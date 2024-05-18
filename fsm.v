`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2024 11:27:02 PM
// Design Name: 
// Module Name: fsm
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


module fsm(
input clk,
input rst,
input en,
output  [6:0] segments,
output  [3:0] anode_active,
input BTNC,
input BTNR,
input BTNL,
input BTNU,
input BTND,
output  LD0,
output  LD12,
output  LD13,
output  LD14,
output  LD15
);
reg en_en;
reg adjust_en_min;
reg adjust_en_hour;
reg clk_input;
reg updown;

    wire clk1Hz, clk200Hz;
    clockDivider #(.n(250000)) clk_div_200hz (
        .clk(clk),
        .rst(rst),
        .clk_out(clk200Hz)
    );
    clockDivider #(.n(250000)) clk_div_1hz (
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
    .updown(updown),
    .segments(segments),
    .anode_active(anode_active) // Active anode signals
    );
    
    inputDetector switch(clk200Hz, rst, BTNC, btnc );
    inputDetector right(clk200Hz, rst, BTNR, btnr );
    inputDetector left(clk200Hz, rst, BTNL, btnl );
    inputDetector up(clk200Hz, rst, BTNU, btnu );
    inputDetector down(clk200Hz, rst, BTND, btnd );
    
    reg [2:0] state;
    reg [2:0] nextState;
    parameter [2:0] clockMode=3'b000;
    parameter [2:0] timeHour=3'b001;
    parameter [2:0] timeMinutes=3'b010;
    parameter [2:0] alarmHour=3'b011;
    parameter [2:0] alarmMinutes=3'b100;
    //output reg [4:0] LEDS;
    always @ (btnc or btnr or btnl or state) 
        case (state)
            clockMode: 
                if (btnc==1)begin
                    nextState = timeHour;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0;
                end
                else begin
                    nextState = clockMode;
                    clk_input = clk1Hz;
                    en_en = 1;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0;           
                 end
            timeHour:
                if (btnc==1) begin
                    nextState = clockMode;
                    clk_input = clk1Hz;
                    en_en = 1;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0;  
                end
                else if (btnr==1) begin
                    nextState = timeMinutes;
                   clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0; 
                end
                else if (btnl==1) begin
                    nextState=alarmMinutes;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0;  
                end
                else if (btnu==1) begin
                    nextState=timeHour;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 1;
                    adjust_en_min = 0;  
                end

                else if (btnd==1) begin
                    nextState=timeHour;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b0;
                    adjust_en_hour = 1;
                    adjust_en_min = 0;  
                end
                else begin
                    nextState=timeHour;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0;                          
                end
            timeMinutes: 
                if (btnc==1) begin
                    nextState = clockMode;
                    clk_input = clk1Hz;
                    en_en = 1;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0;  
                end
                else if (btnr==1) begin
                    nextState = alarmHour;
                   clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0; 
                end
                else if (btnl==1) begin
                    nextState=timeHour;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0;  
                end
                else if (btnu==1) begin
                    nextState=timeMinutes;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 1;  
                end

                else if (btnd==1) begin
                    nextState=timeMinutes;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b0;
                    adjust_en_hour = 0;
                    adjust_en_min = 1;  
                end
                else begin
                    nextState=timeMinutes;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0;                          
                end
            alarmHour: 
               if (btnc==1) begin
                    nextState = clockMode;
                    clk_input = clk1Hz;
                    en_en = 1;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0;  
                end
                else if (btnr==1) begin
                    nextState = alarmMinutes;
                   clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0; 
                end
                else if (btnl==1) begin
                    nextState=timeMinutes;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0;  
                end
                else if (btnu==1) begin
                    nextState=alarmHour;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 1;
                    adjust_en_min = 0;  
                end

                else if (btnd==1) begin
                    nextState=alarmHour;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b0;
                    adjust_en_hour = 1;
                    adjust_en_min = 0;  
                end
                else begin
                    nextState=alarmHour;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0;                          
                end
            alarmMinutes: 
                if (btnc==1) begin
                    nextState = clockMode;
                    clk_input = clk1Hz;
                    en_en = 1;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0;  
                end
                else if (btnr==1) begin
                    nextState = timeHour;
                   clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0; 
                end
                else if (btnl==1) begin
                    nextState=alarmHour;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0;  
                end
                else if (btnu==1) begin
                    nextState=alarmMinutes;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 1;  
                end

                else if (btnd==1) begin
                    nextState=alarmMinutes;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b0;
                    adjust_en_hour = 0;
                    adjust_en_min = 1;  
                end
                else begin
                    nextState=alarmMinutes;
                    clk_input = clk200Hz;
                    en_en = 0;
                    updown  = 1'b1;
                    adjust_en_hour = 0;
                    adjust_en_min = 0;                          
                end
        endcase
        
    always @ (posedge clk200Hz or posedge rst) begin
        if(rst) 
            state <= clockMode;
        else 
            state <= nextState;
    end
assign LD0 = state == (timeHour||timeMinutes||alarmHour||alarmMinutes);
assign LD12 = state == timeHour;
assign LD13 = state == timeMinutes;
assign LD14 = state == alarmHour;
assign LD15 = state == alarmMinutes;

endmodule