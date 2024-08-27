package snax_acc.reshuffle

import chisel3._
import chisel3.util._

class ReshufflerCtrl(params: ReshufflerParams) extends Bundle {

  // packed CRS configuration
  val reduceLen_i = UInt(6.W)
  val tloop2Len_i = UInt(24.W)
  val opcode_i = UInt(2.W)

  require(params.sizeConfigWidth == 32, "sizeConfigWidth must be 32")

}

// Reshuffler data interface
// one big input port, one big output port
class ReshufflerDataIO(params: ReshufflerParams) extends Bundle {

  // a multi-data input, decoupled interface for handshake
  val input_i =
    Flipped(Decoupled(UInt((params.poolLaneLen * params.inputWidth).W)))

  // a multi-data output, decoupled interface for handshake
  val output_o = Decoupled(
    UInt((params.poolLaneLen * params.outputWidth).W)
  )

}

// Reshuffler input and output declaration
class ReshufflerIO(params: ReshufflerParams) extends Bundle {
  // the input data across different MAXPoolPEs shares the same control signal
  val ctrl = Flipped(
    Decoupled(Vec(params.readWriteCsrNum, UInt(params.sizeConfigWidth.W)))
  )
  // decoupled data ports
  val data = new ReshufflerDataIO(params)

  val performance_counter = Output(UInt(32.W))
  val busy_o = Output(Bool())
}

// Reshuffler module
class Reshuffler(params: ReshufflerParams)
    extends Module
    with RequireAsyncReset {
  val io = IO(new ReshufflerIO(params))

  // control csr registers for storing the control data
  val ctrl_csr = Reg(new ReshufflerCtrl(params))

  // transpose module
  val transposeMux = Module(new TransposeMux(params))

  // generating parallel MAXPoolPEs
  val lane = Seq.fill(params.poolLaneLen)(Module(new MAXPoolPE(params)))

  // result from different MAXPoolPEs
  val result = Wire(
    Vec(params.poolLaneLen, SInt(params.outputWidth.W))
  )

  val pe_input_fire = WireInit(0.B)
  val pe_input_fire_counter = RegInit(0.U(params.sizeConfigWidth.W))

  val pe_out_fire = WireInit(0.B)
  val pe_out_valid = WireInit(0.B)
  val pe_out_fire_counter = RegInit(0.U(params.sizeConfigWidth.W))

  // reshuffle result data output
  val reshuffle_output_fire = WireInit(0.B)
  val write_counter = RegInit(0.U(params.sizeConfigWidth.W))

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
  when(config_valid) {
    ctrl_csr.opcode_i := io.ctrl.bits(0)(1, 0)
    ctrl_csr.reduceLen_i := io.ctrl.bits(0)(7, 2)
    ctrl_csr.tloop2Len_i := io.ctrl.bits(0)(31, 8)
  }

  // when opcode is 2, do MAXPool
  val doMAXPool = ctrl_csr.opcode_i === 2.U && cstate === sBUSY

  // -------------------------------------------------------------------
  // pool simd logic
  // -------------------------------------------------------------------

  // give each MAXPoolPE right control signal and data
  // collect the result of each MAXPoolPE
  when(doMAXPool) {
    for (i <- 0 until params.poolLaneLen) {
      // init signal for the first MAXPoolPE
      lane(i).io.ctrl.init_i := pe_input_fire_counter === 0.U

      lane(i).io.data.input_i.bits := io.data.input_i
        .bits(
          (i + 1) * params.inputWidth - 1,
          (i) * params.inputWidth
        )
        .asSInt
      lane(
        i
      ).io.data.input_i.valid := io.data.input_i.valid && io.data.input_i.ready

      result(i) := lane(i).io.data.output_o.bits
      lane(i).io.data.output_o.ready := Mux(
        io.data.output_o.valid,
        io.data.output_o.ready,
        1.B
      )
    }
  }.otherwise {
    lane.map(_.io.ctrl.init_i := false.B)
    lane.map(_.io.data.input_i.bits := 0.S)
    lane.map(_.io.data.input_i.valid := false.B)
    lane.map(_.io.data.output_o.ready := false.B)
    result.map(_ := 0.S)
  }

  // for generating the init signal for the first MAXPoolPE
  pe_input_fire := lane.map(_.io.data.input_i.fire).reduce(_ && _)
  when(
    pe_input_fire && pe_input_fire_counter =/= (ctrl_csr.reduceLen_i - 1.U) && cstate === sBUSY
  ) {
    pe_input_fire_counter := pe_input_fire_counter + 1.U
  }.elsewhen(
    pe_input_fire && pe_input_fire_counter === (ctrl_csr.reduceLen_i - 1.U) && cstate === sBUSY
  ) {
    pe_input_fire_counter := 0.U
  }.elsewhen(cstate === sIDLE) {
    pe_input_fire_counter := 0.U
  }

  pe_out_fire := lane.map(_.io.data.output_o.fire).reduce(_ && _)
  when(
    pe_out_fire && pe_out_fire_counter =/= (ctrl_csr.reduceLen_i - 1.U) && cstate === sBUSY
  ) {
    pe_out_fire_counter := pe_out_fire_counter + 1.U
  }.elsewhen(
    pe_out_fire && pe_out_fire_counter === (ctrl_csr.reduceLen_i - 1.U) && cstate === sBUSY
  ) {
    pe_out_fire_counter := 0.U
  }.elsewhen(cstate === sIDLE) {
    pe_out_fire_counter := 0.U
  }

  pe_out_valid := lane.map(_.io.data.output_o.valid).reduce(_ && _)

  // -------------------------------------------------------------------
  // transpose logic
  // -------------------------------------------------------------------
  // when opcode is 0, do not transpose
  // when opcode is 1, do transpose
  val doTranspose =
    (ctrl_csr.opcode_i === 0.U || ctrl_csr.opcode_i === 1.U) && cstate === sBUSY
  when(doTranspose) {
    transposeMux.io.transpose := ctrl_csr.opcode_i === 1.U
    transposeMux.io.input.bits := io.data.input_i.bits
    transposeMux.io.input.valid := io.data.input_i.valid
    transposeMux.io.output.ready := io.data.output_o.ready
  }.otherwise {
    transposeMux.io.transpose := false.B
    transposeMux.io.input.valid := false.B
    transposeMux.io.input.bits := 0.U
    transposeMux.io.output.ready := false.B
  }

  reshuffle_output_fire := io.data.output_o.fire
  when(reshuffle_output_fire) {
    write_counter := write_counter + 1.U
  }.elsewhen(cstate === sIDLE) {
    write_counter := 0.U
  }

  when(doMAXPool) {
    // always valid for new input on less is sending last output
    io.data.input_i.ready := lane
      .map(_.io.data.input_i.ready)
      .reduce(_ && _) && (cstate === sBUSY)

    // concat every result to a big data bus for output
    io.data.output_o.bits := Cat(result.reverse)

    // first valid from MAXPoolPE or keep sending valid if receiver side is not ready
    io.data.output_o.valid := (pe_out_valid && pe_out_fire_counter === (ctrl_csr.reduceLen_i - 1.U))

  }.elsewhen(doTranspose) {
    io.data.input_i.ready := transposeMux.io.input.ready
    io.data.output_o.bits := transposeMux.io.output.bits
    io.data.output_o.valid := transposeMux.io.output.valid
  }.otherwise {
    io.data.input_i.ready := false.B
    io.data.output_o.bits := 0.U
    io.data.output_o.valid := false.B
  }

  computation_finish := (write_counter === ctrl_csr.tloop2Len_i - 1.U) && reshuffle_output_fire && cstate === sBUSY

  // always ready for configuration
  io.ctrl.ready := cstate === sIDLE

}

// Scala main function for generating system verilog file for the Reshuffler module
object Reshuffler extends App {
  emitVerilog(
    new Reshuffler(DefaultConfig.ReshufflerConfig),
    Array("--target-dir", "generated/reshuffle")
  )
}
