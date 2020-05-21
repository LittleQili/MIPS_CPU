`timescale 1ns / 1ps

module InstMemory(
	input [31:0] readAddr,
	output reg [31:0] Instruction
    );
	
	reg [7:0] InstFile [1024:0];
	
	always @ (readAddr)
	begin
		Instruction = {InstFile[readAddr+3],InstFile[readAddr+2],InstFile[readAddr+1],InstFile[readAddr]};
	end
	
	initial
	begin
		$readmemh("Data",InstFile);
	end
endmodule
