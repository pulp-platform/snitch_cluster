// Copyright 2025 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Xiaoling Yi <xiaoling.yi@kuleuven.be>
// Modified by: Robin Geens <robin.geens@kuleuven.be>

package snax_acc.versacore

import chisel3._
import chisel3.experimental.RawParam
import chisel3.util._

class FPAddFPBlackBox(topmodule: String, typeA: FpType, typeB: FpType, typeC: FpType)
    extends BlackBox(
      Map(
        "FpFormat_a"   -> RawParam(typeA.fpnewFormatEnum),
        "FpFormat_b"   -> RawParam(typeB.fpnewFormatEnum),
        "FpFormat_out" -> RawParam(typeC.fpnewFormatEnum)
      )
    )
    with HasBlackBoxResource {

  val io = IO(new Bundle {
    val operand_a_i = Input(UInt(typeA.width.W))
    val operand_b_i = Input(UInt(typeB.width.W))
    val result_o    = Output(UInt(typeC.width.W))
  })
  override def desiredName: String = topmodule

  addResource("common_block/fpnew_pkg_snax.sv")
  addResource("common_block/fpnew_classifier.sv")
  addResource("common_block/fpnew_rounding.sv")
  addResource("common_block/lzc.sv")
  addResource("src_fp_add/fp_add.sv")

}

class FPAddFP(topmodule: String, val typeA: FpType, val typeB: FpType, val typeC: FpType)
    extends Module
    with RequireAsyncReset {

  val io = IO(new Bundle {
    val operand_a_i = Input(UInt(typeA.width.W))
    val operand_b_i = Input(UInt(typeB.width.W))
    val result_o    = Output(UInt(typeC.width.W))
  })

  val sv_module = Module(new FPAddFPBlackBox(topmodule, typeA, typeB, typeC))

  io.result_o              := sv_module.io.result_o
  sv_module.io.operand_a_i := io.operand_a_i
  sv_module.io.operand_b_i := io.operand_b_i

}

object FPAddFPEmitter extends App {
  emitVerilog(
    new FPAddFP(topmodule = "fp_add", typeA = FP16, typeB = FP16, typeC = FP32),
    Array("--target-dir", "generated/versacore")
  )
}
