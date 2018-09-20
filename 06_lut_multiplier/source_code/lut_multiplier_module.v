///////////////////////////////////////////////
//原理 (a+b)² - (a-b)² = 4ab
//ab = (a+b)²/4 - (a-b)²/4
///////////////////////////////////////////////

module lut_multiplier_module(
    clk,
    rst_n,
    
    start_sig,
    A,
    B,
    
    done_sig,
    product,
    
    I1_Sig,
    I2_Sig,
    Q1_Sig,
    Q2_Sig
    );
    
    input clk;
    input rst_n;
    
    input start_sig;
    input [7:0]A;
    input [7:0]B;
    
    output done_sig;
    output [15:0]product;
    
    //以下变量便于观察算法过程
    output [7:0]I1_Sig;
    output [7:0]I2_Sig;
    output [15:0]Q1_Sig;
    output [15:0]Q2_Sig;
    
    /***********************/
    
    reg isDone;
    reg [15:0]rData;
    
    reg [8:0]I1; //(8bit a) + (8bit b) 可能为9bit
    reg [8:0]I2;
    
    wire [15:0]Q1;
    wire [15:0]Q2;
    
    /***********************/
    
    lut_module u1(
        .CLK(clk),
        .RSTn(rst_n),
        .Addr(I1[7:0]),
        .Q(Q1)
    );
    
    lut_module u2(
        .CLK(clk),
        .RSTn(rst_n),
        .Addr(I2[7:0]),
        .Q(Q2)
    );

    /***********************/
    
    reg [3:0]i;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 4'd0;
            isDone <= 1'b0;
            rData <= 16'd0;
            I1 <= 9'd0;
            I2 <= 9'd0;
        end
        else if (start_sig)
            case(i)
                
                0:
                begin
                    I1 <= {A[7], A} + {B[7], B};
                    I2 <= {A[7], A} - {B[7], B};
                    i <= i + 1'b1;
                end
                
                1: //取正
                begin
                    I1 <= I1[8] ? (~I1 + 1'b1) : I1;
                    I2 <= I2[8] ? (~I2 + 1'b1) : I2;
                    i <= i + 1'b1;
                end
                
                2: //等待从LUT取得计算结果
                    i <= i + 1'b1;
                    
                3:
                begin
                    rData <= Q1 + (~Q2 + 1'b1);
                    i <= i + 1'b1;
                end
                
                4:
                begin
                    isDone <= 1'b1;
                    i <= i + 1'b1;
                end
                
                5:
                begin
                    isDone <= 1'b0;
                    i <= 4'd0;
                end
                
            endcase
    end
    
    assign done_sig = isDone;
    assign product = rData;
    
    assign I1_Sig = I1[7:0];
    assign I2_Sig = I2[7:0];
    assign Q1_Sig = Q1;
    assign Q2_Sig = Q2;
    
    
endmodule
