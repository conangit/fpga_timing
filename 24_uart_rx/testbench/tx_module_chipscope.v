`timescale 1ns / 1ps

module tx_module_tb(
    input CLK,
    input RST_n
);



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
                Tx_Data <= 8'hAA;
            end
            
            3:
                i <= 4'd3;
            
        endcase
end

//Chipscope
wire [35:0]CONTROL0;
wire [19:0]TRIG0;

chipscope_icon icon_debug(
    .CONTROL0(CONTROL0)
);

chipscope_ila ila_debug(
    .CONTROL(CONTROL0),
    .CLK(CLK),
    .TRIG0(TRIG0)
);


assign TRIG0[0] = Tx_En_Sig;
assign TRIG0[8:1] = Tx_Data;

assign TRIG0[9] = Tx_Done_Sig;
assign TRIG0[10] = Tx_Pin_Out;

assign TRIG0[11] = Rx_Done_Sig;
assign TRIG0[19:12] = Rx_Data;

// assign TRIG0[20] = CLK;


endmodule
