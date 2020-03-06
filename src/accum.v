`timescale  1ns/1ns
//the start of module
module accum(
          //output
            accum_out, 
            
          //input
            data,
            load_acc,
            clk,//时钟信号 
            rst
            );
            
     //output port
output[15:0] accum_out;  //the output of the accumlation

    //input ports
input[15:0] data;       //the data from alum
input load_acc;        //the signal of load the data of accumulation  
input clk;            //the system clock
input rst;            //the system reset
reg[15:0] accum_out;
always @(posedge clk)
  begin
   if(rst)
	   accum_out  <= 16'b0000_0000_0000_0000;
	else
	 if(load_acc)
	   accum_out <= data;
	 end
endmodule

// the end of module
	