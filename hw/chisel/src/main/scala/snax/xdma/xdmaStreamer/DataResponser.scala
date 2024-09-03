package snax.xdma.xdmaStreamer

import chisel3._
import chisel3.util._

import snax.utils._

/** DataResponser's IO definition: io.in: From TCDM, see Xiaoling's definition
  * to compatible with her wrapper io.out.data: Decoupled(UInt), to store the
  * data to FIFO at the outside io.out.ResponsorReady: Bool(), to determine
  * whether the Requestor can intake more data (dpending on whether the output
  * FIFO is full)
  */

class DataResponserIO(tcdmDataWidth: Int = 64, numChannel: Int = 8)
    extends Bundle {
  val in = new Bundle {
    val tcdmRsp = Flipped(Valid(new TcdmRsp(tcdmDataWidth = tcdmDataWidth)))
  }
  val out = new Bundle {
    val data = Decoupled(UInt(tcdmDataWidth.W))
    val dataFifoNearlyFull = Input(Bool())
  }
  val enable = Input(Bool())
  val reqrspLink = new Bundle {
    val rspReady = Output(Bool())
    val reqSubmit = Input(Bool())
  }
}

class DataResponser(tcdmDataWidth: Int) extends Module with RequireAsyncReset {
  val io = IO(new DataResponserIO(tcdmDataWidth = tcdmDataWidth))
  when(io.enable) {
    io.out.data.valid := io.in.tcdmRsp.valid // io.out's validity is determined by TCDM's side
    io.out.data.bits := io.in.tcdmRsp.bits.data
  } otherwise {
    io.out.data.valid := io.reqrspLink.reqSubmit // io.out's validity is determined by whether the Requestor submit the fake request
    io.out.data.bits := 0.U
  }
  io.reqrspLink.rspReady := ~io.out.dataFifoNearlyFull // If dataBuffer is not full, then the Responsor is ready to intake more data
}

/** DataResponsers' IO definition: io.in: From TCDM, see Xiaoling's definition
  * to compatible with her wrapper io.out.data: Vec(Decoupled(UInt)), to store
  * the data to FIFO at the outside io.out.ResponsorReady: Vec(Bool()), to
  * determine whether the Requestor can intake more data (dpending on whether
  * the output FIFO is full)
  */
// In this module is the multiple instantiation of DataRequestor. No Buffer is required from the data requestor's side, as it will be done at the outside.

// class DataResponsersIO(tcdmDataWidth: Int = 64, numChannel: Int = 8)
//     extends Bundle {
//   val in = new Bundle {
//     val tcdmRsp = Vec(
//       numChannel,
//       Flipped(Valid(new TcdmRsp(tcdmDataWidth = tcdmDataWidth)))
//     )
//   }
//   val out = new Bundle {
//     val data = Vec(numChannel, Decoupled(UInt(tcdmDataWidth.W)))
//     val dataFifoNearlyFull = Input(Vec(numChannel, Bool()))
//   }
//   val enable = Vec(numChannel, Input(Bool()))
//   val RequestorResponserLink = new Bundle {
//     val ResponsorReady = Vec(numChannel, Output(Bool()))
//     val RequestorSubmit = Vec(numChannel, Input(Bool()))
//   }

// }

class DataResponsers(
    tcdmDataWidth: Int = 64,
    numChannel: Int = 8,
    module_name_prefix: String = "unnamed_cluster"
) extends Module
    with RequireAsyncReset {
  val io = IO(
    Vec(numChannel, new DataResponserIO(tcdmDataWidth = tcdmDataWidth))
  )
  override val desiredName = s"${module_name_prefix}_DataResponsers"
  // Instantiation and connection
  val DataResponser = for (i <- 0 until numChannel) yield {
    val module = Module(new DataResponser(tcdmDataWidth = tcdmDataWidth) {
      override val desiredName = s"${module_name_prefix}_DataResponser"
    })
    io(i) <> module.io
    module
  }
}

object DataResponserEmitter extends App {
  println(
    getVerilogString(new DataResponsers(tcdmDataWidth = 64, numChannel = 8))
  )
}
