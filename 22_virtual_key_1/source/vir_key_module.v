module vir_key_module
(
    input clk,
    input rst_n,
    
    input in_sig,
    output q_sig
);

    reg f1,f2;
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            f1 <= 1'b1;
            f2 <= 1'b1;
        end
        else begin
            f1 <= in_sig;
            f2 <= f1;
        end
    end
    
    /*******************************************************/
    //20MHz
    parameter T8MS = 18'd160000;
    
    /*******************************************************/

    reg [17:0]count;
    reg isCount;
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            count <= 18'd0;
        else if(isCount && count == T8MS)
            count <= 18'd0;
        else if(isCount)
            count <= count + 1'b1;
        else
            count <= 18'd0;
    end
    
    /*******************************************************/

    reg [3:0]i;
    reg isBounce;
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            i <= 4'd0;
            isBounce <= 1'b1;
            isCount <= 1'b0;
        end
        else
            case(i)
                
                0:
                if(f1 != f2)
                    i <= i + 1'b1;
                    
                1,2,3:
                if(count == T8MS) begin
                    isCount <= 1'b0;
                    isBounce <= 1'b0;
                    i <= 4'd8;
                end
                else begin
                    isCount <= 1'b1;
                    isBounce <= 1'b0;   //拉低
                    i <= i + 1'b1;
                end
                
                4,5,6:
                if(count == T8MS) begin
                    isCount <= 1'b0;
                    isBounce <= 1'b0;
                    i <= 4'd8;
                end
                else begin
                    isBounce <= 1'b1;   //拉高
                    i <= i + 1'b1;
                end
                    
                7:
                if(count == T8MS) begin
                    isCount <= 1'b0;
                    isBounce <= 1'b0;
                    i <= 4'd8;
                end
                else
                    i <= 4'd1;
                    
                /*****/
                
                8:
                if(f1 != f2)
                    i <= i + 1'b1;
                    
                9,10,11:
                if(count == T8MS) begin
                    isCount <= 1'b0;
                    isBounce <= 1'b1;
                    i <= 4'd0;
                end 
                else begin
                    isCount <= 1'b1;
                    isBounce <= 1'b1;   //拉高
                    i <= i + 1'b1;
                end
                
                12,13,14:
                if(count == T8MS) begin
                    isCount <= 1'b0;
                    isBounce <= 1'b1;
                    i <= 4'd0;
                end 
                else begin
                    isBounce <= 1'b0;   //拉低
                    i <= i + 1'b1;
                end
                
                15:
                if(count == T8MS) begin
                    isCount <= 1'b0;
                    isBounce <= 1'b1;
                    i <= 4'd0;
                end 
                else
                    i <= 4'd9;
                
            endcase
    end
    
    assign q_sig = isBounce;

endmodule

