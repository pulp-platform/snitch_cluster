package snax.DataPathExtension

import chisel3._
import chisel3.util._

import scala.util.Random
import snax.DataPathExtension.HasBroadcaster256to2048

class BroadcasterTester extends DataPathExtensionTester {

  def hasExtension = HasBroadcaster256to2048

  val csr_vec = Seq()

  val input_data_vec = for (i <- 0 until 1024) yield {
    BigInt.apply(256, Random)
  }

  val output_data_vec = for (i <- input_data_vec) yield {
    var output_data = BigInt(0)
    for (j <- 0 until 8) {
      output_data = (output_data << 256) + i
    }
    output_data
  }
}
