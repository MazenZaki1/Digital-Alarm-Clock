`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2024 03:47:14 PM
// Design Name: 
// Module Name: digitalClock
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


module clock(
input clk,
input rst,
input en,
input updown,
input adjust_en_min,
input adjust_en_hour,
output [5:0] secCount,
output [5:0] minCount,
output [4:0] hourCount
);

wire minuteEnable;
wire hourEnable;
wire clk_out;
minutesCounter sec_counter (
        .clk(clk),
        .rst(rst),
        .en(en),
        .updown(updown),
        .minuteCounter(secCount),
        .hourEnabler(minuteEnable)
    );

    minutesCounter min_counter (
        .clk(clk),
        .rst(rst),
        .en(en?minuteEnable:adjust_en_min),
        .updown(updown),
        .minuteCounter(minCount),
        .hourEnabler(hourEnable)
    );  
    
     minutesCounter #(24) hour_counter (
        .clk(clk),
        .rst(rst),
        .updown(updown),
        .en(en ? hourEnable&minuteEnable : adjust_en_hour),
        .minuteCounter(hourCount)
    );

endmodule
