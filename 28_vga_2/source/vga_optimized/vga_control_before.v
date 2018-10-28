
module vga_control_before
(
    clk,
    rst_n,
    ready,
    x_addr,
    y_addr,
    red_sig,
    green_sig,
    blue_sig
);

    input clk;
    input rst_n;
    input ready;
    input [10:0] x_addr;
    input [10:0] y_addr;
    output red_sig;
    output green_sig;
    output blue_sig;

    /****************************/

    //寄存器驱动
    /*
    reg isRect;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
            isRect <= 1'b0;
        else if(x_addr > 11'd0 && y_addr < 11'd100)
            isRect <= 1'b1;
        else
            isRect <= 1'b0;
    end
    */
    /****************************/
    
    wire isRect;
    
    assign isRect = (x_addr >= 11'd0 && y_addr < 11'd100) ? 1'b1 : 1'b0;
    
    //预期显示区域x(0,799)~y(0,99)
    
    /****************************/
    
    assign red_sig = ready && isRect ? 1'b1 : 1'b0;
    assign green_sig = ready && isRect ? 1'b0 : 1'b0;
    assign blue_sig = ready && isRect ? 1'b1 : 1'b0;
    
    //x=2,isRect及时为1;
    //y=101,isRect及时为0;
    //预期显示区域x(2,799)~y(0,101)
    //实际显示区域x(2,799)~y(0,99) ????
    
endmodule

