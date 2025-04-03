package snax_acc.reshuffle

import chisel3._
import chisel3.util._

// control signals for the basic processing element, related to the pooling algorithm
class MAXPoolPECtrlIO() extends Bundle {

  val init_i = Input(Bool())

}

// data signals for the basic processing element, related to the pooling algorithm
class MAXPoolPEDataIO(params: ReshufflerParams) extends Bundle {

  val input_i  = Flipped(Decoupled(SInt(params.inputWidth.W)))
  val output_o = Decoupled(SInt(params.outputWidth.W))

}

// processing element input and output declaration
class MAXPoolPEIO(params: ReshufflerParams) extends Bundle {

  val ctrl = new MAXPoolPECtrlIO()
  val data = new MAXPoolPEDataIO(params)

}

// MAXPoolPE module
class MAXPoolPE(params: ReshufflerParams) extends Module with RequireAsyncReset {
  val io = IO(new MAXPoolPEIO(params))

  val resReg      = RegInit(0.S(params.inputWidth.W))
  // the receiver isn't ready, needs to send several cycles
  val keep_output = RegInit(0.B)

  when(io.data.input_i.valid) {
    when(io.ctrl.init_i) {
      // max pooling
      resReg := Mux(io.data.input_i.bits > -128.S, io.data.input_i.bits, -128.S)
    }.otherwise {
      // max pooling
      resReg := Mux(io.data.input_i.bits > resReg, io.data.input_i.bits, resReg)
    }
  }

  io.data.output_o.bits := resReg

  // if is keep sending output, send the stored result
  keep_output            := io.data.output_o.valid & !io.data.output_o.ready
  io.data.output_o.valid := RegNext(io.data.input_i.valid) || keep_output

  io.data.input_i.ready := !(io.data.output_o.valid & !io.data.output_o.ready) & !keep_output
}

// Scala main function for generating system verilog file for the MAXPoolPE module
object MAXPoolPEGen extends App {
  emitVerilog(
    new MAXPoolPE(DefaultConfig.ReshufflerConfig),
    Array("--target-dir", "generated/pool")
  )
}
