`timescale 1ns / 1ps
/*******************************************************************
*
* Module: alarm.v
* Project: Digital-Alarm-Clock
* Author: Mazen Zaki (mazen.zaki@aucegypt.edu), Abdelrahman Taher Elessawy (elessawy@aucegypt.edu), Mohanad Hassan Saad (mohanadsamy@aucegypt.edu), Mustafa El Mahdy (mustafaelmahdy@aucegypt.edu)
* Description: Makes the alarm hour and minute using our binaryCounter.
*
* Change history: 
* 18/05/2024 – File created
*
**********************************************************************/
module alarm(
input clk,
input rst,
input updown,
input adjust_alarm_en_min,
input adjust_alarm_en_hour,
output [5:0] alarmMinutes,
output [4:0] alarmHours
);


    minutesCounter alarm_minute (
        .clk(clk),
        .rst(rst),
        .en(adjust_alarm_en_min),
        .updown(updown),
        .minuteCounter(alarmMinutes)
    );  
    
     minutesCounter #(24) alarm_hour (
        .clk(clk),
        .rst(rst),
        .updown(updown),
        .en(adjust_alarm_en_hour),
        .minuteCounter(alarmHours)
    );
endmodule
