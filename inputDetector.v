`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2024 11:55:52 PM
// Design Name: 
// Module Name: inputDetector
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module inputDetector(input clk, rst, sig, output sig_out );
wire w1, w2;
debouncer DB (clk, rst,sig,w1);
sync s (clk, w1, w2);
risingEdgeDetector RE (clk, rst, w2, sig_out);
endmodule


