`timescale 1ns / 1ps

/*����дһ����������ʾ��ͼƬ����˼��
  ʱ���½���д��
  ���κ�ʱ�򶼿���
  ��дͬʱ�Ļ������߶����ܽ��У������0��д����ȥ
*/

module DataMemory(
    input Clk,
    input [31:0] address,
    input [31:0] writeData,
    input memWrite,
    input memRead,
    output reg [31:0] readData
    );
	reg [31:0] memFile[31:0];//test
	
	always @ (memRead or memWrite or address)
	begin
		if(memRead == 1)
		begin
			if(memWrite != 1) readData = memFile[address];
			else readData = 0;
		end
	end
	
	always @ (negedge Clk)
	begin
		if(memWrite == 1)
		begin
			if(memRead != 1) memFile[address] <= writeData;
		end
	end
	
endmodule
