`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:55:24 10/01/2018
// Design Name:   exp20_top
// Module Name:   D:/Program/FPGA/fpga_modelsim/20_mix_module_ip/testbench/testbench.v
// Project Name:  fifo_ip_interface
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: exp20_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench;

    // Inputs
    reg clk;
    reg rst_n;
    reg write_req;
    reg [15:0] fifo_write_data;

    // Outputs
    wire full_out;
    wire done_sig;
    wire [15:0] product;

    // Instantiate the Unit Under Test (UUT)
    exp20_top uut (
        .clk(clk), 
        .rst_n(rst_n), 
        .write_req(write_req), 
        .fifo_write_data(fifo_write_data), 
        .full_out(full_out), 
        .done_sig(done_sig), 
        .product(product)
    );

    initial begin
        // Initialize Inputs
        clk = 0;
        rst_n = 0;
        write_req = 0;
        fifo_write_data = 0;

        // Wait 100 ns for global reset to finish
        #100;
        rst_n = 1;
        forever #10 clk = ~clk;
        
        // Add stimulus here

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
                if(!full_out) begin
                    write_req <= 1'b1;
                    fifo_write_data <= {8'd45, 8'd2};       //45/2=22...1  22*1=22
                    i <= i + 1'b1;
                end
                else
                    write_req <= 1'b0;
                    
                1:
                if(!full_out) begin
                    write_req <= 1'b1;
                    fifo_write_data <= {8'd23, 8'd12};      //23/12=1...11  1*11=11
                    i <= i + 1'b1;
                end
                else
                    write_req <= 1'b0;

                2:
                if(!full_out) begin
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
    
      
endmodule

