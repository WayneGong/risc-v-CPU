`timescale  1ns/1ns
// module start
module CLKSOURCE(
              //input 
              clk,      //时钟信号 
              rst,
              
             //output
              fetch,
              alu_ena);
              
  //input ports
  
input  clk;        //system clk
input  rst;      //system reset ,low is active

  //output ports
  
output fetch;      //the signal of control instruction address and data address
output alu_ena;    //the signal of control logic accumulation

  //reg define
reg fetch;   
reg alu_ena;
reg[5:0] state;    //state machine to product signal which the cpu used
 
  //wire define 
wire clk;
wire rst;

  //parameter define
parameter    S1 = 8'b000001,
             S2 = 8'b000010,
			 S3 = 8'b000100,
             S4 = 8'b001000,
			 S5 = 8'b010000,
             S6 = 8'b100000,
		   idle = 8'b000000;
		   
// the flip-flop start
always @(negedge  clk)
  if(rst)
   begin
	 fetch   <= 0;
	 alu_ena <= 0;
	 state   <= idle;   //the initial of state machine
	end
	else
	  begin
	     case(state)    //machine start
		  S1:
		      begin
				 
				  state   <= S2; 
				 end  
		  S2:
		      begin
				  alu_ena <= 1;
				  state   <= S3;
				 end
		  S3:
		       begin
			   alu_ena <= 0;
				 fetch <= 1;
				 state <= S4;
				end
		  S4: state <= S5;
		  S5: state <= S6;
		  S6: begin 
		          state <= S1;
		           fetch <= 0;
		       end
		  idle: state <= S1;
		  default:state <= idle;
		  endcase
		 end
endmodule
	
//the end of module			 
			 
			 