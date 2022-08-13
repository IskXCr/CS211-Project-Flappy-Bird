`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2022 01:18:36 PM
// Design Name: 
// Module Name: GAMESYS_PHY
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


module GAMESYS_PHY(
    input  wire logic game_clk,
    input  wire logic reset,
    input  wire logic pause,
    
    input  wire logic btn_jmp,
    
    input  wire logic [31:0] random,
    input  wire logic [2:0]  diff,
    
    output      logic signed [`DATA_POSITION_SIZE - 1 : 0] pos_player_x,
    output      logic signed [`DATA_POSITION_SIZE - 1 : 0] pos_player_y,
    output      logic signed [`DATA_POSITION_SIZE - 1 : 0] pos_wall_x      [0:4],
    output      logic signed [`DATA_POSITION_SIZE - 1 : 0] pos_wall_y      [0:4],
    output      logic signed [`DATA_POSITION_SIZE - 1 : 0] pos_wall_height [0:4],
    output      logic        [15:0]                        score
    );
    //Drop speed: Starting from velocity 0 m/s, falling through 60% of the screen takes 1.00 s. 
    //h = 1/2 g * t * t
    //Five obstacles are used for looping.
    
    logic signed [`DATA_POSITION_SIZE - 1 : 0] v_speed, h_speed;
    
    logic signed [`DATA_POSITION_SIZE - 1 : 0] def_pos_wall_y      [0:3];         //Sample data y for randomization
    logic signed [`DATA_POSITION_SIZE - 1 : 0] def_pos_wall_height [0:3];    //Sample data height for randomization
    logic signed [`DATA_POSITION_SIZE - 1 : 0] def_h_speed_lib     [0:7];        //Horizontal speed preset.
    
    initial begin
        h_speed <= `H_SPEED_PRESET;
        def_pos_wall_y[0] <= 13'sd250;
        def_pos_wall_y[1] <= 13'sd350;
        def_pos_wall_y[2] <= 13'sd150;
        def_pos_wall_y[3] <= 13'sd450;
        def_pos_wall_height[0] <= 13'sd400;
        def_pos_wall_height[1] <= 13'sd350;
        def_pos_wall_height[2] <= 13'sd300;
        def_pos_wall_height[3] <= 13'sd250;
        
        def_h_speed_lib[0] <= -13'd3;
        def_h_speed_lib[1] <= -13'd5;
        def_h_speed_lib[2] <= -13'd8;
        def_h_speed_lib[3] <= `H_SPEED_PRESET;
        def_h_speed_lib[4] <= -13'd12;
        def_h_speed_lib[5] <= -13'd15;
        def_h_speed_lib[6] <= -13'd20;
        def_h_speed_lib[7] <= -13'd30;
    end
    
    always @ (posedge game_clk) begin
        h_speed <= def_h_speed_lib[diff];
    end
    
    initial begin
        //Initialize obstacles
        
        for (int i = 0; i < 5; i++) begin
            pos_wall_x[i] <= (`RES_H >> 3) * (5 + (i << 1));
        end
        
        //Test position y
        //Todo: modify this
        pos_wall_y[0] <= 13'sd255;
        pos_wall_y[1] <= 13'sd325;
        pos_wall_y[2] <= 13'sd275;
        pos_wall_y[3] <= 13'sd200;
        pos_wall_y[4] <= 13'sd225;
        
        //Test height
        //Todo: modify this
        pos_wall_height[0] <= 13'sd400;
        pos_wall_height[1] <= 13'sd375;
        pos_wall_height[2] <= 13'sd350;
        pos_wall_height[3] <= 13'sd240;
        pos_wall_height[4] <= 13'sd300;
    end
    
    //Physical simulation: movement and acceleration
    logic btn_jmp_old;
    
    initial begin
        btn_jmp_old <= 1'b0;
        score <= 0;
    end
    
    always_ff @ (posedge game_clk or posedge reset) begin
        if (reset) begin
            //Reset physics
            v_speed <= `V_SPEED_PRESET;
            btn_jmp_old <= 0;
            pos_player_x <= `DEF_PLAYER_POS_X;
            pos_player_y <= `DEF_PLAYER_POS_Y;
            
            for (int i = 0; i < 5; i++) begin
                pos_wall_x[i] <= (`RES_H >> 3) * (5 + (i << 1));
            end
            
//            for (ptr_1 = 3'd0; ptr_1 < 3'd5; ptr_1 = ptr_1 + 3'd1) begin
//                pos_wall_y[ptr_1] <= def_pos_wall_y[i[((ptr_1 << 1) + 1) : (ptr_1 << 1)]];
//            end
            for (int i = 0; i < 5; i++) begin
                pos_wall_y[i] <= def_pos_wall_y[random[(i << 1)+:2]];
            end
            
            for (int i = 0; i < 5; i++) begin
                pos_wall_height[i] <= def_pos_wall_height[random[((i << 1) + 11)+:2]];
            end
            
            //Score
            score <= 16'd0;
        end
        else if (~pause) begin    
            if (btn_jmp != btn_jmp_old && btn_jmp == 1)
                v_speed <= `V_SPEED_PRESET;
            else
                v_speed <= v_speed + `GRAVITY_ACCEL;
                
            btn_jmp_old <= btn_jmp;
            
            pos_player_y <= pos_player_y + ((v_speed + v_speed + `GRAVITY_ACCEL) >> 1);
            
            for (int i = 0; i < 5; i++) begin
                if (pos_wall_x[i] + h_speed < 13'sd0 - `WALL_HALF_WIDTH) begin           //If the position exceeds the left boundary
                    pos_wall_x[i] <= (`RES_H >> 2) * 5 + (- `WALL_HALF_WIDTH) + h_speed;
                    
                    pos_wall_y[i] <= def_pos_wall_y[random[1:0]];
                    pos_wall_height[i] <= def_pos_wall_height[random[3:2]];
                    
                    //Adding score
                    score <= (score == 0) ? 2 : score + 16'd1;
                end
                else
                    pos_wall_x[i] <= pos_wall_x[i] + h_speed;
            end
        end
    end
    
endmodule
