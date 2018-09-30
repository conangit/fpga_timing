module fifo_module_2(
    clk,
    rst_n,
    write_req,
    FIFO_write_data,
    read_req,
    FIFO_read_data,
    left_sig
    );
    
    input clk;
    input rst_n;
    
    input write_req;
    input [7:0]FIFO_write_data;
    
    input read_req;
    output [7:0]FIFO_read_data;
    
    // output full_sig;
    // output empty_sig;
    output [2:0]left_sig;
    
    /**************************/
    
    parameter DEEP = 3'd4;
    
    reg [7:0]shift[DEEP:0];
    reg [2:0]count; //计入数据存入的个数
    reg [7:0]data;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift[0] <= 8'd0;
            shift[1] <= 8'd0;
            shift[2] <= 8'd0;
            shift[3] <= 8'd0;
            shift[4] <= 8'd0;
            count <= 3'd0;
            data <= 8'd0;
        end
        else if (read_req && write_req && count < DEEP && count > 0) begin //同时读写 -- 优先级最高
            shift[1] <= FIFO_write_data;
            shift[2] <= shift[1];
            shift[3] <= shift[2];
            shift[4] <= shift[3];
            data <= shift[count];
        end
        else if (write_req && count < DEEP) begin //写入
            shift[1] <= FIFO_write_data;
            shift[2] <= shift[1];
            shift[3] <= shift[2];
            shift[4] <= shift[3];
            
            count <= count + 1'b1;
        end
        else if (read_req && count > 0) begin //读取
            data <= shift[count];
            count <= count - 1'b1;
        end
    end
    
    assign FIFO_read_data = data;
    assign left_sig = DEEP - count;
    // assign full_sig = (count == DEEP) ? 1'b1 : 1'b0;
    // assign empty_sig = (count == 0) ? 1'b1 : 1'b0;
    
endmodule

