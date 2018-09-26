module pipeline_booth_multiplier(
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
    
    /***************************/
    
    wire [16:0]temp[8:0];
    wire [15:0]item[8:0];
    
    booth_initial_module i1(
        .clk(clk),
        .rst_n(rst_n),
        .a(a),
        .b(b),
        .temp_out(temp[0]),
        .item_out(item[0])
    );
    
    booth_process_module p1(
        .clk(clk),
        .rst_n(rst_n),
        .temp_in(temp[0]),
        .item_in(item[0]),
        .temp_out(temp[1]),
        .item_out(item[1])
    );
    
    booth_process_module p2(
        .clk(clk),
        .rst_n(rst_n),
        .temp_in(temp[1]),
        .item_in(item[1]),
        .temp_out(temp[2]),
        .item_out(item[2])
    );
    
    booth_process_module p3(
        .clk(clk),
        .rst_n(rst_n),
        .temp_in(temp[2]),
        .item_in(item[2]),
        .temp_out(temp[3]),
        .item_out(item[3])
    );

    booth_process_module p4(
        .clk(clk),
        .rst_n(rst_n),
        .temp_in(temp[3]),
        .item_in(item[3]),
        .temp_out(temp[4]),
        .item_out(item[4])
    );
    
    booth_process_module p5(
        .clk(clk),
        .rst_n(rst_n),
        .temp_in(temp[4]),
        .item_in(item[4]),
        .temp_out(temp[5]),
        .item_out(item[5])
    );
    
    booth_process_module p6(
        .clk(clk),
        .rst_n(rst_n),
        .temp_in(temp[5]),
        .item_in(item[5]),
        .temp_out(temp[6]),
        .item_out(item[6])
    );
    
    booth_process_module p7(
        .clk(clk),
        .rst_n(rst_n),
        .temp_in(temp[6]),
        .item_in(item[6]),
        .temp_out(temp[7]),
        .item_out(item[7])
    );
    
    booth_process_module p8(
        .clk(clk),
        .rst_n(rst_n),
        .temp_in(temp[7]),
        .item_in(item[7]),
        .temp_out(temp[8]),
        .item_out(item[8])      //item[8]无存在意义
    );
    
    assign product = temp[8][16:1];
    
    
endmodule


