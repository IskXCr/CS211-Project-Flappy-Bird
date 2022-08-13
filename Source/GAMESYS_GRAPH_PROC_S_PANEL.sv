`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/31/2022 01:27:42 AM
// Design Name: 
// Module Name: GAMESYS_GRAPH_PROC_S_PANEL
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

module GAMESYS_GRAPH_PROC_S_PANEL(
    input  wire logic pause,
    input  wire logic signed [`DATA_POSITION_SIZE - 1 : 0] pos_x,
    input  wire logic signed [`DATA_POSITION_SIZE - 1 : 0] pos_y,
    input  wire logic        [15 : 0]                      score,
    output      logic        [`COLOR_SIZE - 1 : 0]         vout_data,
    output wire logic enabled
    );
    
    assign enabled = (pos_y >= `PANEL_HEIGHT);
    
    //Text Position Judgements
                       
    wire signed [12:0] text_pos_y;
    wire signed [12:0] text_pos_x [0:3];
    wire enabled_text_x;
    wire enabled_text_x_partial [0:3];
    
    assign text_pos_y = (pos_y - `PANEL_HEIGHT - `PANEL_V_GAP >= 0 && pos_y - `PANEL_HEIGHT - `PANEL_V_GAP < `FONT_HEIGHT) ? pos_y - `PANEL_HEIGHT - `PANEL_V_GAP : `INVALID_DATA_POS; 
    
    assign enabled_text_x = enabled_text_x_partial[0]
                              || enabled_text_x_partial[1]
                              || enabled_text_x_partial[2]
                              || enabled_text_x_partial[3];
    
    genvar ptr;
    
    generate
        for (ptr = 0; ptr < 4; ptr++) begin
            assign enabled_text_x_partial[ptr] = (pos_x - `PANEL_H_GAP - (3 - ptr) * (`FONT_WIDTH + `FONT_GAP) >= 0) && (pos_x - `PANEL_H_GAP - (3 - ptr) * (`FONT_WIDTH + `FONT_GAP) < `FONT_WIDTH);
            assign text_pos_x[ptr] = enabled_text_x_partial[ptr] ? pos_x - `PANEL_H_GAP - (3 - ptr) * (`FONT_WIDTH + `FONT_GAP) : `INVALID_DATA_POS;
        end
    endgenerate
    
    //Font Library
    logic [0 : `FONT_WIDTH * `FONT_HEIGHT * `FONT_PIXEL_SIZE - 1] font_lib [0:15];
        
    initial begin
        $readmemh("%Absolute_Path%\\Sources\\fonts\\font_0.mem", font_lib, 0);
        $readmemh("%Absolute_Path%\\Sources\\fonts\\font_1.mem", font_lib, 1);
        $readmemh("%Absolute_Path%\\Sources\\fonts\\font_2.mem", font_lib, 2);
        $readmemh("%Absolute_Path%\\Sources\\fonts\\font_3.mem", font_lib, 3);
        $readmemh("%Absolute_Path%\\Sources\\fonts\\font_4.mem", font_lib, 4);
        $readmemh("%Absolute_Path%\\Sources\\fonts\\font_5.mem", font_lib, 5);
        $readmemh("%Absolute_Path%\\Sources\\fonts\\font_6.mem", font_lib, 6);
        $readmemh("%Absolute_Path%\\Sources\\fonts\\font_7.mem", font_lib, 7);
        $readmemh("%Absolute_Path%\\Sources\\fonts\\font_8.mem", font_lib, 8);
        $readmemh("%Absolute_Path%\\Sources\\fonts\\font_9.mem", font_lib, 9);
        $readmemh("%Absolute_Path%\\Sources\\fonts\\font_a.mem", font_lib, 10);
        $readmemh("%Absolute_Path%\\Sources\\fonts\\font_b.mem", font_lib, 11);
        $readmemh("%Absolute_Path%\\Sources\\fonts\\font_c.mem", font_lib, 12);
        $readmemh("%Absolute_Path%\\Sources\\fonts\\font_d.mem", font_lib, 13);
        $readmemh("%Absolute_Path%\\Sources\\fonts\\font_e.mem", font_lib, 14);
        $readmemh("%Absolute_Path%\\Sources\\fonts\\font_f.mem", font_lib, 15);
    end
    
    function [11:0] get_font_pix;       //Get the color of the pixel of the font
        input logic signed [12:0] f_pos_x, f_pos_y;
        input logic        [3:0]  data;
        begin
            get_font_pix = font_lib[data][f_pos_x * `FONT_PIXEL_SIZE + f_pos_y * `FONT_WIDTH * `FONT_PIXEL_SIZE] == 1 ? `TEXT_FORE_COLOR : (pause ? `PANEL_COLOR_OFF : `PANEL_COLOR_ON);
        end
    endfunction
    
    always_comb begin
        if (enabled) begin
            if (text_pos_y != `INVALID_DATA_POS && enabled_text_x) begin
                if (enabled_text_x_partial[3]) begin
                    vout_data = get_font_pix(.f_pos_x(text_pos_x[3]), .f_pos_y(text_pos_y), .data(score[15:12]));
                end
                else if (enabled_text_x_partial[2]) begin
                    vout_data = get_font_pix(.f_pos_x(text_pos_x[2]), .f_pos_y(text_pos_y), .data(score[11:8]));
                end
                else if (enabled_text_x_partial[1]) begin
                    vout_data = get_font_pix(.f_pos_x(text_pos_x[1]), .f_pos_y(text_pos_y), .data(score[7:4]));
                end
                else if (enabled_text_x_partial[0]) begin
                    vout_data = get_font_pix(.f_pos_x(text_pos_x[0]), .f_pos_y(text_pos_y), .data(score[3:0]));
                end
            end
            //Draw panel background
            else if (pause)
                vout_data = `PANEL_COLOR_OFF;
            else
                vout_data = `PANEL_COLOR_ON;
        end
        else
            vout_data = `DEFAULT_COLOR;
    end
    
    
endmodule
