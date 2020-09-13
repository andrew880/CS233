module sc2_test;

    reg a_in, b_in, c_in;                           // these are inputs to "circuit under test"
                                              // use "reg" not "wire" so can assign a value
    wire s_out, c_out;                        // wires for the outputs of "circuit under test"

    sc2_block sc2 (s_out, c_out, a_in, b_in, c_in);  // the circuit under test

    initial begin                             // initial = run at beginning of simulation
                                          // begin/end = associate block with initial

    $dumpfile("sc2.vcd");                  // name of dump file to create
    $dumpvars(0,sc2_test);                 // record all signals of module "sc_test" and sub-modules
                                          // remember to change "sc_test" to the correct
                                          // module name when writing your own test benches

    // test all six input combinations
    a_in = 0; b_in = 0; c_in = 0; # 10;             // set initial values and wait 10 time units
    a_in = 0; b_in = 0; c_in = 1; # 10;
    a_in = 0; b_in = 1; c_in = 0; # 10;             // change inputs and then wait 10 time units
    a_in = 0; b_in = 1; c_in = 1; # 10;
    a_in = 1; b_in = 0; c_in = 0; # 10;
    a_in = 1; b_in = 0; c_in = 1; # 10;             // as above
    a_in = 1; b_in = 1; c_in = 0; # 10;
    a_in = 1; b_in = 1; c_in = 1; # 10;

    $finish;                              // end the simulation
end

initial
    $monitor("At time %2t, a_in = %d b_in = %d c_in = %d s_out = %d c_out = %d",
             $time, a_in, b_in, c_in, s_out, c_out);
endmodule // sc2_test
