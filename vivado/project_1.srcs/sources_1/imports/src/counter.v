`timescale 1ns/1ns
//the start of module

module counter(
           //output
             pc_addr,   //PC地址
           //input  
             ir_addr,
             load,
             clk,
             rst);
    
    //output port         
output[11:0] pc_addr;
    
    //input ports
input[11:0] ir_addr;  //the loading pc adress
input load;    //the signal of load pc
input clk;    //the clock of load pc 
input rst;    //the reset of pc 

   //reg define
reg[11:0] pc_addr;


always @(posedge clk or posedge rst)
  begin
   if(rst)
	  pc_addr <= 12'b0000_0000_0000;
	else
	 if(load)
	   pc_addr <= ir_addr;
	 else
	   pc_addr <= pc_addr + 12'b1;
	end
endmodule
 //the end of module