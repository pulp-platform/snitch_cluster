package snax.readerWriter

import snax.utils._

import chisel3._
import chisel3.util._

class Writer(
    param: ReaderWriterParam,
    moduleNamePrefix: String = "unnamed_cluster"
) extends Module
    with RequireAsyncReset {

  override val desiredName = s"${moduleNamePrefix}_Writer"

  val io = IO(new WriterIO(param))

  // New Address Generator
  val addressgen = Module(
    new AddressGenUnit(
      param.aguParam,
      moduleNamePrefix = s"${moduleNamePrefix}_Writer"
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
      moduleNamePrefix = s"${moduleNamePrefix}_Writer"
    )
  )

  val dataBuffer = Module(
    new ComplexQueueConcat(
      inputWidth = param.tcdmParam.dataWidth * param.tcdmParam.numChannel,
      outputWidth = param.tcdmParam.dataWidth,
      depth = param.bufferDepth,
      pipe = false
    ) {
      override val desiredName = s"${moduleNamePrefix}_Writer_DataBuffer"
    }
  )

  addressgen.io.cfg := io.aguCfg
  addressgen.io.start := io.start

  // addrgen <> requestors
  requestors.io.zip(addressgen.io.addr).foreach {
    case (requestor, addrgen) => {
      requestor.in.addr <> addrgen
    }
  }

  // enabledChannel & enabledByteMask
  if (param.configurableChannel)
    requestors.io.zip(io.readerwriterCfg.enabledChannel.asBools).foreach {
      case (requestor, enable) => {
        requestor.enable := enable
      }
    }
  else requestors.io.foreach(_.enable := true.B)

  if (param.configurableByteMask)
    requestors.io.foreach(_.in.strb := io.readerwriterCfg.enabledByte)
  else
    requestors.io.zipWithIndex.foreach {
      case (requestor, i) => {
        requestor.in.strb := Fill(requestor.in.strb.getWidth, 1.U)
      }
    }

  // Requestor <> TCDM
  requestors.io.zip(io.tcdmReq).foreach {
    case (requestor, tcdmReq) => {
      requestor.out.tcdmReq <> tcdmReq
    }
  }

  // Requestor <> DataBuffer, Data Link
  requestors.io.zip(dataBuffer.io.out).foreach {
    case (requestor, dataBuffer) => {
      requestor.in.data.get <> dataBuffer
    }
  }

  // DataBuffer <> Input
  if (param.crossClockDomain == false) { dataBuffer.io.in.head <> io.data }
  else {
    val clockDomainCrosser = Module(
      new AsyncQueue(chiselTypeOf(dataBuffer.io.in.head.bits)) {
        override val desiredName =
          s"${moduleNamePrefix}_Writer_ClockDomainCrosser"
      }
    )
    clockDomainCrosser.io.enq.clock := io.accClock.get
    clockDomainCrosser.io.deq.clock := clock
    clockDomainCrosser.io.enq.data <> io.data
    dataBuffer.io.in.head <> clockDomainCrosser.io.deq.data
  }
  // Busy Signal
  io.busy := addressgen.io.busy | (~addressgen.io.bufferEmpty)

  // The debug signal from the dataBuffer to see if AGU and requestor work correctly: It should be high when valid signal at the combined output is low
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
