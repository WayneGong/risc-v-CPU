`timescale 1ns/1ns
//the start of ram
module ram(
         //inout
          data,       //the data
          //input
          addr,     //the write or read address
          ena,      //the signal of select the ram
          read,     //the signal of read
          write     //the singal of write
          );
  //inout ports
inout [15:0] data;
  //input ports
input [8:0] addr;
input ena;
input read,write;
reg[15:0] ram[9'h1ff:0];

assign data= (read&&ena)?ram[addr]:16'hzz;

always @(posedge write)
 begin
  ram[addr] <= data;
 end
endmodule
