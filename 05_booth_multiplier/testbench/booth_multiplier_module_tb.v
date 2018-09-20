`timescale 1ns/1ps

module booth_multiplier_module_tb;

    reg clk;
    reg rst_n;
    reg start_sig;
    reg [7:0]A;
    reg [7:0]B;
    
    wire done_sig;
    wire [15:0]product;
    
    wire [7:0]SQ_a;
    wire [7:0]SQ_s;
    wire [16:0]SQ_p;
    
    /*******************/

    /*
    booth_multiplier_module u1(
        .clk(clk),
        .rst_n(rst_n),
        .start_sig(start_sig),
        .A(A),
        .B(B),
        .done_sig(done_sig),
        .product(product),
        .SQ_a(SQ_a),
        .SQ_s(SQ_s),
        .SQ_p(SQ_p)
    );
    */
    
    booth_multiplier_module_improve u2(
        .clk(clk),
        .rst_n(rst_n),
        .start_sig(start_sig),
        .A(A),
        .B(B),
        .done_sig(done_sig),
        .product(product),
        .SQ_a(SQ_a),
        .SQ_s(SQ_s),
        .SQ_p(SQ_p)
    );
    
    /*******************/
    
    initial begin
        clk = 0;
        rst_n = 0;
        
        #500;
        rst_n = 1;
        
        forever #25 clk = ~clk;
    end
    
    /*******************/
    reg [3:0]i;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 4'd0;
            A <= 8'd0;
            B <= 8'd0;
            start_sig <= 1'b0;
        end
        else
            case (i)
            
                0: // 2 * 4
                    if (done_sig) begin
                        start_sig <= 1'b0;
                        i <= i + 1'b1;
                    end
                    else begin
                        start_sig <= 1'b1;
                        A = 8'd2;
                        B = 8'd4;
                    end
                
                1: // -4 * 4
                    if (done_sig) begin
                        start_sig <= 1'b0;
                        i <= i + 1'b1;
                    end
                    else begin
                        start_sig <= 1'b1;
                        A = 8'b1111_1100;
                        B = 8'd4;
                    end
                    
                2: // 127 * -127
                    if (done_sig) begin
                        start_sig <= 1'b0;
                        i <= i + 1'b1;
                    end
                    else begin
                        start_sig <= 1'b1;
                        A = 8'd127;
                        B = 8'b1000_0001;
                    end
                
                3: // -127 * -127
                    if (done_sig) begin
                        start_sig <= 1'b0;
                        i <= i + 1'b1;
                    end
                    else begin
                        start_sig <= 1'b1;
                        A = 8'b1000_0001;
                        B = 8'b1000_0001;
                    end
                    
                4:
                    i <= 4'd4;

            endcase
    end
    
    GSR GSR_INST(.GSR(1'b1));
    PUR PUR_INST(.PUR(1'b1));
    
endmodule

