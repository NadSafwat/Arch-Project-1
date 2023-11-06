`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2023 05:37:54 PM
// Design Name: 
// Module Name: processor
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


module processor(
    input clk,
    input ssdClk,
    input rst,
    input [1:0] ledSel,
    input [3:0] ssdSel,
    output reg [15:0] Inst_exec,
    output [6:0] LED_out,
    output [3:0] Anode
    );
    
    reg [7:0] PC;
    wire [31:0] Instruction;
    
    wire [7:0] PC4;
    wire [7:0] PCBranch;
    wire [7:0] PCin;
    
    wire Zflag;
    wire Sflag;
    wire Vflag;
    wire Cflag;

    wire Branch;
    wire Jump;
    wire MemRead;
    wire [1:0] regWriteSel;
    wire MemWrite;
    wire ALUsrc1;
    wire ALUsrc2;
    wire RegWrite;
    wire [1:0] ALUop;
    
    wire BranchAnd;
    wire PCen;
    wire [3:0] ALUsel;
    
    wire [31:0] RS1;
    wire [31:0] RS2;
    wire [31:0] RD;
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;
    
    wire [31:0] Immediate;
    wire [31:0] ALU_A;
    wire [31:0] ALU_B;
    wire [31:0] ALU_out;
    wire [31:0] Mem_out;
    reg [31:0] writeDataReg;

    wire[2:0] funct3;
    wire funct7;
    
    assign RS1 = Instruction[19:15];
    assign RS2 = Instruction[24:20];
    assign RD = Instruction[11:7];
    assign funct3 = Instruction[14:12];
    
    assign funct7 = ({funct3,Instruction[6:2]} == 8'b000_00100) ? 1'b0: Instruction[30];
    
    assign ALU_A = ALUsrc1 ? PC : ReadData1;
    assign ALU_B = ALUsrc2 ? Immediate : ReadData2;
    
    assign PCen = ({Instruction[20],Instruction[6:0]} == 8'b1_1110011) ? 1'b0: 1'b1;

    always@(*) begin
        case(regWriteSel)
            2'b00: writeDataReg = ALU_out;
            2'b01: writeDataReg = Mem_out;
            2'b10: writeDataReg = PC + 4;
            2'b11: writeDataReg = Immediate;
        endcase
    end

    InstMem IM(.addr(PC), .data_out(Instruction));
    Control_Unit CU(.opcode(Instruction[6:2]), .branch(Branch), .Jump(Jump), .MemRead(MemRead), .regWriteSel(regWriteSel), . MemWrite(MemWrite), .ALUSrc1(ALUsrc1), .ALUSrc2(ALUsrc2), .RegWrite(RegWrite), .ALUOp(ALUop));
    RegFile RF(.RS1(RS1), .RS2(RS2), .RD(RD), .regWrite(RegWrite), .clk(clk), .rst(rst), .writeData(writeDataReg), .readData1(ReadData1), .readData2(ReadData2));
    ImmGen IG(.inst(Instruction), .gen_out(Immediate));
    ALU_Control_Unit ALUCU(.funct3(funct3), .funct7(funct7), .ALUop(ALUop), .ALUSel(ALUsel));
    ALU alu (.A(ALU_A), .B (ALU_B),.S(ALUsel),.Zflag(Zflag), .Cflag(Cflag), .Sflag(Sflag), .Vflag(Vflag), .ALU_out(ALU_out));
    Branch_Control_Unit BCU (.funct3(funct3), .Zflag(Zflag), .Sflag(Sflag), .Vflag(Vflag), .Cflag(Cflag), .Branch(Branch), .BranchAnd(BranchAnd));
    DataMem DM(.clk(clk), .MemRead(MemRead), .funct3(funct3), .MemWrite(MemWrite), .addr(ALU_out[7:0]), .data_in(ReadData2), .data_out(Mem_out));
    
    
//    assign PCin = PC;
//    assign PC4 = PC + 4;
//    assign PCBranch = (PC + Immediate)%256;
    
    always @ (posedge clk or posedge rst) begin
        if(rst == 1)
            PC <= 0;
        else if (PCen == 0)
            PC <= PC;
        else begin
            if(BranchAnd) 
                PC <= (PC+Immediate)%256;
            else if(Jump)
                PC <= ALU_out;
            else 
                PC <= PC + 4;
       end   
    end
    
    
//    always @ (*) begin
//        case(ledSel) 
//            2'b00: Inst_exec = Instruction[15:0];
//            2'b01: Inst_exec = Instruction[31:16];
//            2'b10: Inst_exec = { Zflag, Branch, MemRead, MemtoReg, ALUop, MemWrite, ALUsrc, RegWrite, BranchAnd, ALUsel};
//    endcase
//    end 
  
//    reg [12:0] Num;
    
//    always @ (*) begin
//        case(ssdSel)
//            4'b0000: Num = PC;
//            4'b0001: Num = PC4;
//            4'b0010: Num = PCBranch;
//            4'b0011: Num = PCin;
//            4'b0100: Num = ReadData1[12:0];
//            4'b0101: Num = ReadData2[12:0];
//            4'b0110: Num = writeData[12:0];
//            4'b0111: Num = Immediate[12:0];
//            4'b1000: Num = Immediate[12:0];
//            4'b1001: Num = ALU_B[12:0];
//            4'b1010: Num = ALU_out[12:0];
//            4'b1011: Num = Mem_out[12:0];
//            default: Num = 13'b0;
//            endcase
//end 
 
//Seven_seg ss (.clk(ssdClk), .num(Num), .Anode(Anode), .LED_out(LED_out));

endmodule
