///////////////////////////////
//此除法器遵行
//商的符号由被除数和除数共同决定
//余数的符号跟随被除数
//////////////////////////////
// 9 /  6 =  1 ... 3
// 9 / -6 = -1 ... 3
//-9 /  6 = -1 ...-3
//-9 / -6 =  1 ...-3
////////////////////////////

module divider_module(
    clk,
    rst_n,
    
    start_sig,
    dividend,
    divisor,
    
    done_sig,
    quotient,
    reminder
    );
    
    input clk;
    input rst_n;
    
    input start_sig;
    input [7:0]dividend;
    input [7:0]divisor;
    
    output done_sig;
    output [7:0]quotient;
    output [7:0]reminder;
    
    /******************************************/
    reg [3:0]i;
    reg isDone;
    reg [7:0]rDivident; //被除数取正
    reg [7:0]rDivisor;  //除数取正
    reg [7:0]q;         //商
    reg [7:0]r;         //余数
    reg qNeg;           //商的正负(被除数和除数共同决定)
    reg rNeg;           //余数正负(跟随被除数)
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 4'd0;
            isDone <= 1'b0;
            rDivident <= 8'd0;
            rDivisor <= 8'd0;
            q <= 8'd0;
            r <= 8'd0;
            qNeg <= 1'b0;
            rNeg <= 1'b0;
        end
        else if (start_sig)
            
            case (i)
                
                0:
                begin
                    qNeg <= dividend[7]^divisor[7]; //决定商的正负
                    rNeg <= dividend[7]; //决定余数的正负
                    rDivident <= dividend[7] ? (~dividend + 1'b1) : dividend; //被除数取正
                    rDivisor <= divisor[7] ? (~divisor + 1'b1) : divisor; //除数取正
                    q <= 8'd0; //每次计算前 必须归零 而不是由复位态归零
                    r <= 8'd0;
                    i <= i + 1'b1;
                end
                
                1:
                if (rDivident < rDivisor)
                    i <= i + 1'b1;
                else begin
                    rDivident <= rDivident - rDivisor;
                    q <= q + 1'b1;
                end
                
                2: //求得结果
                begin
                    q <= qNeg ? (~q + 1'b1) : q;
                    r <= rNeg ? (~rDivident + 1'b1) : rDivident;
                    i <= i + 1'b1;
                end
                
                3:
                begin
                    isDone <= 1'b1;
                    i <= i + 1'b1;
                end
                
                4:
                begin
                    isDone <= 1'b0;
                    i <= 4'd0;
                end
            
            endcase
    end
    
    assign done_sig = isDone;
    assign quotient = q;
    assign reminder = r;
    
endmodule

