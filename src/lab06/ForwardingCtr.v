`timescale 1ns / 1ps

module ForwardingCtr(
	input [4:0] regRead,
	input [4:0] regWrite_EXMA,
	input [4:0] regWrite_MAWB,
	
	input [31:0] pc_EXMA,
	input [31:0] pc_MAWB,
	
	input flag_Alusrc,
	input flag_regWrite_EXMA,
	input flag_regWrite_MAWB,
	input flag_memToReg_EXMA,
	input flag_memToReg_MAWB,
	
	output reg [1:0] choice,
	output reg stall
    );
	
	always @ (flag_Alusrc or regRead or regWrite_EXMA or regWrite_MAWB 
			or flag_regWrite_MAWB or flag_regWrite_EXMA or flag_memToReg_EXMA or flag_memToReg_MAWB 
			or pc_EXMA or pc_MAWB)
	begin
		if(flag_Alusrc == 0)
		begin
			if (regWrite_EXMA == regRead && flag_regWrite_EXMA == 1 && flag_memToReg_EXMA == 0)
			begin 
				choice = 2'b01; 
				stall = 0;
			end
			else
			begin
				if (regWrite_EXMA == regRead && flag_regWrite_EXMA == 1 && flag_memToReg_EXMA == 1 && pc_EXMA != pc_MAWB) 
				begin
					choice = 2'b00;
					stall = 1;
				end
				else if (regWrite_MAWB == regRead && flag_regWrite_MAWB == 1)
					 begin
						if (flag_memToReg_MAWB == 1)
						begin
							choice = 2'b10;
							stall = 0;
						end
						else
						begin
							choice = 2'b11;
							stall = 0;
						end
					 end
					 else 
					 begin
						choice = 2'b00;
						stall = 0;
					 end
			end
		end
		else begin
		choice = 2'b00;
		stall = 0;
		end
	end
	
	initial begin
		choice = 0;
		stall = 0;
	end
endmodule
