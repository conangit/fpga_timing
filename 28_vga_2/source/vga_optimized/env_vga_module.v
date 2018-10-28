

module env_vga_module
(
    input clk_sync,
    input clk_control,
    input rst_n,
    
    output hsync_sig,
    output vsnyc_sig,
    
    output red_sig,
    output green_sig,
    output blue_sig,
    
    //debug
    output isReady,
    output [10:0] x,
    output [10:0] y
);
    
    wire ready;
    wire [10:0] x_addr;
    wire [10:0] y_addr;

    
    vga_sync_last_2 u1
    (
        .clk(clk_sync),
        .rst_n(rst_n),
        .hsync_sig(hsync_sig),
        .vsnyc_sig(vsnyc_sig),
        .ready(ready),
        .column_addr_sig(x_addr),
        .row_addr_sig(y_addr)
    );
    
    
    vga_control_before u2
    (
        .clk(clk_control),
        .rst_n(rst_n),
        .ready(ready),
        .x_addr(x_addr),
        .y_addr(y_addr),
        .red_sig(red_sig),
        .green_sig(green_sig),
        .blue_sig(blue_sig)
    );
    
    
    
    assign isReady = ready;
    assign x = x_addr;
    assign y = y_addr;
    
endmodule


