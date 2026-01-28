`timescale 1ns / 1ps

module test_module(inputData,outputData);

input [1:0] inputData;
output [1:0] outputData;

assign outputData = ~inputData;


endmodule
