`timescale 1ns / 1ps

module Branch_Control_Unit(
    input [2:0] funct3,
    input Zflag,
    input Sflag,
    input Vflag,
    input Cflag,
    input Branch,
    output reg BranchAnd
);

always @(*) begin
    case(funct3)
        3'b000: BranchAnd = Branch & Zflag;
        3'b001: BranchAnd = Branch & ~Zflag;
        3'b100: BranchAnd = Branch & (Sflag != Vflag);
        3'b101: BranchAnd = Branch & (Sflag == Vflag);
        3'b110: BranchAnd = Branch & ~Cflag;
        3'b111: BranchAnd = Branch & Cflag;
    endcase
end

endmodule