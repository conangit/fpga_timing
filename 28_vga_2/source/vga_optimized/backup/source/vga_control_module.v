

module vga_control_module(
    vga_clk,
    rst_n,
    Ready_Sig,
    Column_Addr_Sig,
    Row_Addr_Sig,
    Red_Sig,
    Green_Sig,
    Blue_Sig
    );
    
    input vga_clk;
    input rst_n;
    input Ready_Sig;
    input [11:0]Column_Addr_Sig;
    input [11:0]Row_Addr_Sig;
    
    output [4:0]Red_Sig;
    output [5:0]Green_Sig;
    output [4:0]Blue_Sig;
    
    
    reg [4:0] w_Red_Sig;
    reg [5:0] w_Green_Sig;
    reg [4:0] w_Blue_Sig;
    
    /*
     * 总结：
     * 1. 千万不要忘了Ready_Sig信号
     * 2. if else 语句是否覆盖全面
     */
    
    always @(posedge vga_clk or negedge rst_n) begin
        if (!rst_n) begin // 黑色
            w_Red_Sig   <= 5'b0_0000;
            w_Green_Sig <= 6'b00_0000;
            w_Blue_Sig  <= 5'b0_0000;
        end
        else if (Ready_Sig && (12'd0 <= Column_Addr_Sig && Row_Addr_Sig < 12'd100)) begin // 0 * 100的区域 红绿蓝混合为白色
            w_Red_Sig   <= 5'b1_1111;
            w_Green_Sig <= 6'b11_1111;
            w_Blue_Sig  <= 5'b1_1111;
        end
        else if (Ready_Sig && (12'd0 <= Column_Addr_Sig && 12'd100 <= Row_Addr_Sig && Row_Addr_Sig < 12'd200)) begin // 红色
            w_Red_Sig   <= 5'b1_1111;
            w_Green_Sig <= 6'b00_0000;
            w_Blue_Sig  <= 5'b0_0000;
        end
        else if (Ready_Sig && (12'd0 <= Column_Addr_Sig && 12'd200 <= Row_Addr_Sig && Row_Addr_Sig < 12'd300)) begin // 绿色
            w_Red_Sig   <= 5'b0_0000;
            w_Green_Sig <= 6'b11_1111;
            w_Blue_Sig  <= 5'b0_0000;
        end
        else if (Ready_Sig && (12'd0 <= Column_Addr_Sig && 12'd300 <= Row_Addr_Sig && Row_Addr_Sig < 12'd400)) begin // 蓝色
            w_Red_Sig   <= 5'b0_0000;
            w_Green_Sig <= 6'b00_0000;
            w_Blue_Sig  <= 5'b1_1111;
        end
        else begin
            w_Red_Sig   <= 5'b0_0000;
            w_Green_Sig <= 6'b00_0000;
            w_Blue_Sig  <= 5'b0_0000;
        end
    end

    assign Red_Sig   = w_Red_Sig;
    assign Green_Sig = w_Green_Sig;
    assign Blue_Sig  = w_Blue_Sig; 
    
endmodule

