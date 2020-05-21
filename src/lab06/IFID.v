`timescale 1ns / 1ps

module IFID(
	input Clk,
	input nop,
	input stall,
	input [31:0] IF_inst,
	output reg [31:0] ID_inst,
	input [31:0] IF_pcplusfour,
	output reg [31:0] ID_pcplusfour
    );
	
	always @ (posedge Clk)
	begin
		if(stall == 0)
		begin
			ID_inst <= IF_inst;
			ID_pcplusfour <= IF_pcplusfour;
		end
	end
	
	always @ (posedge nop)
	begin
		ID_inst <= 32'h00000000;
		//????这里需要对pc做改动吗
	end
	
	initial begin
		ID_inst = 32'h00000000;
		ID_pcplusfour = 32'h00000000;
	end
endmodule
