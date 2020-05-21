`timescale 1ns / 1ps

/*这里写一下我所理解的示例图片的意思：
  时钟下降沿写入
  读任何时候都可以
  读写同时的话，二者都不能进行，读输出0，写不进去
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
