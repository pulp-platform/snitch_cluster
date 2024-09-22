package snax.readerWriter

import snax.utils._

import chisel3._
import chisel3.util._

/** DataRequestor's IO definition: io.in.address: Decoupled(UInt) io.in.data:
  * Some(Decoupled(UInt)) or None io.in.ResponsorReady: Some(Bool()) or None
  * io.out: Toward TCDM, see Xiaoling's definition to compatible with her
  * wrapper: TypeDefine.scala
  */
class DataRequestorIO(
    tcdmDataWidth: Int,
    tcdmAddressWidth: Int,
    isReader: Boolean
) extends Bundle {
  val in = new Bundle {
    val addr = Flipped(Decoupled(UInt(tcdmAddressWidth.W)))
    val data =
      if (!isReader) Some(Flipped(Decoupled(UInt(tcdmDataWidth.W)))) else None
    val strb = Input(UInt((tcdmDataWidth / 8).W))
  }

  val out = new Bundle {
    val tcdmReq = Decoupled(new TcdmReq(tcdmAddressWidth, tcdmDataWidth))
  }
  val enable = Input(Bool())
  val reqrspLink = new Bundle {
    val rspReady = if (isReader) Some(Input(Bool())) else None
    val reqSubmit = if (isReader) Some(Output(Bool())) else None
  }
}

// When the requestor is reader, it has to consider the received fifo is full or not
// When the reqeustor is writer, it only has req_valid and ignore the Responsor ready

class DataRequestor(
    tcdmDataWidth: Int,
    tcdmAddressWidth: Int,
    isReader: Boolean
) extends Module
    with RequireAsyncReset {
  val io = IO(new DataRequestorIO(tcdmDataWidth, tcdmAddressWidth, isReader))
  // address queue is popped out if responser is ready and current is acknowldged by the tcdm
  // Or this channel is disabled
  // Because if enable is 0, Reader will always write 0 to databuffer and writer does nothing at all, so the address is popped out if there is place to write 0 (reader case) or unconditionally (writer case)
  when(io.enable) {
    io.in.addr.ready := io.out.tcdmReq.fire
  }.otherwise {
    io.in.addr.ready := { if (isReader) io.reqrspLink.rspReady.get else true.B }
  }

  if (isReader) {
    io.reqrspLink.reqSubmit.get := io.in.addr.fire
  }

  // If is writer, data is poped out with address (synchronous)
  if (!isReader) {
    io.in.data.get.ready := io.in.addr.ready
  }

  // If is reader, the mask is always 1 because tcdm ignore it;
  // Else, the mask is connected to the tcdm requestor to indicate which byte is valid
  io.out.tcdmReq.bits.strb := io.in.strb

  io.out.tcdmReq.bits.addr := io.in.addr.bits
  io.out.tcdmReq.bits.write := { if (isReader) 0.U else 1.U }
  io.out.tcdmReq.bits.data := { if (isReader) 0.U else io.in.data.get.bits }

  // If is reader, tcdm's valid signal depends on address queue and the responser's ready queue; otherwise, it depends on address queue and the requestor's data queue
  when(io.enable) {
    io.out.tcdmReq.valid := {
      if (isReader)
        (io.in.addr.valid && io.reqrspLink.rspReady.get)
      else (io.in.addr.valid && io.in.data.get.valid)
    }
  }.otherwise {
    io.out.tcdmReq.valid := false.B
  }
}

// In this module is the multiple instantiation of DataRequestor. No Buffer is required from the data requestor's side, as it will be done at the outside.
class DataRequestors(
    tcdmDataWidth: Int,
    tcdmAddressWidth: Int,
    isReader: Boolean,
    numChannel: Int,
    moduleNamePrefix: String = "unnamed_cluster"
) extends Module
    with RequireAsyncReset {
  override val desiredName = s"${moduleNamePrefix}_DataRequestors"
  val io = IO(
    Vec(
      numChannel,
      new DataRequestorIO(tcdmDataWidth, tcdmAddressWidth, isReader)
    )
  )
  // new DataRequestorsIO(tcdmDataWidth, tcdmAddressWidth, isReader, numChannel)
  val DataRequestor = for (i <- 0 until numChannel) yield {
    val module = Module(
      new DataRequestor(tcdmDataWidth, tcdmAddressWidth, isReader) {
        override def desiredName = s"${moduleNamePrefix}_DataRequestor"
      }
    )

    // Connect the IO
    io(i) <> module.io
    module
  }
}

object DataRequestorTester extends App {
  emitVerilog(
    new DataRequestor(64, 16, true),
    Array("--target-dir", "generated")
  )
}

object DataRequestorsTester extends App {
  emitVerilog(
    new DataRequestors(64, 16, false, 2),
    Array("--target-dir", "generated")
  )
}
