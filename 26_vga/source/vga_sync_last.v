
//显示标准800X600@60Hz
//VGA CLK 40MHz

/*
精确时序要求
HSYNC  128      88       800     40      (1056)
       3.2us    2.2us    20us    1us     26.4us

VSYNC  4        23       600     1       (628)
       105.6us  607.2us  15840us 26.4us  16579.2us
*/


//根据before的仿真,现在需要优化vsync与ready信号的时序
//其实hsync也有点"小误差":第一个hsync完美,第二个hsync就会多一个时钟了,原因在于
//复位释放后count_h从1到1056,count_h=1056后count_h=0,第二次的hsync则从0到1056
//从而多了一个时钟

module vga_sync_last
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
        else if(count_h == 11'd1055) //使得count_h=11'd1056时count_v也发生变化--从而得到精确地vsync信号
            count_v <= count_v + 1'b1; //然而只有真正的满1056个时钟才是26.4us，故在1055时就决定+vount,则1056立即count_v变化,vsync也立即变化,则会少了1个vga clk
        else                           //那么为什么又没有在计满时,在1055立马下降呢,因为1055决定count_v从627到628,在1056时,count_v的628才决定count_v下一刻为0,也即1056满后vsync才变低
            count_v <= count_v;        //所以“总是会有瑕疵”
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
    assign vsnyc_sig = (count_v < 11'd4) ? 1'b0 : 1'b1;
    assign ready = isReady;
    
    //在优化isReady后,再优化地址输出
    assign column_addr_sig = isReady ? count_h - 11'd217 : 11'd0; //要求(期望)count from 0~799
    assign row_addr_sig = isReady ? count_v - 11'd27 : 11'd0; //要求(期望)count from 0~599
    
endmodule

