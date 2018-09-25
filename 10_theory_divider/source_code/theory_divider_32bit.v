//////////////////////////////////////////////////////////////////////
//此除法器遵行
//商的符号由被除数和除数共同决定
//余数的符号跟随被除数
/////////////////////////////////////////////////////////////////////

module theory_divider_32bit(
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
    input [31:0]dividend;
    input [31:0]divisor;
    
    output dong_sig;
    output [31:0]quotient;
    output [31:0]reminder;
    
    /******************************/
    
    reg [63:0]temp; //操作空间(含被除数)
    reg [31:0]rData; //除数取正
    
    /******************************/
    
    reg isDone;
    reg isqNeg;
    reg isrNeg;
    reg [31:0]q;
    reg [31:0]r;
    
    /******************************/
    
    reg [5:0]i;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            temp <= 64'd0;
            rData <= 32'd0;
            isqNeg <= 1'b0;
            isrNeg <= 1'b0;
            q <= 32'd0;
            r <= 32'd0;
            isDone <= 1'b0;
            i <= 6'd0;
        end
        else if (start_sig)
            
            case(i)
                
                0:
                begin
                    isqNeg <= dividend[31]^divisor[31];
                    isrNeg <= dividend[31];
                    temp <= dividend[31] ? {32'd0, (~dividend + 1'b1)} : {32'd0, dividend};
                    rData <= divisor[31] ? (~divisor + 1'b1) : divisor;
                    q <= 32'd0;
                    r <= 32'd0;
                    i <= i + 1'b1;
                end
                
                1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32:
                if (temp <= (rData<<31)) begin
                    temp <= temp << 1;
                    q[32-i] <= 1'b0;
                    i <= i + 1'b1;
                end
                else begin
                    temp <= (temp - (rData<<31)) << 1;
                    q[32-i] <= 1'b1;
                    i <= i + 1'b1;
                end

                33:
                begin
                    isDone <= 1'b1;
                    i <= i + 1'b1;
                end
                
                34:
                begin
                    isDone <= 1'b0;
                    i <= 6'd0;
                end
                
            endcase
    end
    
    
    assign dong_sig = isDone;
    assign quotient = isqNeg ? (~q + 1'b1) : q;
    assign reminder = isrNeg ? (~temp[63:32] + 1'b1) : temp[63:32];

endmodule

