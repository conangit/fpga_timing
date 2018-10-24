`timescale 1ns/1ns


module count_time_tb;


    reg clk;
    reg rst_n;

    count_time u1
    (
        .clk(clk),
        .rst_n(rst_n)
    );
    
    
    
    initial
    begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    
    initial
    begin
        rst_n = 0;
        #1000;
        rst_n = 1;
    end
    
endmodule

