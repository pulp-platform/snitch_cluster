package snax.xdma.xdmaStreamer

import chisel3._
import chisel3.util._

import snax.utils._

// When the requestor is reader, it has to consider the received fifo is full or not
// When the reqeustor is writer, it only has req_valid and ignore the Responsor ready

class DataRequestorIO(
    tcdmDataWidth: Int,
    tcdmAddressWidth: Int,
    isReader: Boolean
) extends Bundle {
  val in = new Bundle {
    val addr = Flipped(Decoupled(UInt(tcdmAddressWidth.W)))
    val ResponsorReady = if (isReader) Some(Input(Bool())) else None
    val data =
      if (!isReader) Some(Flipped(Decoupled(UInt(tcdmDataWidth.W)))) else None
  }

  val out = new Bundle {
    val tcdm_req = Decoupled(new TcdmReq(tcdmAddressWidth, tcdmDataWidth))
  }

}

class DataRequestorsIO(
    tcdmDataWidth: Int,
    tcdmAddressWidth: Int,
    isReader: Boolean,
    numChannel: Int
) extends Bundle {
  val in = new Bundle {
    val addr = Vec(numChannel, Flipped(Decoupled(UInt(tcdmAddressWidth.W))))
    val ResponsorReady =
      if (isReader) Some(Vec(numChannel, Input(Bool()))) else None
    val data =
      if (!isReader)
        Some(Vec(numChannel, Flipped(Decoupled(UInt(tcdmDataWidth.W)))))
      else None
  }

  val out = new Bundle {
    val tcdm_req =
      Vec(numChannel, Decoupled(new TcdmReq(tcdmAddressWidth, tcdmDataWidth)))
  }

}

/** DataRequestor's IO definition: io.in.address: Decoupled(UInt) io.in.data:
  * Some(Decoupled(UInt)) or None io.in.ResponsorReady: Some(Bool()) or None
  * io.out: Toward TCDM, see Xiaoling's definition to compatible with her
  * wrapper: TypeDefine.scala
  */
class DataRequestor(
    tcdmDataWidth: Int,
    tcdmAddressWidth: Int,
    isReader: Boolean
) extends Module
    with RequireAsyncReset {
  val io = IO(new DataRequestorIO(tcdmDataWidth, tcdmAddressWidth, isReader))
  // address queue is popped out if responser is ready and current is acknowldged by the tcdm
  io.in.addr.ready := {
    if (isReader) io.in.ResponsorReady.get && io.out.tcdm_req.fire
    else io.out.tcdm_req.fire
  }

  // If is writer, data is poped out with address (synchronous)
  if (!isReader) {
    io.in.data.get.ready := io.in.addr.ready
  }

  io.out.tcdm_req.bits.addr := io.in.addr.bits
  io.out.tcdm_req.bits.write := { if (isReader) 0.U else 1.U }
  io.out.tcdm_req.bits.data := { if (isReader) 0.U else io.in.data.get.bits }

  // If is reader, tcdm's valid signal depends on address queue and the responser's ready queue; otherwise, it depends on address queue and the requestor's data queue
  io.out.tcdm_req.valid := {
    if (isReader) (io.in.addr.valid && io.in.ResponsorReady.get)
    else (io.in.addr.valid && io.in.data.get.valid)
  }

}

/** DataRequestors' IO definition: io.in.address: Vec(Decoupled(UInt))
  * io.in.data: Some(Vec(Decoupled(UInt))) or None io.in.ResponsorReady:
  * Some(Vec(Bool())) or None io.out: Toward TCDM, see Xiaoling's definition to
  * compatible with her wrapper
  */
// In this module is the multiple instantiation of DataRequestor. No Buffer is required from the data requestor's side, as it will be done at the outside.
class DataRequestors(
    tcdmDataWidth: Int,
    tcdmAddressWidth: Int,
    isReader: Boolean,
    numChannel: Int
) extends Module
    with RequireAsyncReset {
  val io = IO(
    new DataRequestorsIO(tcdmDataWidth, tcdmAddressWidth, isReader, numChannel)
  )
  val DataRequestor = for (i <- 0 until numChannel) yield {
    val module = Module(
      new DataRequestor(tcdmDataWidth, tcdmAddressWidth, isReader)
    )

    // Address is unconditionally connected
    io.in.addr(i) <> module.io.in.addr
    // For readers, the responser ready signal is connected
    if (isReader) module.io.in.ResponsorReady.get := io.in.ResponsorReady.get(i)

    // For writers, the data interface is connected
    if (!isReader) module.io.in.data.get <> io.in.data.get(i)
    io.out.tcdm_req(i) <> module.io.out.tcdm_req
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
