

module multiplier_module(
    input clk,
    input rst_n,
    
    input start_sig,
    input [7:0]multiplicand, //被乘数
    input [7:0]multiplier,   //乘数
    
    output done_sig,
    output [15:0]product
    );
    
    /****************/
    reg [1:0]i;
    reg [7:0]mcand; //register for multiplicand
    reg [7:0]mer;   //register for multiplier
    reg [15:0]tmp;  //sum of pratocal product
    reg isNeg;
    reg isDone;
    
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 2'd0;
            mcand <= 8'd0;
            mer <= 8'd0;
            tmp <= 16'd0;
            isNeg <= 1'b0;
            isDone <= 1'b0;
        end
        else if (start_sig)
            case (i)
            
                0:
                begin
                    isNeg <= multiplicand[7]^multiplier[7]; //确定计算结果的正/负
                    mcand <= multiplicand[7] ? (~multiplicand + 1'b1) : multiplicand; //取得被乘数的正值
                    mer <= multiplier[7] ? (~multiplier + 1'b1) : multiplier; //取得乘数的正值
                    tmp <= 16'd0;
                    i <= i + 1'b1;
                end
                
                1:
                begin
                    if (mer == 0) i <= i + 1'b1;
                    else begin
                        tmp <= tmp + mcand; //累加操作
                        mer <= mer - 1'b1;
                    end
                end
                
                2:
                begin
                    i <= i + 1'b1;
                    isDone <= 1'b1;
                end
                
                3:
                begin
                    i <= 1'b0;
                    isDone <= 1'b0;
                end

            endcase
    end
    
    assign done_sig = isDone;
    assign product = isNeg ? (~tmp + 1'b1) : tmp;
    
endmodule

