module counter_module_1us
(
    input clk,
    input rst_n,
    
    output _1us,
    output _is1US,
    
    output [4:0]c1
);

    /********************/
    
    //20MHz
    parameter T1US = 5'd20; //大前提 而不是T1US = 5'd20;
    
    /********************/
    
    reg [4:0]count_1us;
    reg is1US;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            count_1us <= 5'd0;
            is1US <= 1'b0;
        end
        else if(count_1us == T1US)
        begin
            count_1us <= 5'd0;
            is1US <= 1'b1;
        end
        else
        begin
            count_1us <= count_1us + 1'b1;
            is1US <= 1'b0;
        end
    end
    
    /********************/
    
    assign c1 = count_1us; //计数器
    assign _1us = (count_1us == T1US) ? 1'b1 : 1'b0; //组合逻辑驱动count_1us=20时,及时输出1,计时为T1~T19:19*50ns=0.95us
    assign _is1US = is1US; //寄存器驱动,count_1us=20时决定is1US=1,再来一个时钟(count_1us=21/0),才真正输出1,计时为T1~T20:20*50ns=1us

    
    
endmodule


