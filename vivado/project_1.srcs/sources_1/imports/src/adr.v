`timescale 1ns/1ns
//the start of module
module adr(
          //output
            addr,  //地址
            
          //input
            fetch,
            ir_addr,
            pc_addr);
            
     //output port
output[11:0] addr;  //output address
     //input port
input[11:0] ir_addr; //data address input
input[11:0] pc_addr; //pc address input
input fetch;         //the signal of select address

assign addr = fetch?(pc_addr-12'h1):ir_addr;//the address subtract 1 to adapt the pc address change

endmodule

//the end of module