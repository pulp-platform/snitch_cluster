// Copyright 2025 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Xiaoling Yi <xiaoling.yi@kuleuven.be>

package snax_acc.versacore

import scala.util.Random

import chisel3._

import chiseltest._
import chiseltest.simulator.VerilatorBackendAnnotation
import org.scalatest.flatspec.AnyFlatSpec
import snax_acc.utils.fpUtils._

trait FPMULIntTestUtils {

  def test_fp_mul_int(dut: FPMULInt, test_id: Int, A: Float, B: Int, Bwidth: Int) = {
    val A_fp16 = uintToFloat(
      fp16.expWidth,
      fp16.sigWidth,
      floatToUInt(fp16.expWidth, fp16.sigWidth, A)
    ) // Convert to 16-bit representation

    var gold_O = 0.0f // Initialize expected output

    if (Bwidth == 1 && B == 0) {
      gold_O = A_fp16 * (-1) // Expected result
    } else if (Bwidth == 1 && B == 1) {
      gold_O = A_fp16 // Expected result
    } else {
      gold_O = A_fp16 * B // Expected result
    }

    println(
      f"-----------Test id: $test_id, A_fp16: ${A_fp16} , B: ${B},  gold_O: ${gold_O}-----------"
    )

    val stimulus_a_i = floatToUInt(fp16.expWidth, fp16.sigWidth, A) // Convert to 16-bit representation
    val stimulus_b_i =
      (BigInt(B) & ((BigInt(
        1
      ) << Bwidth) - 1)).U // B is an integer, int2uint conversion needed for sending it to the DUT
    val expected_o = floatToUInt(fp32.expWidth, fp32.sigWidth, gold_O) // Expected output as UInt

    dut.io.operand_a_i.poke(stimulus_a_i.U)
    dut.io.operand_b_i.poke(stimulus_b_i)

    dut.clock.step()
    dut.clock.step()

    val reseult = dut.io.result_o.peek().litValue
    println(
      f"-----------Test id: $test_id Expected: 0x${expected_o.toString(16)}, Got: 0x${reseult.toString(16)}-----------"
    )

    // try {
    //   assert(reseult == expected_o)
    // } catch {
    //   case _: java.lang.AssertionError => {
    //     println(
    //       f"----Error!!!!-------Test id: $test_id Expected: 0x${expected_o.toString(16)}, Got: 0x${reseult.toString(16)}-----------"
    //     )
    //   }
    // }
    assert(reseult == expected_o)

    dut.clock.step()
    dut.clock.step()
  }

}

class FPMULInt4Test extends AnyFlatSpec with ChiselScalatestTester with FPMULIntTestUtils {

  behavior of "FPMULInt4"

  it should "perform fp16-int4 multiply correctly" in {
    test(
      new FPMULInt(
        topmodule = "fp_mul_int",
        widthA    = 16,
        widthB    = 4,
        widthC    = 32
      )
    ).withAnnotations(Seq(VerilatorBackendAnnotation, WriteVcdAnnotation)) { dut =>

      var A = 1.0f // float16
      var B = -1   // int4

      test_fp_mul_int(dut, 1, A, B, 4)

      A = 0.5f
      B = -2

      test_fp_mul_int(dut, 2, A, B, 4)

      A = 0.005f
      B = 7

      test_fp_mul_int(dut, 3, A, B, 4)

      A = 0.005f
      B = 0

      test_fp_mul_int(dut, 4, A, B, 4)

      new Random()

      // Generate 10 test cases with:
      // - A: Random Float16-compatible float
      // - B: Random integer
      val test_num  = 10
      val testCases = Seq.fill(test_num)(
        (
          (Random.nextFloat() * 20 - 10), // A: Random float between -10 and 10
          Random.nextInt(15) - 8          // B: Random int between -8 and 7
        )
      )

      testCases.zipWithIndex.foreach { case ((a, b), index) =>
        test_fp_mul_int(dut, index + 1, a, b, 4)
      }

    }
  }

}

class FPMULInt3Test extends AnyFlatSpec with ChiselScalatestTester with FPMULIntTestUtils {

  it should "perform fp16-int3 multiply correctly" in {
    test(
      new FPMULInt(
        topmodule = "fp_mul_int",
        widthA    = 16,
        widthB    = 3,
        widthC    = 32
      )
    ).withAnnotations(Seq(VerilatorBackendAnnotation, WriteVcdAnnotation)) { dut =>

      var A = 1.0f // float16
      var B = 1    // int3

      test_fp_mul_int(dut, 1, A, B, 3)

      A = 0.5f
      B = 2

      test_fp_mul_int(dut, 2, A, B, 3)

      A = 0.005f
      B = 3

      test_fp_mul_int(dut, 3, A, B, 3)

      A = 0.005f
      B = 0

      test_fp_mul_int(dut, 4, A, B, 3)

      val random = new Random()

      // Generate 10 test cases with:
      // - A: Random Float16-compatible float
      // - B: Random integer
      val test_num  = 10
      val testCases = Seq.fill(test_num)(
        (
          (random.nextFloat() * 20 - 10), // A: Random float between -10 and 10
          random.nextInt(7) - 4           // B: Random int between -4 and 3
        )
      )

      testCases.zipWithIndex.foreach { case ((a, b), index) =>
        test_fp_mul_int(dut, index + 1, a, b, 3)
      }

    }
  }
}

class FPMULInt2Test extends AnyFlatSpec with ChiselScalatestTester with FPMULIntTestUtils {

  it should "perform fp16-int2 multiply correctly" in {
    test(
      new FPMULInt(
        topmodule = "fp_mul_int",
        widthA    = 16,
        widthB    = 2,
        widthC    = 32
      )
    ).withAnnotations(Seq(VerilatorBackendAnnotation, WriteVcdAnnotation)) { dut =>

      var A = 1.0f // float16
      var B = 1    // int2

      test_fp_mul_int(dut, 1, A, B, 2)

      A = 0.5f
      B = 1

      test_fp_mul_int(dut, 2, A, B, 2)

      A = 0.015f
      B = 0

      test_fp_mul_int(dut, 3, A, B, 2)

      A = 0.005f
      B = 0

      test_fp_mul_int(dut, 4, A, B, 2)

      val random = new Random()

      // Generate 10 test cases with:
      // - A: Random Float16-compatible float
      // - B: Random integer
      val test_num  = 10
      val testCases = Seq.fill(test_num)(
        (
          (random.nextFloat() * 20 - 10), // A: Random float between -10 and 10
          random.nextInt(3) - 2           // B: Random int between -2 and 1
        )
      )

      testCases.zipWithIndex.foreach { case ((a, b), index) =>
        test_fp_mul_int(dut, index + 1, a, b, 2)
      }

    }
  }
}

class FPMULInt1Test extends AnyFlatSpec with ChiselScalatestTester with FPMULIntTestUtils {

  it should "perform fp16-int1 multiply correctly" in {
    test(
      new FPMULInt(
        topmodule = "fp_mul_int",
        widthA    = 16,
        widthB    = 1,
        widthC    = 32
      )
    ).withAnnotations(Seq(VerilatorBackendAnnotation, WriteVcdAnnotation)) { dut =>

      var A = 1.0f // float16
      var B = 1    // int1

      test_fp_mul_int(dut, 1, A, B, 1)

      A = 0.5f
      B = 0

      test_fp_mul_int(dut, 2, A, B, 1)

      A = 0.005f
      B = 1

      test_fp_mul_int(dut, 3, A, B, 1)

      A = 0.005f
      B = 0

      test_fp_mul_int(dut, 4, A, B, 1)

      val random = new Random()

      // Generate 10 test cases with:
      // - A: Random Float16-compatible float
      // - B: Random integer
      val test_num  = 10
      val testCases = Seq.fill(test_num)(
        (
          (random.nextFloat() * 20 - 10), // A: Random float between -10 and 10
          random.nextInt(1) // B: Random int between 0 and 1, 1 means positive, 0 means negative in int1 representation
        )
      )

      testCases.zipWithIndex.foreach { case ((a, b), index) =>
        test_fp_mul_int(dut, index + 1, a, b, 1)
      }

    }
  }
}
