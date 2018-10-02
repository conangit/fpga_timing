module exp22_top
(
    input clk,
    input rst_n,
    input key_in,
    output pin_out
);


wire u1_q;

vir_key_module u1
(
    .clk(clk),
    .rst_n(rst_n),
    .in_sig(key_in),
    .q_sig(u1_q)
);


debounce_module u2
(
    .CLK(clk),
    .RST_n(rst_n),
    .Pin_In(u1_q),
    .Pin_Out(pin_out)
);

endmodule
