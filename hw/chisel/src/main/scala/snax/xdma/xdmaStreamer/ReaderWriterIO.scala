package snax.xdma.xdmaStreamer

import chisel3._
import chisel3.util._

import snax.utils._
import snax.xdma.DesignParams._

abstract class ReaderWriterCommomIO(val param: ReaderWriterParam)
    extends Bundle {
  // The signal to control address generator
  val cfg = Input(new AddressGenUnitCfgIO(param.aguParam))
  // The signal to control which byte is written to TCDM
  val strb =
    if (param.configurableByteMask)
      Input(UInt((param.tcdmParam.dataWidth / 8).W))
    else Input(UInt(0.W))

  // The signal trigger the start of Address Generator. The non-empty of address generator will cause data requestor to read the data
  val start = Input(Bool())
  // The module is busy if addressgen is busy or fifo in addressgen is not empty
  val busy = Output(Bool())
  // The buffer is empty
  val bufferEmpty = Output(Bool())
}

trait HasTCDMRequestor {
  this: ReaderWriterCommomIO =>
  val tcdmReq = Vec(
    param.tcdmParam.numChannel,
    Decoupled(
      new TcdmReq(
        addrWidth = param.tcdmParam.addrWidth,
        tcdmDataWidth = param.tcdmParam.dataWidth
      )
    )
  )
}

trait HasTCDMResponder {
  this: ReaderWriterCommomIO =>
  val tcdmRsp = Vec(
    param.tcdmParam.numChannel,
    Flipped(Valid(new TcdmRsp(tcdmDataWidth = param.tcdmParam.dataWidth)))
  )
}

trait HasInputDataIO {
  this: ReaderWriterCommomIO =>
  val data = Flipped(
    Decoupled(
      UInt((param.tcdmParam.dataWidth * param.tcdmParam.numChannel).W)
    )
  )
}

trait HasOutputDataIO {
  this: ReaderWriterCommomIO =>
  val data = Decoupled(
    UInt((param.tcdmParam.dataWidth * param.tcdmParam.numChannel).W)
  )
}

class ReaderIO(param: ReaderWriterParam)
    extends ReaderWriterCommomIO(param)
    with HasTCDMRequestor
    with HasTCDMResponder
    with HasOutputDataIO

class WriterIO(param: ReaderWriterParam)
    extends ReaderWriterCommomIO(param)
    with HasTCDMRequestor
    with HasInputDataIO

class ReaderWriterIO(
    readerParam: ReaderWriterParam,
    writerParam: ReaderWriterParam
) extends Bundle {
  // As they share the same TCDM interface, different number of channel is meaningless
  require(
    readerParam.tcdmParam.numChannel == writerParam.tcdmParam.numChannel
  )
  // Full-funcional Reader interface
  val readerInterface = new ReaderIO(readerParam)
  // Writer interface without TCDM port
  val writerInterface = new ReaderWriterCommomIO(writerParam)
    with HasInputDataIO
}
