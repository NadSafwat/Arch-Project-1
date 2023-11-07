`timescale 1ns / 1ps
/*******************************************************************
* Module: processor.v
* Project: Arch-Project-1
* Authors: Nadine Safwat nadine.hkm@aucegypt.edu
           Nour Kasaby N.Kasaby@aucegypt.edu
* Description: 
* Change history: 17/10/23 – Created module in lab
                  03/11/23 -  edited module to include all instructions
**********************************************************************/


module processor(
    input clk,
    input ssd_Clk,
    input rst,
    input [1:0] led_Sel,
    input [3:0] ssd_Sel,
    output reg [15:0] Inst_exec,
    output [6:0] LED_out,
    output [3:0] Anode
    );
    
    reg [7:0] PC;
    wire [31:0] Instruction;
    
    wire [7:0] PC4;
    wire [7:0] PC_Branch;
    wire [7:0] PC_in;
    
    wire Z_flag;
    wire S_flag;
    wire V_flag;
    wire C_flag;

    wire Branch;
    wire Jump;
    wire Mem_Read;
    wire [1:0] reg_Write_Sel;
    wire Mem_Write;
    wire ALU_src1;
    wire ALU_src2;
    wire Reg_Write;
    wire [1:0] ALU_op;
    
    wire Branch_And;
    wire PC_en;
    wire [3:0] ALU_sel;
    
    wire [31:0] RS1;
    wire [31:0] RS2;
    wire [31:0] RD;
    wire [31:0] Read_Data1;
    wire [31:0] Read_Data2;
    
    wire [31:0] Immediate;
    wire [31:0] ALU_A;
    wire [31:0] ALU_B;
    wire [31:0] ALU_out;
    wire [31:0] Mem_out;
    reg [31:0] write_Data_Reg;

    wire[2:0] funct3;
    wire funct7;
    
    assign RS1 = Instruction[19:15];
    assign RS2 = Instruction[24:20];
    assign RD = Instruction[11:7];
    assign funct3 = Instruction[14:12];
    
    assign funct7 = ({funct3,Instruction[6:2]} == 8'b000_00100) ? 1'b0: Instruction[30];
    
    assign ALU_A = ALU_src1 ? PC : Read_Data1;
    assign ALU_B = ALU_src2 ? Immediate : Read_Data2;
    
    assign PC_en = ({Instruction[20],Instruction[6:0]} == 8'b1_1110011) ? 1'b0: 1'b1;

    always@(*) begin
        case(reg_Write_Sel)
            2'b00: write_Data_Reg = ALU_out;
            2'b01: write_Data_Reg = Mem_out;
            2'b10: write_Data_Reg = PC + 4;
            2'b11: write_Data_Reg = Immediate;
        endcase
    end

    InstMem IM(.addr(PC), .data_out(Instruction));
    Control_Unit CU(.opcode(Instruction[6:2]), .branch(Branch), .Jump(Jump), .Mem_Read(Mem_Read), .reg_Write_Sel(reg_Write_Sel), . Mem_Write(Mem_Write), .ALU_Src1(ALU_Src1), .ALU_Src2(ALU_Src2), .Reg_Write(Reg_Write), .ALU_Op(ALU_Op));
    Reg_File RF(.RS1(RS1), .RS2(RS2), .RD(RD), .Reg_Write(Reg_Write), .clk(clk), .rst(rst), .write_Data(write_Data_Reg), .read_Data1(Read_Data1), .read_Data2(Read_Data2));
    Imm_Gen IG(.inst(Instruction), .gen_out(Immediate));
    ALU_Control_Unit ALUCU(.funct3(funct3), .funct7(funct7), .ALU_Op(ALU_Op), .ALUSel(ALUsel));
    ALU alu (.A(ALU_A), .B (ALU_B),.S(ALU_sel),.Z_flag(Z_flag), .C_flag(C_flag), .S_flag(S_flag), .V_flag(V_flag), .ALU_out(ALU_out));
    Branch_Control_Unit BCU (.funct3(funct3), .Z_flag(Z_flag), .S_flag(S_flag), .V_flag(V_flag), .C_flag(C_flag), .Branch(Branch), .Branch_And(Branch_And));
    Data_Mem DM(.clk(clk), .Mem_Read(Mem_Read), .funct3(funct3), .Mem_Write(Mem_Write), .addr(ALU_out[7:0]), .data_in(ReadData2), .data_out(Mem_out));
    
    
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
//            2'b10: Inst_exec = { Zflag, Branch, Mem_Read, MemtoReg, ALU_Op, Mem_Write, ALUsrc, Reg_Write, BranchAnd, ALUsel};
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
//            4'b0110: Num = write_Data[12:0];
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
