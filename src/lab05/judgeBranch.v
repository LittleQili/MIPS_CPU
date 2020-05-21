`timescale 1ns / 1ps

module judgeBranch(
    input zero,
	input branch,
	input bequal,
    output reg branchenable
    );
	
	always @ (zero or branch or bequal)
	begin
		if(branch == 1)
		begin
			if(zero == 1&&bequal == 1) branchenable = 1;
			else if (zero == 0&&bequal == 0) branchenable = 1;
			else branchenable = 0;
		end
		else branchenable = 0;
	end
	
endmodule
