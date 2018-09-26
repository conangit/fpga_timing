module booth_initial_module(
    clk,
    rst_n,
    a,
    b,
    temp_out,
    item_out
    );
    
    input clk;
    input rst_n;
    
    input [7:0]a;
    input [7:0]b;
    
    output [16:0]temp_out;
    output [15:0]item_out;
    
    /*****************************/
    
    reg [16:0]temp;
    reg [15:0]item;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            temp <= 17'd0;
            item <= 16'd0;
        end
        else begin
            temp <= {8'd0, b, 1'b0};
            item <= {~a + 1'b1, a};
        end
    end
    
    assign temp_out = temp;
    assign item_out = item;
    
endmodule

