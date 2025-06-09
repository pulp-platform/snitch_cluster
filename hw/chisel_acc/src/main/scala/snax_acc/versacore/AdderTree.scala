// Copyright 2025 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Xiaoling Yi <xiaoling.yi@kuleuven.be>
// Modified by: Robin Geens <robin.geens@kuleuven.be>

package snax_acc.versacore

import chisel3._
import chisel3.util._

/** AdderTree is a module that implements a tree of adders for efficient parallel addition. It takes multiple input
  * vectors and produces a single output vector.
  * @param opType
  *   The type of operation to perform (e.g., UInt, SInt, Float16).
  * @param numElements
  *   The number of elements in the input vector.
  * @param groupSizes
  *   A sequence of group sizes for the adder tree.
  */
class AdderTree(
  val opType:      OpType,
  val inputType:   DataType,
  val outputTpe:   DataType,
  val numElements: Int,
  val groupSizes:  Seq[Int]
) extends Module
    with RequireAsyncReset {
  require(isPow2(numElements), "numElements must be a power of 2")

  val io = IO(new Bundle {
    val in  = Input(Vec(numElements, UInt(inputType.width.W)))
    val out = Output(Vec(numElements, UInt(outputTpe.width.W)))
    val cfg = Input(UInt(log2Ceil(groupSizes.length + 1).W))
  })

  // Ensure valid size
  groupSizes.foreach(size => require(isPow2(size), "groupSizes must be a power of 2"))
  require(
    groupSizes.length < 32 && groupSizes.length >= 1,
    "groupSizes number must be less than 32 and greater than 0"
  )

  // adder tree initialization
  val maxGroupSize = groupSizes.max
  val treeDepth    = log2Ceil(maxGroupSize)

  val layers = Wire(
    Vec(treeDepth + 1, Vec(numElements, UInt(outputTpe.width.W)))
  )

  // Initialize the output type based on the operation type
  // For SIntSIntOp, we need to use SInt for the output
  // For UIntUIntOp, we can use UInt for the output
  // Other types will be handled in the black box adder module as we use UInt for inputs and outputs
  val outputType = if (opType == SIntSIntOp) {
    SInt(outputTpe.width.W)
  } else {
    UInt(outputTpe.width.W)
  }

  // Initialize all layers to zero
  layers.map(_.map(_ := 0.U.asTypeOf(UInt(outputTpe.width.W))))
  // Initialize the first layer with input values
  layers(0) := VecInit(
    io.in.map(_.asTypeOf(outputType).asTypeOf(UInt(outputTpe.width.W)))
  )

  // Generate adder tree layers
  for (d <- 0 until treeDepth) {
    val step = 1
    for (i <- 0 until numElements by (2 * step)) {
      // Create adders for the current layer
      val adder = Module(
        new Adder(opType, outputTpe, outputTpe, outputTpe)
      )
      // Connect the inputs of the adder
      // The adder takes two inputs from the current layer
      // and produces one output for the next layer
      adder.io.in_a        := layers(d)(i)
      adder.io.in_b        := layers(d)(i + step)
      layers(d + 1)(i / 2) := adder.io.out_c
    }
  }

  // Generate multiple adder tree outputs based on groupSizes
  val adderResults = groupSizes.map(size => layers(log2Ceil(size)))

  // Mux output based on cfg to select the appropriate adder result
  // for dynamic spatial reduction
  io.out := MuxLookup(io.cfg, adderResults(0))(
    (0 until groupSizes.length).map(i => (i).U -> adderResults(i))
  )
}

object AdderTreeEmitterUInt extends App {
  emitVerilog(
    new AdderTree(UIntUIntOp, Int8, new IntType(9), 8, Seq(1, 2, 4)),
    Array("--target-dir", "generated/versacore")
  )
}

object AdderTreeEmitterSInt extends App {
  emitVerilog(
    new AdderTree(SIntSIntOp, Int16, Int32, 1024, Seq(1, 2, 8)),
    Array("--target-dir", "generated/versacore")
  )
}
