`timescale 1ns/1ps

module pipeline_lut_multiplier_module_tb;

    reg clk;
    reg rst_n;
    reg [7:0]a;
    reg [7:0]b;
    
    wire [15:0]product;
    
    
    initial begin
        clk = 0;
        rst_n = 0;
        
        #250;
        rst_n = 1;
        
        forever #25 clk = ~clk;
    end
    
    
    pipeline_booth_multiplier p1(
        .clk(clk),
        .rst_n(rst_n),
        .a(a),
        .b(b),
        .product(product)
    );
    
    reg [3:0]i;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 4'd0;
            a <= 8'd0;
            b <= 8'd0;
        end
        else
            case(i)
                
                0:
                begin
                    i <= i + 1'b1;
                    a <= 8'd5;
                    b <= 8'd4;
                end
                
                1:
                begin
                    i <= i + 1'b1;
                    a <= 8'b1111_0111; //-9
                    b <= 8'd7;
                end
                
                2:
                    i <= 4'd2;
            
            endcase
    end

endmodule

