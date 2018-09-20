


module led_rgb(
    sysclk,
    rst_n,
    leds
    );
    
    
    input sysclk;
    input rst_n;
    output [2:0]leds;
    
    reg [2:0]rLED;
    
    assign leds = rLED;
    
    reg [25:0]cnt;
    
    always @(posedge sysclk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 26'd0;
        else if (cnt == 26'd59_999_999)
            cnt <= 26'd0;
        else
            cnt <= cnt + 1'b1;
    end
    
    always @(posedge sysclk or negedge rst_n) begin
        if (!rst_n)
            rLED <= 3'b111;
        else if (cnt == 26'd19_999_999)
            rLED <= 3'b110;
        else if (cnt == 26'd39_999_999)
            rLED <= 3'b101;
        else if (cnt == 26'd59_999_999)
            rLED <= 3'b011;
    end
    
endmodule
