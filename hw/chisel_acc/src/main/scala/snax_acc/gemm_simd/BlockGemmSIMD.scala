package snax_acc.gemm_simd

import chisel3._
import chisel3.util._

import snax_acc.simd._
import snax_acc.gemm._

// The BlockGemmSIMD's control port declaration.
class BlockGemmSIMDCtrlIO extends Bundle {

  val gemm_ctrl = Flipped(DecoupledIO(new BlockGemmCtrlIO()))
  val simd_ctrl = Flipped(
    Decoupled(Vec(SIMDConstant.readWriteCsrNum, UInt(32.W)))
  )
  val bypassSIMD = Input(Bool())
  val busy_o = Output(Bool())
  val performance_counter = Output(UInt(32.W))

}

// The BlockGemmSIMD's data port declaration. Decoupled interface connected to the streamer
class BlockGemmSIMDDataIO extends Bundle {
  val gemm_data = new BlockGemmDataIO()
  val simd_data = Decoupled(
    UInt((SIMDConstant.laneLen * SIMDConstant.outputType).W)
  )
}

class BlockGemmSIMDIO extends Bundle {
  val ctrl = new BlockGemmSIMDCtrlIO()
  val data = new BlockGemmSIMDDataIO()
}

class BlockGemmSIMD extends Module with RequireAsyncReset {

  val io = IO(new BlockGemmSIMDIO())

  val gemm = Module(new BlockGemm())
  val simd = Module(new SIMD())

  // gemm  control signal connection
  gemm.io.ctrl <> io.ctrl.gemm_ctrl
  // gemm input data
  gemm.io.data.a_i <> io.data.gemm_data.a_i
  gemm.io.data.b_i <> io.data.gemm_data.b_i
  gemm.io.data.c_i <> io.data.gemm_data.c_i

  // simd signal connection
  when(io.ctrl.bypassSIMD){
    simd.io.ctrl.bits <> 0.U.asTypeOf(simd.io.ctrl.bits)
    simd.io.ctrl.valid := false.B
    io.ctrl.simd_ctrl.ready := simd.io.ctrl.ready
  }.otherwise{
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
    simd.io.data.input_i.valid := RegNext(gemm.io.data.d_o.valid)
    simd.io.data.input_i.bits := RegNext(gemm.io.data.d_o.bits)
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
    simd.io.data.out_o.ready := false.B
  }.otherwise {
    io.data.simd_data <> simd.io.data.out_o
  }

  io.ctrl.busy_o := gemm.io.busy_o || simd.io.busy_o
  when(io.ctrl.bypassSIMD) {
    io.ctrl.performance_counter := gemm.io.performance_counter
  }.otherwise {
    io.ctrl.performance_counter := simd.io.performance_counter
  }

}

object BlockGemmSIMD extends App {
  emitVerilog(
    new (BlockGemmSIMD),
    Array("--target-dir", "generated/gemm_simd")
  )
}
