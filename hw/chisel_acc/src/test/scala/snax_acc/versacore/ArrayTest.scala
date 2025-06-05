// Copyright 2025 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Xiaoling Yi <xiaoling.yi@kuleuven.be>

package snax_acc.versacore

import scala.util.Random

import chisel3._

import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import snax_acc.utils.CommonTestUtils.toSInt

class SpatialArrayTest extends AnyFlatSpec with ChiselScalatestTester {

  "SpatialArray" should "correctly compute output with different array dimensions" in {

    def testArray(params: SpatialArrayParam): Unit = {

      test(new SpatialArray(params)).withAnnotations(Seq(WriteVcdAnnotation)) { c =>
        val rand = new Random()

        (0 until params.opType.length).map { dataTypeIdx =>

          (0 until params.arrayDim(dataTypeIdx).length).map { arrayShapeIdx =>
            // Get the parameters for the current configuration
            val inputAElemWidth  = params.inputAElemWidth(dataTypeIdx)
            val inputBElemWidth  = params.inputBElemWidth(dataTypeIdx)
            val outputDElemWidth = params.outputDElemWidth(dataTypeIdx)

            val Mu = params.arrayDim(dataTypeIdx)(arrayShapeIdx)(0)
            val Ku = params.arrayDim(dataTypeIdx)(arrayShapeIdx)(1)
            val Nu = params.arrayDim(dataTypeIdx)(arrayShapeIdx)(2)

            // Generate random values for 'a' and 'b'
            val aValues = Array.fill(Mu * Ku)(rand.nextInt(math.pow(2, inputAElemWidth).toInt))
            val bValues = Array.fill(Ku * Nu)(rand.nextInt(math.pow(2, inputBElemWidth).toInt))

            // Print the generated values in 0x format
            // println(s"Generated aValues: ${aValues.map(v => f"0x$v%X").mkString(", ")}")
            // println(s"Generated bValues: ${bValues.map(v => f"0x$v%X").mkString(", ")}")

            // Construct 'a' and 'b' from the random values
            val a = aValues.zipWithIndex.map { case (v, i) => BigInt(v) << (i * inputAElemWidth) }.sum
            val b = bValues.zipWithIndex.map { case (v, i) => BigInt(v) << (i * inputBElemWidth) }.sum

            // Compute dot product treating aValues and bValues as SInt
            val expectedResult = Array.tabulate(Mu, Nu) { (i, j) =>
              (0 until Ku).map { k =>
                val aSInt = toSInt(
                  aValues(i * Ku + k),
                  inputAElemWidth,
                  params.opType(dataTypeIdx) == SIntSIntOp
                ) // Convert UInt to SInt
                val bSInt = toSInt(
                  bValues(k + j * Ku),
                  inputBElemWidth,
                  params.opType(dataTypeIdx) == SIntSIntOp
                ) // Convert UInt to SInt
                aSInt * bSInt
              }.sum
            }

            // Poke the random values
            c.io.data.in_a.bits.poke(a.U)
            c.io.data.in_b.bits.poke(b.U)
            c.io.data.in_c.bits.poke(0.U)

            // Enable valid signals
            c.io.data.in_a.valid.poke(true.B)
            c.io.data.in_b.valid.poke(true.B)
            c.io.data.in_c.valid.poke(true.B)
            c.io.data.in_substraction.valid.poke(false.B)
            c.io.data.out_d.ready.poke(true.B)

            c.io.ctrl.arrayShapeCfg.poke(arrayShapeIdx.U)
            c.io.ctrl.dataTypeCfg.poke(dataTypeIdx.U)
            c.io.ctrl.accAddExtIn.poke(false.B)
            c.io.ctrl.accClear.poke(false.B)

            c.clock.step(1)

            // Check the output
            c.io.data.out_d.valid.expect(true.B)
            val out_d            = c.io.data.out_d.bits.peek().litValue
            val extractedOutputs = (0 until (Mu * Nu)).map { i =>
              ((out_d >> (i * outputDElemWidth)) & (math.pow(2, outputDElemWidth).toLong - 1)).toInt
            }

            println(s"Checking opType${dataTypeIdx + 1} res_cfg${arrayShapeIdx + 1}...")
            val expected = expectedResult.flatten
            for (i <- expected.indices) {
              val actual = extractedOutputs(i)
              // println(s"  Output[$i]: $actual (Expected: ${expected(i)})")
              assert(actual == expected(i), f"Mismatch at index $i: got 0x$actual%X, expected 0x${expected(i)}%X")
            }

            c.io.ctrl.accClear.poke(true.B)
            c.clock.step(1)
            c.io.ctrl.accClear.poke(false.B)

          }
        }
      }
    }

    var params = SpatialArrayParam(
      opType                 = Seq(UIntUIntOp),
      macNum                 = Seq(1024),
      inputAElemWidth        = Seq(8),
      inputBElemWidth        = Seq(8),
      inputCElemWidth        = Seq(32),
      mulElemWidth           = Seq(16),
      outputDElemWidth       = Seq(32),
      arrayInputAWidth       = 1024,
      arrayInputBWidth       = 8192,
      arrayInputCWidth       = 4096,
      arrayOutputDWidth      = 4096,
      serialInputADataWidth  = 1024,
      serialInputBDataWidth  = 8192,
      serialInputCDataWidth  = 512,
      serialOutputDDataWidth = 512,
      arrayDim               = Seq(Seq(Seq(16, 8, 8), Seq(1, 32, 32)))
    )

    // Test for each configuration
    testArray(params)

    // Test for a different configuration
    params = SpatialArrayParam(
      opType                 = Seq(SIntSIntOp, UIntUIntOp),
      // opType = Seq(UIntUIntOp, UIntUIntOp),
      macNum                 = Seq(8, 16),
      inputAElemWidth        = Seq(8, 4),
      inputBElemWidth        = Seq(8, 4),
      inputCElemWidth        = Seq(32, 16),
      mulElemWidth           = Seq(16, 8),
      outputDElemWidth       = Seq(32, 16),
      arrayInputAWidth       = 64,
      arrayInputBWidth       = 64,
      arrayInputCWidth       = 256,
      arrayOutputDWidth      = 256,
      serialInputADataWidth  = 64,
      serialInputBDataWidth  = 64,
      serialInputCDataWidth  = 512,
      serialOutputDDataWidth = 512,
      arrayDim               = Seq(Seq(Seq(2, 2, 2), Seq(2, 1, 4)), Seq(Seq(2, 4, 2), Seq(2, 1, 8)))
    )

    testArray(params)

    // Test for a different configuration

    params = SpatialArrayParam(
      opType                 = Seq(SIntSIntOp),
      macNum                 = Seq(8),
      inputAElemWidth        = Seq(16),
      inputBElemWidth        = Seq(4),
      inputCElemWidth        = Seq(32),
      mulElemWidth           = Seq(32),
      outputDElemWidth       = Seq(32),
      arrayInputAWidth       = 64,
      arrayInputBWidth       = 16,
      arrayInputCWidth       = 128,
      arrayOutputDWidth      = 128,
      serialInputADataWidth  = 64,
      serialInputBDataWidth  = 16,
      serialInputCDataWidth  = 128,
      serialOutputDDataWidth = 128,
      arrayDim               = Seq(Seq(Seq(2, 2, 2)))
    )

    testArray(params)
  }
}
