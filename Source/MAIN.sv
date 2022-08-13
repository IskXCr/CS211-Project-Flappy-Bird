`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2022 07:47:03 PM
// Design Name: 
// Module Name: MAIN
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

module MAIN(
    input  wire logic clk,
    input  wire logic reset,
    output wire [3:0] red,
    output wire [3:0] green,
    output wire [3:0] blue,
    output wire       hsync,
    output wire       vsync,
    
    input  wire       btn_jmp,
    output wire       led_pause,
    output wire       led_failed,
    output wire       led_jmp,
    output wire       led_score,
    
    input  wire       btn_l_level,
    input  wire       btn_h_level,
    output wire [7:0] led_level,
    
    output wire [7:0] led_en,
    output wire [7:0] led_dest_1,
    output wire [7:0] led_dest_2
    );
    assign led_jmp = btn_jmp;

    wire signed [12:0] pos_player_y;
    wire signed [12:0] pos_player_x;
    
    wire signed [12:0] pos_wall_x [0:4];
    wire signed [12:0] pos_wall_y [0:4];             //The position of the upper boundary of the opening on the wall
    wire signed [12:0] pos_wall_height [0:4];        //The height of the opening
    
    wire pause, failed;                       //High active
    
    assign led_pause = pause;
    assign led_failed = failed;
    assign led_score = game_clk;
    
    //Timer
    integer i = 0;
    
    wire dri_clk;
    clk_wiz_0 clk_gen(.clk_in1(clk), .clk_out1(dri_clk), .reset(1'b0));
     
    //Calibrating Timer
    wire game_clk;
    GAMESYS_CLK_GEN gamesys_clk_gen(.clk(clk), 
                                    .game_clk(game_clk),
                                    .reset(reset));
    
    wire [31:0] random;
    RANDOMIZER_32W randomizer(.clk(clk), .random(random));
    

    //----------------
    // Game Pausing & Detection
    //----------------
    
    GAMESYS_FSM gamesys_fsm(.game_clk(game_clk),
                            .reset(reset),
                            .btn_jmp(btn_jmp),
                            .failed(failed),
                            .pause(pause));
    
    
    //Physical simulation: collision detection
    GAMESYS_JUDGE gamesys_judge(.game_clk(game_clk),
                                .reset(reset),
                                .pause(pause),
                                .pos_player_x(pos_player_x),
                                .pos_player_y(pos_player_y),
                                .pos_wall_x(pos_wall_x),
                                .pos_wall_y(pos_wall_y),
                                .pos_wall_height(pos_wall_height),
                                .failed(failed));
    
    //Controlling difficulty
    wire [2:0] diff;
    
    GAMESYS_DIFF_CTRL gamesys_diff_ctrl(.clk(clk), 
                                        .reset(reset), 
                                        .btn_l_level(btn_l_level), 
                                        .btn_h_level(btn_h_level), 
                                        .diff(diff),
                                        .led_level(led_level));
    
    wire [15:0] score;
    //Physical simulation: Initialization
    GAMESYS_PHY gamesys_phy(.game_clk(game_clk),
                            .reset(reset),
                            .pause(pause),
                            .btn_jmp(btn_jmp),
                            .random(random),
                            .diff(diff),
                            .pos_player_x(pos_player_x),
                            .pos_player_y(pos_player_y),
                            .pos_wall_x(pos_wall_x),
                            .pos_wall_y(pos_wall_y),
                            .pos_wall_height(pos_wall_height),
                            .score(score));
    
    
    //----------------
    //    Rendering
    //----------------
    
    logic signed [`DATA_POSITION_SIZE - 1 : 0] pos_x, pos_y;
    logic [`COLOR_SIZE - 1 : 0] vout_data;
    
    GAMESYS_GRAPH_PROC gamesys_graph_proc(.reset(reset),
                                          .pause(pause),
                                          .base_clk(clk),
                                          .game_clk(game_clk),
                                          .random(random),
                                          .pos_x(pos_x),
                                          .pos_y(pos_y),
                                          .pos_player_x(pos_player_x),
                                          .pos_player_y(pos_player_y),
                                          .pos_wall_x(pos_wall_x),
                                          .pos_wall_y(pos_wall_y),
                                          .pos_wall_height(pos_wall_height),
                                          .score(score),
                                          .vout_data(vout_data));
    
    VGA_DRIVER v_dri(.pos_x(pos_x[11:0]), 
                     .pos_y(pos_y[11:0]),
                     .v_data(vout_data),
                     
                     .clk(clk), 
                     .rst_n(0), 
                     .red(red), 
                     .green(green), 
                     .blue(blue), 
                     .hsync(hsync), 
                     .vsync(vsync)
                     );
    
    //Driving the scoring panel
    LED_DRIVER_4D led_dri_1(.clk(clk),
                            .reset(reset),
                            .data(score),
                            .led_en(led_en[3:0]),
                            .dest(led_dest_1)
                            );
                            
                            
    LED_DRIVER_4D led_dri_2(.clk(clk),
                            .reset(reset),
                            .data({2'b00, pos_player_y}),
                            .led_en(led_en[7:4]),
                            .dest(led_dest_2)
                            );
                            
    
    
endmodule
