package snax.utils

import chisel3._

import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

class BasicCounterTester extends AnyFlatSpec with ChiselScalatestTester {
  println(getVerilogString(new BasicCounter(8)))
  "The basic counter" should " pass" in {
    test(new BasicCounter(8)).withAnnotations(
      Seq(WriteVcdAnnotation, VerilatorBackendAnnotation)
    ) { dut =>
      dut.io.ceil.poke(28)
      for (i <- 0 until 128) {
        dut.io.tick.poke(i % 2)
        dut.clock.step()
      }
    }
  }
}

class UpDownCounterTester extends AnyFlatSpec with ChiselScalatestTester {
  println(getVerilogString(new UpDownCounter(8)))
  "The up down counter" should " pass" in {
    test(new UpDownCounter(8)).withAnnotations(
      Seq(WriteVcdAnnotation, VerilatorBackendAnnotation)
    ) { dut =>
      dut.io.ceil.poke(28)
      for (i <- 0 until 128) {
        dut.io.tickUp.poke(i         % 2 == 0)
        dut.io.tickDown.poke((i + 1) % 7 == 0)
        dut.clock.step()
      }
      for (i <- 0 until 128) {
        dut.io.tickUp.poke(i         % 7 == 0)
        dut.io.tickDown.poke((i + 1) % 2 == 0)
        dut.clock.step()
      }
    }
  }
}
