module keypad(valid, number, a, b, c, d, e, f, g);
   output 	valid;
   output [3:0] number;
   input 	a, b, c, d, e, f, g;
   wire w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, wp, wn;

   not n1(wn, w12);
   or o5(w12, w1, w2);
   or o6(wp,w0,w3,w4,w5,w6,w7,w8,w9,w10,w11);
   and a13(valid, wp, wn);
   and a1(w0, b, g);
   and a2(w1, a, g);
   and a3(w2, c, g);
   and a4(w3, a, d);
   and a5(w4, b, d);
   and a6(w5, c, d);
   and a7(w6, a, e);
   and a8(w7, b, e);
   and a9(w8, c, e);
   and a10(w9, a, f);
   and a11(w10, b, f);
   and a12(w11, c, f);
   or o1(number[3], w10, w11);
   or o2(number[2], w6, w7, w8, w9);
   or o3(number[1], w4, w5, w8, w9);
   or o4(number[0], w3, w5, w7, w9, w11);
   //number = 4'h1;

endmodule // keypad
/*
 1 2 3 d
 4 5 6 e
 7 8 9 f
   0   g
 a b c

0001 1 0 0 1 0 0 0 ad
0010 0 1 0 1 0 0 0 bd
0011 0 0 1 1 0 0 0 cd
0100 1 0 0 0 1 0 0 ae
0101 0 1 0 0 1 0 0 be
0110 0 0 1 0 1 0 0 ce
0111 1 0 0 0 0 1 0 af
1000 0 1 0 0 0 1 0 bf <- number[3] is 1
1001 0 0 1 0 0 1 0 cf <- number[3] is 1, so when bf +cf -> number[3] should be 1
0000 0 1 0 0 0 0 1 bg
*/
