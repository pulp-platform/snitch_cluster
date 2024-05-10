package snax.csr_manager

import snax.utils._

import chisel3._
import chisel3.util._

/** This class represents the csr input and output ports of the streamer top
  * module
  *
  * @param csrAddrWidth
  *   csr registers address width
  */
class SnaxCsrIO(csrAddrWidth: Int) extends Bundle {

  val req = Flipped(Decoupled(new CsrReq(csrAddrWidth)))
  val rsp = Decoupled(new CsrRsp)

}

/** This class represents the input and output ports of the CsrManager module.
  * The input is connected to the SNAX CSR port. The output is connected to the
  * streamer configuration port.
  * @param csrNum
  *   the number of csr registers
  * @param addrWidth
  *   the width of the address
  */
class CsrManagerIO(
    csrNum: Int,
    csrAddrWidth: Int
) extends Bundle {

  val csr_config_in = new SnaxCsrIO(csrAddrWidth)
  val csr_config_out = Decoupled(Vec(csrNum, UInt(32.W)))
}

/** This class represents the CsrManager module. It contains the csr registers
  * and the read and write control logic.
  * @param csrNum
  *   the number of csr registers
  * @param addrWidth
  *   the width of the address
  */
class CsrManager(
    csrNum: Int,
    csrAddrWidth: Int,
    csrModuleTagName: String = ""
) extends Module
    with RequireAsyncReset {
  override val desiredName = csrModuleTagName + "CsrManager"

  val io = IO(new CsrManagerIO(csrNum, csrAddrWidth))

  // generate a vector of registers to store the csr state
  val csr = RegInit(VecInit(Seq.fill(csrNum)(0.U(32.W))))

  // read write and start csr command
  val read_csr = io.csr_config_in.req.fire && !io.csr_config_in.req.bits.write
  val write_csr = io.csr_config_in.req.fire && io.csr_config_in.req.bits.write
  val start_csr = io.csr_config_in.req.bits.write &&
    (io.csr_config_in.req.bits.addr === (csrNum - 1).U) && io.csr_config_in.req.bits.data === 1.U

  // assert the csr address is valid
  when(io.csr_config_in.req.fire) {
    assert(io.csr_config_in.req.bits.addr < csrNum.U, "csr address overflow!")
  }

  // handle write req
  when(write_csr) {
    csr(io.csr_config_in.req.bits.addr) := io.csr_config_in.req.bits.data
  }

  // handle read requests: send the result directly. If the receiver
  // is busy (ready not asserted), store the read result in a buffer.

  // signal to indicate if a read request is in progress
  val read_csr_busy = RegInit(0.B)
  read_csr_busy := io.csr_config_in.rsp.valid && !io.csr_config_in.rsp.ready

  // a register to buffer the read request response data until the request is finished
  val read_csr_buffer = RegInit(0.U(32.W))
  read_csr_buffer := io.csr_config_in.rsp.bits.data

  when(read_csr) {
    io.csr_config_in.rsp.bits.data := csr(io.csr_config_in.req.bits.addr)
    io.csr_config_in.rsp.valid := 1.B
  }.elsewhen(read_csr_busy) {
    io.csr_config_in.rsp.bits.data := read_csr_buffer
    io.csr_config_in.rsp.valid := 1.B
  }.otherwise {
    io.csr_config_in.rsp.valid := 0.B
    io.csr_config_in.rsp.bits.data := 0.U
  }

  // handle start requests: if the last csr is written to 1, the
  // configuration can be sent to the streamer if it is not busy

  // streamer configuration valid signal
  io.csr_config_out.valid := write_csr && (io.csr_config_in.req.bits.addr === (csrNum - 1).U) && io.csr_config_in.req.bits.data === 1.U

  // CSR Manager ready signal logic
  // The CSR Manager is always ready except if:
  //   - a read transaction is still happening
  //   - the launch signal is asserted but the streamer is not ready
  when(read_csr_busy) {
    io.csr_config_in.req.ready := 0.B
  }.elsewhen(start_csr) {
    io.csr_config_in.req.ready := io.csr_config_out.ready
  }.otherwise {
    io.csr_config_in.req.ready := 1.B
  }

  // signals connected to the output ports
  io.csr_config_out.bits <> csr

}
