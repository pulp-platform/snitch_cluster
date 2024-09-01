package snax.xdma.xdmaStreamer

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

class ReaderTester extends AnyFreeSpec with ChiselScalatestTester {
  "Reader's behavior is as expected" in test(
    new Reader(new ReaderWriterParam)
  ).withAnnotations(Seq(WriteVcdAnnotation, VerilatorBackendAnnotation)) {
    dut =>
      // The accessed address is 1KB (0x0 - 0x400)
      // Configure AGU
      dut.io.aguCfg.ptr.poke(0x0.U)
      // 8 parfor continuous, 4 tempfor having the distance of 128B (read one superbank skip one superbank)
      // 4 tempfor having the distance of 1024B (finish read 4 SB in 8 SB, skip the consiquent 8SB)
      // 8 parfor, 4 tempfor x 4 tempfor
      dut.io.aguCfg.spatialStrides(0).poke(8)
      dut.io.aguCfg.temporalStrides(0).poke(64)
      dut.io.aguCfg.temporalStrides(1).poke(256)

      dut.io.aguCfg.temporalBounds(0).poke(4)
      dut.io.aguCfg.temporalBounds(1).poke(16)

      dut.io.readerwriterCfg.enabledChannel.poke(0xff.U)
      dut.io.readerwriterCfg.enabledByte.poke(0xff.U)

      dut.io.start.poke(true)
      dut.clock.step()
      dut.io.start.poke(false)
      // Waiting for the AGU to begin
      while (dut.io.busy.peekBoolean() == false) dut.clock.step()

      // AGU started work. Now we need to create branches to emulate each channels of TCDM ports
      var concurrent_threads =
        new chiseltest.internal.TesterThreadList(Seq())
      val mem = collection.mutable.Map[Int, BigInt]()
      var testTerminated = false

      // Queues to temporarily store the address at request side, which will be consumed by responser
      val queues = Seq.fill(8)(collection.mutable.Queue[Int]())

      // Each individual thread simulate one TCDM request port and one TCDM response: If TCDM behaves differently, this is only part need to be modified
      for (i <- 0 until 8) {
        // Emulate TCDM request side
        concurrent_threads = concurrent_threads.fork {
          breakable {
            while (true) {
              // Terminate this thread if the testbench ends
              if (testTerminated) break()

              // Emulate the contention at the TCDM Req side
              val random_delay = Random.between(0, 3)
              if (random_delay > 1) {
                dut.io.tcdmReq(i).ready.poke(false)
                dut.clock.step(random_delay)
                dut.io.tcdmReq(i).ready.poke(true)
              } else dut.io.tcdmReq(i).ready.poke(true)

              // If valid is high: the request is enqueue into a list, waiting for the consumption of response side
              if (dut.io.tcdmReq(i).valid.peekBoolean()) {
                mem.addOne(
                  (
                    dut.io.tcdmReq(i).bits.addr.peekInt().toInt,
                    BigInt(64, Random)
                  )
                )
                println(
                  "[Generator] Data: "
                    + mem(
                      dut.io.tcdmReq(i).bits.addr.peekInt().toInt
                    )
                    + " is saved at address: "
                    + dut.io.tcdmReq(i).bits.addr.peekInt().toInt
                )
                // The request is sent to response side
                queues(i).enqueue(
                  dut.io.tcdmReq(i).bits.addr.peekInt().toInt
                )
                println(
                  "[Generator] Request with Address: "
                    + dut.io.tcdmReq(i).bits.addr.peekInt().toInt
                    + " is sending to TCDM response side"
                )

                // Current request is consumed
                dut.clock.step()

              }
            }
          }
        }

        // Emulate TCDM response side
        concurrent_threads = concurrent_threads.fork {
          breakable {
            while (true) {
              // Terminate this thread if the testbench ends
              if (testTerminated) break()

              if (queues(i).isEmpty) dut.clock.step()
              else {
                println(
                  "[Generator] Request with Address: "
                    + queues(i).front
                    + " is responded"
                )

                dut.io.tcdmRsp(i).valid.poke(true)
                dut.io
                  .tcdmRsp(i)
                  .bits
                  .data
                  .poke(
                    mem(queues(i).dequeue())
                  )
                dut.clock.step()
                dut.io.tcdmRsp(i).valid.poke(false)
              }
            }
          }
        }
      }

      // The output verifier to verify if the output data is correct
      concurrent_threads = concurrent_threads.fork {
        breakable {
          while (true) {
            // Terminate this thread if the testbench ends
            if (testTerminated) break()

            if (dut.io.data.valid.peekBoolean()) {
              // retrieve the data back from the emulated rom
              val expected_output_non_combined =
                for (i <- 0 until 8) yield {
                  val mem_element = mem.minBy(_._1)
                  mem.remove(mem_element._1)
                  mem_element._2
                }
              // Concatenate them into 512-bit value => This is the expected output
              val expected_output =
                expected_output_non_combined.reduceRight((a, b) =>
                  (b << 64) + a
                )

              dut.io.data.ready.poke(true)
              dut.io.data.bits.expect(expected_output)
              println(
                "[Output Verifier] Value: " + expected_output + " equals to emulated memory. "
              )
              dut.clock.step()
              dut.io.data.ready.poke(false)
            } else dut.clock.step()
          }
        }
      }

      // The monitor to see if the simulation had finished
      concurrent_threads = concurrent_threads.fork {
        println("[Monitor] The monitor is launched. ")
        // Wait for the dut to start
        dut.clock.step(3)
        // Waiting for the addressgen to finish
        while (dut.io.busy.peekBoolean()) dut.clock.step()
        // Waiting for the Tester to readout all the data
        while (mem.size != 0) dut.clock.step()
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
