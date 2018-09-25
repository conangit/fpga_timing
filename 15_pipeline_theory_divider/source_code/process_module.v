module process_module(
    clk,
    rst_n,
    temp_in,
    item_in,
    temp_out,
    item_out,
    q
    );
    
    input clk;
    input rst_n;
    
    input [15:0]temp_in;
    input [9:0]item_in;
    
    output [15:0]temp_out;
    output [9:0]item_out;
    
    output q; //记录商的每个bit位
    
    /***************************/
    
    reg [15:0]temp;
    reg [9:0]item;
    reg rQ;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            temp <= 16'd0;
            item <= 10'd0;
            rQ <= 1'b0;
        end
        else begin
            if (temp_in <= (item_in[9:2] << 7)) begin //这里可能存在bug
                temp <= (temp_in << 1);
                rQ <= 1'b0;
            end
            else begin
                temp <= ((temp_in - (item_in[9:2] << 7)) << 1);
                rQ <= 1'b1;
            end
            
            item <= item_in;
        end
    end
    
    assign temp_out = temp;
    assign item_out = item;
    assign q = rQ;
    
endmodule

