

module top_module
(
    input clk,
    input rst_n,
    
    output hsync_sig,
    output vsnyc_sig,
    
    output [4:0] red,
    output [5:0] green,
    output [4:0] blue
);

    wire clk_40;
    wire clk_80;
    
    wire red_sig;
    wire green_sig;
    wire blue_sig;
    
    pll_ip u1
    (
        .CLK_IN1(clk),
        .CLK_OUT1(clk_40),
        .CLK_OUT2(clk_80),
        .RESET(~rst_n)
    );
    
    
    env_vga_module u2
    (
        .clk_sync(clk_40),
        // .clk_control(clk_40),
        .clk_control(clk_80),
        .rst_n(rst_n),
        .hsync_sig(hsync_sig),
        .vsnyc_sig(vsnyc_sig),
        .red_sig(red_sig),
        .green_sig(green_sig),
        .blue_sig(blue_sig),
        .isReady(),
        .x(),
        .y()
    );
    
    assign red = {5{red_sig}};
    assign green = {6{green_sig}};
    assign blue = {5{blue_sig}};
    

endmodule

