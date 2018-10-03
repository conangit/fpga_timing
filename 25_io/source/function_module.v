

module function_module(
    CLK,
    RSTn,
    func_start_sig,
    words_addr,
    write_data,
    read_data,
    func_done_sig,
    rtc_rst,
    rtc_sclk,
    rtc_sio,
    sq_i
);

    input   CLK;
    input   RSTn;
    
    input   [1:0]func_start_sig;
    input   [7:0]words_addr;
    input   [7:0]write_data;
    
    output  [7:0]read_data;
    output  func_done_sig;
    
    output  rtc_rst;
    output  rtc_sclk;
    inout   rtc_sio;
    
    output [5:0]sq_i;
    
    /***********************************/
    
    //50MHz 0.5us
    parameter T0P5US = 5'd24;
    
    reg [4:0]count;
    
    /* 在start_sig使能下，计时0.5us */
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn)
            count <= 5'd0;
        else if (count == T0P5US)
            count <= 5'd0;
        else if ((func_start_sig[1] == 1'b1) || (func_start_sig[0] == 1'b1))
            count <= count + 1'b1;
        else
            count <= 5'd0;
    end
    
    reg [5:0]i;
    reg [7:0]rData;
    reg rRST;
    reg rSCLK;
    reg rSIO;
    reg isDone;
    reg isOut; //控制rtc_sio
    
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn) begin
            i <= 6'd0;
            rData <= 8'h0;
            rRST <= 1'b0;
            rSCLK <= 1'b0;
            rSIO <= 1'b0;
            isOut <= 1'b0;
            isDone <= 1'b0;
        end
        else if (func_start_sig[1]) begin // 写操作
            case(i)
                
                0: //初始化
                    begin
                        rSCLK <= 1'b0;
                        rData <= words_addr;
                        rRST <= 1'b1;
                        isOut <= 1'b1; // 写操作 rtc_sio整个过程为output态
                        i <= i + 1'b1;
                    end
                    
                1,3,5,7,9,11,13,15: // 设置数据
                    if (count == T0P5US)
                        i <= i + 1'b1;
                    else begin
                        rSIO <= rData[(i>>1)]; //1-0 3-1 5-2 ... 15-7 : (i-1)/2 = i>>1 - 1>>1 = i>>1
                        rSCLK <= 1'b0;
                    end
                    
                2,4,6,8,10,12,14,16: // 锁存数据
                    if (count == T0P5US)
                        i <= i + 1'b1;
                    else
                        rSCLK <= 1'b1; // 芯片(DS1302)在上升沿写入数据
                        
                17: //第二个字节初始化
                    begin
                        rData <= write_data;
                        i <= i + 1'b1;
                    end
                    
                18,20,22,24,26,28,30,32: // 设置数据
                    if (count == T0P5US)
                        i <= i + 1'b1;
                    else begin
                        rSIO <= rData[(i>>1) - 9]; // 18-0 20-1 22-2 ... 32-7 : (i-17-1)/2 = (i-18)/2 = i>>1 - 9 LSB
                        rSCLK <= 1'b0;
                    end
                    
                19,21,23,25,27,29,31,33: // 锁存数据
                    if (count == T0P5US)
                        i <= i + 1'b1;
                    else
                        rSCLK <= 1'b1;
                        
                34:
                    begin
                        rRST <= 1'b0;
                        i <= i + 1'b1;
                    end
                    
                35:
                    begin
                        isDone <= 1'b1;
                        i <= i + 1'b1;
                    end
                    
                36:
                    begin
                        isDone <= 1'b0;
                        i <= 6'd0;
                    end
                    
            endcase
        end
        else if (func_start_sig[0]) begin // 读操作
            case(i)
            
                0:
                    begin
                        rSCLK <= 1'b0;
                        rData <= words_addr;
                        rRST <= 1'b1;
                        isOut <= 1'b1; //读操作rtc_sio第一个字节为output,第二个字节为input
                        i <= i + 1'b1;
                    end
                    
                1,3,5,7,9,11,13,15:
                    if (count == T0P5US)
                        i <= i + 1'b1;
                    else begin
                        rSIO <= rData[(i>>1)];
                        rSCLK <= 1'b0;
                    end
                    
                2,4,6,8,10,12,14,16:
                    if (count == T0P5US)
                        i <= i + 1'b1;
                    else
                        rSCLK <= 1'b1;
                        
                17:
                    begin
                        isOut <= 1'b0; // 之后rtc_sio为input
                        i <= i + 1'b1;
                    end
                    
                18,20,22,24,26,28,30,32:
                    if (count == T0P5US)
                        i <= i + 1'b1;
                    else
                        rSCLK <= 1'b1;
                    
                19,21,23,25,27,29,31,33:
                    if (count == T0P5US)
                        i <= i + 1'b1;
                    else begin
                        rSCLK <= 1'b0; // 下降沿读取数据 芯片(DS1302在下降沿输出数据)
                        // rData[(i>>1) - 9] <= rSIO; //严重错误呀！！！！
                        rData[(i>>1) - 9] <= rtc_sio;
                    end
                    
                34:
                    begin
                        rRST <= 1'b0;
                        isOut <= 1'b1;
                        i <= i + 1'b1;
                    end
                    
                35:
                    begin
                        isDone <= 1'b1;
                        i <= i + 1'b1;
                    end
                    
                36:
                    begin
                        isDone <= 1'b0;
                        i <= 6'd0;
                    end
                    
            endcase
        end
    end
    

    assign read_data = rData;
    assign func_done_sig = isDone;
    
    assign rtc_rst = rRST;
    assign rtc_sclk = rSCLK;
    assign rtc_sio = isOut ? rSIO : 1'bz;
    
    assign sq_i = i;

endmodule

