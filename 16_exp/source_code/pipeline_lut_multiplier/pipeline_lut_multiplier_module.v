///////////////////////////////////////////////
//原理 (a+b)² - (a-b)² = 4ab
//ab = (a+b)²/4 - (a-b)²/4
///////////////////////////////////////////////

module pipeline_lut_multiplier_module(
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
    
    wire [8:0]w_init1;
    wire [8:0]w_init2;
    
    wire [8:0]w_i1_out;
    wire [8:0]w_i2_out;
    
    wire [15:0]w_q1;
    wire [15:0]w_q2;
    
    
    lut_initial_module i1(
        .clk(clk),
        .rst_n(rst_n),
        .a(a),
        .b(b),
        .i1_out(w_init1),
        .i2_out(w_init2)
    );
    
    lut_positive_module p1(
        .clk(clk),
        .rst_n(rst_n),
        .i1_in(w_init1),
        .i2_in(w_init2),
        .i1_out(w_i1_out),
        .i2_out(w_i2_out)
    );
    
    lut_module t1(
        .CLK(clk),
        .RSTn(rst_n),
        .Addr(w_i1_out[7:0]),
        .Q(w_q1)
    );
    
    lut_module t2(
        .CLK(clk),
        .RSTn(rst_n),
        .Addr(w_i2_out[7:0]),
        .Q(w_q2)
    );

    /***********************/
    
    assign product = w_q1 + (~w_q2 + 1'b1);
    
    
endmodule

