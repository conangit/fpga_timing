module fifo_module(
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
    
    output [4:0]left_sig;
    
    /*********************************************/
    
    parameter FIFO_DEEP = 5'd16;
    
    reg [15:0]shift [FIFO_DEEP:0]; //17个
    
    reg [4:0]count;
    reg [15:0]data_out;
    
    /*********************************************/
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift[0]  <= 16'd0;
            shift[1]  <= 16'd0; shift[2]  <= 16'd0; shift[3] <= 16'd0;  shift[4] <= 16'd0;
            shift[5]  <= 16'd0; shift[6]  <= 16'd0; shift[7] <= 16'd0;  shift[8] <= 16'd0;
            shift[9]  <= 16'd0; shift[10] <= 16'd0; shift[11] <= 16'd0; shift[12] <= 16'd0;
            shift[13] <= 16'd0; shift[14] <= 16'd0; shift[15] <= 16'd0; shift[16] <= 16'd0;
            count <= 5'd0;
            data_out <= 16'd0;
        end
        else if (write_req && read_req && count < FIFO_DEEP && count > 0) begin //读写同时发生
            shift[1]  <= fifo_write_data;
            shift[2]  <= shift[1];
            shift[3]  <= shift[2];
            shift[4]  <= shift[3];
            shift[5]  <= shift[4];
            shift[6]  <= shift[5];
            shift[7]  <= shift[6];
            shift[8]  <= shift[7];
            shift[9]  <= shift[8];
            shift[10] <= shift[9];
            shift[11] <= shift[10];
            shift[12] <= shift[11];
            shift[13] <= shift[12];
            shift[14] <= shift[13];
            shift[15] <= shift[14];
            shift[16] <= shift[15];
            
            data_out <= shift[count];
        end
        else if (write_req && count < FIFO_DEEP) begin //写
            shift[1]  <= fifo_write_data;
            shift[2]  <= shift[1];
            shift[3]  <= shift[2];
            shift[4]  <= shift[3];
            shift[5]  <= shift[4];
            shift[6]  <= shift[5];
            shift[7]  <= shift[6];
            shift[8]  <= shift[7];
            shift[9]  <= shift[8];
            shift[10] <= shift[9];
            shift[11] <= shift[10];
            shift[12] <= shift[11];
            shift[13] <= shift[12];
            shift[14] <= shift[13];
            shift[15] <= shift[14];
            shift[16] <= shift[15];
            
            count <= count + 1'b1;
        end
        else if (read_req && count > 0) begin //读
            data_out <= shift[count];
            count <= count - 1'b1;
        end
    end
    
    assign fifo_read_data = data_out;
    assign left_sig = FIFO_DEEP - count;
    
    
endmodule

