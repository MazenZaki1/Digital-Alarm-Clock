`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2024 03:44:51 PM
// Design Name: 
// Module Name: hoursCounter
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


module hoursCounter#(parameter n = 24)(
input clk,
input rst,
input en,
output reg [4:0] hourCounter
);

always @(posedge clk or posedge rst) begin
        if (rst) begin
            hourCounter <= 0;           // Reset counter to 0 
        end
         else if (en) begin
            if (hourCounter == n-1) begin //when counter counts 24 hours, counter resets
                hourCounter <= 0;       
            end else begin
                hourCounter <= hourCounter + 1; // normal counting
            end
        end
    end
endmodule