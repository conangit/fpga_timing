//////////////////////////////////////////////////////////////////////
//此除法器遵行
//商的符号由被除数和除数共同决定
//余数的符号永为正
//////////////////////////////
// 7   /  2 =  3 ... 1
// 8   / -3 = -2 ... 2
//-19  /  6 = -4 ... 5
//-120 / -7 = 18 ... 6
//
//8bit情况下 上面又是错的，why????????
//
//若改进一下 同时判别余数的正负 那么又回到了C C++规则除法器
/////////////////////////////////////////////////////////////////////

module streamlined_divider_8bit_improve(
    clk,
    rst_n,
    start_sig,
    dividend,
    divisor,
    dong_sig,
    quotient,
    reminder
    );
    
    input clk;
    input rst_n;
    
    input start_sig;
    input [7:0]dividend;
    input [7:0]divisor;
    
    output dong_sig;
    output [7:0]quotient;
    output [7:0]reminder;
    
    /******************************/
    
    reg [15:0]temp;
    reg [15:0]diff;
    reg [8:0]s;
    
    /******************************/
    
    reg isDone;
    reg isqNeg;
    reg isrNeg;
    reg [7:0]q;
    reg [7:0]r;
    
    assign dong_sig = isDone;
    assign quotient = q;
    assign reminder = r;
    
    /******************************/
    
    reg [3:0]i;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            temp <= 16'd0;
            diff <= 16'd0;
            s <= 9'd0;
            isDone <= 1'b0;
            isqNeg <= 1'b0;
            isrNeg <= 1'b0;
            q <= 8'd0;
            r <= 8'd0;
            i <= 4'd0;
        end
        else if (start_sig)
            
            case(i)
                
                0:
                begin
                    isqNeg <= dividend[7]^divisor[7];
                    isrNeg <= dividend[7];
                    
                    // temp <= {8'd0, dividend};
                    temp <= dividend[7] ? {8'd0, ~dividend+1'b1} : {8'd0, dividend};
                    // temp <= dividend[7] ? {8'hff, ~dividend+1'b1} : {8'h00, dividend};
                    
                    diff <= 16'd0;
                    s <= divisor[7] ? {1'b1, divisor} : {1'b1, (~divisor + 1'b1)};
                    q <= 8'd0;
                    r <= 8'd0;
                    i <= i + 1'b1;
                end
                
                1,2,3,4,5,6,7,8:
                begin
                    diff = temp + {s, 7'd0};
                    
                    if (diff[15])
                        temp <= {temp[14:0], 1'b0};
                    else
                        temp <= {diff[14:0], 1'b1};
                        
                    i <= i + 1'b1;
                end
                
                9:
                begin
                    q <= isqNeg ? (~temp[7:0] + 1'b1) : temp[7:0];
                    r <= isrNeg ? (~temp[15:8] +1'b1) : temp[15:8];
                    i <= i + 1'b1;
                end
                
                10:
                begin
                    isDone <= 1'b1;
                    i <= i + 1'b1;
                end
                
                11:
                begin
                    isDone <= 1'b0;
                    i <= 4'd0;
                end
                
            endcase
    end

endmodule

