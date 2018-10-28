`timescale 1ps/1ps

//若延时单位为1ns 则40MHz为 #12.5 clk = ~clk;
//存在小数

module vga_sync_tb;

    reg clk_40MHz;
    reg clk_80MHz;
    
    reg rst_n;
    
    wire hsync_sig;
    wire vsnyc_sig;
    wire ready;
    wire [10:0] x;
    wire [10:0] y;
    wire red_sig;
    wire green_sig;
    wire blue_sig;
    
    env_vga_module u1
    (
        .clk_sync(clk_40MHz),
        .clk_control(clk_40MHz),
        // .clk_control(clk_80MHz),
        .rst_n(rst_n),
        .hsync_sig(hsync_sig),
        .vsnyc_sig(vsnyc_sig),
        .isReady(ready),
        .red_sig(red_sig),
        .green_sig(green_sig),
        .blue_sig(blue_sig),
        .x(x),
        .y(y)
    );
    
    
    initial
    begin
        rst_n = 0;
        #12500;         //12.5ns使得rst_n与clk同步
        rst_n = 1;
    end
    
    initial
    begin
        clk_40MHz = 0;
        forever #12500 clk_40MHz = ~clk_40MHz; //40MHz
    end
    
    initial
    begin
        clk_80MHz = 1; //时钟相位对齐
        forever #6250 clk_80MHz = ~clk_80MHz; //80MHz
    end
    
    
endmodule

