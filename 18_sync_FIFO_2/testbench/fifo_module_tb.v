`timescale 1ns/1ps

module fifo_module_tb;

    reg clk;
    reg rst_n;
    
    reg write_req;
    reg [7:0]FIFO_write_data;
    
    reg read_req;
    wire [7:0]FIFO_read_data;
    
    // wire full_sig;
    // wire empty_sig;
    wire [2:0]left_sig;
    
    /*************************************/
    
    initial begin
        clk = 0;
        rst_n = 0;
        
        #250;
        rst_n = 1;
        
        forever #25 clk = ~clk;
    end

    fifo_module_2 u1(
        .clk(clk),
        .rst_n(rst_n),
        .write_req(write_req),
        .FIFO_write_data(FIFO_write_data),
        .read_req(read_req),
        .FIFO_read_data(FIFO_read_data),
        .left_sig(left_sig)
    );
    
    reg [4:0]i;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
            write_req <= 1'b0;
            read_req <= 1'b0;
            FIFO_write_data <= 8'd0;
        end
        else
        
            case(i)
                
                0:
                begin
                    i <= 5'd1;
                    write_req <= 1'b1;
                    read_req <= 1'b0;
                    FIFO_write_data <= 8'd1;
                end
                
                1:
                begin
                    i <= 5'd2;
                    write_req <= 1'b1;
                    read_req <= 1'b0;
                    FIFO_write_data <= 8'd2;
                end
                
                2:
                begin
                    i <= 5'd3;
                    write_req <= 1'b1;
                    read_req <= 1'b0;
                    FIFO_write_data <= 8'd3;
                end
                
                3:
                begin
                    i <= 5'd4;
                    write_req <= 1'b1;
                    read_req <= 1'b0;
                    FIFO_write_data <= 8'd4;
                end
                
                //
                // 不使用控制信号 对FIFO写入8'd1 8'd2 8'd3 8'd4
                //
                
                4:
                begin
                    i <= 5'd5;
                    write_req <= 1'b0; //FIFO已写满
                    read_req <= 1'b1;
                end
                
                5:
                begin
                    i <= 5'd6;
                    write_req <= 1'b0;
                    read_req <= 1'b1;
                end
                
                6:
                begin
                    i <= 5'd7;
                    write_req <= 1'b0;
                    read_req <= 1'b1;
                end
                
                7:
                begin
                    i <= 5'd8;
                    write_req <= 1'b0;
                    read_req <= 1'b1;
                end
                
                //
                // 不使用控制信号 对FIFO连续读取
                //
                
                8:
                if(left_sig <= 1) begin //将要写满了
                    write_req <= 1'b0;
                    i <= i + 1'b1;
                end
                else begin
                    write_req <= 1'b1;
                    read_req <= 1'b0;
                    FIFO_write_data <= FIFO_write_data + 1'b1;
                end
                
                //
                // 使用控制信号对FIFO写入数据 直到达到if条件
                //
             
                9:
                if(left_sig >= 3) begin //将要读空了 
                    read_req <= 1'b0;
                    i <= i + 1'b1;
                end
                else begin
                    write_req <= 1'b0;
                    read_req <= 1'b1;
                end
                
                //
                // 使用控制信号对FIFO连续读取数据 直到达到if条件
                //
                
                10:
                if(left_sig >= 1) begin //A还可写
                    write_req <= 1'b1;
                    FIFO_write_data <= 8'd5;
                    i <= i + 1'b1;
                end
                else begin
                    write_req <= 1'b0;
                    i <= i + 1'b1;
                end
                
                11:
                if(left_sig >= 1) begin //A继续写
                    write_req <= 1'b1;
                    FIFO_write_data <= 8'd6;
                    i <= i + 1'b1;
                end
                else begin
                    write_req <= 1'b0;
                    i <= i + 1'b1;
                end
                
                12:
                begin
                
                    if(left_sig >= 1) begin //A继续写
                        write_req <= 1'b1;
                        FIFO_write_data <= 8'd7;
                    end
                    else
                        write_req <= 1'b0;
                        
                    if(left_sig <= 3) //B可读了
                        read_req <= 1'b1;
                    else
                        read_req <= 1'b0;
                    
                    i <= i + 1'b1;
                
                end
                
                13:
                begin
                
                    if(left_sig >= 1) begin //A继续写
                        write_req <= 1'b1;
                        FIFO_write_data <= 8'd8;
                    end
                    else
                        write_req <= 1'b0;
                        
                    if(left_sig <= 3) //B继续可读
                        read_req <= 1'b1;
                    else
                        read_req <= 1'b0;
                    
                    i <= i + 1'b1;
                
                end
                
                14:
                if(left_sig <= 3) begin //B差点要读空
                    write_req <= 1'b0;
                    read_req <= 1'b1;
                    i <= i + 1'b1;
                end
                else begin
                    read_req <= 1'b0;
                    i <= i + 1'b1;
                end

                15:
                if(left_sig <= 3) begin //B差点要读空
                    read_req <= 1'b1;
                    i <= i + 1'b1;
                end
                else begin
                    read_req <= 1'b0;
                    i <= i + 1'b1;
                end
                
                //
                // A B同时对FIFO操作
                // 10~13 A方一直在写
                // 12~15 B方一直在读
                
                16:
                begin
                    read_req <= 1'b0;
                    i <= 5'd16;
                end
                
            endcase
    end
    
endmodule

