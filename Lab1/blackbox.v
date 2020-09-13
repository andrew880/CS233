module blackbox(o, f, j, v);
    output o;
    input  f, j, v;
    wire   w05, w17, w19, w21, w25, w34, w38, w44, w53, w57, w65, w98;
    or  o31(o, w65, w53, w05);
    and a6(w53, w25, w34);
    not n64(w34, w25);
    and a10(w05, w98, w44);
    not n90(w98, w44);
    or  o27(w44, j, w57, f);
    not n20(w57, v);
    or  o68(w25, w19, w17);
    and a87(w19, w38, j);
    not n26(w38, f);
    and a55(w17, v, j, f);
    and a61(w65, f, w21);
    or  o71(w21, j, v);
endmodule // blackbox