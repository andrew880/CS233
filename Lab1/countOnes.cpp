/**
 * @file
 * Contains an implementation of the countOnes function.
 */

unsigned countOnes(unsigned input) {
	// TODO: write your code here
	input = (input & 0x55555555) + ((input & 0xAAAAAAAA) >> 1);
	input = (input & 0x33333333) + ((input & 0xCCCCCCCC) >> 2);
	input = (input & 0x0f0f0f0f) + ((input & 0xf0f0f0f0) >> 4);
	input = (input & 0x00ff00ff) + ((input & 0xff00ff00) >> 8);
	input = (input & 0x0000ffff) + ((input & 0xffff0000) >> 16);

	return input;
}
