`timescale 1ns/1ps


module led_rgb_tb();

    reg sysclk;
    reg rst_n;
    wire [2:0]leds;
    
    initial begin
        sysclk = 0;
        rst_n = 0;
    
        #250;
        rst_n = 1;
    
        forever #25 sysclk = ~sysclk;
    end
    
    led_rgb u1(
        .sysclk(sysclk),
        .rst_n(rst_n),
        .leds(leds)
    );
    
    
    
    //仿真用到？
    GSR GSR_INST(.GSR(1'b1));
    PUR PUR_INST(.PUR(1'b1));


endmodule
