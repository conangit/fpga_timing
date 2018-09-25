module task1_module(
    clk,
    rst_n,
    a,
    b,
    i1_o,
    i2_o
    );
    
    input clk;
    input rst_n;
    
    input [7:0]a;
    input [7:0]b;
    
    output [8:0]i1_o;
    output [8:0]i2_o;
    
    /***********************/
    
    reg [8:0]rData1;
    reg [8:0]rData2;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rData1 <= 9'd0;
            rData2 <= 9'd0;
        end
        else begin
            rData1 <= {a[7], a} + {b[7], b};
            rData2 <= {a[7], a} + {~b[7], (~b + 1'b1)};
        end
    end
    
    assign i1_o = rData1;
    assign i2_o = rData2;
    
endmodule

