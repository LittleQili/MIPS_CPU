`timescale 1ns / 1ps

module Top(
	input Clk,
	input reset
    );
	
	wire [31:0] jmpDst;
	wire stall;
	wire nop;
	wire targetAddr;
	
	wire [31:0] IF_pc_write;
	wire [31:0] IF_pc;
	wire [31:0] IF_pcplusfour;
	wire [31:0] IF_pcj;
	wire [31:0] IF_inst;
	
	
	wire [31:0] ID_inst; 
	wire [31:0] ID_pcplusfour;
	wire [31:0] ID_regDataA;
	wire [31:0] ID_regDataB;
	wire [31:0] ID_imm;
	wire [31:0] ID_branchDst;
	wire [4:0] ID_writeReg;//要写的寄存器编号
	
	wire ID_jump;
	wire ID_link;
	wire ID_ext;
	wire ID_regDst;
	wire ID_aluSrcA;
	wire ID_aluSrcB;
	wire [3:0] ID_aluCtr;
	wire ID_memToReg;
	wire ID_regWrite;
	wire ID_memRead;
	wire ID_memWrite;
	wire ID_branch;
	wire ID_bequal;
	wire ID_retu;
	
	wire EX_aluSrcA;
	wire EX_aluSrcB;
	wire [3:0] EX_aluCtr;
	wire EX_memToReg;
	wire EX_regWrite;
	wire EX_memRead;
	wire EX_memWrite;
	wire EX_branch;
	wire EX_bequal;
	wire EX_retu;
	
	wire [4:0] EX_regReadA;
	wire [4:0] EX_regReadB;
	wire [4:0] EX_writeReg;
	wire [31:0] EX_pcplusfour;
	wire [31:0] EX_regDataA;
	wire [31:0] EX_regDataB;
	wire [31:0] EX_imm;
	wire [31:0] EX_branchDst;
	
	wire [31:0] EX_shamt;
	wire [31:0] EX_ReginputA;
	wire [31:0] EX_ReginputB;
	wire [1:0] EX_FwChoiceA;
	wire [1:0] EX_FwChoiceB;
	wire EX_stallA;
	wire EX_stallB;
	wire [31:0] EX_ALUinputA;
	wire [31:0] EX_ALUinputB;
	wire EX_zero;
	wire [31:0] EX_ALURes;
	//IF
	PC myPC(
	.pc_write(IF_pc_write),
	.Clk(Clk),
	.reset(reset),
	.stall(stall)
	.pc(IF_pc)
    );
	
	Adder_four myAdder_four(
    .pc(IF_pc),
    .pc_4next(IF_pcplusfour)
    );
	
	MUX_zeroone JmpMUX(
	.input0(IF_pcplusfour),
	.input1(jmpDst),
	.flag(ID_jump),
	.MUX_res(IF_pcj)
    );
	
	MUXposEdge myPCMUX(
	.input0(IF_pcj),
	.input1(targetAddr),
	.flag(nop),
	.MUX_res(IF_pc_write)
    );
	
	InstMemory myInstmemory(
	.readAddr(IF_pc),
	.Instruction(IF_inst)
    );
	
	
	//ID
	
	IFID myIFID(
	.Clk(Clk),
	.nop(nop),
	.stall(stall),
	.IF_inst(IF_inst),
	.ID_inst(ID_inst),
	.IF_pcplusfour(IF_pcplusfour),
	.ID_pcplusfour(ID_pcplusfour),
    );
	
	Registers myRegisters(
    .readReg1(ID_inst[25:21]),
    .readReg2(ID_inst[20:16]),
    input .writeReg(writeReg),
    input .writeData(writeback),
	.writeLink(ID_pcplusfour),
    input .regWrite(regWrite),
	.link(ID_link),
	.Clk(Clk),
	.reset(reset),
    .readData1(ID_regDataA),
    .readData2(ID_regDataB)
    );
	
	Ctr myCtr(
    .opCode(ID_inst[31:26]),
	.func(ID_inst[5:0]),
	
    .aluSrcA(ID_aluSrcA),
	.aluSrcB(ID_aluSrcB),
	.aluCtr(ID_aluCtr),
	.ext(ID_ext),
	
	.regDst(ID_regDst),
    .memToReg(ID_memToReg),
    .regWrite(ID_regWrite),
	
    .memRead(ID_memRead),
    .memWrite(ID_memWrite),
	
    .branch(ID_branch),
	.bequal(ID_bequal),
    .jump(ID_jump),
	.link(ID_link),//jal
	.retu(ID_retu)//jr
    );
	
	signExt mysignExt(
    .inst(ID_inst[15:0]),
	.ext(ID_ext),
    .data(ID_imm)
    );
	
	Adder_branch myAdder_branch(
	.pc_4next(ID_pcplusfour),
	.imm(ID_imm),
	.branch_dst(ID_branchDst)
    );
	
	SHL_two_J mySHL_two_J(
    .Instruction(ID_inst[25:0]),
    .pc_4next(ID_pcplusfour[31:28]),
    .pc_J(jmpDst)
    );
	
	MUXfivebits RegistersMUX(
	.input0(ID_inst[20:16]),
	.input1(ID_inst[15:11]),
	.flag(ID_regDst),
	.MUX_res(ID_writeReg)
    );
	
	//EX
	
	IDEX myIDEX(
	.Clk(Clk),
	.nop(nop),
	.stall(stall),
	
	.ID_regReadA(ID_inst[25:21]),
	.EX_regReadA(EX_regReadA),
	.ID_regReadB(ID_inst[20:16]),
	.EX_regReadB(EX_regReadB),
	.ID_writeReg(ID_writeReg),
	.EX_writeReg(EX_writeReg),
	
	.ID_pcplusfour(ID_pcplusfour),
	.EX_pcplusfour(EX_pcplusfour),
	
	.ID_regDataA(ID_regDataA),
	.EX_regDataA(EX_regDataA),
	.ID_regDataB(ID_regDataB),
	.EX_regDataB(EX_regDataB),
	.ID_imm(ID_imm),
	.EX_imm(EX_imm),
	
	.ID_branchDst(ID_branchDst),
	.EX_branchDst(EX_branchDst),
	
	.ID_aluSrcA(ID_aluSrcA),
	.ID_aluSrcB(ID_aluSrcB),
	.ID_aluCtr(ID_aluCtr),
	.ID_memToReg(ID_memToReg),
	.ID_regWrite(ID_regWrite),
	.ID_memRead(ID_memRead),
	.ID_memWrite(ID_memWrite),
	.ID_branch(ID_branch),
	.ID_bequal(ID_bequal),
	.ID_retu(ID_retu),
	
	.EX_aluSrcA(EX_aluSrcA),
	.EX_aluSrcB(EX_aluSrcB),
	.EX_aluCtr(EX_aluCtr),
	.EX_memToReg(EX_memToReg),
	.EX_regWrite(EX_regWrite),
	.EX_memRead(EX_memRead),
	.EX_memWrite(EX_memWrite),
	.EX_branch(EX_branch),
	.EX_bequal(EX_bequal),
	.EX_retu(EX_retu)
    );
	
	SHR_six mySHR_six(
    .imm(EX_imm),
    .shamt(EX_shamt)
    );
	
	MUX_zeroone ALUMUXA(
	.input0(EX_regDataA),
	.input1(EX_shamt),
	.flag(EX_aluSrcA),
	.MUX_res(EX_ReginputA)
    );
	MUX_zeroone ALUMUXB(
	.input0(EX_regDataB),
	.input1(EX_imm),
	.flag(EX_aluSrcB),
	.MUX_res(EX_ReginputB)
    );
	
	ForwardingCtr FwALUinputA(
	.regRead(EX_regReadA),
	input [4:0] regWrite_EXMA,//MA
	input [4:0] regWrite_MAWB,//WB
	
	input [31:0] pc_EXMA,//MA
	input [31:0] pc_MAWB,//WB
	
	.flag_Alusrc(EX_aluSrcA),
	input flag_regWrite_EXMA,//MA
	input flag_regWrite_MAWB,//WB
	input flag_memToReg_EXMA,//MA
	input flag_memToReg_MAWB,//WB
	
	.choice(EX_FwChoiceA),
	.stall(EX_stallA)
    );
	
	ForwardingCtr FwALUinputB(
	.regRead(EX_regReadB),
	input [4:0] regWrite_EXMA,//MA
	input [4:0] regWrite_MAWB,//WB
	
	input [31:0] pc_EXMA,//MA
	input [31:0] pc_MAWB,//WB
	
	.flag_Alusrc(EX_aluSrcB),
	input flag_regWrite_EXMA,//MA
	input flag_regWrite_MAWB,//WB
	input flag_memToReg_EXMA,//MA
	input flag_memToReg_MAWB,//WB
	
	.choice(EX_FwChoiceB),
	.stall(EX_stallB)
    );
	
	Orer Staller(
    .input1(EX_stallA),
	.input2(EX_stallB),
    .OrRes(stall)
    );
	
	MUXForwarding MUXFwA(
	.input_EX(EX_ReginputA),
	input [31:0] input_MA,//MA
	input [31:0] input_WB_mem,//WB
	input [31:0] input_WB_reg,//WB
	.flag(EX_FwChoiceA),
	.MUX_res(EX_ALUinputA)
    );
	MUXForwarding MUXFwB(
	.input_EX(EX_ReginputB),
	input [31:0] input_MA,//MA
	input [31:0] input_WB_mem,//WB
	input [31:0] input_WB_reg,//WB
	.flag(EX_FwChoiceB),
	.MUX_res(EX_ALUinputB)
    );
	
	ALU myALU(
       .input1(EX_ALUinputA),
       .input2(EX_ALUinputB),
       .ALUCtr(EX_aluCtr),
       .zero(EX_zero),
       .ALURes(EX_ALURes)
    );
	
	BranchJrjudge myBranchJrjudge(
	.Clk(Clk),
	.stall(stall),
    .zero(EX_zero),
	.branch(EX_branch),
	.bequal(EX_bequal),
	.retu(EX_retu),
	
	.branchRes(EX_branchDst),
	.ALURes(EX_ALURes),
	
    .nop(nop),
	.targetAddr(targetAddr)
    );
	
	
	//MA
	EXMA myEXMA(
	.Clk(Clk),
	.stall(stall),
	
	.EX_ALURes(EX_ALURes),
	output reg [31:0] MA_ALURes,
	.EX_regDataB(EX_regDataB),
	output reg [31:0] MA_regDataB,
	
	.EX_writeReg(EX_writeReg),
	output reg [4:0] MA_writeReg,
	
	.EX_pcplusfour(EX_pcplusfour),
	output reg [31:0] MA_pcplusfour,
	
	.EX_memToReg(EX_memToReg),
	.EX_regWrite(EX_regWrite),
	.EX_memRead(EX_memRead),
	.EX_memWrite(EX_memWrite),
	output reg MA_memToReg,
	output reg MA_regWrite,
	output reg MA_memRead,
	output reg MA_memWrite
    );
	
	
	//old
	
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