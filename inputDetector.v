`timescale 1ns / 1ps
/*******************************************************************
*
* Module: inputDetector.v
* Project: Digital-Alarm-Clock
* Author: Mazen Zaki (mazen.zaki@aucegypt.edu), Abdelrahman Taher Elessawy (elessawy@aucegypt.edu), Mohanad Hassan Saad (mohanadsamy@aucegypt.edu), Mustafa El Mahdy (mustafaelmahdy@aucegypt.edu)
* Description: Detects input by calling debouncer, sync and the rising edge detector.
*
* Change history: 
* 17/05/2024 – File created
*
**********************************************************************/

module inputDetector(input clk, rst, sig, output sig_out );
wire w1, w2;
debouncer DB (clk, rst,sig,w1);
sync s (clk, w1, w2);
risingEdgeDetector RE (clk, rst, w2, sig_out);
endmodule


