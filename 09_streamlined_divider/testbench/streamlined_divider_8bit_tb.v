`timescale 1ns/1ps

module streamlined_divider_8bit_tb;

    reg clk;
    reg rst_n;
    
    reg start_sig;
    reg [7:0]dividend;
    reg [7:0]divisor;
    
    wire dong_sig;
    wire [7:0]quotient;
    wire [7:0]reminder;

    streamlined_divider_8bit_improve u1(
        .clk(clk),
        .rst_n(rst_n),
        .start_sig(start_sig),
        .dividend(dividend),
        .divisor(divisor),
        .dong_sig(dong_sig),
        .quotient(quotient),
        .reminder(reminder)
    );
    
    // streamlined_divider_demo u1(
        // .CLK(clk),
        // .RSTn(rst_n),
        // .Start_Sig(start_sig),
        // .Dividend(dividend),
        // .Divisor(divisor),
        // .Done_Sig(dong_sig),
        // .Quotient(quotient),
        // .Reminder(reminder)
    // );
    
    
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
            i <= 4'd0;
            start_sig <= 1'b0;
            dividend <= 8'd0;
            divisor <= 8'd0;
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
                    dividend <= 8'd7;
                    divisor <= 8'd2;
                end
                
                1: // 8 / -3
                if (dong_sig) begin
                    start_sig <= 1'b0;
                    i <= i + 1'b1;
                end
                else begin
                    start_sig <= 1'b1;
                    dividend <= 8'd8;
                    divisor <= 8'b1111_1101;
                end
                
                2: // -19 / 6
                if (dong_sig) begin
                    start_sig <= 1'b0;
                    i <= i + 1'b1;
                end
                else begin
                    start_sig <= 1'b1;
                    dividend <= 8'b1110_1101;
                    divisor <= 8'd6;
                end
                
                3: // -120 / -7
                if (dong_sig) begin
                    start_sig <= 1'b0;
                    i <= i + 1'b1;
                end
                else begin
                    start_sig <= 1'b1;
                    dividend <= 8'b1000_1000;
                    divisor <= 8'b1111_1001;
                end
                
                4:
                    i <= 4'd4;
                
            endcase
    end
    
    GSR GSR_INST(.GSR(1'b1));
    PUR PUR_INST(.PUR(1'b1));
    
endmodule


