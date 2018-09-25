//////////////////////////////////////////////////////////////////////
//此除法器遵行
//商的符号由被除数和除数共同决定
//余数的符号跟随被除数
/////////////////////////////////////////////////////////////////////

module theory_divider_8bit(
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
    
    reg [15:0]temp; //操作空间(含被除数)
    reg [7:0]rData; //除数取正
    
    /******************************/
    
    reg isDone;
    reg isqNeg;
    reg isrNeg;
    reg [7:0]q;
    reg [7:0]r;
    
    /******************************/
    
    reg [3:0]i;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            temp <= 16'd0;
            rData <= 8'd0;
            isqNeg <= 1'b0;
            isrNeg <= 1'b0;
            q <= 8'd0;
            r <= 8'd0;
            isDone <= 1'b0;
            i <= 4'd0;
        end
        else if (start_sig)
            
            case(i)
                
                0:
                begin
                    isqNeg <= dividend[7]^divisor[7];
                    isrNeg <= dividend[7];
                    
                    // temp <= 16'd0;
                    // temp <= {8'd0, dividend};
                    temp <= dividend[7] ? {8'd0, (~dividend + 1'b1)} : {8'd0, dividend};
                    
                    rData <= divisor[7] ? (~divisor + 1'b1) : divisor;
                    
                    q <= 8'd0;
                    r <= 8'd0;
                    i <= i + 1'b1;
                end
                
                1,2,3,4,5,6,7,8:
                if (temp <= (rData<<7)) begin
                    temp <= temp << 1;
                    q[8-i] <= 1'b0;
                    i <= i + 1'b1;
                end
                else begin
                    temp <= (temp - (rData<<7)) << 1;
                    q[8-i] <= 1'b1;
                    i <= i + 1'b1;
                end

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
    
    
    assign dong_sig = isDone;
    assign quotient = isqNeg ? (~q + 1'b1) : q;
    
    // temp/2^(7+1) = temp / 2^8
    assign reminder = isrNeg ? (~temp[15:8] + 1'b1) : temp[15:8];

endmodule

