`timescale 1ns / 1ps

module Top(
	input Clk,
	input reset
    );
	
	wire [31:0] jmpDst;
	wire stall;
	wire nop;
	wire [31:0] targetAddr;
	
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
	wire [4:0] ID_writeReg;//瑕佸啓鐨勫瘎瀛樺櫒缂栧彿
	
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
	
	wire [31:0] MA_ALURes;
	wire [31:0] MA_regDataB;
	wire [4:0] MA_writeReg;
	wire [31:0] MA_pcplusfour;
	
	wire MA_memToReg;
	wire MA_regWrite;
	wire MA_memRead;
	wire MA_memWrite;
	
	wire [31:0] MA_memData;
	
	wire [31:0] WB_ALURes;
	wire [31:0] WB_memData;
	wire [4:0] WB_writeReg;
	wire [31:0] WB_pcplusfour;
	
	wire WB_memToReg;
	wire WB_regWrite;
	
	wire [31:0] WB_CalRes;
	
	//IF
	PC myPC(
	.pc_write(IF_pc_write),
	.Clk(Clk),
	.reset(reset),
	.stall(stall),
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
	.ID_pcplusfour(ID_pcplusfour)
    );
	
	Registers myRegisters(
    .readReg1(ID_inst[25:21]),
    .readReg2(ID_inst[20:16]),
    .writeReg(WB_writeReg),
    .writeData(WB_CalRes),
	.writeLink(ID_pcplusfour),
    .regWrite(WB_regWrite),
	.link(ID_link),
	.Clk(Clk),
	.reset(reset),
    .readData1(ID_regDataA),
    .readData2(ID_regDataB)
    );
	
	Ctr myCtr(
    .inst(ID_inst),
	
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
	.regWrite_EXMA(MA_writeReg),//MA
	.regWrite_MAWB(WB_writeReg),//WB
	
	.pc_EXMA(MA_pcplusfour),//MA
	.pc_MAWB(WB_pcplusfour),//WB
	
	.flag_Alusrc(EX_aluSrcA),
	.flag_regWrite_EXMA(MA_regWrite),//MA
	.flag_regWrite_MAWB(WB_regWrite),//WB
	.flag_memToReg_EXMA(MA_memToReg),//MA
	.flag_memToReg_MAWB(WB_memToReg),//WB
	
	.choice(EX_FwChoiceA),
	.stall(EX_stallA)
    );
	
	ForwardingCtr FwALUinputB(
	.regRead(EX_regReadB),
	.regWrite_EXMA(MA_writeReg),//MA
	.regWrite_MAWB(WB_writeReg),//WB
	
	.pc_EXMA(MA_pcplusfour),//MA
	.pc_MAWB(WB_pcplusfour),//WB
	
	.flag_Alusrc(EX_aluSrcB),
	.flag_regWrite_EXMA(MA_regWrite),//MA
	.flag_regWrite_MAWB(WB_regWrite),//WB
	.flag_memToReg_EXMA(MA_memToReg),//MA
	.flag_memToReg_MAWB(WB_memToReg),//WB
	
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
	.input_MA(MA_ALURes),//MA
	.input_WB_mem(WB_memData),//WB
	.input_WB_reg(WB_ALURes),//WB
	.flag(EX_FwChoiceA),
	.MUX_res(EX_ALUinputA)
    );
	MUXForwarding MUXFwB(
	.input_EX(EX_ReginputB),
	.input_MA(MA_ALURes),//MA
	.input_WB_mem(WB_memData),//WB
	.input_WB_reg(WB_ALURes),//WB
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
	.MA_ALURes(MA_ALURes),
	.EX_regDataB(EX_regDataB),
	.MA_regDataB(MA_regDataB),
	
	.EX_writeReg(EX_writeReg),
	.MA_writeReg(MA_writeReg),
	
	.EX_pcplusfour(EX_pcplusfour),
	.MA_pcplusfour(MA_pcplusfour),
	
	.EX_memToReg(EX_memToReg),
	.EX_regWrite(EX_regWrite),
	.EX_memRead(EX_memRead),
	.EX_memWrite(EX_memWrite),
	.MA_memToReg(MA_memToReg),
	.MA_regWrite(MA_regWrite),
	.MA_memRead(MA_memRead),
	.MA_memWrite(MA_memWrite)
    );
	
	DataMemory myDataMemory(
    .Clk(Clk),
    .address(MA_ALURes),
    .writeData(MA_regDataB),
    .memWrite(MA_memWrite),
    .memRead(MA_memRead),
    .readData(MA_memData)
    );
	
	
	//WB
	MAWB myMAWB(
	.Clk(Clk),
	
	.MA_ALURes(MA_ALURes),
	.WB_ALURes(WB_ALURes),
	.MA_memData(MA_memData),
	.WB_memData(WB_memData),
	
	.MA_writeReg(MA_writeReg),
	.WB_writeReg(WB_writeReg),
	
	.MA_pcplusfour(MA_pcplusfour),
	.WB_pcplusfour(WB_pcplusfour),
	
	.MA_memToReg(MA_memToReg),
	.MA_regWrite(MA_regWrite),
	.WB_memToReg(WB_memToReg),
	.WB_regWrite(WB_regWrite)
    );
	
	MUX_zeroone datamemregMUX(
	.input0(WB_ALURes),
	.input1(WB_memData),
	.flag(WB_memToReg),
	.MUX_res(WB_CalRes)
    );
	
endmodule