module fifo_module_2(
    clk,
    rst_n,
    write_req,
    fifo_write_data,
    read_req,
    fifo_read_data,
    left_sig
    );
    
    input clk;
    input rst_n;
    
    input write_req;
    input [15:0]fifo_write_data;
    
    input read_req;
    output [15:0]fifo_read_data;
    
    output [2:0]left_sig;
    
    /**************************************/
    
    parameter FIFO_DEEP = 3'd4;
    reg [15:0] shift [FIFO_DEEP:0];
    
    reg [2:0]count;
    reg [15:0]data;
       
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift[0] <= 16'd0;
            shift[1] <= 16'd0;
            shift[2] <= 16'd0;
            shift[3] <= 16'd0;
            shift[4] <= 16'd0;
            count <= 3'd0;
            data <= 16'd0;
        end
        else if(read_req && write_req && count < FIFO_DEEP && count > 0) begin
            shift[1] <= fifo_write_data;
            shift[2] <= shift[1];
            shift[3] <= shift[2];
            shift[4] <= shift[3];
            data <= shift[count];
        end
        else if(write_req && count < FIFO_DEEP) begin
            shift[1] <= fifo_write_data;
            shift[2] <= shift[1];
            shift[3] <= shift[2];
            shift[4] <= shift[3];
            
            count <= count + 1'b1;
        end
        else if(read_req && count > 0) begin
            data <= shift[count];
            count <= count - 1'b1;
        end
    end
    
    assign fifo_read_data = data;
    assign left_sig = FIFO_DEEP - count;
    
endmodule

