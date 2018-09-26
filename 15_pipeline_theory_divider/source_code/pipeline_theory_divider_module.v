module pipeline_theory_divider_module(
    clk,
    rst_n,
    dividend,
    divisor,
    quotient,
    reminder
    );
    
    input clk;
    input rst_n;
    input [7:0]dividend;
    input [7:0]divisor;
    output [7:0]quotient;
    output [7:0]reminder;
    
    /****************************/
    
    wire [7:0]q;
    wire [15:0]temp[8:0];
    wire [9:0]item[8:0];
    
    
    initial_module i1(
        .clk(clk),
        .rst_n(rst_n),
        .dividend(dividend),
        .divisor(divisor),
        .temp_out(temp[0]),
        .item_out(item[0])
    );
    
    process_module p1(
        .clk(clk),
        .rst_n(rst_n),
        .temp_in(temp[0]),
        .item_in(item[0]),
        .temp_out(temp[1]),
        .item_out(item[1]),
        .q(q[7])
    );
    
    process_module p2(
        .clk(clk),
        .rst_n(rst_n),
        .temp_in(temp[1]),
        .item_in(item[1]),
        .temp_out(temp[2]),
        .item_out(item[2]),
        .q(q[6])
    );
    
    process_module p3(
        .clk(clk),
        .rst_n(rst_n),
        .temp_in(temp[2]),
        .item_in(item[2]),
        .temp_out(temp[3]),
        .item_out(item[3]),
        .q(q[5])
    );
    
    process_module p4(
        .clk(clk),
        .rst_n(rst_n),
        .temp_in(temp[3]),
        .item_in(item[3]),
        .temp_out(temp[4]),
        .item_out(item[4]),
        .q(q[4])
    );
    
    process_module p5(
        .clk(clk),
        .rst_n(rst_n),
        .temp_in(temp[4]),
        .item_in(item[4]),
        .temp_out(temp[5]),
        .item_out(item[5]),
        .q(q[3])
    );
    
    process_module p6(
        .clk(clk),
        .rst_n(rst_n),
        .temp_in(temp[5]),
        .item_in(item[5]),
        .temp_out(temp[6]),
        .item_out(item[6]),
        .q(q[2])
    );
    
    process_module p7(
        .clk(clk),
        .rst_n(rst_n),
        .temp_in(temp[6]),
        .item_in(item[6]),
        .temp_out(temp[7]),
        .item_out(item[7]),
        .q(q[1])
    );
    
    process_module p8(
        .clk(clk),
        .rst_n(rst_n),
        .temp_in(temp[7]),
        .item_in(item[7]),
        .temp_out(temp[8]),
        .item_out(item[8]),
        .q(q[0])
    );
    
    // 使用组合逻辑 -- 连续输入式，造成输出冲突
    // 商的正负 由被除数和除数的正负共同决定 余数的正负跟随被除数
    assign quotient = ((item[8][1])^(item[8][0])) ? (~q + 1'b1) : q;
    assign reminder = item[8][1] ? (~(temp[8][15:8]) + 1'b1) : temp[8][15:8];
    
    
    // result_module r1(
        // .clk(clk),
        // .rst_n(rst_n),
        // .temp_in(temp[8]),
        // .item_in(item[8]),
        // .q(q),
        // .quotient(quotient),
        // .reminder(reminder)
    // );
    
endmodule

