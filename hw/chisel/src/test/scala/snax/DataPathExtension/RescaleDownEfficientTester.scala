package snax.DataPathExtension
import scala.math._
import scala.util.Random

import chiseltest._
import snax.DataPathExtension.HasRescaleDownEfficient

class RescaleDownEfficientTester extends DataPathExtensionTester(TreadleBackendAnnotation) {

  def GoldenModelEfficient(
    input:      Int,
    input_zp:   Int,
    multiplier: Int,
    output_zp:  Int,
    shift:      Int
  ): Byte = {

    // Default values for parameters not passed in (matching the test setup)
    val max_int_i      = 127  // Max value for signed byte
    val min_int_i      = -128 // Min value for signed byte
    val double_round_i = true // Assuming double rounding is enabled

    // Step 1: Subtract input zero point
    var var_1 = input - input_zp

    // Additional Step 1: Calculate dynamic shifts to avoid overflow
    val bits_to_shift_input      = math.max(
      0,
      9 + shift - math.ceil(math.log(multiplier) / math.log(2)).toInt - 16
    )
    // 8 can be adapted to be higher. higher will add more support for
    // overflows, but will also reduce accuracy of the output.
    val bits_to_shift_multiplier = math.max(0, math.ceil(math.log(multiplier) / math.log(2)).toInt - 16)

    var_1 = var_1 >> bits_to_shift_input
    val multiplier_shifted = multiplier >> bits_to_shift_multiplier
    val shift_adjusted     = shift - bits_to_shift_input - bits_to_shift_multiplier

    // Step 2: Multiply with the multiplier avoiding overflow
    val var_2 = var_1.toLong * multiplier_shifted.toLong

    // Step 3: Left shift one
    val shifted_one = 1L << (shift_adjusted - 1)

    // Step 4: Add shifted one
    val var_3 = var_2 + shifted_one

    // Step 5: Double rounding
    val var_4 = if (double_round_i) {
      if (var_1 > 0) {
        var_3 + (1L << (30 - bits_to_shift_multiplier - bits_to_shift_input))
      } else {
        var_3 - (1L << (30 - bits_to_shift_multiplier - bits_to_shift_input))
      }
    } else {
      var_3
    }

    val var_5 = if (shift_adjusted > 31 - bits_to_shift_multiplier - bits_to_shift_input) {
      var_4
    } else {
      var_3
    }

    // Step 6: Shift right
    val var_6 = (var_5 >> shift_adjusted).toInt

    // Step 7: Add output zero point
    val var_7 = var_6 + output_zp

    // Step 8: Clip the values to be within min and max integer range
    val var_8 = math.max(min_int_i, math.min(max_int_i, var_7))

    var_8.toByte
  }

  def hasExtension =
    new HasRescaleDownEfficient(
      in_elementWidth  = 32,
      out_elementWidth = 8
    )
  val input_zp     = 0
  val multiplier   = 1140768824
  val output_zp    = 0
  val shift        = 47
  val csr_vec      = Seq(input_zp, multiplier, output_zp, shift)

  val inputData  = collection.mutable.Buffer[BigInt]()
  val outputData = collection.mutable.Buffer[BigInt]()

  Random.setSeed(1) // For reproducibility

  for (_ <- 0 until 128) {
    // val inputMatrix: Array[Int] = Array.fill(64)(1360653)
    val inputMatrix: Array[Int] = Array.fill(64)(Random.between(-2 << 22, 2 << 22))
    val inputMatrix1 = inputMatrix.slice(0, 16)
    val inputMatrix2 = inputMatrix.slice(16, 32)
    val inputMatrix3 = inputMatrix.slice(32, 48)
    val inputMatrix4 = inputMatrix.slice(48, 64)
    inputData.append(BigInt(inputMatrix1.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix2.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix3.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix4.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))

    val outputMatrix = inputMatrix.map { i => GoldenModelEfficient(i, input_zp, multiplier, output_zp, shift) }
    outputData.append(BigInt(outputMatrix.map { i => f"${i & 0xff}%02X" }.reverse.reduce(_ + _), 16))
  }
  val input_data_vec = inputData.toSeq

  val output_data_vec = outputData.toSeq

}
