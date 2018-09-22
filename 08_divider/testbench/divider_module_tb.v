`timescale 1ns/1ps


module divider_module_tb;

    reg clk;
    reg rst_n;
    reg start_sig;
    reg [7:0]dividend;
    reg [7:0]divisor;
    
    wire done_sig;
    wire [7:0]quotient;
    wire [7:0]reminder;

    // divider_module_1 u1(
        // .clk(clk),
        // .rst_n(rst_n),
        // .start_sig(start_sig),
        // .dividend(dividend),
        // .divisor(divisor),
        // .done_sig(done_sig),
        // .quotient(quotient),
        // .reminder(reminder)
    // );
    
    
    // divider_module_2 u2(
        // .clk(clk),
        // .rst_n(rst_n),
        // .start_sig(start_sig),
        // .dividend(dividend),
        // .divisor(divisor),
        // .done_sig(done_sig),
        // .quotient(quotient),
        // .reminder(reminder)
    // );
    
    divider_module_3 u3(
        .CLK(clk),
        .RSTn(rst_n),
        .Start_Sig(start_sig),
        .Dividend(dividend),
        .Divisor(divisor),
        .Done_Sig(done_sig),
        .Quotient(quotient),
        .Reminder(reminder)
    );
    
    
    initial begin
        clk = 0;
        rst_n = 0;
        
        #100;
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
        
            case (i)
                
                0: // 9 / 6
                if (done_sig) begin
                    start_sig <= 1'b0;
                    i <= i + 1'b1;
                end
                else begin
                    start_sig <= 1'b1;
                    dividend <= 8'd9;
                    divisor <= 8'd6;
                end
                
                1: // 9 / -6
                if (done_sig) begin
                    start_sig <= 1'b0;
                    i <= i + 1'b1;
                end
                else begin
                    start_sig <= 1'b1;
                    dividend <= 8'd9;
                    divisor <= 8'b1111_1010;
                end
                
                2: // -9 / 6
                if (done_sig) begin
                    start_sig <= 1'b0;
                    i <= i + 1'b1;
                end
                else begin
                    start_sig <= 1'b1;
                    dividend <= 8'b1111_0111;
                    divisor <= 8'd6;
                end
                
                3: // -9 / -6
                if (done_sig) begin
                    start_sig <= 1'b0;
                    i <= i + 1'b1;
                end
                else begin
                    start_sig <= 1'b1;
                    dividend <= 8'b1111_0111;
                    divisor <= 8'b1111_1010;
                end
                
                4:
                    i <= 4'd4;
            
            endcase
        
    end

    GSR GSR_INST(.GSR(1'b1));
    PUR PUR_INST(.PUR(1'b1));

endmodule


