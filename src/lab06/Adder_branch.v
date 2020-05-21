`timescale 1ns / 1ps

module Adder_branch(
	input [31:0] pc_4next,
	input [31:0] imm,
	output reg [31:0] branch_dst
    );
	
	always @ (pc_4next or imm)
	begin
		branch_dst = pc_4next + (imm << 2);
	end
endmodule
