package snax.utils

import scala.util.Random
import scala.util.control.Breaks.break
import scala.util.control.Breaks.breakable

import chisel3._
import chisel3.util._

import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import snax.utils.DecoupledCut._

class DataCutWrapper extends Module {
  val io = IO(new Bundle {
    val in  = Flipped(Decoupled(UInt(8.W)))
    val out = Decoupled(UInt(8.W))
  })

  val middle = Wire(Decoupled(UInt(8.W)))

  io.in -||> middle -\\\> io.out
}

class CustomOperatorsTester extends AnyFlatSpec with ChiselScalatestTester {
  "The test of DecoupledCut" should " pass" in {

    val dataIn     = collection.mutable.ListBuffer.fill(16384)(Random.nextInt(256))
    val dataInCopy = dataIn.clone()
    val dataOut    = collection.mutable.ListBuffer[Int]()

    var allowIn  = false
    var allowOut = false

    test(new DataCutWrapper)
      .withAnnotations(Seq(WriteVcdAnnotation, VerilatorBackendAnnotation)) { dut =>
        dut.clock.setTimeout(0)

        var concurrent_threads =
          new chiseltest.internal.TesterThreadList(Seq())
        // Turn on and off the gate
        concurrent_threads = concurrent_threads.fork {
          breakable {
            while (true) {
              val delay = Random.between(50, 100)
              dut.clock.step(delay)
              allowIn = !allowIn
              if (dataIn.isEmpty) {
                allowIn = true
                break()
              }
            }
          }
        }

        concurrent_threads = concurrent_threads.fork {
          breakable {
            while (true) {
              val delay = Random.between(50, 100)
              dut.clock.step(delay)
              allowOut = !allowOut
              if (dataIn.isEmpty) {
                allowOut = true
                break()
              }
            }
          }
        }

        concurrent_threads = concurrent_threads.fork {

          breakable {
            while (true) {
              if (allowIn) {
                dut.io.in.valid.poke(true.B)
                dut.io.in.bits.poke(dataIn.head.U)
                while (!dut.io.in.ready.peekBoolean()) {
                  dut.clock.step()
                }
                dut.clock.step()
                dut.io.in.valid.poke(false.B)
                dataIn.dropInPlace(1)
                if (dataIn.isEmpty) break()
              } else dut.clock.step()
            }
          }
        }

        concurrent_threads = concurrent_threads.fork {

          breakable {
            while (true) {
              if (allowOut) {
                dut.io.out.ready.poke(true.B)
                while (!dut.io.out.valid.peekBoolean()) {
                  dut.clock.step()
                }
                dataOut.append(dut.io.out.bits.peekInt().toInt)
                dut.clock.step()
                dut.io.out.ready.poke(false.B)
                if (dataOut.length == dataInCopy.length) break()
              } else dut.clock.step()
            }
          }
        }

        concurrent_threads.joinAndStep()
        if (dataInCopy == dataOut) {
          println("Test passed")
        } else {
          throw new Exception("Test failed")
        }
      }
  }
}
