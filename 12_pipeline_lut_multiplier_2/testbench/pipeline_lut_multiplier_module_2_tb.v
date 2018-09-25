`timescale 1ns/1ps

module pipeline_lut_multiplier_module_2_tb();

    reg clk;
    reg rst_n;
    
    reg [7:0]a;
    reg [7:0]b;
    
    wire [15:0]product;
    
    pipeline_lut_multiplier_module_2 u1(
        .clk(clk),
        .rst_n(rst_n),
        .a(a),
        .b(b),
        .product(product)
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
            a <= 8'd0;
            b <= 8'd0;
        end
        else
            case (i)
            
                0: // 15 * 34 = 510
                begin
                    a <= 8'd15;
                    b <= 8'd34;
                    i <= i + 1'b1;
                end
                
                1: // -20 * 59 = -1180
                begin
                    a <= 8'b1110_1100;
                    b <= 8'd59;
                    i <= i + 1'b1;
                end
                
                2: // -127 * 127 = -16129
                begin
                    a <= 8'b1000_0001;
                    b <= 8'd127;
                    i <= i + 1'b1;
                end
                
                3:
                    i <= 4'd3;
            
            endcase
    end
    
endmodule
