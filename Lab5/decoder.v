// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op       (output) - control signal to be sent to the ALU
// writeenable  (output) - should a new value be captured by the register file
// rd_src       (output) - should the destination register be rd (0) or rt (1)
// alu_src2     (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except       (output) - set to 1 when we don't recognize an opdcode & funct combination
// control_type (output) - 00 = fallthrough, 01 = branch_target, 10 = jump_target, 11 = jump_register
// mem_read     (output) - the register value written is coming from the memory
// word_we      (output) - we're writing a word's worth of data
// byte_we      (output) - we're only writing a byte's worth of data
// byte_load    (output) - we're doing a byte load
// slt          (output) - the instruction is an slt
// lui          (output) - the instruction is a lui
// addm         (output) - the instruction is an addm
// opcode        (input) - the opcode field from the instruction
// funct         (input) - the function field from the instruction
// zero          (input) - from the ALU
//

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                   mem_read, word_we, byte_we, byte_load, slt, lui, addm,
                   opcode, funct, zero);
    output [2:0] alu_op;
    output       writeenable, rd_src, alu_src2, except;
    output [1:0] control_type;
    output       mem_read, word_we, byte_we, byte_load, slt, lui, addm;
    input  [5:0] opcode, funct;
    input        zero;

    wire add = (opcode == `OP_OTHER0) & (funct == `OP0_ADD);
    wire sub = (opcode == `OP_OTHER0) & (funct == `OP0_SUB);
    wire nd = (opcode == `OP_OTHER0) & (funct == `OP0_AND);
    wire r = (opcode == `OP_OTHER0) & (funct == `OP0_OR);
    wire nr = (opcode == `OP_OTHER0) & (funct == `OP0_NOR);
    wire xr = (opcode == `OP_OTHER0) & (funct == `OP0_XOR);
    wire adi = (opcode == `OP_ADDI);
    wire ndi = (opcode == `OP_ANDI);
    wire ri = (opcode == `OP_ORI);
    wire xri = (opcode == `OP_XORI);

    wire bne = (opcode == `OP_BNE);
    wire beq = (opcode == `OP_BEQ);
    wire j = (opcode == `OP_J);
    wire jr = (opcode == `OP_OTHER0) && (funct == `OP0_JR);
    assign lui = (opcode == `OP_LUI);
    assign slt = (opcode == `OP_OTHER0) && (funct == `OP0_SLT);
    wire lw = (opcode == `OP_LW);
    wire lbu = (opcode == `OP_LBU);
    wire sw = (opcode == `OP_SW);
    wire sb = (opcode == `OP_SB);
    assign addm = (opcode == `OP_OTHER0) && (funct == `OP0_ADDM);

    assign control_type[0] = (beq & zero) | (bne & !zero) | jr;
    assign control_type[1] = j || jr;
    assign mem_read = lw || lbu || addm;
    assign word_we = sw;
    assign byte_we = sb;
    assign byte_load = lbu;
    assign alu_src2 = adi || ndi || ri || xri || lui || lw || lbu || sw || sb;
    assign rd_src = alu_src2;

    assign writeenable = ~(bne | beq | j | jr | sw | sb | except);
    assign except = ~(add | sub | nd | r | nr | xr | adi | ndi | ri | xri |
      bne | beq | j | jr | lui | slt | lw | lbu | sw | sb | addm);

    wire al0 = bne || slt || beq;
    wire al1 = lbu || bne || beq || slt || lw || sw || sb;
    assign alu_op[0] = sub || r || xr || xri || al0;
    assign alu_op[1] = add || sub || nr || xr || adi || xri || al1 || addm;
    assign alu_op[2] = nd || r || nr || xr || ndi || ri || xri;

endmodule // mips_decode
