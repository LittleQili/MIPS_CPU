`timescale 1ns / 1ps

module Top(
	input Clk,
	input reset
	//test
    );
	wire [31:0] pc;
	wire [31:0] inst;
	wire [4:0] writeReg;
	wire [31:0] regData1;
	wire [31:0] regData2;
	wire [31:0] imm;
	wire [31:0] shamt;
	wire [31:0] ALUinputA;
	wire [31:0] ALUinputB;
	wire [31:0] ALURes;
	wire zero;
	wire [31:0] Memdata;
	wire [31:0] CalRes;
	wire [31:0] pcplusfour;
	wire [31:0] writeback;
	wire [31:0] pc_write;
	wire [31:0] pc_J;
	wire [31:0] branch_dst;
	wire [31:0] branchRes;
	wire [31:0] bjRes;
	
	wire branchenable;
	wire aluSrcA;
	wire aluSrcB;
	wire [3:0] aluCtr;
	wire ext;
	wire regDst;
	wire memToReg;
	wire regWrite;
	wire memRead;
	wire memWrite;
	wire branch;
	wire bequal;
	wire jump;
	wire link;
	wire retu;
	
	PC myPC(
	.pc_write(pc_write),
	.Clk(Clk),
	.reset(reset),
	.pc(pc)
    );
	
	MUX_zeroone PCMUX(
	.input0(bjRes),
	.input1(writeback),
	.flag(retu),
	.MUX_res(pc_write)
    );
	
	Ctr myCtr(
    .opCode(inst[31:26]),
	.func(inst[5:0]),
	
    .aluSrcA(aluSrcA),
	.aluSrcB(aluSrcB),
	.aluCtr(aluCtr),
	.ext(ext),
	
	.regDst(regDst),
    .memToReg(memToReg),
    .regWrite(regWrite),
	
    .memRead(memRead),
    .memWrite(memWrite),
	
    .branch(branch),
	.bequal(bequal),
    .jump(jump),
	.link(link),//jal
	.retu(retu)//jr
    );
	
	InstMemory myInstmemory(
	.readAddr(pc),
	.Instruction(inst)
    );
	
	Registers myRegisters(
    .readReg1(inst[25:21]),
    .readReg2(inst[20:16]),
    .writeReg(writeReg),
    .writeData(writeback),
    .regWrite(regWrite),
	.link(link),
	.Clk(Clk),
	.reset(reset),
    .readData1(regData1),
    .readData2(regData2)
    );
	
	MUXfivebits RegistersMUX(
	.input0(inst[20:16]),
	.input1(inst[15:11]),
	.flag(regDst),
	.MUX_res(writeReg)
    );
	
	signExt mysignExt(
    .inst(inst[15:0]),
	.ext(ext),
    .data(imm)
    );
	
	SHR_six mySHR_six(
    .imm(imm),
    .shamt(shamt)
    );
	
	ALU myALU(
       .input1(ALUinputA),
       .input2(ALUinputB),
       .ALUCtr(aluCtr),
       .zero(zero),
       .ALURes(ALURes)
    );
	
	MUX_zeroone ALUMUXA(
	.input0(regData1),
	.input1(shamt),
	.flag(aluSrcA),
	.MUX_res(ALUinputA)
    );
	MUX_zeroone ALUMUXB(
	.input0(regData2),
	.input1(imm),
	.flag(aluSrcB),
	.MUX_res(ALUinputB)
    );
	
	DataMemory myDataMemory(
    .Clk(Clk),
    .address(ALURes),
    .writeData(regData2),
    .memWrite(memWrite),
    .memRead(memRead),
    .readData(Memdata)
    );
	
	MUX_zeroone datamemregMUX(
	.input0(ALURes),
	.input1(Memdata),
	.flag(memToReg),
	.MUX_res(CalRes)
    );
	MUX_zeroone linkMUX(
	.input0(CalRes),
	.input1(pcplusfour),
	.flag(link),
	.MUX_res(writeback)
    );
	
	Adder_four myAdder_four(
    .pc(pc),
    .pc_4next(pcplusfour)
    );
	
	SHL_two_J mySHL_two_J(
    .Instruction(inst[25:0]),
    .pc_4next(pcplusfour[31:28]),
    .pc_J(pc_J)
    );
	
	Adder_branch myAdder_branch(
	.pc_4next(pcplusfour),
	.imm(imm),
	.branch_dst(branch_dst)
    );
	
	judgeBranch myjudgeBranch(
    .zero(zero),
	.branch(branch),
	.bequal(bequal),
    .branchenable(branchenable)
    );
	
	MUX_zeroone BranchMUX(
	.input0(pcplusfour),
	.input1(branch_dst),
	.flag(branchenable),
	.MUX_res(branchRes)
    );
	MUX_zeroone JumpMUX(
	.input0(branchRes),
	.input1(pc_J),
	.flag(jump),
	.MUX_res(bjRes)
    );
	
endmodule