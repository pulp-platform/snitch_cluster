package snax.DataPathExtension

import scala.util.Random

import chisel3._

import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import snax.DataPathExtension.HasDataPathExtension
import snax.utils.DecoupledCut._

/** The parent (abstract) Class for the DMA Extension Testbench It includes two things: 1) A Testharness to wrap the
  * extension 2) A Testbench to emulate DMACtrl, the prior extension and posterior extension
  *
  * Usage: (See MaxPoolTester as an example) 1) Define the dut (HasDMAExtension class) 2) Define CSR value for this test
  * 3) Define input data 4) Define expected output data The testbench will then automatically control the dut and verify
  * output data's correctness.
  */

class DataPathExtensionHarness(extension: HasDataPathExtension) extends Module with RequireAsyncReset {
  val dut = extension.instantiate("dma_extension_dut")
  val io  = IO(chiselTypeOf(dut.io))

  io.busy_o       := dut.io.busy_o
  dut.io.csr_i    := io.csr_i
  dut.io.bypass_i := io.bypass_i
  dut.io.start_i  := io.start_i

  io.data_i -||> dut.io.data_i
  dut.io.data_o -||> io.data_o
}

abstract class DataPathExtensionTester(
  simBackEnd: chiseltest.simulator.SimulatorAnnotation = VerilatorBackendAnnotation,
  debugMode:  Boolean                                  = false
) extends AnyFlatSpec
    with ChiselScalatestTester {
  val csr_vec:         Seq[Int]
  val input_data_vec:  Seq[BigInt]
  val output_data_vec: Seq[BigInt]
  def hasExtension: HasDataPathExtension

  hasExtension.extensionParam.moduleName should "pass" in {
    test(new DataPathExtensionHarness(hasExtension))
      .withAnnotations(Seq(WriteVcdAnnotation, simBackEnd)) { dut =>
        dut.io.csr_i.zip(csr_vec).foreach { case (csrPort, csrData) =>
          csrPort.poke(csrData)
        }
        dut.io.bypass_i.poke(false) // Bypass disabled

        var concurrent_threads =
          new chiseltest.internal.TesterThreadList(Seq())

        // Input Injector
        concurrent_threads = concurrent_threads.fork {
          // Emulate the delay of previous extensions
          dut.io.start_i.poke(true)
          dut.clock.step(1)
          dut.io.start_i.poke(false)
          // Emulate the delay of previous extensions
          dut.clock.step(Random.between(1, 16))
          // Real transmission is starting
          dut.io.data_i.valid.poke(true)
          for (i <- input_data_vec) {
            while (!dut.io.data_i.ready.peekBoolean()) dut.clock.step(1)
            dut.io.data_i.bits.poke(i)
            if (debugMode)
              println(
                "[Input Injector] The input of DMAExtension is: " + i.toString(
                  16
                )
              )
            dut.clock.step(1)
          }
          dut.io.data_i.valid.poke(false)
        }

        // Output checker
        concurrent_threads = concurrent_threads.fork {
          // Real transmission is starting
          for (i <- output_data_vec) {
            while (!dut.io.data_o.valid.peekBoolean()) dut.clock.step()
            val returned_value = dut.io.data_o.bits.peekInt()
            if (debugMode) {
              println(
                "[Output Checker] The output of DMAExtension is: " + returned_value
                  .toString(16)
              )
            }
            if (i == returned_value) {
              if (debugMode)
                println("[Output Checker] Result is correct. ")
            } else
              throw new Exception("[Output Checker] Result is not correct. ")

            // Emulate the jamming at later stage
            dut.clock.step(Random.between(1, 5))
            dut.io.data_o.ready.poke(true)
            dut.clock.step()
            dut.io.data_o.ready.poke(false)
          }
        }

        concurrent_threads.joinAndStep()
      }
  }
}
