`timescale 1ns/1ps

module counter_module_tb;

reg clk;
reg rst_n;

wire _1us;      //由寄存器驱动
wire _3us;
wire _is1US;    //由组合逻辑驱动
wire _is3US;
wire [4:0]c1;
wire [5:0]c2;


counter_module u1
(
    .clk(clk),
    .rst_n(rst_n),
    ._1us(_1us),
    ._3us(_3us),
    ._is1US(_is1US),
    ._is3US(_is3US),
    .c1(c1),
    .c2(c2)
);

initial begin
    clk = 0;
    rst_n = 0;
    
    #1000;
    rst_n = 1;
    forever #25 clk = ~clk;
end

endmodule

