`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2023 06:39:43 PM
// Design Name: 
// Module Name: ALU
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


module ALU #(parameter n = 32)
   (
    input [n-1:0] A,
    input [n-1:0] B,
    input [3:0] S,
    output Zflag,
    output Vflag,
    output Sflag,
    output Cflag,
    output reg [n-1:0] ALU_out
    );
    
    wire [n-1:0] ADD;
    wire [n-1:0] SUB;
    wire [n-1:0] AND;
    wire [n-1:0] OR;
    wire [n-1:0] zero;
    wire [n-1:0] mux_out;
    
    wire [n-1:0] TwosComp;
    assign TwosComp = (~B +1);
    
    assign mux_out = (S == 4'b0000) ? B : TwosComp;
    RCA #(.n(32)) rca (.A(A), .B(mux_out), .P(ADD), .carry(Cflag), .overflow(Vflag));
    assign SUB = ADD;
 
    //assign zero = 32'b0;
    
    always @ (*) begin
         case(S)
            4'b0000: ALU_out = ADD;
            4'b0001: ALU_out = SUB;
            4'b0011: ALU_out = B;
            4'b0100: ALU_out = A | B;
            4'b0101: ALU_out = A & B;
            4'b0111: ALU_out = A ^ B;
            4'b1000: ALU_out = A >> B;
            4'b1010: ALU_out = $signed(A) >>> B;
            4'b1001: ALU_out = A << B;
            4'b1101: ALU_out = (Sflag != Vflag) ?  32'b1 : 32'b0;
            4'b1111: ALU_out = (~Cflag) ? 32'b1 : 32'b0;
         endcase
    end
    
    assign Zflag = (SUB == 0) ? 1'b1 : 1'b0;
//    assign Vflag = A[n-1] ^ B[n-1] ^ ADD[n-1] ^ Cflag;
    assign Sflag = SUB[n-1];
   
endmodule

