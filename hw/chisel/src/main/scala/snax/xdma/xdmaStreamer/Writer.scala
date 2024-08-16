package snax.xdma.xdmaStreamer

import chisel3._
import chisel3.util._

import snax.utils._

import snax.xdma.CommonCells._
import snax.xdma.DesignParams._

class Writer(param: ReaderWriterParam, clusterName: String = "unnamed_cluster")
    extends Module
    with RequireAsyncReset {

  override val desiredName = s"${clusterName}_xdma_Writer"

  val io = IO(new Bundle {
    val cfg = Input(new AddressGenUnitCfgIO(param.aguParam))
    val tcdmReq = Vec(
      param.tcdmParam.numChannel,
      Decoupled(
        new TcdmReq(
          addrWidth = param.tcdmParam.addrWidth,
          tcdmDataWidth = param.tcdmParam.dataWidth
        )
      )
    )
    val data = Flipped(
      Decoupled(
        UInt((param.tcdmParam.dataWidth * param.tcdmParam.numChannel).W)
      )
    )
    // The signal to control which byte is written to TCDM
    val strb = Input(UInt((param.tcdmParam.dataWidth / 8).W))
    // The signal trigger the start of Address Generator. The non-empty of address generator will cause data requestor to read the data
    val start = Input(Bool())
    // The module is busy if addressgen is busy or fifo in addressgen is not empty
    val busy = Output(Bool())
    // Both the AGU FIFO and data FIFO are empty
    val bufferEmpty = Output(Bool())
  })

  // New Address Generator
  val addressgen = Module(
    new AddressGenUnit(
      param.aguParam,
      module_name_prefix = s"${clusterName}_xdma_Writer"
    )
  )

  // Write Requestors
  // Requestors to send address and data to TCDM
  val requestors = Module(
    new DataRequestors(
      tcdmDataWidth = param.tcdmParam.dataWidth,
      tcdmAddressWidth = param.tcdmParam.addrWidth,
      numChannel = param.tcdmParam.numChannel,
      isReader = false,
      module_name_prefix = s"${clusterName}_xdma_Writer"
    )
  )

  val dataBuffer = Module(
    new ComplexQueueConcat(
      inputWidth = param.tcdmParam.dataWidth * param.tcdmParam.numChannel,
      outputWidth = param.tcdmParam.dataWidth,
      depth = param.bufferDepth
    ) {
      override val desiredName = s"${clusterName}_xdma_Writer_DataBuffer"
    }
  )

  addressgen.io.cfg := io.cfg
  addressgen.io.start := io.start

  requestors.io.enable := addressgen.io.enabled_channels
  requestors.io.in.addr <> addressgen.io.addr
  requestors.io.in.data.get <> dataBuffer.io.out
  requestors.io.out.tcdmReq <> io.tcdmReq
  requestors.io.in.strb := io.strb

  dataBuffer.io.in.head <> io.data
  io.busy := addressgen.io.busy | (~addressgen.io.bufferEmpty)
  // Debug Signal
  io.bufferEmpty := addressgen.io.bufferEmpty & dataBuffer.io.allEmpty
}

object WriterPrinter extends App {
  println(getVerilogString(new Writer(new ReaderWriterParam)))
}

object WriterEmitter extends App {
  emitVerilog(
    new Writer(new ReaderWriterParam),
    Array("--target-dir", "generated")
  )
}
