

`timescale 1ns/1ps

module lut_multiplier_module_tb();

    reg clk;
    reg rst_n;
    reg start_sig;
    reg [7:0]A;
    reg [7:0]B;
    
    wire done_sig;
    wire [15:0]product;
    
    wire [7:0]I1_Sig;
    wire [7:0]I2_Sig;
    wire [15:0]Q1_Sig;
    wire [15:0]Q2_Sig;
    
    lut_multiplier_module u1(
        .clk(clk),
        .rst_n(rst_n),
        .start_sig(start_sig),
        .A(A),
        .B(B),
        .done_sig(done_sig),
        .product(product),
        .I1_Sig(I1_Sig),
        .I2_Sig(I2_Sig),
        .Q1_Sig(Q1_Sig),
        .Q2_Sig(Q2_Sig)
    );
    
    initial begin
        clk = 0;
        rst_n = 0;
        
        #250;
        rst_n = 1;
        
        forever #25 clk = ~clk;
    end
    
    
    reg [3:0]i;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 4'd0;
            start_sig <= 1'b0;
            A <= 8'd0;
            B <= 8'd0;
        end
        else
            case (i)
            
                0: // 15 * 34 = 510
                if (done_sig) begin
                    start_sig <= 1'b0;
                    i <= i + 1'b1;
                end
                else begin
                    start_sig <= 1'b1;
                    A <= 8'd15;
                    B <= 8'd34;
                end
                
                1: // -20 * 59 = -1180
                if (done_sig) begin
                    start_sig <= 1'b0;
                    i <= i + 1'b1;
                end
                else begin
                    start_sig <= 1'b1;
                    A <= 8'b1110_1100;
                    B <= 8'd59;
                end
                
                2: // -127 * 127 = -16129
                if (done_sig) begin
                    start_sig <= 1'b0;
                    i <= i + 1'b1;
                end
                else begin
                    start_sig <= 1'b1;
                    A <= 8'b1000_0001;
                    B <= 8'd127;
                end
                
                3:
                    i <= 4'd3;
            
            endcase
    end
    
endmodule
