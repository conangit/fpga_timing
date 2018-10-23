`timescale 1ps/1ps

module counter_module_tb;

    reg clk;
    reg rst_n;
    
    /*
    wire _1us;      //由寄存器驱动
    wire _is1US;    //由组合逻辑驱动
    wire [4:0]c1;
    
    
    
    wire _3us;
    wire _is3US;
    wire [5:0]c2;
    
    
    counter_module_1us_3us u1
    (
        .clk(clk),
        .rst_n(rst_n),
        ._1us(_1us),
        ._is1US(_is1US),
        .c1(c1),
        ._3us(_3us),
        ._is3US(_is3US),
        .c2(c2)
    );
    
    
    counter_module_1us u2
    (
        .clk(clk),
        .rst_n(rst_n),
        ._1us(_1us),
        ._is1US(_is1US),
        .c1(c1)
    );
    */
    
    
    
    wire [3:0] i;
    wire [3:0] index;
    
    count_status u3
    (
        .clk(clk),
        .rst_n(rst_n),
        ._i(i),
        ._index(index)
    );
    
    
    initial
    begin
        clk = 0;
        forever #25_000 clk = ~clk; //20MHz
    end
    
    
    initial
    begin
        rst_n = 0;
        
        #1_000_000;     //则是在复位后的出现的第一个上升沿开始动作
        // #1_025_000;     //25ns的奇数倍复位,假设满足"同步释放" 25ns*41=1025ns=1.025us
        rst_n = 1;
    end

endmodule

