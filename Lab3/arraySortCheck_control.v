
module arraySortCheck_control(sorted, done, load_input, load_index, select_index, go, inversion_found, end_of_array, clock, reset);
	output sorted, done, load_input, load_index, select_index;
	input go, inversion_found, end_of_array;
	input clock, reset;

	wire sGarbage_next = sGarbage & ~go | reset;
	wire sReadyCheck_next = (sGarbage | sReadyCheck | sChecking | sDoneSort | sDoneNonSort) & go & ~reset;
	wire sChecking_next = (sReadyCheck & ~go) & ~reset;
	wire sDoNothing_next = (sChecking | (sDoNothing & ~inversion_found & ~end_of_array)) & ~reset;
	wire sDoneSort_next = (sDoneSort & ~go | sDoNothing & ~inversion_found & end_of_array) & ~reset;
	wire sDoneNonSort_next = (sDoneNonSort & ~go | sDoNothing & inversion_found) & ~reset;

	dffe dfGarbage(sGarbage, sGarbage_next, clock, 1'b1, 1'b0);
	dffe dfStart(sStart, sStart_next, clock, 1'b1, 1'b0);
	dffe dfDoNothing(sDoNothing, sDoNothing_next, clock, 1'b1, 1'b0);
	dffe dfCheck(sChecking, sChecking_next, clock, 1'b1, 1'b0);
	dffe dfReadyCheck(sReadyCheck, sReadyCheck_next, clock, 1'b1, 1'b0);
	dffe dfDoneSort(sDoneSort, sDoneSort_next, clock, 1'b1, 1'b0);
	dffe dfDoneNonSort(sDoneNonSort, sDoneNonSort_next, clock, 1'b1, 1'b0);

	assign sorted = (sDoneSort & ~inversion_found) & ~reset;
	assign load_input = (sReadyCheck) & ~reset;
	assign load_index = (sReadyCheck || sChecking || sDoNothing) & ~reset;
	assign select_index = (sChecking || sDoNothing) & ~reset;
	assign done = (sDoneSort || sDoneNonSort) & ~reset;

endmodule
