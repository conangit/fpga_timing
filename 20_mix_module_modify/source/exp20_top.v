module exp20_top(
    input clk,
    input rst_n,
    
    input write_req,
    input [15:0]fifo_write_data,
    output [4:0]a_left_sig,

    output done_sig,
    output [15:0]product
    );
    
    
    wire [15:0]u1_product;
    wire u1_done_sig;
    
    wire [4:0]u2_left_sig;
    
    
    divider_interface i1(
        .clk(clk),
        .rst_n(rst_n),
        .write_req(write_req),
        .fifo_write_data(fifo_write_data),
        .a_left_sig(a_left_sig),
        .product(u1_product),
        .b_left_sig(u2_left_sig),
        .done_sig(u1_done_sig)
    );
    
    
    multiplier_interface i2(
        .clk(clk),
        .rst_n(rst_n),
        .write_req(u1_done_sig),        //由divider_interface的done_sig驱动
        .fifo_write_data(u1_product),   //来源于divider计算的结果
        .left_sig(u2_left_sig),         //对外提供给divider_interface
        .done_sig(done_sig),            //提示计算结果可取
        .product(product)
    );
    
endmodule

