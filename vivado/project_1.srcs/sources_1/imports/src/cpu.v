//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    2019
// Design Name: 
// Module Name:    cpu 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 16位CPU，包含以下模块：时钟发生器，数据控制器，累加器，算术逻辑运算单元，状态控制器，程序计数器，指令寄存器，地址多路器。
//
// Dependencies: 
//
// Revision: 
// Revision 1.00 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
//`include "CLKSOURCE.v"
//`include "accum.v"
//`include "adr.v"
//`include "alu.v"
//`include "machine.v"
//`include "counter.v"
//`include "machinectl.v"
//`include "irregister.v"
//`include "datactl.v"

`timescale 1ns/1ns
   //the start of module
module cpu(
           //input
            clk,      //时钟信号  
            reset,    //复位信号
           
           //output
            halt,
            rd,     //读信号
            wr,     //写信号
            addr,
            data,
            opcode,
            fetch,
            ir_addr,
            pc_addr
            );
   
  //input ports         
input clk,reset;

  //output ports
output rd,wr,halt;
output[11:0] addr;
output[3:0] opcode;
output fetch;
output[11:0] ir_addr,pc_addr;

 //inout port
inout[15:0] data;

 //wire define
wire clk,reset,halt;

wire[15:0] data;
wire[11:0] addr;

wire[3:0]  opcode;   //the operate code
wire[11:0] ir_addr;  //ir address
wire[11:0] pc_addr;
wire[15:0] alu_out;   //the output of alu
wire[15:0] accum;     //the output of accumulation

wire rd;
wire wr;
wire fetch;              
wire alu_ena;        //the signal of enable alu
wire zero;
wire inc_pc;         //pc clock
wire load_acc;       //load acc signal
wire load_pc;        //load pc signal
wire load_ir;        //load ir signal
wire data_ena;       //data enable
wire contrl_ena;     //the signal of machine is work or not

//the module transfer other module

CLKSOURCE m_CLKSOURCE(.clk(clk),.rst(reset),.fetch(fetch),.alu_ena(alu_ena));

irregister m_irregister(.data(data),.load_ir(load_ir),.rst(reset),.clk(clk),.opc_iraddr({opcode,ir_addr}));

accum m_accum(.data(alu_out),.load_acc(load_acc),.clk(clk),.rst(reset),. accum_out(accum));

alu m_alu(.data(data),.accum(accum),.alu_clk(alu_ena),.opcode(opcode),.alu_out(alu_out),.zero(zero));

machinectl m_machinectl(.clk(clk),.rst(reset),.fetch(fetch),.ena(contrl_ena));

machine m_machine(.inc_pc(inc_pc),.load_acc(load_acc),.load_pc(load_pc),.rd(rd),
                   .wr(wr),.load_ir(load_ir),.clk(clk),.datactl_ena(data_ena),
						 .halt(halt),.zero(zero),.ena(contrl_ena),.opcode(opcode));
						 
datactl m_datactl(.in(alu_out),.data_ena(data_ena),.data(data));

adr  m_adr(.fetch(fetch),.ir_addr(ir_addr),.pc_addr(pc_addr),.addr(addr));

counter m_counter(.clk(inc_pc),.rst(reset),.ir_addr(ir_addr),.load(load_pc),.pc_addr(pc_addr));						 


endmodule

  //the end of module
