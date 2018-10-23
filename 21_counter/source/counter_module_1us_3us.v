module counter_module_1us_3us
(
    input clk,
    input rst_n,
    
    output _1us,
    output _is1US,
    output [4:0]c1,
    
    output _3us,
    output _is3US,
    output [5:0]c2
);

    /********************/
    
    //20MHz
    parameter T1US = 5'd20;
    
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
    
    parameter T3US = 6'd60;
    
    /********************/
    
    reg [5:0]count_3us;
    reg is3US;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            count_3us <= 6'd0;
            is3US <= 1'b0;
        end
        else if(count_3us == T3US)
        begin
            count_3us <= 6'd0;
            is3US <= 1'b1;
        end
        else begin
            count_3us <= count_3us + 1'b1;
            is3US <= 1'b0;
        end
    end
    
    /********************/
    
    //组合逻辑驱动
    assign _1us = (count_1us == T1US) ? 1'b1 : 1'b0;
    assign _3us = (count_3us == T3US) ? 1'b1 : 1'b0;
    
    //寄存器驱动
    assign _is1US = is1US;
    assign _is3US = is3US;
    
    assign c1 = count_1us;
    assign c2 = count_3us;
    
endmodule


