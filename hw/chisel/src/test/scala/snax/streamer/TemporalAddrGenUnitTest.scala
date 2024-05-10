package snax.streamer

import chisel3._
import org.scalatest.flatspec.AnyFlatSpec
import chiseltest._
import scala.math.BigInt
import org.scalatest.matchers.should.Matchers
import org.scalatest.Tag

// manual test for temporal address generation unit
// TODO: automated random configuration test and automated results check
class TemporalAddrGenUnitTest
    extends AnyFlatSpec
    with ChiselScalatestTester
    with Matchers
    with WithSpatialLoopIndices {
  "DUT" should "pass" in {
    test(new TemporalAddrGenUnit(TestParameters.temporalAddrGenUnit)).withAnnotations(
      Seq(WriteVcdAnnotation)
    ) { dut =>
      def test_once() = {
        dut.clock.step(5)
        // random config generation
        val base_ptr = scala.util.Random.nextInt(100)
        val loopBounds =
          Seq.fill(TestParameters.temporalAddrGenUnit.loopDim)(
            (
              scala.util.Random.nextInt(5) + 1
            )
          )
        val strides =
          Seq.fill(TestParameters.temporalAddrGenUnit.loopDim)(
            (
              scala.util.Random.nextInt(10)
            )
          )

        // sending these configuration to the dut
        for (i <- 0 until TestParameters.temporalAddrGenUnit.loopDim) {
          val lb = loopBounds(i).U
          val ts = strides(i).U
          dut.io.loopBounds_i.bits(i).poke(lb)
          dut.io.strides_i.bits(i).poke(ts)
        }
        dut.io.ptr_i.bits.poke(base_ptr.U)

        dut.io.loopBounds_i.valid.poke(1.B)
        dut.io.strides_i.valid.poke(1.B)
        dut.io.ptr_i.valid.poke(1.B)

        dut.clock.step(1)
        dut.io.loopBounds_i.valid.poke(0.B)
        dut.io.strides_i.valid.poke(0.B)
        dut.io.ptr_i.valid.poke(0.B)

        dut.io.ptr_o.ready.poke(0.B)

        dut.clock.step(1)

        // keep consuming generated addresses by asserting dut.io.ptr_o.ready
        var counter = 0
        var golden_address = 0

        dut.io.ptr_o.ready.poke(1.B)

        while (dut.io.done.peekBoolean() == false) {
          val indices = genSpatialLoopIndices(
            TestParameters.temporalAddrGenUnit.loopDim,
            loopBounds,
            counter
          )
          golden_address = indices
            .zip(strides)
            .map({ case (a, b) => a * b })
            .reduce(_ + _) + base_ptr
          assert(
            dut.io.ptr_o.bits.peekInt() == golden_address,
            "generated address doesn't match the golden!"
          )
          dut.clock.step(1)

          counter = counter + 1
        }

        dut.clock.step(10)

      }

      test_once()
      test_once()

    }
  }
}
