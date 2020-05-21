`timescale 1ns / 1ps
//IF
//
module MUXposEdge(
	input [31:0] input0,
	input [31:0] input1,
	input flag,
	output reg [31:0] MUX_res
    );
	
	always @ (posedge flag)
	begin
		MUX_res <= input1;
	end
	
	always @ (input0)
	begin
		MUX_res = input0;
	end
	
endmodule
