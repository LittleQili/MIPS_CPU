`timescale 1ns / 1ps

module IDEX(
	input Clk,
	input nop,
	input stall,
	
	input [4:0] ID_regReadA,
	output reg [4:0] EX_regReadA,
	input [4:0] ID_regReadB,
	output reg [4:0] EX_regReadB,
	input [4:0] ID_writeReg,
	output reg [4:0] EX_writeReg,
	
	input [31:0] ID_pcplusfour,
	output reg [31:0] EX_pcplusfour,
	
	input [31:0] ID_regDataA,
	output reg [31:0] EX_regDataA,
	input [31:0] ID_regDataB,
	output reg [31:0] EX_regDataB,
	input [31:0] ID_imm,
	output reg [31:0] EX_imm,
	
	input [31:0] ID_branchDst,
	output reg [31:0] EX_branchDst,
	
	input ID_aluSrcA,
	input ID_aluSrcB,
	input [3:0] ID_aluCtr,
	input ID_memToReg,
	input ID_regWrite,
	input ID_memRead,
	input ID_memWrite,
	input ID_branch,
	input ID_bequal,
	input ID_retu,
	
	output reg EX_aluSrcA,
	output reg EX_aluSrcB,
	output reg [3:0] EX_aluCtr,
	output reg EX_memToReg,
	output reg EX_regWrite,
	output reg EX_memRead,
	output reg EX_memWrite,
	output reg EX_branch,
	output reg EX_bequal,
	output reg EX_retu
    );
	
	always @ (posedge Clk)
	begin
		if(stall == 0)
		begin
			EX_regReadA <= ID_regReadA;
			  EX_regReadB <= ID_regReadB;
			  EX_writeReg <= ID_writeReg;
			  EX_pcplusfour <= ID_pcplusfour;
			  EX_regDataA <= ID_regDataA;
			  EX_regDataB <= ID_regDataB;
			  EX_imm <= ID_imm;
			  EX_branchDst <= ID_branchDst;
			
			  EX_aluSrcA <= ID_aluSrcA;
			  EX_aluSrcB <= ID_aluSrcB;
			  EX_aluCtr <= ID_aluCtr;
			  EX_memToReg <= ID_memToReg;
			  EX_regWrite <= ID_regWrite;
			  EX_memRead <= ID_memRead;
			  EX_memWrite <= ID_memWrite;
			  EX_branch <= ID_branch;
			  EX_bequal <= ID_bequal;
			  EX_retu <= ID_retu;
		end
	end
	
	always @ (posedge nop)
	begin
		EX_aluSrcA <= 0;
		EX_aluSrcB <= 0;
		EX_aluCtr <= 0;
		EX_memToReg <= 0;
		EX_regWrite <= 0;
		EX_memRead <= 0;
		EX_memWrite <= 0;
		EX_branch <= 0;
		EX_bequal <= 0;
		EX_retu <= 0;
	end
	
	initial begin
		EX_aluSrcA = 0;
		EX_aluSrcB = 0;
		EX_aluCtr = 0;
		EX_memToReg = 0;
		EX_regWrite = 0;
		EX_memRead = 0;
		EX_memWrite = 0;
		EX_branch = 0;
		EX_bequal = 0;
		EX_retu = 0;
		
		EX_regReadA = 0;
		EX_regReadB = 0;
	    EX_writeReg = 0;
		EX_pcplusfour = 0;
		EX_regDataA = 0;
		EX_regDataB = 0;
		EX_imm = 0;
		EX_branchDst = 0;
	end
endmodule
