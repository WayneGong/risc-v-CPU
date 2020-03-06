`include "ram.v"
`include "rom.v"
`include "addr_decode.v"
`include "CLKSOURCE.v"
`include "accum.v"
`include "adr.v"
`include "alu.v"
`include "machine.v"
`include "counter.v"
`include "machinectl.v"
`include "irregister.v"
`include "datactl.v"

`timescale 1ns/1ns
`define PERIOD 100
module cputop;
reg reset_req,clock;
integer test;
reg[31:0] mnemonic; //array that holds 4 8 bit ascii characters
reg[11:0] PC_addr,IR_addr;
wire[15:0] data;
wire[11:0] addr;
wire rd,wr,halt,ram_sel,rom_sel;
wire[3:0] opcode;
wire fetch;
wire[11:0] ir_addr,pc_addr;

//-----cpu模块与地址译码器和ROM，RAM的连接部分------------
cpu t_cpu(.clk(clock),.reset(reset_req),.halt(halt),.rd(rd),.wr(wr),.addr(addr),
           .data(data),.opcode(opcode),.fetch(fetch),.ir_addr(ir_addr),.pc_addr(pc_addr));
ram t_ram(.addr(addr[8:0]),.read(rd),.write(wr),.ena(ram_sel),.data(data));
rom t_rom(.addr(addr),.read(rd),.ena(rom_sel),.data(data));
addr_decode t_addr_decode(.addr(addr),.ram_sel(ram_sel),.rom_sel(rom_sel));

//-----CPU模块与地址译码器和ROM,RAM的连接部分结束-----------
initial
  begin
    clock = 1;
	 //display time in nanoseconds
	 $timeformat(-9,1,"ns",12);
	 display_debug_message;
	 sys_reset;
	 test1;
	 $stop;
	 test2;
	 $stop;
	 test3;
	 $finish;  //simulation is finish here
	end
task display_debug_message;
  begin
  $display("\********************************************");
  $display("  * THE FOLLOW DEBUG TASK ARE AVAILABLE :*   ");
  $display("*\"test1;\"to load the 1st diagnostic program. *");
  $display("*\"test2;\"to load the 2nd diagnostic program. *");
  $display("*\"test3;\"to load the Fibonacci program. *");
  $display("*******************************************\n");
 end
endtask
task test1;
 begin
 test=0;
   disable MONITOR;
   $readmemb("test1.pro",t_rom.memory);
   $display("rom loaded successfully!");
   $readmemb("test1.dat",t_ram.ram);
   $display("ram loaded successfully!");
   #1 test = 1;
   #34800;
   sys_reset;
 end
endtask
 
task test2;
 begin
  test=0;
   disable MONITOR;
   $readmemb("test2.pro",t_rom.memory);
   $display("rom loaded successfully!");
   $readmemb("test2.dat",t_ram.ram);
   $display("ram loaded successfully!");
   #1 test = 2;
   #11600;
   sys_reset;
 end 
 endtask
 
 task test3;
 begin
   test=0;
   disable MONITOR;
   $readmemb("test3.pro",t_rom.memory);
   $display("rom loaded successfully!");
   $readmemb("test3.dat",t_ram.ram);
   $display("ram loaded successfully!");
   #1 test = 3;
   #94000;
   sys_reset;
 end 
 endtask
 
task sys_reset;
    begin
	   reset_req = 0;
		#(`PERIOD*0.7) reset_req  = 1;
		#(1.5*`PERIOD) reset_req  = 0;
  	 end
 endtask
 
 always @(test)
    begin:MONITOR
	   case(test)
		1:
		   begin
		$display("\n***RUNNING CPU test1 - THE BASIC CPU Diagnostic Program ***");
		$display("\n   TIME  PC  INSTR ADDR DATA");
		$display(" -------- -----  ------ ----- -----");
		while(test==1)
		 @(t_cpu.m_adr.pc_addr)
		 if(t_cpu.m_adr.fetch == 1)
		 begin
		  # 120  PC_addr <= t_cpu.m_adr.pc_addr;
		         IR_addr <= t_cpu.m_adr.ir_addr;
		  #340  $strobe("%t  %h  %s  %h  %h",$time,PC_addr,mnemonic,IR_addr,data);
		  end
		  end
		  
	  2:
		   begin
		$display("\n***RUNNING CPU test2 - THE Advanced CPU Diagnostic Program ***");
		$display("\n   TIME  PC  INSTR ADDR DATA");
		$display(" -------- -----  ------ ----- -----");
		while(test==2)
		 @(t_cpu.m_adr.pc_addr)
		 if((t_cpu.m_adr.pc_addr%2==1)&&(t_cpu.m_adr.fetch == 1))
		 begin
		  # 60  PC_addr <= t_cpu.m_adr.pc_addr - 1;
		        IR_addr <= t_cpu.m_adr.ir_addr;
		  #340  $strobe("%t  %h  %s  %h  %h",$time,PC_addr,mnemonic,IR_addr,data);
		  end
	end
	
   3:
	 begin
		$display("\n***RUNNING CPU test3 - THE EXCEUTABLE CPU Diagnostic Program ***");
		$display("\n***This Pogram should calculate the fibonacci *****");
		$display("\n   TIME FIBONACCI NUMBER");
		$display(" -------- -----  ------ ----- -----");
		while(test==3)
		 begin
		    wait(t_cpu.m_alu.opcode == 3'h1)
			 $strobe("%t  %d ",$time,t_ram.ram[10'h2]);
			 wait(t_cpu.m_alu.opcode != 3'h1);
		  end
	  end	
	endcase
end

always @(posedge halt)
   begin
     #500 
	  $display("\n***********************************************");
	  $display("*** A HALT INSTRUCTION WAS PROCESSED!!!**");
	  $display("************************************************\n");
	  end
always #(`PERIOD/2) clock = ~clock;
always @(t_cpu.opcode)
    case(t_cpu.m_alu.opcode)
	  4'b0000: mnemonic = "HLT";
	  4'b0001: mnemonic = "SKZ";
	  4'b0010: mnemonic = "ADD";
	  4'b0011: mnemonic = "SUB"; 
	  4'b0100: mnemonic = "MUL";
	  4'b0101: mnemonic = "OR"; 
	  4'b0110: mnemonic = "AND";
	  4'b0111: mnemonic = "XOR";
	  
	  4'b1000: mnemonic = "NOT";
	  4'b1001: mnemonic = "STO";
	  4'b1010: mnemonic = "LDA";
	  4'b1011: mnemonic = "RL"; 
	  4'b1100: mnemonic = "RR";
	  4'b1101: mnemonic = "JMP"; 
	  4'b1110: mnemonic = "POP";
	  4'b1111: mnemonic = "PUSH";
	  
	  default :mnemonic = "????";
	 endcase	  
endmodule
