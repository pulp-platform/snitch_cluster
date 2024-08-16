package snax.xdma.xdmaStreamer

import chisel3._
import chisel3.util._

import snax.utils._
import snax.xdma.CommonCells._
import snax.xdma.DesignParams._

// ReaderWriter is the module that has a reader port and writer port, but they share one TCDM interface.
// This is suitable for the case that the throughput is not high.

class ReaderWriter(
    readerParam: ReaderWriterParam,
    writerParam: ReaderWriterParam,
    clusterName: String = "unnamed_cluster"
) extends Module
    with RequireAsyncReset {

  override val desiredName = s"${clusterName}_xdma_ReaderWriter"

  // As they share the same TCDM interface, different number of channel is meaningless
  require(
    readerParam.tcdmParam.numChannel == writerParam.tcdmParam.numChannel
  )

  val io = IO(new Bundle {
    val readerCfg = Input(new AddressGenUnitCfgIO(readerParam.aguParam))
    val writerCfg = Input(new AddressGenUnitCfgIO(writerParam.aguParam))
    val tcdmReq = Vec(
      readerParam.tcdmParam.numChannel,
      Decoupled(
        new TcdmReq(
          addrWidth = readerParam.tcdmParam.addrWidth,
          tcdmDataWidth = readerParam.tcdmParam.dataWidth
        )
      )
    )
    val tcdmRsp = Vec(
      readerParam.tcdmParam.numChannel,
      Flipped(
        Valid(new TcdmRsp(tcdmDataWidth = readerParam.tcdmParam.dataWidth))
      )
    )
    val readerData = Decoupled(
      UInt(
        (readerParam.tcdmParam.dataWidth * readerParam.tcdmParam.numChannel).W
      )
    )
    val writerData = Flipped(
      Decoupled(
        UInt(
          (writerParam.tcdmParam.dataWidth * writerParam.tcdmParam.numChannel).W
        )
      )
    )
    // The signal to control which byte is read from or written to TCDM
    val readerStrb = Input(UInt((readerParam.tcdmParam.dataWidth / 8).W))
    val writerStrb = Input(UInt((writerParam.tcdmParam.dataWidth / 8).W))
    // The signal trigger the start of Address Generator. The non-empty of address generator will cause data requestor to read the data
    val readerStart = Input(Bool())
    val writerStart = Input(Bool())
    // The module is busy if addressgen is busy or fifo in addressgen is not empty
    val readerBusy = Output(Bool())
    val writerBusy = Output(Bool())
    // The data buffer is empty
    val readerBufferEmpty = Output(Bool())
    val writerBufferEmpty = Output(Bool())
  })

  // Reader
  val reader = Module(
    new Reader(
      readerParam,
      clusterName = s"${clusterName}_RWReader"
    )
  )

  reader.io.cfg := io.readerCfg
  reader.io.data <> io.readerData
  reader.io.strb := io.readerStrb
  reader.io.start := io.readerStart
  io.readerBusy := reader.io.busy
  io.readerBufferEmpty := reader.io.bufferEmpty

  // Writer
  val writer = Module(
    new Writer(
      writerParam,
      clusterName = s"${clusterName}_RWWriter"
    )
  )

  writer.io.cfg := io.writerCfg
  writer.io.data <> io.writerData
  writer.io.strb := io.writerStrb
  writer.io.start := io.writerStart
  io.writerBusy := writer.io.busy
  io.writerBufferEmpty := writer.io.bufferEmpty

  // Both reader and writer share the same Request interface
  val readerwriterArbiter = Seq.fill(readerParam.tcdmParam.numChannel)(
    Module(
      new Arbiter(
        new TcdmReq(
          readerParam.tcdmParam.addrWidth,
          readerParam.tcdmParam.dataWidth
        ),
        2
      )
    )
  )

  // Writer has the higher priority, and reversely connected to avoid contention when some channels are turned off
  readerwriterArbiter.reverse.zip(writer.io.tcdmReq).foreach {
    case (arbiter, writerReq) => arbiter.io.in(0) <> writerReq
  }

  // Reader has the lower priority
  readerwriterArbiter.zip(reader.io.tcdmReq).foreach {
    case (arbiter, readerReq) => arbiter.io.in(1) <> readerReq
  }

  // Connect the arbiter to the TCDM interface
  readerwriterArbiter.zip(io.tcdmReq).foreach { case (arbiter, tcdmReq) =>
    tcdmReq <> arbiter.io.out
  }

  // Connect the response from TCDM to the reader
  io.tcdmRsp <> reader.io.tcdmRsp
}

object ReaderWriterEmitter extends App {
  println(
    getVerilogString(
      new ReaderWriter(new ReaderWriterParam, new ReaderWriterParam)
    )
  )
}
