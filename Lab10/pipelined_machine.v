module pipelined_machine(clk, reset);
    input        clk, reset;

    wire [31:0]  PC;
    wire [31:2]  next_PC, PC_plus4_new,PC_plus4, PC_target;
    wire [31:0]  inst, inst_pre;

    wire [31:0]  imm = {{ 16{inst[15]} }, inst[15:0] };  // sign-extended immediate
    wire [4:0]   rs = inst[25:21];
    wire [4:0]   rt = inst[20:16];
    wire [4:0]   rd = inst[15:11];
    wire [5:0]   opcode = inst[31:26];
    wire [5:0]   funct = inst[5:0];

    wire [4:0]   wr_regnum, wr_regnum_MW;
    wire [2:0]   ALUOp, ALUOp_MW;

    wire         RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst;
    wire         RegWrite_MW, BEQ_MW, ALUSrc_MW, MemRead_MW, MemWrite_MW, MemToReg_MW, RegDst_MW;
    wire         PCSrc, zero, ForwardA, ForwardB, stall;
    wire [31:0]  rd1_data, rd2_data, B_data, alu_out_data, load_data, wr_data;
    wire [31:0]  rd1_data_new, rd2_data_MW, rd2_data_new, alu_out_data_MW;

    assign ForwardA = (RegWrite_MW && (rs == wr_regnum_MW) && ~(rs == 0));
  	assign ForwardB = (RegWrite_MW && (rt == wr_regnum_MW) && ~(rt == 0));

  	assign stall = ((rs == wr_regnum_MW) && ~(rs == 0) || (rt == wr_regnum_MW) && ~(rt == 0)) && (MemRead_MW);
    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(30, 30'h100000) PC_reg(PC[31:2], next_PC[31:2], clk, ~stall, reset);

    assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
    adder30 next_PC_adder(PC_plus4, PC[31:2], 30'h1);
    adder30 target_PC_adder(PC_target, PC_plus4_new, imm[29:0]);
    mux2v #(30) branch_mux(next_PC, PC_plus4, PC_target, PCSrc);
    assign PCSrc = BEQ & zero;

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory imem(inst_pre, PC[31:2]);
    register #(32) if_de_imem(inst, inst_pre, clk, ~stall, PCSrc || reset);
    register #(30) if_de_pcplusfour(PC_plus4_new, PC_plus4, clk, ~stall, PCSrc || reset);

    mips_decode decode(ALUOp, RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst,
                      opcode, funct);
    register #(3) aluop_mw(ALUOp_MW, ALUOp, clk, 1'b1, PCSrc);
    register #(1) regwrite_mw(RegWrite_MW, RegWrite, clk, 1'b1, PCSrc);
    register #(1) beq_mw(BEQ_MW, BEQ, clk, 1'b1, PCSrc);
    register #(1) alusrc_mw(ALUSrc_MW, ALUSrc, clk, 1'b1, PCSrc);
    register #(1) memread_mw(MemRead_MW, MemRead, clk, 1'b1, PCSrc);
    register #(1) memwrite_mw(MemWrite_MW, MemWrite, clk, 1'b1, PCSrc);
    register #(1) memtoreg_mw(MemToReg_MW, MemToReg, clk, 1'b1, PCSrc);
    register #(1) regdst_mw(RegDst_MW, RegDst, clk, 1'b1, PCSrc);
    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rd1_data, rd2_data_new,
               rs, rt, wr_regnum_MW, wr_data,
               RegWrite_MW, clk, reset);

    mux2v #(32) forwarda_mux(rd1_data_new, rd1_data, alu_out_data_MW, ForwardA);
   	mux2v #(32) forwardb_mux(rd2_data, rd2_data_new, alu_out_data_MW, ForwardB);

    mux2v #(32) imm_mux(B_data, rd2_data, imm, ALUSrc);
    alu32 alu(alu_out_data, zero, ALUOp, rd1_data_new, B_data);

    // DO NOT comment out or rename this module
    // or the test bench will break
    data_mem data_memory(load_data, alu_out_data_MW, rd2_data_MW, MemRead_MW, MemWrite_MW, clk, reset);

  	register #(32) aluresult_mw(alu_out_data_MW, alu_out_data, clk, 1'b1, PCSrc);
  	register #(32) forwardB_mw(rd2_data_MW, rd2_data, clk, 1'b1, PCSrc);
  	register #(5) regnum_mw(wr_regnum_MW, wr_regnum, clk, 1'b1, PCSrc);

    mux2v #(32) wb_mux(wr_data, alu_out_data_MW, load_data, MemToReg_MW);
    mux2v #(5) rd_mux(wr_regnum, rt, rd, RegDst);
endmodule // pipelined_machine
