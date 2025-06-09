// Copyright 2025 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Xiaoling Yi <xiaoling.yi@kuleuven.be>

package snax_acc.versacore

import chisel3._

import chiseltest._
import org.scalatest.funsuite.AnyFunSuite

class AccumulatorTest extends AnyFunSuite with ChiselScalatestTester {
  test("Accumulator should correctly add or accumulate values") {
    val numElements = 4

    test(new Accumulator(UIntUIntOp, Int8, Int16, numElements)).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      // Helper function to run tests with different configurations
      def testConfig(
        in1Values:      Seq[Int],
        in2Values:      Seq[Int],
        accAddExtIn:    Boolean,
        expectedOutput: Seq[Int]
      ): Unit = {
        // Set input values
        in1Values.zipWithIndex.foreach { case (value, idx) =>
          dut.io.in1.bits(idx).poke(value.U)
        }
        in2Values.zipWithIndex.foreach { case (value, idx) =>
          dut.io.in2.bits(idx).poke(value.U)
        }

        // Set control signals
        dut.io.accAddExtIn.poke(accAddExtIn.B)
        dut.io.enable.poke(true.B)
        dut.io.accClear.poke(false.B)
        dut.io.in1.valid.poke(true.B)
        dut.io.in2.valid.poke(true.B)
        dut.io.out.ready.poke(true.B)

        // Step clock
        dut.clock.step()

        // Check expected output
        expectedOutput.zipWithIndex.foreach { case (expected, idx) =>
          dut.io.out.bits(idx).expect(expected.U)
        }
      }

      // Test case 1: Element-wise addition when accAddExtIn is true
      testConfig(
        in1Values      = Seq(1, 2, 3, 4),
        in2Values      = Seq(4, 3, 2, 1),
        accAddExtIn    = true,
        expectedOutput = Seq(5, 5, 5, 5) // [1+4, 2+3, 3+2, 4+1]
      )

      // Test case 2: Accumulate in1 values when accAddExtIn is false
      testConfig(
        in1Values      = Seq(1, 2, 3, 4),
        in2Values      = Seq(0, 0, 0, 0),  // Unused
        accAddExtIn    = false,
        expectedOutput = Seq(6, 7, 8, 9)   // Initial accumulation
      )
      testConfig(
        in1Values      = Seq(1, 2, 3, 4),
        in2Values      = Seq(0, 0, 0, 0),  // Unused
        accAddExtIn    = false,
        expectedOutput = Seq(7, 9, 11, 13) // Initial accumulation
      )

      // Test case 3: clear accumulator
      testConfig(
        in1Values      = Seq(0, 0, 0, 0), // Unused
        in2Values      = Seq(0, 0, 0, 0), // Unused
        accAddExtIn    = true,
        expectedOutput = Seq(0, 0, 0, 0)  // Initial accumulation
      )

      // Continue accumulating
      testConfig(
        in1Values      = Seq(2, 3, 4, 5),
        in2Values      = Seq(0, 0, 0, 0), // Unused
        accAddExtIn    = false,
        expectedOutput = Seq(2, 3, 4, 5)  //
      )
    }
  }
}
