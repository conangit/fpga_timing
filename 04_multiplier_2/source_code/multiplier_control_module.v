`timescale 1ns / 1ns

module multiplier_control_module(
    clk,
    done_sig,
    rst_n,
    start_sig,
    multiplicand,
    multiplier
    );
    
    input clk;
    input done_sig;
    
    output reg rst_n;
    output reg start_sig;
    output reg [7:0]multiplicand;
    output reg [7:0]multiplier;

    
    reg [7:0] cnt;
    
    always @(posedge clk) begin
        cnt <= cnt + 1'b0;
    end
    
    
    // rst_n复位信号描述
    always @(posedge clk) begin
        if (cnt == 8'd0)
            rst_n <= 1'b0;
        if (cnt == 8'd250)
            rst_n <= 1'b1;
    end
    
    
    //不同的被乘数和乘数来刺激multiplier_module
    reg [2:0]i;
    
    always @(posedge clk) begin
        if (!rst_n) begin
            i <= 3'd0;
            start_sig <= 1'b0;
            multiplicand <= 8'd0;
            multiplier <= 8'd0;
        end
        else
            case (i)
                
                0: // 10 * 2
                if (done_sig) begin
                    i <= i + 1'b1;
                    start_sig <= 1'b0;
                end
                else begin
                    start_sig <= 1'b1;
                    multiplicand <= 8'd10;
                    multiplier <= 8'd2;
                end

                1: // 2 * 10
                if (done_sig) begin
                    i <= i + 1'b1;
                    start_sig <= 1'b0;
                end
                else begin
                    start_sig <= 1'b1;
                    multiplicand <= 8'd2;
                    multiplier <= 8'd10;
                end
                
                2: // 11 * -5
                if (done_sig) begin
                    i <= i + 1'b1;
                    start_sig <= 1'b0;
                end
                else begin
                    start_sig <= 1'b1;
                    multiplicand <= 8'd11;
                    multiplier <= 8'b1111_1011;
                end
                
                3: // -5 * -11
                if (done_sig) begin
                    i <= i + 1'b1;
                    start_sig <= 1'b0;
                end
                else begin
                    start_sig <= 1'b1;
                    multiplicand <= 8'b1111_1011;
                    multiplier <= 8'b1111_0101;
                end
                
                4: // -5 * -11
                    i <= 3'd4;
                
            endcase
    end
    
    //仿真用到�    // GSR GSR_INST(.GSR(1'b1));
    // PUR PUR_INST(.PUR(1'b1));
    
endmodule

