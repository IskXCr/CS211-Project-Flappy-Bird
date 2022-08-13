`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/24/2022 10:38:40 PM
// Design Name: 
// Module Name: LED_DRIVER_4D
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


module LED_DRIVER_4D(
    input  wire logic clk,
    input  wire logic reset,
    input  wire logic [15:0] data,
    output      logic [3:0]  led_en,
    output      logic [7:0]  dest
    );
    
    
    integer i = 0;
    parameter frame_shift = 18;
    parameter integer frame_slice = (1 << frame_shift);
     
    //Calibrating Timer
    always @ (posedge clk) begin
        if (i == 10000000) begin
            i <= 0;
        end
        else begin
            i <= i + 1;
        end
    end
    
    reg [1:0] sel;
    reg [3:0] v_data;
    
    initial begin
        sel <= 0;
        dest <= 8'b0000_0000;
    end
    
    always_ff @ (posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 4; i++)
                led_en[i] <= 1'b1;
            sel <= 0;
        end
        else if (i[frame_shift:0] == frame_slice) begin
            for (int i = 0; i < 4; i++) begin
                if (i == sel)
                    led_en[i] <= 1'b1;
                else
                    led_en[i] <= 1'b0;
            end
            sel <= sel + 2'b01;
        end
    end
    
    always_ff @ (posedge clk or posedge reset) begin
        if (reset) begin
            v_data <= 4'h0;
        end
        else if (i[frame_shift:0] == frame_slice) begin
            case(sel)
                2'b00: v_data <= data[3:0];
                2'b01: v_data <= data[7:4];
                2'b10: v_data <= data[11:8];
                2'b11: v_data <= data[15:12];
            endcase
        end
    end
    
    always_comb begin
        if (reset) begin
            dest = 8'b0000_0000;
        end
        else begin
            case (v_data)
                4'h0: dest = 8'b1111_1100; //0
                4'h1: dest = 8'b0110_0000;
                4'h2: dest = 8'b1101_1010;
                4'h3: dest = 8'b1111_0010;
                4'h4: dest = 8'b0110_0110;
                4'h5: dest = 8'b1011_0110;
                4'h6: dest = 8'b1011_1110;
                4'h7: dest = 8'b1110_0000;
                
                4'h8: dest = 8'b1111_1110;
                4'h9: dest = 8'b1110_0110;
                4'hA: dest = 8'b1110_1110;
                4'hB: dest = 8'b0011_1110;
                4'hC: dest = 8'b0001_1010;
                4'hD: dest = 8'b0111_1010;
                4'hE: dest = 8'b1001_1110;
                4'hF: dest = 8'b1000_1110;
            endcase
        end
    end
    
endmodule
