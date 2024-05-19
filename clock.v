`timescale 1ns / 1ps
/*******************************************************************
*
* Module: clock.v
* Project: Digital-Alarm-Clock
* Author: Mazen Zaki (mazen.zaki@aucegypt.edu), Abdelrahman Taher Elessawy (elessawy@aucegypt.edu), Mohanad Hassan Saad (mohanadsamy@aucegypt.edu), Mustafa El Mahdy (mustafaelmahdy@aucegypt.edu)
* Description: This module uses minutesCounter module three times to make a second, minute and hour counter.
*
* Change history: 
* 17/05/2024 – File Created
* 18/05/2024 - Added new inputs for the adjust mode.
**********************************************************************/
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

wire minuteEnable; // A wire to take the enable from the second after the second reaches 60 seconds so the minute would increment by 1.
wire hourEnable; // A wire to take the enable from the minute after the minute reaches 60 minutes so the hour would increment by 1.

minutesCounter sec_counter ( // Second counter
        .clk(clk),
        .rst(rst),
        .en(en),
        .updown(updown),
        .minuteCounter(secCount),
        .hourEnabler(minuteEnable)
    );

    minutesCounter min_counter ( // Minute counter
        .clk(clk),
        .rst(rst),
        .en(en?minuteEnable:adjust_en_min), // When en is 1 then it should be counting normally, otherwise it should be in adjust mode
        .updown(updown),
        .minuteCounter(minCount),
        .hourEnabler(hourEnable)
    );  
    
     minutesCounter #(24) hour_counter ( // Hour counter
        .clk(clk),
        .rst(rst),
        .en(en ? hourEnable&minuteEnable : adjust_en_hour), // When en is 1 then it should be counting normally, otherwise it should be in adjust mode
        .updown(updown),
        .minuteCounter(hourCount)
    );

endmodule
