module result_module(
    clk,
    rst_n,
    temp_in,
    item_in,
    q,
    quotient,
    reminder
    );
    
    input clk;
    input rst_n;
    
    input [15:0]temp_in;
    input [9:0]item_in;
    input [7:0]q;
    
    output [7:0]quotient;
    output [7:0]reminder;
    
    /****************************/
    
    reg [7:0]rQueo;
    reg [7:0]rRemi;
    
    //增加一个clock延时
    reg [7:0]Q1;
    reg [7:0]R1;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rQueo <= 8'd0;
            rRemi <= 8'd0;
            Q1 <= 8'd0;
            R1 <= 8'd0;
        end
        else begin
            rQueo <= ((item_in[1])^(item_in[0])) ? (~q + 1'b1) : q;
            rRemi <= item_in[1] ? (~(temp_in[15:8]) + 1'b1) : temp_in[15:8];
            Q1 <= rQueo;
            R1 <= rRemi;
        end
    end
    
    assign quotient = Q1;
    assign reminder = R1;
    
    
endmodule


