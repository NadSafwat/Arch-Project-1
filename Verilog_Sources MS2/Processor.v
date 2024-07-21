`timescale 1ns / 1ps
/*******************************************************************
* Module: processor.v
* Project: Arch-Project-1
* Authors: Nadine Safwat nadine.hkm@aucegypt.edu
           Nour Kasaby N.Kasaby@aucegypt.edu
* Description: Will create all the need wires and will call the 
               modules and pass in the required signals/ wires 
* Change history: 17/10/23 – Created module in lab
                  03/11/23 -  edited module to include all instructions
**********************************************************************/


module Processor(
    input clk,
    input rst
    // input ssd_Clk,
    // input [1:0] led_Sel,
    // input [3:0] ssd_Sel,
    // output reg [15:0] Inst_exec,
    // output [6:0] LED_out,
    // output [3:0] Anode
    );
    
    reg [7:0] PC;
    wire [31:0] Instruction;
    
    wire Z_Flag;
    wire S_Flag;
    wire V_Flag;
    wire C_Flag;

    wire Branch;
    wire Jump;
    wire Mem_Read;
    wire [1:0] Reg_Write_Sel;
    wire Mem_Write;
    wire ALU_Src_1;
    wire ALU_Src_2;
    wire Reg_Write;
    wire [1:0] ALU_op;
    wire Branch_And;
    wire PC_en;
    wire [3:0] ALU_sel;
    
    wire [6:0] Opcode;
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
    reg [31:0] Write_Data_Reg;

    wire[2:0] Funct_3;
    wire Funct_7;
    
    assign Opcode = Instruction[6:0];
    assign RS1 = Instruction[19:15];
    assign RS2 = Instruction[24:20];
    assign RD = Instruction[11:7];
    
    assign Funct_3 = Instruction[14:12];
    assign Funct_7 = ({Funct_3,Instruction[6:2]} == 8'b000_00100) ? 1'b0: Instruction[30];
    
    assign ALU_A = ALU_Src_1 ? PC : Read_Data1;
    assign ALU_B = ALU_Src_2 ? Immediate : Read_Data2;
    
    assign PC_en = ({Instruction[20],Opcode} == 8'b1_1110011) ? 1'b0: 1'b1;

    always@(*) begin
        case(Reg_Write_Sel)
            2'b00: Write_Data_Reg = ALU_out;
            2'b01: Write_Data_Reg = Mem_out;
            2'b10: Write_Data_Reg = PC + 4;
            2'b11: Write_Data_Reg = Immediate;
        endcase
    end

    Inst_Mem IM(.Addr(PC), .Data_Out(Instruction));
    
    Control_Unit CU(.Opcode(Opcode[6:2]), .Branch(Branch), .Jump(Jump), .Mem_Read(Mem_Read), .Reg_Write_Sel(Reg_Write_Sel), .Mem_Write(Mem_Write), .ALU_Src_1(ALU_Src_1), .ALU_Src_2(ALU_Src_2), .Reg_Write(Reg_Write), .ALU_Op(ALU_Op));
    
    Reg_File RF(.clk(clk), .rst(rst), .Reg_Write(Reg_Write), .RS1(RS1), .RS2(RS2), .RD(RD), .Write_Data(Write_Data_Reg), .Read_Data1(Read_Data1), .Read_Data2(Read_Data2));
    
    Imm_Gen IG(.Opcode(Opcode), .Funct7_3({Funct_7, Funct_3}), .Gen_Out(Gen_Out));
    
    ALU_Control_Unit ALUCU(.Funct_7(Funct_7), .Funct_3(Funct_3), .ALU_Op(ALU_Op), .ALU_Sel(ALU_Sel));
    
    ALU ALU (.A(ALU_A), .B(ALU_B), .ALU_Sel(ALU_Sel), .Z_Flag(Z_Flag), .C_Flag(C_Flag), .S_Flag(S_Flag), .V_Flag(V_Flag), .ALU_out(ALU_out));
    
    Branch_Control_Unit BCU (.Funct_3(Funct_3), .Z_Flag(Z_Flag), .S_Flag(S_Flag), .V_Flag(V_Flag), .C_Flag(C_Flag), .Branch(Branch), .Branch_And(Branch_And));
    
    Data_Mem DM(.clk(clk), .Mem_Read(Mem_Read), .Funct_3(Funct_3), .Mem_Write(Mem_Write), .Addr(ALU_out[7:0]), .Data_In(ReadData2), .Data_Out(Mem_out));
    
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
    
/* wire [7:0] PC4;
   wire [7:0] PC_Branch;
   wire [7:0] PC_in;

   assign PCin = PC;
   assign PC4 = PC + 4;
   assign PCBranch = (PC + Immediate)%256;

   always @ (*) begin
       case(ledSel) 
           2'b00: Inst_exec = Instruction[15:0];
           2'b01: Inst_exec = Instruction[31:16];
           2'b10: Inst_exec = { Zflag, Branch, Mem_Read, MemtoReg, ALU_Op, Mem_Write, ALUsrc, Reg_Write, BranchAnd, ALU_Sel};
   endcase
   end 

   reg [12:0] Num;
    
   always @ (*) begin
       case(ssdSel)
           4'b0000: Num = PC;
           4'b0001: Num = PC4;
           4'b0010: Num = PCBranch;
           4'b0011: Num = PCin;
           4'b0100: Num = ReadData1[12:0];
           4'b0101: Num = ReadData2[12:0];
           4'b0110: Num = write_Data[12:0];
           4'b0111: Num = Immediate[12:0];
           4'b1000: Num = Immediate[12:0];
           4'b1001: Num = ALU_B[12:0];
           4'b1010: Num = ALU_out[12:0];
           4'b1011: Num = Mem_out[12:0];
           default: Num = 13'b0;
           endcase
    end 
    Seven_seg ss (.clk(ssdClk), .num(Num), .Anode(Anode), .LED_out(LED_out)); */

endmodule
