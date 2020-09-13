`define STATUS_REGISTER 5'd12
`define CAUSE_REGISTER  5'd13
`define EPC_REGISTER    5'd14

module cp0(rd_data, EPC, TakenInterrupt,
           wr_data, regnum, next_pc,
           MTC0, ERET, TimerInterrupt, clock, reset);
    output [31:0] rd_data;
    output [29:0] EPC;
    output        TakenInterrupt;
    input  [31:0] wr_data;
    input   [4:0] regnum;
    input  [29:0] next_pc;
    input         MTC0, ERET, TimerInterrupt, clock, reset;

    // your Verilog for coprocessor 0 goes here
    wire [31:0] eout;
    decoder32 e(eout, regnum[4:0], MTC0);

    wire [31:0] user_status;
    register #(32) userstatus(user_status, wr_data, clock, eout[12], reset);

    wire exception_level;
    dffe exceptionlevel(exception_level, 1'b1, clock, TakenInterrupt, reset || ERET);

    wire [29:0] epc_d;
    mux2v #(30) epcregisterd(epc_d, wr_data[31:2], next_pc, TakenInterrupt);
    register #(30) epcregister(EPC[29:0], epc_d, clock, eout[14] || TakenInterrupt, reset);

    wire [31:0] cause_register = {16'b0, TimerInterrupt, 15'b0};
    wire [31:0] status_register = {16'b0, user_status[15:8], 6'b0, exception_level, user_status[0]};

    assign TakenInterrupt = ((cause_register[15] && status_register[15]) &&
      ((~status_register[1]) && status_register[0]));

    mux32v rdmux(rd_data, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0,
     32'b0, 32'b0, status_register[31:0], cause_register[31:0], {EPC, 2'b0},32'b0, 32'b0, 32'b0,
     32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, regnum);

endmodule
