

module top_module(
    input clk,
    output [15:0]product
    );
    
    wire rst_n;
    wire start_sig;
    wire [7:0]multiplicand;
    wire [7:0]multiplier;
    wire done_sig;
    
    multiplier_control_module u1(
        .clk(clk), //input
        .done_sig(done_sig), //input
        .rst_n(rst_n), //output
        .start_sig(start_sig), //output
        .multiplicand(multiplicand), //output
        .multiplier(multiplier) //output
    );
    
    
    multiplier_module u2(
        .clk(clk),
        .rst_n(rst_n),
        .start_sig(start_sig),
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .done_sig(done_sig),
        .product(product)
    );
    
endmodule

