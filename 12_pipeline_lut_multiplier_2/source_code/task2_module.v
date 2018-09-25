module task2_module(
    clk,
    rst_n,
    i1_a,
    i2_b,
    i1,
    i2
    );
    
    input clk;
    input rst_n;
    
    input [8:0]i1_a;
    input [8:0]i2_b;
    
    output [7:0]i1;
    output [7:0]i2;
    
    /***********************/
    
    reg [8:0]rData1;
    reg [8:0]rData2;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rData1 <= 9'd0;
            rData2 <= 9'd0;
        end
        else begin
            rData1 <= i1_a[8] ? (~i1_a + 1'b1) : i1_a;
            rData2 <= i2_b[8] ? (~i2_b + 1'b1) : i2_b;
        end
    end
    
    assign i1 = rData1[7:0];
    assign i2 = rData2[7:0];
    
endmodule


