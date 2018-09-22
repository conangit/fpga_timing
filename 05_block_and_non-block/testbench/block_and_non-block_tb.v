`timescale 1ns/1ps

module block_and_non_block_tb;

    reg clk;
    reg rst_n;

    block_and_non_block u1(
        .clk(clk),
        .rst_n(rst_n)
    );
    
    initial begin
        clk = 0;
        rst_n = 0;
        
        #250;
        rst_n = 1;
        
        forever #25 clk = ~clk;
    end
    
endmodule

