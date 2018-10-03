`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:47:33 08/01/2018 
// Design Name: 
// Module Name:    detect_module 
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
module detect_module(
    CLK,
    RST_n,
    Rx_Pin_In,
    H2L_Sig
    );
    
    input CLK;
    input RST_n;
    input Rx_Pin_In;
    output H2L_Sig;
    
    reg H2L_F1;
    reg H2L_F2;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            H2L_F1 <= 1'b1;
            H2L_F2 <= 1'b1;
        end
        else begin
            H2L_F1 <= Rx_Pin_In;
            H2L_F2 <= H2L_F1;
        end
    end
    
    // 当前电平(H2L_F1)为低 前一时刻电平(H2L_F2)为高
    // 检测到一个开始位 输出一个高脉冲
    assign H2L_Sig = H2L_F2 & !H2L_F1;

endmodule
