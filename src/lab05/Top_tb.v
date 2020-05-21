`timescale 1ns / 1ps

module Top_tb(

    );
	reg Clk;
	reg reset;
	Top myTop(
	.Clk(Clk),
	.reset(reset)
	);
	parameter PERIOD = 50;
	
	always #(PERIOD) Clk = ~Clk;
	
	initial begin
		Clk = 1;
		reset = 1;
		#2;
		reset = 0;
	end
endmodule
