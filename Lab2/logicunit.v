// 00 -> AND, 01 -> OR, 10 -> NOR, 11 -> XOR
module logicunit(out, A, B, control);
    output      out;
    input       A, B;
    input [1:0] control;
    wire w0, w1, AND, OR, NOR, XOR, wA, wO, wN, wX, w2, w3, w4, not_A, not_B, w5;

    not n1(w0, control[0]);
    not n2(w1, control[1]);
    not n3(not_A, A);
    not n4(not_B, B);
    and a0(wA, A, B, w0, w1);
    and a1(OR, control[0], w1);
    or o4(w5, A, B);
    and a2(wO, OR, w5);
    and a3(NOR, w0, control[1]);
    and a4(wN, NOR, not_A, not_B);
    and a5(XOR, control[0], control[1]);
    and a6(w3, A, not_B);
    and a7(w4, B, not_A);
    or o8(w2, w3, w4);
    and a8(wX, w2, XOR);
    or o9(out, wA, wO, wN, wX);
endmodule // logicunit
