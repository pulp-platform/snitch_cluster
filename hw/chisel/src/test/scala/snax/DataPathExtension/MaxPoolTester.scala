package snax.DataPathExtension

import chisel3._
import chisel3.util._

import scala.util.Random
import snax.DataPathExtension.HasMaxPool

class MaxPoolTester extends DataPathExtensionTester {

  def hasExtension = HasMaxPool

  // System Val
  val extension_width = 512
  val bit_width = 8

  // Testing Val
  val num_testing_data = 1024
  // pooling_ratio = 8 means we select the max number from 8 consecutive inputs
  val pooling_ratio = 8
  // We have 512bits input for each CC
  // Hence at most we can process 512/8 = 64 input
  val maxpool_PE_num = extension_width / bit_width
  val csr_vec = Seq(pooling_ratio) // 8 -> 1 Pooling

  // We have 1024 sets test data
  // each set is 8 x 64 8bit data
  //         |<----64 numbers, each with 8bit---->|
  // t = 0 ->[0,  -2,               -64B-         ]
  // t = 1 ->[1,  -15,              -64B-         ]
  // t = 2 ->[3,  45,               -64B-         ]
  // t = 3 ->[2,  37,               -64B-         ]
  // t = 4 ->[-5, 102,              -64B-         ]
  // t = 5 ->[-2, -35,              -64B-         ]
  // t = 6 ->[7,  -46,              -64B-         ]
  // t = 7 ->[9,  4,                -64B-         ]
  // In total we have 64 maxpool PEs
  // Expected output will select the max number for each colume
  // Expected: [9, 102,             -64B-         ]
  val input_data = for (i <- 0 until num_testing_data) yield {
    for (j <- 0 until pooling_ratio) yield {
      for (k <- 0 until maxpool_PE_num) yield {
        Random.between(-128, 128)
      }
    }
  }
  // Transpose the input_data
  // --- |<-8->|
  // |  [     ]
  // |  [     ]
  // |  [     ]
  // 64 [     ]
  // |  [     ]
  // |  [     ]
  // |  [     ]
  // --- [     ]
  val output_data_pre_compare = for (i <- 0 until num_testing_data) yield {
    for (k <- 0 until maxpool_PE_num) yield {
      for (j <- 0 until pooling_ratio) yield {
        input_data(i)(j)(k)
      }
    }
  }

  val output_data = for (i <- output_data_pre_compare) yield {
    // i is a 64 × 8 2D sequence
    for (j <- i) yield {
      // j refers to a 1D list with 8 elements
      j.reduce { (a, b) =>
        {
          if (a > b) a
          else b
        }
      }
      // j is now reduced to the max value of the 8 elements
    }
  }

  val input_data_vec = for {
    i <- input_data
    j <- i
  } yield {
    // i is a 8x64 2D Sequence
    // j refers to a 1D list with 64 elements
    // which is the input data to the tb
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
