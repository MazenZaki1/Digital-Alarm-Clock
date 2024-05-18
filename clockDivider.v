`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2024 03:19:34 PM
// Design Name: 
// Module Name: ClockDivider
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


module clockDivider #(parameter n=250000) (
input clk,
input rst, 
output reg clk_out 
);
parameter width= $clog2(n);
reg [width-1:0] count;

always @ (posedge clk, posedge rst) begin
    if (rst == 1'b1) // Asynchronous Reset 
        count <= 32'b0;
    else if (count == n-1) 
        count <= 32'b0;
    else 
        count <= count + 1;
end
// Handle the output clock
always @ (posedge clk, posedge rst) begin
    if (rst) // Asynchronous Reset
        clk_out <= 0;
    else if (count == n-1)
        clk_out <= ~ clk_out;
end
endmodule
