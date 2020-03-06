`timescale 1ns/1ns
//the start of module
module addr_decode(
	              //input
	               addr,    //the address to decode
	              //output
	               rom_sel,  //the signal of rom select
	               ram_sel   //the signal of ram select
	             );
	//output ports             
output rom_sel,ram_sel;

    //input port
input[11:0] addr;

     //reg define
reg rom_sel,ram_sel;

always @(addr)
 begin
  casex(addr)
    12'b1xxx_xxxx_xxxx: {rom_sel,ram_sel}<= 2'b01;
	12'b0xxx_xxxx_xxxx: {rom_sel,ram_sel}<= 2'b10;
	12'b10xx_xxxx_xxxx: {rom_sel,ram_sel}<= 2'b10;
	default:{rom_sel,ram_sel} <=2'b00;
	endcase
	end
endmodule

//the end of module
	
