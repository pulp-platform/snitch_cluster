package snax.xdma.xdmaStreamer

import chisel3._
import chisel3.util._

import snax.utils._
import snax.xdma.CommonCells._
import snax.xdma.DesignParams._

// The reader takes the address from the AGU, offer to requestor, and responser collect the data from TCDM and pushed to FIFO packer to recombine into 512 bit data

class Reader(param: ReaderWriterParam, clusterName: String = "unnamed_cluster")
    extends Module
    with RequireAsyncReset {

  override val desiredName = s"${clusterName}_xdma_Reader"

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
    val tcdmRsp = Vec(
      param.tcdmParam.numChannel,
      Flipped(Valid(new TcdmRsp(tcdmDataWidth = param.tcdmParam.dataWidth)))
    )
    val data = Decoupled(
      UInt((param.tcdmParam.dataWidth * param.tcdmParam.numChannel).W)
    )
    // The signal to control which byte is written to TCDM
    val strb = Input(UInt((param.tcdmParam.dataWidth / 8).W))
    // The signal trigger the start of Address Generator. The non-empty of address generator will cause data requestor to read the data
    val start = Input(Bool())
    // The module is busy if addressgen is busy or fifo in addressgen is not empty
    val busy = Output(Bool())
    // The reader's buffer is empty
    val bufferEmpty = Output(Bool())

  })

  // New Address Generator
  val addressgen = Module(
    new AddressGenUnit(
      param.aguParam,
      module_name_prefix = s"${clusterName}_xdma_Reader"
    )
  )

  // Requestors to send address to TCDM
  val requestors = Module(
    new DataRequestors(
      tcdmDataWidth = param.tcdmParam.dataWidth,
      tcdmAddressWidth = param.tcdmParam.addrWidth,
      numChannel = param.tcdmParam.numChannel,
      isReader = true,
      module_name_prefix = s"${clusterName}_xdma_Reader"
    )
  )

  // Responsors to receive the data from TCDM
  val responsers = Module(
    new DataResponsers(
      tcdmDataWidth = param.tcdmParam.dataWidth,
      numChannel = param.tcdmParam.numChannel,
      module_name_prefix = s"${clusterName}_xdma_Reader"
    )
  )

  // Output FIFOs to combine the data from the output of responsers
  val dataBuffer = Module(
    new ComplexQueueConcat(
      inputWidth = param.tcdmParam.dataWidth,
      outputWidth = param.tcdmParam.dataWidth * param.tcdmParam.numChannel,
      depth = param.bufferDepth
    ) {
      override val desiredName = s"${clusterName}_xdma_Reader_DataBuffer"
    }
  )

  addressgen.io.cfg := io.cfg
  addressgen.io.start := io.start
  requestors.io.in.addr <> addressgen.io.addr
  requestors.io.enable := addressgen.io.enabled_channels
  responsers.io.enable := addressgen.io.enabled_channels
  requestors.io.in.strb := io.strb
  requestors.io.RequestorResponserLink.ResponsorReady.get := responsers.io.RequestorResponserLink.ResponsorReady
  responsers.io.RequestorResponserLink.RequestorSubmit := requestors.io.RequestorResponserLink.RequestorSubmit.get
  requestors.io.out.tcdmReq <> io.tcdmReq
  responsers.io.in.tcdmRsp <> io.tcdmRsp
  dataBuffer.io.in <> responsers.io.out.data
  dataBuffer.io.out.head <> io.data

  io.busy := addressgen.io.busy | (~addressgen.io.bufferEmpty)

  // The debug signal from the dataBuffer to see if AGU and requestor / responser works correctly: It should be high when valid signal at the combined output is low
  io.bufferEmpty := dataBuffer.io.allEmpty
}

object ReaderEmitter extends App {
  println(getVerilogString(new Reader(new ReaderWriterParam)))
}
