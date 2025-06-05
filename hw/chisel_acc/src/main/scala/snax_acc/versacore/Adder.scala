// Copyright 2025 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Xiaoling Yi <xiaoling.yi@kuleuven.be>

package snax_acc.versacore

import chisel3._

/** AdderIO defines the input and output interfaces for the Adder module. */
class AdderIO(
  inputAElemWidth:  Int,
  inputBElemWidth:  Int,
  outputCElemWidth: Int
) extends Bundle {
  val in_a  = Input(UInt(inputAElemWidth.W))
  val in_b  = Input(UInt(inputBElemWidth.W))
  val out_c = Output(UInt(outputCElemWidth.W))
}

/** Adder is a module that performs addition on two inputs based on the specified operation type. */
class Adder(
  opType:           OpType,
  inputAElemWidth:  Int,
  inputBElemWidth:  Int,
  outputCElemWidth: Int
) extends Module
    with RequireAsyncReset {

  val io = IO(new AdderIO(inputAElemWidth, inputBElemWidth, outputCElemWidth))
  require(
    opType == UIntUIntOp || opType == SIntSIntOp ||
      opType == Float16IntOp || opType == Float16Float16Op,
    "Unsupported operation type for Adder"
  )
  require(
    inputAElemWidth > 0 && inputBElemWidth > 0 && outputCElemWidth > 0,
    "Element widths must be greater than 0"
  )

  // instantiating the adder based on the operation type
  if (opType == UIntUIntOp) {
    io.out_c := io.in_a + io.in_b
  } else if (opType == SIntSIntOp) {
    io.out_c := (io.in_a.asTypeOf(SInt(outputCElemWidth.W)) + io.in_b.asTypeOf(
      SInt(outputCElemWidth.W)
    )).asUInt
  } else if (opType == Float16IntOp || opType == Float16Float16Op) {
    // For Float16IntOp and Float16Float16Op, we use a black box for floating-point addition
    // Now only support fp32+fp32=fp32, as the system verilog module's parameter is fixed
    val fpAddfp = Module(
      new FPAddFPBlackBox("fp_add", inputAElemWidth, inputBElemWidth, outputCElemWidth)
    )
    fpAddfp.io.operand_a_i  := io.in_a
    fpAddfp.io.operand_b_i  := io.in_b
    io.out_c                := fpAddfp.io.result_o
    assert(
      inputAElemWidth == 32 && inputBElemWidth == 32 && outputCElemWidth == 32,
      "For Float16IntOp or Float16Float16Op, input widths must be 32, 32 and output width must be 32 for the adder module"
    )

  } else {
    // TODO: add support for other types
    // For now, just set the output to 0
    io.out_c := 0.U
  }
}

// Below are the emitters for different adder configurations for testing and evaluation purposes.
object AdderEmitterUInt extends App {
  emitVerilog(
    new Adder(UIntUIntOp, 8, 4, 16),
    Array("--target-dir", "generated/versacore")
  )
}

object AdderEmitterSInt extends App {
  emitVerilog(
    new Adder(SIntSIntOp, 8, 4, 16),
    Array("--target-dir", "generated/versacore/adder")
  )
}

object AdderEmitterFloat16Float16 extends App {
  emitVerilog(
    new Adder(Float16Float16Op, 32, 32, 32),
    Array("--target-dir", "generated/versacore/adder")
  )
}

object AdderEmitters {
  def emitInt4_Int4_Int8():  Unit = {
    val tag = "int4_int4_int8"
    emitVerilog(
      new Adder(SIntSIntOp, 4, 4, 8),
      Array("--target-dir", s"/generated/versacore/adder/$tag")
    )
  }
  def emitInt8_Int8_Int16(): Unit = {
    val tag = "int8_int8_int16"
    emitVerilog(
      new Adder(SIntSIntOp, 8, 8, 16),
      Array("--target-dir", s"/generated/versacore/adder/$tag")
    )
  }

  def emitInt16_Int16_Int32(): Unit = {
    val tag = "int16_int16_int32"
    emitVerilog(
      new Adder(SIntSIntOp, 16, 16, 32),
      Array("--target-dir", s"generated/versacore/adder/$tag")
    )
  }

  def emitInt32_Int32_Int64(): Unit = {
    val tag = "int32_int32_int64"
    emitVerilog(
      new Adder(SIntSIntOp, 32, 32, 64),
      Array("--target-dir", s"generated/versacore/adder/$tag")
    )
  }

  def emitFloat32_Float32_Float32(): Unit = {
    val tag = "float32_float32_float32"
    emitVerilog(
      new Adder(Float16Float16Op, 32, 32, 32),
      Array("--target-dir", s"generated/versacore/adder/$tag")
    )
  }
}

object RunAllAdderEmitters extends App {
  import AdderEmitters._

  emitInt4_Int4_Int8()
  emitInt8_Int8_Int16()
  emitInt16_Int16_Int32()
  emitInt32_Int32_Int64()
  emitFloat32_Float32_Float32()

}
