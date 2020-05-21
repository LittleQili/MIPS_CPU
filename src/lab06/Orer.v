`timescale 1ns / 1ps

module Orer(
    input input1,
	input input2,
    output reg OrRes
    );
    always @ (input1 or input2)
    begin
        OrRes = input1 | input2;
    end
endmodule
