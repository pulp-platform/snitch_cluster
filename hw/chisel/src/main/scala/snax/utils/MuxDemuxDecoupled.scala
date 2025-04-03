package snax.utils

import chisel3._
import chisel3.util._

/** The 1in, N-out Demux for Decoupled signal We don't need to consider the demux of bits.
  */
class DemuxDecoupled[T <: Data](dataType: T, numOutput: Int) extends Module with RequireAsyncReset {
  val io = IO(new Bundle {
    val in  = Flipped(Decoupled(dataType))
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
      io.in.ready     := io.out(i).ready
    } otherwise {
      io.out(i).valid := false.B // Unselected output should not be valid
    }
  }
}

// The stream splitter with runtime configurability to duplicate the stream to multiple destination
class SplitterDecoupled[T <: Data](dataType: T, numOutput: Int) extends Module with RequireAsyncReset {
  val io = IO(new Bundle {
    val in  = Flipped(Decoupled(dataType))
    val out = Vec(numOutput, Decoupled(dataType))
    val sel = Input(Vec(numOutput, Bool()))
  })

  val dataTransmitted     = RegInit(VecInit(Seq.fill(numOutput)(false.B)))
  val nextTransferAllowed = WireInit(VecInit(io.sel.map(~_)))

  // Valid signal of the output channel should be high when:
  // 1) The data needs to be sent to that channel
  // 2) The input data is valid
  // 3) The data has not been accepted before
  io.out.zip(io.sel.zip(dataTransmitted)).foreach {
    case (channelOut, (channelSel, channelTransmitted)) => {
      channelOut.valid := channelSel && io.in.valid && (~channelTransmitted)
    }
  }

  // The next transfer is allowed when:
  // 1) The channel will be successfully transferred in this cycle
  // 2) The channel had been successfully transferred in the previous cycles
  nextTransferAllowed.zipWithIndex.foreach {
    case (channelNextTransferAllowed, index) => {
      when(io.sel(index)) {
        channelNextTransferAllowed := io.out(index).ready | dataTransmitted(
          index
        )
      }
    }
  }

  // When all channels allow the next transfer, then input can pop the current transfer
  io.in.ready := nextTransferAllowed.reduceTree(_ & _)

  // The register as the recorder of whether the previous transfer is accepted
  when(io.in.fire) {
    dataTransmitted := 0.U.asTypeOf(chiselTypeOf(dataTransmitted))
  } otherwise {
    dataTransmitted.zipWithIndex.foreach {
      case (channelTransmitted, index) => {
        channelTransmitted := channelTransmitted | io.out(index).fire
      }
    }
  }

  // Bits does not need and controls, only the valid / ready signal needs the control
  io.out.foreach(_.bits := io.in.bits)
}

object SplitterDecoupledEmitter extends App {
  println(
    getVerilogString(new SplitterDecoupled(UInt(8.W), 8))
  )
}

/** The N-in, 1out Demux for Decoupled signal
  */
class MuxDecoupled[T <: Data](dataType: T, numInput: Int) extends Module with RequireAsyncReset {
  val io = IO(new Bundle {
    val in  = Vec(numInput, Flipped(Decoupled(dataType)))
    val out = Decoupled(dataType)
    val sel = Input(UInt(log2Ceil(numInput).W))
  })
  // Default assigns
  io.out.valid := false.B
  io.out.bits := 0.U.asTypeOf(dataType)
  // Mux logic
  for (i <- 0 until numInput) {
    when(io.sel === i.U) {
      io.out.valid   := io.in(i).valid
      io.in(i).ready := io.out.ready
      io.out.bits    := io.in(i).bits
    } otherwise {
      io.in(i).ready := false.B // Unselected input should not be ready
    }
  }
}
