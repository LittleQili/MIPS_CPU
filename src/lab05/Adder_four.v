`timescale 1ns / 1ps

module Adder_four(
    input [31:0] pc,
    output reg [31:0] pc_4next
    );
    always @ (pc)
    begin
        pc_4next = pc + 4;
    end
endmodule
