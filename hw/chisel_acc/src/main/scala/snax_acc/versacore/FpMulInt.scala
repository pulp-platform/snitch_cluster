// Copyright 2025 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Xiaoling Yi <xiaoling.yi@kuleuven.be>

package snax_acc.versacore

import chisel3._
import chisel3.util._

class FPMULIntBlackBox(
  topmodule: String,
  widthA:    Int,
  widthB:    Int,
  widthC:    Int
) extends BlackBox(
      // only works for FP16 for a, FP32 for result
      // data width of b is configurable
      Map("WIDTH_B" -> widthB)
    )
    with HasBlackBoxResource {

  val io = IO(new Bundle {
    val operand_a_i = Input(UInt(widthA.W))
    val operand_b_i = Input(UInt(widthB.W))
    val result_o    = Output(UInt(widthC.W))
  })
  override def desiredName: String = topmodule

  addResource("common_block/fpnew_pkg.sv")
  addResource("common_block/fpnew_classifier.sv")
  addResource("common_block/fpnew_rounding.sv")
  addResource("common_block/lzc.sv")
  addResource("src_fp_mul_int/int2fp.sv")
  addResource("src_fp_mul_int/fp_mul_int.sv")

}

class FPMULInt(
  topmodule:  String,
  val widthA: Int,
  val widthB: Int,
  val widthC: Int
) extends Module
    with RequireAsyncReset {

  override def desiredName: String = "FPMULInt_" + topmodule

  val io = IO(new Bundle {
    val operand_a_i = Input(UInt(widthA.W))
    val operand_b_i = Input(UInt(widthB.W))
    val result_o    = Output(UInt(widthC.W))
  })

  val sv_module = Module(
    new FPMULIntBlackBox(topmodule, widthA, widthB, widthC)
  )

  io.result_o              := sv_module.io.result_o
  sv_module.io.operand_a_i := io.operand_a_i
  sv_module.io.operand_b_i := io.operand_b_i

}

object FPMULIntEmitter extends App {
  emitVerilog(
    new FPMULInt(
      topmodule = "fp_mul_int",
      widthA    = 16,
      widthB    = 16,
      widthC    = 32
    ),
    Array("--target-dir", "generated/versacore")
  )
}
