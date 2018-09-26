module booth_process_module(
    clk,
    rst_n,
    temp_in,
    item_in,
    temp_out,
    item_out
    );
    
    input clk;
    input rst_n;
    
    input [16:0]temp_in;
    input [15:0]item_in;
    
    output [16:0]temp_out;
    output [15:0]item_out;
    
    /*******************************/
    
    reg [7:0]diff1;
    reg [7:0]diff2;
    
    reg [16:0]temp;
    reg [15:0]item;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            diff1 <= 8'd0;
            diff2 <= 8'd0;
            temp <= 17'd0;
            item <= 16'd0;
        end
        else begin
            diff1 = temp_in[16:9] + item_in[7:0];
            diff2 = temp_in[16:9] + item_in[15:8];
        
            if (temp_in[1:0] == 2'b01)
                temp <= {diff1[7], diff1, temp_in[8:1]};
            else if (temp_in[1:0] == 2'b10)
                temp <= {diff2[7], diff2, temp_in[8:1]};
            else
                temp <= {temp_in[16], temp_in[16:1]};
            
            item <= item_in;
        end
    end
    
    assign temp_out = temp;
    assign item_out = item;
    
endmodule

