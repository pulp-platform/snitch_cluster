
package snax.DataPathExtension
import scala.util.Random

import chiseltest._
import snax.DataPathExtension.HasDivisionFinder

class DivisionFinderTester extends DataPathExtensionTester(TreadleBackendAnnotation) {

  def hasExtension = new HasDivisionFinder(elementWidth = 32, dataWidth = 512)

  val input_number = 7187272
  val csr_vec           = Seq(input_number)

  val inputData  = collection.mutable.Buffer[BigInt]()
  val outputData = collection.mutable.Buffer[BigInt]()

  for (_ <- 0 until 128) {
    val OutputMatrix = Array.fill(16)(input_number)
    outputData.append(BigInt(OutputMatrix.map { i => f"$i%08X" }.reverse.reduce(_ + _), 16))
  }

  val input_data_vec = inputData.toSeq

  val output_data_vec = outputData.toSeq
}