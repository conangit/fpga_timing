
//显示标准800X600@60Hz
//VGA CLK 40MHz

/*
精确时序要求
HSYNC  128      88       800     40      (1056)
       3.2us    2.2us    20us    1us     26.4us

VSYNC  4        23       600     1       (628)
       105.6us  607.2us  15840us 26.4us  16579.2us
*/


module vga_sync_last_2
(
    clk,
    rst_n,
    hsync_sig,
    vsnyc_sig,
    ready,
    column_addr_sig,
    row_addr_sig
);

    input clk;
    input rst_n;
    
    output vsnyc_sig;
    output hsync_sig;
    output ready;
    output [10:0] column_addr_sig;
    output [10:0] row_addr_sig;
    
    /***********************/
    
    reg [10:0] count_h;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
            count_h <= 11'd0;
        else if(count_h == 11'd1056)
            count_h <= 11'd1; //复位释放后第一个clk,count_h=1;此处使其仍从1开始计数--从而得到精确地hsync信号
        else
            count_h <= count_h + 1'b1;
    end
    
    
    reg [10:0] count_v;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
            count_v <= 11'd0;
        else if(count_v == 11'd628)
            count_v <= 11'd0; //count_v=628过后的一个时钟count_v=0,这个没错,因为复位释放后count_v就为0
        else if(count_h == 11'd1056) //使用1055则开始少一个时钟,结尾正好;使用1056则开始正好,结尾多一个时钟
            count_v <= count_v + 1'b1;
        else
            count_v <= count_v;
    end
    
    //注意此处为寄存器驱动
    reg isReady;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
            isReady <= 1'b0;
        else if((count_h >= 11'd216 && count_h < 11'd1016)      //这里count_v由count_h驱动,故首要先保证条件一满足(抓住216/1016是决定点)
                && (count_v >= 11'd27 && count_v < 11'd627))    //isReady的本质目的是是指示x,y地址
            isReady <= 1'b1;
        else
            isReady <= 1'b0;
    end
    
    //注意此处为组合逻辑驱动
    assign hsync_sig = (count_h <= 11'd128) ? 1'b0 : 1'b1;
    
    //使用1055则开始少一个时钟,结尾正好;使用1056则开始正好,结尾多一个时钟
    //增加限定条件,约束vsnyc_sig
    // assign vsnyc_sig = (count_v < 11'd4) ? 1'b0 : 1'b1;
    /*
     * 注意此处：
     * count_v > 11'd3 与 count_v >= 11'd4 等价
     * 但是
     *  count_v < 11'd628 与  count_v <= 11'd627 可不等价！
     */
    assign vsnyc_sig = (count_v >= 11'd4 && count_v < 11'd628) ? 1'b1 : 1'b0;
    
    //其实本质上依然不是"完美时序"--只是将多余的一个时钟高电平信号转为了低电平信号
    //也就意味着vsync的高电平完美了,但低电平依然有"瑕疵"
    //思路:若vsync是高电平有效,那么此优化是合理的;若vsync是低电平有效,那么应该根据低电平来进行优化
    
    
    assign ready = isReady;
    
    //在优化isReady后,再优化地址输出
    assign column_addr_sig = isReady ? count_h - 11'd217 : 11'd0; //要求(期望)count from 0~799
    assign row_addr_sig = isReady ? count_v - 11'd27 : 11'd0; //要求(期望)count from 0~599
    
endmodule

