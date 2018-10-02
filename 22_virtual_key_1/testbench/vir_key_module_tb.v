`timescale 1ns/1ps

module vir_key_module_tb;

    reg clk;
    reg rst_n;
    
    reg in_sig;
    wire q_sig;
    
    vir_key_module u1
    (
        .clk(clk),
        .rst_n(rst_n),
        .in_sig(in_sig),
        .q_sig(q_sig)
    );
    
    initial begin
    rst_n = 0;
    #1000;
    rst_n = 1;
    
    clk = 0;
    forever #25 clk = ~clk;
    end
    
    /***************************/
    
    parameter T1MS = 15'd20000;
    
    reg [14:0]count;
    reg [9:0]count_ms;
    reg [9:0]rTime;
    reg isCount;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 15'd0;
            isCount <= 1'b0;
        end
        else if(isCount && count_ms ==rTime) begin
            count <= 15'd0;
            count_ms <= 10'd0;
        end
        else if(isCount && count == T1MS) begin
            count <= 15'd0;
            count_ms <= count_ms + 1'b1;
        end
        else if(isCount)
            count <= count + 1'b1;
        else if(!isCount) begin
            count <= 15'd0;
            count_ms <= 10'd0;
        end
    end
    
    /***************************/
    
    reg [3:0]i;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 4'd0;
            in_sig <= 1'b1;
            isCount <= 1'b0;
            rTime <= 10'd0; //这里初始值为0 那么在接下来的判断条件商必须做些处理 否则电路复位即 count_ms(0) == rTime(0)
        end
        else
            case(i)
            
                0:
                if(isCount && count_ms == rTime) begin
                    isCount <= 1'b0;
                    i <= i + 1'b1;
                end
                else begin
                    isCount <= 1'b1;
                    rTime <= 10'd1;
                end
                
                1:
                begin
                    in_sig <= 1'b0;
                    i <= i + 1'b1;
                end
                
                2:
                if(isCount && count_ms == rTime) begin
                    isCount <= 1'b0;
                    i <= i + 1'b1;
                end
                else begin
                    isCount <= 1'b1;
                    rTime <= 10'd12;
                end
                
                3:
                begin
                    in_sig <= 1'b1;
                    i <= 4'd3;
                end
            endcase
    end
    
endmodule

