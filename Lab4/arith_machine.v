// arith_machine: execute a series of arithmetic instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock  (input)  - the clock signal
// reset  (input)  - set to 1 to set all registers to zero, set to 0 for normal execution.

module arith_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;
    wire [31:0] PC;
    wire [31:0] nextPC;
    wire [31:0] A;
    wire [31:0] B_data;
    wire [31:0] B;
    wire [31:0] w_data;
    wire [2:0] alu_op;
    wire [4:0] w_addr;
    wire write_enable, rd_src, alu_src2;

  wire [31:0] sign_out = {{16{inst[15]}}, inst[15:0]};
    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC, nextPC, clock, 1'b1, reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst, PC[31:2]);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (A, B_data, inst[25:21], inst[20:16], w_addr, w_data, write_enable, clock, reset);
    alu32 pcplus4(nextPC, , , , PC, 32'h4, `ALU_ADD);
    mux2v mx3(w_addr, inst[15:11], inst[20:16], rd_src);
    mux2v mx2(B, B_data, sign_out, alu_src2);
    alu32 aluout(w_data, , , , A, B, alu_op);
    mips_decode mipsd(alu_src2, rd_src, write_enable, alu_op, except, inst[31:26], inst[5:0]);


    /* add other modules */

    //assign except = 1'b0;

endmodule // arith_machine
