`resetall
`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2022 01:19:52 PM
// Design Name: 
// Module Name: GAMESYS_GRAPH_PROC
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

module GAMESYS_GRAPH_PROC(
    input  wire logic reset,
    input  wire logic pause,
    input  wire logic base_clk,
    input  wire logic game_clk,
    
    input  wire logic        [31:0]                        random,
    input  wire logic signed [`DATA_POSITION_SIZE - 1 : 0] pos_x,
    input  wire logic signed [`DATA_POSITION_SIZE - 1 : 0] pos_y,
    input  wire logic signed [`DATA_POSITION_SIZE - 1 : 0] pos_player_x,
    input  wire logic signed [`DATA_POSITION_SIZE - 1 : 0] pos_player_y,
    input  wire logic signed [`DATA_POSITION_SIZE - 1 : 0] pos_wall_x       [0:4],
    input  wire logic signed [`DATA_POSITION_SIZE - 1 : 0] pos_wall_y       [0:4],
    input  wire logic signed [`DATA_POSITION_SIZE - 1 : 0] pos_wall_height  [0:4],

    input  wire logic        [15 : 0]                      score,
    output      logic        [`COLOR_SIZE - 1 : 0]         vout_data
    );
    wire mem_clk;
    clk_wiz_0 clk_gen_mem(.clk_in1(base_clk), 
                          .clk_out1(mem_clk), 
                          .reset(1'b0));
//    assign mem_clk = game_clk;
    
    wire [11:0] s_panel_vout_data;
    wire        s_panel_enabled;
    GAMESYS_GRAPH_PROC_S_PANEL gamesys_graph_proc_s_panel(.pause(pause),
                                                          .pos_x(pos_x),
                                                          .pos_y(pos_y),
                                                          .score(score),
                                                          .vout_data(s_panel_vout_data),
                                                          .enabled(s_panel_enabled));
    
    wire [11:0] player_vout_data;
    wire        player_enabled;
    GAMESYS_GRAPH_PROC_PLAYER gamesys_graph_proc_player(.base_clk(base_clk),
                                                        .mem_clk(mem_clk),
                                                        .reset(reset),
                                                        .pos_x(pos_x),
                                                        .pos_y(pos_y),
                                                        .pos_player_x(pos_player_x),
                                                        .pos_player_y(pos_player_y),
                                                        .vout_data(player_vout_data),
                                                        .enabled(player_enabled));
    wire [11:0] walls_vout_data;
    wire        walls_enabled;
    GAMESYS_GRAPH_PROC_WALLS gamesys_graph_proc_walls(.base_clk(base_clk),
                                                      .game_clk(game_clk),
                                                      .mem_clk(mem_clk),
                                                      .reset(reset),
                                                      .pos_x(pos_x),
                                                      .pos_y(pos_y),
                                                      .pos_wall_x(pos_wall_x),
                                                      .pos_wall_y(pos_wall_y),
                                                      .pos_wall_height(pos_wall_height),
                                                      .vout_data(walls_vout_data),
                                                      .enabled(walls_enabled));
    
    wire [11:0] bkgnd_vout_data;
    wire        bkgnd_enabled;
    GAMESYS_GRAPH_PROC_BKGND gamesys_graph_proc_bkgnd(.base_clk(base_clk),
                                                      .mem_clk(mem_clk),
                                                      .reset(reset),
                                                      .random(random),
                                                      .pos_x(pos_x),
                                                      .pos_y(pos_y),
                                                      .vout_data(bkgnd_vout_data),
                                                      .enabled(bkgnd_enabled));
    
    //--------Order--------
    //1. Draw Panel
    //2. Draw Player
    //3. Draw Wall
    //4. Draw Background
    
    always_comb begin
        //Score panel:
        if (s_panel_enabled)
            vout_data = s_panel_vout_data;        
        //Draw player
        else if (player_enabled)
            vout_data = player_vout_data;
        //Draw walls
        else if (walls_enabled)
            vout_data = walls_vout_data;
        //Draw background else
        else if (bkgnd_enabled)
            vout_data = bkgnd_vout_data;
        else
            vout_data = `DEFAULT_COLOR;
    end
    
endmodule
