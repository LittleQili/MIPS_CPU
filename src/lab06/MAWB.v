`timescale 1ns / 1ps

module MAWB(
	input Clk,
	
	input [31:0] MA_ALURes,
	output reg [31:0] WB_ALURes,
	input [31:0] MA_memData,
	output reg [31:0] WB_memData,
	
	input [4:0] MA_writeReg,
	output reg [4:0] WB_writeReg,
	
	input [31:0] MA_pcplusfour,
	output reg [31:0] WB_pcplusfour,
	
	input MA_memToReg,
	input MA_regWrite,
	output reg WB_memToReg,
	output reg WB_regWrite
    );
	
	always @ (posedge Clk)
	begin
		WB_ALURes <= MA_ALURes;
		WB_memData <= MA_memData;
		WB_writeReg <= MA_writeReg;
		WB_pcplusfour <= MA_pcplusfour;
		
		WB_memToReg <= MA_memToReg;
		WB_regWrite <= MA_regWrite;
	end
	
	initial begin
		WB_ALURes = 0;
		WB_memData = 0;
		WB_writeReg = 0;
		WB_pcplusfour = 0;
		
		WB_memToReg = 0;
		WB_regWrite = 0;
	end
endmodule
