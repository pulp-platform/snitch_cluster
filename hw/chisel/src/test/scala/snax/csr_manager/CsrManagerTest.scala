package snax.csr_manager

import chisel3._
import org.scalatest.flatspec.AnyFlatSpec
import chiseltest._
import scala.math.BigInt
import org.scalatest.matchers.should.Matchers
import org.scalatest.Tag
import scala.util.control.Breaks._

class CsrManagerTest
    extends AnyFlatSpec
    with ChiselScalatestTester
    with Matchers {

  "DUT" should "pass" in {
    test(new CsrManager(10, 32)).withAnnotations(Seq(WriteVcdAnnotation)) {
      dut =>
        // ***********************************************************************
        // Write values to the CSRs (valid)
        // ***********************************************************************

        // First write some values to the CSR:
        // 1. Write 10 to address 1
        // 2. Write 20 to address 2
        // 3. Write 30 to address 3
        // 4. Write 40 to address 4

        dut.io.csr_config_in.req.valid.poke(1.B)

        dut.io.csr_config_in.req.bits.data.poke(10.U)
        dut.io.csr_config_in.req.bits.addr.poke(1.U)
        dut.io.csr_config_in.req.bits.write.poke(1.B)

        dut.clock.step(1)

        dut.io.csr_config_in.req.bits.data.poke(20.U)
        dut.io.csr_config_in.req.bits.addr.poke(2.U)
        dut.io.csr_config_in.req.bits.write.poke(1.B)

        dut.clock.step(1)

        dut.io.csr_config_in.req.bits.data.poke(30.U)
        dut.io.csr_config_in.req.bits.addr.poke(3.U)
        dut.io.csr_config_in.req.bits.write.poke(1.B)

        dut.clock.step(1)

        dut.io.csr_config_in.req.bits.data.poke(40.U)
        dut.io.csr_config_in.req.bits.addr.poke(4.U)
        dut.io.csr_config_in.req.bits.write.poke(1.B)

        dut.clock.step(1)

        dut.io.csr_config_in.req.valid.poke(0.B)

        dut.clock.step(5)

        // ***********************************************************************
        // Read values of the CSRs (valid)
        // ***********************************************************************

        // Read at address 1:
        dut.io.csr_config_in.req.valid.poke(1.B)
        dut.io.csr_config_in.req.bits.write.poke(0.B)
        dut.io.csr_config_in.req.bits.addr.poke(1.U)
        dut.io.csr_config_in.rsp.ready.poke(1.B)

        dut.clock.step(1)

        // expect to read 10
        dut.io.csr_config_in.rsp.valid.expect(1.B)
        dut.io.csr_config_in.rsp.bits.data.expect(10.U)

        // Read at address 2:
        dut.io.csr_config_in.req.valid.poke(1.B)
        dut.io.csr_config_in.req.bits.write.poke(0.B)
        dut.io.csr_config_in.req.bits.addr.poke(2.U)

        dut.clock.step(1)

        // expect to read 20
        dut.io.csr_config_in.rsp.valid.expect(1.B)
        dut.io.csr_config_in.rsp.bits.data.expect(20.U)

        // Read at address 3:
        dut.io.csr_config_in.req.valid.poke(1.B)
        dut.io.csr_config_in.req.bits.write.poke(0.B)
        dut.io.csr_config_in.req.bits.addr.poke(3.U)

        dut.clock.step(1)

        // expect to read 30
        dut.io.csr_config_in.rsp.valid.expect(1.B)
        dut.io.csr_config_in.rsp.bits.data.expect(30.U)

        // Read at address 4:
        dut.io.csr_config_in.req.valid.poke(1.B)
        dut.io.csr_config_in.req.bits.write.poke(0.B)
        dut.io.csr_config_in.req.bits.addr.poke(4.U)

        dut.clock.step(1)

        // expect to read 40
        dut.io.csr_config_in.rsp.valid.expect(1.B)
        dut.io.csr_config_in.rsp.bits.data.expect(40.U)

        dut.io.csr_config_in.req.valid.poke(0.B)
        dut.io.csr_config_in.rsp.ready.poke(0.B)

        dut.clock.step(5)

        // ***********************************************************************
        // Write to the CSRs without asserting valid
        // ***********************************************************************

        // Write without asserting valid
        dut.io.csr_config_in.req.bits.data.poke(0.U)
        dut.io.csr_config_in.req.bits.addr.poke(1.U)
        dut.io.csr_config_in.req.bits.write.poke(1.B)

        dut.clock.step(1)

        // Now reading should still return the original value (10)

        dut.io.csr_config_in.req.valid.poke(1.B)
        dut.io.csr_config_in.req.bits.write.poke(0.B)
        dut.io.csr_config_in.req.bits.addr.poke(1.U)
        dut.io.csr_config_in.rsp.ready.poke(1.B)

        dut.clock.step(1)

        // expect to read 10
        dut.io.csr_config_in.rsp.valid.expect(1.B)
        dut.io.csr_config_in.rsp.bits.data.expect(10.U)

        dut.io.csr_config_in.req.valid.poke(0.B)
        dut.io.csr_config_in.rsp.ready.poke(0.B)

        dut.clock.step(3)

        // ***********************************************************************
        // More Complex Reading: read without asserting ready directly
        // ***********************************************************************

        // Read at address 1: (without ready)
        dut.io.csr_config_in.req.valid.poke(1.B)
        dut.io.csr_config_in.req.bits.write.poke(0.B)
        dut.io.csr_config_in.req.bits.addr.poke(1.U)
        dut.io.csr_config_in.rsp.ready.poke(0.B)

        dut.clock.step(1)

        dut.io.csr_config_in.req.valid.poke(0.B)

        dut.clock.step(3)

        // response should still be valid now
        dut.io.csr_config_in.rsp.valid.expect(1.B)
        dut.io.csr_config_in.rsp.bits.data.expect(10.U)

        // the csr should not be ready to accept new requests
        dut.io.csr_config_in.rsp.ready.expect(0.B)

        // send a new request which should be ignored
        dut.io.csr_config_in.req.valid.poke(1.B)
        dut.io.csr_config_in.req.bits.write.poke(0.B)
        dut.io.csr_config_in.req.bits.addr.poke(2.U)

        dut.clock.step(1)

        dut.io.csr_config_in.req.valid.poke(0.B)

        // wait even longer

        dut.clock.step(2)

        // response should still be valid now
        dut.io.csr_config_in.rsp.valid.expect(1.B)
        dut.io.csr_config_in.rsp.bits.data.expect(10.U)

        // the csr should not be ready to accept new requests
        dut.io.csr_config_in.rsp.ready.expect(0.B)

        // assert ready
        dut.io.csr_config_in.rsp.ready.poke(1.B)

        dut.clock.step(1)

        // response should no longer be valid
        dut.io.csr_config_in.rsp.valid.expect(0.B)
        // the csr should be ready to accept new requests
        dut.io.csr_config_in.rsp.ready.expect(1.B)

        dut.clock.step(5)

        // ***********************************************************************
        // Test output mechanism of the CSR manager
        // ***********************************************************************

        dut.io.csr_config_out.valid.expect(0.B)

        // set output ready to 0
        dut.io.csr_config_out.ready.poke(0.B)

        // write a 1 to the valid register
        dut.io.csr_config_in.req.valid.poke(1.B)
        dut.io.csr_config_in.req.bits.write.poke(1.B)
        dut.io.csr_config_in.req.bits.addr.poke(9.U)
        dut.io.csr_config_in.req.bits.data.poke(1.U)

        dut.clock.step(1)

        // expect valid out to still be 0, as accelerator is not ready
        dut.io.csr_config_out.valid.expect(0.B)
        dut.io.csr_config_in.req.ready.expect(0.B)

        dut.clock.step(1)

        // set output ready to 1
        dut.io.csr_config_out.ready.poke(1.B)
        dut.io.csr_config_in.req.ready.expect(1.B)

        dut.clock.step(1)

        // expect valid out to be 1
        dut.io.csr_config_out.valid.expect(1.B)

        dut.clock.step(5)

    }
  }
}
