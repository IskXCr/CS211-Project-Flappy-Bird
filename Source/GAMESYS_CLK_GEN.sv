`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2022 04:31:13 PM
// Design Name: 
// Module Name: GAMESYS_CLK_GEN
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
`include "CONSTANTS.vh"

module GAMESYS_CLK_GEN(
    input  wire logic clk,
    input  wire logic reset,
    output      logic game_clk
    );
    
    integer i;
    
    initial begin
        i <= 0;
        game_clk <= 0;
    end
    
    always_ff @ (posedge clk) begin
        if (i == 1000000000)
            i <= 0;
        else
            i <= i + 1;
    end
    
    always_ff @ (posedge clk or posedge reset) begin
        if (reset) begin
            game_clk <= 0;
        end
        else begin
            if (i[`FRAME_SHIFT : 0] == `FRAME_SLICE_HALF)
                game_clk <= 1;
            else
                game_clk <= 0;
        end
    end
    
endmodule
