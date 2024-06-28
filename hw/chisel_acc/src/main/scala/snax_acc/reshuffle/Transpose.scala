package snax_acc.reshuffle

import chisel3._
import chisel3.util._

class TransposeMux(params: ReshufflerParams) extends Module {

  override val desiredName = params.tagName + "_TransposeMux"

  val io = IO(new Bundle {
    val input = Flipped(Decoupled(UInt(params.transposeInWidth.W)))
    val output = Decoupled(UInt(params.transposeOutWidth.W))
    val transpose = Input(Bool())
  })

  require(
    params.transposeInWidth == 512 && 512 == params.transposeOutWidth,
    "transposeInWidth must be 512 for now"
  )

  // data logic
  // add reg for one cycle delay
  val data_reg = RegInit(0.U(params.transposeInWidth.W))

  // fixed pattern: transpose 8x8 matrix
  val out_data_array = Wire(Vec(8, Vec(8, UInt(8.W))))

  for (i <- 0 until 8) {
    for (j <- 0 until 8) {
      out_data_array(i)(j) := io.input.bits(
        i * 8 + j * 8 * 8 + 7,
        i * 8 + j * 8 * 8 + 0
      )
    }
  }

  when(io.transpose && io.input.valid) {
    data_reg := out_data_array.asUInt
  }.elsewhen(!io.transpose && io.input.valid) {
    data_reg := io.input.bits
  }

  // control logic
  val output_stall = WireInit(false.B)
  output_stall := io.output.valid && !io.output.ready

  val keep_output = RegInit(false.B)
  keep_output := output_stall

  io.output.valid := RegNext(io.input.valid) || keep_output
  io.input.ready := !keep_output && !output_stall

  io.output.bits := data_reg
}
