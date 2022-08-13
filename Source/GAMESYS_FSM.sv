`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2022 01:20:06 PM
// Design Name: 
// Module Name: GAMESYS_FSM
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


module GAMESYS_FSM(
    input  wire logic game_clk,
    input  wire logic reset,
    
    input  wire logic btn_jmp,
    
    input  wire logic failed,
    output      logic pause
    );
    
    logic btn_jmp_old;
    
    //Initializaing game status
    initial begin
        pause <= 1;
        btn_jmp_old <= 0;
    end
    
    //Processing failures & resets
    always @ (posedge game_clk or posedge reset) begin
        if (reset) begin
            pause <= 1;
        end
        else begin
            if (~failed && btn_jmp_old != btn_jmp && btn_jmp == 1 && pause) begin
                pause <= 0;
            end
            else if (failed) begin
                pause <= 1;
            end
            btn_jmp_old <= btn_jmp;
        end
    end
    
endmodule
