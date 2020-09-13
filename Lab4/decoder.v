// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_src2    (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// rd_src      (output) - should the destination register be rd (0) or rt (1)
// writeenable (output) - should a new value be captured by the register file
// alu_op      (output) - control signal to be sent to the ALU
// except      (output) - set to 1 when the opcode/funct combination is unrecognized
// opcode      (input)  - the opcode field from the instruction
// funct       (input)  - the function field from the instruction
//

module mips_decode(alu_src2, rd_src, writeenable, alu_op, except, opcode, funct);
    output       alu_src2, rd_src, writeenable, except;
    output [2:0] alu_op;
    input  [5:0] opcode, funct;


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


    assign alu_src2 = (opcode && `OP_ADDI) || (opcode && `OP_ANDI) || (opcode && `OP_ORI) || (opcode && `OP_XORI);
    assign rd_src = (opcode && `OP_ADDI) || (opcode && `OP_ANDI) || (opcode && `OP_ORI) || (opcode && `OP_XORI);

    assign writeenable = add | sub | nd | r | nr | xr | adi | ndi | ri | xri;
    assign except = ~writeenable;

    assign alu_op[0] = sub || r || xr || xri;
    assign alu_op[1] = add || sub || nr || xr || adi || xri;
    assign alu_op[2] = nd || r || nr || xr || ndi || ri || xri;
endmodule // mips_decode
