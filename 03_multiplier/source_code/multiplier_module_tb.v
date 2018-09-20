`timescale 1ns / 1ps

module multiplier_module_simlation();

    reg clk;
    reg rst_n;
    reg start_sig;
    reg [7:0]multiplicand;
    reg [7:0]multiplier;
    
    wire done_sig;
    wire [15:0]product;
    
    //复位信号和时钟信号的刺激
    initial
    begin
        rst_n = 0;
        #10;
        rst_n = 1;
        
        clk = 1;
        forever #10 clk = ~clk;
    end

    //仿真模块的实例化
    multiplier_module u1(
        .clk(clk),
        .rst_n(rst_n),
        .start_sig(start_sig),
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .done_sig(done_sig),
        .product(product)
    );
    
    //不同的被乘数和乘数来刺激multiplier_module
    reg [2:0]i;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 3'd0;
            start_sig <= 1'b0;
            multiplicand <= 8'd0;
            multiplier <= 8'd0;
        end
        else
            case (i)
                
                0: // 10 * 2
                if (done_sig) begin
                    i <= i + 1'b1;
                    start_sig <= 1'b0;
                end
                else begin
                    start_sig <= 1'b1;
                    multiplicand <= 8'd10;
                    multiplier <= 8'd2;
                end

                1: // 2 * 10
                if (done_sig) begin
                    i <= i + 1'b1;
                    start_sig <= 1'b0;
                end
                else begin
                    start_sig <= 1'b1;
                    multiplicand <= 8'd2;
                    multiplier <= 8'd10;
                end
                
                2: // 11 * -5
                if (done_sig) begin
                    i <= i + 1'b1;
                    start_sig <= 1'b0;
                end
                else begin
                    start_sig <= 1'b1;
                    multiplicand <= 8'd11;
                    multiplier <= 8'b1111_1011;
                end
                
                3: // -5 * -11
                if (done_sig) begin
                    i <= i + 1'b1;
                    start_sig <= 1'b0;
                end
                else begin
                    start_sig <= 1'b1;
                    multiplicand <= 8'b1111_1011;
                    multiplier <= 8'b1111_0101;
                end
                
                4: // -5 * -11
                    i <= 3'd4;
                
            endcase
    end
    
    //仿真用到？
    GSR GSR_INST(.GSR(1'b1));
    PUR PUR_INST(.PUR(1'b1));
    
endmodule

