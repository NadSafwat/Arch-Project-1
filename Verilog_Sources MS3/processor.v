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


module processor(
    input clk,
    input rst
    );
    
    reg [7:0] PC_IF;
    wire [7:0] PC_ID;
    wire [7:0] PC_EX;
    wire [7:0] PC_MEM;
    wire [7:0] PC_WB;
    reg [31:0] Instruction_IF;
    wire [31:0] Instruction_ID;
    
    wire Zflag_EX;
    wire Sflag_EX;
    wire Vflag_EX;
    wire Cflag_EX;
    wire Zflag_MEM;
    wire Sflag_MEM;
    wire Vflag_MEM;
    wire Cflag_MEM;
    
    wire RegWrite_ID;
    wire [1:0] regWriteSel_ID;
    wire RegWrite_EX;
    wire [1:0] regWriteSel_EX;
    wire RegWrite_MEM;
    wire [1:0] regWriteSel_MEM;
    wire RegWrite_WB;
    wire [1:0] regWriteSel_WB;
    
    wire Jump_ID;
    wire Branch_ID;
    wire MemRead_ID;
    wire MemWrite_ID;
    wire Jump_EX;
    wire Branch_EX;
    wire MemRead_EX;
    wire MemWrite_EX;
    wire Jump_MEM;
    wire Branch_MEM;
    wire MemRead_MEM;
    wire MemWrite_MEM;
    
    wire [1:0] ALUop_ID;
    wire ALUsrc1_ID;
    wire ALUsrc2_ID;
    wire [1:0] ALUop_EX;
    wire ALUsrc1_EX;
    wire ALUsrc2_EX;
    
    wire BranchAnd;
    wire PCen;
    wire [3:0] ALUsel;
    
    wire [4:0] RS1_ID;
    wire [4:0] RS2_ID;
    wire [4:0] RD_ID;
    wire [4:0] RS1_EX;
    wire [4:0] RS2_EX;
    wire [4:0] RD_EX;
    wire [4:0] RD_MEM;
    wire [4:0] RD_WB;
    
    wire [31:0] ReadData1_ID;
    wire [31:0] ReadData2_ID;
    wire [31:0] ReadData1_EX;
    wire [31:0] ReadData2_EX;
    wire [31:0] ReadData2_MEM;
    
    wire [31:0] Immediate_ID;
    wire [31:0] Immediate_EX;
    wire [31:0] Immediate_MEM;
    wire [31:0] Immediate_WB;
    reg [31:0] ALU_A;
    reg [31:0] ALU_B_EX;
    wire[31:0] ALU_B_MEM;
    wire [31:0] ALU_B_In;
    wire [31:0] ALU_out_EX;
    wire [31:0] ALU_out_MEM;
    wire [31:0] ALU_out_WB;
    reg [31:0] Mem_out_MEM;
    wire [31:0] Mem_out_WB;
    reg [31:0] writeDataReg;

    wire[2:0] funct3_ID;
    wire funct7_ID;
    wire[2:0] funct3_EX;
    wire funct7_EX;
    wire[2:0] funct3_MEM;
    
    wire [6:0] target_address_EX;
    wire [6:0] target_address_MEM;

    reg ReadMem;
    reg [2:0] bitsRead;
    reg WriteMem;
    reg [7:0] addr;
    wire [31:0] data_out_mem;
    
    wire Stall;
    wire [10:0] Stall_Needed;
    
    wire [1:0] Forward_A;
    wire [1:0] Forward_B;
    
    wire [31:0] NOP; 
    wire [31:0] flush_Needed_Inst;
    wire [6:0] flush_Needed_EX;
    
    wire Using_Mem;
    wire compressed; 
    
    wire [31:0] decompressedInstruction;
    
    assign Using_Mem = (MemWrite_MEM || MemRead_MEM);
    assign compressed = ~(Instruction_IF[1:0] == 2'b11);
   
    
    assign NOP = 32'b00000000000000000000000000110011 ; //add x0, x0, x0 
    
    assign Stall_Needed = (Jump_MEM || BranchAnd || Stall) ? 11'b0 : {Jump_ID,Branch_ID, MemRead_ID,regWriteSel_ID,MemWrite_ID,ALUsrc1_ID,ALUsrc2_ID, RegWrite_ID, ALUop_ID};
    assign flush_Needed_EX = (Jump_MEM || BranchAnd) ? 7'b0 : {Jump_EX, Branch_EX, MemRead_EX, regWriteSel_EX, MemWrite_EX, RegWrite_EX};
    assign flush_Needed_Inst = (Using_Mem || Jump_MEM || BranchAnd) ? NOP : Instruction_IF;

    assign target_address_EX = (PC_EX + Immediate_EX)%256;
    assign RS1_ID = Instruction_ID[19:15];
    assign RS2_ID = Instruction_ID[24:20];
    assign RD_ID = Instruction_ID[11:7];
    
    assign funct3_ID = Instruction_ID[14:12];
    assign funct7_ID = ({funct3_ID,Instruction_ID[6:2]} == 8'b00000100) ? 1'b0: Instruction_ID[30];

    assign PCen = (Using_Mem || Stall || ({Instruction_IF[20],Instruction_IF[6:0]} == 8'b11110011)) ? 1'b0: 1'b1;

    always@(*) begin
        case(regWriteSel_WB)
            2'b00: writeDataReg = ALU_out_WB;
            2'b01: writeDataReg = Mem_out_WB;
            2'b10: writeDataReg = PC_WB + 4;
            2'b11: writeDataReg = Immediate_WB;
        endcase
    end 
    
    always @(*) begin
    case(Forward_A)
         2'b00: ALU_A = ALUsrc1_EX ? PC_EX : ReadData1_EX; 
         2'b01: ALU_A = writeDataReg;
         2'b10: ALU_A = ALU_out_MEM;
         default: ALU_A = 32'b0;
    endcase
    end

    always @(*) begin
        case(Forward_B)
             2'b00: ALU_B_EX = ReadData2_EX; 
             2'b01: ALU_B_EX = writeDataReg;
             2'b10: ALU_B_EX = ALU_out_MEM;
             default: ALU_B_EX = 32'b0;
        endcase
    end 
    
    assign ALU_B_In = ALUsrc2_EX ? Immediate_EX : ALU_B_EX;
    
    always @(*) begin
        case(Using_Mem) 
            1'b0: begin 
                ReadMem = 1'b1;
                bitsRead = 3'b010;
                WriteMem = 1'b0;
                addr = PC_IF;
                Instruction_IF = data_out_mem;
            end
           1'b1:  begin 
                ReadMem = MemRead_MEM;
                bitsRead = funct3_MEM;
                WriteMem = MemWrite_MEM;
                addr = ALU_out_MEM[7:0]+84;
                Mem_out_MEM = data_out_mem;
            end 
           default: begin 
                ReadMem = 1'b0;
                bitsRead = 3'b000;
                WriteMem = 1'b0;
                addr = 8'b0;
                Mem_out_MEM = 32'b0;
                Instruction_IF = 32'b0;
            end           
        endcase
    end  
    
        always @(*) begin
             Instruction_IF = compressed ? decompressedInstruction : Instruction_IF;
          end
    
    Register_Posedge #(40) IF_ID (.clk(clk), .rst(rst), .Load(~Stall), .D({PC_IF, flush_Needed_Inst}), 
                                                                     .Q({PC_ID, Instruction_ID}));

    Register_Posedge #(134) ID_EX (.clk(clk), .rst(rst), .Load(1'b1), .D({Stall_Needed, PC_ID, ReadData1_ID, ReadData2_ID, Immediate_ID, funct7_ID, funct3_ID, RS1_ID,RS2_ID,RD_ID}), 
                                                                      .Q({Jump_EX,Branch_EX, MemRead_EX,regWriteSel_EX,MemWrite_EX,ALUsrc1_EX,ALUsrc2_EX, RegWrite_EX, ALUop_EX, PC_EX, ReadData1_EX, ReadData2_EX, Immediate_EX, funct7_EX, funct3_EX, RS1_EX,RS2_EX,RD_EX}));
    
    Register_Posedge #(162) EX_MEM (.clk(clk), .rst(rst), .Load(1'b1), .D({flush_Needed_EX, target_address_EX, Zflag_EX, Cflag_EX, Vflag_EX , Sflag_EX, ALU_out_EX, ReadData2_EX, RD_EX,PC_EX, Immediate_EX, funct3_EX, ALU_B_EX}), 
                                                                      .Q({Jump_MEM, Branch_MEM, MemRead_MEM, regWriteSel_MEM, MemWrite_MEM, RegWrite_MEM, target_address_MEM, Zflag_MEM, Cflag_MEM, Vflag_MEM , Sflag_MEM, ALU_out_MEM, ReadData2_MEM, RD_MEM,PC_MEM, Immediate_MEM, funct3_MEM, ALU_B_MEM}));

    Register_Posedge #(112) MEM_WB (.clk(clk), .rst(rst), .Load(1'b1), .D({RegWrite_MEM, regWriteSel_MEM, Mem_out_MEM, ALU_out_MEM, RD_MEM,PC_MEM, Immediate_MEM}), 
                                                                      .Q({RegWrite_WB, regWriteSel_WB, Mem_out_WB, ALU_out_WB, RD_WB,PC_WB, Immediate_WB}));
    
//    InstMem IM(.addr(PC_IF), .data_out(Instruction_IF));
    decompressor d (.compressedInstruction(Instruction_IF[15:0]), .decompressedInstruction(decompressedInstruction) );
    Stalling_Unit SU(.RS1_ID(RS1_ID),.RS2_ID(RS2_ID), .RD_EX(RD_EX), .MemRead_EX(MemRead_EX), .Stall(Stall));    
    Control_Unit CU(.opcode(Instruction_ID[6:2]), .branch(Branch_ID), .Jump(Jump_ID), .MemRead(MemRead_ID), .regWriteSel(regWriteSel_ID), . MemWrite(MemWrite_ID), .ALUSrc1(ALUsrc1_ID), .ALUSrc2(ALUsrc2_ID), .RegWrite(RegWrite_ID), .ALUOp(ALUop_ID));
    RegFile RF(.clk(clk), .rst(rst), .RS1(RS1_ID), .RS2(RS2_ID), .RD(RD_WB), .regWrite(RegWrite_WB), .writeData(writeDataReg), .readData1(ReadData1_ID), .readData2(ReadData2_ID));
    ImmGen IG(.inst(Instruction_ID), .gen_out(Immediate_ID));
    ALU_Control_Unit ALUCU(.funct3(funct3_EX), .funct7(funct7_EX), .ALUop(ALUop_EX), .ALUSel(ALUsel));
    Forwarding_Unit FU(.RS1_EX(RS1_EX), .RS2_EX(RS2_EX), .RD_MEM(RD_MEM), .RD_WB(RD_WB), .RegWrite_MEM(RegWrite_MEM), .RegWrite_WB(RegWrite_WB), .Forward_A(Forward_A), .Forward_B(Forward_B));
    ALU alu (.A(ALU_A), .B (ALU_B_In),.S(ALUsel),.Zflag(Zflag_EX), .Cflag(Cflag_EX), .Sflag(Sflag_EX), .Vflag(Vflag_EX), .ALU_out(ALU_out_EX));
    Branch_Control_Unit BCU (.funct3(funct3_MEM), .Zflag(Zflag_MEM), .Sflag(Sflag_MEM), .Vflag(Vflag_MEM), .Cflag(Cflag_MEM), .Branch(Branch_MEM), .BranchAnd(BranchAnd));
//    Memory Mem(.clk(clk), .MemRead(MemRead_MEM), .funct3(funct3_MEM), .MemWrite(MemWrite_MEM), .addr(ALU_out_MEM[7:0]), .data_in(ALU_B_MEM), .data_out(Mem_out_MEM));
    Memory Mem(.clk(clk), .MemRead(ReadMem), .funct3(bitsRead), .MemWrite(WriteMem), .addr(addr), .data_in(ALU_B_MEM), .data_out(data_out_mem));
    
    always @ (posedge clk or posedge rst) begin
        if(rst == 1)
            PC_IF <= 0;
        else begin
            if(BranchAnd) 
                PC_IF <= target_address_MEM;
            else if(Jump_MEM)
                PC_IF <= ALU_out_MEM;
            else if (PCen == 0)
                PC_IF <= PC_IF;
            else 
                if(compressed)
                    PC_IF <= PC_IF + 2;
                else
                    PC_IF <= PC_IF + 4;
       end   
    end

endmodule
