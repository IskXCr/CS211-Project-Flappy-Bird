`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/31/2022 01:27:42 AM
// Design Name: 
// Module Name: GAMESYS_GRAPH_PROC_PLAYER
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

module GAMESYS_GRAPH_PROC_PLAYER(
    input  wire logic base_clk,
    input  wire logic game_clk,
    input  wire logic mem_clk,
    input  wire logic reset,
    
    input  wire logic signed [`DATA_POSITION_SIZE - 1 : 0] pos_x,
    input  wire logic signed [`DATA_POSITION_SIZE - 1 : 0] pos_y,
    
    input  wire logic signed [`DATA_POSITION_SIZE - 1 : 0] pos_player_x,
    input  wire logic signed [`DATA_POSITION_SIZE - 1 : 0] pos_player_y,
    
    output      logic        [`COLOR_SIZE - 1 : 0]         vout_data,
    output wire logic enabled
    );
    
    integer i;
    
    always_ff @ (posedge game_clk or posedge reset) begin
        if (reset)
            i <= 0;
        else begin
            i <= i + 1;
        end
    end
    
    logic player_frame;
    always_ff @ (posedge game_clk or posedge reset) begin
        if (reset)
            player_frame <= 0;
        else if (i[`FRAME_SHIFT + 3] == 1)
            player_frame <= ~player_frame;
    end
    
    wire signed [`DATA_POSITION_SIZE - 1 : 0] player_entity_pos_x,     //Corrected Player Pixel Position in the Library
                       player_entity_pos_x_iv,  //Corrected Player Pixel Position in the Library
                       player_entity_pos_y,     //Corrected Player Pixel Position in the Library
                       player_entity_pos_y_iv;  //Corrected Player Pixel Position in the Library
    
    assign player_entity_pos_x_iv = pos_x - pos_player_x + `PLAYER_HALF_WIDTH;
    assign player_entity_pos_x    = (player_entity_pos_x_iv >= 0 && player_entity_pos_x_iv < `PLAYER_HALF_WIDTH * 2) ? player_entity_pos_x_iv : `INVALID_DATA_POS;
    assign player_entity_pos_y_iv = pos_y - pos_player_y + `PLAYER_HALF_HEIGHT;
    assign player_entity_pos_y    = (player_entity_pos_y_iv >= 0 && player_entity_pos_y_iv < `PLAYER_HALF_HEIGHT * 2) ? player_entity_pos_y_iv : `INVALID_DATA_POS;
    
    //Player Entity Asset Memory
    wire [15:0] player_entity_data [0:1];
    wire [`DATA_POSITION_SIZE - 1 : 0] addr_player_lib;
    
    
    
    wire signed [`DATA_POSITION_SIZE - 1 : 0] player_entity_pos_x_pre,     //Corrected Player Pixel Position in the Library
                       player_entity_pos_x_iv_pre,  //Corrected Player Pixel Position in the Library
                       player_entity_pos_y_pre,     //Corrected Player Pixel Position in the Library
                       player_entity_pos_y_iv_pre;  //Corrected Player Pixel Position in the Library
    
    assign player_entity_pos_x_iv_pre = pos_x - pos_player_x + `PLAYER_HALF_WIDTH + 1;
    assign player_entity_pos_x_pre    = (player_entity_pos_x_iv_pre >= 0 && player_entity_pos_x_iv_pre < `PLAYER_HALF_WIDTH * 2) ? player_entity_pos_x_iv_pre : `INVALID_DATA_POS;
    
    assign addr_player_lib = (player_entity_pos_x_pre + player_entity_pos_y * `PLAYER_HALF_WIDTH * 2 >= `PLAYER_HALF_WIDTH * `PLAYER_HALF_HEIGHT * 4) ? 0 : player_entity_pos_x_pre + player_entity_pos_y * `PLAYER_HALF_WIDTH * 2;
    
    blk_mem_gen_0 player_lib_1(.addra(addr_player_lib[11:0]),
                                      .clka(mem_clk),
                                      .douta(player_entity_data[0]),
                                      .ena(1));
    
    blk_mem_gen_1 player_lib_2(.addra(addr_player_lib[11:0]),
                                      .clka(mem_clk),
                                      .douta(player_entity_data[1]),
                                      .ena(1));
    
    assign enabled = (player_entity_pos_x != `INVALID_DATA_POS && player_entity_pos_y != `INVALID_DATA_POS) && (player_entity_data[player_frame][15:12] == 4'hf);
    
    always_comb begin
        if (player_entity_pos_x != `INVALID_DATA_POS && player_entity_pos_y != `INVALID_DATA_POS) begin
            vout_data = player_entity_data[player_frame][11:0];
        end
        else
            vout_data = `DEFAULT_COLOR;
    end
endmodule
