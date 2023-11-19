module decompressor (
    input [15:0] compressedInstruction,
    output reg [31:0] decompressedInstruction
    );

    wire [6:0] func7_R1 = 7'b0;
    wire [6:0] func7_R2 = 7'b0100000;
    reg [4:0] adjustedRs1;
    reg [4:0] adjustedRs2;

    always @(*) begin
        case (compressedInstruction[9:7])
            3'b000: adjustedRs1 = 5'b01000;
            3'b001: adjustedRs1 = 5'b01001;
            3'b010: adjustedRs1 = 5'b01010;
            3'b011: adjustedRs1 = 5'b01011;
            3'b100: adjustedRs1 = 5'b01100;
            3'b101: adjustedRs1 = 5'b01101;
            3'b110: adjustedRs1 = 5'b01110;
            3'b111: adjustedRs1 = 5'b01111;
        endcase
    end

    always @(*) begin
        case (compressedInstruction[4:2])
            3'b000: adjustedRs2 = 5'b01000;
            3'b001: adjustedRs2 = 5'b01001;
            3'b010: adjustedRs2 = 5'b01010;
            3'b011: adjustedRs2 = 5'b01011;
            3'b100: adjustedRs2 = 5'b01100;
            3'b101: adjustedRs2 = 5'b01101;
            3'b110: adjustedRs2 = 5'b01110;
            3'b111: adjustedRs2 = 5'b01111;
        endcase
    end

    always @(*) begin
        case(compressedInstruction[1:0])
            2'b0: begin
                case (compressedInstruction[15:13]) 
                    // c.sw
                    3'b110 : decompressedInstruction = {5'b0, compressedInstruction[5], compressedInstruction[12],adjustedRs2, adjustedRs1, 3'b10, compressedInstruction[11:10], compressedInstruction[6], 2'b0, 7'b0100011};
                    // c.lw
                    3'b010 : decompressedInstruction = {5'b0, compressedInstruction[5],compressedInstruction[12:10], compressedInstruction[6], 2'b0, adjustedRs1, 3'b010, adjustedRs2, 7'b0000011};
                    // c.addi4spn
                    3'b000: decompressedInstruction = {2'b0, compressedInstruction[10:7], compressedInstruction[12:11], compressedInstruction[5], 10'b10000, adjustedRs2, 7'b0010011};

                endcase
              
            end
            2'b1: begin
                case(compressedInstruction[15:13])
                // c.nop or c.addi
                3'b0: decompressedInstruction = (compressedInstruction[11:7]== 5'b0) ? 32'b10011:{ {7{compressedInstruction[12]}}, compressedInstruction[6:2], compressedInstruction[11:7], 3'b0, compressedInstruction[11:7], 7'b0010011};
                // c.jal
                3'b1: decompressedInstruction = { {2{compressedInstruction[8]} }, compressedInstruction[10:9],compressedInstruction[7], compressedInstruction[2],compressedInstruction[11],compressedInstruction[5:3], compressedInstruction[12], {8{compressedInstruction[8]}}, 5'b1 , 7'b1101111};
                // c.j
                3'b101: decompressedInstruction = { {2{compressedInstruction[8]} }, compressedInstruction[10:9],compressedInstruction[7], compressedInstruction[2],compressedInstruction[11],compressedInstruction[5:3], compressedInstruction[12], {8{compressedInstruction[8]}}, 5'b0 , 7'b1101111};
                // c.beqz
                3'b110: decompressedInstruction = { {4{compressedInstruction[12]}}, compressedInstruction[6:5], compressedInstruction[2], 5'b0, adjustedRs1, 3'b0, compressedInstruction[11:10],compressedInstruction[4:3], compressedInstruction[12], 7'b1100011};
                // c.bnez
                3'b111: decompressedInstruction = { {4{compressedInstruction[12]}}, compressedInstruction[6:5], compressedInstruction[2], 5'b1, adjustedRs1, 3'b1, compressedInstruction[11:10],compressedInstruction[4:3], compressedInstruction[12], 7'b1100011};
                3'b100: case(compressedInstruction[11:10]) 
                //c.srli 
                    2'b0: decompressedInstruction = { 5'b01000, compressedInstruction[12],compressedInstruction[6:2], adjustedRs1, 3'b101, adjustedRs1, 7'b0010011};
                // c.srai 
                    2'b01: decompressedInstruction = { 5'b01000, compressedInstruction[12],compressedInstruction[6:2], adjustedRs1, 3'b101, adjustedRs1, 7'b0010011};
                    // c.andi
                    2'b10: decompressedInstruction = { 5'b0,compressedInstruction[12],compressedInstruction[6:2], adjustedRs1, 3'b111, adjustedRs1, 7'b0010011};
                    2'b11: case(compressedInstruction[6:5])
                        //c.sub
                        2'b00: decompressedInstruction = { func7_R2, adjustedRs2, adjustedRs1, 3'b0, adjustedRs1, 7'b0110011};
                        // c.xor
                        2'b01: decompressedInstruction = { func7_R1, adjustedRs2, adjustedRs1, 3'b100, adjustedRs1, 7'b0110011};
                        // c.or
                        2'b10: decompressedInstruction = { func7_R1, adjustedRs2, adjustedRs1, 3'b110, adjustedRs1, 7'b0110011};
                        // c.and
                        2'b11: decompressedInstruction = { func7_R1, adjustedRs2, adjustedRs1, 3'b111, adjustedRs1, 7'b0110011};
                        endcase
                    endcase 
                //c.li
                3'b010: decompressedInstruction = { {7{compressedInstruction[12]}}, compressedInstruction[6:2], 8'b0, compressedInstruction[11:7], 7'b0010011};
               // c.lui or c.addi16sp
                3'b011: decompressedInstruction = (compressedInstruction[11:7] != 5'b0 && compressedInstruction[11:7] != 5'b10) ? { {15{compressedInstruction[12]}}, compressedInstruction[6:2] ,compressedInstruction[11:7], 7'b0110111} : ( (compressedInstruction[11:7] == 5'b10) ?  { {3{compressedInstruction[12]}}, compressedInstruction[4:2], compressedInstruction[5], compressedInstruction[2], compressedInstruction[6],12'b10000, compressedInstruction[11:7] , 7'b0010011} : 32'b0);
                endcase
            end

            2'b10: begin
                case(compressedInstruction[15:12])
                    // c.add or c.jalr
                    4'b1001: decompressedInstruction = (compressedInstruction[6:2] != 5'b0 && compressedInstruction[11:7]!=5'b0) ? { func7_R1, compressedInstruction[13:9],compressedInstruction[11:7],3'b0,compressedInstruction[11:7], 7'b0110011} : ( (compressedInstruction[6:2] == 5'b0 && compressedInstruction[11:7] != 5'b0) ?  { 12'b0, compressedInstruction[11:7],15'b11100111} : 32'b0);
                    // c.jr or c.mv
                    4'b1000: decompressedInstruction = (compressedInstruction[6:2] == 5'b0 && compressedInstruction[11:7]!=5'b0) ? {12'b0, compressedInstruction[11:7], 15'b1100111} : {7'b0,compressedInstruction[10:6],8'b0,compressedInstruction[11:7], 7'b0110011};
                endcase
                case (compressedInstruction[15:13])
                    3'b000: decompressedInstruction = (compressedInstruction[6:2] !=5'b0) ? { 5'b0,compressedInstruction[12], compressedInstruction[6:2],compressedInstruction[11:7],3'b1,compressedInstruction[11:7],7'b0010011}: 32'b0;
                    3'b001: decompressedInstruction = (compressedInstruction[11:7]!= 5'b0) ? { 4'b0, compressedInstruction[3:2], compressedInstruction[12],compressedInstruction[6:4],10'b10010,compressedInstruction[11:7], 7'b11 }: 32'b0;
                    3'b110: decompressedInstruction = {4'b0, compressedInstruction[8:7],compressedInstruction[12], compressedInstruction[6:2], 8'b10010, compressedInstruction[11:9], 9'b100011};          
                endcase
            end
            default: 
                decompressedInstruction = 32'b0;
        endcase
    end

endmodule

    
