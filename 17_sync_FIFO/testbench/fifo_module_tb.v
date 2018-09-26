`timescale 1ns/1ps

module fifo_module_tb;

    reg clk;
    reg rst_n;
    
    reg write_req;
    reg [7:0]FIFO_write_data;
    
    reg read_req;
    wire [7:0]FIFO_read_data;
    
    wire full_sig;
    wire empty_sig;
    
    initial begin
        clk = 0;
        rst_n = 0;
        
        #250;
        rst_n = 1;
        
        forever #25 clk = ~clk;
    end

    fifo_module u1(
        .clk(clk),
        .rst_n(rst_n),
        .write_req(write_req),
        .FIFO_write_data(FIFO_write_data),
        .read_req(read_req),
        .FIFO_read_data(FIFO_read_data),
        .full_sig(full_sig),
        .empty_sig(empty_sig)
    );
    
    reg [3:0]i;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 4'd0;
            write_req <= 1'b0;
            read_req <= 1'b0;
            FIFO_write_data <= 8'd0;
        end
        else
        
            case(i)
                
                0: //拉高写 写入5
                begin
                    i <= 4'd1;
                    write_req <= 1'b1;
                    FIFO_write_data <= 8'd5;
                end
                
                1:
                begin
                    i <= 4'd2;
                    write_req <= 1'b0;
                end
                
                2: //拉高写 写入6 拉高读
                begin
                    i <= 4'd3;
                    write_req <= 1'b1;
                    FIFO_write_data <= 8'd6;
                    read_req <= 1'b1;
                end
                
                3:
                begin
                    i <= 4'd4;
                    write_req <= 1'b0;
                    read_req <= 1'b0;
                end
                
                4:
                begin
                    i <= 4'd5;
                    read_req <= 1'b1;
                end
                
                5:
                begin
                    i <= 4'd6;
                    read_req <= 1'b0;
                end
                
                6:
                begin
                    i <= 4'd7;
                    write_req <= 1'b1;
                    FIFO_write_data <= 8'd100;
                end
                
                7:
                begin
                    i <= 4'd8;
                    write_req <= 1'b1;
                    FIFO_write_data <= 8'd33;
                    read_req <= 1'b1;
                end
                
                8:
                begin
                    i <= 4'd9;
                    write_req <= 1'b0;
                    read_req <= 1'b1;
                end
                
                9:
                begin
                    i <= 4'd10;
                    write_req <= 1'b1;
                    FIFO_write_data <= 8'd99;
                end
                
                10:
                begin
                    i <= 4'd11;
                    write_req <= 1'b0;
                    read_req <= 1'b1;
                end
                
                11:
                begin
                    i <= 4'd12;
                    read_req <= 1'b0;
                end
                
                12:
                if (full_sig) begin
                    i <= 4'd13;
                    write_req <= 1'b0;
                end
                else begin
                    write_req <= 1'b1;
                    read_req <= 1'b0;
                    FIFO_write_data <= FIFO_write_data + 1'b1;
                end
                
                13:
                if(empty_sig) begin
                    read_req <= 1'b0;
                    i <= 4'd14;
                end
                else begin
                    write_req <= 1'b0;
                    read_req <= 1'b1;
                end
                
                14:
                    i <= 4'd14;

            endcase
    end
    
endmodule















