`timescale 1ns / 1ps

module BranchJrjudge(
	input Clk,
	input stall,
    input zero,
	input branch,
	input bequal,
	input retu,
	
	input [31:0] branchRes,
	input [31:0] ALURes,
	
    output reg nop,
	output reg [31:0] targetAddr
    );
	
	wire bj_Clk;
	
	assign # 25 bj_Clk = Clk;
	
	always @ (posedge bj_Clk)
	begin
		if(stall == 0)
		begin
			if(retu == 1)
			begin
				nop <= 1;
				targetAddr <= ALURes;
			end
			else if (branch == 1)
				begin
					if((bequal == 1&& zero == 1)||(bequal == 0 && zero == 0))
					begin
						nop <= 1;
						targetAddr <= branchRes;
					end
					else
					begin
						nop <= 0;
						targetAddr <= 0;
					end 
				end
				else
				begin
					nop <= 0;
					targetAddr <= 0;
				end
		end
	end
	
	initial begin
		nop = 0;
		targetAddr = 0;
	end
endmodule
