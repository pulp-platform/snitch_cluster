package snax.reqRspManager

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import snax.reqRspManager.ReqRspManager

class IO64R64ReqRspManagerTest extends AnyFlatSpec with ChiselScalatestTester with Matchers with HasReqRspManagerTest {

  "IO64R64ReqRspManager_7" should "pass" in {
    test(
      new ReqRspManager(
        numReadWriteReg = 7,
        numReadOnlyReg  = 2,
        addrWidth       = 32,
        ioDataWidth     = 64,
        regDataWidth    = 64,
        moduleTagName   = "Test"
      )
    ).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      // Strobe Moves step by step
      writeReg(dut, 0, BigInt("FFFFFFFFFFFFFFFF", 16), BigInt("00000001", 2))
      dut.io.readWriteRegIO.bits(0).expect(BigInt("00000000000000FF", 16))
      dut.io.readWriteRegIO.bits(1).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(2).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(3).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(4).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(5).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(6).expect(BigInt("0000000000000000", 16))
      if (readReg(dut, 0) != BigInt("00000000000000FF", 16)) throw new Exception("Value not written correctly")

      writeReg(dut, 0, BigInt("FFFFFFFFFFFFFFFF", 16), BigInt("00000010", 2))
      dut.io.readWriteRegIO.bits(0).expect(BigInt("000000000000FFFF", 16))
      dut.io.readWriteRegIO.bits(1).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(2).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(3).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(4).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(5).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(6).expect(BigInt("0000000000000000", 16))
      if (readReg(dut, 0) != BigInt("000000000000FFFF", 16)) throw new Exception("Value not written correctly")

      writeReg(dut, 0, BigInt("FFFFFFFFFFFFFFFF", 16), BigInt("00000100", 2))
      dut.io.readWriteRegIO.bits(0).expect(BigInt("0000000000FFFFFF", 16))
      dut.io.readWriteRegIO.bits(1).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(2).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(3).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(4).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(5).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(6).expect(BigInt("0000000000000000", 16))
      if (readReg(dut, 0) != BigInt("0000000000FFFFFF", 16)) throw new Exception("Value not written correctly")

      writeReg(dut, 0, BigInt("FFFFFFFFFFFFFFFF", 16), BigInt("00001000", 2))
      dut.io.readWriteRegIO.bits(0).expect(BigInt("00000000FFFFFFFF", 16))
      dut.io.readWriteRegIO.bits(1).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(2).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(3).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(4).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(5).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(6).expect(BigInt("0000000000000000", 16))
      if (readReg(dut, 0) != BigInt("00000000FFFFFFFF", 16)) throw new Exception("Value not written correctly")

      writeReg(dut, 0, BigInt("FFFFFFFFFFFFFFFF", 16), BigInt("00010000", 2))
      dut.io.readWriteRegIO.bits(0).expect(BigInt("000000FFFFFFFFFF", 16))
      dut.io.readWriteRegIO.bits(1).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(2).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(3).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(4).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(5).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(6).expect(BigInt("0000000000000000", 16))
      if (readReg(dut, 0) != BigInt("000000FFFFFFFFFF", 16)) throw new Exception("Value not written correctly")

      writeReg(dut, 0, BigInt("FFFFFFFFFFFFFFFF", 16), BigInt("00100000", 2))
      dut.io.readWriteRegIO.bits(0).expect(BigInt("0000FFFFFFFFFFFF", 16))
      dut.io.readWriteRegIO.bits(1).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(2).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(3).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(4).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(5).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(6).expect(BigInt("0000000000000000", 16))
      if (readReg(dut, 0) != BigInt("0000FFFFFFFFFFFF", 16)) throw new Exception("Value not written correctly")

      writeReg(dut, 0, BigInt("FFFFFFFFFFFFFFFF", 16), BigInt("01000000", 2))
      dut.io.readWriteRegIO.bits(0).expect(BigInt("00FFFFFFFFFFFFFF", 16))
      dut.io.readWriteRegIO.bits(1).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(2).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(3).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(4).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(5).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(6).expect(BigInt("0000000000000000", 16))
      if (readReg(dut, 0) != BigInt("00FFFFFFFFFFFFFF", 16)) throw new Exception("Value not written correctly")

      writeReg(dut, 0, BigInt("FFFFFFFFFFFFFFFF", 16), BigInt("10000000", 2))
      dut.io.readWriteRegIO.bits(0).expect(BigInt("FFFFFFFFFFFFFFFF", 16))
      dut.io.readWriteRegIO.bits(1).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(2).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(3).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(4).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(5).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(6).expect(BigInt("0000000000000000", 16))
      if (readReg(dut, 0) != BigInt("FFFFFFFFFFFFFFFF", 16)) throw new Exception("Value not written correctly")

      // Write data with all strobes = 0 => no change
      writeReg(dut, 0, 0, BigInt("00000000", 2))
      dut.io.readWriteRegIO.bits(0).expect(BigInt("FFFFFFFFFFFFFFFF", 16))
      dut.io.readWriteRegIO.bits(1).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(2).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(3).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(4).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(5).expect(BigInt("0000000000000000", 16))
      dut.io.readWriteRegIO.bits(6).expect(BigInt("0000000000000000", 16))
      if (readReg(dut, 0) != BigInt("FFFFFFFFFFFFFFFF", 16)) throw new Exception("Value not written correctly")

      dut.io.reqRspIO.req.valid.poke(false.B)
      dut.clock.step(5)

      // Write data to the last register's LSB => Ready interface should work
      dut.io.reqRspIO.req.bits.write.poke(1.B)
      dut.io.reqRspIO.req.bits.strb.poke(BigInt("00000001", 2).U)
      dut.io.reqRspIO.req.bits.data.poke(BigInt("FFFFFFFFFFFFFFFF", 16).U)
      dut.io.reqRspIO.req.bits.addr.poke(6.U)
      dut.io.reqRspIO.req.valid.poke(true.B)
      dut.clock.step(10)

      // Acc side does not ready => Req side should also not be ready for the next transaction
      dut.io.readWriteRegIO.valid.expect(false.B)
      dut.io.reqRspIO.req.ready.expect(false.B)
      dut.clock.step(1)
      dut.io.readWriteRegIO.ready.poke(true.B)
      dut.io.readWriteRegIO.valid.expect(true.B)
      dut.clock.step(1)
      dut.io.readWriteRegIO.ready.poke(false.B)
      dut.io.reqRspIO.req.valid.poke(false.B)
    }
  }
}
