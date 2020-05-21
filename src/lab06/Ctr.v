`timescale 1ns / 1ps

module Ctr(
    input [5:0] opCode,
	input [5:0] func,
	
    output reg aluSrcA,
	output reg aluSrcB,
	output reg [3:0] aluCtr,
	output reg ext,
	
	output reg regDst,
    output reg memToReg,
    output reg regWrite,
	
    output reg memRead,
    output reg memWrite,
	
    output reg branch,
	output reg bequal,
    output reg jump,
	output reg link,//jal
	output reg retu//jr
    );
    
    always @(opCode or func)
	begin
		case(opCode)
		//R type
		6'b000000:
		begin
			case(func)
			6'b100000://add
			begin
				aluSrcA = 0;aluSrcB = 0;aluCtr = 4'b0001;ext = 0;
				regDst = 1; memToReg = 0;regWrite = 1;
				memRead = 0;memWrite = 0;
				branch = 0;jump = 0;link = 0;retu = 0;bequal = 0;
			end
			6'b100001://addu
			begin
				aluSrcA = 0;aluSrcB = 0;aluCtr = 4'b0001;ext = 0;
				regDst = 1; memToReg = 0;regWrite = 1;
				memRead = 0;memWrite = 0;
				branch = 0;jump = 0;link = 0;retu = 0;bequal = 0;
			end
			6'b100010://sub
			begin
				aluSrcA = 0;aluSrcB = 0;aluCtr = 4'b0010;ext = 0;
				regDst = 1; memToReg = 0;regWrite = 1;
				memRead = 0;memWrite = 0;
				branch = 0;jump = 0;link = 0;retu = 0;bequal = 0;
			end
			6'b100011://subu
			begin
				aluSrcA = 0;aluSrcB = 0;aluCtr = 4'b0010;ext = 0;
				regDst = 1; memToReg = 0;regWrite = 1;
				memRead = 0;memWrite = 0;
				branch = 0;jump = 0;link = 0;retu = 0;bequal = 0;
			end
			6'b100100://and
			begin
				aluSrcA = 0;aluSrcB = 0;aluCtr = 4'b0100;ext = 0;
				regDst = 1; memToReg = 0;regWrite = 1;
				memRead = 0;memWrite = 0;
				branch = 0;jump = 0;link = 0;retu = 0;bequal = 0;
			end
			6'b100101://or
			begin
				aluSrcA = 0;aluSrcB = 0;aluCtr = 4'b0101;ext = 0;
				regDst = 1; memToReg = 0;regWrite = 1;
				memRead = 0;memWrite = 0;
				branch = 0;jump = 0;link = 0;retu = 0;bequal = 0;
			end
			6'b100110://xor
			begin
				aluSrcA = 0;aluSrcB = 0;aluCtr = 4'b0110;ext = 0;
				regDst = 1; memToReg = 0;regWrite = 1;
				memRead = 0;memWrite = 0;
				branch = 0;jump = 0;link = 0;retu = 0;bequal = 0;
			end
			6'b100111://nor
			begin
				aluSrcA = 0;aluSrcB = 0;aluCtr = 4'b0111;ext = 0;
				regDst = 1; memToReg = 0;regWrite = 1;
				memRead = 0;memWrite = 0;
				branch = 0;jump = 0;link = 0;retu = 0;bequal = 0;
			end
			6'b101010://slt
			begin
				aluSrcA = 0;aluSrcB = 0;aluCtr = 4'b1100;ext = 0;
				regDst = 1; memToReg = 0;regWrite = 1;
				memRead = 0;memWrite = 0;
				branch = 0;jump = 0;link = 0;retu = 0;bequal = 0;
			end
			6'b101011://sltu
			begin
				aluSrcA = 0;aluSrcB = 0;aluCtr = 4'b1101;ext = 0;
				regDst = 1; memToReg = 0;regWrite = 1;
				memRead = 0;memWrite = 0;
				branch = 0;jump = 0;link = 0;retu = 0;bequal = 0;
			end
			6'b000000://sll
			begin
				aluSrcA = 1;aluSrcB = 0;aluCtr = 4'b1000;ext = 0;
				regDst = 1; memToReg = 0;regWrite = 1;
				memRead = 0;memWrite = 0;
				branch = 0;jump = 0;link = 0;retu = 0;bequal = 0;
			end
			6'b000010://srl
			begin
				aluSrcA = 1;aluSrcB = 0;aluCtr = 4'b1010;ext = 0;
				regDst = 1; memToReg = 0;regWrite = 1;
				memRead = 0;memWrite = 0;
				branch = 0;jump = 0;link = 0;retu = 0;bequal = 0;
			end
			6'b000011://sra
			begin
				aluSrcA = 1;aluSrcB = 0;aluCtr = 4'b1011;ext = 0;
				regDst = 1; memToReg = 0;regWrite = 1;
				memRead = 0;memWrite = 0;
				branch = 0;jump = 0;link = 0;retu = 0;bequal = 0;
			end
			6'b000100://sllv
			begin
				aluSrcA = 0;aluSrcB = 0;aluCtr = 4'b1000;ext = 0;
				regDst = 1; memToReg = 0;regWrite = 1;
				memRead = 0;memWrite = 0;
				branch = 0;jump = 0;link = 0;retu = 0;bequal = 0;
			end
			6'b000110://srlv
			begin
				aluSrcA = 0;aluSrcB = 0;aluCtr = 4'b1010;ext = 0;
				regDst = 1; memToReg = 0;regWrite = 1;
				memRead = 0;memWrite = 0;
				branch = 0;jump = 0;link = 0;retu = 0;bequal = 0;
			end
			6'b000111://srav
			begin
				aluSrcA = 0;aluSrcB = 0;aluCtr = 4'b1011;ext = 0;
				regDst = 1; memToReg = 0;regWrite = 1;
				memRead = 0;memWrite = 0;
				branch = 0;jump = 0;link = 0;retu = 0;bequal = 0;
			end
			
			6'b001000://jr
			begin
				aluSrcA = 0;aluSrcB = 0;aluCtr = 4'b1110;ext = 0;
				regDst = 0; memToReg = 0;regWrite = 0;
				memRead = 0;memWrite = 0;
				branch = 0;jump = 0;link = 0;retu = 1;bequal = 0;
			end
			default:
			begin
				aluSrcA = 0;aluSrcB = 0;aluCtr = 4'b0000;ext = 0;
				regDst = 0; memToReg = 0;regWrite = 0;
				memRead = 0;memWrite = 0;
				branch = 0;jump = 0;link = 0;retu = 0;bequal = 0;
			end
			endcase
		end
		
		//I type
		6'b001000://addi
		begin
			aluSrcA = 0;aluSrcB = 1;aluCtr = 4'b0001;ext = 1;
			regDst = 0; memToReg = 0;regWrite = 1;
			memRead = 0;memWrite = 0;
			branch = 0;jump = 0;link = 0;retu = 0;bequal = 0;
		end
		6'b001001://addiu
		begin
			aluSrcA = 0;aluSrcB = 1;aluCtr = 4'b0001;ext = 0;
			regDst = 0; memToReg = 0;regWrite = 1;
			memRead = 0;memWrite = 0;
			branch = 0;jump = 0;link = 0;retu = 0;bequal = 0;
		end
		6'b001100://andi
		begin
			aluSrcA = 0;aluSrcB = 1;aluCtr = 4'b0100;ext = 0;
			regDst = 0; memToReg = 0;regWrite = 1;
			memRead = 0;memWrite = 0;
			branch = 0;jump = 0;link = 0;retu = 0;bequal = 0;
		end
		6'b001101://ori
		begin
			aluSrcA = 0;aluSrcB = 1;aluCtr = 4'b0101;ext = 0;
			regDst = 0; memToReg = 0;regWrite = 1;
			memRead = 0;memWrite = 0;
			branch = 0;jump = 0;link = 0;retu = 0;bequal = 0;
		end
		6'b001110://xori
		begin
			aluSrcA = 0;aluSrcB = 1;aluCtr = 4'b0110;ext = 0;
			regDst = 0; memToReg = 0;regWrite = 1;
			memRead = 0;memWrite = 0;
			branch = 0;jump = 0;link = 0;retu = 0;bequal = 0;
		end
		
		6'b001111://lui
		begin
			aluSrcA = 0;aluSrcB = 1;aluCtr = 4'b1001;ext = 0;
			regDst = 0; memToReg = 0;regWrite = 1;
			memRead = 0;memWrite = 0;
			branch = 0;jump = 0;link = 0;retu = 0;bequal = 0;
		end
		
		6'b100011://lw
		begin
			aluSrcA = 0;aluSrcB = 1;aluCtr = 4'b0001;ext = 1;
			regDst = 0; memToReg = 1;regWrite = 1;
			memRead = 1;memWrite = 0;
			branch = 0;jump = 0;link = 0;retu = 0;bequal = 0;
		end
		6'b101011://sw
		begin
			aluSrcA = 0;aluSrcB = 1;aluCtr = 4'b0001;ext = 1;
			regDst = 0; memToReg = 0;regWrite = 0;
			memRead = 0;memWrite = 1;
			branch = 0;jump = 0;link = 0;retu = 0;bequal = 0;
		end
		
		6'b000100://beq
		begin
			aluSrcA = 0;aluSrcB = 0;aluCtr = 4'b0010;ext = 1;
			regDst = 0; memToReg = 0;regWrite = 0;
			memRead = 0;memWrite = 0;
			branch = 1;jump = 0;link = 0;retu = 0;bequal = 1;
		end
		6'b000101://bne
		begin
			aluSrcA = 0;aluSrcB = 0;aluCtr = 4'b0010;ext = 1;
			regDst = 0; memToReg = 0;regWrite = 0;
			memRead = 0;memWrite = 0;
			branch = 1;jump = 0;link = 0;retu = 0;bequal = 0;
		end
		
		6'b001010://slti
		begin
			aluSrcA = 0;aluSrcB = 1;aluCtr = 4'b1100;ext = 1;
			regDst = 0; memToReg = 0;regWrite = 1;
			memRead = 0;memWrite = 0;
			branch = 0;jump = 0;link = 0;retu = 0;bequal = 0;
		end
		6'b001011://sltiu
		begin
			aluSrcA = 0;aluSrcB = 1;aluCtr = 4'b1101;ext = 1;
			regDst = 0; memToReg = 0;regWrite = 1;
			memRead = 0;memWrite = 0;
			branch = 0;jump = 0;link = 0;retu = 0;bequal = 0;
		end
		
		//J type
		6'b000010://j
		begin
			aluSrcA = 0;aluSrcB = 0;aluCtr = 0;ext = 0;
			regDst = 0; memToReg = 0;regWrite = 0;
			memRead = 0;memWrite = 0;
			branch = 0;jump = 1;link = 0;retu = 0;bequal = 0;
		end
		6'b000011://jal
		begin
			aluSrcA = 0;aluSrcB = 0;aluCtr = 0;ext = 0;
			regDst = 0; memToReg = 0;regWrite = 1;
			memRead = 0;memWrite = 0;
			branch = 0;jump = 1;link = 1;retu = 0;bequal = 0;
		end
		
		default:
		begin
			aluSrcA = 0;aluSrcB = 0;aluCtr = 0;ext = 0;
			regDst = 0; memToReg = 0;regWrite = 0;
			memRead = 0;memWrite = 0;
			branch = 0;jump = 0;link = 0;retu = 0;bequal = 0;
		end
	   endcase
    end
    
endmodule

