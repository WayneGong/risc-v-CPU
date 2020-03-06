`timescale 1ns/1ns
//the start of module
module machine(
            //output
            inc_pc,      //the clock of pc 
            load_acc,   //the signal of load the value of accumulation
            load_pc,    //the signal of load pc
            rd,         //the signal of read rom or ram
            wr,         //the signal of write rom of ram
            load_ir,    //the signal of load instruction 
            datactl_ena, //the signal of data is using
            halt,       //the signal of halt machine
           //input 
            clk,        //the system clock，系统时钟
            zero,       //the flag whether accumulation's value is zero or not
            ena,        //the signal of machine is work or not
            opcode      //the operate code
            );
            
 //output ports
output inc_pc,load_acc,load_pc,rd,wr,load_ir;
output datactl_ena,halt;

 //input ports
input clk,zero,ena;
input[3:0] opcode;

  //reg define
reg inc_pc,load_acc,load_pc,rd,wr,load_ir;
reg datactl_ena,halt;
reg[2:0] state;

  //parameter define
parameter       HLT  = 4'b0000,
                SKZ  = 4'b0001,
			    ADD  = 4'b0010,
			    SUB  = 4'b0011,
			    MUL  = 4'b0100,
			    OR   = 4'b0101,
			    AND  = 4'b0110,
			    XOR  = 4'b0111,
			    NOT  = 4'b1000,
			    STO  = 4'b1001,
			    LDA  = 4'b1010,
			    RL   = 4'b1011,
			    RR   = 4'b1100,
			    JMP  = 4'b1101,
			    POP  = 4'b1110,
			    PUSH = 4'b1111;
			 
always @(negedge clk)
 begin
   if(!ena)
	  begin
	        state <= 3'b000;
		{inc_pc,load_acc,load_pc,rd}  <= 4'b0000;
		{wr,load_ir,datactl_ena,halt} <= 4'b0000;
	  end
   else
     ctl_cycle;
 end
 //---------begin of task ct_cycle-------
 task ctl_cycle;
  begin
  casex(state)
  
	3'b000:       //pc inceased by one then load low 8bit instruction
	      begin
		    {inc_pc,load_acc,load_pc,rd}   <= 4'b1001;
		    {wr,load_ir,datactl_ena,halt}  <= 4'b0100;
			    state <= 3'b001;
			 end 
	3'b001: //idle
	       begin
		    {inc_pc,load_acc,load_pc,rd}   <= 4'b0000;
		    {wr,load_ir,datactl_ena,halt}  <= 4'b0000;
			    state <= 3'b010;
			 end 
	3'b010: // next instruction address setup
	         begin
				 if(opcode==HLT)
				   begin
				    {inc_pc,load_acc,load_pc,rd}   <= 4'b0000;
		            {wr,load_ir,datactl_ena,halt}  <= 4'b0001;
					end
				 else
				    begin 
					   {inc_pc,load_acc,load_pc,rd}   <= 4'b0000;
		               {wr,load_ir,datactl_ena,halt}  <= 4'b0000;
					 end
					    state <= 3'b011;
				end
	3'b011:  // fetch opand
	         begin
	              if(opcode==JMP)
					   begin
					     {inc_pc,load_acc,load_pc,rd}   <= 4'b0010;
		                 {wr,load_ir,datactl_ena,halt}  <= 4'b0000;
					   end
			      else
				   if(opcode==ADD||opcode==AND||opcode==XOR||opcode==LDA||
				      opcode==NOT||opcode==MUL||opcode==SUB||opcode==OR||
				      opcode==RL||opcode==RR||opcode==POP||opcode==PUSH) 
					  begin
					    {inc_pc,load_acc,load_pc,rd}   <= 4'b0001;
		                {wr,load_ir,datactl_ena,halt}  <= 4'b0000;
					  end
					else
					 if(opcode==STO)
					   begin
					     {inc_pc,load_acc,load_pc,rd}   <= 4'b0000;
		                 {wr,load_ir,datactl_ena,halt}  <= 4'b0010;
					   end
					  else
					    begin
						  {inc_pc,load_acc,load_pc,rd}   <= 4'b0000;
		                  {wr,load_ir,datactl_ena,halt}  <= 4'b0000;
						 end
					   state <= 3'b100;
				end
	3'b100: //operation
	        begin
			    if(opcode==ADD||opcode==AND||opcode==XOR||opcode==LDA||
			       opcode==NOT||opcode==MUL||opcode==SUB||opcode==OR||
			       opcode==RL||opcode==RR||opcode==POP||opcode==PUSH) 
			       
					 begin      // after a clock the alu is working
					   {inc_pc,load_acc,load_pc,rd}   <= 4'b0101;
		               {wr,load_ir,datactl_ena,halt}  <= 4'b0000;
					 end
				 else
				  if(opcode==SKZ&&zero==1)
				    begin
					   {inc_pc,load_acc,load_pc,rd}   <= 4'b1000;
		               {wr,load_ir,datactl_ena,halt}  <= 4'b0000;
					end
					else
				   if(opcode==JMP)
					   begin
					     {inc_pc,load_acc,load_pc,rd}   <= 4'b1010;
		                 {wr,load_ir,datactl_ena,halt}  <= 4'b0000;
					   end
					else
					if(opcode==STO)  //after a clock ,the value write to ram
					   begin
						  {inc_pc,load_acc,load_pc,rd}   <= 4'b0000;
		                  {wr,load_ir,datactl_ena,halt}  <= 4'b1010;
						  end
					else
						 begin
						    {inc_pc,load_acc,load_pc,rd}   <= 4'b0000;
		                    {wr,load_ir,datactl_ena,halt}  <= 4'b0000;
							end
					    state <= 3'b101;
				end
						 
	3'b101:  //idle
	         begin
				 if(opcode==STO)
				   begin 
					   {inc_pc,load_acc,load_pc,rd}   <= 4'b0000;
		               {wr,load_ir,datactl_ena,halt}  <= 4'b0010;
					 end
				  else
				  if(opcode==ADD||opcode==AND||opcode==XOR||opcode==LDA||
				      opcode==NOT||opcode==MUL||opcode==SUB||opcode==OR||
				      opcode==RL||opcode==RR||opcode==POP||opcode==PUSH) 
				      
					 begin
					   {inc_pc,load_acc,load_pc,rd}   <= 4'b0001;
		               {wr,load_ir,datactl_ena,halt}  <= 4'b0000;
					 end
					else
					 begin
					   {inc_pc,load_acc,load_pc,rd}   <= 4'b0000;
		               {wr,load_ir,datactl_ena,halt}  <= 4'b0000;
					end
				   state <= 3'b000;
			end
				   			

			
	default:
	         begin
				      {inc_pc,load_acc,load_pc,rd}   <= 4'b0000;
		              {wr,load_ir,datactl_ena,halt}  <= 4'b0000;
					   state <= 3'b000;
				end
	endcase
 end
 endtask
     //the end of task ctl_cycle
 endmodule
 
 //the end of module