`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/31/2022 01:26:39 AM
// Design Name: 
// Module Name: GAMESYS_GRAPH_PROC_WALLS
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

module GAMESYS_GRAPH_PROC_WALLS(
    input  wire logic base_clk,
    input  wire logic game_clk,
    input  wire logic mem_clk,
    input  wire logic reset,
    
    input  wire logic signed [`DATA_POSITION_SIZE - 1 : 0] pos_x,
    input  wire logic signed [`DATA_POSITION_SIZE - 1 : 0] pos_y,
    
    input  wire logic signed [`DATA_POSITION_SIZE - 1 : 0] pos_wall_x       [0:4],
    input  wire logic signed [`DATA_POSITION_SIZE - 1 : 0] pos_wall_y       [0:4],
    input  wire logic signed [`DATA_POSITION_SIZE - 1 : 0] pos_wall_height  [0:4],
    
    output      logic        [`COLOR_SIZE - 1 : 0]         vout_data,
    output wire logic enabled
    );
    
    wire  [15:0]                    wall_entity_data;
    logic [`DATA_POSITION_SIZE - 1 : 0] addr_wall_lib;
    
    blk_mem_gen_2 wall_lib(.addra(addr_wall_lib[7:0]),
                           .clka(mem_clk),
                           .douta(wall_entity_data),
                           .ena(1));
    
    wire enabled_partial [0:4];
    genvar ptr;
    generate
        for (ptr = 0; ptr < 5; ptr++) begin
            assign enabled_partial[ptr] = pos_x <= pos_wall_x[ptr] + `WALL_HALF_WIDTH - `DATA_POSITION_SIZE'sb1 && pos_x >= pos_wall_x[ptr] - `WALL_HALF_WIDTH
                                            && ((pos_y >= pos_wall_y[ptr] + pos_wall_height[ptr]) || pos_y < pos_wall_y[ptr]);
        end
    endgenerate
    
    assign enabled = pos_y <= `GROUND_HEIGHT 
                       && (enabled_partial[0]
                       || enabled_partial[1]
                       || enabled_partial[2]
                       || enabled_partial[3]
                       || enabled_partial[4]);
    
    wire enabled_pre_partial [0:4];
    wire [`DATA_POSITION_SIZE - 1 : 0] wall_entity_pos_x_pre [0:4];
    generate
        for (ptr = 0; ptr < 5; ptr++) begin
            assign enabled_pre_partial[ptr] = pos_x + `DATA_POSITION_SIZE'sd1 <= pos_wall_x[ptr] + `WALL_HALF_WIDTH - `DATA_POSITION_SIZE'sd1 && pos_x + `DATA_POSITION_SIZE'sd1 >= pos_wall_x[ptr] - `WALL_HALF_WIDTH;
            assign wall_entity_pos_x_pre[ptr] = (pos_x + `DATA_POSITION_SIZE'sd1 - (pos_wall_x[ptr] - `WALL_HALF_WIDTH) >= `WALL_HALF_WIDTH * 2) ? 0 : pos_x + `DATA_POSITION_SIZE'sd1 - (pos_wall_x[ptr] - `WALL_HALF_WIDTH);
        end
    endgenerate
    
    always_comb begin
        if (enabled_pre_partial[0])
            addr_wall_lib = wall_entity_pos_x_pre[0];
        else if (enabled_pre_partial[1])
            addr_wall_lib = wall_entity_pos_x_pre[1];
        else if (enabled_pre_partial[2])
            addr_wall_lib = wall_entity_pos_x_pre[2];
        else if (enabled_pre_partial[3])
            addr_wall_lib = wall_entity_pos_x_pre[3];
        else if (enabled_pre_partial[4])
            addr_wall_lib = wall_entity_pos_x_pre[4];
        else
            addr_wall_lib = 10'd0;
    end
                       
    always_comb begin
        if (enabled) 
            vout_data = wall_entity_data[11:0];
        else
            vout_data = `DEFAULT_COLOR;
    end
endmodule
