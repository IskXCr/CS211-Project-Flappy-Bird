`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2022 07:58:16 PM
// Design Name: 
// Module Name: VGA_DRIVER
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


module VGA_DRIVER(
    input  wire logic clk,              //clk base frequency: 100 MHz
    input  wire logic rst_n,            //High active
    
    input  wire logic [11:0] v_data,    //Input color data
    output      logic [3:0]  red,
    output      logic [3:0]  green,
    output      logic [3:0]  blue,
    output      logic        hsync,
    output      logic        vsync,
    output      logic [11:0] pos_x,    //Output current rendering position
    output      logic [11:0] pos_y     //Output current rendering position
    );
    
    wire dri_clk;
    clk_wiz_0 clk_gen(.clk_in1(clk), .clk_out1(dri_clk), .reset(1'b0));
    
    
    //mode: 1920*1080 @60Hz
    parameter integer   RES_H = 12'd1920,
                        RES_V = 12'd1080;
    //Horizontal
    parameter integer   C_H_SYNC_PULSE  =   12'd44,     //a
                        C_H_BACK_PORCH  =   12'd148,    //b
                        C_H_ACTIVE_TIME =   12'd1920,   //c
                        C_H_FRONT_PORCH =   12'd88,     //d
                        C_H_LINE_PERIOD =   12'd2200;   //e
    //vertical
    parameter integer   C_V_SYNC_PULSE  =   12'd5,      //a
                        C_V_BACK_PORCH  =   12'd36,     //b
                        C_V_ACTIVE_TIME =   12'd1080,   //c
                        C_V_FRONT_PORCH =   12'd4,      //d
                        C_V_FRAME_PERIOD=   12'd1125;   //e
    
    //horizontal counter
    reg [11:0] hc;
    wire [11:0] hcp;
    assign pos_x = (hc - (C_H_SYNC_PULSE + C_H_BACK_PORCH)) > 0 ? hc - (C_H_SYNC_PULSE + C_H_BACK_PORCH): 0;
    always @(posedge dri_clk) begin
       if(rst_n)
           hc <= 0;
       else if(hc == C_H_LINE_PERIOD - 1)
           hc <= 0;
       else
           hc <= hc + 1;
    end
     
    //vertical counter
    reg [11:0] vc;
    assign pos_y = (vc - (C_V_SYNC_PULSE + C_V_BACK_PORCH)) > 0 ? vc - (C_V_SYNC_PULSE + C_V_BACK_PORCH): 0;

    always @(posedge dri_clk) begin
       if(rst_n)
           vc <= 0;
       else if(vc == C_V_FRAME_PERIOD - 1 && hc == C_H_LINE_PERIOD - 1)
           vc <= 0;
       else if(hc == C_H_LINE_PERIOD - 1)
           vc <= vc + 1;
       else
           vc <= vc;
    end
    
    initial begin
        vc <= 0;
        hc <= 0;
    end
                
    assign hsync = (hc < C_H_SYNC_PULSE) ? 0 : 1;
    assign vsync = (vc < C_V_SYNC_PULSE) ? 0 : 1;

    wire active = (hc >= (C_H_SYNC_PULSE + C_H_BACK_PORCH)) && 
                  (hc < (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_H_ACTIVE_TIME)) &&
                  (vc >= (C_V_SYNC_PULSE + C_V_BACK_PORCH)) && 
                  (vc < (C_V_SYNC_PULSE + C_V_BACK_PORCH + C_V_ACTIVE_TIME)) ? 1 : 0;
                  
    assign {red, green, blue} = (rst_n == 1 || ~active) ? 12'h000 : v_data;
    
endmodule
