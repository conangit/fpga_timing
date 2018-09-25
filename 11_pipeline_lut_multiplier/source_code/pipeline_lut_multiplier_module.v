///////////////////////////////////////////////
//原理 (a+b)² - (a-b)² = 4ab
//ab = (a+b)²/4 - (a-b)²/4
///////////////////////////////////////////////

module pipeline_lut_multiplier_module(
    clk,
    rst_n,
    A,
    B,
    product
    );
    
    input clk;
    input rst_n;
    
    input [7:0]A;
    input [7:0]B;
    
    output [15:0]product;
    
    /***********************/
    
    reg [8:0]I1[1:0];
    reg [8:0]I2[1:0];
    
    wire [15:0]Q1;
    wire [15:0]Q2;
    
    /***********************/
    
    lut_module u1(
        .CLK(clk),
        .RSTn(rst_n),
        .Addr(I1[1][7:0]),
        .Q(Q1)
    );
    
    lut_module u2(
        .CLK(clk),
        .RSTn(rst_n),
        .Addr(I2[1][7:0]),
        .Q(Q2)
    );

    /***********************/
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            I1[0] <= 9'd0;
            I1[1] <= 9'd0;
            I2[0] <= 9'd0;
            I2[1] <= 9'd0;
        end
        else begin
            //
            I1[0] <= {A[7], A} + {B[7], B};             //a+b
            I2[0] <= {A[7], A} + {~B[7], ~B+1'b1};      //a-b
            
            I1[1] <= I1[0][8] ? (~I1[0]+1'b1) : I1[0];  //I1取正
            I2[1] <= I2[0][8] ? (~I2[0]+1'b1) : I2[0];  //I2取正
        end
    end
    
    assign product = Q1 + (~Q2 + 1'b1);
    
    
endmodule
