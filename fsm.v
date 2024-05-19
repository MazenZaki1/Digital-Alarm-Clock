`timescale 1ns / 1ps
/*******************************************************************
*
* Module: fsm.v
* Project: Digital-Alarm-Clock
* Author: Mazen Zaki (mazen.zaki@aucegypt.edu), Abdelrahman Taher Elessawy (elessawy@aucegypt.edu), Mohanad Hassan Saad (mohanadsamy@aucegypt.edu), Mustafa El Mahdy (mustafaelmahdy@aucegypt.edu)
* Description: This is the fsm for all states which calls digital clock (which is incharge of displaying clock regarding of state)
*
* Change history: 
* 17/05/2024 – File created
* 18/05/2024 - Created all the states and modified them accordingly.
*
**********************************************************************/
module fsm(
input clk,
input rst,
input en,
input BTNC,
input BTNR,
input BTNL, // the five buttons
input BTNU,
input BTND,
output  [6:0] segments,
output  [3:0] anode_active,
output  LD0,
output  LD12,
output  LD13, // the five LEDs
output  LD14,
output  LD15,
output dp,
output buzzer
);
reg en_en;
reg adjust_en_min;
reg adjust_en_hour;
reg clk_input;
reg updown;
reg adjust_alarm_en_min;
reg adjust_alarm_en_hour;
wire segment_display_flag;
assign buzzer = state == alarm ? LD0: 0;

    wire clk1Hz, clk200Hz; 
    clockDivider #(.n(250000)) clk_div_200hz ( // We make two clocks, a 200hz one and a 1hz one
        .clk(clk),
        .rst(rst),
        .clk_out(clk200Hz)
    );
    clockDivider #(.n(5000000)) clk_div_1hz ( //50000000 (1hz)
        .clk(clk),
        .rst(rst),
        .clk_out(clk1Hz)
    );
    
    digitalClock ourClockk(
    .clk_input(clk_input),
    .rst(rst),
    .clk200Hz(clk200Hz),
    .en_en(en_en),
    .adjust_en_min(adjust_en_min),
    .adjust_en_hour(adjust_en_hour),
    .adjust_alarm_en_min(adjust_alarm_en_min),
    .adjust_alarm_en_hour(adjust_alarm_en_hour),    
    .updown(updown),
    .segment_display_flag(segment_display_flag),
    .isAlarmEqualToTime(comparator),
    .segments(segments),
    .anode_active(anode_active), // Active anode signals
    .dp(dp)

    );
    
    wire comparator; // The comparator is the output of Digital Clock which checks if alarm time and clock time are equal.
    
    inputDetector switch(clk200Hz, rst, BTNC, btnc );
    inputDetector right(clk200Hz, rst, BTNR, btnr );
    inputDetector left(clk200Hz, rst, BTNL, btnl );     // 5 button input detectors
    inputDetector up(clk200Hz, rst, BTNU, btnu );
    inputDetector down(clk200Hz, rst, BTND, btnd );
    
    reg [2:0] state;
    reg [2:0] nextState;
    parameter [2:0] clockMode=3'b000;
    parameter [2:0] timeHour=3'b001;
    parameter [2:0] timeMinutes=3'b010;
    parameter [2:0] alarmHour=3'b011; // Our states
    parameter [2:0] alarmMinutes=3'b100;
    parameter [2:0] alarm=3'b110;
    //output reg [4:0] LEDS;
    assign segment_display_flag = (state == alarmMinutes | state == alarmHour); // This is a checker for display the alarm minutes/hours

    always @ (btnc or btnr or btnl or state) 
        case (state)
            clockMode: // Clock mode state
                if (comparator) begin // If block to check if alarm and clock are similar, each state takes the following attributes
                    nextState = alarm; // This is to specifiy what the next state will be
                    clk_input = clk1Hz; // The frequency for the state
                    en_en = 1; // If clock should be counting or not
                    updown  = 1'b1; // Updown as 1 since it will be increment when counting
                    adjust_en_hour = 0; // This is to tell the state if we will be adjusting time or not
                    adjust_en_min = 0;    
                    adjust_alarm_en_min = 0;
                    adjust_alarm_en_hour = 0;
                end
                else if (btnc==1)begin // To go to the adjust mode using btnc
                    nextState = timeHour;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0;
                    adjust_alarm_en_min = 0;
                    adjust_alarm_en_hour = 0;                    
                end
                else begin
                    nextState = clockMode;
                    clk_input = clk1Hz;
                    en_en = 1;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0;    
                    adjust_alarm_en_min = 0;
                    adjust_alarm_en_hour = 0;                                       
                 end
            timeHour:
                if (btnc==1) begin
                    nextState = clockMode;
                    clk_input = clk1Hz;
                    en_en = 1;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0;  
                    adjust_alarm_en_min = 0;
                    adjust_alarm_en_hour = 0;                                
                end
                else if (btnr==1) begin
                    nextState = timeMinutes;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0; 
                    adjust_alarm_en_min = 0;
                    adjust_alarm_en_hour = 0;                                
                end
                else if (btnl==1) begin
                    nextState=alarmMinutes;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0;  
                    adjust_alarm_en_min = 0;
                    adjust_alarm_en_hour = 0;                                
                end
                else if (btnu==1) begin
                    nextState=timeHour;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 1;
                    adjust_en_min = 0;  
                    adjust_alarm_en_min = 0;
                    adjust_alarm_en_hour = 0;                                
                end

                else if (btnd==1) begin
                    nextState=timeHour;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b0;
                    adjust_en_hour = 1;
                    adjust_en_min = 0;  
                    adjust_alarm_en_min = 0;
                    adjust_alarm_en_hour = 0;                                
                end
                else begin
                    nextState=timeHour;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0;   
                    adjust_alarm_en_min = 0;
                    adjust_alarm_en_hour = 0;                                                       
                end
            timeMinutes: 
                if (btnc==1) begin
                    nextState = clockMode;
                    clk_input = clk1Hz;
                    en_en = 1;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0;  
                    adjust_alarm_en_min = 0;
                    adjust_alarm_en_hour = 0;                                
                end
                else if (btnr==1) begin
                    nextState = alarmHour;
                   clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0; 
                    adjust_alarm_en_min = 0;
                    adjust_alarm_en_hour = 0;                                
                end
                else if (btnl==1) begin
                    nextState=timeHour;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0; 
                    adjust_alarm_en_min = 0;
                    adjust_alarm_en_hour = 0;                                 
                end
                else if (btnu==1) begin
                    nextState=timeMinutes;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 1;  
                    adjust_alarm_en_min = 0;
                    adjust_alarm_en_hour = 0;                                
                end

                else if (btnd==1) begin
                    nextState=timeMinutes;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b0;
                    adjust_en_hour = 0;
                    adjust_en_min = 1;  
                    adjust_alarm_en_min = 0;
                    adjust_alarm_en_hour = 0;                                
                end
                else begin
                    nextState=timeMinutes;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0;    
                    adjust_alarm_en_min = 0;
                    adjust_alarm_en_hour = 0;                                                      
                end
            alarmHour: 
               if (btnc==1) begin
                    nextState = clockMode;
                    clk_input = clk1Hz;
                    en_en = 1;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0; 
                    adjust_alarm_en_min = 0;
                    adjust_alarm_en_hour = 0;                                 
                end
                else if (btnr==1) begin
                    nextState = alarmMinutes;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0; 
                    adjust_alarm_en_min = 0;
                    adjust_alarm_en_hour = 0;                                
                end
                else if (btnl==1) begin
                    nextState=timeMinutes;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0;  
                    adjust_alarm_en_min = 0;
                    adjust_alarm_en_hour = 0;                                
                end
                else if (btnu==1) begin
                    nextState=alarmHour;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0; 
                    adjust_alarm_en_min = 0;
                    adjust_alarm_en_hour = 1;                                 
                end

                else if (btnd==1) begin
                    nextState=alarmHour;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b0;
                    adjust_en_hour = 0;
                    adjust_en_min = 0;  
                    adjust_alarm_en_min = 0;
                    adjust_alarm_en_hour = 1;                                
                end
                else begin
                    nextState=alarmHour;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0;    
                    adjust_alarm_en_min = 0;
                    adjust_alarm_en_hour = 0;                                                      
                end
            alarmMinutes: 
                if (btnc==1) begin
                    nextState = clockMode;
                    clk_input = clk1Hz;
                    en_en = 1;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0;  
                    adjust_alarm_en_min = 0;
                    adjust_alarm_en_hour = 0;                                
                end
                else if (btnr==1) begin
                    nextState = timeHour;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0; 
                    adjust_alarm_en_min = 0;
                    adjust_alarm_en_hour = 0;                                
                end
                else if (btnl==1) begin
                    nextState=alarmHour;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0;  
                    adjust_alarm_en_min = 0;
                    adjust_alarm_en_hour = 0;                                
                end
                else if (btnu==1) begin
                    nextState=alarmMinutes;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0;  
                    adjust_alarm_en_min = 1;
                    adjust_alarm_en_hour = 0;                                
                end

                else if (btnd==1) begin
                    nextState=alarmMinutes;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b0;
                    adjust_en_hour = 0;
                    adjust_en_min = 0;  
                    adjust_alarm_en_min = 1;
                    adjust_alarm_en_hour = 0;                                
                end
                else begin
                    nextState=alarmMinutes;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0;    
                    adjust_alarm_en_min = 0;
                    adjust_alarm_en_hour = 0;                                                      
                end
        alarm:
            if(btnu==1|btnl==1|btnc==1|btnr==1|btnd==1) begin // This is to get out of the buzzer and blinking part
                nextState = clockMode;
                clk_input = clk1Hz;
                en_en = 1;
                updown  = 1'b1;
                adjust_en_hour = 0;
                adjust_en_min = 0;    
                adjust_alarm_en_min = 0;
                adjust_alarm_en_hour = 0;
            end 
            else begin
                nextState = alarm;
                clk_input = clk1Hz;
                en_en = 1;
                updown  = 1'b1;
                adjust_en_hour = 0;
                adjust_en_min = 0;    
                adjust_alarm_en_min = 0;
                adjust_alarm_en_hour = 0;
            end
        endcase
        
    always @ (posedge clk200Hz or posedge rst) begin
        if(rst) 
            state <= clockMode;
        else 
            state <= nextState;
    end
assign LD0 = state == (timeHour|timeMinutes|alarmHour|alarmMinutes) ? 1 : state==alarm ? clk1Hz:0; //  LD0 would be blinking when alarm and time match or stable as 1 when we are in adjust mode
assign LD15 = state == timeHour;
assign LD14 = state == timeMinutes;
assign LD13 = state == alarmHour;
assign LD12 = state == alarmMinutes;
endmodule