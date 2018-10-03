`timescale 1ns/1ps

module function_module_tb;

    reg clk;
    reg rst_n;
    
    reg [1:0]func_start_sig;
    reg [7:0]words_addr;
    reg [7:0]write_data;
    
    wire func_done_sig;
    wire [7:0]read_data;
    
    wire rtc_rst;
    wire rtc_sclk;
    
    /**重点来了**/
    wire rtc_sio;
    reg treg_sio;
    assign rtc_sio = treg_sio;
    
    wire [5:0]sq_i;
    
    /*************************************/
    
    function_module u1
    (
        .CLK(clk),
        .RSTn(rst_n),
        .func_start_sig(func_start_sig),
        .words_addr(words_addr),
        .write_data(write_data),
        .read_data(read_data),
        .func_done_sig(func_done_sig),
        .rtc_rst(rtc_rst),
        .rtc_sclk(rtc_sclk),
        .rtc_sio(rtc_sio),
        .sq_i(sq_i)
    );
    
    initial begin
        clk = 0;
        rst_n = 0;
        
        #1000;
        rst_n = 1;
        
        forever #10 clk = ~clk;
    end
    
    /*************************************/
    
    reg [3:0]i;
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            i <= 4'd0;
            func_start_sig <= 2'b00;
            words_addr <= 8'd0;
            write_data <= 8'd0;
        end
        else
            case(i)
            
                0:
                if(func_done_sig) begin
                    func_start_sig <= 2'b00;
                    i <= i + 1'b1;
                end
                else begin
                    func_start_sig <= 2'b10; //write
                    words_addr <= 8'hF0;
                    write_data <= 8'hF2;
                end
                
                1:
                if(func_done_sig) begin
                    func_start_sig <= 2'b00;
                    i <= i + 1'b1;
                end
                else begin
                    func_start_sig <= 2'b01; //read 此时应有另一方在驱动IO
                    words_addr <= 8'hF0;
                end
                
                2:
                    i <= 4'd2;
                    
            endcase
    end
    
    /*************************************/
    
    reg [7:0]ds1302_data;
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            treg_sio <= 1'b0;
            ds1302_data <= 8'h55;
        end
        else if(func_start_sig == 2'b01)
            case(sq_i)
                
                18: treg_sio <= ds1302_data[0];
                20: treg_sio <= ds1302_data[1];
                22: treg_sio <= ds1302_data[2];
                24: treg_sio <= ds1302_data[3];
                26: treg_sio <= ds1302_data[4];
                28: treg_sio <= ds1302_data[5];
                30: treg_sio <= ds1302_data[6];
                32: treg_sio <= ds1302_data[7];
                
                // default: treg_sio <= 1'bz;
                
            endcase
    end

endmodule

