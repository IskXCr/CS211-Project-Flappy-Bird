`define DATA_POSITION_SIZE  13
`define INVALID_DATA_POS    13'b1_1111_1111_1111
`define COLOR_SIZE          12

`define RES_H               13'sd1920
`define RES_V               13'sd1080
`define DEF_PLAYER_POS_X    (`RES_H >> 2)
`define DEF_PLAYER_POS_Y    (`RES_V >> 1)


`define PLAYER_HALF_WIDTH   13'sd34
`define PLAYER_HALF_HEIGHT  13'sd24
`define WALL_HALF_WIDTH     13'sd120

`define JUDGE_TOLERANCE     13'sd0
    
`define FONT_HEIGHT         13'sd30
`define FONT_WIDTH          13'sd16
`define FONT_GAP            13'sd6

`define DEFAULT_COLOR       12'h000
`define WALL_COLOR          12'h0d8
`define PLAYER_FORE_COLOR   12'hfe8
`define PLAYER_BACK_COLOR   12'h000
`define BACKGROUND_H_COLOR  12'h4cc
`define BACKGROUND_M_COLOR  12'hdef
`define BACKGROUND_L_COLOR  12'h5e7
`define BACKGROUND_SKY_H    ((`RES_V >> 3) * 5)
`define BACKGROUND_IMG_W    288
`define BACKGROUND_IMG_H    88
`define BACKGROUND_BASE_GAP 130
`define BACKGROUND_LINE_H   4
`define BASE_COLOR_DEEP     12'h7b2
`define BASE_COLOR_SHAL     12'h9e5
`define BASE_COLOR_U_BOUND  12'h534
`define BASE_COLOR_M_BOUND  12'hef8
`define BASE_COLOR_L_BOUND  12'h582
`define BASE_COLOR_SHADOW   12'hda4
`define BASE_COLOR_L_FILL   12'hdd9
`define PANEL_COLOR_ON      12'h0f0
`define PANEL_COLOR_OFF     12'hf00
`define PANEL_HEIGHT        (`RES_V / 16 * 15)
`define PANEL_V_GAP         13'sd10
`define PANEL_H_GAP         (`RES_H / 2 - 2 * `FONT_WIDTH - 2 * `FONT_GAP)


`define FRAME_SHIFT         20
`define FRAME_SLICE_HALF    (1 << (`FRAME_SHIFT)) //60 FPS - 1666666 cycles per frame
`define GRAVITY_ACCEL       int'((0.6 * (`RES_V - `PANEL_HEIGHT) * 2 / 600) + 0.5)
`define V_SPEED_PRESET      -13'd15      //Vertical speed preset
`define H_SPEED_PRESET      -13'd10

`define GROUND_HEIGHT       (`BACKGROUND_SKY_H + `BACKGROUND_IMG_H + `BACKGROUND_BASE_GAP)

`define TEXT_FORE_COLOR     12'hfff
`define TEXT_BACK_COLOR     12'h000
`define FONT_PIXEL_SIZE     1
