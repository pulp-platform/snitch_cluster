package snax.readerWriter
import chisel3._
import chisel3.util._
// Import Chiseltest
import chiseltest._
import org.scalatest.freespec.AnyFreeSpec
import org.scalatest.flatspec.AnyFlatSpec
// Import Random number generator
import scala.util.Random
// Import break support for loops
import scala.util.control.Breaks.{break, breakable}

import snax.xdma.DesignParams._

case class DmaWriteTransaction(data: BigInt, delay: Int)

class ReaderWriterTesterParam(
    val address: Int,
    val spatial_bound: Int,
    val temporal_bound: Array[Int],
    val spatial_stride: Int,
    val temporal_stride: Array[Int]
)

object ReaderWriterTesterParam {
  def apply() = new ReaderWriterTesterParam(
    address = 0,
    spatial_bound = 8,
    temporal_bound = Array(4, 16),
    spatial_stride = 8,
    temporal_stride = Array(64, 256)
  )
  def apply(
      address: Int,
      dimension: Int,
      spatial_bound: Int,
      temporal_bound: Array[Int],
      spatial_stride: Int,
      temporal_stride: Array[Int]
  ) = new ReaderWriterTesterParam(
    address = address,
    spatial_bound = spatial_bound,
    temporal_bound = temporal_bound,
    spatial_stride = spatial_stride,
    temporal_stride = temporal_stride
  )
}

class WriterTester extends AnyFreeSpec with ChiselScalatestTester {
  "Writer's behavior is as expected" in test(
    new Writer(
      new ReaderWriterParam(
        configurableByteMask = true,
        configurableChannel = true,
        pipeFifo = false
      )
    )
  ).withAnnotations(Seq(WriteVcdAnnotation, VerilatorBackendAnnotation)) {
    dut =>
      dut.clock.step(10)
      // The accessed address is 1KB (0x0 - 0x400)
      // Configure AGU
      val testingParams = ReaderWriterTesterParam()
      dut.io.aguCfg.ptr.poke(testingParams.address)
      // 8 parfor, 4 tempfor x 4 tempfor
      dut.io.aguCfg.spatialStrides(0).poke(testingParams.spatial_stride)
      dut.io.aguCfg.temporalBounds(0).poke(testingParams.temporal_bound(0))
      dut.io.aguCfg.temporalBounds(1).poke(testingParams.temporal_bound(1))
      dut.io.aguCfg.temporalBounds(0).poke(testingParams.temporal_bound(0))
      dut.io.aguCfg.temporalBounds(1).poke(testingParams.temporal_bound(1))
      dut.io.readerwriterCfg.enabledChannel.poke(0xff.U)
      dut.io.readerwriterCfg.enabledByte.poke(0xff.U)
      // 8 parfor continuous, 4 tempfor having the distance of 128B (read one superbank skip one superbank)
      // 4 tempfor having the distance of 1024B (finish read 4 SB in 8 SB, skip the consiquent 8SB)

      dut.io.start.poke(true)
      dut.clock.step()
      dut.io.start.poke(false)
      // Prepare the dma transactions
      // Initialize the dma_write_data that is going to write to the tcdm
      val dma_write_transaction =
        collection.mutable.Map[Int, DmaWriteTransaction]()
      for (i <- 0 until testingParams.temporal_bound.reduce(_ * _)) {
        val data = BigInt(512, Random)
        val delay = Random.between(0, 5)
        dma_write_transaction(i) = DmaWriteTransaction(data, delay)
        // println(
        //   f"[Generator] DMA Transaction: $i%d = 0x${data.toString(16)}%s with delay of $delay%d"
        // )
      }

      // Waiting for the AGU to begin
      while (!dut.io.busy.peekBoolean()) dut.clock.step()

      // AGU started work. Now we need to create branches to emulate each channels of TCDM ports
      var concurrent_threads = new chiseltest.internal.TesterThreadList(Seq())

      var testTerminated = false
      // one thread to feed data into the complex queue
      var transaction_id = 0
      concurrent_threads = concurrent_threads.fork {
        println("[DMA] The DMA is launched. ")
        breakable {
          while (true) {
            // Terminate this thread if the testbench ends
            // if (testTerminated) break()
            if (transaction_id == testingParams.temporal_bound.reduce(_ * _)) {
              println(
                "[DMA] Send All Transactions to Streamer. Close DMA Thread"
              )
              break()
            }
            if (dut.io.data.ready.peekBoolean()) {
              val random_delay = dma_write_transaction(transaction_id).delay
              if (random_delay > 1) {
                // println(
                //   s"[DMA] Transaction $transaction_id is delayed with $random_delay"
                // )
                dut.io.data.valid.poke(false)
                dut.clock.step(random_delay)
              }
              dut.io.data.valid.poke(true)
              val dma_data = dma_write_transaction(transaction_id).data
              dut.io.data.bits.poke(dma_data)
              println(
                f"[DMA] Send Transaction $transaction_id%d = 0x${dma_data.toString(16)}%s to the Streamer FIFO"
              )
              transaction_id += 1
              dut.clock.step()
            }
          }
        }
      }
      val tcdm_mem = collection.mutable.Map[Int, Long]()

      // Each individual thread simulate one TCDM request port and one TCDM response: If TCDM behaves differently, this is only part need to be modified
      for (i <- 0 until 8) {
        // Emulate TCDM request side
        concurrent_threads = concurrent_threads.fork {
          breakable {
            while (true) {
              // Terminate this thread if the testbench ends
              if (testTerminated) break()

              if (
                dut.io
                  .tcdmReq(i)
                  .valid
                  .peekBoolean() && dut.io.tcdmReq(i).bits.write.peekBoolean()
              ) {
                val random_delay = Random.between(0, 3)

                if (random_delay > 1) {
                  dut.io.tcdmReq(i).ready.poke(false)
                  dut.clock.step(random_delay)
                  dut.io.tcdmReq(i).ready.poke(true)
                } else dut.io.tcdmReq(i).ready.poke(true)

                val req_addr = dut.io.tcdmReq(i).bits.addr.peekInt().toInt
                val req_data =
                  dut.io.tcdmReq(i).bits.data.peek().litValue.toLong
                println(
                  f"[TCDM] Write to Addr: $req_addr%d with Data = 0x${req_data}%016x"
                )
                // The request is stored to tcdm mem
                tcdm_mem(req_addr) = req_data
                // Current request is consumed
                dut.clock.step()
              } else dut.clock.step()
            }
          }
        }
      }
      // one thread to monitor the simulation
      concurrent_threads = concurrent_threads.fork {
        println("[Monitor] The monitor is launched. ")
        // Wait for the dut to start
        dut.clock.step(3)
        // Waiting for the addressgen to finish
        while (dut.io.busy.peekBoolean()) dut.clock.step()

        while (transaction_id != (4 * 16)) dut.clock.step()
        // All the data has sent to the streamer
        println("[Monitor] The DMA has sent all the data to Streamer. ")
        println("[Monitor] Wait all the data in Streamer to be consumed. ")
        // Wait the streamer is empty
        // while (!dut.io.bufferEmpty.peekBoolean()) dut.clock.step()
        // Everything finished: The simulation is ended
        println(
          "[Monitor] The test is finished and all threads are about to be terminated by the monitor. "
        )
        // Wait some step to make sure all the signals are settled
        dut.clock.step(10)
        testTerminated = true

      }
      concurrent_threads.joinAndStep()

      // We need to test two things: addr and data
  }
}
