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

class FPMULFPTest extends AnyFlatSpec with ChiselScalatestTester with fpUtils {
  behavior of "FPMULFP"

  def test_fp_mul_fp(dut: FPMULFP, test_id: Int, A: Float, B: Float) = {

    // Quantize the float
    val A_uint     = floatToUInt(dut.typeA, A)
    val A_fp       = uintToFloat(dut.typeA, A_uint)
    val B_uint     = floatToUInt(dut.typeB, B)
    val B_fp       = uintToFloat(dut.typeB, B_uint)
    // Expected result
    val gold_o     = A_fp * B_fp
    val expected_o = floatToUInt(dut.typeC, gold_o)

    val stimulus_a_i = A_uint
    val stimulus_b_i = B_uint

    dut.io.operand_a_i.poke(stimulus_a_i.U)
    dut.io.operand_b_i.poke(stimulus_b_i.U)

    dut.clock.step(2)

    val result    = dut.io.result_o.peek().litValue
    val result_fp = uintToFloat(dut.typeC, result)

    try {
      // The testbench does not model the module's RNE (Round to Nearest, ties to Even), so result can be 1 bit higher
      // (but not lower!)
      assert(result - expected_o <= 1)
    } catch {
      case e: Throwable => {
        println(f"----Error in test id: $test_id----")
        println(f"A_fp: ${A_fp} , B_fp: ${B_fp},  gold_o: ${gold_o}")
        println(
          f"(expected) ${expected_o.toString(2).grouped(4).mkString("_")} (got) ${result.toString(2).grouped(4).mkString("_")}"
        )
        println(f"(expected) ${gold_o} (got) ${result_fp}")
        throw e
      }
    }

    dut.clock.step(2)
  }

  def test_all_fp_mul_fp(dut: FPMULFP) = {
    // Generate 10 random test cases
    val test_num  = 100
    val testCases = Seq.fill(test_num)(
      (
        Random.nextFloat() * 20 - 10, // Random float between -10 and 10
        Random.nextFloat() * 20 - 10
      )
    )
    testCases.zipWithIndex.foreach { case ((a, b), index) => test_fp_mul_fp(dut, index + 1, a, b) }

  }

  it should "perform FP16 x FP16 = FP32 correctly" in {
    test(
      new FPMULFP(topmodule = "fp_mul", typeA = FP16, typeB = FP16, typeC = FP32)
    ).withAnnotations(Seq(VerilatorBackendAnnotation, WriteVcdAnnotation)) { dut => test_all_fp_mul_fp(dut) }
  }

  it should "perform FP16 x FP16 = FP16 correctly" in {
    test(
      new FPMULFP(topmodule = "fp_mul", typeA = FP16, typeB = FP16, typeC = FP16)
    ).withAnnotations(Seq(VerilatorBackendAnnotation, WriteVcdAnnotation)) { dut => test_all_fp_mul_fp(dut) }
  }

  it should "perform BF16 x BF16 = FP32 correctly" in {
    test(
      new FPMULFP(topmodule = "fp_mul", typeA = BF16, typeB = BF16, typeC = FP32)
    ).withAnnotations(Seq(VerilatorBackendAnnotation, WriteVcdAnnotation)) { dut => test_all_fp_mul_fp(dut) }
  }

  it should "perform BF16 x BF16 = BF16 correctly" in {
    test(
      new FPMULFP(topmodule = "fp_mul", typeA = BF16, typeB = BF16, typeC = BF16)
    ).withAnnotations(Seq(VerilatorBackendAnnotation, WriteVcdAnnotation)) { dut => test_all_fp_mul_fp(dut) }
  }

  it should "perform BF16 x FP16 = FP32 correctly" in {
    test(
      new FPMULFP(topmodule = "fp_mul", typeA = BF16, typeB = BF16, typeC = BF16)
    ).withAnnotations(Seq(VerilatorBackendAnnotation, WriteVcdAnnotation)) { dut => test_all_fp_mul_fp(dut) }
  }
}
