module timer(TimerInterrupt, cycle, TimerAddress,
             data, address, MemRead, MemWrite, clock, reset);
    output        TimerInterrupt;
    output [31:0] cycle;
    output        TimerAddress;
    input  [31:0] data, address;
    input         MemRead, MemWrite, clock, reset;

    wire [31:0] Qcc, Dcc;
    register #(32) cycle_counter(Qcc, Dcc, clock, 1'd1, reset);
    alu32 cycle_alu(Dcc, , , `ALU_ADD,Qcc, 32'd1);

    wire [31:0] Qic;
    wire timerwrite;
    register #(32, 32'hffffffff) interrupt_cycle(Qic, data, clock, timerwrite, reset);

    wire added1c = address == 32'hffff001c;
    wire added6c = address == 32'hffff006c;

    wire timerread, acknowledge;
    tristate tricycle(cycle, Qcc, timerread);
    assign acknowledge = added6c & MemWrite;
    wire resetil = acknowledge | reset;
    dffe interrupt_line(TimerInterrupt, 1'd1, clock, Qcc == Qic, resetil);
    // complete the timer circuit here

    assign timerread = added1c & MemRead;
    assign timerwrite = added1c & MemWrite;
    assign TimerAddress = added1c | added6c;
    // HINT: make your interrupt cycle register reset to 32'hffffffff
    //       (using the reset_value parameter)
    //       to prevent an interrupt being raised the very first cycle
endmodule
