package snax_acc.simd

import chisel3._
import chisel3.util._
import chisel3.VecInit

// Rescale SIMD data interface
// one big input port, one big output port
class RescaleSIMDDataIO(params: RescaleSIMDParams) extends Bundle {
  // a multi-data input, decoupled interface for handshake
  val input_i =
    Flipped(Decoupled(UInt((params.dataLen * params.inputType).W)))

  // a multi-data output, decoupled interface for handshake
  val output_o = Decoupled(
    UInt((params.dataLen * params.outputType).W)
  )

}

// Rescale SIMD input and output declaration
class RescaleSIMDIO(params: RescaleSIMDParams) extends Bundle {
  // the input data across different RescalePEs shares the same control signal
  val ctrl = Flipped(Decoupled(Vec(params.readWriteCsrNum, UInt(32.W))))
  // decoupled data ports
  val data = new RescaleSIMDDataIO(params)
  val busy_o = Output(Bool())
  val performance_counter = Output(UInt(32.W))
}

// Rescale SIMD module
// This module implements this spec: specification: https://gist.github.com/jorendumoulin/83352a1e84501ec4a7b3790461fee2bf in parallel
class RescaleSIMD(params: RescaleSIMDParams)
    extends Module
    with RequireAsyncReset {
  val io = IO(new RescaleSIMDIO(params))

  // generating parallel RescalePEs
  val lane = Seq.fill(params.laneLen)(Module(new RescalePE(params)))

  // control csr registers for storing the control data
  val ctrl_csr = Reg(new RescalePECtrl(params))

  // result from different RescalePEs
  val result = Wire(
    Vec(params.laneLen, SInt(params.outputType.W))
  )
  // storing the result in case needs to output multi-cycles
  val out_reg = RegInit(
    0.U((params.laneLen * params.outputType).W)
  )

  // the receiver isn't ready, needs to send several cycles
  val keep_output = RegInit(0.B)

  val simd_output_fire = WireInit(0.B)

  val read_counter = RegInit(0.U(32.W))

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

  val simd_input_fire = WireInit(0.B)
  simd_input_fire := io.data.input_i.fire
  when(simd_input_fire) {
    read_counter := read_counter + 1.U
  }.elsewhen(cstate === sIDLE) {
    read_counter := 0.U
  }

  simd_output_fire := io.data.output_o.fire
  when(simd_output_fire) {
    write_counter := write_counter + 1.U
  }.elsewhen(cstate === sIDLE) {
    write_counter := 0.U
  }

  computation_finish := (read_counter === ctrl_csr.len) && (write_counter === ctrl_csr.len - 1.U) && simd_output_fire && cstate === sBUSY

  // always ready for configuration
  io.ctrl.ready := cstate === sIDLE

  // give each RescalePE right control signal and data
  // collect the result of each RescalePE
  for (i <- 0 until params.laneLen) {
    lane(i).io.ctrl_i := ctrl_csr
    lane(i).io.input_i := io.data.input_i
      .bits(
        (i + 1) * params.inputType - 1,
        (i) * params.inputType
      )
      .asSInt
    lane(i).io.valid_i := io.data.input_i.valid && io.data.input_i.ready
    result(i) := lane(i).io.output_o
  }

  // always valid for new input on less is sending last output
  io.data.input_i.ready := !keep_output && !(io.data.output_o.valid & !io.data.output_o.ready) && (cstate === sBUSY)

  // if out valid but not ready, keep sneding output valid signal
  keep_output := io.data.output_o.valid & !io.data.output_o.ready

  // if data out is valid from RescalePEs, store the results in case later needs keep sending output data if receiver side is not ready
  when(lane(0).io.valid_o) {
    out_reg := Cat(result.reverse)
  }
  val out_reg_valid = RegNext(lane(0).io.valid_o)

  // concat every result to a big data bus for output
  // if is keep sending output, send the stored result
  io.data.output_o.bits := out_reg

  // first valid from RescalePE or keep sending valid if receiver side is not ready
  io.data.output_o.valid := out_reg_valid || keep_output

}

// Scala main function for generating system verilog file for the Rescale SIMD module
object RescaleSIMD extends App {
  emitVerilog(
    new RescaleSIMD(DefaultConfig.rescaleSIMDConfig),
    Array("--target-dir", "generated/rescalesimd")
  )
}
