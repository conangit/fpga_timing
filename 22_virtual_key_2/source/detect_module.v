`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:25:18 06/20/2018 
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
    Pin_In,
    H2L_Sig,
    L2H_Sig
    );

    input CLK;
    input RST_n;
    input Pin_In;
    output H2L_Sig;
    output L2H_Sig;
    
    parameter T100US = 13'd4_999;
    
    reg [12:0] counter;
    reg isEn;
    
    //电平检测是敏感模块 在复位瞬间 电平易处于不稳定状态 故延时100us
    //counter将"永远"停留在T100US(不存在溢出问题) isEN恒为1
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            counter <= 13'd0;
            isEn <= 1'b0;
        end
        else if (counter == T100US) begin
            isEn <= 1'b1;
        end
        else begin
            counter <= counter + 1'b1;
        end
    end
    
    reg H2L_F1;
    reg H2L_F2;
    reg L2H_F1;
    reg L2H_F2;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            H2L_F1 <= 1'b1;
            H2L_F2 <= 1'b1;
            L2H_F1 <= 1'b0;
            L2H_F2 <= 1'b0;
        end
        else begin
            H2L_F1 <= Pin_In;
            H2L_F2 <= H2L_F1;
            L2H_F1 <= Pin_In;
            L2H_F2 <= L2H_F1;
        end
    end
    
    //H2L_F1记录当前电平 H2L_F2记录前一时刻电平
    //当前为0 前一时间为1 -- 检测到H2L
    assign H2L_Sig = isEn ? (H2L_F2 & !H2L_F1) : 1'b0;
    
    //L2H_F1记录当前电平 L2H_F2记录前一时刻电平
    //当前为1 前一时间为0 -- 检测到L2H
    assign L2H_Sig = isEn ? (!L2H_F2 & L2H_F1) : 1'b0;


endmodule
