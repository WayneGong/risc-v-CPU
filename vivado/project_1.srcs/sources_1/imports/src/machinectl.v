`timescale 1ns/1ns

module machinectl(
                //output
                  ena,   //the singal of control machine
                //input
                 fetch,  // the signal of machine start work
                 rst,   // system reset
                 clk    //system clk，时钟
                  );
      // input ports
input fetch;
input rst;
input clk;
     
     //output ports
output ena;

    //reg define
reg ena;


always @(posedge  clk)
  begin
    if(rst)
	   begin
	    ena <= 0;
	   end
    else
       if(fetch)
        begin
         ena <= 1;
        end
   end
 endmodule
 
 //the end of module
 