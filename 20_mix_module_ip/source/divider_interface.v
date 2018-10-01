module divider_interface(
    input clk,
    input rst_n,
    
    input write_req,
    input [15:0]fifo_write_data,
    output full_out,
    
    output [15:0]product,
    
    input full_in,              //意义:除法接口的计算结果需要输入到乘法接口(FIFO)
    output done_sig             //故 输入之前 需要借助乘法接口FIFO的left信号来判断是否可写入 以及在合适的时间产生写入使能
    );
    
    
    reg isRead;
    wire [15:0]u1_read_data;
    wire [4:0]u1_left_sig;
    
    /*
    fifo_module u1(
        .clk(clk),
        .rst_n(rst_n),
        .write_req(write_req),
        .fifo_write_data(fifo_write_data),
        .read_req(isRead),
        .fifo_read_data(u1_read_data),
        .left_sig(u1_left_sig)
    );
    */
    
    wire u1_empty;
    
    fifo_ip u1(
        .clk(clk),
        .rst(!rst_n),
        .din(fifo_write_data),
        .wr_en(write_req),
        .rd_en(isRead),
        .dout(u1_read_data),
        .full(full_out),
        .empty(u1_empty)
    );
    
    reg isStart;
    wire u2_done_sig; //用于沟通除法器模块
    wire [7:0]u2_q;
    wire [7:0]u2_r;
    
    divider_module u2(
        .clk(clk),
        .rst_n(rst_n),
        .start_sig(isStart),
        .dividend(u1_read_data[15:8]),
        .divisor(u1_read_data[7:0]),
        .done_sig(u2_done_sig),
        .quotient(u2_q),
        .reminder(u2_r)
    );
    
    assign product = {u2_q, u2_r}; //此处也可以改为 直接写到例化
    
    reg [1:0]i;
    reg isDone;
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            i <= 2'd0;
            isRead <= 1'b0;
            isStart <= 1'b0;
            isDone <= 1'b0;
        end
        else
            
            case(i)
                
                0:
                if (!u1_empty) begin //FIFO不为空 决定从FIFO取数据
                    isRead <= 1'b1;
                    i <= i + 1'b1;
                end
                else
                    isRead <= 1'b0;
                    
                1:
                if(u2_done_sig) begin
                    isStart <= 1'b0;
                    i <= i + 1'b1;
                end
                else begin
                    isStart <= 1'b1; //处理取得的数据
                    isRead <= 1'b0;
                end
                
                2: //一次FIFO数据处理完毕 将结果写入到乘法接口的FIFO(条件1:数据准备好了 条件2:FIFO可写入 条件3:有写入使能)
                if(!full_in) begin
                    isDone <= 1'b1; //这里巧妙的借助done信号 来驱动乘法接口的FIFO写入使能
                    i <= i + 1'b1;
                end
                else
                    isDone <= 1'b0;
                    
                3:
                begin
                    isDone <= 1'b0;
                    i <= 2'd0;
                end

            endcase
    end
    
    assign done_sig = isDone;

endmodule

