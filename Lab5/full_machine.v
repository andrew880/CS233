// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock   (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst, PC, nextPC, pc4out, pc4off;
    wire [31:0] rsdata, rtdata, B, w_data, addr, rddata;
    wire [2:0] alu_op;
    wire [4:0] w_addr;
    wire [7:0] byteload;
    wire [31:0] byteout, memout, sltout, data_out, luiout, addmin, bout, addmout, Bout;
    wire [1:0] control_type;
    wire write_enable, rd_src, alu_src2, overflow, zero, neg, slt, lui, mem_read;
    wire addm, word_we, byte_we, byte_load;

    wire [31:0] jump;
    assign jump[31:28] = PC[31:28];
    assign jump[27:2] = inst[25:0];
    assign jump[1:0] = 0;

    wire [31:0] sign_out = {{16{inst[15]}}, inst[15:0]};
    wire [31:0] branch_offset = {sign_out[29:0], 2'b00};
    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC, nextPC, clock, 1'b1, reset);

    alu32 pcplus4(pc4out, , , , PC, 32'b100, `ALU_ADD);
    alu32 pc4plusoffset(pc4off, , , , pc4out, branch_offset, `ALU_ADD);
    mux4v cont(nextPC, pc4out, pc4off, jump, rsdata, control_type);
    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst, PC[31:2]);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rsdata, rtdata, inst[25:21], inst[20:16], w_addr, rddata, write_enable, clock, reset);
    mux2v #(5) mxrd(w_addr, inst[15:11], inst[20:16], rd_src);

    alu32 aluaddm(addmout, , , , rtdata, data_out, 3'b010);
    mux2v mx2b(Bout, rtdata, sign_out, alu_src2);
    mux2v mxaddm(B, Bout, 32'b0, addm);
    mux2v mxadfin(rddata, luiout, addmout, addm);
    alu32 aluout(addr, overflow, zero, neg, rsdata, B, alu_op);

    data_mem mem(data_out, addr, rtdata, word_we, byte_we, clock, reset);
    mux4v #(8) mx4(byteload, data_out[7:0], data_out[15:8], data_out[23:16], data_out[31:24], addr[1:0]);
    wire [31:0] bt;
    assign bt [31:8] = 0;
    assign bt [7:0] = byteload;
    mux2v mxbyte(byteout, data_out, bt, byte_load);
    wire [31:0] st;
    assign st [31:1] = 0;
    assign st [0] = neg;
    mux2v mxslt(sltout, addr, st, slt);
    mux2v mxmem(memout, sltout, byteout, mem_read);
    wire [31:0] li;
    assign li [31:16] = inst[15:0];
    assign li [15:0] = 0;
    mux2v mxlui(luiout, memout, li, lui);

    mips_decode mipsd(alu_op, write_enable, rd_src, alu_src2, except, control_type,
                       mem_read, word_we, byte_we, byte_load, slt, lui, addm,
                       inst[31:26], inst[5:0], zero);


endmodule // full_machine
