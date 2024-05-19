`timescale 1ns / 1ps
/*******************************************************************
*
* Module: minuteCounter.v
* Project: Digital-Alarm-Clock
* Author: Mazen Zaki (mazen.zaki@aucegypt.edu), Abdelrahman Taher Elessawy (elessawy@aucegypt.edu), Mohanad Hassan Saad (mohanadsamy@aucegypt.edu), Mustafa El Mahdy (mustafaelmahdy@aucegypt.edu)
* Description: Binary counter module.
*
* Change history: 
* 17/05/2024 – Implemented the minuteCounter as from the lab.
* 18/05/2024 - Added the updown variable which allows us to increment and decrement using the buttons on the FPGA board.
*
**********************************************************************/


module minutesCounter#(parameter  n = 60)(
input clk,
input rst,
input en,
input updown, // Control signal for increment/decrement logic. 1 = increment, 0 = decrement
output reg [width-1:0] minuteCounter = 0, // Counter register
output reg hourEnabler // Output signal for the hour to be enabled so it can increment by 1 when minutes reach 60
);
parameter width= $clog2(n);

always @(posedge clk or posedge rst) begin
        if (rst) begin
            minuteCounter <= 0;           // Reset counter to 0 
            hourEnabler <= 0;   // Disable hour enable signal
        end 
        else 
        if (en) begin
            if(updown) // When updown is 1, we can increment amount using algorithm in fsm.v
                if (minuteCounter == n-1) begin 
                    minuteCounter <= 0;       
                    hourEnabler <= 1; 
                end else begin
                    minuteCounter <= minuteCounter + 1; 
                    hourEnabler <= 0; 
                end
            else // When updown is 0, we can decrement amount using algorithm in fsm.v
                if (minuteCounter == 0) begin 
                    minuteCounter <= n-1;       
                    hourEnabler <= 1; 
                end else begin
                    minuteCounter <= minuteCounter - 1; 
                    hourEnabler <= 0; 
                end        
            end
    end
endmodule


