package snax_acc.gemm

import chisel3._

import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import snax_acc.utils.MatrixLibBase._

class GemmArrayTest extends AnyFlatSpec with ChiselScalatestTester {

  // Random Integer 8 data test and check with the results of Gemm with golden model
  // TODO Add C is not tested
  "GemmArray" should "correctly compute INT8 GeMM" in {
    test(new GemmArray(TestParameters.testConfig)).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>

      val meshRow  = dut.params.meshRow
      val tileSize = dut.params.tileSize
      val meshCol  = dut.params.meshCol

      /** Generate Random Integer 8 data (from -128 to 127) */
      def RandomTest() = {
        val random_matrix_A                = GenRandomMatrix(meshRow, tileSize)
        val random_matrix_B                = GenRandomMatrix(tileSize, meshCol)
        val (subtraction_a, subtraction_b) = GenRandomSubtractionValue()

        // Generate golden result data for verification
        val goldenMatrix   =
          MatrixMul_1D(
            meshRow,
            tileSize,
            meshCol,
            random_matrix_A,
            random_matrix_B,
            subtraction_a,
            subtraction_b
          )
        val goldenBus      = MatrixArray2BigBus(meshRow, meshCol, goldenMatrix, dut.params.dataWidthAccum)
        // Translate data array to big bus for Gemm module input
        val RandomBigBus_A = MatrixArray2BigBus(meshRow, tileSize, random_matrix_A, dut.params.dataWidthA)
        val RandomBigBus_B = MatrixArray2BigBus(tileSize, meshCol, random_matrix_B, dut.params.dataWidthB)

        // Inputs to start computation
        dut.io.data.c_i.poke(0.U)
        dut.io.ctrl.dotprod_a_b.poke(1.U)
        dut.io.ctrl.add_c_i.poke(1.U)
        dut.io.ctrl.d_ready_i.poke(false.B)

        dut.io.ctrl.subtraction_a_i.poke(subtraction_a)
        dut.io.ctrl.subtraction_b_i.poke(subtraction_b)
        dut.io.data.a_i.poke(RandomBigBus_A)
        dut.io.data.b_i.poke(RandomBigBus_B)

        dut.clock.step(1)
        dut.io.ctrl.dotprod_a_b.poke(0.U)
        dut.io.ctrl.add_c_i.poke(0.U)

        // Wait for data_valid_o assert, then take the result
        while (!dut.io.ctrl.d_valid_o.peekBoolean()) dut.clock.step(1)

        val results = dut.io.data.d_o.peekInt()
        dut.io.ctrl.d_ready_i.poke(true.B)
        dut.clock.step(1)
        dut.io.ctrl.d_ready_i.poke(true.B)

        CheckResults(Array(results), Array(goldenBus))

        dut.clock.step(10)
      }

      dut.clock.step(1)
      val TestLoop = 3

      for (_ <- 0 until TestLoop) RandomTest()

    }
  }
}
