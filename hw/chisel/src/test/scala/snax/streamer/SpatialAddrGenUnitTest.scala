package snax.streamer

import chisel3._
import org.scalatest.flatspec.AnyFlatSpec
import chiseltest._
import scala.math.BigInt
import org.scalatest.matchers.should.Matchers
import org.scalatest.Tag

// manual test for spatial address generation unit
// TODO: automated random configuration test and automated results check
class SpatialAddrGenUnitTest
    extends AnyFlatSpec
    with ChiselScalatestTester
    with Matchers {
  "DUT" should "pass" in {
    test(new SpatialAddrGenUnit(TestParameters.spatialAddrGenUnit))
      .withAnnotations(
        Seq(WriteVcdAnnotation)
      ) { dut =>
        dut.clock.step(5)
        // random config generation
        val strides =
          Seq.fill(TestParameters.spatialAddrGenUnit.loopDim)(
            (
              scala.util.Random.nextInt(10)
            )
          )

        // sending these configuration to the dut
        for (i <- 0 until TestParameters.spatialAddrGenUnit.loopDim) {
          val stride = strides(i).U
          dut.io.strides_i(i).poke(stride)
        }
        dut.io.ptr_i.poke(16.U)
        dut.io.valid_i.poke(1.B)

        dut.clock.step(5)

        // check the result (for loopDim = 2)
        val ptr_0 = 16
        for (i <- 0 until TestParameters.spatialAddrGenUnit.loopBounds(0)) {
          for (j <- 0 until TestParameters.spatialAddrGenUnit.loopBounds(1)) {
            val ptr = ptr_0 + i * strides(0) + j * strides(1)
            dut.io
              .ptr_o(i + j * TestParameters.spatialAddrGenUnit.loopBounds(0))
              .expect(ptr)
          }
        }

      }
  }
}
