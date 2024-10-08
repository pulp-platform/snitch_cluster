package snax.readerWriter

import snax.utils._

import chisel3._
import chisel3.util._

class ReaderWriterCfgIO(val param: ReaderWriterParam) extends Bundle {
  val enabledByte =
    if (param.configurableByteMask)
      UInt((param.tcdmParam.dataWidth / 8).W)
    else UInt(0.W)
  val enabledChannel =
    if (param.configurableChannel)
      UInt(param.tcdmParam.numChannel.W)
    else UInt(0.W)

  def connectWithList(csrList: IndexedSeq[UInt]): IndexedSeq[UInt] = {
    var remaincsrList = csrList
    if (param.configurableChannel) {
      enabledChannel := remaincsrList.head
      remaincsrList = remaincsrList.tail
    } else {
      enabledChannel := Fill(param.tcdmParam.numChannel, 1.U)
    }
    if (param.configurableByteMask) {
      enabledByte := remaincsrList.head
      remaincsrList = remaincsrList.tail
    } else {
      enabledByte := Fill(param.tcdmParam.dataWidth / 8, 1.U)
    }
    remaincsrList
  }
}

abstract class ReaderWriterCommomIO(val param: ReaderWriterParam)
    extends Bundle {
  // The signal to control address generator
  val aguCfg = Input(new AddressGenUnitCfgIO(param.aguParam))
  // The signal to control which byte is written to TCDM
  val readerwriterCfg = Input(new ReaderWriterCfgIO(param))
  // The port to feed in the clock signal from acc
  val accClock = if (param.crossClockDomain) Some(Input(Clock())) else None

  def connectCfgWithList(csrList: IndexedSeq[UInt]): IndexedSeq[UInt] = {
    var remaincsrList = csrList
    remaincsrList = aguCfg.connectWithList(remaincsrList)
    remaincsrList = readerwriterCfg.connectWithList(remaincsrList)
    remaincsrList
  }

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
