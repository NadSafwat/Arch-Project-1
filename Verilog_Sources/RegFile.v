`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2023 06:17:25 PM
// Design Name: 
// Module Name: RegFile
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


module RegFile #(parameter n = 32)(
input [4:0] RS1,
input [4:0] RS2,
input [4:0] RD,
input regWrite,
input clk,
input rst,
input [n-1:0] writeData,
output [n-1:0] readData1,
output [n-1:0] readData2
    );
    
reg [n-1:0] Registers [31:0];
integer i;

always @ (posedge clk or posedge rst) begin
    if(rst == 1'b1) begin
        for(i =0; i<n; i=i+1) begin
            Registers[i] <= 0;
        end
    end
    
    else if(regWrite == 1'b1) begin
        if(RD != 0) 
            Registers[RD] <= writeData;
    end
end 

    assign readData1 = Registers[RS1];
    assign readData2 = Registers[RS2];
endmodule
