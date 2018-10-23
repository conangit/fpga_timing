

module count_status
(
    input clk,
    input rst_n,
    
    output [3:0] _i,
    output [3:0] _index
);


    reg [3:0] i;
    reg [3:0] index;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            // i <= 4'd0;
            i <= 4'd2;
            index <= 4'd1;
        end
        else
        begin
            case(i)
            
                0:
                begin
                    i <= 1;
                    index <= 4'd5;
                end
                
                1:
                begin
                    i <= 2;
                    index <= 4'd12;
                end
                
                2:
                begin
                    i <= 3;
                    index <= 4'd7;
                end
                
                3:
                begin
                    i <= 0;
                    index <= 4'd0;
                end
            
            endcase
        end
    end
    
    assign _i = i;
    assign _index = index;
    
endmodule

