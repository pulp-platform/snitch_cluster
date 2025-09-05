package snax.reqRspManager

import chisel3._
import chisel3.util._

import snax.utils._

/** This class represents the reg input and output ports of the streamer top module
  *
  * @param addrWidth
  *   Registers address width
  */
class SnaxReqRspIO(addrWidth: Int) extends Bundle {

  val req = Flipped(Decoupled(new RegReq(addrWidth = addrWidth, tcdmDataWidth = 32)))
  val rsp = Decoupled(new RegRsp(tcdmDataWidth = 32))

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
class ReqRspManagerIO(numReadWriteReg: Int, numReadOnlyReg: Int, addrWidth: Int) extends Bundle {

  val reqRspIO       = new SnaxReqRspIO(addrWidth = addrWidth)
  val readWriteRegIO = Decoupled(Vec(numReadWriteReg, UInt(32.W)))

  // Add extra input ports from accelerator side for the read only registers
  val readOnlyReg = Input(Vec(numReadOnlyReg, UInt(addrWidth.W)))

}

/** This class represents the CsrManager module. It contains the csr registers and the read and write control logic. It
  * contains only one type of registers, eg. read and write CSR.
  * @param numReadWriteReg
  *   the number of read and write csr registers
  * @param numReadOnlyReg
  *   the number of read only csr registers
  * @param addrWidth
  *   the width of the address
  */
class ReqRspManager(numReadWriteReg: Int, numReadOnlyReg: Int, addrWidth: Int, moduleTagName: String = "")
    extends Module
    with RequireAsyncReset {
  override val desiredName = moduleTagName + "ReqRspManager"

  lazy val io = IO(new ReqRspManagerIO(numReadWriteReg, numReadOnlyReg, addrWidth))
  io.suggestName("io")

  // generate a vector of registers to store the csr state
  val csr = RegInit(VecInit(Seq.fill(numReadWriteReg)(0.U(32.W))))

  // read write and start csr command
  val readReg  = io.reqRspIO.req.fire  && !io.reqRspIO.req.bits.write
  val writeReg = io.reqRspIO.req.fire  && io.reqRspIO.req.bits.write
  val startReg = io.reqRspIO.req.valid && io.reqRspIO.req.bits.write &&
    (io.reqRspIO.req.bits.addr === (numReadWriteReg - 1).U) && io.reqRspIO.req.bits.data === 1.U
  val check_acc_status = io.reqRspIO.req.valid && io.reqRspIO.req.bits.write &&
    (io.reqRspIO.req.bits.addr === (numReadWriteReg - 1).U) && io.reqRspIO.req.bits.data === 0.U

  def address_range_assert() = {
    // assert the csr address range is valid
    when(io.reqRspIO.req.valid) {
      when(io.reqRspIO.req.bits.write === 1.B) {
        assert(
          io.reqRspIO.req.bits.addr < numReadWriteReg.U,
          cf"csr write address overflow! Address: ${io.reqRspIO.req.bits.addr}, Max: ${numReadWriteReg - 1}, Config: ${io.reqRspIO.req.bits.data}"
        )
      }
    }

    when(io.reqRspIO.req.valid) {
      when(io.reqRspIO.req.bits.write === 0.B) {
        assert(
          io.reqRspIO.req.bits.addr < (numReadWriteReg + numReadOnlyReg).U,
          "csr read address overflow!"
        )
      }
    }
  }

  address_range_assert()

  // handle write req
  when(writeReg) {
    val mask = FillInterleaved(8, io.reqRspIO.req.bits.strb)
    csr(io.reqRspIO.req.bits.addr) := (csr(
      io.reqRspIO.req.bits.addr
    ) & ~mask) | (io.reqRspIO.req.bits.data & mask)
  }

  // handle read requests: send the result directly. If the receiver
  // is busy (ready not asserted), store the read result in a buffer.

  // signal to indicate if a read request is in progress
  val readRegBusy = RegInit(0.B)
  readRegBusy := io.reqRspIO.rsp.valid && !io.reqRspIO.rsp.ready

  // a register to buffer the read request response data until the request is finished
  val readRegBuffer = RegInit(0.U(32.W))
  readRegBuffer := io.reqRspIO.rsp.bits.data

  when(readReg) {
    when(io.reqRspIO.req.bits.addr < numReadWriteReg.U) {
      io.reqRspIO.rsp.bits.data := csr(io.reqRspIO.req.bits.addr)
      // add extra logic for read only CSR respond data
    }.otherwise {
      io.reqRspIO.rsp.bits.data := io.readOnlyReg(
        io.reqRspIO.req.bits.addr - numReadWriteReg.U
      )
    }
    io.reqRspIO.rsp.valid := 1.B
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
  io.readWriteRegIO.valid := writeReg && (io.reqRspIO.req.bits.addr === (numReadWriteReg - 1).U) &&
    io.reqRspIO.req.bits.data === 1.U

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
  io.readWriteRegIO.bits <> csr

}
