


//显示标准800X600@60Hz
//VGA CLK 40MHz

module vga_sync_module_alinx_before
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
            count_h <= 11'd0; //count_h=1056过后的一个时钟count_h=0
        else
            count_h <= count_h + 1'b1;
    end
    
    
    reg [10:0] count_v;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
            count_v <= 11'd0;
        else if(count_v == 11'd628)
            count_v <= 11'd0; //count_v=628过后的一个时钟count_v=0
        else if(count_h == 11'd1056)
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
        else if((count_h > 11'd216 && count_h < 11'd1017)
                && (count_v > 11'd27 && count_v < 11'd627))
            isReady <= 1'b1; //count_h=218,count_v=28 ~ count_h=1018,count_v=628 (?)
        else
            isReady <= 1'b0;
    end
    
    //注意此处为组合逻辑驱动
    assign hsync_sig = (count_h <= 11'd128) ? 1'b0 : 1'b1; //count_h=129时刻,hsync_sig=1
    assign vsnyc_sig = (count_v <= 11'd4) ? 1'b0 : 1'b1; //count_v=5时刻,vsnyc_sig=1 (理论上4个count_v(0~4)就够了:可以看出,多了一个count_v)
    assign ready = isReady;
    
    assign column_addr_sig = isReady ? count_h - 11'd217 : 11'd0; //isReady=1时刻,column_addr_sig=1~800
    assign row_addr_sig = isReady ? count_v - 11'd28 : 11'd0; //isReady=1时刻,row_addr_sig=0~598
    
    
endmodule


