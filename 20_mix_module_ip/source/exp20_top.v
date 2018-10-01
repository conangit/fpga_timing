module exp20_top(
    input clk,
    input rst_n,
    
    input write_req,
    input [15:0]fifo_write_data,
    output full_out,

    output done_sig,
    output [15:0]product
    );
    
    
    wire [15:0]u1_product;
    wire u1_done_sig;
    
    wire u2_full;
    
    divider_interface i1(
        .clk(clk),
        .rst_n(rst_n),
        .write_req(write_req),
        .fifo_write_data(fifo_write_data),
        .full_out(full_out),
        .product(u1_product),
        .full_in(u2_full),
        .done_sig(u1_done_sig)
    );
    
    
    multiplier_interface i2(
        .clk(clk),
        .rst_n(rst_n),
        .write_req(u1_done_sig),        //由divider_interface的done_sig驱动
        .fifo_write_data(u1_product),   //来源于divider计算的结果
        .full_out(u2_full),             //对外提供给divider_interface
        .done_sig(done_sig),            //提示计算结果可取
        .product(product)
    );
    
endmodule

