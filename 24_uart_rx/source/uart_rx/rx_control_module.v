`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:48:54 08/01/2018 
// Design Name: 
// Module Name:    rx_control_module 
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
module rx_control_module(
    CLK,
    RST_n,
    H2L_Sig,
    Rx_Pin_In,
    BPS_CLK,
    Rx_En_Sig,
    Count_Sig,
    Rx_Done_Sig,
    Rx_Data
    );
    
    input CLK;
    input RST_n;
    
    input H2L_Sig;
    input Rx_Pin_In;
    input BPS_CLK;
    input Rx_En_Sig;
    
    output Count_Sig;
    output Rx_Done_Sig;
    output [7:0]Rx_Data;
    
    reg [3:0]i;
    reg [7:0]rData;
    reg isCount;
    reg isDone;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            i <= 4'd0;
            rData <= 8'd0;
            isCount <= 1'b0;
            isDone <= 1'b0;
        end
        else if (Rx_En_Sig)
            case (i)
                4'd0:   // 检测到开始传输信号
                begin
                    if (H2L_Sig) begin
                        i <= i + 1'b1;
                        isCount <= 1'b1;    // rx_bps模块开始产生波特率定时
                    end
                end
                
                4'd1:   // 开始位
                begin
                    if (BPS_CLK) begin
                        i <= i + 1'b1;
                    end
                end
                
                4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9:     // 数据位
                begin
                    if (BPS_CLK) begin
                        i <= i + 1'b1;
                        rData[i-2] <= Rx_Pin_In; //LSB
                    end
                end

                4'd10:   // 停止位
                begin
                    if (BPS_CLK) begin
                        i <= i + 1'b1;
                    end
                end


                4'd11:   // 一帧数据采集完成
                begin
                    i <= i + 1'b1;
                    isCount <= 1'b0; //bps模块已"停止"
                    isDone <= 1'b1;
                end
                
                4'd12:   // 回到初态
                begin
                    i <= 1'b0;
                    isDone <= 1'b0;
                end
            endcase
    end
    
    assign Count_Sig = isCount;
    assign Rx_Done_Sig = isDone;
    assign Rx_Data = rData;

endmodule
