module streamlined_divider_demo
(
    input CLK,
     input RSTn,
     
     input Start_Sig,
     input [7:0]Dividend,
     input [7:0]Divisor,
     
     output Done_Sig,
     output [7:0]Quotient,
     output [7:0]Reminder
     
     /**************************/
     
     // output [15:0]SQ_Diff,
     // output [15:0]SQ_Temp
);

    /******************************/
     
     reg [3:0]i;
     reg [8:0]s;
     reg [15:0]Temp;
     reg [15:0]Diff;
     reg isNeg;
     reg isDone;
     
     always @ ( posedge CLK or negedge RSTn )
         if( !RSTn )
              begin
                    i <= 4'd0;
                     s <= 9'd0;
                     Temp <= 16'd0;
                     Diff <= 16'd0;
                     isNeg <= 1'b0;
                     isDone <= 1'b0;
                end
          else if( Start_Sig )
              case( i )
                
                    0:
                     begin
                         
                         isNeg <= Dividend[7] ^ Divisor[7];
                          s <= Divisor[7] ? { 1'b1, Divisor } : { 1'b1 , ~Divisor + 1'b1 };
                          Temp <= Dividend[7] ? { 8'd0 , ~Dividend + 1'b1 } : { 8'd0 , Dividend };
                          Diff <= 16'd0;
                          i <= i + 1'b1;
                          
                     end
                     
                     1,2,3,4,5,6,7,8:
                     begin 
                         
                          Diff = Temp + { s , 7'd0 }; 
                          
                          if( Diff[15] ) Temp <= { Temp[14:0] , 1'b0 }; 
                        else Temp <= { Diff[14:0] , 1'b1 }; 
                     
                         i <= i + 1'b1;
                          
                end
                     
                     9:
                     begin isDone <= 1'b1; i <= i + 1'b1; end
                     
                     10:
                     begin isDone <= 1'b0; i <= 2'd0; end
                
                
                endcase
                
    /*********************************/
     
     assign Done_Sig = isDone;
     assign Quotient = isNeg ? ( ~Temp[7:0] + 1'b1 ) : Temp[7:0];
     assign Reminder = Temp[15:8];
     
     /**********************************/
     
     // assign SQ_Diff = Diff;
     // assign SQ_Temp = Temp;
        
     /**********************************/
     
 
endmodule
