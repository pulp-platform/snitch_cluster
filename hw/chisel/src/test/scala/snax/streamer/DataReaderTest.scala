package snax.streamer

import chisel3._
import org.scalatest.flatspec.AnyFlatSpec
import chiseltest._
import scala.math.BigInt
import org.scalatest.matchers.should.Matchers
import org.scalatest.Tag
import scala.util.control.Breaks._

// data reader initial test
class DataReaderTest
    extends AnyFlatSpec
    with ChiselScalatestTester
    with Matchers {
  "DUT" should "pass" in {
    test(new DataReader(DataMoverParams())).withAnnotations(
      Seq(WriteVcdAnnotation)
    ) { dut =>
      dut.clock.step(5)
      // give valid config, give the proper spatial strides so that is a aligned in one TCDM bank
      dut.io.spatialStrides_csr_i.bits(0).poke(1)
      dut.io.spatialStrides_csr_i.bits(1).poke(8)
      dut.io.spatialStrides_csr_i.valid.poke(1)
      dut.io.data_fifo_o.ready.poke(1)
      for (i <- 0 until DataMoverTestParameters.tcdmPortsNum) {
        dut.io.tcdm_req(i).ready.poke(1)
        dut.io.tcdm_rsp(i).bits.data.poke(1)
      }
      dut.clock.step(5)
      dut.io.spatialStrides_csr_i.valid.poke(0)

      dut.io.ptr_agu_i.bits.poke(160)
      dut.io.ptr_agu_i.valid.poke(1)

      // wait for getting the enough address
      var ready_counter = 0
      breakable {
        while (true) {
          if (dut.io.ptr_agu_i.ready.peekBoolean()) {
            ready_counter = ready_counter + 1
            dut.clock.step(5)
            if (ready_counter == 8) {
              break()
            }
          }
        }
      }
      dut.io.addr_gen_done.poke(1.B)

      dut.clock.step(5)
      dut.clock.step(50)
    }
  }
}
