module lut_initial_module(
    clk,
    rst_n,
    a,
    b,
    i1_out,
    i2_out
    );
    
    input clk;
    input rst_n;
    
    input [7:0]a;
    input [7:0]b;
    
    output [8:0]i1_out;
    output [8:0]i2_out;
    
    /***********************/
    
    reg [8:0]i1;
    reg [8:0]i2;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i1 <= 9'd0;
            i2 <= 9'd0;
        end
        else begin
            i1 <= {a[7], a} + {b[7], b}; //a+b
            i2 <= {a[7], a} + {~b[7], (~b + 1'b1)}; //a-b
        end
    end
    
    assign i1_out = i1;
    assign i2_out = i2;
    
endmodule

