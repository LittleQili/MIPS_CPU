`timescale 1ns / 1ps

module MUXfivebits(
	input [4:0] input0,
	input [4:0] input1,
	input flag,
	output reg [4:0] MUX_res
    );
	
	always @ (input0 or input1 or flag)
	begin
		if(flag == 0) MUX_res = input0;
		else MUX_res = input1;
	end
endmodule
