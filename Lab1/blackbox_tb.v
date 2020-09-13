module blackbox_test;

    reg i_in, s_in, o_in;

    wire b_out;

    blackbox bb1 (b_out, i_in, s_in, o_in);
    initial begin

        $dumpfile("bb.vcd");
        $dumpvars(0,blackbox_test);

        i_in = 0; s_in = 0; o_in = 0; #10;
        i_in = 0; s_in = 0; o_in = 1; #10;
        i_in = 0; s_in = 1; o_in = 0; #10;
        i_in = 0; s_in = 1; o_in = 1; #10;
        i_in = 1; s_in = 0; o_in = 0; #10;
        i_in = 1; s_in = 0; o_in = 1; #10;
        i_in = 1; s_in = 1; o_in = 0; #10;
        i_in = 1; s_in = 1; o_in = 1; #10;

        $finish;
    end

    initial
      $monitor("At time %2t, i_in = %d s_in = %d o_in = %d b_out = %d",
              $time, i_in, s_in, o_in, b_out);
endmodule // blackbox_test
