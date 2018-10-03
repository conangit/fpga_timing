`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:47:50 08/02/2018 
// Design Name: 
// Module Name:    tx_module 
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
module tx_module(
    CLK,
    RST_n,
    Tx_En_Sig,
    Tx_Data,
    Tx_Done_Sig,
    Tx_Pin_Out
    );
    
    input CLK;
    input RST_n;
    
    input Tx_En_Sig;
    input [7:0]Tx_Data;
    
    output Tx_Done_Sig;
    output Tx_Pin_Out;
    
    wire BPS_CLK;

    tx_bps_module U1(
        .CLK(CLK),
        .RST_n(RST_n),
        .Count_Sig(Tx_En_Sig),
        .BPS_CLK(BPS_CLK)
    );
    
    tx_control_module U2(
        .CLK(CLK),
        .RST_n(RST_n),
        .Tx_En_Sig(Tx_En_Sig),
        .Tx_Data(Tx_Data),
        .BPS_CLK(BPS_CLK),
        .Tx_Done_Sig(Tx_Done_Sig),
        .Tx_Pin_Out(Tx_Pin_Out)
    );

endmodule
