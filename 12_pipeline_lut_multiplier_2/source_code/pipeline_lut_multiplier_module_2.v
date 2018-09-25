///////////////////////////////////////////////
//原理 (a+b)² - (a-b)² = 4ab
//ab = (a+b)²/4 - (a-b)²/4
///////////////////////////////////////////////

module pipeline_lut_multiplier_module_2(
    clk,
    rst_n,
    a,
    b,
    product
    );
    
    input clk;
    input rst_n;
    
    input [7:0]a;
    input [7:0]b;
    
    output [15:0]product;
    
    /***********************/
    
    wire [8:0]w_i1;
    wire [8:0]w_i2;
    
    wire [7:0]w_ia;
    wire [7:0]w_ib;
    
    wire [15:0]Q1;
    wire [15:0]Q2;
    
    
    task1_module t1(
        .clk(clk),
        .rst_n(rst_n),
        .a(a),
        .b(b),
        .i1_o(w_i1),
        .i2_o(w_i2)
    );
    
    task2_module t2(
        .clk(clk),
        .rst_n(rst_n),
        .i1_a(w_i1),
        .i2_b(w_i2),
        .i1(w_ia),
        .i2(w_ib)
    );
    
    lut_module u1(
        .CLK(clk),
        .RSTn(rst_n),
        .Addr(w_ia),
        .Q(Q1)
    );
    
    lut_module u2(
        .CLK(clk),
        .RSTn(rst_n),
        .Addr(w_ib),
        .Q(Q2)
    );

    /***********************/
    
    assign product = Q1 + (~Q2 + 1'b1);
    
    
endmodule

