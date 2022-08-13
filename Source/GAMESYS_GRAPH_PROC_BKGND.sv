`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/31/2022 01:27:42 AM
// Design Name: 
// Module Name: GAMESYS_GRAPH_PROC_BKGND
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

module GAMESYS_GRAPH_PROC_BKGND(
    input  wire logic base_clk,
    input  wire logic mem_clk,
    input  wire logic reset,
    
    input  wire logic        [31:0]                        random,
    
    input  wire logic signed [`DATA_POSITION_SIZE - 1 : 0] pos_x,
    input  wire logic signed [`DATA_POSITION_SIZE - 1 : 0] pos_y,
    
    output      logic        [`COLOR_SIZE - 1 : 0]         vout_data,
    output wire logic enabled
    );
    
    assign enabled = 1;
    
    wire [15:0] bkgnd_entity_data;
    wire [14:0] bkgnd_pos_x_pre;
    wire [14:0] bkgnd_pos_y;
    wire [14:0] addr_bkgnd_lib;
    
    assign bkgnd_pos_x_pre =  (pos_x == `RES_H - 1)? 0 : (pos_x + 1) % `BACKGROUND_IMG_H;
    assign bkgnd_pos_y = pos_y - `BACKGROUND_SKY_H;
    assign addr_bkgnd_lib = bkgnd_pos_x_pre + bkgnd_pos_y * `BACKGROUND_IMG_W;
    
    blk_mem_gen_3 bkgnd_lib(.addra(addr_bkgnd_lib),
                            .clka(mem_clk),
                            .douta(bkgnd_entity_data),
                            .ena(1));
    
    always_comb begin
        if (pos_y < `BACKGROUND_SKY_H)
            vout_data = `BACKGROUND_H_COLOR;
        else if (pos_y < `BACKGROUND_SKY_H + `BACKGROUND_IMG_H)
            vout_data = bkgnd_entity_data;
        else if (pos_y < `BACKGROUND_SKY_H + `BACKGROUND_IMG_H + `BACKGROUND_BASE_GAP)
            vout_data = `BACKGROUND_L_COLOR;
        else if (pos_y < `BACKGROUND_SKY_H + `BACKGROUND_IMG_H + `BACKGROUND_BASE_GAP + `BACKGROUND_LINE_H)
            vout_data = `BASE_COLOR_U_BOUND;
        else if (pos_y < `BACKGROUND_SKY_H + `BACKGROUND_IMG_H + `BACKGROUND_BASE_GAP + 2 * `BACKGROUND_LINE_H)
            vout_data = `BASE_COLOR_M_BOUND;
        else if (pos_y < `BACKGROUND_SKY_H + `BACKGROUND_IMG_H + `BACKGROUND_BASE_GAP + 10 * `BACKGROUND_LINE_H)
            if (pos_y <= `BACKGROUND_SKY_H + `BACKGROUND_IMG_H + `BACKGROUND_BASE_GAP + pos_x[5:0])
                vout_data = `BASE_COLOR_DEEP;
            else
                vout_data = `BASE_COLOR_SHAL;
        else if (pos_y < `BACKGROUND_SKY_H + `BACKGROUND_IMG_H + `BACKGROUND_BASE_GAP + 11 * `BACKGROUND_LINE_H)
            vout_data = `BASE_COLOR_L_BOUND;
        else if (pos_y < `BACKGROUND_SKY_H + `BACKGROUND_IMG_H + `BACKGROUND_BASE_GAP + 12 * `BACKGROUND_LINE_H)
            vout_data = `BASE_COLOR_SHADOW;
        else
            vout_data = `BASE_COLOR_L_FILL;
    end
    
    
    
    
    
endmodule
