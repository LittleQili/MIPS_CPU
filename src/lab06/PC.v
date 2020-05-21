`timescale 1ns / 1ps
//IF

module PC(
	input [31:0] pc_write,
	input Clk,
	input reset,
	input stall,
	output reg [31:0] pc
    );
	
	always @ (negedge Clk)
	begin
		if(reset == 0&&stall == 0) pc <= pc_write;
	end
	
	always @ (reset)
	begin
		if(reset == 1) pc = 0;
	end
	
	initial begin
	pc = 0;
	end
endmodule
