`timescale 1ns / 1ps

module SHR_six(
    input [31:0] imm,
    output reg [31:0] shamt
    );
    always @ (imm)
    begin
        shamt = (imm >> 6)&32'h0000001f;
    end
endmodule
