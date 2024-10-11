package snax.readerWriter

import snax.utils._

import chisel3._
import chisel3.util._

// The reader takes the address from the AGU, offer to requestor, and responser collect the data from TCDM and pushed to FIFO packer to recombine into 512 bit data

class Reader(
    param: ReaderWriterParam,
    moduleNamePrefix: String = "unnamed_cluster"
) extends Module
    with RequireAsyncReset {

  override val desiredName = s"${moduleNamePrefix}_Reader"

  require(
    param.configurableByteMask == false,
    "Byte Mask is not supported in Reader"
  )

  val io = IO(new ReaderIO(param))

  // New Address Generator
  val addressgen = Module(
    new AddressGenUnit(
      param.aguParam,
      moduleNamePrefix = s"${moduleNamePrefix}_Reader"
    )
  )

  // Requestors to send address to TCDM
  val requestors = Module(
    new DataRequestors(
      tcdmDataWidth = param.tcdmParam.dataWidth,
      tcdmAddressWidth = param.tcdmParam.addrWidth,
      numChannel = param.tcdmParam.numChannel,
      isReader = true,
      moduleNamePrefix = s"${moduleNamePrefix}_Reader"
    )
  )

  // Responsors to receive the data from TCDM
  val responsers = Module(
    new DataResponsers(
      tcdmDataWidth = param.tcdmParam.dataWidth,
      numChannel = param.tcdmParam.numChannel,
      fifoDepth = param.bufferDepth,
      moduleNamePrefix = s"${moduleNamePrefix}_Reader"
    )
  )

  // Output FIFOs to combine the data from the output of responsers
  val dataBuffer = Module(
    new ComplexQueueConcat(
      inputWidth = param.tcdmParam.dataWidth,
      outputWidth = param.tcdmParam.dataWidth * param.tcdmParam.numChannel,
      depth = param.bufferDepth,
      pipe = true
    ) {
      override val desiredName = s"${moduleNamePrefix}_Reader_DataBuffer"
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
  if (param.configurableChannel) {
    requestors.io.zip(io.readerwriterCfg.enabledChannel.asBools).foreach {
      case (requestor, enable) => {
        requestor.enable := enable
      }
    }
    responsers.io.zip(io.readerwriterCfg.enabledChannel.asBools).foreach {
      case (responser, enable) => {
        responser.enable := enable
      }
    }
  } else {
    requestors.io.foreach(_.enable := true.B)
    responsers.io.foreach(_.enable := true.B)
  }

  if (param.configurableByteMask)
    requestors.io.foreach(_.in.strb := io.readerwriterCfg.enabledByte)
  else
    requestors.io.foreach { case requestor =>
      requestor.in.strb := Fill(requestor.in.strb.getWidth, 1.U)
    }

  // ReqRsp Link to exchange necessary data
  requestors.io.zip(responsers.io).foreach {
    case (requestor, responser) => {
      requestor.reqrspLink.rspReady.get := responser.reqrspLink.rspReady
      responser.reqrspLink.reqSubmit := requestor.reqrspLink.reqSubmit.get
    }
  }

  // Req & Rsp <> TCDM
  requestors.io.zip(io.tcdmReq).foreach {
    case (requestor, tcdmReq) => {
      requestor.out.tcdmReq <> tcdmReq
    }
  }
  responsers.io.zip(io.tcdmRsp).foreach {
    case (responser, tcdmRsp) => {
      responser.in.tcdmRsp <> tcdmRsp
    }
  }
  // Responser <> DataBuffer, Data Link + dataFifoPopped
  dataBuffer.io.in.zip(responsers.io).foreach {
    case (buffer, responser) => {
      buffer <> responser.out.data
    }
  }
  responsers.io.foreach(_.out.dataFifoPopped := dataBuffer.io.out.head.fire)

  // DataBuffer <> Output
  if (param.crossClockDomain == false) {
    // Condition 1: When there is no clock crossing
    dataBuffer.io.out.head <> io.data
  } else {
    // Condition 2: When there is clock crossing
    val clockDomainCrosser = Module(
      new AsyncQueue(chiselTypeOf(dataBuffer.io.out.head.bits)) {
        override val desiredName =
          s"${moduleNamePrefix}_Reader_ClockDomainCrosser"
      }
    )
    clockDomainCrosser.io.enq.clock := clock
    clockDomainCrosser.io.deq.clock := io.accClock.get
    dataBuffer.io.out.head <> clockDomainCrosser.io.enq.data
    io.data <> clockDomainCrosser.io.deq.data
  }
  // Busy Signal
  io.busy := addressgen.io.busy | (~addressgen.io.bufferEmpty)

  // The debug signal from the dataBuffer to see if AGU and requestor / responser work correctly: It should be high when valid signal at the combined output is low
  io.bufferEmpty := dataBuffer.io.allEmpty
}

object ReaderEmitter extends App {
  println(
    getVerilogString(
      new Reader(
        new ReaderWriterParam(
          tcdmDataWidth = 512,
          numChannel = 1,
          spatialBounds = List(1)
        )
      )
    )
  )
}
