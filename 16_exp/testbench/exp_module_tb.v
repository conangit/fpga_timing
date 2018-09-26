`timescale 1ns/1ps

module exp_module_tb;
    
    
    reg clk;
    reg rst_n;
    
    reg [7:0]a;
    reg [7:0]b;
    reg [7:0]c;
    reg [7:0]d;
    
    wire [16:0]s;
    
    
    initial begin
        clk = 0;
        rst_n = 0;
        
        #250;
        rst_n = 1;
        
        forever #25 clk = ~clk;
    end
    
    
    exp_module u1(
        .clk(clk),
        .rst_n(rst_n),
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .s(s)
    );
    
    reg [3:0]i;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 4'd0;
            a <= 8'd0;
            b <= 8'd0;
            c <= 8'd0;
            d <= 8'd0;
        end
        else
            case(i)
                
                0: // 4*5 + 3*2 = 20+6 = 26
                begin
                    i <= 4'd1;
                    a <= 8'd5;
                    b <= 8'd4;
                    c <= 8'd3;
                    d <= 8'd2;
                end
                
                1: //-9*7 + 3*4 = -63+12 = -51
                begin
                    i <= 4'd2;
                    a <= 8'b1111_0111; //-9
                    b <= 8'd7;
                    c <= 8'd3;
                    d <= 8'd4;
                end
                
                2: //-16*5 + 77*6 = -80+462 = 382
                begin
                    i <= 4'd3;
                    a <= 8'b1111_0000;
                    b <= 8'd5;
                    c <= 8'd77;
                    d <= 8'd6;
                end
                
                3: //-13*-5 + -127*15 = 65+(-1905) = -1840
                begin
                    i <= 4'd4;
                    a <= 8'b1111_0011;
                    b <= 8'b1111_1011;
                    c <= 8'b1000_0001;
                    d <= 8'd15;
                end
                
                4:
                    i <= 4'd4;
            
            endcase
    end
    
    
    GSR GSR_INST(.GSR(1'b1));
    PUR PUR_INST(.PUR(1'b1));

endmodule

