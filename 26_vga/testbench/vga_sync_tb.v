`timescale 1ps/1ps

//若延时单位为1ns 则40MHz为 #12.5 clk = ~clk;
//存在小数

module vga_sync_tb;

    reg clk;
    reg rst_n;
    
    wire hsync_sig;
    wire vsnyc_sig;
    wire ready;
    wire [10:0] column_addr_sig;
    wire [10:0] row_addr_sig;
    
    /*
    vga_sync_before u1
    (
        .clk(clk),
        .rst_n(rst_n),
        .hsync_sig(hsync_sig),
        .vsnyc_sig(vsnyc_sig),
        .ready(ready),
        .column_addr_sig(column_addr_sig),
        .row_addr_sig(row_addr_sig)
    );
    */
    
    /*
    vga_sync_middle u2
    (
        .clk(clk),
        .rst_n(rst_n),
        .hsync_sig(hsync_sig),
        .vsnyc_sig(vsnyc_sig),
        .ready(ready),
        .column_addr_sig(column_addr_sig),
        .row_addr_sig(row_addr_sig)
    );
    */
    
    
    vga_sync_last u3
    (
        .clk(clk),
        .rst_n(rst_n),
        .hsync_sig(hsync_sig),
        .vsnyc_sig(vsnyc_sig),
        .ready(ready),
        .column_addr_sig(column_addr_sig),
        .row_addr_sig(row_addr_sig)
    );
    
    
    initial
    begin
        rst_n = 0;
        #12500;         //12.5ns使得rst_n与clk同步
        rst_n = 1;
    end
    
    initial
    begin
        clk = 0;
        forever #12500 clk = ~clk; //40MHz
    end
    
    //所有列像素跑完16579.2us + 10us
    // always
    // begin
        // # 64d16_589_200_000;
        // $stop;
    // end
    
endmodule

