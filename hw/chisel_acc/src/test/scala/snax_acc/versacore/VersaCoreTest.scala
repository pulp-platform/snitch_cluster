// Copyright 2025 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Xiaoling Yi <xiaoling.yi@kuleuven.be>

package snax_acc.versacore

import scala.util.Random

import chisel3._

import chiseltest._
import fp_unit._
import org.scalatest.flatspec.AnyFlatSpec
import snax_acc.utils.CommonTestUtils.WaitOrTimeout
import snax_acc.utils.CommonTestUtils.toSInt
import snax_acc.utils.DecoupledCut._
import snax_acc.utils.MatrixLibBlock.temporalToSpatialIndicesAB

class VersaCoreHarness(params: SpatialArrayParam) extends Module with RequireAsyncReset {
  val dut = Module(new VersaCore(params))
  val io  = IO(chiselTypeOf(dut.io))

  io.ctrl <> dut.io.ctrl
  io.data <> dut.io.data
  io.data.in_a -||> dut.io.data.in_a
  io.data.in_b -||> dut.io.data.in_b
  io.data.in_c -||> dut.io.data.in_c

  io.busy_o              := dut.io.busy_o
  io.performance_counter := dut.io.performance_counter
}

trait VersaCoreTestHelper extends AnyFlatSpec with ChiselScalatestTester {
  // Define the function to test a single configuration
  def testSingleConfig(params: SpatialArrayParam, dataTypeIdx: Int, arrayShapeIdx: Int): Unit = {
    test(new VersaCoreHarness(params)).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      println(s"Testing dataTypeIdx${dataTypeIdx + 1} arrayShapeIdx_cfg${arrayShapeIdx + 1}...")

      // Get the current configuration parameters
      val inputTypeA  = params.inputTypeA(dataTypeIdx)
      val inputTypeB  = params.inputTypeB(dataTypeIdx)
      val inputTypeC  = params.inputTypeC(dataTypeIdx)
      val outputTypeD = params.outputTypeD(dataTypeIdx)

      val Mu = params.arrayDim(dataTypeIdx)(arrayShapeIdx)(0)
      val Ku = params.arrayDim(dataTypeIdx)(arrayShapeIdx)(1)
      val Nu = params.arrayDim(dataTypeIdx)(arrayShapeIdx)(2)

      val sizeRange = 1
      val rand      = new Random()
      val M         = rand.nextInt(sizeRange) + 1
      val N         = rand.nextInt(sizeRange) + 1
      val K         = rand.nextInt(sizeRange) + 1

      println(s"Parameters: M=$M, N=$N, K=$K, Mu=$Mu, Ku=$Ku, Nu=$Nu")

      // Generate test data
      val aValues = Array.fill(Mu * Ku * M * K)(rand.nextInt(math.pow(2, inputTypeA.width).toInt))
      val bValues = Array.fill(Ku * Nu * N * K)(rand.nextInt(math.pow(2, inputTypeB.width).toInt))
      // val cValues = Array.fill(Mu * Nu * M * N)(rand.nextInt(1))
      val cValues = Array.fill(Mu * Nu * M * N)(rand.nextInt(math.pow(2, inputTypeC.width).toInt))

      // Compute the expected result
      val expectedResult = Array.tabulate(M, N) { (m2, n2) =>
        val acc = Array.fill(Mu, Nu)(0)

        // Matrix multiplication part
        for (k2 <- 0 until K) {
          for (m1 <- 0 until Mu) {
            for (n1 <- 0 until Nu) {
              var sum = 0
              for (k1 <- 0 until Ku) {
                val aIdx = m2 * K * Mu * Ku + k2 * Mu * Ku + m1 * Ku + k1
                val bIdx = n2 * K * Nu * Ku + k2 * Nu * Ku + n1 * Ku + k1

                val aSInt = toSInt(
                  aValues(aIdx),
                  inputTypeA.width
                )
                val bSInt = toSInt(
                  bValues(bIdx),
                  inputTypeB.width
                )

                sum += aSInt * bSInt
              }
              acc(m1)(n1) += sum
            }
          }
        }

        // Add the C matrix
        for {
          m1 <- 0 until Mu
          n1 <- 0 until Nu
        } {
          val cIdx = m2 * N * Mu * Nu + n2 * Mu * Nu + m1 * Nu + n1
          val cVal = toSInt(cValues(cIdx), inputTypeC.width)
          acc(m1)(n1) += cVal
          acc(m1)(n1) = (acc(m1)(n1) & ((1L << outputTypeD.width) - 1)).toInt
        }

        acc
      }

      // Print the generated values in SInt format
      // println("Generated aValues:")
      // for (i <- aValues.indices) {
      //   val aSInt = toSInt(aValues(i), inputTypeA.width)
      //   println(f"$aSInt")
      // }
      // println("Generated bValues:")
      // for (i <- bValues.indices) {
      //   val bSInt = toSInt(bValues(i), inputTypeB.width)
      //   println(f"$bSInt")
      // }
      // println("Generated cValues:")
      // for (i <- cValues.indices) {
      //   val cSInt = toSInt(cValues(i), inputTypeC.width)
      //   println(f"$cSInt")
      // }

      // // Print the expected result
      // for (m2 <- 0 until M) {
      //   for (n2 <- 0 until N) {
      //     println(s"Block ($m2, $n2):")
      //     val block = expectedResult(m2)(n2)
      //     for (m1 <- 0 until Mu) {
      //       for (n1 <- 0 until Nu) {
      //         print(f"${block(m1)(n1)}%6d ")
      //       }
      //       println() // Newline after each row
      //     }
      //     println() // Extra newline between blocks
      //   }
      // }

      // Configure hardware
      dut.clock.step(5)
      dut.io.ctrl.bits.fsmCfg.K_i.poke(K.U)
      dut.io.ctrl.bits.fsmCfg.N_i.poke(N.U)
      dut.io.ctrl.bits.fsmCfg.M_i.poke(M.U)
      dut.io.ctrl.bits.fsmCfg.subtraction_constant_i.poke(0.U)
      dut.io.ctrl.bits.arrayCfg.arrayShapeCfg.poke(arrayShapeIdx.U)
      dut.io.ctrl.bits.arrayCfg.dataTypeCfg.poke(dataTypeIdx.U)
      dut.io.ctrl.valid.poke(true.B)
      WaitOrTimeout(dut.io.ctrl.ready, dut.clock)
      dut.clock.step(1)
      dut.io.ctrl.valid.poke(false.B)

      // Concurrent thread management
      var concurrent_threads = new chiseltest.internal.TesterThreadList(Seq())

      // A input injection thread
      concurrent_threads = concurrent_threads.fork {
        for (temporalIndexInput <- 0 until M * K * N) {
          val (indexA, _) = temporalToSpatialIndicesAB(temporalIndexInput, K = K, N = N)
          val aValues_cur = aValues
            .slice(indexA * Mu * Ku, indexA * Mu * Ku + Mu * Ku)
            .zipWithIndex
            .map { case (v, i) => BigInt(v) << (i * inputTypeA.width) }
            .sum

          dut.clock.step(Random.between(1, 5))
          dut.io.data.in_a.bits.poke(aValues_cur.U)
          dut.io.data.in_a.valid.poke(true.B)
          WaitOrTimeout(dut.io.data.in_a.ready, dut.clock)
          assert(dut.io.data.in_a.ready.peekBoolean())

          dut.clock.step(1)
          dut.io.data.in_a.valid.poke(false.B)
        }
      }

      // B input injection thread
      concurrent_threads = concurrent_threads.fork {
        for (temporalIndexInput <- 0 until M * K * N) {
          val (_, indexB) = temporalToSpatialIndicesAB(temporalIndexInput, K = K, N = N)
          val bValues_cur = bValues
            .slice(indexB * Nu * Ku, indexB * Nu * Ku + Nu * Ku)
            .zipWithIndex
            .map { case (v, i) => BigInt(v) << (i * inputTypeB.width) }
            .sum

          dut.clock.step(Random.between(1, 5))
          dut.io.data.in_b.bits.poke(bValues_cur.U)
          dut.io.data.in_b.valid.poke(true.B)
          WaitOrTimeout(dut.io.data.in_b.ready, dut.clock)
          assert(dut.io.data.in_b.ready.peekBoolean())

          dut.clock.step(1)
          dut.io.data.in_b.valid.poke(false.B)
        }
      }

      // C input injection thread
      concurrent_threads = concurrent_threads.fork {
        for (temporalIndex <- 0 until M * N) {
          val cValues_cur = cValues
            .slice(temporalIndex * Mu * Nu, temporalIndex * Mu * Nu + Mu * Nu)
            .zipWithIndex
            .map { case (v, i) => BigInt(v) << (i * inputTypeC.width) }
            .sum

          dut.clock.step(Random.between(1, 5))
          dut.io.data.in_c.bits.poke(cValues_cur.U)
          dut.io.data.in_c.valid.poke(true.B)
          WaitOrTimeout(dut.io.data.in_c.ready, dut.clock)

          dut.clock.step(1)
          dut.io.data.in_c.valid.poke(false.B)
        }
      }

      // Output checking thread
      concurrent_threads = concurrent_threads.fork {
        for (outputTemporalIndex <- 0 until M * N) {
          WaitOrTimeout(dut.io.data.out_d.valid, dut.clock)

          val expected = expectedResult.flatten.flatten.flatten
            .slice(outputTemporalIndex * Mu * Nu, (outputTemporalIndex + 1) * Mu * Nu)
          val out_d    = dut.io.data.out_d.bits.peek().litValue
          val output   = (0 until (Mu * Nu)).map { i =>
            ((out_d >> (i * outputTypeD.width)) & (math.pow(2, outputTypeD.width).toLong - 1)).toInt
          }

          for (i <- output.indices) {
            assert(
              output(i) == expected(i),
              f"Mismatch at index $i: got 0x${output(i)}%X, expected 0x${expected(i)}%X"
            )
          }
          dut.clock.step(Random.between(1, 5))
          dut.io.data.out_d.ready.poke(true.B)
          dut.clock.step(1)
          dut.io.data.out_d.ready.poke(false.B)
        }
      }

      // Wait for all threads to finish
      concurrent_threads.join()

      // check busy_o
      dut.clock.step(10)
      dut.io.busy_o.expect(false.B)
      dut.clock.step(1)
    }
  }

}

class VersaCoreTest extends VersaCoreTestHelper {

  behavior of "VersaCore"
  it should "correctly process configuration and data" in {

    // Define the test parameters
    val paramsList = Seq(
      SpatialArrayParam(
        macNum                 = Seq(8, 16),
        inputTypeA             = Seq(Int8, Int4),
        inputTypeB             = Seq(Int8, Int4),
        inputTypeC             = Seq(Int32, Int16),
        outputTypeD            = Seq(Int32, Int16),
        arrayInputAWidth       = 64,
        arrayInputBWidth       = 64,
        arrayInputCWidth       = 256,
        arrayOutputDWidth      = 256,
        serialInputADataWidth  = 64,
        serialInputBDataWidth  = 64,
        serialInputCDataWidth  = 256,
        serialOutputDDataWidth = 256,
        arrayDim               = Seq(Seq(Seq(2, 2, 2), Seq(2, 1, 4)), Seq(Seq(2, 4, 2), Seq(2, 1, 8)))
      ),
      // test different data types
      SpatialArrayParam(
        macNum                 = Seq(8),
        inputTypeA             = Seq(Int16),
        inputTypeB             = Seq(Int4),
        inputTypeC             = Seq(Int32),
        outputTypeD            = Seq(Int32),
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
    )

    // Run the tests
    for (params <- paramsList) {
      for (dataTypeIdx <- params.inputTypeA.indices) {
        for (arrayShapeIdx <- params.arrayDim(dataTypeIdx).indices) {
          testSingleConfig(params, dataTypeIdx, arrayShapeIdx)
        }
      }
    }
  }
}
