`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2022 04:03:24 PM
// Design Name: 
// Module Name: GAMESYS_JUDGE
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

module GAMESYS_JUDGE(
    input  wire logic game_clk,
    input  wire logic reset,
    input  wire logic pause,
    
    input  wire logic signed [`DATA_POSITION_SIZE - 1 : 0] pos_player_x,
    input  wire logic signed [`DATA_POSITION_SIZE - 1 : 0] pos_player_y,
    input  wire logic signed [`DATA_POSITION_SIZE - 1 : 0] pos_wall_x      [0:4],
    input  wire logic signed [`DATA_POSITION_SIZE - 1 : 0] pos_wall_y      [0:4],
    input  wire logic signed [`DATA_POSITION_SIZE - 1 : 0] pos_wall_height [0:4],
    
    output      logic failed
    );
    
    
    always @ (posedge game_clk or posedge reset) begin
        if (reset) begin
            failed <= 0;
        end
        else if (~pause) begin
            for (int i = 0; i < 5; i++) begin
                if (pos_wall_x[i] - `WALL_HALF_WIDTH <= pos_player_x + `PLAYER_HALF_WIDTH - 1'b1       //If passing through this wall
                 && pos_wall_x[i] + `WALL_HALF_WIDTH - 1'b1 > pos_player_x - `PLAYER_HALF_WIDTH 
                 && ((pos_player_y + `PLAYER_HALF_HEIGHT > pos_wall_y[i] + pos_wall_height[i] + `JUDGE_TOLERANCE)
                     || (pos_player_y - `PLAYER_HALF_HEIGHT < pos_wall_y[i] - `JUDGE_TOLERANCE)))                  //If collide with this wall
                    failed <= 1;
                    
                else if (pos_player_y + `PLAYER_HALF_HEIGHT - 1'b1 >= `GROUND_HEIGHT)
                    failed <= 1;
            end
            
        end
    end
    
endmodule
