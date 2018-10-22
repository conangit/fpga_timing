`timescale 1ps/1ps


module testbench_2;

    
    reg vga_clk;
    reg rst_n;
    
    wire VSYNC_Sig;
    wire HSYNC_Sig;
    
    wire Ready_Sig;
    wire [10:0] Column_Addr_Sig;
    wire [10:0] Row_Addr_Sig;
    
    
    
    vga_sync_module_800_600_60_after u1
    (
        .vga_clk(vga_clk),
        .rst_n(rst_n),
        .VSYNC_Sig(VSYNC_Sig),
        .HSYNC_Sig(HSYNC_Sig),
        .Ready_Sig(Ready_Sig),
        .Column_Addr_Sig(Column_Addr_Sig),
        .Row_Addr_Sig(Row_Addr_Sig)
    );
    
    initial
    begin
    
    rst_n = 0;
    vga_clk = 0;
    
    #1000_000; //1us
    rst_n = 1;
    
    forever #12500 vga_clk = ~vga_clk; //40MHz
    
    end
    
endmodule

