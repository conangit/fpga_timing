`timescale 1ns/1ps

module theory_divider_32bit_tb;

    reg clk;
    reg rst_n;
    
    reg start_sig;
    reg [31:0]dividend;
    reg [31:0]divisor;
    
    wire dong_sig;
    wire [31:0]quotient;
    wire [31:0]reminder;

    theory_divider_32bit u1(
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
            i <= 4'd0;
            start_sig <= 1'b0;
            dividend <= 32'd0;
            divisor <= 32'd0;
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
                    dividend <= 32'd7;
                    divisor <= 32'd2;
                end
                
                1: // 20512 / 2236
                if (dong_sig) begin
                    start_sig <= 1'b0;
                    i <= i + 1'b1;
                end
                else begin
                    start_sig <= 1'b1;
                    dividend <= 32'd20_512;
                    divisor <= 32'd2_236;
                end
                
                2: // -12564 / 22
                if (dong_sig) begin
                    start_sig <= 1'b0;
                    i <= i + 1'b1;
                end
                else begin
                    start_sig <= 1'b1;
                    // dividend <= -32'12564;
                    dividend <= 32'hFFFF_CEEC;
                    divisor <= 32'd22;
                end
                
                
                3: // 1_040_000_056 / 8_999
                if (dong_sig) begin
                    start_sig <= 1'b0;
                    i <= i + 1'b1;
                end
                else begin
                    start_sig <= 1'b1;
                    dividend <= 32'd1_040_000_056;
                    divisor <= 32'd8_999;
                end
                
                4:
                    i <= 4'd4;
                
            endcase
    end
    
    GSR GSR_INST(.GSR(1'b1));
    PUR PUR_INST(.PUR(1'b1));
    
endmodule


