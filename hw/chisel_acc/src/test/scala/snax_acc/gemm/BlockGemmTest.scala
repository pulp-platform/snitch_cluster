package snax_acc.gemm

import chisel3._

import chiseltest._
import chiseltest.internal.TesterThreadList
import org.scalatest.flatspec.AnyFlatSpec
import snax_acc.utils.MatrixLibBase.CheckResults
import snax_acc.utils.MatrixLibBlock._

/** A trait with basic gemm test function to be used in different test */
trait AbstractBlockGemmTest {

  /** Step the clock until the given signal asserts, or stop after timeout
    * @param signal
    *   Signal to wait for until it is asserted
    * @param timeout
    *   Assert after this number of cycles
    */
  def WaitOrTimeout(signalToAssert: Bool, clock: Clock, timeout: Int = 100) = {
    var waitCnt = 0
    while (!signalToAssert.peekBoolean()) {
      if (waitCnt > timeout) {
        println(s"Timeout at cycle ${clock.getStepCount} for signal ${signalToAssert}")
        assert(false)
      }
      clock.step(1)
      waitCnt += 1
    }
  }

  /** Block gemm test generation function */
  def BlockGemmRandomTest[T <: BlockGemmDelayedWrapper](dut: T, size_M: Int, size_K: Int, size_N: Int) = {
    val params = dut.params

    // Randomly generation of input matrices
    val (matrix_A, matrix_B, matrix_C) = GenBlockMatrices(size_M, size_K, size_N, dut.params)

    // Convert the sub-matrices to a big bus
    val (split_matrix_A, split_matrix_B, split_matrix_C) =
      SplitBlockMatrix(size_M, size_K, size_N, matrix_A, matrix_B, matrix_C, params)

    // Outputs
    val golden_array   = BlockMatrixMul_1D(size_M, size_K, size_N, matrix_A, matrix_B, matrix_C, params)
    val split_matrix_D = Array.ofDim[BigInt](size_M * size_N)

    // Set up configuration
    dut.clock.step(5)
    dut.io.ctrl.bits.K_i.poke(size_K)
    dut.io.ctrl.bits.N_i.poke(size_N)
    dut.io.ctrl.bits.M_i.poke(size_M)
    dut.io.ctrl.bits.subtraction_constant_i.poke(0.U)
    dut.io.ctrl.valid.poke(true.B)

    WaitOrTimeout(dut.io.ctrl.ready, dut.clock)
    dut.clock.step(1)
    dut.io.ctrl.valid.poke(false.B)

    // Always ready to accept output data. This must happen before the concurrent threads because the data_in.ready
    // signal is combinatorially connected to this signal
    dut.io.data.d_o.ready.poke(true.B)

    var concurrent_threads = new TesterThreadList(Seq())

    // A, B Input injector
    concurrent_threads = concurrent_threads.fork {

      // dut.clock.step(Random.between(1, 16))
      for (temporalIndexInput <- 0 until size_M * size_N * size_K) {
        val (indexA, indexB) = temporalToSpatialIndicesAB(temporalIndexInput, K = size_K, N = size_N)
        // A, B
        dut.io.data.a_i.bits.poke(split_matrix_A(indexA))
        dut.io.data.b_i.bits.poke(split_matrix_B(indexB))
        dut.io.data.a_i.valid.poke(true.B)
        dut.io.data.b_i.valid.poke(true.B)
        WaitOrTimeout(dut.io.data.a_i.ready, dut.clock)
        assert(dut.io.data.b_i.ready.peekBoolean() && dut.io.data.b_i.ready.peekBoolean())

        dut.clock.step(1) // Valid needs to be asserted for >=1 cycle

        dut.io.data.a_i.valid.poke(false.B)
        dut.io.data.b_i.valid.poke(false.B)
      }
    }

    // C injector
    concurrent_threads = concurrent_threads.fork {

      // dut.clock.step(Random.between(1, 16))
      for (temporalIndex <- 0 until size_M * size_N) {
        val indexC = temporalToSpatialIndexD(temporalIndex, M = size_M, N = size_N)

        dut.io.data.c_i.bits.poke(split_matrix_C(indexC))
        dut.io.data.c_i.valid.poke(true.B)
        WaitOrTimeout(dut.io.data.c_i.ready, dut.clock)

        dut.clock.step(1) // Valid needs to be asserted for >=1 cycle

        dut.io.data.c_i.valid.poke(false.B)
      }
    }

    // Output checker
    concurrent_threads = concurrent_threads.fork {
      for (outputTemporalIndex <- 0 until size_M * size_N) {
        WaitOrTimeout(dut.io.data.d_o.valid, dut.clock)
        // println(s"Received output tile $outputTemporalIndex at cycle ${dut.clock.getStepCount}")
        val result = dut.io.data.d_o.bits.peekInt()
        val indexD = temporalToSpatialIndexD(outputTemporalIndex, M = size_M, N = size_N)
        split_matrix_D(indexD) = result
        dut.clock.step(1)
      }
    }

    concurrent_threads.joinAndStep()

    // Compare the output data with the golden model
    CheckResults(split_matrix_D, golden_array)
    println(s"Test passed for M = $size_M, K = $size_K, N = $size_N")
  }

}

/** Random size of input matrices and Integer 8 data test and check with the results of Block Gemm with golden model */
class BlockGemmTest extends AnyFlatSpec with ChiselScalatestTester with AbstractBlockGemmTest {
  "BlockGemm" should "work in corner case configurations" in {
    test(new BlockGemmDelayedWrapper(TestParameters.testConfig))
      .withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
        dut.clock.step(5)
        BlockGemmRandomTest(dut, 1, 1, 1)
        BlockGemmRandomTest(dut, 1, 2, 1)
        BlockGemmRandomTest(dut, 1, 1, 4)
        BlockGemmRandomTest(dut, 4, 1, 1)
        BlockGemmRandomTest(dut, 2, 2, 2)
      }
  }

  "BlockGemm" should "correctly compute randomly sized matrices" in {
    test(new BlockGemmDelayedWrapper(DefaultConfig.gemmConfig)).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      val nbTests = 10
      for (_ <- 0 until nbTests) {
        // Randomly generate the size of the input matrices
        val (size_M, size_K, size_N) = GenRandSizeTest()
        BlockGemmRandomTest(dut, size_M, size_K, size_N)
      }

    }
  }

}
