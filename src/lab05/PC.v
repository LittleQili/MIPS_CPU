`timescale 1ns / 1ps

module PC(
	input [31:0] pc_write,
	input Clk,
	input reset,
	output reg [31:0] pc
    );
	
	always @ (posedge Clk)
	begin
		if(reset == 0) pc <= pc_write;
	end
	
	always @ (reset)
	begin
		if(reset == 1) pc = 0;
	end
	
	initial begin
	pc = 1;
	end
endmodule
