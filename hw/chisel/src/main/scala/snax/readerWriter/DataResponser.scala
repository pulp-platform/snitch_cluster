package snax.readerWriter

import chisel3._
import chisel3.util._

import snax.utils._

/** DataResponser's IO definition: io.in: From TCDM, see Xiaoling's definition to compatible with her wrapper
  * io.out.data: Decoupled(UInt), to store the data to FIFO at the outside io.out.ResponsorReady: Bool(), to determine
  * whether the Requestor can intake more data (dpending on whether the output FIFO is full)
  */

class DataResponserIO(tcdmDataWidth: Int = 64, numChannel: Int = 8) extends Bundle {
  val in         = new Bundle {
    val tcdmRsp = Flipped(Valid(new RegRsp(tcdmDataWidth = tcdmDataWidth)))
  }
  val out        = new Bundle {
    val data           = Decoupled(UInt(tcdmDataWidth.W))
    val dataFifoPopped = Input(Bool())
  }
  val enable     = Input(Bool())
  val reqrspLink = new Bundle {
    val rspReady  = Output(Bool())
    val reqSubmit = Input(Bool())
  }
}

class DataResponser(tcdmDataWidth: Int, fifoDepth: Int, moduleNamePrefix: String = "unnamed_cluster")
    extends Module
    with RequireAsyncReset {
  override val desiredName = s"${moduleNamePrefix}_DataResponser"
  val io                   = IO(new DataResponserIO(tcdmDataWidth = tcdmDataWidth))
  when(io.enable) {
    io.out.data.valid := io.in.tcdmRsp.valid // io.out's validity is determined by TCDM's side
    io.out.data.bits  := io.in.tcdmRsp.bits.data
  } otherwise {
    io.out.data.valid := io.reqrspLink.reqSubmit // io.out's validity is determined by whether the Requestor submit the fake request
    io.out.data.bits := 0.U
  }

  // The responsorReady Ctrl Logic
  // Implemented by a bi-directional counter
  // If the dataBuffer is full and there is no data sent from the output, then the Responsor is not ready to intake more data
  val fifoUtilizationCounter = Module(new UpDownCounter(log2Up(fifoDepth + 1)) {
    override val desiredName = s"${moduleNamePrefix}_FifoUtilizationCounter"
  })
  fifoUtilizationCounter.io.ceil := (fifoDepth + 1).U
  fifoUtilizationCounter.io.reset    := 0.U
  fifoUtilizationCounter.io.tickUp   := io.reqrspLink.reqSubmit
  fifoUtilizationCounter.io.tickDown := io.out.dataFifoPopped
  io.reqrspLink.rspReady             := ~fifoUtilizationCounter.io.lastVal || io.out.dataFifoPopped
}

// In this module is the multiple instantiation of DataRequestor. No Buffer is required from the data requestor's side, as it will be done at the outside.

class DataResponsers(
  tcdmDataWidth:    Int    = 64,
  numChannel:       Int    = 8,
  fifoDepth:        Int,
  moduleNamePrefix: String = "unnamed_cluster"
) extends Module
    with RequireAsyncReset {
  val io                   = IO(
    Vec(numChannel, new DataResponserIO(tcdmDataWidth = tcdmDataWidth))
  )
  override val desiredName = s"${moduleNamePrefix}_DataResponsers"
  // Instantiation and connection
  val DataResponser        = for (i <- 0 until numChannel) yield {
    val module = Module(
      new DataResponser(
        tcdmDataWidth    = tcdmDataWidth,
        fifoDepth        = fifoDepth,
        moduleNamePrefix = moduleNamePrefix
      )
    )
    io(i) <> module.io
    module
  }
}

object DataResponserEmitter extends App {
  println(
    getVerilogString(
      new DataResponsers(tcdmDataWidth = 64, numChannel = 8, fifoDepth = 8)
    )
  )
}
