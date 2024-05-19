`timescale 1ns / 1ps

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
