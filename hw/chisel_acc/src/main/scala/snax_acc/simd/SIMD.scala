package snax_acc.simd

import chisel3._
import chisel3.util._
import chisel3.VecInit

// post-processing SIMD data interface
// one big input port, one big output port
class SIMDDataIO extends Bundle {
  // a multi-data input, decoupled interface for handshake
  val input_i =
    Flipped(Decoupled(UInt((SIMDConstant.laneLen * SIMDConstant.inputType).W)))

  // a multi-data output, decoupled interface for handshake
  val out_o = Decoupled(
    UInt((SIMDConstant.laneLen * SIMDConstant.outputType).W)
  )

}

// post-processing SIMD input and output declaration
class SIMDIO extends Bundle {
  // the input data across different PEs shares the same control signal
  val ctrl = Flipped(Decoupled(Vec(SIMDConstant.readWriteCsrNum, UInt(32.W))))
  // decoupled data ports
  val data = new SIMDDataIO()
  val busy_o = Output(Bool())
  val performance_counter = Output(UInt(32.W))
}

// post-processing SIMD module
// This module implements this spec: specification: https://gist.github.com/jorendumoulin/83352a1e84501ec4a7b3790461fee2bf in parallel
class SIMD(laneLen: Int = SIMDConstant.laneLen)
    extends Module
    with RequireAsyncReset {
  val io = IO(new SIMDIO())

  // generating parallel PEs
  val lane = Seq.fill(laneLen)(Module(new PE()))

  // control csr registers for storing the control data
  val ctrl_csr = Reg(new PECtrl())

  // result from different PEs
  val result = Wire(
    Vec(SIMDConstant.laneLen, SInt(SIMDConstant.outputType.W))
  )
  // storing the result in case needs to output multi-cycles
  val out_reg = RegInit(
    0.U((SIMDConstant.laneLen * SIMDConstant.outputType).W)
  )

  // the receiver isn't ready, needs to send several cycles
  val keep_output = RegInit(0.B)

  val simd_output_fire = WireInit(0.B)

  val write_counter = RegInit(0.U(32.W))

  // State declaration
  val sIDLE :: sBUSY :: Nil = Enum(2)
  val cstate = RegInit(sIDLE)
  val nstate = WireInit(sIDLE)

  // signals for state transition
  val config_valid = WireInit(0.B)
  val computation_finish = WireInit(0.B)

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

  io.busy_o := cstate === sBUSY

  val performance_counter = RegInit(0.U(32.W))
  when(cstate === sBUSY) {
    performance_counter := performance_counter + 1.U
  }.elsewhen(config_valid) {
    performance_counter := 0.U
  }
  io.performance_counter := performance_counter

  config_valid := io.ctrl.fire

  // when config valid, store the configuration for later computation
  ctrl_csr.input_zp_i := io.ctrl.bits(0)(7, 0).asSInt
  ctrl_csr.output_zp_i := io.ctrl.bits(0)(15, 8).asSInt

  // this control input port is 32 bits, so it needs 1 csr
  ctrl_csr.multiplier_i := io.ctrl.bits(2).asSInt

  ctrl_csr.shift_i := io.ctrl.bits(0)(23, 16).asSInt
  ctrl_csr.max_int_i := io.ctrl.bits(0)(31, 24).asSInt

  ctrl_csr.min_int_i := io.ctrl.bits(1)(7, 0).asSInt

  // this control input port is only 1 bit
  ctrl_csr.double_round_i := io.ctrl.bits(1)(8).asBool

  // length of the data
  ctrl_csr.len := io.ctrl.bits(3)

  simd_output_fire := io.data.out_o.fire
  when(simd_output_fire) {
    write_counter := write_counter + 1.U
  }.elsewhen(cstate === sIDLE) {
    write_counter := 0.U
  }

  computation_finish := (write_counter === ctrl_csr.len - 1.U) && simd_output_fire && cstate === sBUSY

  // always ready for configuration
  io.ctrl.ready := cstate === sIDLE

  // give each PE right control signal and data
  // collect the result of each PE
  for (i <- 0 until laneLen) {
    lane(i).io.ctrl_i := ctrl_csr
    lane(i).io.input_i := io.data.input_i
      .bits(
        (i + 1) * SIMDConstant.inputType - 1,
        (i) * SIMDConstant.inputType
      )
      .asSInt
    lane(i).io.valid_i := io.data.input_i.valid && io.data.input_i.ready
    result(i) := lane(i).io.out_o
  }

  // always valid for new input on less is sending last output
  io.data.input_i.ready := !keep_output && !(io.data.out_o.valid & !io.data.out_o.ready) && (cstate === sBUSY)

  // if out valid but not ready, keep sneding output valid signal
  keep_output := io.data.out_o.valid & !io.data.out_o.ready

  // if data out is valid from PEs, store the results in case later needs keep sending output data if receiver side is not ready
  when(lane(0).io.valid_o) {
    out_reg := Cat(result.reverse)
  }
  val out_reg_valid = RegNext(lane(0).io.valid_o)

  // concat every result to a big data bus for output
  // if is keep sending output, send the stored result
  io.data.out_o.bits := out_reg

  // first valid from PE or keep sending valid if receiver side is not ready
  io.data.out_o.valid := out_reg_valid || keep_output

}

// Scala main function for generating system verilog file for the post-processing SIMD module
object SIMD extends App {
  emitVerilog(
    new SIMD(SIMDConstant.laneLen),
    Array("--target-dir", "generated/simd")
  )
}
