package snax.streamer

import chisel3._
import org.scalatest.flatspec.AnyFlatSpec
import chiseltest._
import scala.math.BigInt
import org.scalatest.matchers.should.Matchers
import org.scalatest.Tag

// simple test for streamer top module, mimic the csr write process (config streamer process)
class StreamerTopTest
    extends AnyFlatSpec
    with ChiselScalatestTester
    with Matchers {
  "DUT" should "pass" in {
    test(new StreamerTop(TestParameters.streamer))
      .withAnnotations(
        Seq(WriteVcdAnnotation)
      ) { dut =>
        dut.clock.step(5)

        // write csr helper function
        def write_csr(addr: Int, data: Int) = {

          // give the data and address to the right ports
          dut.io.csr.req.bits.write.poke(1.B)
          dut.io.csr.req.bits.data.poke(data.U)
          dut.io.csr.req.bits.addr.poke(addr.U)
          dut.io.csr.req.valid.poke(1.B)

          // wait for grant
          while (dut.io.csr.req.ready.peekBoolean() == false) {
            dut.clock.step(1)
          }

          dut.clock.step(1)

          dut.io.csr.req.valid.poke(0.B)

        }

        // read csr helper function
        def read_csr(addr: Int, data: Int) = {

          // give the data and address to the right ports
          dut.io.csr.req.bits.write.poke(0.B)
          dut.io.csr.req.bits.data.poke(data.U)
          dut.io.csr.req.bits.addr.poke(addr.U)
          dut.io.csr.req.valid.poke(1.B)

          // wait for grant
          while (dut.io.csr.req.ready.peekBoolean() == false) {
            dut.clock.step(1)
          }

          dut.clock.step(1)

          dut.io.csr.req.valid.poke(0.B)

          // wait for valid signal
          while (dut.io.csr.rsp.valid.peekBoolean() == false) {
            dut.clock.step(1)
          }
          dut.io.csr.rsp.bits.data.peekInt()
        }

        // give valid transaction config
        // temporal loop bound
        val temporal_loop_bound = 20
        write_csr(0, temporal_loop_bound)

        // temporal loop strides
        // address 1 configs the temporal loop stride for first data reader, which is a for mac engine.
        write_csr(1, 2)
        // address 2 configs the temporal loop stride for second data reader, which is b for mac engine.
        write_csr(2, 2)
        // address 3 configs the temporal loop stride for third data reader, which is c for mac engine.
        write_csr(3, 2)
        // address 4 configs the temporal loop stride for first data writer, which is d for mac engine.
        write_csr(4, 2)

        // spatial loop strides
        // warning!!! give the proper spatial strides so that is a aligned in one TCDM bank.
        // address 5 configs the spatial loop stride for first data reader, which is a_u for mac engine.
        write_csr(5, 4)
        // address 6 configs the spatial loop stride for second data reader, which is b_u for mac engine.
        write_csr(6, 4)
        // address 7 configs the spatial loop stride for third data reader, which is c_u for mac engine.
        write_csr(7, 4)
        // address 8 configs the spatial loop stride for first data writer, which is d_u for mac engine.
        write_csr(8, 4)

        // base ptr
        // the order is the same as temporal loop strides.
        // address 9 configs the base ptr for first data reader.
        write_csr(9, 0x100)
        write_csr(10, 0x200)
        write_csr(11, 0x300)
        // address 12 configs the base ptr for first data writer.
        write_csr(12, 0x400)

        dut.clock.step(5)

        // start
        write_csr(13, 0)

        dut.clock.step(5)

        // give tcdm ports signals, no contention scene
        for (i <- 0 until TestParameters.streamer.dataReaderTcdmPorts.sum) {
          dut.io.data.tcdm_req(i).ready.poke(1.B)
          dut.io.data.tcdm_rsp(i).valid.poke(1.B)
        }

        // give accelerator ready to get input signals
        for (i <- 0 until TestParameters.streamer.dataReaderNum) {
          dut.io.data.streamer2accelerator.data(i).ready.poke(1.B)
        }

        // wait for temporal_loop_bound cycles
        dut.clock.step(temporal_loop_bound * 2)
        for (i <- 0 until TestParameters.streamer.dataReaderTcdmPorts.sum) {
          dut.io.data.tcdm_req(i).ready.poke(0.B)
          dut.io.data.tcdm_rsp(i).valid.poke(0.B)
        }

        // mimic accelerator gives valid data
        for (i <- 0 until TestParameters.streamer.dataWriterNum) {
          dut.io.data.accelerator2streamer.data(i).valid.poke(1.B)
        }

        // mimic tcdm is ready for write request
        for (i <- 0 until TestParameters.streamer.dataWriterTcdmPorts.sum) {
          dut.io.data
            .tcdm_req(i + TestParameters.streamer.dataReaderTcdmPorts.sum)
            .ready
            .poke(1.B)
        }

        // wait for temporal_loop_bound cycles
        dut.clock.step(temporal_loop_bound * 2)
        for (i <- 0 until TestParameters.streamer.dataWriterNum) {
          dut.io.data.accelerator2streamer.data(i).valid.poke(0.B)
        }

        // wait until finish
        write_csr(13, 0)

        dut.clock.step(10)

        // csr read test and check the result
        val read_csr_value = read_csr(0, 0)
        assert(read_csr_value == temporal_loop_bound)

        dut.clock.step(10)

      }
  }
}
