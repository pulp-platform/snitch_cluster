package snax.xdma.CommonCells

import chisel3._
import chisel3.util._

/** The 1in, N-out Demux for Decoupled signal As the demux is the 1in, 2out
  * system, we don't need to consider the demux of bits
  */
class DemuxDecoupled[T <: Data](dataType: T, numOutput: Int)
    extends Module
    with RequireAsyncReset {
  val io = IO(new Bundle {
    val in = Flipped(Decoupled(dataType))
    val out = Vec(numOutput, Decoupled(dataType))
    val sel = Input(UInt(log2Ceil(numOutput).W))
  })
  // Default assigns
  io.in.ready := false.B
  // Demux logic
  for (i <- 0 until numOutput) {
    io.out(i).bits := io.in.bits
    when(io.sel === i.U) {
      io.out(i).valid := io.in.valid
      io.in.ready := io.out(i).ready
    } otherwise {
      io.out(i).valid := false.B // Unselected output should not be valid
    }
  }
}

/** The N-in, 1out Demux for Decoupled signal
  */
class MuxDecoupled[T <: Data](dataType: T, numInput: Int)
    extends Module
    with RequireAsyncReset {
  val io = IO(new Bundle {
    val in = Vec(numInput, Flipped(Decoupled(dataType)))
    val out = Decoupled(dataType)
    val sel = Input(UInt(log2Ceil(numInput).W))
  })
  // Default assigns
  io.out.valid := false.B
  io.out.bits := 0.U.asTypeOf(dataType)
  // Mux logic
  for (i <- 0 until numInput) {
    when(io.sel === i.U) {
      io.out.valid := io.in(i).valid
      io.in(i).ready := io.out.ready
      io.out.bits := io.in(i).bits
    } otherwise {
      io.in(i).ready := false.B // Unselected input should not be ready
    }
  }
}
