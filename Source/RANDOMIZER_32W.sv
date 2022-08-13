`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/27/2022 02:44:20 AM
// Design Name: 
// Module Name: RANDOMIZER_32W
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


//Reference: Catalin Baetoniu. High Speed True Random Number Generators in Xilinx FPGAs.
module RANDOMIZER_32W(
    input  wire logic clk,
    output      logic [31:0] random
    );
    (* OPTIMIZE="OFF" *)
    wire [31:0] flg, slg;   //first/second level gates
    reg [31:0] flr, slr;    //first/second level registers
    
    assign random = slr;
    
    assign flg[0] = ~(flg[31] ^ flg[0] ^ flg[1]);
    assign flg[1] = flg[0] ^ flg[1] ^ flg[2];
    assign flg[2] = flg[1] ^ flg[2] ^ flg[3];
    assign flg[3] = flg[2] ^ flg[3] ^ flg[4];
    assign flg[4] = flg[3] ^ flg[4] ^ flg[5];
    assign flg[5] = flg[4] ^ flg[5] ^ flg[6];
    assign flg[6] = flg[5] ^ flg[6] ^ flg[7];
    assign flg[7] = flg[6] ^ flg[7] ^ flg[8];
    assign flg[8] = flg[7] ^ flg[8] ^ flg[9];
    assign flg[9] = flg[8] ^ flg[9] ^ flg[10];
    assign flg[10] = flg[9] ^ flg[10] ^ flg[11];
    assign flg[11] = flg[10] ^ flg[11] ^ flg[12];
    assign flg[12] = flg[11] ^ flg[12] ^ flg[13];
    assign flg[13] = flg[12] ^ flg[13] ^ flg[14];
    assign flg[14] = flg[13] ^ flg[14] ^ flg[15];
    assign flg[15] = flg[14] ^ flg[15] ^ flg[16];
    assign flg[16] = flg[15] ^ flg[16] ^ flg[17];
    assign flg[17] = flg[16] ^ flg[17] ^ flg[18];
    assign flg[18] = flg[17] ^ flg[18] ^ flg[19];
    assign flg[19] = flg[18] ^ flg[19] ^ flg[20];
    assign flg[20] = flg[19] ^ flg[20] ^ flg[21];
    assign flg[21] = flg[20] ^ flg[21] ^ flg[22];
    assign flg[22] = flg[21] ^ flg[22] ^ flg[23];
    assign flg[23] = flg[22] ^ flg[23] ^ flg[24];
    assign flg[24] = flg[23] ^ flg[24] ^ flg[25];
    assign flg[25] = flg[24] ^ flg[25] ^ flg[26];
    assign flg[26] = flg[25] ^ flg[26] ^ flg[27];
    assign flg[27] = flg[26] ^ flg[27] ^ flg[28];
    assign flg[28] = flg[27] ^ flg[28] ^ flg[29];
    assign flg[29] = flg[28] ^ flg[29] ^ flg[30];
    assign flg[30] = flg[29] ^ flg[30] ^ flg[31];
    assign flg[31] = flg[30] ^ flg[31] ^ flg[1];
    
    always_ff @ (posedge clk) begin
        flr[0] <= flg[0];
        flr[1] <= flg[1];
        flr[2] <= flg[2];
        flr[3] <= flg[3];
        flr[4] <= flg[4];
        flr[5] <= flg[5];
        flr[6] <= flg[6];
        flr[7] <= flg[7];
        flr[8] <= flg[8];
        flr[9] <= flg[9];
        flr[10] <= flg[10];
        flr[11] <= flg[11];
        flr[12] <= flg[12];
        flr[13] <= flg[13];
        flr[14] <= flg[14];
        flr[15] <= flg[15];
        flr[16] <= flg[16];
        flr[17] <= flg[17];
        flr[18] <= flg[18];
        flr[19] <= flg[19];
        flr[20] <= flg[20];
        flr[21] <= flg[21];
        flr[22] <= flg[22];
        flr[23] <= flg[23];
        flr[24] <= flg[24];
        flr[25] <= flg[25];
        flr[26] <= flg[26];
        flr[27] <= flg[27];
        flr[28] <= flg[28];
        flr[29] <= flg[29];
        flr[30] <= flg[30];
        flr[31] <= flg[31];
    end
    
    assign slg[0] = 0 ^ flr[0] ^ slg[0] ^ slg[1];
    assign slg[1] = slg[0] ^ flr[1] ^ slg[1] ^ slg[2];
    assign slg[2] = slg[1] ^ flr[2] ^ slg[2] ^ slg[3];
    assign slg[3] = slg[2] ^ flr[3] ^ slg[3] ^ slg[4];
    assign slg[4] = slg[3] ^ flr[4] ^ slg[4] ^ slg[5];
    assign slg[5] = slg[4] ^ flr[5] ^ slg[5] ^ slg[6];
    assign slg[6] = slg[5] ^ flr[6] ^ slg[6] ^ slg[7];
    assign slg[7] = slg[6] ^ flr[7] ^ slg[7] ^ slg[8];
    assign slg[8] = slg[7] ^ flr[8] ^ slg[8] ^ slg[9];
    assign slg[9] = slg[8] ^ flr[9] ^ slg[9] ^ slg[10];
    assign slg[10] = slg[9] ^ flr[10] ^ slg[10] ^ slg[11];
    
    assign slg[11] = slg[10] ^ flr[11] ^ slg[11] ^ slg[12];
    assign slg[12] = slg[11] ^ flr[12] ^ slg[12] ^ slg[13];
    assign slg[13] = slg[12] ^ flr[13] ^ slg[13] ^ slg[14];
    assign slg[14] = slg[13] ^ flr[14] ^ slg[14] ^ slg[15];
    assign slg[15] = slg[14] ^ flr[15] ^ slg[15] ^ slg[16];
    assign slg[16] = slg[15] ^ flr[16] ^ slg[16] ^ slg[17];
    assign slg[17] = slg[16] ^ flr[17] ^ slg[17] ^ slg[18];
    assign slg[18] = slg[17] ^ flr[18] ^ slg[18] ^ slg[19];
    assign slg[19] = slg[18] ^ flr[19] ^ slg[19] ^ slg[20];
    assign slg[20] = slg[19] ^ flr[20] ^ slg[20] ^ slg[21];
    
    assign slg[21] = slg[20] ^ flr[21] ^ slg[21] ^ slg[22];
    assign slg[22] = slg[21] ^ flr[22] ^ slg[22] ^ slg[23];
    assign slg[23] = slg[22] ^ flr[23] ^ slg[23] ^ slg[24];
    assign slg[24] = slg[23] ^ flr[24] ^ slg[24] ^ slg[25];
    assign slg[25] = slg[24] ^ flr[25] ^ slg[25] ^ slg[26];
    assign slg[26] = slg[25] ^ flr[26] ^ slg[26] ^ slg[27];
    assign slg[27] = slg[26] ^ flr[27] ^ slg[27] ^ slg[28];
    assign slg[28] = slg[27] ^ flr[28] ^ slg[28] ^ slg[29];
    assign slg[29] = slg[28] ^ flr[29] ^ slg[29] ^ slg[30];
    assign slg[30] = slg[29] ^ flr[30] ^ slg[30] ^ slg[31];
    assign slg[31] = slg[30] ^ flr[31] ^ slg[31] ^ 0;
    
    always_ff @ (posedge clk) begin
        slr[0] <= slg[0];
        slr[1] <= slg[1];
        slr[2] <= slg[2];
        slr[3] <= slg[3];
        slr[4] <= slg[4];
        slr[5] <= slg[5];
        slr[6] <= slg[6];
        slr[7] <= slg[7];
        slr[8] <= slg[8];
        slr[9] <= slg[9];
        slr[10] <= slg[10];
        slr[11] <= slg[11];
        slr[12] <= slg[12];
        slr[13] <= slg[13];
        slr[14] <= slg[14];
        slr[15] <= slg[15];
        slr[16] <= slg[16];
        slr[17] <= slg[17];
        slr[18] <= slg[18];
        slr[19] <= slg[19];
        slr[20] <= slg[20];
        slr[21] <= slg[21];
        slr[22] <= slg[22];
        slr[23] <= slg[23];
        slr[24] <= slg[24];
        slr[25] <= slg[25];
        slr[26] <= slg[26];
        slr[27] <= slg[27];
        slr[28] <= slg[28];
        slr[29] <= slg[29];
        slr[30] <= slg[30];
        slr[31] <= slg[31];
    end
    
    assign random[0] = slr[0];
    assign random[1] = slr[1];
    assign random[2] = slr[2];
    assign random[3] = slr[3];
    assign random[4] = slr[4];
    assign random[5] = slr[5];
    assign random[6] = slr[6];
    assign random[7] = slr[7];
    assign random[8] = slr[8];
    assign random[9] = slr[9];
    assign random[10] = slr[10];
    assign random[11] = slr[11];
    assign random[12] = slr[12];
    assign random[13] = slr[13];
    assign random[14] = slr[14];
    assign random[15] = slr[15];
    assign random[16] = slr[16];
    assign random[17] = slr[17];
    assign random[18] = slr[18];
    assign random[19] = slr[19];
    assign random[20] = slr[20];
    assign random[21] = slr[21];
    assign random[22] = slr[22];
    assign random[23] = slr[23];
    assign random[24] = slr[24];
    assign random[25] = slr[25];
    assign random[26] = slr[26];
    assign random[27] = slr[27];
    assign random[28] = slr[28];
    assign random[29] = slr[29];
    assign random[30] = slr[30];
    assign random[31] = slr[31];
    
endmodule
