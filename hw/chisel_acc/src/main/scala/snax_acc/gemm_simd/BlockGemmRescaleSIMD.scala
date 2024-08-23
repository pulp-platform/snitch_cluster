package snax_acc.gemmx

import chisel3._
import chisel3.util._

import snax_acc.simd._
import snax_acc.gemm._

// The BlockGemmRescaleSIMD's control port declaration.
class BlockGemmRescaleSIMDCtrlIO(params: BlockGemmRescaleSIMDParams)
    extends Bundle {

  val gemm_ctrl = Flipped(DecoupledIO(new BlockGemmCtrlIO(params.gemmParams)))
  val simd_ctrl = Flipped(
    Decoupled(Vec(params.rescaleSIMDParams.readWriteCsrNum, UInt(32.W)))
  )
  val bypassSIMD = Input(Bool())
  val busy_o = Output(Bool())
  val performance_counter = Output(UInt(32.W))

}

// The BlockGemmRescaleSIMD's data port declaration. Decoupled interface connected to the streamer
class BlockGemmRescaleSIMDDataIO(params: BlockGemmRescaleSIMDParams)
    extends Bundle {
  val gemm_data = new BlockGemmDataIO(params.gemmParams)
  val simd_data = Decoupled(
    UInt(
      (params.rescaleSIMDParams.dataLen * params.rescaleSIMDParams.outputType).W
    )
  )
}

class BlockGemmRescaleSIMDIO(params: BlockGemmRescaleSIMDParams)
    extends Bundle {
  val ctrl = new BlockGemmRescaleSIMDCtrlIO(params)
  val data = new BlockGemmRescaleSIMDDataIO(params)
}

class BlockGemmRescaleSIMD(params: BlockGemmRescaleSIMDParams)
    extends Module
    with RequireAsyncReset {

  val io = IO(new BlockGemmRescaleSIMDIO(params))

  val gemm = Module(new BlockGemm(params.gemmParams))

  // instiantiate the simd module based on the configuration
  // select if use pipelined simd or not accrording to the configuration
  val simd = params.withPipeline match {
    case true =>
      Module(new PipelinedRescaleSIMD(params.rescaleSIMDParams))
    case false =>
      Module(new RescaleSIMD(params.rescaleSIMDParams))
    case _ => throw new Exception("Unknown SIMD configuration")
  }

  // gemm control signal connection
  gemm.io.ctrl <> io.ctrl.gemm_ctrl
  // gemm input data
  gemm.io.data.a_i <> io.data.gemm_data.a_i
  gemm.io.data.b_i <> io.data.gemm_data.b_i
  gemm.io.data.c_i <> io.data.gemm_data.c_i

  // simd signal connection
  when(io.ctrl.bypassSIMD) {
    simd.io.ctrl.bits <> 0.U.asTypeOf(simd.io.ctrl.bits)
    simd.io.ctrl.valid := false.B
    io.ctrl.simd_ctrl.ready := simd.io.ctrl.ready
  }.otherwise {
    simd.io.ctrl <> io.ctrl.simd_ctrl
  }

  // simd data input
  // gemm output
  when(io.ctrl.bypassSIMD) {
    // input driver
    simd.io.data.input_i.valid := false.B
    simd.io.data.input_i.bits := 0.U

    // gemm output to outside directly
    io.data.gemm_data.d_o <> gemm.io.data.d_o

  }.otherwise {
    // insert a register to improve frequency
    simd.io.data.input_i.valid := gemm.io.data.d_o.valid
    simd.io.data.input_i.bits := gemm.io.data.d_o.bits
    // directly connect the ready signal
    gemm.io.data.d_o.ready := simd.io.data.input_i.ready

    // output driver
    io.data.gemm_data.d_o.valid := false.B
    io.data.gemm_data.d_o.bits := 0.U

  }

  // simd output
  when(io.ctrl.bypassSIMD) {
    // output driver
    io.data.simd_data.bits <> 0.U
    io.data.simd_data.valid <> false.B
    // fake ready signal
    simd.io.data.output_o.ready := false.B
  }.otherwise {
    io.data.simd_data <> simd.io.data.output_o
  }

  io.ctrl.busy_o := gemm.io.busy_o || simd.io.busy_o
  when(io.ctrl.bypassSIMD) {
    io.ctrl.performance_counter := gemm.io.performance_counter
  }.otherwise {
    io.ctrl.performance_counter := simd.io.performance_counter
  }

}

object BlockGemmRescaleSIMD extends App {
  emitVerilog(
    new BlockGemmRescaleSIMD(
      BlockGemmRescaleSIMDDefaultConfig.blockGemmRescaleSIMDConfig
    ),
    Array("--target-dir", "generated/gemmx")
  )
}
