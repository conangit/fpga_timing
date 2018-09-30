`timescale 1ns/1ps

module exp20_top_tb;

    reg clk;
    reg rst_n;
    reg write_req;
    reg [15:0]fifo_write_data;
    wire [4:0]left_sig;
    wire [15:0]product;

    exp20_top t1(
        .clk(clk),
        .rst_n(rst_n),
        .write_req(write_req),
        .fifo_write_data(fifo_write_data),
        .a_left_sig(left_sig),
        .product(product)
    );
    
    
    initial begin
        clk = 0;
        rst_n = 0;
        
        #10;
        rst_n =1;
        
        forever #25 clk = ~clk;
    end
    
    reg [3:0]i;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 4'd0;
            write_req <= 1'b0;
            fifo_write_data <= 16'd0;
        end
        else
            case(i)
                
                0:
                if(left_sig >= 1) begin
                    write_req <= 1'b1;
                    fifo_write_data <= {8'd45, 8'd2};       //45/2=22...1  22*1=22
                    i <= i + 1'b1;
                end
                else
                    write_req <= 1'b0;
                    
                1:
                if(left_sig >= 1) begin
                    write_req <= 1'b1;
                    fifo_write_data <= {8'd23, 8'd12};      //23/12=1...11  1*11=11
                    i <= i + 1'b1;
                end
                else
                    write_req <= 1'b0;

                2:
                if(left_sig >= 1) begin
                    write_req <= 1'b1;
                    fifo_write_data <= {8'd15, 8'b1111_1010}; //15/-6=-2...3  -2*3=-6
                    i <= i + 1'b1;
                end
                else
                    write_req <= 1'b0;
                    
                3:
                begin
                    write_req <= 1'b0;
                    i <= 4'd3;
                end
            
            endcase
    end
    
    GSR GSR_INST(.GSR(1'b1));
    PUR PUR_INST(.PUR(1'b1));
    
    
endmodule

