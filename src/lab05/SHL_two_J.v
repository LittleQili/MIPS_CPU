`timescale 1ns / 1ps

module SHL_two_J(
    input [25:0] Instruction,
    input [3:0] pc_4next,
    output reg [31:0] pc_J
    );
    always @ (Instruction or pc_4next)
    begin
        pc_J[27:0] = Instruction << 2;
        pc_J[31:28] = pc_4next;
    end
endmodule
