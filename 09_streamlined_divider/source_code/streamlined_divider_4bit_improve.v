/////////////////////////////////////////////////////////////
//还需改进点
//1>确定商的正负
//2>有别于传统除法 此除法得到的余数用为正 -- 同Python规则
/////////////////////////////////////////////////////////////

module streamlined_divider_4bit_improve(
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
    input [3:0]dividend;
    input [3:0]divisor;
    
    output dong_sig;
    output [3:0]quotient;
    output [3:0]reminder;
    
    /******************************/
    
    reg [7:0]temp;
    reg [7:0]diff;
    reg [4:0]s;
    
    /******************************/
    
    reg isDone;
    reg [3:0]q;
    reg [3:0]r;
    
    assign dong_sig = isDone;
    assign quotient = q;
    assign reminder = r;
    
    /******************************/
    
    reg [2:0]i;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 3'd0;
            isDone <= 1'b0;
            q <= 4'd0;
            r <= 4'd0;
            temp <= 8'd0;
            diff <= 8'd0;
            s <= 5'd0;
        end
        else if (start_sig)
        
            case(i)
            
                0: //初始化
                begin
                    temp <= {4'd0, dividend};
                    s <= divisor[3] ? {divisor[3], divisor} : {~divisor[3], (~divisor+1'b1)};
                    diff <= 8'd0;
                    q <= 4'd0;
                    r <= 4'd0;
                    i <= i + 1'b1;
                end
                
                1, 2, 3, 4: //计算
                begin
                    diff = temp + {s, 3'b0}; //"="表示当前步骤取得结果 便于待会的diff[7]判断
                    
                    if (diff[7])
                        temp <= {temp[6:0], 1'b0};
                    else
                        temp <= {diff[6:0], 1'b1};
                        
                    i <= i + 1'b1;
                end
                
                5: //求得结果
                begin
                    q <= temp[3:0];
                    r <= temp[7:4];
                    i <= i + 1'b1;
                end
                
                6:
                begin
                    isDone <= 1'b1;
                    i <= i + 1'b1;
                end
                
                7:
                begin
                    isDone <= 1'b0;
                    i <= 3'd0;
                end
            
            endcase
    end
    
endmodule

