`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:35:29 08/11/2018 
// Design Name: 
// Module Name:    vga_module 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module vga_module(
    input clk,
    input rst_n,
    output VSYNC_Sig,
    output HSYNC_Sig,
    output [4:0]Red_Sig,
    output [5:0]Green_Sig,
    output [4:0]Blue_Sig
    );
    
    
    wire clk_out;
    wire isReady;
    wire [11:0]x_addr;
    wire [11:0]y_addr;
    
    
    pll_ip pll_ip_inst(
        .CLK_IN1(clk),
        .CLK_OUT1(clk_out),
        .RESET(~rst_n)
    );

    /*
    vga_control_module C1(
        .vga_clk(clk_out),
        .rst_n(rst_n),
        .Ready_Sig(isReady),
        .Column_Addr_Sig(x_addr),
        .Row_Addr_Sig(y_addr),
        .Red_Sig(Red_Sig),
        .Green_Sig(Green_Sig),
        .Blue_Sig(Blue_Sig)
    );
    
    
    vga_sync_module_800_600_60 S1(
        .vga_clk(clk_out),
        .rst_n(rst_n),
        .VSYNC_Sig(VSYNC_Sig),
        .HSYNC_Sig(HSYNC_Sig),
        .Ready_Sig(isReady),
        .Column_Addr_Sig(x_addr),
        .Row_Addr_Sig(y_addr)
    );
    */
    
    
    wire red;
    wire green;
    wire blue;
    
    assign Red_Sig = {5{red}};
    assign Green_Sig = {6{green}};
    assign Blue_Sig = {5{blue}};
    
    vga_control_before u1
    (
        .clk(clk_out),
        .rst_n(rst_n),
        .ready(isReady),
        .x_addr(x_addr),
        .y_addr(y_addr),
        .red_sig(red),
        .green_sig(green),
        .blue_sig(blue)
    );
    
    
    vga_sync_last_2 u2
    (
        .clk(clk_out),
        .rst_n(rst_n),
        .hsync_sig(HSYNC_Sig),
        .vsnyc_sig(VSYNC_Sig),
        .ready(isReady),
        .column_addr_sig(x_addr),
        .row_addr_sig(y_addr)
    );


endmodule
