package snax.xdma.xdmaFrontend

import chisel3._
import chisel3.util._

// Hardware and its Generation Param
import snax.xdma.xdmaFrontend.DMADataPath
import snax.xdma.DesignParams.{DMADataPathParam, AXIParam}
import snax.readerWriter.ReaderWriterParam
import snax.xdma.xdmaTop.xdmaTopGen.axiParam

// Import Chiseltest
import chiseltest._
import org.scalatest.freespec.AnyFreeSpec
import org.scalatest.flatspec.AnyFlatSpec

// Import Random number generator
import scala.util.Random
// Import break support for loops
import scala.util.control.Breaks.{break, breakable}
import snax.DataPathExtension.HasMemset

class ReaderWriterTesterParam(
    val address: Int,
    val dimension: Int,
    val spatial_bound: Int,
    val temporal_bound: Array[Int],
    val spatial_stride: Int,
    val temporal_stride: Array[Int]
)

class DMADataPathTester extends AnyFreeSpec with ChiselScalatestTester {
  "DMA Data Path behavior is as expected" in test(
    new DMADataPath(
      readerparam = new DMADataPathParam(
        axiParam = new AXIParam,
        rwParam = new ReaderWriterParam(
          configurableByteMask = false,
          configurableChannel = true
        )
      ),
      writerparam = new DMADataPathParam(
        axiParam = new AXIParam,
        rwParam = new ReaderWriterParam(
          configurableByteMask = true,
          configurableChannel = true
        )
      )
    )
  ).withAnnotations(Seq(WriteVcdAnnotation, VerilatorBackendAnnotation)) {
    dut =>
      // ************************ Prepare the simulation data ************************//

      // Prepare the data in the tcdm
      val tcdm_mem = collection.mutable.Map[Int, Long]()
      // We have 128KB of the tcdm data
      // Each element is 64bit(8B) long
      // Hence in total we have 128KB/8B = 16K entried of the tcdm
      // First we generate the first half (64KB) of the data ramdomly

      // We first test only to read 8 rows of data
      // Each row we have 256B
      for (i <- 0 until (8 * 256) / 8) {
        tcdm_mem(8 * i) = i * 1L
      }
      // Queues to temporarily store the address at request side, which will be consumed by responser
      val queues = Seq.fill(8)(collection.mutable.Queue[Int]())

      // Prepare AGU config
      // Prepare read cfg
      val readerTestingParams = new ReaderWriterTesterParam(
        address = 0,
        dimension = 3,
        // spatial_bound is fixed to 8 -> every time we fetch 8 banks
        spatial_bound = 8,
        temporal_bound = Array(4, 8),
        spatial_stride = 8,
        temporal_stride = Array(64, 256)
      )
      // Prepare write cfg
      val writerTestingParams = new ReaderWriterTesterParam(
        address = 8 * 256,
        dimension = 3,
        // spatial_bound is fixed to 8 -> every time we fetch 8 banks
        spatial_bound = 8,
        temporal_bound = Array(4, 8),
        spatial_stride = 8,
        temporal_stride = Array(64, 256)
      )
      // ************************ Start Simulation **********************************//
      // Start up the system
      dut.clock.step(10)
      // Poke the reader agu
      dut.io.readerCfg.aguCfg.ptr.poke(readerTestingParams.address)
      dut.io.readerCfg.readerwriterCfg.enabledChannel.poke(0xff.U)
      dut.io.readerCfg.aguCfg
        .temporalBounds(0)
        .poke(readerTestingParams.temporal_bound(0))
      dut.io.readerCfg.aguCfg
        .temporalBounds(1)
        .poke(readerTestingParams.temporal_bound(1))
      dut.io.readerCfg.aguCfg
        .spatialStrides(0)
        .poke(readerTestingParams.spatial_stride)
      dut.io.readerCfg.aguCfg
        .temporalStrides(0)
        .poke(readerTestingParams.temporal_stride(0))
      dut.io.readerCfg.aguCfg
        .temporalStrides(1)
        .poke(readerTestingParams.temporal_stride(1))

      // Poke the write agu
      dut.io.writerCfg.aguCfg.ptr.poke(writerTestingParams.address)
      dut.io.writerCfg.readerwriterCfg.enabledChannel.poke(0xff.U)
      dut.io.writerCfg.readerwriterCfg.enabledByte.poke(0xff.U)
      dut.io.writerCfg.aguCfg
        .temporalBounds(0)
        .poke(writerTestingParams.temporal_bound(0))
      dut.io.writerCfg.aguCfg
        .temporalBounds(1)
        .poke(writerTestingParams.temporal_bound(1))
      dut.io.writerCfg.aguCfg
        .spatialStrides(0)
        .poke(writerTestingParams.spatial_stride)
      dut.io.writerCfg.aguCfg
        .temporalStrides(0)
        .poke(writerTestingParams.temporal_stride(0))
      dut.io.writerCfg.aguCfg
        .temporalStrides(1)
        .poke(writerTestingParams.temporal_stride(1))
      // Poke the loop back to ture since we are only testing w/o any axi transactions
      dut.io.readerCfg.loopBack.poke(true)
      dut.io.writerCfg.loopBack.poke(true)

      // Start the reader and writer
      dut.io.readerStart.poke(true)
      dut.io.writerStart.poke(true)
      dut.clock.step()
      dut.io.readerStart.poke(false)
      dut.io.writerStart.poke(false)
      // Waiting for the AGU to begin
      if (
        !(dut.io.readerBusy.peekBoolean() && dut.io.writerBusy
          .peekBoolean())
      )
        dut.clock.step()
      // AGU started work. Now we need to create branches to emulate each channels of TCDM ports
      var concurrent_threads = new chiseltest.internal.TesterThreadList(Seq())
      var testTerminated = false

      // eight threads to mimic the reader req side
      // Each threads will emulate a random delay in the req_ready side
      // ---------                ------------
      // |       |----->addr----->|          |
      // |reader |----->valid---->| tcdm port|
      // |   req |<-----ready----<|          |
      // ---------                ------------
      for (i <- 0 until 8) {
        concurrent_threads = concurrent_threads.fork {
          breakable(
            while (true) {
              if (testTerminated) break()
              val random_delay = Random.between(0, 3)
              if (random_delay > 1) {
                dut.io.tcdmReader.req(i).ready.poke(false)
                dut.clock.step(random_delay)
                dut.io.tcdmReader.req(i).ready.poke(true)
              } else dut.io.tcdmReader.req(i).ready.poke(true)
              val reader_req_addr =
                dut.io.tcdmReader.req(i).bits.addr.peekInt().toInt
              if (dut.io.tcdmReader.req(i).valid.peekBoolean()) {
                queues(i).enqueue(reader_req_addr)

                println(
                  f"[Reader Req] Read the TCDM with Addr = $reader_req_addr%d"
                )
              }

              dut.clock.step()
            }
          )
        }
      }
      // eight threads to mimic the reader resp side
      // There are no ready port in the reader side, so we just pop out the data accoring to
      // the addr recored in queues
      // ---------                ------------
      // |       |<-----data-----<|          |
      // |reader |<-----valid----<| tcdm port|
      // |   resp|                |          |
      // ---------                ------------
      for (i <- 0 until 8) {
        concurrent_threads = concurrent_threads.fork {
          breakable(
            while (true) {
              if (testTerminated) break()
              if (queues(i).isEmpty) dut.clock.step()
              else {
                dut.io.tcdmReader.rsp(i).valid.poke(true)
                val reader_addr = queues(i).dequeue()
                val reader_resp_data = tcdm_mem(reader_addr)
                //   println(
                //     f"[Reader Resp] TCDM Response to Reader with Addr = $reader_addr%d Data = 0x${reader_resp_data}%016x"
                //   )
                println(
                  f"[Reader Resp] TCDM Response to Reader with Addr = $reader_addr%d Data = $reader_resp_data%d"
                )
                dut.io.tcdmReader.rsp(i).bits.data.poke(reader_resp_data.U)
                dut.clock.step()
                dut.io.tcdmReader.rsp(i).valid.poke(false)
              }

            }
          )
        }
      }
      // eight threads to mimic the writer req side
      // Like the reader req side, we emulate the random delay by poking to ready signal
      // ---------                ------------
      // |       |>-----addr----->|          |
      // |writer |>-----write---->| tcdm port|
      // |   req |>-----data----->|          |
      // |       |>-----valid---->|          |
      // |       |<-----ready----<|          |
      // ---------                ------------
      for (i <- 0 until 8) {
        concurrent_threads = concurrent_threads.fork {
          breakable(
            while (true) {
              if (testTerminated) break()

              if (dut.io.tcdmWriter.req(i).valid.peekBoolean()) {
                val writer_req_addr =
                  dut.io.tcdmWriter.req(i).bits.addr.peekInt().toInt
                val writer_req_data =
                  dut.io.tcdmWriter.req(i).bits.data.peek().litValue.toLong

                val random_delay = Random.between(0, 3)
                if (random_delay > 1) {
                  dut.io.tcdmWriter.req(i).ready.poke(false)
                  dut.clock.step(random_delay)
                  dut.io.tcdmWriter.req(i).ready.poke(true)
                } else dut.io.tcdmWriter.req(i).ready.poke(true)

                val writer_expected_data = (writer_req_addr - 2048) / 8
                println(
                  f"[Writer Req] Writes to TCDM with Addr: $writer_req_addr and Data = ${writer_req_data} (Expected Data = $writer_expected_data)"
                )
                tcdm_mem(writer_req_addr) = writer_req_data

                dut.clock.step()
              } else dut.clock.step()

            }
          )
        }
      }

      // one threads to monitor the simulation
      concurrent_threads = concurrent_threads.fork {
        println("[Monitor] The monitor is launched. ")
        // Wait for the dut to start
        dut.clock.step(20)
        // After the dut is start, we poll the busy signal of both writer and reader
        while (
          dut.io.readerBusy.peekBoolean() && dut.io.writerBusy
            .peekBoolean()
        )
          dut.clock.step()
        // If they are both zero => system is done
        // Everything finished: The simulation is ended
        println(
          "[Monitor] The test is finished and all threads are about to be terminated by the monitor. "
        )
        dut.clock.step()
        testTerminated = true
      }

      concurrent_threads.joinAndStep()
  }
}

object DMADataPathEmitter extends App {
  emitVerilog(
    new DMADataPath(
      readerparam = new DMADataPathParam(new AXIParam, new ReaderWriterParam),
      writerparam = new DMADataPathParam(new AXIParam, new ReaderWriterParam)
    ),
    Array("--target-dir", "generated")
  )
}
