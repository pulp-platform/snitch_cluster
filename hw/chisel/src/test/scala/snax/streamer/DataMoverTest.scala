package snax.streamer

import chisel3._
import org.scalatest.flatspec.AnyFlatSpec
import chiseltest._
import scala.math.BigInt
import org.scalatest.matchers.should.Matchers
import org.scalatest.Tag
import scala.util.control.Breaks._

// data reader initial test
class DataMoverTest
    extends AnyFlatSpec
    with ChiselScalatestTester
    with Matchers {
  "DUT" should "pass" in {
    test(
      new DataMoverTester(
        DataMoverParams(
          tcdmPortsNum = 2,
          spatialBounds = Seq(8, 2),
          spatialDim = 2,
          elementWidth = 8,
          fifoWidth = 128
        )
      )
    ).withAnnotations(
      Seq(WriteVcdAnnotation)
    ) { dut =>
      // initialize input pointer
      dut.io.ptr_agu_i.bits.poke(0.U)
      dut.io.ptr_agu_i.valid.poke(0.B)

      dut.clock.step(5)

      // ************************************************
      // test: send a valid stride config to the data mover
      // ************************************************

      // data mover should start in IDLE state => ready for a new config
      dut.io.spatialStrides_csr_i.ready.expect(1)

      // send a valid stride config to the data mover

      dut.io.spatialStrides_csr_i.bits(0).poke(1)
      dut.io.spatialStrides_csr_i.bits(1).poke(8)
      dut.io.spatialStrides_csr_i.valid.poke(1)

      dut.clock.step(1)

      // data mover should now be in the busy state => not ready for a new config
      dut.io.spatialStrides_csr_i.ready.expect(0)

      // stop programming
      dut.io.spatialStrides_csr_i.valid.poke(0)

      dut.clock.step(5)

      // ************************************************
      // test: ideal case, no conflicts
      // ************************************************

      // no conflicts
      dut.io.tcdm_req(0).ready.poke(1)
      dut.io.tcdm_req(1).ready.poke(1)

      dut.clock.step(1)

      // send 12 requests
      for (i <- 0 until 12) {
        // the data mover should accept a new pointer
        dut.io.ptr_agu_i.ready.expect(1)

        // send a valid pointer
        dut.io.ptr_agu_i.bits.poke((16 * i).U)
        dut.io.ptr_agu_i.valid.poke(1)

        // check for a valid request at tcdm size
        dut.io.tcdm_req(0).valid.expect(1)
        dut.io.tcdm_req(1).valid.expect(1)
        dut.io.tcdm_req(0).bits.addr.expect((16 * i).U)
        dut.io.tcdm_req(1).bits.addr.expect((16 * i + 8).U)

        // clock
        dut.clock.step(1)
      }

      // stop sending pointers
      dut.io.ptr_agu_i.valid.poke(0)

      // check

      dut.clock.step(5)

      // ************************************************
      // test: banking conflicts
      // ************************************************

      // send 12 requests
      for (i <- 0 until 12) {

        // bank conflict for port 1
        dut.io.tcdm_req(0).ready.poke(1)
        dut.io.tcdm_req(1).ready.poke(0)

        // the data mover should not yet accept a new pointer
        dut.io.ptr_agu_i.ready.expect(0)

        // send a valid pointer
        dut.io.ptr_agu_i.bits.poke((16 * i).U)
        dut.io.ptr_agu_i.valid.poke(1)

        // check for a valid request at tcdm size
        dut.io.tcdm_req(0).valid.expect(1)
        dut.io.tcdm_req(1).valid.expect(1)
        dut.io.tcdm_req(0).bits.addr.expect((16 * i).U)
        dut.io.tcdm_req(1).bits.addr.expect((16 * i + 8).U)

        // clock
        dut.clock.step(1)

        // resolve bank conflict on port 1
        dut.io.tcdm_req(1).ready.poke(1)

        // the data mover should now be ready for a new pointer
        dut.io.ptr_agu_i.ready.expect(1)

        // check for a valid request at tcdm size
        dut.io.tcdm_req(0).valid.expect(0)
        dut.io.tcdm_req(1).valid.expect(1)
        dut.io.tcdm_req(0).bits.addr.expect((16 * i).U)
        dut.io.tcdm_req(1).bits.addr.expect((16 * i + 8).U)

        // clock
        dut.clock.step(1)
      }

      dut.clock.step(5)

      // ************************************************
      // test: alternating bank conflicts
      // ************************************************

      // send 12 requests
      for (i <- 0 until 12) {

        // bank conflict for port 1
        dut.io.tcdm_req(0).ready.poke(1)
        dut.io.tcdm_req(1).ready.poke(0)

        // the data mover should not yet accept a new pointer
        dut.io.ptr_agu_i.ready.expect(0)

        // send a valid pointer
        dut.io.ptr_agu_i.bits.poke((16 * i).U)
        dut.io.ptr_agu_i.valid.poke(1)

        // check for a valid request at tcdm size
        dut.io.tcdm_req(0).valid.expect(1)
        dut.io.tcdm_req(1).valid.expect(1)
        dut.io.tcdm_req(0).bits.addr.expect((16 * i).U)
        dut.io.tcdm_req(1).bits.addr.expect((16 * i + 8).U)

        // clock
        dut.clock.step(1)

        // resolve bank conflict on port 1
        dut.io.tcdm_req(1).ready.poke(1)

        // the data mover should now be ready for a new pointer
        dut.io.ptr_agu_i.ready.expect(1)

        // check for a valid request at tcdm size
        dut.io.tcdm_req(0).valid.expect(0)
        dut.io.tcdm_req(1).valid.expect(1)
        dut.io.tcdm_req(0).bits.addr.expect((16 * i).U)
        dut.io.tcdm_req(1).bits.addr.expect((16 * i + 8).U)

        // clock
        dut.clock.step(1)

        // send a valid pointer
        dut.io.ptr_agu_i.bits.poke((16 * i + 160).U)
        dut.io.ptr_agu_i.valid.poke(1)

        // bank conflict for port 0
        dut.io.tcdm_req(0).ready.poke(0)

        // the data mover should not yet accept a new pointer
        dut.io.ptr_agu_i.ready.expect(0)

        // check for a valid request at tcdm size
        dut.io.tcdm_req(0).valid.expect(1)
        dut.io.tcdm_req(1).valid.expect(1)
        dut.io.tcdm_req(0).bits.addr.expect((16 * i + 160).U)
        dut.io.tcdm_req(1).bits.addr.expect((16 * i + 160 + 8).U)

        // clock
        dut.clock.step(1)

        // resolve bank conflict on port 0
        dut.io.tcdm_req(0).ready.poke(1)

        // the data mover should now be ready for a new pointer
        dut.io.ptr_agu_i.ready.expect(1)

        // check for a valid request at tcdm size
        dut.io.tcdm_req(0).valid.expect(1)
        dut.io.tcdm_req(1).valid.expect(0)
        dut.io.tcdm_req(0).bits.addr.expect((16 * i + 160).U)
        dut.io.tcdm_req(1).bits.addr.expect((16 * i + 160 + 8).U)

        // clock
        dut.clock.step(1)

        // request without conflicts
        dut.io.tcdm_req(0).ready.poke(1)
        dut.io.tcdm_req(1).ready.poke(1)

        // the data mover should accept a new pointer
        dut.io.ptr_agu_i.ready.expect(1)

        // send a valid pointer
        dut.io.ptr_agu_i.bits.poke((16 * i + 320).U)
        dut.io.ptr_agu_i.valid.poke(1)

        // check for a valid request at tcdm size
        dut.io.tcdm_req(0).valid.expect(1)
        dut.io.tcdm_req(1).valid.expect(1)
        dut.io.tcdm_req(0).bits.addr.expect((16 * i + 320).U)
        dut.io.tcdm_req(1).bits.addr.expect((16 * i + 320 + 8).U)

        // clock
        dut.clock.step(1)

      }
    }
  }
}
