

module booth_multiplier_module(
    input clk,
    input rst_n,
    
    input start_sig,
    input [7:0]A,
    input [7:0]B,
    
    output done_sig,
    output [15:0]product,
    
    output [7:0]SQ_a,
    output [7:0]SQ_s,
    output [16:0]SQ_p
    );
    
    /*******************/
    
    reg [3:0]i;
    
    reg [7:0]a;     //result of A
    reg [7:0]s;     //reverse result of A
    reg [16:0]p;    //operation register P=2*8+1=17
    reg [3:0]n;     //用来指示n(8)次循环
    reg isDone;
    
    /*******************/
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 4'd0;
            a <= 8'd0;
            s <= 8'd0;
            p <= 17'd0; //p初始化为0
            n <= 4'd0;
            isDone <= 1'b0;
        end
        else if (start_sig)
            case (i)
            
                0:
                begin
                    a <= A;
                    s <= (~A + 1'b1);
                    p <= {8'd0, B, 1'b0}; //填充P空间
                    i <= i + 1'b1;
                end
                
                1: //P空间操作
                    if (n == 8)begin
                        n <= 4'd0;
                        i <= 4'd3; //8次循环完成 跳到步骤3
                    end
                    else if (p[1:0] == 2'b01) begin //+A
                        p <= {p[16:9]+a, p[8:0]};
                        i <= i + 1'b1;
                    end
                    else if (p[1:0] == 2'b10) begin //-A
                        p <= {p[16:9]+s, p[8:0]};
                        i <= i + 1'b1;
                    end
                    else
                        i <= i + 1'b1;
                        
                2: //P空间移位
                begin
                    p <= {p[16], p[16:1]}; //右移一位
                    n <= n + 1'b1; //记录一次操作
                    i <= 4'd1; //退回步骤1 继续循环
                end
                
                3: //求得计算结果
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
    assign product = p[16:1];
    
    assign SQ_a = a;
    assign SQ_s = s;
    assign SQ_p = p;
    
endmodule

///////////////////////////////////////////////////////////////////
// booth算法乘法器
// 1>填充P空间 P = {n'd0, B, 1'b0};
// 2>根据P[1:0],在P[2n+1:n+1]上±A,即P={P[2n+1:n+1]±A, P[n:0]};
// 3>根据P[2n+1]右移一位P
// 4>重复n次2,3步骤
///////////////////////////////////////////////////////////////////


