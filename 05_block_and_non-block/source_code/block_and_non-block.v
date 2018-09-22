module block_and_non_block(
    clk,
    rst_n
    );
    
    input clk;
    input rst_n;
    
    reg [3:0]i;
    reg [3:0]a;
    reg [3:0]b;
    reg [4:0]c;
    reg dong_sig;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 4'd0;
            a <= 4'd0;
            b <= 4'd0;
            c <= 5'd0;
            dong_sig <= 1'b0;
        end
        else
            case(i)
            
                
                0:
                begin
                    a <= 4'd1;
                    b <= 4'd2;
                    c <= 5'd0;
                    i <= i + 1'b1;
                end
                
                1:
                begin
                    c <= a + b;
                    i <= i + 1'b1;
                end
                
                2:
                begin
                    c <= c + 1'b1; //c+1操作并须在c=a+b完成之后进行
                    i <= i + 1'b1;
                end
                
                3: //拿到最终的c的结果4
                begin
                    dong_sig <= 1'b1;
                    i <= i + 1'b1;
                end
                
                4:
                begin
                    dong_sig <= 1'b0;
                    i <= 4'd4;
                end
                
                
                /*
                0:
                begin
                    a <= 4'd1;
                    b <= 4'd2;
                    c <= 5'd0;
                    i <= i + 1'b1;
                end
                
                //"1"太进行c=a+b操作后 "2"态进行c=c+1操作
                //合并为一个"1"态 c先求得当前态的a+b值 然后c=c+1
                1:
                begin
                    c = a + b;          //此语句将综合成“无延时的”组合逻辑
                    
                    c <= c + 1'b1;      //"1"态的c值仍为0 -- “0”态作用的结果
                    i <= i + 1'b1;
                end
                
                2:                      //一旦到达"2"态 c将变为"1"态的作用结果c=c+1
                begin                   //但计算等式的左值时 c将取得a+b“瞬态”(本态--"1"态)的组合逻辑的结果 即3
                    dong_sig <= 1'b1;   //"1"态3的来源 则是"0"态作用的结果
                    i <= i + 1'b1;
                end
                
                3:
                begin
                    dong_sig <= 1'b0;
                    i <= 4'd3;
                end
                */

            endcase
    end
    
endmodule

