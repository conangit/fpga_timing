module exp_module(
    clk,
    rst_n,
    a,
    b,
    c,
    d,
    s
    );
    
    input clk;
    input rst_n;
    
    input [7:0]a;
    input [7:0]b;
    input [7:0]c;
    input [7:0]d;
    
    output [16:0]s;
    
    /************************/
    wire [15:0]s1;
    wire [15:0]s2;
    
    reg [15:0]shift[5:0];
    
    pipeline_booth_multiplier b1(
        .clk(clk),
        .rst_n(rst_n),
        .a(a),
        .b(b),
        .product(s1)
    );
    
    pipeline_lut_multiplier_module l1(
        .clk(clk),
        .rst_n(rst_n),
        .a(c),
        .b(d),
        .product(s2)
    );
    
    //s1比s2延后6个clock
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift[0] <= 16'd0;
            shift[1] <= 16'd0;
            shift[2] <= 16'd0;
            shift[3] <= 16'd0;
            shift[4] <= 16'd0;
            shift[5] <= 16'd0;
        end
        else begin
            shift[0] <= s2;
            shift[1] <= shift[0];
            shift[2] <= shift[1];
            shift[3] <= shift[2];
            shift[4] <= shift[3];
            shift[5] <= shift[4];
        end
    end
    
    assign s = {s1[15], s1} + {shift[5][15], shift[5]};
    
endmodule

