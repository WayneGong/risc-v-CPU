`timescale 1ns/1ns
//the start of module

module alu(
	       //output
	       alu_out,  //输出结果
	       zero,
	       
	       //input
	       data,
	       accum,
	       alu_clk,
	       opcode
	       );
	       
	 //output ports
output[15:0] alu_out;  // the output of alu
output  zero;         // the value of alu output is zero or not 

    //output ports
input[15:0]  data;     //the input data to calculate from rom or ram
input[15:0]  accum;    //the input data to calculate from accumulation
input[3:0]  opcode;   //the operation code
input alu_clk;        //the clk of alu

    // reg define
reg[15:0] alu_out;

   //  parmeter define
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
			    
assign zero = !accum;

reg[15:0]  spbuf;

always @(posedge alu_clk)
	begin
     casex(opcode)
	    HLT:  alu_out <= accum;
	    SKZ:  alu_out <= accum;
	    ADD:  alu_out <= data + accum;
	    SUB:  alu_out <= accum - data;
	    MUL:  alu_out <= accum * data;
	    OR :  alu_out <= accum | data;
	    AND: alu_out  <= data & accum;
	    XOR: alu_out  <= data ^ accum;
	    NOT: alu_out  <= ~ data;
	    LDA:  alu_out <= data;
	    STO:  alu_out <= accum;
	    RL :  alu_out <= data << 1;
	    RR :  alu_out <= data >> 1;
	    JMP:  alu_out <= accum;
	    POP:  alu_out <= spbuf;  
	    PUSH: spbuf <= accum;
	    default: alu_out <= 16'hxxxx;
	 endcase 
	end

endmodule

//the end of module	