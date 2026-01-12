// Map $_DLATCH_P_ → sg13g2_dlhq_1
module \$_DLATCH_P_ (D, E, Q);
    input E, D;
    output Q;
//    wire [1023:0] _TECHMAP_DO_ = "simplemap";

    sg13g2_dlhq_1 _TECHMAP_REPLACE_ (
        .D    (D),
        .GATE (E),
        .Q    (Q)
    );
endmodule

// Map $_DLATCH_N_ → sg13g2_dllr_1  (enable active LOW)
module \$_DLATCH_N_ (D, E, Q);
//    wire [1023:0] _TECHMAP_DO_ = "simplemap; opt";
    input E, D;
    output Q;

    sg13g2_dllr_1 _TECHMAP_REPLACE_ (
        .D      (D),
        .GATE_N (E),
        .RESET_B(1'b1),
        .Q      (Q)
    );
endmodule
