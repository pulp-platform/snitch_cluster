package snax.xdma.xdmaExtension

import chisel3._
import chisel3.util._
import org.scalatest.flatspec.AnyFlatSpec
import chiseltest._

import snax.xdma.CommonCells.DecoupledCut._

import snax.xdma.DesignParams._
import scala.util.Random
import org.scalatest.Args

class MaxPoolTester extends DMAExtensionTester {

  def hasExtension = HasMaxPool
  val csr_vec = Seq(8) // 8 -> 1 Pooling
  val input_data = for (i <- 0 until 1024) yield {
    for (j <- 0 until 8) yield {
      for (k <- 0 until 64) yield {
        Random.between(-128, 128)
      }
    }
  }

  val output_data_pre_compare = for (i <- 0 until 1024) yield {
    for (k <- 0 until 64) yield {
      for (j <- 0 until 8) yield {
        input_data(i)(j)(k)
      }
    }
  }

  val output_data = for (i <- output_data_pre_compare) yield {
    for (j <- i) yield {
      j.reduce { (a, b) =>
        {
          if (a > b) a
          else b
        }
      }
    }
  }

  val input_data_vec = for {
    i <- input_data
    j <- i
  } yield {
    j.zipWithIndex.foldLeft(BigInt(0)) { case (accum, (current, idx)) =>
      (accum << 8) + (current.toByte & 0xff)
    }
  }

  val output_data_vec = for (i <- output_data) yield {
    i.zipWithIndex.foldLeft(BigInt(0)) { case (accum, (current, idx)) =>
      (accum << 8) + (current.toByte & 0xff)
    }
  }
}
