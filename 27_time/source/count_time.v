

module count_time
(
    input clk,
    input rst_n
);

    //50Mhz
    parameter T1US = 6'd50;
    
    
    reg [5:0] count;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
            count <= 6'd0;
        else if(count == T1US)
            count <= 6'd1;
        else
            count <= count + 1'b1;
    end
    
    /******/
    
    reg [7:0] count_us;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
            count_us <= 8'd0;
        else if(count_us == 8'd10)
            count_us <= 8'd0;
        else if(count == T1US)
            count_us <= count_us + 1'b1;
        else
            count_us <= count_us;
    end
    
    /******/
    
    // wire count_1us;
    // assign count_1us = (count == T1US) ? 1'b1 : 1'b0;
    
    reg count_1us;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
            count_1us <= 1'b0;
        else
            count_1us <= (count == T1US);
    end
    
    
    wire count_10us;
    assign count_10us = (count_us == 8'd10) ? 1'b1 : 1'b0;
    
endmodule

