// Copyright 2025 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Xiaoling Yi <xiaoling.yi@kuleuven.be>

package snax_acc.versacore

import chisel3._
import chisel3.util._

import fp_unit.FP16
import fp_unit.FP32
import fp_unit.FpType

/** @param typeA
  *   Must be FP16
  * @param typeB
  *   Configurable
  * @param typeC
  *   Must be FP32
  */
class FPMULIntBlackBox(topmodule: String, typeA: FpType, typeB: IntType, typeC: FpType)
    extends BlackBox(Map("WIDTH_B" -> typeB.width))
    with HasBlackBoxResource {

  require(typeA == FP16 && typeC == FP32)

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
  addResource("src_fp_mul_int/int2fp.sv")
  addResource("src_fp_mul_int/fp_mul_int.sv")

}

class FPMULInt(topmodule: String, val typeA: FpType, val typeB: IntType, val typeC: FpType)
    extends Module
    with RequireAsyncReset {

  override def desiredName: String = "FPMULInt_" + topmodule

  val io = IO(new Bundle {
    val operand_a_i = Input(UInt(typeA.width.W))
    val operand_b_i = Input(UInt(typeB.width.W))
    val result_o    = Output(UInt(typeC.width.W))
  })

  val sv_module = Module(new FPMULIntBlackBox(topmodule, typeA, typeB, typeC))

  io.result_o              := sv_module.io.result_o
  sv_module.io.operand_a_i := io.operand_a_i
  sv_module.io.operand_b_i := io.operand_b_i

}

object FPMULIntEmitter extends App {
  emitVerilog(
    new FPMULInt(topmodule = "fp_mul_int", typeA = FP16, typeB = Int16, typeC = FP32),
    Array("--target-dir", "generated/versacore")
  )
}
