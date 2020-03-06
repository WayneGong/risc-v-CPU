`timescale 1ns/1ns
//the start of ram
module rom(
           //output
           data,     //the data
           //input 
            addr,   //the  read address
            read,   //the signal of read
            ena     //the signal of select the ron
            );
   //output ports           
output[15:0] data;
   
   //input ports
input[11:0] addr;
input read,ena;

  //reg define
reg[15:0] memory[12'hfff:0];

  //wire define
wire[15:0] data;

assign data= (read&&ena)?memory[addr]:16'hzzzz;

endmodule
