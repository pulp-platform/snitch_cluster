package snax.DataPathExtension
import scala.math._
import scala.util.Random

import chiseltest._
import snax.DataPathExtension.HasRescaleUp

class RescaleUpTester extends DataPathExtensionTester(TreadleBackendAnnotation) {

  def GoldenModelUp(
    data_in:      Int,
    input_zp_i:   Int,
    output_zp_i:  Int,
    shift_i:      Int,
    max_int_i:    Int,
    min_int_i:    Int,
    multiplier_i: Int
  ): Int = {

    /** This function performs SIMD postprocessing of data given approximate algorithm of TOSA.rescale, with dynamically
      * scaled shifts.
      */

    // Step 1: Subtract input zero point
    val var_1 = data_in - input_zp_i

    // Step 2: Multiply with the multiplier avoiding overflow
    val var_2 = var_1.toLong * multiplier_i.toLong

    // Step 3: Left shift one
    val shifted_one = 1L << (shift_i - 1) // TODO: check if the minus one is actually correct

    // Step 4: Add shifted one
    val var_3 = var_2 + shifted_one

    // Step 6: Shift right
    val var_6 = (var_3 >> shift_i).toInt

    // Step 7: Add output zero point
    val var_7 = var_6 + output_zp_i

    // Step 8: Clip the values to be within min and max integer range
    val var_8 = math.max(min_int_i, math.min(max_int_i, var_7))

    return var_8
  }

  def hasExtension =
    new HasRescaleUp(
      in_elementWidth  = 8,
      out_elementWidth = 32
    )
  val input_zp     = 0
  val multiplier   = 10283821
  val output_zp    = 0
  val shift        = 10
  val csr_vec      = Seq(input_zp, multiplier, output_zp, shift)

  val inputData  = collection.mutable.Buffer[BigInt]()
  val outputData = collection.mutable.Buffer[BigInt]()

  Random.setSeed(1) // For reproducibility

  val max_int_i = 1 << 31 - 1 // Max value for signed int
  val min_int_i = -1 << 31    // Min value for signed int

  for (_ <- 0.until(128)) {
    // val inputMatrix: Array[Int] = Array.fill(64)(1360653)
    val inputMatrix: Array[Int] = Array.fill(64)(Random.between(-128, 127))
    inputData.append(BigInt(inputMatrix.map { i => f"${i & 0xff}%02X" }.reverse.reduce(_ + _), 16))

    val outputMatrix: Array[Int] = inputMatrix.map { i =>
      GoldenModelUp(i.toInt, input_zp, output_zp, shift, max_int_i, min_int_i, multiplier)
    }
    val outputMatrix1 = outputMatrix.slice(0, 16)
    val outputMatrix2 = outputMatrix.slice(16, 32)
    val outputMatrix3 = outputMatrix.slice(32, 48)
    val outputMatrix4 = outputMatrix.slice(48, 64)
    outputData.append(BigInt(outputMatrix1.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    outputData.append(BigInt(outputMatrix2.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    outputData.append(BigInt(outputMatrix3.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    outputData.append(BigInt(outputMatrix4.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
  }
  val input_data_vec = inputData.toSeq

  val output_data_vec = outputData.toSeq

}
