

module modified_booth_module(
    clk,
    rst_n,
    
    start_sig,
    A,
    B,
    
    done_sig,
    product,
    
    SQ_a,
    SQ_s,
    SQ_p
    );
    
    input clk;
    input rst_n;
    
    input start_sig;
    input [7:0]A;
    input [7:0]B;
    
    output done_sig;
    output [15:0]product;
    
    //以下变量便于观察算法过程
    output [7:0]SQ_a;
    output [7:0]SQ_s;
    output [16:0]SQ_p;
    
    /***********************/
    
    reg [3:0]i;
    reg [7:0]a;
    reg [7:0]s;
    reg [16:0]p;
    reg [3:0]n;
    reg isDone;
    
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 4'd0;
            a <= 8'd0;
            s <= 8'd0;
            p <= 17'd0;
            n <= 4'd0;
            isDone <= 1'b0;
        end
        else if (start_sig)
            case(i)
                
                0:
                begin
                    a <= A;
                    s <= (~A + 1'b1);
                    p <= {8'd0, B, 1'b0};
                    i <= i + 1'b1;
                end
                
                1:
                if (n == 4) begin
                    n <= 4'd0;
                    i <= 4'd9;
                end
                else if (p[2:0] == 3'b001 || p[2:0] == 3'b010) begin
                    p <= {p[16:9]+a, p[8:0]}; //+被乘数
                    i <= i + 1'b1; //2--右移两位
                end
                else if (p[2:0] == 3'b011) begin
                    i <= 4'd3; //3
                end
                else if (p[2:0] == 3'b100) begin
                    i <= 4'd6; //6
                end
                else if (p[2:0] == 3'b101 || p[2:0] == 3'b110) begin
                    p <= {p[16:9]+s, p[8:0]}; //-被乘数
                    i <= i + 1'b1; //2--右移两位
                end
                else
                    i <= i + 1'b1; //2--无操作 右移两位
                
                //p右移两位
                2:
                begin
                    p <= {p[16], p[16], p[16:2]};
                    n <= n + 1'b1;
                    i <= 4'd1;
                end
                
                //右移一位 加被乘数 右移一位
                3:
                begin
                    p <= {p[16], p[16:1]}; //右移一位
                    i <= i + 1'b1;
                end
                
                4:
                begin
                    p <= {p[16:9]+a, p[8:0]}; //加被乘数
                    i <= i + 1'b1;
                end
                
                5:
                begin
                    p <= {p[16], p[16:1]}; //右移一位
                    n <= n + 1'b1;
                    i <= 4'd1;
                end
                
                //右移一位 减被乘数 右移一位
                6:
                begin
                    p <= {p[16], p[16:1]}; //右移一位
                    i <= i + 1'b1;
                end
                
                7:
                begin
                    p <= {p[16:9]+s, p[8:0]}; //减被乘数
                    i <= i + 1'b1;
                end
                
                8:
                begin
                    p <= {p[16], p[16:1]}; //右移一位
                    n <= n + 1'b1;
                    i <= 4'd1;
                end
                
                //done
                9:
                begin
                    isDone <= 1'b1;
                    i <= i + 1'b1;
                end
                
                10:
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
