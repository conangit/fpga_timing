module booth_multipiler_process_module(
    clk,
    p_i,
    item_i,
    p_o,
    item_o
    );
    
    input clk;
    input [16:0]p_i;
    input [15:0]item_i;
    output [16:0]p_o;
    output [15:0]item_o;
    
    reg [7:0]diff1;
    reg [7:0]diff2;
    
    reg [16:0]pData;
    reg [15:0]itemData;
    
    always @(posedge clk) begin
        diff1 = p_i[16:9] + item_i[7:0];
        diff2 = p_i[16:9] + item_i[15:8];
        
        if (p_i[1:0] == 2'b01)
            pData <= {diff1[7], diff1, p_i[8:1]};
        else if (p_i[1:0] == 2'b10)
            pData <= {diff2[7], diff2, p_i[8:1]};
        else
            pData <= {p_i[16], p_i[16:1]};
            
        itemData <= item_i;
    end
    
    assign p_o = pData;
    assign item_o = itemData;
    
endmodule


