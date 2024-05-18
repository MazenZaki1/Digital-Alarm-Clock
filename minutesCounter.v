`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2024 03:40:17 PM
// Design Name: 
// Module Name: minutesCounter
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


module minutesCounter#(parameter  n = 60)(
input clk,
input rst,
input en,
input updown,
output reg [width-1:0] minuteCounter = 0 ,
output reg hourEnabler,
output clk_out
);
parameter width= $clog2(n);
assign clk_out = clk;

always @(posedge clk or posedge rst) begin
        if (rst) begin
            minuteCounter <= 0;           // Reset counter to 0 
            hourEnabler <= 0;   // Disable hour enable signal
        end 
        else 
        if (en) begin
            if(updown)
                if (minuteCounter == n-1) begin //when counter counts 60 minutes, counter resets and enables hour counter
                    minuteCounter <= 0;       
                    hourEnabler <= 1; 
                end else begin
                    minuteCounter <= minuteCounter + 1; // normal counting
                    hourEnabler <= 0; // disable hour enable signal
                end
            else
                if (minuteCounter == 0) begin //when counter counts 60 minutes, counter resets and enables hour counter
                    minuteCounter <= n-1;       
                    hourEnabler <= 1; 
                end else begin
                    minuteCounter <= minuteCounter - 1; // normal counting
                    hourEnabler <= 0; // disable hour enable signal
                end        
            end
    end
endmodule
