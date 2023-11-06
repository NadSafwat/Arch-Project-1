`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2023 06:41:02 PM
// Design Name: 
// Module Name: RCA
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


module RCA #(parameter n=8)(
input [n-1:0] A, 
input [n-1:0] B,
output [n-1:0] P,
output carry,
output overflow
);

wire [n:0] C;
assign C[0] = 1'b0;
genvar i;

generate 
    for(i =0; i<n; i=i+1) begin
        full_adder FA(.A(A[i]), .B(B[i]), .cin(C[i]), .P(P[i]), .cout(C[i+1]));
    end
endgenerate 

assign carry = C[n];
assign overflow = (C[n] ^ C[n-1]);

endmodule
