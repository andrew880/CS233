/**
 * @file
 * Contains an implementation of the extractMessage function.
 */

#include <iostream> // might be useful for debugging
#include <assert.h>
#include "extractMessage.h"

using namespace std;

char *extractMessage(const char *message_in, int length) {
   // Length must be a multiple of 8
   assert((length % 8) == 0);

   // allocates an array for the output
   char *message_out = new char[length];
   for (int i=0; i<length; i++) {
     message_out[i] = 0;    // Initialize all elements to zero.
   }
   for (int i=0; i<length; i++) {
      message_out[0+(i/8)*8] |= ((message_in[i] & 0b00000001) << (i%8));
      message_out[1+(i/8)*8] |= ((message_in[i] & 0b00000010) >> 1) << i%8;
      message_out[2+(i/8)*8] |= ((message_in[i] & 0b00000100) >> 2) << i%8;
      message_out[3+(i/8)*8] |= ((message_in[i] & 0b00001000) >> 3) << i%8;
      message_out[4+(i/8)*8] |= ((message_in[i] & 0b00010000) >> 4) << i%8;
      message_out[5+(i/8)*8] |= ((message_in[i] & 0b00100000) >> 5) << i%8;
      message_out[6+(i/8)*8] |= ((message_in[i] & 0b01000000) >> 6) << i%8;
      message_out[7+(i/8)*8] |= ((message_in[i] & 0b10000000) >> 7) << i%8;
   }

   // for (int i=0; i<length; i++) {
   //   for (int j=0; j<8; j++) {
   //     message_out[j+(i/8)*8] |= ((message_in[i] & pow(2, j)) >> j) << (i%8);
   //   }
   // }
   // TODO: write your code here
   return message_out;
}
