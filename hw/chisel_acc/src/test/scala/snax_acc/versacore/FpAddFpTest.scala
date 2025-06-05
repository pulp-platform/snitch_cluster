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

class FP32AddFP32Test extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "FPAddFP"

  it should "perform fp32 add fp32 correctly" in {
    test(
      new FPAddFP(
        topmodule = "fp_add",
        widthA    = 32, // Changed to 32-bit
        widthB    = 32, // Changed to 32-bit
        widthC    = 32  // Output remains 32-bit
      )
    ).withAnnotations(Seq(VerilatorBackendAnnotation, WriteVcdAnnotation)) { dut =>

      def test_fp_add_fp(test_id: Int, A: Float, B: Float) = {
        val A_fp32 = uintToFloat(
          fp32.expWidth,
          fp32.sigWidth,
          floatToUInt(fp32.expWidth, fp32.sigWidth, A)
        )
        val B_fp32 = uintToFloat(
          fp32.expWidth,
          fp32.sigWidth,
          floatToUInt(fp32.expWidth, fp32.sigWidth, B)
        )

        val gold_O = A_fp32 + B_fp32 // Expected result

        val stimulus_a_i = floatToUInt(fp32.expWidth, fp32.sigWidth, A)
        val stimulus_b_i = floatToUInt(fp32.expWidth, fp32.sigWidth, B)

        val expected_o = floatToUInt(fp32.expWidth, fp32.sigWidth, gold_O)

        dut.io.operand_a_i.poke(stimulus_a_i.U)
        dut.io.operand_b_i.poke(stimulus_b_i.U)

        dut.clock.step()
        dut.clock.step()

        val result = dut.io.result_o.peek().litValue
        println(f"-----------Test id: $test_id-----------")
        println(f"Expected: 0x${expected_o.toString(16)}, Got: 0x${result.toString(16)}")
        println(f"Float expected: ${gold_O}, Result float: ${uintToFloat(fp32.expWidth, fp32.sigWidth, result)}")

        // try {
        //   assert(result == expected_o)
        // } catch {
        //   case _: java.lang.AssertionError => {
        //     println(f"----Error!!!!------- Assertion failed on test $test_id")
        //   }
        // }
        assert(result == expected_o)

        dut.clock.step()
        dut.clock.step()
      }

      val A = -1f
      val B = 4.5f

      test_fp_add_fp(1, A, B)

      // Generate random test cases
      val test_num  = 100
      val testCases = Seq.fill(test_num)(
        (
          Random.nextFloat() * 1000 - 1000,
          Random.nextFloat() * 1000 - 1000
        )
      )

      testCases.zipWithIndex.foreach { case ((a, b), index) =>
        test_fp_add_fp(index + 2, a, b)
      }

    }
  }
}
