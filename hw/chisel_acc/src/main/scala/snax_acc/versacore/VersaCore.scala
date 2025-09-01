// Copyright 2025 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Xiaoling Yi <xiaoling.yi@kuleuven.be>
// arrayTop with the fsm controller and the spatial array

package snax_acc.versacore

import chisel3._
import chisel3.util._

import fp_unit._
import snax_acc.utils._

/** VersaCoreCfg is a configuration bundle for the VersaCore module. */
class VersaCoreCfg(params: SpatialArrayParam) extends Bundle {
  val fsmCfg = new Bundle {
    val K_i                    = UInt(params.configWidth.W)
    val N_i                    = UInt(params.configWidth.W)
    val M_i                    = UInt(params.configWidth.W)
    val subtraction_constant_i = UInt(params.configWidth.W)
  }

  val arrayCfg = new Bundle {
    val arrayShapeCfg = UInt(params.configWidth.W)
    val dataTypeCfg   = UInt(params.configWidth.W)
  }
}

/** VersaCoreIO defines the input and output interfaces for the VersaCore module. */
class VersaCoreIO(params: SpatialArrayParam) extends Bundle {
  // data interface
  val data = new Bundle {
    val in_a  = Flipped(DecoupledIO(UInt(params.arrayInputAWidth.W)))
    val in_b  = Flipped(DecoupledIO(UInt(params.arrayInputBWidth.W)))
    val in_c  = Flipped(DecoupledIO(UInt(params.serialInputCDataWidth.W)))
    val out_d = DecoupledIO(UInt(params.serialOutputDDataWidth.W))
  }

  // control interface
  val ctrl = Flipped(DecoupledIO(new VersaCoreCfg(params)))

  // profiling and status signals
  val busy_o              = Output(Bool())
  val performance_counter = Output(UInt(params.configWidth.W))
}

/** VersaCore is the top-level module for VersaCore. */
class VersaCore(params: SpatialArrayParam) extends Module with RequireAsyncReset {

  val io = IO(new VersaCoreIO(params))

  if (params.dataflow.length > 1) {
    require(
      params.arrayInputAWidth == params.serialInputADataWidth && params.arrayInputBWidth == params.serialInputBDataWidth && params.arrayInputCWidth == params.serialInputCDataWidth &&
        params.arrayOutputDWidth == params.serialOutputDDataWidth,
      "For multi-dataflow, the array input/output widths must match the serial input/output data widths."
    )
  }

  // -----------------------------------
  // state machine starts
  // -----------------------------------

  // State declaration
  val sIDLE :: sBUSY :: Nil = Enum(2)
  val cstate                = RegInit(sIDLE)
  val nstate                = WireInit(sIDLE)

  // signals for state transition
  val config_valid       = WireInit(0.B)
  val computation_finish = WireInit(0.B)

  val zeroLoopBoundCase =
    io.ctrl.bits.fsmCfg.M_i === 0.U || io.ctrl.bits.fsmCfg.K_i === 0.U || io.ctrl.bits.fsmCfg.K_i === 0.U

  // Changing states
  cstate := nstate

  chisel3.dontTouch(cstate)
  switch(cstate) {
    is(sIDLE) {
      when(config_valid) {
        nstate := sBUSY
      }.otherwise {
        nstate := sIDLE
      }
    }
    is(sBUSY) {
      when(computation_finish) {
        nstate := sIDLE
      }.otherwise {
        nstate := sBUSY
      }
    }
  }

  config_valid  := io.ctrl.fire && !zeroLoopBoundCase && cstate === sIDLE
  io.ctrl.ready := cstate === sIDLE

  val csrReg = RegInit(0.U.asTypeOf(new VersaCoreCfg(params)))

  // Store the configurations when config valid
  when(config_valid) {
    when(!zeroLoopBoundCase) {
      csrReg.fsmCfg.M_i := io.ctrl.bits.fsmCfg.M_i
      csrReg.fsmCfg.N_i := io.ctrl.bits.fsmCfg.N_i
      csrReg.fsmCfg.K_i := io.ctrl.bits.fsmCfg.K_i
    }.otherwise {
      assert(
        io.ctrl.bits.fsmCfg.M_i =/= 0.U || io.ctrl.bits.fsmCfg.K_i =/= 0.U || io.ctrl.bits.fsmCfg.K_i =/= 0.U,
        " M == 0 or K ==0 or N == 0, invalid configuration!"
      )
    }
    csrReg.fsmCfg.subtraction_constant_i := io.ctrl.bits.fsmCfg.subtraction_constant_i
    csrReg.arrayCfg.arrayShapeCfg        := io.ctrl.bits.arrayCfg.arrayShapeCfg
    csrReg.arrayCfg.dataTypeCfg          := io.ctrl.bits.arrayCfg.dataTypeCfg
  }

  // counter for output data count
  val dOutputCounter = Module(new BasicCounter(params.configWidth, nameTag = "dOutputCounter"))

  val dimRom = VecInit(params.arrayDim.map { twoD =>
    VecInit(twoD.map { oneD =>
      VecInit(oneD.map(_.U(params.configWidth.W)))
    })
  })

  def realCDBandWidth(
    dataTypeIdx:  UInt,
    dimIdx:       UInt,
    elemWidthSeq: Vec[UInt]
  ) = {
    val dim = dimRom(dataTypeIdx)(dimIdx)
    dim(0) * dim(2) * elemWidthSeq(dataTypeIdx)
  }

  // Calculate the run-time output serial factor based on the configuration
  // (how many cycles it to output one data)
  val outPutDWidthRom = VecInit(params.outputTypeD.map(_.width.U(params.configWidth.W)))

  val runTimeOutputBandWidthFactor = (realCDBandWidth(
    csrReg.arrayCfg.dataTypeCfg,
    csrReg.arrayCfg.arrayShapeCfg,
    outPutDWidthRom
  ) / params.serialOutputDDataWidth.U)

  val output_d_serial_factor =
    Mux(
      params.arrayOutputDWidth.U <= params.serialOutputDDataWidth.U,
      1.U,
      Mux(
        runTimeOutputBandWidthFactor
          === 0.U,
        1.U,
        runTimeOutputBandWidthFactor
      )
    )

  // all number of cycles that the data needs to be outputted
  dOutputCounter.io.ceil  := csrReg.fsmCfg.M_i * csrReg.fsmCfg.N_i * output_d_serial_factor
  dOutputCounter.io.tick  := io.data.out_d.fire && cstate === sBUSY
  dOutputCounter.io.reset := computation_finish

  // all the data is outputted means the computation is finished
  computation_finish := dOutputCounter.io.lastVal

  // -----------------------------------
  // state machine ends
  // -----------------------------------

  // data serial to parallel converters for input A and B
  // only used with a single input or weight stationary
  // the serial factor also dynamically calculated based on the run-time configuration
  val A_s2p = Module(
    new SerialToParallel(
      SerialToParallelParams(
        parallelWidth  = params.arrayInputAWidth,
        serialWidth    = params.serialInputADataWidth,
        earlyTerminate = true
      )
    )
  )

  val B_s2p = Module(
    new SerialToParallel(
      SerialToParallelParams(
        parallelWidth  = params.arrayInputBWidth,
        serialWidth    = params.serialInputBDataWidth,
        earlyTerminate = true
      )
    )
  )

  // TODO: a single input or weight stationary are not tested, but should be valid
  require(params.serialInputADataWidth == params.arrayInputAWidth)
  require(params.serialInputBDataWidth == params.arrayInputBWidth)

  A_s2p.io.in <> io.data.in_a
  A_s2p.io.enable := cstate === sBUSY

  B_s2p.io.in <> io.data.in_b
  B_s2p.io.enable := cstate === sBUSY

  // dynamically calculate the serial factor for input A and B
  // based on the run-time configuration
  def realABandWidth(
    dataTypeIdx:  UInt,
    dimIdx:       UInt,
    elemWidthSeq: Vec[UInt]
  ) = {
    val dim = dimRom(dataTypeIdx)(dimIdx)
    dim(0) * dim(1) * elemWidthSeq(dataTypeIdx)
  }

  val inputAElemWidthRom = VecInit(params.inputTypeA.map(_.width.U(params.configWidth.W)))

  val runTimeInputABandWidthFactor = (realABandWidth(
    csrReg.arrayCfg.dataTypeCfg,
    csrReg.arrayCfg.arrayShapeCfg,
    inputAElemWidthRom
  ) / params.serialInputADataWidth.U)

  val input_a_serial_factor =
    Mux(
      params.arrayInputAWidth.U <= params.serialInputADataWidth.U,
      1.U,
      Mux(
        runTimeInputABandWidthFactor === 0.U,
        1.U,
        runTimeInputABandWidthFactor
      )
    )
  A_s2p.io.terminate_factor.get := input_a_serial_factor

  def realBBandWidth(
    dataTypeIdx:  UInt,
    dimIdx:       UInt,
    elemWidthSeq: Vec[UInt]
  ) = {
    val dim = dimRom(dataTypeIdx)(dimIdx)
    dim(1) * dim(2) * elemWidthSeq(dataTypeIdx)
  }

  val inputBElemWidthRom = VecInit(params.inputTypeB.map(_.width.U(params.configWidth.W)))

  val runTimeInputBBandWidthFactor = (realBBandWidth(
    csrReg.arrayCfg.dataTypeCfg,
    csrReg.arrayCfg.arrayShapeCfg,
    inputBElemWidthRom
  ) / params.serialInputBDataWidth.U)

  val input_b_serial_factor =
    Mux(
      params.arrayInputBWidth.U <= params.serialInputBDataWidth.U,
      1.U,
      Mux(
        runTimeInputBBandWidthFactor === 0.U,
        1.U,
        runTimeInputBBandWidthFactor
      )
    )
  B_s2p.io.terminate_factor.get := input_b_serial_factor

  // -----------------------------------
  // insert registers for A and B data cut starts
  // -----------------------------------
  val cut_combined_decoupled_a_b_sub_in  = Wire(
    Decoupled(UInt((params.arrayInputAWidth + params.arrayInputBWidth + params.configWidth).W))
  )
  val cut_combined_decoupled_a_b_sub_out = Wire(
    Decoupled(UInt((params.arrayInputAWidth + params.arrayInputBWidth + params.configWidth).W))
  )

  val combined_decoupled_a_b_sub = Module(
    new DecoupledCatNto1(
      Seq(
        params.arrayInputAWidth,
        params.arrayInputBWidth,
        params.configWidth
      )
    )
  )

  combined_decoupled_a_b_sub.io.in(0) <> A_s2p.io.out
  combined_decoupled_a_b_sub.io.in(1) <> B_s2p.io.out

  val decoupled_sub = Wire(Decoupled(UInt(params.configWidth.W)))
  decoupled_sub.bits  := io.ctrl.bits.fsmCfg.subtraction_constant_i
  decoupled_sub.valid := cstate === sBUSY
  combined_decoupled_a_b_sub.io.in(2) <> decoupled_sub

  combined_decoupled_a_b_sub.io.out <> cut_combined_decoupled_a_b_sub_in

  val cut_buffer = Module(
    new DataCut(chiselTypeOf(cut_combined_decoupled_a_b_sub_in.bits), delay = params.adderTreeDelay) {
      override val desiredName =
        s"DataCut${params.adderTreeDelay}_W_" + cut_combined_decoupled_a_b_sub_in.bits.getWidth.toString + "_T_" + cut_combined_decoupled_a_b_sub_in.bits.getClass.getSimpleName
    }
  )
  cut_buffer.suggestName(cut_combined_decoupled_a_b_sub_in.circuitName + s"_dataCut${params.adderTreeDelay}")
  cut_combined_decoupled_a_b_sub_in <> cut_buffer.io.in
  cut_buffer.io.out <> cut_combined_decoupled_a_b_sub_out

  val a_after_cut   = Wire(Decoupled(UInt(params.arrayInputAWidth.W)))
  val b_after_cut   = Wire(Decoupled(UInt(params.arrayInputBWidth.W)))
  val sub_after_cut = Wire(Decoupled(UInt(params.configWidth.W)))

  a_after_cut.bits  := cut_combined_decoupled_a_b_sub_out.bits(
    params.arrayInputAWidth + params.arrayInputBWidth + params.configWidth - 1,
    params.arrayInputBWidth + params.configWidth
  )
  a_after_cut.valid := cut_combined_decoupled_a_b_sub_out.valid

  b_after_cut.bits  := cut_combined_decoupled_a_b_sub_out.bits(
    params.arrayInputBWidth + params.configWidth - 1,
    params.configWidth
  )
  b_after_cut.valid := cut_combined_decoupled_a_b_sub_out.valid

  sub_after_cut.bits  := cut_combined_decoupled_a_b_sub_out.bits(
    params.configWidth - 1,
    0
  )
  sub_after_cut.valid := cut_combined_decoupled_a_b_sub_out.valid

  cut_combined_decoupled_a_b_sub_out.ready := a_after_cut.fire && b_after_cut.fire && sub_after_cut.fire

  // -----------------------------------
  // insert registers for data cut ends
  // -----------------------------------

  // -----------------------------------
  // serial_parallel C/D data converters starts
  // ---------------------------------

  // C32 serial to parallel converter
  val C_s2p = Module(
    new SerialToParallel(
      SerialToParallelParams(
        parallelWidth  = params.arrayInputCWidth,
        serialWidth    = params.serialInputCDataWidth,
        earlyTerminate = true
      )
    )
  )

  // D32 parallel to serial converter
  val D_p2s = Module(
    new ParallelToSerial(
      ParallelToSerialParams(
        parallelWidth  = params.arrayOutputDWidth,
        serialWidth    = params.serialOutputDDataWidth,
        earlyTerminate = true
      )
    )
  )
  require(params.serialInputCDataWidth == params.serialOutputDDataWidth)
  require(params.arrayInputCWidth == params.arrayOutputDWidth)

  // Design-time check to ensure real bandwidth is divisible by serialization width
  params.arrayDim.zipWithIndex.foreach { case (shapes, dataTypeIdx) =>
    shapes.zipWithIndex.foreach { case (dim, dimIdx) =>
      val outputTypeD   = params.outputTypeD(dataTypeIdx)
      val realBandwidth = dim(0) * dim(2) * outputTypeD.width
      require(
        if (realBandwidth > params.serialOutputDDataWidth) realBandwidth % params.serialOutputDDataWidth == 0 else true,
        s"Invalid config: real bandwidth ($realBandwidth) not divisible by serialOutputDDataWidth (${params.serialOutputDDataWidth}) " +
          s"at dataTypeIdx=$dataTypeIdx, dimIdx=$dimIdx"
      )
    }
  }

  val inputCElemWidthRom = VecInit(params.inputTypeC.map(_.width.U(params.configWidth.W)))

  val runTimeInputCBandWidthFactor = (realCDBandWidth(
    csrReg.arrayCfg.dataTypeCfg,
    csrReg.arrayCfg.arrayShapeCfg,
    inputCElemWidthRom
  ) / params.serialInputCDataWidth.U)

  val input_c_serial_factor =
    Mux(
      params.arrayInputCWidth.U <= params.serialInputCDataWidth.U,
      1.U,
      Mux(
        runTimeInputCBandWidthFactor === 0.U,
        1.U,
        runTimeInputCBandWidthFactor
      )
    )

  C_s2p.io.terminate_factor.get := input_c_serial_factor
  C_s2p.io.enable               := cstate === sBUSY

  D_p2s.io.terminate_factor.get := output_d_serial_factor
  D_p2s.io.enable               := cstate === sBUSY

  io.data.in_c <> C_s2p.io.in
  io.data.out_d <> D_p2s.io.out

  // ------------------------------------
  // serial_parallel data converters ends
  // ------------------------------------

  // ------------------------------------
  // array instance and data handshake signal connections starts
  // ------------------------------------
  val array = Module(new SpatialArray(params))

  // array accAddExtIn control signal
  // always one accumulation then  K_i array computation
  val accAddExtIn        = WireInit(0.B)
  val computeFireCounter = Module(new BasicCounter(params.configWidth, nameTag = "computeFireCounter"))
  computeFireCounter.io.ceil := csrReg.fsmCfg.K_i
  val addCFire =
    (a_after_cut.fire && b_after_cut.fire && array.io.data.in_c.fire && computeFireCounter.io.value === 0.U)
  val mulABFire = (a_after_cut.fire && b_after_cut.fire && computeFireCounter.io.value =/= 0.U)
  computeFireCounter.io.tick  := (addCFire || mulABFire) && cstate === sBUSY
  computeFireCounter.io.reset := computation_finish

  accAddExtIn := computeFireCounter.io.value === 0.U && cstate === sBUSY

  // array ctrl signals
  array.io.ctrl.arrayShapeCfg := csrReg.arrayCfg.arrayShapeCfg
  array.io.ctrl.dataTypeCfg   := csrReg.arrayCfg.dataTypeCfg
  array.io.ctrl.accAddExtIn   := accAddExtIn
  array.io.ctrl.accClear      := computation_finish

  // array data signals
  array.io.data.in_a <> a_after_cut
  array.io.data.in_b <> b_after_cut

  array.io.data.in_c.bits  := C_s2p.io.out.bits
  array.io.data.in_c.valid := C_s2p.io.out.valid && cstate === sBUSY
  // array c_ready  considering output stationary
  C_s2p.io.out.ready       := addCFire           && cstate === sBUSY

  array.io.data.in_subtraction <> sub_after_cut

  // array d_ready considering output stationary
  val dOutputValidCounter = Module(new BasicCounter(params.configWidth, nameTag = "dOutputValidCounter"))
  dOutputValidCounter.io.ceil  := csrReg.fsmCfg.K_i
  dOutputValidCounter.io.tick  := array.io.data.out_d.fire && cstate === sBUSY
  dOutputValidCounter.io.reset := computation_finish

  // array output data to the D_p2s converter
  D_p2s.io.in.bits := array.io.data.out_d.bits
  D_p2s.io.in.valid := array.io.data.out_d.valid && cstate === sBUSY && dOutputValidCounter.io.value === (csrReg.fsmCfg.K_i - 1.U)
  array.io.data.out_d.ready := Mux(D_p2s.io.in.valid, D_p2s.io.in.ready, true.B) && cstate === sBUSY

  // ------------------------------------
  // array instance and data handshake signal connections ends
  // ------------------------------------

  // profiling and status signals
  val performance_counter = RegInit(0.U(params.configWidth.W))

  when(cstate === sBUSY) {
    performance_counter := performance_counter + 1.U
  }.elsewhen(config_valid) {
    performance_counter := 0.U
  }

  // output control signals for read-only csrs
  io.performance_counter := performance_counter

  io.busy_o := cstate =/= sIDLE
}

object VersaCoreEmitter extends App {
  emitVerilog(
    new VersaCore(SpatialArrayParam()),
    Array("--target-dir", "generated/versacore")
  )
}

object VersaCoreEmitterFloat16Int4 extends App {
  val FP16Int4Array_Param = SpatialArrayParam(
    macNum                 = Seq(8),
    inputTypeA             = Seq(FP16),
    inputTypeB             = Seq(Int4),
    inputTypeC             = Seq(FP32),
    outputTypeD            = Seq(FP32),
    arrayInputAWidth       = 64,
    arrayInputBWidth       = 16,
    arrayInputCWidth       = 128,
    arrayOutputDWidth      = 128,
    serialInputADataWidth  = 64,
    serialInputBDataWidth  = 16,
    serialInputCDataWidth  = 128,
    serialOutputDDataWidth = 128,
    arrayDim               = Seq(Seq(Seq(2, 2, 2)))
  )
  emitVerilog(
    new VersaCore(FP16Int4Array_Param),
    Array("--target-dir", "generated/versacore")
  )
}

object VersaCoreEmitterFloat16Float16 extends App {
  val FP16Float16Array_Param = SpatialArrayParam(
    macNum                 = Seq(8),
    inputTypeA             = Seq(FP16),
    inputTypeB             = Seq(FP16),
    inputTypeC             = Seq(FP32),
    outputTypeD            = Seq(FP32),
    arrayInputAWidth       = 64,
    arrayInputBWidth       = 64,
    arrayInputCWidth       = 128,
    arrayOutputDWidth      = 128,
    serialInputADataWidth  = 64,
    serialInputBDataWidth  = 64,
    serialInputCDataWidth  = 128,
    serialOutputDDataWidth = 128,
    arrayDim               = Seq(Seq(Seq(2, 2, 2)))
  )
  emitVerilog(
    new VersaCore(FP16Float16Array_Param),
    Array("--target-dir", "generated/versacore")
  )
}
