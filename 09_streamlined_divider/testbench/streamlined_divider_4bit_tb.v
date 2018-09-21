`timescale 1ns/1ps

module streamlined_divider_4bit_tb;

    reg clk;
    reg rst_n;
    
    reg start_sig;
    reg [3:0]dividend;
    reg [3:0]divisor;
    
    wire dong_sig;
    wire [3:0]quotient;
    wire [3:0]reminder;

    streamlined_divider_4bit u4(
        .clk(clk),
        .rst_n(rst_n),
        .start_sig(start_sig),
        .dividend(dividend),
        .divisor(divisor),
        .dong_sig(dong_sig),
        .quotient(quotient),
        .reminder(reminder)
    );
    
    initial begin
        clk = 0;
        rst_n = 0;
        
        #250;
        rst_n = 1;
        
        forever #25 clk = ~clk;
    end
    
    reg [3:0]i;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            start_sig <= 1'b0;
            dividend <= 4'd0;
            divisor <= 4'd0;
        end
        else
        
            case(i)
                
                0: // 7 / 2
                if (dong_sig) begin
                    start_sig <= 1'b0;
                    i <= i + 1'b1;
                end
                else begin
                    start_sig <= 1'b1;
                    dividend <= 4'd7;
                    divisor <= 4'd2;
                end
                
                1:
                    i <= 4'd1;
                
            endcase
    end
    
    GSR GSR_INST(.GSR(1'b1));
    PUR PUR_INST(.PUR(1'b1));
    
endmodule


