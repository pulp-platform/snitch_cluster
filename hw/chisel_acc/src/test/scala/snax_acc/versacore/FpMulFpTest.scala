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

class FPMULFPTest extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "FPMULFP"

  it should "perform fp16 multiply fp16 correctly" in {
    test(
      new FPMULFP(
        topmodule = "fp_mul",
        widthA    = 16,
        widthB    = 16,
        widthC    = 32
      )
    ).withAnnotations(Seq(VerilatorBackendAnnotation, WriteVcdAnnotation)) { dut =>

      def test_fp_mul_fp(test_id: Int, A: Float, B: Float) = {
        val A_fp16 = uintToFloat(
          fp16.expWidth,
          fp16.sigWidth,
          floatToUInt(fp16.expWidth, fp16.sigWidth, A)
        ) // Convert to 16-bit representation
        val B_fp16 = uintToFloat(
          fp16.expWidth,
          fp16.sigWidth,
          floatToUInt(fp16.expWidth, fp16.sigWidth, B)
        ) // Convert to 16-bit representation

        val gold_O = A_fp16 * B_fp16 // Expected result

        println(
          f"-----------Test id: $test_id, A_fp16: 0x${A_fp16} , B_fp16: 0x${B_fp16},  gold_O: 0x${gold_O}-----------"
        )
        val stimulus_a_i = floatToUInt(fp16.expWidth, fp16.sigWidth, A)      // Convert to 16-bit representation
        val stimulus_b_i = floatToUInt(fp16.expWidth, fp16.sigWidth, B)      // Direct 4-bit integer
        val expected_o   = floatToUInt(fp32.expWidth, fp32.sigWidth, gold_O) // Expected output as UInt
        println(
          f"-----------Test id: $test_id, stimulus_a_i: 0x${stimulus_a_i} , stimulus_b_i: 0x${stimulus_b_i},  gold_O: 0x${gold_O}-----------"
        )
        dut.io.operand_a_i.poke(stimulus_a_i.U)
        dut.io.operand_b_i.poke(stimulus_b_i.U)

        dut.clock.step()
        dut.clock.step()

        val reseult = dut.io.result_o.peek().litValue
        // val reseult_int =   floatToUInt(fp32.expWidth, fp32.sigWidth, reseult)
        println(
          f"-----------Test id: $test_id, Expected: 0x${expected_o.toString(16)} , 0x${reseult.toString(16)}------------"
        )
        // try {
        //   assert(reseult == expected_o)
        // } catch {
        //   case _: java.lang.AssertionError => {
        //     println(
        //       f"----Error!!!!------------------Test id: $test_id Expected: 0x${expected_o.toString(16)}, Got: 0x${reseult.toString(16)}-----------"
        //     )
        //   }
        // }
        assert(reseult == expected_o)

        dut.clock.step()
        dut.clock.step()
      }

      val A = -1.0101f // float16
      val B = 0.1245f  // float16

      test_fp_mul_fp(1, A, B)

      // Generate 10 random test cases
      val test_num  = 10
      val testCases = Seq.fill(test_num)(
        (
          Random.nextFloat() * 200 - 100, // Random float between -100 and 100
          Random.nextFloat() * 200 - 100  // Random float between -100 and 100
        )
      )

      testCases.zipWithIndex.foreach { case ((a, b), index) =>
        test_fp_mul_fp(index + 1, a, b)
      }

    }
  }
}
