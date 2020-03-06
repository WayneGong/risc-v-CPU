`timescale 1ns/1ns
module datactl(
              //output
                data,  //数据输出
              //input
                in,
                data_ena);
   //output port
output[15:0] data;// data output
   //input ports
input[15:0] in;   //data input
input data_ena;  //the signal of data enable output 

assign data = (data_ena)?in:16'hzzzz;

endmodule
//the end of module
