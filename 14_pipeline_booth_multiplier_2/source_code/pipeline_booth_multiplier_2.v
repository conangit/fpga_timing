module pipeline_booth_multiplier_2(
    clk,
    a,
    b,
    product
    );
    
    input clk;
    input [7:0]a;
    input [7:0]b;
    output [15:0]product;
    
    /***************************/
    
    wire [16:0]p[8:0];
    wire [15:0]item[8:0];
    
    assign p[0] = {8'd0, b, 1'b0};
    assign item[0] = {~a + 1'b1, a};
    
    booth_multipiler_process_module p1(
        .clk(clk),
        .p_i(p[0]),
        .item_i(item[0]),
        .p_o(p[1]),
        .item_o(item[1])
    );
    
    booth_multipiler_process_module p2(
        .clk(clk),
        .p_i(p[1]),
        .item_i(item[1]),
        .p_o(p[2]),
        .item_o(item[2])
    );
    
    booth_multipiler_process_module p3(
        .clk(clk),
        .p_i(p[2]),
        .item_i(item[2]),
        .p_o(p[3]),
        .item_o(item[3])
    );

    booth_multipiler_process_module p4(
        .clk(clk),
        .p_i(p[3]),
        .item_i(item[3]),
        .p_o(p[4]),
        .item_o(item[4])
    );
    
    booth_multipiler_process_module p5(
        .clk(clk),
        .p_i(p[4]),
        .item_i(item[4]),
        .p_o(p[5]),
        .item_o(item[5])
    );
    
    booth_multipiler_process_module p6(
        .clk(clk),
        .p_i(p[5]),
        .item_i(item[5]),
        .p_o(p[6]),
        .item_o(item[6])
    );
    
    booth_multipiler_process_module p7(
        .clk(clk),
        .p_i(p[6]),
        .item_i(item[6]),
        .p_o(p[7]),
        .item_o(item[7])
    );
    
    booth_multipiler_process_module p8(
        .clk(clk),
        .p_i(p[7]),
        .item_i(item[7]),
        .p_o(p[8]),
        .item_o(item[8])        //item[8]无存在意义
    );
    
    assign product = p[8][16:1];
    
    
endmodule


