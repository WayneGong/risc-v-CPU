`timescale 1ns/1ns
// the start of module
module irregister(
               //output
                 opc_iraddr,
               //onput
                 data,  //输出数据
                 load_ir,
                 clk,
                 rst   
                 );
             
    //output port             
output[15:0] opc_iraddr;    //the address of oprand instruction 
                            //high four bit is oprond ,low forteen is address
   
    //input ports
input[15:0] data;            //the data from rom or ram
input load_ir;                  //the sigal of load instruction
input clk;                  //system clock
input rst;                  //system reset

    //reg define
reg[15:0] opc_iraddr;      

   //the flip_flop start
always @(posedge clk)
 begin
 if(rst)
   begin
	 opc_iraddr <= 16'b0000_0000_0000_0000;
	end
 else
	 if(load_ir)       //the signal is coming
	    begin
		   opc_iraddr[15:0] <= data;          
	    end
  end
endmodule

//the end of module

	