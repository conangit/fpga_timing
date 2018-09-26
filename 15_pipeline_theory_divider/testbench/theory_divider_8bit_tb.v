`timescale 1ns/1ps

module theory_divider_8bit_tb;

    reg clk;
    reg rst_n;
    
    reg [7:0]dividend;
    reg [7:0]divisor;
    
    wire [7:0]quotient;
    wire [7:0]reminder;

    pipeline_theory_divider_module u1(
        .clk(clk),
        .rst_n(rst_n),
        .dividend(dividend),
        .divisor(divisor),
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
    reg [3:0]go;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 4'd0;
            // i <= 4'd1;
            // i <= 4'd2;
            // i <= 4'd3;
            go <= 4'd0;
            dividend <= 8'd0;
            divisor <= 8'd0;
        end
        else
        
            case(i)
                
                0: // 7 / 2
                begin
                    // i <= i + 1'b1;
                    // i <= 4'd4;
                    i <= 4'd5;
                    go <= i + 1'b1;
                    dividend <= 8'd7;
                    divisor <= 8'd2;
                end
                
                1: // 8 / -3
                begin
                    // i <= i + 1'b1;
                    // i <= 4'd4;
                    i <= 4'd5;
                    go <= i + 1'b1;
                    dividend <= 8'd7;
                    dividend <= 8'd8;
                    divisor <= 8'b1111_1101;
                end
                
                2: // -19 / 6
                begin
                    // i <= i + 1'b1;
                    // i <= 4'd4;
                    i <= 4'd5;
                    go <= i + 1'b1;
                    dividend <= 8'b1110_1101;
                    divisor <= 8'd6;
                end
                
                3: // -120 / -7
                begin
                    // i <= i + 1'b1;
                    i <= 4'd5;
                    go <= i + 1'b1;
                    dividend <= 8'b1000_1000;
                    divisor <= 8'b1111_1001;
                end
                
                4:
                    i <= 4'd4;
                    
                5:
                begin
                    // clock=50delay
                    // #50; //will error
                    // #75;
                    #100; //至少的延时 否则结果出错
                    i <= go;
                end
                
            endcase
    end
    
    GSR GSR_INST(.GSR(1'b1));
    PUR PUR_INST(.PUR(1'b1));
    
endmodule


