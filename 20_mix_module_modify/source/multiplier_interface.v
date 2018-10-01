module multiplier_interface(
    input clk,
    input rst_n,
    
    input write_req,
    input [15:0]fifo_write_data,
    output [4:0]left_sig,
    
    output done_sig,                //增加一个dong_sig用来指示输出结果何时可取
    output [15:0]product
    );

    reg isRead;
    wire [15:0]u1_read_data;
    
    fifo_module u1(
        .clk(clk),
        .rst_n(rst_n),
        .write_req(write_req),
        .fifo_write_data(fifo_write_data),
        .read_req(isRead),
        .fifo_read_data(u1_read_data),
        .left_sig(left_sig)
    );
    
    reg isStart;
    wire u2_done_sig;
    
    multiplier_module u2(
        .clk(clk),
        .rst_n(rst_n),
        .start_sig(isStart),
        .multiplicand(u1_read_data[15:8]),
        .multiplier(u1_read_data[7:0]),
        .done_sig(u2_done_sig),
        .product(product)
    );
    
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
            if(left_sig <= 15) begin
                isRead <= 1'b1;
                i <= 2'd1;
            end
            else
                isRead <= 1'b0;
                
            1:
            if(u2_done_sig) begin
                isStart <= 1'b0;
                isDone <= 1'b1;
                i <= 2'd2;
            end
            else begin
                isRead <= 1'b0;
                isStart <= 1'b1;
            end
            
            2:
            begin
                i <= 2'd0;
                isDone <= 1'b0;
            end

            endcase
    end
    
    assign done_sig = isDone;

endmodule

