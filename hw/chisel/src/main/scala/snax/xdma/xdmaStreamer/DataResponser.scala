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
  val tcdm_rsp = Flipped(Valid(new TcdmRsp(tcdmDataWidth = tcdmDataWidth)))
  val out = new Bundle {
    val data = Decoupled(UInt(tcdmDataWidth.W))
    val ResponsorReady = Output(Bool())
  }
}

class DataResponser(tcdmDataWidth: Int) extends Module with RequireAsyncReset {
  val io = IO(new DataResponserIO(tcdmDataWidth = tcdmDataWidth))
  io.out.data.valid := io.tcdm_rsp.valid // io.out's validity is determined by TCDM's side
  io.out.data.bits := io.tcdm_rsp.bits.data
  io.out.ResponsorReady := io.out.data.ready // If io.out.data.ready is high, the new request can be issued
}

/** DataResponsers' IO definition: io.in: From TCDM, see Xiaoling's definition
  * to compatible with her wrapper io.out.data: Vec(Decoupled(UInt)), to store
  * the data to FIFO at the outside io.out.ResponsorReady: Vec(Bool()), to
  * determine whether the Requestor can intake more data (dpending on whether
  * the output FIFO is full)
  */
// In this module is the multiple instantiation of DataRequestor. No Buffer is required from the data requestor's side, as it will be done at the outside.

class DataResponsersIO(tcdmDataWidth: Int = 64, numChannel: Int = 8)
    extends Bundle {
  val tcdm_rsp =
    Vec(numChannel, Flipped(Valid(new TcdmRsp(tcdmDataWidth = tcdmDataWidth))))
  val out = new Bundle {
    val data = Vec(numChannel, Decoupled(UInt(tcdmDataWidth.W)))
    val ResponsorReady = Vec(numChannel, Output(Bool()))
  }
}

class DataResponsers(
    tcdmDataWidth: Int = 64,
    numChannel: Int = 8,
    module_name_prefix: String = "unnamed_cluster"
) extends Module
    with RequireAsyncReset {
  val io = IO(
    new DataResponsersIO(tcdmDataWidth = tcdmDataWidth, numChannel = numChannel)
  )
  override val desiredName = s"${module_name_prefix}_DataResponsers"
  // Instantiation and connection
  val DataResponser = for (i <- 0 until numChannel) yield {
    val module = Module(new DataResponser(tcdmDataWidth = tcdmDataWidth) {
      override val desiredName = s"${module_name_prefix}_DataResponser"
    })
    io.tcdm_rsp(i) <> module.io.tcdm_rsp
    io.out.data(i) <> module.io.out.data
    io.out.ResponsorReady(i) := module.io.out.ResponsorReady
    module
  }
}

object DataResponserEmitter extends App {
  println(
    getVerilogString(new DataResponsers(tcdmDataWidth = 64, numChannel = 8))
  )
}
