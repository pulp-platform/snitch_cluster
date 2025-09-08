package snax.reqRspManager

import chisel3._
import chisel3.util._

import snax.utils._

/** This class represents the reg input and output ports of the streamer top module
  *
  * @param addrWidth
  *   Registers address width
  */
class SnaxReqRspIO(addrWidth: Int, dataWidth: Int) extends Bundle {
  val req = Flipped(Decoupled(new RegReq(addrWidth = addrWidth, dataWidth = dataWidth)))
  val rsp = Decoupled(new RegRsp(dataWidth = dataWidth))
}

/** This class represents the input and output ports of the CsrManager module. The input is connected to the SNAX CSR
  * port. The output is connected to the streamer configuration port.
  * @param numReadWriteReg
  *   the number of read/write registers. These control registers are buffered and can only be written to by the manager
  *   core.
  * @param numReadOnlyReg
  *   the number of read only registers. These values are written to by the accelerator
  * @param addrWidth
  *   the width of the address
  */
class ReqRspManagerIO(
  numReadWriteReg: Int,
  numReadOnlyReg:  Int,
  addrWidth:       Int,
  ioDataWidth:     Int = 32,
  regDataWidth:    Int = 32
) extends Bundle {

  val reqRspIO       = new SnaxReqRspIO(addrWidth = addrWidth, dataWidth = ioDataWidth)
  val readWriteRegIO = Decoupled(Vec(numReadWriteReg, UInt(regDataWidth.W)))

  // Add extra input ports from accelerator side for the read only registers
  val readOnlyReg = Input(Vec(numReadOnlyReg, UInt(regDataWidth.W)))

}

/** This class represents the ReqRspManager module. It contains the csr registers and the read and write control logic.
  * It contains only one type of registers, eg. read and write CSR.
  * @param numReadWriteReg
  *   the number of read and write csr registers
  * @param numReadOnlyReg
  *   the number of read only csr registers
  * @param addrWidth
  *   the width of the address
  * @param ioDataWidth
  *   the data width of the ReqRsp interface
  * @param regDataWidth
  *   the data width of the registers connected to accelerators, must be smaller or equal to ioDataWidth
  * @param moduleTagName
  *   the module tag name, used in the generated verilog file name
  */
class ReqRspManager(
  numReadWriteReg: Int,
  numReadOnlyReg:  Int,
  addrWidth:       Int,
  ioDataWidth:     Int    = 32,
  regDataWidth:    Int    = 32,
  moduleTagName:   String = ""
) extends Module
    with RequireAsyncReset {
  override val desiredName = moduleTagName + "ReqRspManager"

  lazy val io = IO(new ReqRspManagerIO(numReadWriteReg, numReadOnlyReg, addrWidth, ioDataWidth, regDataWidth))
  io.suggestName("io")

  // Concatenate regDataWidth-bit registers into ioDataWidth-bit words
  assert(ioDataWidth  % regDataWidth == 0, "ioDataWidth must be a multiple of regDataWidth")
  assert(ioDataWidth >= regDataWidth, "regDataWidth must be less than or equal to ioDataWidth")
  val wordsPerBeat = ioDataWidth / regDataWidth

  // generate a vector of registers to store the csr state
  val regs = RegInit(VecInit(Seq.fill(numReadWriteReg)(0.U(regDataWidth.W))))

  // read write and start csr command
  val readReg  = io.reqRspIO.req.fire  && !io.reqRspIO.req.bits.write
  val writeReg = io.reqRspIO.req.fire  && io.reqRspIO.req.bits.write
  val startReg = io.reqRspIO.req.valid && io.reqRspIO.req.bits.write &&
    // The last address in the ReqRspManager
    (io.reqRspIO.req.bits.addr === ((numReadWriteReg - 1) / wordsPerBeat).U) &&
    // The strobe of LSB is 1 (will write the valid bit)
    (io.reqRspIO.req.bits
      .strb((numReadWriteReg - 1) % wordsPerBeat * regDataWidth / 8))        &&
    // The data is of LSB is non zero
    io.reqRspIO.req.bits.data((numReadWriteReg - 1) % wordsPerBeat * regDataWidth)
  val check_acc_status = io.reqRspIO.req.valid && io.reqRspIO.req.bits.write &&
    // The last address in the ReqRspManager
    (io.reqRspIO.req.bits.addr === ((numReadWriteReg - 1) / wordsPerBeat).U) &&
    // The strobe of LSB is 1 (will write the valid bit)
    (io.reqRspIO.req.bits
      .strb((numReadWriteReg - 1) % wordsPerBeat * regDataWidth / 8))        &&
    // The data is of LSB is non zero
    io.reqRspIO.req.bits.data((numReadWriteReg - 1) % wordsPerBeat * regDataWidth)

  // handle write req
  when(writeReg) {
    var remainingMask = FillInterleaved(8, io.reqRspIO.req.bits.strb)
    val masks         = collection.mutable.ArrayBuffer[UInt]()
    while (remainingMask.getWidth > 0) {
      if (remainingMask.getWidth > regDataWidth)
        masks.append(remainingMask(regDataWidth - 1, 0))
      else masks.append(remainingMask)

      if (remainingMask.getWidth > regDataWidth)
        remainingMask    = remainingMask(remainingMask.getWidth - 1, regDataWidth)
      else remainingMask = 0.U(0.W)
    }

    var remainingData = io.reqRspIO.req.bits.data
    val datas         = collection.mutable.ArrayBuffer[UInt]()
    while (remainingData.getWidth > 0) {
      if (remainingData.getWidth > regDataWidth)
        datas.append(remainingData(regDataWidth - 1, 0))
      else datas.append(remainingData)

      if (remainingData.getWidth > regDataWidth)
        remainingData    = remainingData(remainingData.getWidth - 1, regDataWidth)
      else remainingData = 0.U(0.W)
    }

    val BaseAddr = io.reqRspIO.req.bits.addr * wordsPerBeat.U
    masks.zipWithIndex.foreach { case (mask, i) =>
      when((BaseAddr + i.U) < numReadWriteReg.U) {
        regs(BaseAddr + i.U) := (regs(BaseAddr + i.U) & ~mask) | (datas(i) & mask)
      } otherwise {
        assert(
          mask === 0.U,
          cf"csr write address overflow! Address: ${BaseAddr + i.U}, Max: ${numReadWriteReg - 1}, Config: ${datas(i)}"
        )
      }
    }
  }

  // handle read requests: send the result directly. If the receiver
  // is busy (ready not asserted), store the read result in a buffer.

  // signal to indicate if a read request is in progress
  val readRegBusy = RegInit(0.B)
  readRegBusy := io.reqRspIO.rsp.valid && !io.reqRspIO.rsp.ready

  // a register to buffer the read request response data until the request is finished
  val readRegBuffer = RegInit(0.U(ioDataWidth.W))
  readRegBuffer := io.reqRspIO.rsp.bits.data

  // Combine RW and RO regs as regDataWidth-bit words (pad RO to regDataWidth bits if needed)
  val all32 = VecInit(regs ++ io.readOnlyReg.map(_.asUInt.pad(regDataWidth)))

  // Group into dataWidth-bit entries (list becomes shorter by wordsPerBeat)
  val numBeats     = ((numReadWriteReg + numReadOnlyReg) + wordsPerBeat - 1) / wordsPerBeat
  val allRegisters = Wire(Vec(numBeats, UInt(ioDataWidth.W)))
  for (b <- 0 until numBeats) {
    val slice = (0 until wordsPerBeat).map { i =>
      val idx = b * wordsPerBeat + i
      if (idx < all32.length) all32(idx) else 0.U(regDataWidth.W)
    }
    allRegisters(b) := Cat(slice.reverse)
  }

  when(readReg) {
    assert(
      io.reqRspIO.req.bits.addr <= ((numReadWriteReg + numReadOnlyReg + numBeats - 1) / wordsPerBeat).U,
      s"csr read address overflow! Max allowed address is ${(numReadWriteReg + numReadOnlyReg - 1) / wordsPerBeat}"
    )
    io.reqRspIO.rsp.bits.data   := allRegisters(io.reqRspIO.req.bits.addr)
    io.reqRspIO.rsp.valid       := 1.B
  }.elsewhen(readRegBusy) {
    io.reqRspIO.rsp.bits.data := readRegBuffer
    io.reqRspIO.rsp.valid     := 1.B
  }.otherwise {
    io.reqRspIO.rsp.valid     := 0.B
    io.reqRspIO.rsp.bits.data := 0.U
  }

  // handle start requests: if the last csr is written to 1, the
  // configuration can be sent to the streamer if it is not busy

  // streamer configuration valid signal
  io.readWriteRegIO.valid                                                    := writeReg &&
    // The last address in the ReqRspManager
    (io.reqRspIO.req.bits.addr === ((numReadWriteReg - 1) / wordsPerBeat).U) &&
    // The strobe of LSB is 1 (will write the valid bit)
    (io.reqRspIO.req.bits
      .strb((numReadWriteReg - 1) % wordsPerBeat * regDataWidth / 8))        &&
    // The data is of LSB is non zero
    io.reqRspIO.req.bits.data((numReadWriteReg - 1) % wordsPerBeat * regDataWidth)

  // CSR Manager ready signal logic
  // The CSR Manager is always ready except if:
  //   - a read transaction is still happening
  //   - the launch signal is asserted but the streamer is not ready
  when(readRegBusy) {
    io.reqRspIO.req.ready := 0.B
  }.elsewhen(startReg) {
    io.reqRspIO.req.ready := io.readWriteRegIO.ready
  }.elsewhen(check_acc_status) {
    io.reqRspIO.req.ready := io.readWriteRegIO.ready
  }.otherwise {
    io.reqRspIO.req.ready := 1.B
  }
  // signals connected to the output ports
  io.readWriteRegIO.bits <> regs
}
