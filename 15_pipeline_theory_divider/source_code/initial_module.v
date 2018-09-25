///////////////////////////////////////////////
//
//流水式8bit循环除法器
//从原理上理解的除法器:8bit -> m=7 -> 循环8次
//
//初始化模块:
//填充temp操作空间
//取得被除数和除数正值
//确定被除数和除数正负
///////////////////////////////////////////////

module initial_module(
    clk,
    rst_n,
    dividend,
    divisor,
    temp_out,
    item_out
    );
    
    input clk;
    input rst_n;
    
    input [7:0]dividend;
    input [7:0]divisor;
    
    output [15:0]temp_out;
    output [9:0]item_out; //bit[1]记录被除数正负 bit[0]记录除数正负 bit[9:2]取除数正值
    
    
    /***************************/
    
    reg [15:0]temp;
    reg [9:0]item;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            temp <= 16'd0;
            item <= 10'd0;
        end
        else begin
            temp <= dividend[7] ? {8'd0, (~dividend+1'b1)} : {8'd0, dividend};
            
            // item[9:8] <= {dividend[7], divisor[7]};
            // item[7:0] <= divisor[7] ? (~divisor+1'b1) : divisor; //是否会破坏item[9:8]
            
            item[1:0] <= {dividend[7], divisor[7]};
            item[9:2] <= divisor[7] ? (~divisor+1'b1) : divisor;
        end
    end
    
    assign temp_out = temp;
    assign item_out = item;
    
endmodule

