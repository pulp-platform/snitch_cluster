package snax.DataPathExtension
import scala.util.Random

import snax.DataPathExtension.HasTransposer

class TransposerTester extends DataPathExtensionTester {

  def hasExtension = new HasTransposer(row = Seq(8), col = Seq(8), elementWidth = Seq(16), dataWidth = 512)

  val csr_vec = Seq()

  val inputData  = collection.mutable.Buffer[BigInt]()
  val outputData = collection.mutable.Buffer[BigInt]()

  for (_ <- 0 until 128) {
    val inputMatrix: Array[Array[Int]] = Array.fill(8, 8)(Random.nextInt(1 << 16))
    val leftInputMatrix  = inputMatrix.map(row => row.slice(0, 4))
    val rightInputMatrix = inputMatrix.map(row => row.slice(4, 8))
    inputData.append(BigInt(leftInputMatrix.flatten.map { i => f"$i%04X" }.reverse.reduce(_ + _), 16))
    inputData.append(BigInt(rightInputMatrix.flatten.map { i => f"$i%04X" }.reverse.reduce(_ + _), 16))

    val outputMatrix: Array[Array[Int]] = inputMatrix.transpose
    val leftOutputMatrix  = outputMatrix.map(row => row.slice(0, 4))
    val rightOutputMatrix = outputMatrix.map(row => row.slice(4, 8))
    outputData.append(BigInt(leftOutputMatrix.flatten.map { i => f"$i%04X" }.reverse.reduce(_ + _), 16))
    outputData.append(BigInt(rightOutputMatrix.flatten.map { i => f"$i%04X" }.reverse.reduce(_ + _), 16))
  }

  val input_data_vec = inputData.toSeq

  val output_data_vec = outputData.toSeq
}
