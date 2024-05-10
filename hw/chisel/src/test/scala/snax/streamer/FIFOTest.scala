package snax.streamer

import chisel3._
import org.scalatest.flatspec.AnyFlatSpec
import chiseltest._
import scala.math.BigInt
import org.scalatest.matchers.should.Matchers
import org.scalatest.Tag

class FIFOTest extends AnyFlatSpec with ChiselScalatestTester with Matchers {
  "DUT" should "pass" in {
    test(new FIFO(
        width=TestParameters.fifo.width,
        depth=TestParameters.fifo.depth))
      .withAnnotations(
        Seq(WriteVcdAnnotation)
      ) { dut =>
        dut.clock.step()
        dut.io.in.valid.poke(0.B)

        dut.clock.step()
        dut.io.in.valid.poke(1.B)
        dut.io.in.bits.poke(32)
        dut.clock.step()
        dut.io.in.valid.poke(1.B)
        dut.io.in.bits.poke(16)
        dut.clock.step()
        dut.io.in.valid.poke(1.B)
        dut.io.in.bits.poke(8)
        dut.clock.step()
        dut.io.in.valid.poke(1.B)
        dut.io.in.bits.poke(1)

        dut.clock.step()
        dut.io.in.valid.poke(0.B)

        dut.clock.step()
        dut.clock.step()

        dut.clock.step()
        dut.io.out.ready.poke(1.B)
        dut.clock.step()
        dut.clock.step()

        dut.io.out.ready.poke(0.B)

        dut.clock.step()
        dut.clock.step()

      }
  }
}
