package snax.reqRspManager

import chisel3._

import chiseltest._
import snax.reqRspManager.ReqRspManager

trait HasRegRspManagerTestUtils {

  // writeReg helper function without strobe
  def writeReg[T <: ReqRspManager](dut: T, addr: Int, data: Int) = {

    // give the data and address to the right ports
    dut.io.reqRspIO.req.bits.write.poke(1.B)
    dut.io.reqRspIO.req.bits.strb.poke("b1111".U)
    dut.io.reqRspIO.req.bits.data.poke(data.U)
    dut.io.reqRspIO.req.bits.addr.poke(addr.U)
    dut.io.reqRspIO.req.valid.poke(1.B)

    // wait for grant
    while (dut.io.reqRspIO.req.ready.peekBoolean() == false) {
      dut.clock.step(1)
    }

    dut.clock.step(1)

    dut.io.reqRspIO.req.valid.poke(0.B)

  }

  // writeReg helper function with strobe
  def writeReg[T <: ReqRspManager](dut: T, addr: BigInt, data: BigInt, strb: Int) = {

    // give the data and address to the right ports
    dut.io.reqRspIO.req.bits.write.poke(1.B)
    dut.io.reqRspIO.req.bits.strb.poke(strb.U)
    dut.io.reqRspIO.req.bits.data.poke(data.U)
    dut.io.reqRspIO.req.bits.addr.poke(addr.U)
    dut.io.reqRspIO.req.valid.poke(1.B)

    // wait for grant
    while (dut.io.reqRspIO.req.ready.peekBoolean() == false) {
      dut.clock.step(1)
    }

    dut.clock.step(1)

    dut.io.reqRspIO.req.valid.poke(0.B)

  }

  // readReg helper function
  def readReg[T <: ReqRspManager](dut: T, addr: Int) = {
    dut.clock.step(1)

    // give the data and address to the right ports
    dut.io.reqRspIO.req.bits.write.poke(0.B)
    dut.io.reqRspIO.req.bits.addr.poke(addr.U)
    dut.io.reqRspIO.req.valid.poke(1.B)

    // wait for grant
    while (dut.io.reqRspIO.req.ready.peekBoolean() == false) {
      dut.clock.step(1)
    }

    // wait for valid signal
    while (dut.io.reqRspIO.rsp.valid.peekBoolean() == false) {
      dut.clock.step(1)
    }

    // return read csr result
    val result = dut.io.reqRspIO.rsp.bits.data.peekInt()

    dut.clock.step(1)

    dut.io.reqRspIO.req.valid.poke(0.B)

    // give read out ready signal
    dut.io.reqRspIO.rsp.ready.poke(1.B)

    result
  }
}
