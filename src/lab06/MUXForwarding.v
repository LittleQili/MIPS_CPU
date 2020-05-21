`timescale 1ns / 1ps

module MUXForwarding(
	input [31:0] input_EX,
	input [31:0] input_MA,
	input [31:0] input_WB_mem,
	input [31:0] input_WB_reg,
	input [1:0] flag,
	output reg [31:0] MUX_res
    );
	
	always @ (input_EX or input_MA or input_WB_mem or input_WB_reg or flag)
	begin
		case (flag)
		2'b00: MUX_res = input_EX;
		2'b01: MUX_res = input_MA;
		2'b10: MUX_res = input_WB_mem;
		2'b11: MUX_res = input_WB_reg;
		endcase
	end
endmodule
