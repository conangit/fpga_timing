module lut_positive_module(
    clk,
    rst_n,
    i1_in,
    i2_in,
    i1_out,
    i2_out
    );
    
    input clk;
    input rst_n;
    
    input [8:0]i1_in;
    input [8:0]i2_in;
    
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
            i1 <= i1_in[8] ? (~i1_in + 1'b1) : i1_in;
            i2 <= i2_in[8] ? (~i2_in + 1'b1) : i2_in;
        end
    end
    
    assign i1_out = i1;
    assign i2_out = i2;
    
endmodule


