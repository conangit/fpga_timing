`timescale 1ns/1ps

module pipeline_booth_multiplier_module_tb;

    reg clk;

    reg [7:0]a;
    reg [7:0]b;
    
    wire [15:0]product;
    
    /*******************/
    pipeline_booth_multiplier u1(
        .clk(clk),
        .a(a),
        .b(b),
        .product(product)
    );
    
    
    /*******************/
    
    initial begin
        clk = 0;

        forever #25 clk = ~clk;
    end
    
    /*******************/
    reg [3:0]i = 4'd0;
    
    always @(posedge clk) begin
            case (i)
            
                0: // 2 * 4
                begin
                    a <= 8'd2;
                    b <= 8'd4;
                    i <= i + 1'b1;
                end
                
                1: // -4 * 5
                begin
                    a <= 8'b1111_1100;
                    b <= 8'd5;
                    i <= i + 1'b1;
                end

                2: // 36 * -8
                begin
                    a = 8'd36;
                    b = 8'b1111_1000;
                    i <= i + 1'b1;
                end
                
                3: // -127 * -127
                begin
                    a <= 8'b1000_0001;
                    b <= 8'b1000_0001;
                    i <= i + 1'b1;
                end
                    
                4:
                    i <= 4'd4;

            endcase
    end
    
    GSR GSR_INST(.GSR(1'b1));
    PUR PUR_INST(.PUR(1'b1));
    
endmodule

