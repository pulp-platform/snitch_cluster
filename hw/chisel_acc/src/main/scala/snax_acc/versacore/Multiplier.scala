// Copyright 2025 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Xiaoling Yi <xiaoling.yi@kuleuven.be>
// Modified by: Robin Geens <robin.geens@kuleuven.be>

package snax_acc.versacore

import chisel3._

class MultiplierIO(inputTypeA: DataType, inputTypeB: DataType, inputTypeC: DataType) extends Bundle {
  val in_a  = Input(UInt(inputTypeA.width.W))
  val in_b  = Input(UInt(inputTypeB.width.W))
  val out_c = Output(UInt(inputTypeC.width.W))
}

/** Multiplier module that supports different operation types */
class Multiplier(opType: OpType, inputTypeA: DataType, inputTypeB: DataType, inputTypeC: DataType)
    extends Module
    with RequireAsyncReset {

  val io = IO(new MultiplierIO(inputTypeA, inputTypeB, inputTypeC))

  (inputTypeA, inputTypeB, inputTypeC, opType) match {
    case (_: IntType, _: IntType, _: IntType, UIntUIntOp) => io.out_c := io.in_a * io.in_b

    case (_: IntType, _: IntType, _: IntType, SIntSIntOp) =>
      io.out_c := (io.in_a.asTypeOf(SInt(inputTypeC.width.W)) * io.in_b.asTypeOf(
        SInt(inputTypeC.width.W)
      )).asUInt

    case (a: FpType, b: IntType, c: FpType, Float16IntOp) => {
      val fpMulInt = Module(new FPMULIntBlackBox("fp_mul_int", a, b, c))
      fpMulInt.io.operand_a_i := io.in_a
      fpMulInt.io.operand_b_i := io.in_b
      io.out_c                := fpMulInt.io.result_o
    }

    case (a: FpType, b: FpType, c: FpType, Float16Float16Op) => {
      val fpMulfp = Module(new FPMULFP("fp_mul", a, b, c))
      fpMulfp.io.operand_a_i := io.in_a
      fpMulfp.io.operand_b_i := io.in_b
      io.out_c               := fpMulfp.io.result_o
    }

    case (_, _, _, _) => throw new NotImplementedError()

  }

}

object MultiplierEmitterUInt extends App {
  emitVerilog(
    new Multiplier(UIntUIntOp, Int8, Int4, Int16),
    Array("--target-dir", "generated/versacore")
  )
}

object MultiplierEmitterSInt extends App {
  emitVerilog(
    new Multiplier(SIntSIntOp, Int8, Int4, Int16),
    Array("--target-dir", "generated/versacore")
  )
}

object MultiplierEmitterFloat16Int4 extends App {
  emitVerilog(
    new Multiplier(Float16IntOp, FP16, Int4, FP32),
    Array("--target-dir", "generated/versacore")
  )
}

object MultiplierEmitterFloat16Float16 extends App {
  emitVerilog(
    new Multiplier(Float16Float16Op, FP16, FP16, FP32),
    Array("--target-dir", "generated/versacore")
  )
}
