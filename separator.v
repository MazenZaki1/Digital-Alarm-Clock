`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2024 04:52:03 PM
// Design Name: 
// Module Name: separator
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


module separator( 
input [5:0] number,
output [3:0] tens,
output [3:0] units
);

 assign tens = (number / 10)%10;
 assign units = number % 10;
    
endmodule
