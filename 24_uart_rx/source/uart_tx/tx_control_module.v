`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:27:20 08/02/2018 
// Design Name: 
// Module Name:    tx_control_module 
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
module tx_control_module(
    CLK,
    RST_n,
    Tx_En_Sig,
    Tx_Data,
    BPS_CLK,
    Tx_Done_Sig,
    Tx_Pin_Out
    );
    
    input CLK;
    input RST_n;
    
    input Tx_En_Sig;
    input [7:0]Tx_Data;
    input BPS_CLK;
    
    output Tx_Done_Sig;
    output Tx_Pin_Out;
    
    reg [3:0]i;
    reg rTx;
    reg isDone;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            i <= 4'd0;
            rTx <= 1'b1;        // rx线默认高电平
            isDone <= 1'b0;
        end
        else if (Tx_En_Sig)
            case (i)

                4'd0:
                begin
                    if (BPS_CLK) begin
                        i <= i + 1'b1;
                        rTx <= 1'b0; // 开始信号
                    end
                end
                
                4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8: // 发送数据
                begin
                    if (BPS_CLK) begin
                        i <= i + 1'b1;
                        rTx <= Tx_Data[i-1]; //LSB
                    end
                end

                4'd9: // 停止位
                begin
                    if (BPS_CLK) begin
                        i <= i + 1'b1;
                        rTx <= 1'b1;
                    end
                end
                
                4'd10:
                begin
                    i <= i + 1'b1;
                    isDone <= 1'b1;
                end

                4'd11:
                begin
                    i <= 4'd0;
                    isDone <= 1'b0;
                end
            endcase
    end

    assign Tx_Done_Sig = isDone;
    assign Tx_Pin_Out = rTx;

endmodule
