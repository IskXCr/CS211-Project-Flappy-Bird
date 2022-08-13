`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2022 01:21:10 PM
// Design Name: 
// Module Name: GAMESYS_DIFF_CTRL
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


module GAMESYS_DIFF_CTRL(
    input  wire logic clk,
    input  wire logic reset,            //High Active
    
    input  wire logic btn_l_level,      //Button - Higher Level
    input  wire logic btn_h_level,      //Button - Lower Level
    
    output      logic [2:0] diff,
    output      logic [7:0] led_level
    );
    
    //Reference for detecting rising edge: https://stackoverflow.com/questions/37467750/verilog-incrementing-variable-using-buttons
    wire buttons = btn_l_level | btn_h_level;
    reg buttons_old;
    
    initial begin
        buttons_old <= 1'b0;
        diff <= 3;
        led_level <= 8'b00010000;
    end
    
    always_ff @ (posedge clk or posedge reset) begin
        if (reset) begin
            diff <= 3'd3;
            led_level <= 8'b00010000;
        end
        else begin
            if (buttons_old != buttons && buttons == 1'b1) begin
            
                led_level[diff] <= 0;
                
                if (btn_h_level) begin
                    diff <= (diff == 3'd7 ? 7 : diff + 1);
                    led_level[(diff == 3'd7 ? 7 : diff + 1)] <= 1;
                end
                else begin
                    diff <= (diff == 3'd0 ? 0 : diff - 1);
                    led_level[(diff == 3'd0 ? 0 : diff - 1)] <= 1;
                end
            end
            
            buttons_old <= buttons;
        end
    end
endmodule
