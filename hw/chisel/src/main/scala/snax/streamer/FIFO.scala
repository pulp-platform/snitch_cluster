package snax.streamer

import chisel3._
import chisel3.util._

// Customized FIFO with an extra almost_full signal.
// almost_full will be asserted when there is Depth-1 elements in the FIFO
class FIFOIO(width: Int) extends Bundle {
  val in = Flipped(Decoupled(UInt(width.W)))
  val out = Decoupled(UInt(width.W))
  val almost_full = Output(Bool())
}

class FIFO(
    depth: Int,
    width: Int,
    tagName: String = ""
) extends Module
    with RequireAsyncReset {
  override val desiredName = tagName + "FIFO"

  val io = IO(new FIFOIO(width))

  if (depth > 0) {
    val fifo = Module(new Queue(UInt(width.W), depth, flow = true))
    fifo.io.enq <> io.in
    fifo.io.deq <> io.out
    io.almost_full := fifo.io.count === (depth - 1).U
  } else {
    io.in <> io.out
    io.almost_full := 0.U
  }

}
