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

  val io = IO(new ReaderWriterIO(readerParam, writerParam))

  // Reader
  val reader = Module(
    new Reader(
      readerParam,
      clusterName = s"${clusterName}_RWReader"
    )
  )

  reader.io.aguCfg := io.readerInterface.aguCfg
  reader.io.readerwriterCfg := io.readerInterface.readerwriterCfg
  reader.io.data <> io.readerInterface.data
  reader.io.start := io.readerInterface.start
  io.readerInterface.busy := reader.io.busy
  io.readerInterface.bufferEmpty := reader.io.bufferEmpty

  // Writer
  val writer = Module(
    new Writer(
      writerParam,
      clusterName = s"${clusterName}_RWWriter"
    )
  )

  writer.io.aguCfg := io.writerInterface.aguCfg
  writer.io.readerwriterCfg := io.writerInterface.readerwriterCfg
  writer.io.data <> io.writerInterface.data
  writer.io.start := io.writerInterface.start
  io.writerInterface.busy := writer.io.busy
  io.writerInterface.bufferEmpty := writer.io.bufferEmpty

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
  readerwriterArbiter.zip(io.readerInterface.tcdmReq).foreach {
    case (arbiter, tcdmReq) =>
      tcdmReq <> arbiter.io.out
  }

  // Connect the response from TCDM to the reader
  io.readerInterface.tcdmRsp <> reader.io.tcdmRsp
}

object ReaderWriterEmitter extends App {
  println(
    getVerilogString(
      new ReaderWriter(new ReaderWriterParam, new ReaderWriterParam)
    )
  )
}
