`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2024 03:24:10 PM
// Design Name: 
// Module Name: secondsCounter
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


module secondsCounter(
input clk,
input rst,
input en,
input updown,
output reg [5:0] secondCounter = 0,
output reg minuteEnabler
);
parameter integer n = 60;
always @(posedge clk or posedge rst) begin
        if (rst) begin
            secondCounter <= 0;           // Reset counter to 0 
            minuteEnabler <= 0;   // Disable minute enable signal
        end else if (en) begin
            if (secondCounter == n-1) begin //when counter counts 60 seconds, counter resets and enables minutes counter
                secondCounter <= 0;       
                minuteEnabler <= 1; 
            end else begin
                secondCounter <= secondCounter + 1; // normal counting
                minuteEnabler <= 0; // disable minute enable signal
            end
        end
    end
endmodule

