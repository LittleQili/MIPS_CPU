`timescale 1ns / 1ps

module EXMA(
	input Clk,
	input stall,
	
	input [31:0] EX_ALURes,
	output reg [31:0] MA_ALURes,
	input [31:0] EX_regDataB,
	output reg [31:0] MA_regDataB,
	
	input [4:0] EX_writeReg,
	output reg [4:0] MA_writeReg,
	
	input [31:0] EX_pcplusfour,
	output reg [31:0] MA_pcplusfour,
	
	input EX_memToReg,
	input EX_regWrite,
	input EX_memRead,
	input EX_memWrite,
	output reg MA_memToReg,
	output reg MA_regWrite,
	output reg MA_memRead,
	output reg MA_memWrite
    );
	
	always @ (posedge Clk)
	begin
		if(stall == 0)
		begin
			MA_ALURes <= EX_ALURes;
			MA_regDataB <= EX_regDataB;
			MA_writeReg <= EX_writeReg;
			MA_pcplusfour <= EX_pcplusfour;
			
			MA_memToReg <= EX_memToReg;
			MA_regWrite <= EX_regWrite;
			MA_memRead <= EX_memRead;
			MA_memWrite <= EX_memWrite;
		end
	end
	
	initial begin
		MA_ALURes = 0;
		MA_regDataB = 0;
		MA_writeReg = 0;
		MA_pcplusfour = 0;
		
		MA_memToReg = 0;
		MA_regWrite = 0;
		MA_memRead = 0;
		MA_memWrite = 0;
	end
endmodule
