`timescale 1ns / 1ps

module ALU(
       input [31:0] input1,
       input [31:0] input2,
       input [3:0] ALUCtr,
       output reg zero,
       output reg [31:0] ALURes
    );
	
	always @ (input1 or input2 or ALUCtr)
	begin
		case (ALUCtr)
		4'b0001://add
			ALURes = input1 + input2;
		4'b0010://sub
			ALURes = input1 - input2;
		4'b0100://and
			ALURes = input1 & input2;
		4'b0101://or
			ALURes = input1 | input2;
		4'b0110://xor
			ALURes = input1 ^ input2;
		4'b0111://nor
		begin
			ALURes = input1 | input2;
			ALURes = ~ALURes;
		end
		4'b1000://sll
			ALURes = input2 << input1;
		4'b1010://srl
			ALURes = input2 >> input1;
		4'b1011://sra
		begin
			if(input2[31] == 0) ALURes = input2 >> input1;
			else 
			begin
				ALURes = 32'hffffffff;
				ALURes = ~(ALURes >> input1);
				ALURes = ALURes | (input2 >> input1);
			end
		end
		4'b1100://slt
		begin
			if (input1[31] == 0)
			begin
				if (input2[31] == 0)
				begin
					if(input1 < input2) ALURes = 1;
					else ALURes = 0;
				end
				else ALURes = 0;
			end
			else
			begin
				if (input2[31] == 0) ALURes = 1;
				else
				begin
					if(input1 < input2) ALURes = 1;
					else ALURes = 0;
				end
			end
		end
		4'b1101://sltu
		begin
			if (input1 < input2) ALURes = 1;
			else ALURes = 0;
		end
		4'b1001://lui
			ALURes = input2 << 16;
		4'b1110://jr
			ALURes = input1;
		endcase
		if(ALURes == 0) zero = 1;
		else zero = 0;
	end
endmodule
