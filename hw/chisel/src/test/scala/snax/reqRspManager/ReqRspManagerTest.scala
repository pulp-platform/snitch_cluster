package snax.reqRspManager

import chisel3._

import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import snax.reqRspManager.ReqRspManager

trait HasReqRspManagerTest extends HasRegRspManagerTestUtils {
  def baseReqRspManagerTest[T <: ReqRspManager](dut: T) = {
    // ***********************************************************************
    // Write values to the CSRs (valid)
    // ***********************************************************************

    // First write some values to the CSR:
    // 1. Write 10 to address 1
    // 2. Write 20 to address 2
    // 3. Write 30 to address 3
    // 4. Write 40 to address 4

    writeReg(dut, 1, 10)
    writeReg(dut, 2, 20)
    writeReg(dut, 3, 30)
    writeReg(dut, 4, 40)
    writeReg(dut, 5, 0xFFFFFFFFL, 0b0001)


    dut.clock.step(5)

    // ***********************************************************************
    // Read values of the CSRs (valid)
    // ***********************************************************************
    assert(10 == readReg(dut, 1))
    assert(20 == readReg(dut, 2))
    assert(30 == readReg(dut, 3))
    assert(40 == readReg(dut, 4))
    assert(0x000000FF == readReg(dut, 5))

    dut.clock.step(5)

    // ***********************************************************************
    // Write values to the CSRs with all strobes = 0 (valid)
    // ***********************************************************************

    writeReg(dut, 1, 10, 0x0)
    writeReg(dut, 2, 20, 0x0)
    writeReg(dut, 3, 30, 0x0)
    writeReg(dut, 4, 40, 0x0)
    writeReg(dut, 5, BigInt("FFFFFFFF", 16), 0b0001)

    dut.clock.step(5)
    // ***********************************************************************
    // Read back the values, they should be unchanged
    // ***********************************************************************
    assert(10 == readReg(dut, 1))
    assert(20 == readReg(dut, 2))
    assert(30 == readReg(dut, 3))
    assert(40 == readReg(dut, 4))
    assert(0x000000FF == readReg(dut, 5))

    dut.clock.step(5)
    // ***********************************************************************
    // Write to the CSRs without asserting valid
    // ***********************************************************************

    // Write without asserting valid
    dut.io.reqRspIO.req.bits.data.poke(0.U)
    dut.io.reqRspIO.req.bits.addr.poke(1.U)
    dut.io.reqRspIO.req.bits.write.poke(1.B)

    dut.clock.step(1)

    // Now reading should still return the original value (10)

    dut.io.reqRspIO.req.valid.poke(1.B)
    dut.io.reqRspIO.req.bits.write.poke(0.B)
    dut.io.reqRspIO.req.bits.addr.poke(1.U)
    dut.io.reqRspIO.rsp.ready.poke(1.B)

    dut.clock.step(1)

    // expect to read 10
    dut.io.reqRspIO.rsp.valid.expect(1.B)
    dut.io.reqRspIO.rsp.bits.data.expect(10.U)

    dut.io.reqRspIO.req.valid.poke(0.B)
    dut.io.reqRspIO.rsp.ready.poke(0.B)

    dut.clock.step(3)

    // ***********************************************************************
    // More Complex Reading: read without asserting ready directly
    // ***********************************************************************

    // Read at address 1: (without ready)
    dut.io.reqRspIO.req.valid.poke(1.B)
    dut.io.reqRspIO.req.bits.write.poke(0.B)
    dut.io.reqRspIO.req.bits.addr.poke(1.U)
    dut.io.reqRspIO.rsp.ready.poke(0.B)

    dut.clock.step(1)

    dut.io.reqRspIO.req.valid.poke(0.B)

    dut.clock.step(3)

    // response should still be valid now
    dut.io.reqRspIO.rsp.valid.expect(1.B)
    dut.io.reqRspIO.rsp.bits.data.expect(10.U)

    // the csr should not be ready to accept new requests
    dut.io.reqRspIO.rsp.ready.expect(0.B)

    // send a new request which should be ignored
    dut.io.reqRspIO.req.valid.poke(1.B)
    dut.io.reqRspIO.req.bits.write.poke(0.B)
    dut.io.reqRspIO.req.bits.addr.poke(2.U)

    dut.clock.step(1)

    dut.io.reqRspIO.req.valid.poke(0.B)

    // wait even longer

    dut.clock.step(2)

    // response should still be valid now
    dut.io.reqRspIO.rsp.valid.expect(1.B)
    dut.io.reqRspIO.rsp.bits.data.expect(10.U)

    // the csr should not be ready to accept new requests
    dut.io.reqRspIO.rsp.ready.expect(0.B)

    // assert ready
    dut.io.reqRspIO.rsp.ready.poke(1.B)

    dut.clock.step(1)

    // response should no longer be valid
    dut.io.reqRspIO.rsp.valid.expect(0.B)
    // the csr should be ready to accept new requests
    dut.io.reqRspIO.rsp.ready.expect(1.B)

    dut.clock.step(5)

    // ***********************************************************************
    // Test output mechanism of the CSR manager
    // ***********************************************************************

    dut.io.readWriteRegIO.valid.expect(0.B)

    // set output ready to 0
    dut.io.readWriteRegIO.ready.poke(0.B)

    // write a 1 to the valid register
    dut.io.reqRspIO.req.valid.poke(1.B)
    dut.io.reqRspIO.req.bits.write.poke(1.B)
    dut.io.reqRspIO.req.bits.addr.poke(9.U)
    dut.io.reqRspIO.req.bits.data.poke(1.U)

    dut.clock.step(1)

    // expect valid out to still be 0, as accelerator is not ready
    dut.io.readWriteRegIO.valid.expect(0.B)
    dut.io.reqRspIO.req.ready.expect(0.B)

    dut.clock.step(1)

    // set output ready to 1
    dut.io.readWriteRegIO.ready.poke(1.B)
    dut.io.reqRspIO.req.ready.expect(1.B)

    dut.clock.step(1)

    // expect valid out to be 1
    dut.io.readWriteRegIO.valid.expect(1.B)

    // ***********************************************************************
    // Test accesing status CSR when accelerator is busy
    // ***********************************************************************

    dut.clock.step(1)
    dut.io.readWriteRegIO.ready.poke(0.B)

    // accesing status CSR
    dut.io.reqRspIO.req.valid.poke(1.B)
    dut.io.reqRspIO.req.bits.data.poke(0.U)
    dut.io.reqRspIO.req.bits.addr
      .poke((ReqRspManagerTestParameters.numReadWriteReg - 1).U)
    dut.io.reqRspIO.req.bits.write.poke(1.B)
    dut.clock.step(1)

    //  accelerator is busy, so request not ready, the write csr cmd is stalled
    dut.io.reqRspIO.req.ready.expect(0.B)

    dut.clock.step(5)
    // still stalled
    dut.io.reqRspIO.req.ready.expect(0.B)

    dut.clock.step(1)
    // accelerator not busy now
    dut.io.readWriteRegIO.ready.poke(1.B)

    dut.clock.step(1)
    // CsrManager is not stalled any more
    dut.io.reqRspIO.req.ready.expect(1.B)

    // ***********************************************************************
    // test read only csr
    // ***********************************************************************

    // drive the read only csr
    dut.io.readOnlyReg(0).poke(1.U)
    dut.io.readOnlyReg(1).poke(2.U)

    // check the read value
    assert(
      1 == readReg(
        dut,
        0 + ReqRspManagerTestParameters.numReadWriteReg
      )
    )
    assert(
      2 == readReg(
        dut,
        1 + ReqRspManagerTestParameters.numReadWriteReg
      )
    )

    // drive the read only csr
    dut.io.readOnlyReg(0).poke(3.U)
    dut.io.readOnlyReg(1).poke(4.U)

    // check the read value
    assert(
      3 == readReg(
        dut,
        0 + ReqRspManagerTestParameters.numReadWriteReg
      )
    )
    assert(
      4 == readReg(
        dut,
        1 + ReqRspManagerTestParameters.numReadWriteReg
      )
    )

  }
}

class ReqRspManagerTest extends AnyFlatSpec with ChiselScalatestTester with Matchers with HasReqRspManagerTest {

  "DUT" should "pass" in {
    test(
      new ReqRspManager(
        ReqRspManagerTestParameters.numReadWriteReg,
        ReqRspManagerTestParameters.numReadOnlyReg,
        ReqRspManagerTestParameters.addrWidth
      )
    ).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      baseReqRspManagerTest(dut)
    }
  }

}
