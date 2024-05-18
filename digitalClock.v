`timescale 1ns / 1ps

module digitalClock(
    input clk_input,
    input rst,
    input clk200Hz,
    input en_en,
    input adjust_en_min,
    input adjust_en_hour,
    input updown,
    output  [6:0] segments, // 7-segment display for the current digit
    output reg [3:0] anode_active // Active anode signals
);
   
    wire [5:0] secCount;
    wire [5:0] minCount;
    wire [4:0] hourCount;
    wire [3:0] min_ones, min_tens, hour_ones, hour_tens;
    reg [1:0] anodeSelect;
  

    // Change anode every 100Hz clock cycle
    always @(posedge clk200Hz or posedge rst) begin
        if (rst) begin
            anodeSelect <= 0;
        end else begin
            if(anodeSelect == 3)
                anodeSelect <= 0;
            else
                anodeSelect <= anodeSelect + 1;
        end
    end

    // Instantiate the digital clock for minute and hour counters
    clock ourClock (
        .clk(clk_input),
        .rst(rst),
        .en(en_en),
        .updown(updown),
        .adjust_en_min(adjust_en_min),
        .adjust_en_hour(adjust_en_hour),
        .secCount(secCount),
        .minCount(minCount),
        .hourCount(hourCount)
    );
    
    // Separate digits for minutes
    separator minDigits (
        .number(minCount),
        .tens(min_tens),
        .units(min_ones)
    );

    // Separate digits for hours
    separator hourDigits (
        .number({1'b0,hourCount}),
        .tens(hour_tens),
        .units(hour_ones)
    );

    // Instantiate 7-segment decoders for each digit
    reg  [3:0] num;
    SevenSegDecWithEn hrTensDec (
        .num(num),
        .segments(segments)
    );

    // Multiplexing logic
    always @(*) begin
        case (anodeSelect)
            2'b00: begin
                anode_active = 4'b1110; // Activate anode 0
                num = min_ones; // Display units of minutes
            end
            2'b01: begin
                anode_active = 4'b1101; // Activate anode 1
                num = min_tens; // Display tens of minutes
            end
            2'b10: begin
                anode_active = 4'b1011; // Activate anode 2
                num = hour_ones; // Display units of hours
            end
            2'b11: begin
                anode_active = 4'b0111; // Activate anode 3
                num = hour_tens; // Display tens of hours
            end
        endcase
    end
    


endmodule