// Copyright 2025 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Xiaoling Yi <xiaoling.yi@kuleuven.be>

package snax_acc.versacore

import chisel3._

import chiseltest._
import org.scalatest.funsuite.AnyFunSuite

class AdderTreeTest extends AnyFunSuite with ChiselScalatestTester {
  test("AdderTree should correctly sum groups of inputs") {
    val numElements = 8
    val groupSizes  = Seq(1, 2, 4) // Possible grouping sizes

    test(new AdderTree(Int8, Int8, numElements, groupSizes)) { dut =>
      // Helper function to run tests for different group sizes
      def testConfig(cfg: Int, inputValues: Seq[Int], expectedOutput: Seq[Int]): Unit = {
        // Set input values
        inputValues.zipWithIndex.foreach { case (value, idx) =>
          dut.io.in(idx).poke(value.U)
        }

        // Set configuration
        dut.io.cfg.poke(cfg.U)

        // Evaluate circuit
        dut.clock.step()

        // Check expected output
        expectedOutput.zipWithIndex.foreach { case (expected, idx) =>
          dut.io.out(idx).expect(expected.U)
        }
      }

      // Test case 1: No summing (cfg = 0, group size = 1)
      testConfig(cfg = 0, inputValues = Seq(1, 2, 3, 4, 5, 6, 7, 8), expectedOutput = Seq(1, 2, 3, 4, 5, 6, 7, 8))

      // Test case 2: Group by 2 (cfg = 1)
      testConfig(
        cfg            = 1,
        inputValues    = Seq(1, 2, 3, 4, 5, 6, 7, 8),
        expectedOutput = Seq(3, 7, 11, 15, 0, 0, 0, 0)
      ) // [1+2, 3+4, 5+6, 7+8]

      // Test case 3: Group by 4 (cfg = 2)
      testConfig(
        cfg            = 2,
        inputValues    = Seq(1, 2, 3, 4, 5, 6, 7, 8),
        expectedOutput = Seq(10, 26, 0, 0, 0, 0, 0, 0)
      ) // [1+2+3+4, 5+6+7+8]
    }
  }
}
