// Copyright 2025 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Xiaoling Yi <xiaoling.yi@kuleuven.be>

package snax_acc.versacore

import chisel3._
import chisel3.util._

// data io
class SpatialArrayDataIO(params: SpatialArrayParam) extends Bundle {
  val in_a            = Flipped(DecoupledIO(UInt(params.arrayInputAWidth.W)))
  val in_b            = Flipped(DecoupledIO(UInt(params.arrayInputBWidth.W)))
  val in_c            = Flipped(DecoupledIO(UInt(params.arrayInputCWidth.W)))
  val out_d           = DecoupledIO(UInt(params.arrayOutputDWidth.W))
  val in_substraction = Flipped(DecoupledIO(UInt(params.configWidth.W)))
}

// control io
class SpatialArrayCtrlIO(params: SpatialArrayParam) extends Bundle {
  val arrayShapeCfg = Input(UInt(params.configWidth.W))
  val dataTypeCfg   = Input(UInt(params.configWidth.W))
  val accAddExtIn   = Input(Bool())
  val accClear      = Input(Bool())
}

class SpatialArrayIO(params: SpatialArrayParam) extends Bundle {
  val data = new SpatialArrayDataIO(params)
  val ctrl = new SpatialArrayCtrlIO(params)
}

/** SpatialArray is a module that implements a spatial array for parallel computation.
  *
  * @param params
  */
class SpatialArray(params: SpatialArrayParam) extends Module with RequireAsyncReset {

  // io instantiation
  val io = IO(new SpatialArrayIO(params))

  // constraints, regardless of the computation bound or bandwidth bound array
  params.arrayDim.zipWithIndex.foreach { case (dims, dataTypeIdx) =>
    dims.foreach { dim =>
      {
        require(dim.length == 3)
        // mac number should be enough to support the computation bound
        require(dim(0) * dim(1) * dim(2) <= params.macNum(dataTypeIdx))
        // arrayInputAWidth should be enough to support the bandwidth bound
        require(
          params.arrayInputAWidth        >= dim(0) * dim(1) * params.inputAElemWidth(dataTypeIdx)
        )
        // arrayInputBWidth should be enough to support the bandwidth bound
        require(
          params.arrayInputBWidth        >= dim(1) * dim(2) * params.inputBElemWidth(dataTypeIdx)
        )
        // arrayInputCWidth should be enough to support the bandwidth bound
        require(
          params.arrayInputCWidth        >= dim(0) * dim(2) * params.inputCElemWidth(dataTypeIdx)
        )
        // arrayOutputDWidth should be enough to support the bandwidth bound
        require(params.arrayOutputDWidth >= dim(0) * dim(2) * params.outputDElemWidth(dataTypeIdx))

        // adder tree should be power of 2
        require(isPow2(dim(1)))

      }
    }
  }

  // constraints for the number of spatial array dimensions
  require(
    params.arrayDim.map(_.length).sum < 32 && params.arrayDim
      .map(_.length)
      .sum                                 >= 1
  )

  require(
    params.opType.length == params.macNum.length             &&
      params.inputAElemWidth.length == params.macNum.length  &&
      params.inputBElemWidth.length == params.macNum.length  &&
      params.inputCElemWidth.length == params.macNum.length  &&
      params.mulElemWidth.length == params.macNum.length     &&
      params.outputDElemWidth.length == params.macNum.length &&
      params.arrayDim.length == params.macNum.length,
    "All data type related parameters should have the same length"
  )

  // N-D data feeding network, spatial loop bounds are specified by `dims` and data reuse strides by `strides`, idx 0 is the outermost dimension
  // e.g., for 3D data, dims = Seq(Mu, Nu, Ku) and strides = Seq(stride_Ku, stride_Nu, stride_Mu)
  def dataForwardN(
    macNum:   Int,
    elemBits: Int,
    dims:     Seq[Int],
    strides:  Seq[Int],
    input:    UInt
  ): Vec[UInt] = {
    require(dims.length == strides.length)
    dims.length

    val reshapedData = Wire(Vec(macNum, UInt(elemBits.W)))

    for (i <- 0 until macNum) {
      // Compute multi-dimensional index: idx = [d0, d1, ..., dn]
      def computeMultiIndex(flatIdx: Int, dims: Seq[Int]): Seq[Int] = {
        var remainder = flatIdx
        dims.reverse.map { dim =>
          val idx = remainder % dim
          remainder = remainder / dim
          idx
        }.reverse
      }

      if (i < dims.product) {
        val indices = computeMultiIndex(i, dims) // e.g., [m, n, k]

        // Calculate 1D input index using strides
        val indexExpr = indices
          .zip(strides)
          .map { case (idx, stride) =>
            idx * stride
          }
          .reduce(_ + _) // index = Σ (idx_i * stride_i)

        reshapedData(i) := input(indexExpr * elemBits + elemBits - 1, indexExpr * elemBits)
      } else {
        reshapedData(i) := 0.U
      }
    }

    reshapedData
  }

  val inputA = params.arrayDim.zipWithIndex.map { case (dims, dataTypeIdx) =>
    dims.map(dim => {
      dataForwardN(
        params.macNum(dataTypeIdx),
        params.inputAElemWidth(dataTypeIdx),
        // Mu, Nu, Ku
        Seq(dim(0), dim(2), dim(1)),
        // stride_Mu, stride_Nu, stride_Ku
        Seq(dim(1), 0, 1),
        io.data.in_a.bits
      )
    })
  }

  val inputB = params.arrayDim.zipWithIndex.map { case (dims, dataTypeIdx) =>
    dims.map(dim => {
      dataForwardN(
        params.macNum(dataTypeIdx),
        params.inputBElemWidth(dataTypeIdx),
        // Mu, Nu, Ku
        Seq(dim(0), dim(2), dim(1)),
        // stride_Mu, stride_Nu, stride_Ku
        Seq(0, dim(1), 1),
        io.data.in_b.bits
      )
    })
  }

  val inputC = params.arrayDim.zipWithIndex.map { case (dims, dataTypeIdx) =>
    dims.map(dim => {
      dataForwardN(
        params.macNum(dataTypeIdx),
        params.inputCElemWidth(dataTypeIdx),
        // Mu, Nu, 1
        Seq(dim(0), dim(2), 1),
        // stride_Mu, stride_Nu, stride_Ku
        Seq(dim(2), 1, 0),
        io.data.in_c.bits
      )
    })
  }

  // instantiate a bunch of multipliers with different data type
  val multipliers = (0 until params.opType.length).map(dataTypeIdx =>
    Seq.fill(params.macNum(dataTypeIdx))(
      Module(
        new Multiplier(
          params.opType(dataTypeIdx),
          params.inputAElemWidth(dataTypeIdx),
          params.inputBElemWidth(dataTypeIdx),
          params.mulElemWidth(dataTypeIdx)
        )
      )
    )
  )

  // multipliers connection with the output from data feeding network
  (0 until params.opType.length).foreach(dataTypeIdx =>
    multipliers(dataTypeIdx).zipWithIndex.foreach { case (mul, mulIdx) =>
      mul.io.in_a := MuxLookup(
        io.ctrl.arrayShapeCfg,
        inputA(dataTypeIdx)(0)(mulIdx)
      )(
        (0 until params.arrayDim(dataTypeIdx).length).map(j => j.U -> inputA(dataTypeIdx)(j)(mulIdx))
      )
      mul.io.in_b := MuxLookup(
        io.ctrl.arrayShapeCfg,
        inputB(dataTypeIdx)(0)(mulIdx)
      )(
        (0 until params.arrayDim(dataTypeIdx).length).map(j => j.U -> inputB(dataTypeIdx)(j)(mulIdx))
      )
    }
  )

  // instantiate adder tree
  val adderTree = (0 until params.opType.length).map(dataTypeIdx =>
    Module(
      new AdderTree(
        params.opType(dataTypeIdx),
        params.mulElemWidth(dataTypeIdx),
        params.outputDElemWidth(dataTypeIdx),
        params.macNum(dataTypeIdx),
        // adderGroupSizes = params.arrayDim(dataTypeIdx).map(_(1)), which describes the spatial reduction dimension
        params.arrayDim(dataTypeIdx).map(_(1))
      )
    )
  )

  // connect output of the multipliers to adder tree
  multipliers.zipWithIndex.foreach { case (muls, dataTypeIdx) =>
    muls.zipWithIndex.foreach { case (mul, mulIdx) =>
      adderTree(dataTypeIdx).io.in(mulIdx) := mul.io.out_c
    }
  }

  // adder tree runtime configuration
  adderTree.foreach(_.io.cfg := io.ctrl.arrayShapeCfg)

  // instantiate accumulators
  val accumulators = (0 until params.opType.length).map(dataTypeIdx =>
    Module(
      new Accumulator(
        params.opType(dataTypeIdx),
        params.outputDElemWidth(dataTypeIdx),
        params.outputDElemWidth(dataTypeIdx),
        params.macNum(dataTypeIdx)
      )
    )
  )

  // connect adder tree output to accumulators
  // and inputC to accumulators
  accumulators.zipWithIndex.foreach { case (acc, dataTypeIdx) =>
    acc.io.in1.bits := adderTree(dataTypeIdx).io.out
    acc.io.in2.bits := MuxLookup(
      io.ctrl.arrayShapeCfg,
      inputC(dataTypeIdx)(0)
    )(
      (0 until params.arrayDim(dataTypeIdx).length).map(j => j.U -> inputC(dataTypeIdx)(j))
    )
  }

  // handle the control signals for accumulators
  accumulators.foreach(_.io.in1.valid := io.data.in_a.valid && io.data.in_b.valid)
  accumulators.foreach(_.io.in2.valid := io.data.in_c.valid)
  accumulators.foreach(_.io.accAddExtIn := io.ctrl.accAddExtIn)
  accumulators.foreach(_.io.accClear := io.ctrl.accClear)
  accumulators.foreach(_.io.out.ready := io.data.out_d.ready)
  (0 until params.opType.length).foreach { dataTypeIdx =>
    accumulators(dataTypeIdx).io.enable := io.ctrl.dataTypeCfg === dataTypeIdx.U
  }

  // input fire signals
  val acc_in1_fire = MuxLookup(
    io.ctrl.dataTypeCfg,
    accumulators(0).io.in1.fire
  )(
    (0 until params.arrayDim.length).map(dataTypeIdx => dataTypeIdx.U -> accumulators(dataTypeIdx).io.in1.fire)
  )
  val acc_in2_fire = MuxLookup(
    io.ctrl.dataTypeCfg,
    accumulators(0).io.in2.fire
  )(
    (0 until params.arrayDim.length).map(dataTypeIdx => dataTypeIdx.U -> accumulators(dataTypeIdx).io.in2.fire)
  )
  io.data.in_a.ready := Mux(io.ctrl.accAddExtIn, acc_in1_fire && acc_in2_fire, acc_in1_fire)
  io.data.in_b.ready := Mux(io.ctrl.accAddExtIn, acc_in1_fire && acc_in2_fire, acc_in1_fire)
  io.data.in_c.ready := Mux(io.ctrl.accAddExtIn, acc_in1_fire && acc_in2_fire, false.B)

  io.data.in_substraction.ready := io.data.in_a.ready && io.data.in_b.ready

  // output data and valid signals
  io.data.out_d.bits := MuxLookup(
    io.ctrl.dataTypeCfg,
    accumulators(0).io.out.asUInt
  )(
    (0 until params.arrayDim.length).map(dataTypeIdx => dataTypeIdx.U -> accumulators(dataTypeIdx).io.out.bits.asUInt)
  )

  io.data.out_d.valid := MuxLookup(
    io.ctrl.dataTypeCfg,
    accumulators(0).io.out.valid
  )(
    (0 until params.arrayDim.length).map(dataTypeIdx => dataTypeIdx.U -> accumulators(dataTypeIdx).io.out.valid)
  )
}

object SpatialArrayEmitter extends App {
  emitVerilog(
    new SpatialArray(SpatialArrayParam()),
    Array("--target-dir", "generated/versacore")
  )

  val params = SpatialArrayParam(
    opType                 = Seq(UIntUIntOp),
    macNum                 = Seq(1024),
    inputAElemWidth        = Seq(8),
    inputBElemWidth        = Seq(8),
    inputCElemWidth        = Seq(8),
    mulElemWidth           = Seq(16),
    outputDElemWidth       = Seq(32),
    arrayInputAWidth       = 1024,
    arrayInputBWidth       = 8192,
    arrayInputCWidth       = 4096,
    arrayOutputDWidth      = 4096,
    serialInputADataWidth  = 1024,
    serialInputBDataWidth  = 8192,
    serialInputCDataWidth  = 512,
    serialOutputDDataWidth = 512,
    // Mu, Ku, Nu
    arrayDim               = Seq(Seq(Seq(16, 8, 8), Seq(1, 32, 32)))
  )
  emitVerilog(
    new SpatialArray(params),
    Array("--target-dir", "generated/versacore")
  )

}
