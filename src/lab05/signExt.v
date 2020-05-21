`timescale 1ns / 1ps

module signExt(
    input [15:0] inst,
	input ext,
    output reg [31:0] data
    );
	
	always @ (inst or ext)
	begin
		if(ext == 1&&inst[15] == 1) data = {16'hffff,inst};
		else data = {16'h0000,inst};
	end
	
endmodule
