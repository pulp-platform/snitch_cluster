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
    val data =
      if (!isReader) Some(Flipped(Decoupled(UInt(tcdmDataWidth.W)))) else None
    val strb = Input(UInt((tcdmDataWidth / 8).W))
  }

  val out = new Bundle {
    val tcdm_req = Decoupled(new TcdmReq(tcdmAddressWidth, tcdmDataWidth))
  }
  val enable = Input(Bool())
  val RequestorResponserLink = new Bundle {
    val ResponsorReady = if (isReader) Some(Input(Bool())) else None
    val RequestorSubmit = if (isReader) Some(Output(Bool())) else None
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
    val data =
      if (!isReader)
        Some(Vec(numChannel, Flipped(Decoupled(UInt(tcdmDataWidth.W)))))
      else None
    val strb = Input(UInt((tcdmDataWidth / 8).W))
  }
  val out = new Bundle {
    val tcdm_req =
      Vec(numChannel, Decoupled(new TcdmReq(tcdmAddressWidth, tcdmDataWidth)))
  }

  val enable = Vec(numChannel, Input(Bool()))

  val RequestorResponserLink = new Bundle {
    val ResponsorReady =
      if (isReader) Some(Vec(numChannel, Input(Bool()))) else None
    val RequestorSubmit =
      if (isReader) Some(Vec(numChannel, Output(Bool()))) else None
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
  // Or this channel is disabled
  // Because if enable is 0, Reader will always write 0 to databuffer and writer does nothing at all, so the address is popped out if there is place to write 0 (reader case) or unconditionally (writer case)
  when(io.enable) {
    io.in.addr.ready := {
      if (isReader)
        io.RequestorResponserLink.ResponsorReady.get && io.out.tcdm_req.fire
      else io.out.tcdm_req.fire
    }
  }.otherwise {
    io.in.addr.ready := {
      if (isReader) io.RequestorResponserLink.ResponsorReady.get
      else true.B
    }
  }

  if (isReader) {
    io.RequestorResponserLink.RequestorSubmit.get := io.in.addr.fire
  }

  // If is writer, data is poped out with address (synchronous)
  if (!isReader) {
    io.in.data.get.ready := io.in.addr.ready
  }

  // If is reader, the mask is always 1 because tcdm ignore it;
  // Else, the mask is connected to the tcdm requestor to indicate which byte is valid
  io.out.tcdm_req.bits.strb := io.in.strb

  // If is writer, the data port is ready to receive data when there is a valid address
  if (!isReader) {
    io.in.data.get.ready := io.in.addr.ready
  }

  io.out.tcdm_req.bits.addr := io.in.addr.bits
  io.out.tcdm_req.bits.write := { if (isReader) 0.U else 1.U }
  io.out.tcdm_req.bits.data := { if (isReader) 0.U else io.in.data.get.bits }

  // If is reader, tcdm's valid signal depends on address queue and the responser's ready queue; otherwise, it depends on address queue and the requestor's data queue
  when(io.enable) {
    io.out.tcdm_req.valid := {
      if (isReader)
        (io.in.addr.valid && io.RequestorResponserLink.ResponsorReady.get)
      else (io.in.addr.valid && io.in.data.get.valid)
    }
  }.otherwise {
    io.out.tcdm_req.valid := false.B
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
    numChannel: Int,
    module_name_prefix: String = "unnamed_cluster"
) extends Module
    with RequireAsyncReset {
  override val desiredName = s"${module_name_prefix}_DataRequestors"
  val io = IO(
    new DataRequestorsIO(tcdmDataWidth, tcdmAddressWidth, isReader, numChannel)
  )
  val DataRequestor = for (i <- 0 until numChannel) yield {
    val module = Module(
      new DataRequestor(tcdmDataWidth, tcdmAddressWidth, isReader) {
        override def desiredName = s"${module_name_prefix}_DataRequestor"
      }
    )

    // Address is unconditionally connected
    io.in.addr(i) <> module.io.in.addr
    // Enable signal is unconditionally connected
    module.io.enable := io.enable(i)
    // For readers, the responser ready and requestor submit signal is connected
    if (isReader) {
      module.io.RequestorResponserLink.ResponsorReady.get := io.RequestorResponserLink.ResponsorReady
        .get(i)
      io.RequestorResponserLink.RequestorSubmit.get(
        i
      ) := module.io.RequestorResponserLink.RequestorSubmit.get
    }
    // For writers, the data interface is connected
    if (!isReader) module.io.in.data.get <> io.in.data.get(i)

    // Connect the strobe signal
    module.io.in.strb := io.in.strb

    // Connect the output to the tcdm request
    io.out.tcdm_req(i) <> module.io.out.tcdm_req

    // Return the module for the future usage
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
