// Copyright 2025 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Floating-Point Adder
// Based on fpnew_fma modified for fp addition
// Author: Man Shi <man.shi@kuleuven.be>
//         Xiaoling Yi <xiaoling.yi@kuleuven.be>

module intN_to_fp16 #(
    parameter INT_WIDTH = 4  // Set to 1, 2, 3, or 4
) (
    input  wire signed [INT_WIDTH-1:0] intN_in,
    output reg         [         15:0] fp16_out
);

  reg sign;
  reg [INT_WIDTH-1:0] abs_val;
  reg [4:0] exponent;
  reg [9:0] mantissa;

  integer i;
  integer msb_pos;

  always @(*) begin
    // Special case: INT_WIDTH = 1
    if (INT_WIDTH == 1) begin
      // input: 1 => +1 → fp16 of +1.0 (0 01111 0000000000)
      // input: 0 => -1 → fp16 of -1.0 (1 01111 0000000000)
      sign     = ~intN_in[0];
      exponent = 5'd15;  // exponent = 0 + bias (15)
      mantissa = 10'd0;
      fp16_out = {sign, exponent, mantissa};
    end else begin
      // General case: signed int to fp16
      sign = intN_in[INT_WIDTH-1];
      abs_val = sign ? -intN_in : intN_in;

      // If input is zero
      if (abs_val == 0) begin
        fp16_out = 16'b0;
      end else begin
        // Find position of MSB
        msb_pos = 0;
        for (i = INT_WIDTH - 1; i >= 0; i = i - 1) begin
          if (abs_val[i] == 1'b1 && msb_pos == 0) msb_pos = i;
        end

        // Compute exponent: bias + msb_pos
        exponent = 5'd15 + msb_pos;

        // Align mantissa bits (remove leading 1)
        mantissa = abs_val << (10 - msb_pos);
        mantissa = mantissa[9:0];  // Drop overflow

        fp16_out = {sign, exponent, mantissa};
      end
    end
  end

endmodule
