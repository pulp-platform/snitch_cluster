// Copyright 2025 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Xiaoling Yi <xiaoling.yi@kuleuven.be>
// Modified by: Robin Geens <robin.geens@kuleuven.be>

package snax_acc.versacore

import scala.util.Random

import chisel3._

import chiseltest._
import chiseltest.simulator.VerilatorBackendAnnotation
import org.scalatest.flatspec.AnyFlatSpec
import snax_acc.utils.fpUtils

class FPMULIntTest extends AnyFlatSpec with ChiselScalatestTester with fpUtils {
  behavior of "FPMULInt"

  def test_fp_mul_int(dut: FPMULInt, test_id: Int, A: Float, B: Int, intWidthB: Int) = {
    // Convert to 16-bit representation
    val A_FP16 = uintToFloat(FP16, floatToUInt(FP16, A))

    var gold_O = 0.0f // Initialize expected output

    if (intWidthB == 1 && B == 0) {
      gold_O = A_FP16 * (-1) // Expected result
    } else if (intWidthB == 1 && B == 1) {
      gold_O = A_FP16 // Expected result
    } else {
      gold_O = A_FP16 * B // Expected result
    }

    println(
      f"-----------Test id: $test_id, A_FP16: ${A_FP16} , B: ${B},  gold_O: ${gold_O}-----------"
    )

    val stimulus_a_i = floatToUInt(FP16.expWidth, FP16.sigWidth, A)
    // Int to uint conversion
    val stimulus_b_i = (BigInt(B) & ((BigInt(1) << intWidthB) - 1)).U
    val expected_o   = floatToUInt(FP32, gold_O)

    dut.io.operand_a_i.poke(stimulus_a_i.U)
    dut.io.operand_b_i.poke(stimulus_b_i)

    dut.clock.step(2)

    val result = dut.io.result_o.peek().litValue
    println(
      f"-----------Test id: $test_id Expected: 0x${expected_o.toString(16)}, Got: 0x${result.toString(16)}-----------"
    )

    assert(result == expected_o)

    dut.clock.step(2)
  }

  def generateTestCases(intWidthB: Int, numTests: Int = 10): Seq[(Float, Int)] = {
    val random       = new Random()
    val (minB, maxB) = intWidthB match {
      case 1 => (0, 1)  // 0 to 1 for int1
      case 2 => (-2, 1) // -2 to 1 for int2
      case 3 => (-4, 3) // -4 to 3 for int3
      case 4 => (-8, 7) // -8 to 7 for int4
      case _ => throw new IllegalArgumentException(s"Unsupported intWidthB: $intWidthB")
    }

    Seq.fill(numTests)(
      (
        (random.nextFloat() * 20 - 10),        // Random float between -10 and 10
        random.nextInt(maxB - minB + 1) + minB // Random int in range
      )
    )
  }

  def runBasicTests(dut: FPMULInt, intWidthB: Int) = {
    // Test case 1
    test_fp_mul_int(dut, 1, 1.0f, if (intWidthB <= 2) 1 else -1, intWidthB)

    // Test case 2
    test_fp_mul_int(dut, 2, 0.5f, if (intWidthB <= 2) 0 else -2, intWidthB)

    // Test case 3
    test_fp_mul_int(dut, 3, 0.005f, if (intWidthB <= 2) 1 else 3, intWidthB)

    // Test case 4
    test_fp_mul_int(dut, 4, 0.005f, 0, intWidthB)

    // Run random test cases
    generateTestCases(intWidthB).zipWithIndex.foreach { case ((a, b), index) =>
      test_fp_mul_int(dut, index + 5, a, b, intWidthB)
    }
  }

  it should "perform FP16-int4 multiply correctly" in {
    test(new FPMULInt(topmodule = "fp_mul_int", typeA = FP16, typeB = Int4, typeC = FP32))
      .withAnnotations(Seq(VerilatorBackendAnnotation, WriteVcdAnnotation)) { dut =>
        runBasicTests(dut, 4)
      }
  }

  it should "perform FP16-int3 multiply correctly" in {
    test(new FPMULInt(topmodule = "fp_mul_int", typeA = FP16, typeB = Int3, typeC = FP32))
      .withAnnotations(Seq(VerilatorBackendAnnotation, WriteVcdAnnotation)) { dut =>
        runBasicTests(dut, 3)
      }
  }

  it should "perform FP16-int2 multiply correctly" in {
    test(new FPMULInt(topmodule = "fp_mul_int", typeA = FP16, typeB = Int2, typeC = FP32))
      .withAnnotations(Seq(VerilatorBackendAnnotation, WriteVcdAnnotation)) { dut =>
        runBasicTests(dut, 2)
      }
  }

  it should "perform FP16-int1 multiply correctly" in {
    test(new FPMULInt(topmodule = "fp_mul_int", typeA = FP16, typeB = Int1, typeC = FP32))
      .withAnnotations(Seq(VerilatorBackendAnnotation, WriteVcdAnnotation)) { dut =>
        runBasicTests(dut, 1)
      }
  }
}
