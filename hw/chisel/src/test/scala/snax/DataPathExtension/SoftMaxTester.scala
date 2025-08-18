package snax.DataPathExtension
import scala.util.Random

import chiseltest._
import snax.DataPathExtension.HasSoftMax

class SoftMaxTester extends DataPathExtensionTester(TreadleBackendAnnotation) {

  def hasExtension = new HasSoftMax()

  val scaled_ln2     = 6930
  val scaled_a   = 3585
  val scaled_b    = 13530
  val scaled_c        = 5125
  val shift       = 26
  val softmax_cycles = 8
  val csr_vec      = Seq(scaled_ln2, scaled_a, scaled_b, scaled_c, shift, softmax_cycles)

  val inputData  = collection.mutable.Buffer[BigInt]()
  val outputData = collection.mutable.Buffer[BigInt]()

  Random.setSeed(1) // For reproducibility

  for (_ <- 0 until 128) {
    // val inputMatrix: Array[Int] = Array.fill(64)(-5956158)
    val inputMatrix: Array[Array[Int]] = Array.fill(8,16)(Random.between(-40000, 40000))
    val inputMatrix1 = inputMatrix(0)
    val inputMatrix2 = inputMatrix(1)
    val inputMatrix3 = inputMatrix(2)
    val inputMatrix4 = inputMatrix(3)
    val inputMatrix5 = inputMatrix(4)
    val inputMatrix6 = inputMatrix(5)
    val inputMatrix7 = inputMatrix(6)
    val inputMatrix8 = inputMatrix(7)

    inputData.append(BigInt(inputMatrix1.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix2.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix3.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix4.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix5.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix6.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix7.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix8.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))

    inputData.append(BigInt(inputMatrix1.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix2.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix3.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix4.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix5.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix6.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix7.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix8.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))

    inputData.append(BigInt(inputMatrix1.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix2.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix3.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix4.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix5.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix6.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix7.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(inputMatrix8.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))

    val outputMatrix = inputMatrix.map { i => 76 }
    outputData.append(BigInt(outputMatrix.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
  }
  val input_data_vec = inputData.toSeq

  val output_data_vec = outputData.toSeq

}

