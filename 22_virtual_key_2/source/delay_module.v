`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:25:38 06/20/2018 
// Design Name: 
// Module Name:    delay_module 
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
module delay_module(
    CLK,
    RST_n,
    H2L_Sig,
    L2H_Sig,
    Pin_Out
    );
    
    input CLK;
    input RST_n;
    input H2L_Sig;
    input L2H_Sig;
    output reg Pin_Out;
    
    parameter T1MS = 15'd20000;

    //在isCounter使能信号作用下的循环1ms计时
    reg [15:0] counter;
    //20ms延时
    reg [4:0] count_MS;
    reg isCounter;

    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            counter <= 16'd0;
        end
        else if (isCounter && counter == T1MS) begin
            counter <= 16'd0;
        end
        else if (isCounter) begin
            counter <= counter + 1'b1;
        end
        else if (!isCounter) begin
            counter <= 16'd0;
        end
    end
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            count_MS <= 5'd0;
        end
        else if (isCounter && counter == T1MS) begin
            count_MS <= count_MS + 1'b1;
        end
        else if (!isCounter) begin
            count_MS <= 5'd0;
        end
    end
    
    
    
    reg [1:0] i;
    
    //仿顺序操作
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            isCounter <= 1'b0;
            Pin_Out <= 1'b1;
            i <= 2'd0;
        end
        else
            
            case (i)
                
                2'd0:
                begin
                    if (H2L_Sig) i <= 2'd1;
                    else if(L2H_Sig) i <= 2'd2;
                end

                2'd1:   //检测到按键按下
                begin
                    if (count_MS == 5'd10) begin
                        isCounter <= 1'b0;
                        Pin_Out <= 1'b0;
                        i <= 2'd0;
                    end
                    else begin
                        isCounter <= 1'b1;
                    end
                end
               
                2'd2:   //检测到按键弹起
                begin
                    if (count_MS == 5'd10) begin
                        isCounter <= 1'b0;
                        Pin_Out <= 1'b1;
                        i <= 2'd0;
                    end
                    else begin
                        isCounter <= 1'b1;
                    end
                end
                
            endcase
    end

endmodule
