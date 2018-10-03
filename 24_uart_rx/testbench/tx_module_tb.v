`timescale 1ns / 1ps

module tx_module_tb;

reg CLK;
reg RST_n;

reg Tx_En_Sig;
reg [7:0]Tx_Data;

wire Tx_Done_Sig;
wire Tx_Pin_Out;

wire Rx_Done_Sig;
wire [7:0]Rx_Data;

tx_module u1(
    .CLK(CLK),
    .RST_n(RST_n),
    .Tx_En_Sig(Tx_En_Sig),
    .Tx_Data(Tx_Data),
    .Tx_Done_Sig(Tx_Done_Sig),
    .Tx_Pin_Out(Tx_Pin_Out)
);


rx_module u2(
    .CLK(CLK),
    .RST_n(RST_n),
    .Rx_Pin_In(Tx_Pin_Out),
    .Rx_En_Sig(1'b1),
    .Rx_Done_Sig(Rx_Done_Sig),
    .Rx_Data(Rx_Data)
);


initial begin
    CLK = 0;
    RST_n = 0;
    
    #1000;
    RST_n = 1;
    
    //50MHz
    forever #10 CLK = ~CLK;
end

reg [3:0]i;

always @(posedge CLK or negedge RST_n) begin
    if (!RST_n) begin
        i <= 4'd0;
        Tx_En_Sig <= 1'b0;
        Tx_Data <= 8'd0;
    end
    else
        case(i)
            
            0:
            if(Tx_Done_Sig) begin
                i <= i + 1'b1;
                Tx_En_Sig <= 1'b0;
            end
            else begin
                Tx_En_Sig <= 1'b1;
                Tx_Data <= 8'h2E;
            end
    
            1:
            if(Tx_Done_Sig) begin
                i <= i + 1'b1;
                Tx_En_Sig <= 1'b0;
            end
            else begin
                Tx_En_Sig <= 1'b1;
                Tx_Data <= 8'h3F;
            end
            
            2:
            if(Tx_Done_Sig) begin
                i <= i + 1'b1;
                Tx_En_Sig <= 1'b0;
            end
            else begin
                Tx_En_Sig <= 1'b1;
                Tx_Data <= 8'hDD;
            end
            
            3:
                i <= 4'd3;
            
        endcase
end


endmodule
