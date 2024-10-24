package snax_acc.simd

import chisel3._
import chisel3.util._
import chisel3.VecInit
import snax_acc.utils.DecoupledCut._

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
  def ctrl_csr_set_num = params.laneLen / params.sharedScaleFactorPerGroupSize

  // Create a Vec of ctrl_csr_set_num instances of RescalePECtrl(params)
  val ctrl_csr = VecInit(Seq.fill(ctrl_csr_set_num) {
    Reg(new RescalePECtrl(params))
  })

  // result from different RescalePEs
  val result = Wire(
    Vec(params.laneLen, SInt(params.outputType.W))
  )

  // one cycle delayed input data using DecoupledCut
  val one_cycle_dalayed_decoupled_input_data = Wire(
    Decoupled(UInt((params.laneLen * params.inputType).W))
  )

  io.data.input_i -\> one_cycle_dalayed_decoupled_input_data

  val simd_input_fire = WireInit(0.B)
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
  for (i <- 0 until ctrl_csr_set_num) {
    // common control input ports
    ctrl_csr(i).input_zp_i := io.ctrl.bits(0)(7, 0).asSInt
    ctrl_csr(i).output_zp_i := io.ctrl.bits(0)(15, 8).asSInt
    ctrl_csr(i).max_int_i := io.ctrl.bits(0)(23, 16).asSInt
    ctrl_csr(i).min_int_i := io.ctrl.bits(0)(31, 24).asSInt

    // this control input port is only 1 bit
    ctrl_csr(i).double_round_i := io.ctrl.bits(1)(0).asBool

    // ---------------------
    // sharedScaleFactorPerGroup
    def packed_shift_num = 32 / params.constantType
    ctrl_csr(i).shift_i := io.ctrl
      .bits(2 + i / packed_shift_num)(
        i % packed_shift_num * params.constantType + params.constantType - 1,
        i % packed_shift_num * params.constantType
      )
      .asSInt

    // this control input port is 32 bits, so it needs 1 csr
    ctrl_csr(i).multiplier_i := io.ctrl.bits(4 + i).asSInt
    // ---------------------

    // length of the data
    ctrl_csr(i).len := io.ctrl
      .bits(2 + ctrl_csr_set_num / 4 + ctrl_csr_set_num)
      .asUInt

  }

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

  computation_finish := (read_counter === ctrl_csr(
    0
  ).len) && (write_counter === ctrl_csr(
    0
  ).len) && cstate === sBUSY

  // always ready for configuration
  io.ctrl.ready := cstate === sIDLE

  // give each RescalePE right control signal and data
  // collect the result of each RescalePE
  for (i <- 0 until params.laneLen) {
    lane(i).io.ctrl_i := ctrl_csr(i % ctrl_csr_set_num)
    result(i) := lane(i).io.output_o.bits
  }

  for (i <- 0 until params.laneLen) {
    lane(i).io.input_i.bits := one_cycle_dalayed_decoupled_input_data
      .bits(
        (i + 1) * params.inputType - 1,
        (i) * params.inputType
      )
      .asSInt
    lane(i).io.input_i.valid := one_cycle_dalayed_decoupled_input_data.valid
    lane(i).io.output_o.ready := io.data.output_o.ready
  }

  // always ready for new input unless is sending the last output (output stalled)
  one_cycle_dalayed_decoupled_input_data.ready := lane
    .map(_.io.input_i.ready)
    .reduce(_ && _) && (cstate === sBUSY)

  // concat every result to a big data bus for output
  io.data.output_o.bits := Cat(result.reverse)

  // propogate the valid signal
  io.data.output_o.valid := lane
    .map(_.io.output_o.valid)
    .reduce(_ && _) && (cstate === sBUSY)

}

// Scala main function for generating system verilog file for the Rescale SIMD module
object RescaleSIMD extends App {
  emitVerilog(
    new RescaleSIMD(DefaultConfig.rescaleSIMDConfig),
    Array("--target-dir", "generated/rescalesimd")
  )
}
