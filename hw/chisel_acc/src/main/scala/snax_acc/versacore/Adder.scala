// Copyright 2025 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Xiaoling Yi <xiaoling.yi@kuleuven.be>
// Modified by: Robin Geens <robin.geens@kuleuven.be>

package snax_acc.versacore

import chisel3._

/** AdderIO defines the input and output interfaces for the Adder module. */
class AdderIO(
  inputTypeA: DataType,
  inputTypeB: DataType,
  inputTypeC: DataType
) extends Bundle {
  val in_a  = Input(UInt(inputTypeA.width.W))
  val in_b  = Input(UInt(inputTypeB.width.W))
  val out_c = Output(UInt(inputTypeC.width.W))
}

/** Adder is a module that performs addition on two inputs based on the specified operation type. */
class Adder(
  opType:     OpType,
  inputTypeA: DataType,
  inputTypeB: DataType,
  inputTypeC: DataType
) extends Module
    with RequireAsyncReset {

  val io = IO(new AdderIO(inputTypeA, inputTypeB, inputTypeC))

  (inputTypeA, inputTypeB, inputTypeC, opType) match {
    case (_: IntType, _: IntType, _: IntType, UIntUIntOp) => io.out_c := io.in_a + io.in_b

    case (_: IntType, _: IntType, _: IntType, SIntSIntOp) =>
      io.out_c := (io.in_a.asTypeOf(SInt(inputTypeC.width.W)) + io.in_b.asTypeOf(
        SInt(inputTypeC.width.W)
      )).asUInt

    case (_: FpType, _: IntType, _: FpType, Float16IntOp) => throw new NotImplementedError()

    case (a: FpType, b: FpType, c: FpType, Float16Float16Op) => {
      val fpAddFp = Module(new FPAddFPBlackBox("fp_add", a, b, c))
      fpAddFp.io.operand_a_i := io.in_a
      fpAddFp.io.operand_b_i := io.in_b
      io.out_c               := fpAddFp.io.result_o
    }

    case (_, _, _, _) => throw new NotImplementedError()

  }

}

// Below are the emitters for different adder configurations for testing and evaluation purposes.
object AdderEmitterUInt extends App {
  emitVerilog(
    new Adder(UIntUIntOp, Int8, Int4, Int16),
    Array("--target-dir", "generated/versacore")
  )
}

object AdderEmitterSInt extends App {
  emitVerilog(
    new Adder(SIntSIntOp, Int8, Int4, Int16),
    Array("--target-dir", "generated/versacore/adder")
  )
}

object AdderEmitterFloat16Float16 extends App {
  emitVerilog(
    new Adder(Float16Float16Op, FP32, FP32, FP32),
    Array("--target-dir", "generated/versacore/adder")
  )
}
