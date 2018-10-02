`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:50:09 06/22/2018 
// Design Name: 
// Module Name:    debounce_module 
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
module debounce_module(
    input CLK,
    input RST_n,
    input Pin_In,
    output Pin_Out
    );

    wire w_h2l;
    wire w_l2h;
    
    detect_module D1(.CLK(CLK), .RST_n(RST_n), .Pin_In(Pin_In), .H2L_Sig(w_h2l), .L2H_Sig(w_l2h));
    delay_module T1(.CLK(CLK), .RST_n(RST_n), .H2L_Sig(w_h2l), .L2H_Sig(w_l2h), .Pin_Out(Pin_Out));

endmodule
