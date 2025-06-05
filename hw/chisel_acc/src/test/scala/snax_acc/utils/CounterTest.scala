package snax_acc.utils

import scala.util.Random

import chisel3._

import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

class NestCounterTest extends AnyFlatSpec with ChiselScalatestTester {

  def testNestCounter(width: Int, loopNum: Int, ceilValues: Array[Int]): Unit = {
    test(new NestCounter(width, loopNum)).withAnnotations(Seq(WriteVcdAnnotation)) { c =>
      // Print generated ceil values
      println(s"Testing with loopNum=$loopNum, ceilValues: ${ceilValues.mkString(", ")}")

      // Poke the ceil values to the NestCounter inputs
      for (i <- 0 until loopNum) {
        c.io.ceil(i).poke(ceilValues(i).U)
      }

      // Apply reset signal
      c.io.reset.poke(true.B)
      c.clock.step(1) // Step to allow reset to take effect
      c.io.reset.poke(false.B)

      // Track expected counter values
      val expectedValues = Array.fill(loopNum)(0)

      // Apply tick signal and test counter incrementing
      for (_ <- 1 to ceilValues.reduce(_ * _)) { // Run enough cycles to test nested behavior
        c.io.tick.poke(true.B)
        c.clock.step(1) // Step to simulate one cycle of the clock

        // Update expected values
        var carry = true
        for (i <- 0 until loopNum if carry) {
          if (expectedValues(i) == ceilValues(i) - 1) {
            expectedValues(i) = 0 // Reset and propagate carry
          } else {
            expectedValues(i) += 1
            carry = false // Stop propagation if no carry
          }
        }

        // Check values after each tick
        for (i <- 0 until loopNum) {
          val actual = c.io.value(i).peek().litValue.toInt
          // println(s"Counter[$i] after tick $tickCount: got $actual (Expected: ${expectedValues(i)})")
          assert(actual == expectedValues(i), s"Mismatch at counter $i: got $actual, expected ${expectedValues(i)}")
        }
      }

    }
  }

  "NestCounter" should "correctly compute counter values with hierarchical dependencies" in {
    val width      = 4                                        // Set the width of the counter
    var loopNum    = 3                                        // Set the number of loops (counters)
    val rand       = new Random()
    var ceilValues = Array.fill(loopNum)(rand.nextInt(8) + 1) // Random ceil between 1 and 8 for each counter

    testNestCounter(width, loopNum, ceilValues)

    // Test with a different set of ceil values
    ceilValues = Array.fill(loopNum)(rand.nextInt(1) + 1) // Random ceil between 1 and 8 for each counter
    testNestCounter(width, loopNum, ceilValues)

    // Test with a different set of ceil values
    ceilValues = Array(1, 2, 3) // Random ceil between 1 and 8 for each counter
    testNestCounter(width, loopNum, ceilValues)
    // Test with a different set of ceil values
    ceilValues = Array(2, 1, 4) // Random ceil between 1 and 8 for each counter
    testNestCounter(width, loopNum, ceilValues)
    // Test with a different set of ceil values
    ceilValues = Array(3, 2, 1) // Random ceil between 1 and 8 for each counter
    testNestCounter(width, loopNum, ceilValues)

    // test with different loopNum
    loopNum    = 5
    ceilValues = Array.fill(loopNum)(rand.nextInt(4) + 1) // Random ceil between 1 and 8 for each counter
    testNestCounter(width, loopNum, ceilValues)
  }
}
