package snax.xdma.xdmaStreamer

import chisel3._
import org.scalatest.flatspec.AnyFlatSpec
import chiseltest._

import snax.xdma.DesignParams._

class basicCounterTester extends AnyFlatSpec with ChiselScalatestTester {
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

class AddressGenUnitTester extends AnyFlatSpec with ChiselScalatestTester {

  println(
    getVerilogString(new AddressGenUnit(AddressGenUnitParam()))
  )

  "AddressGenUnit: continuous fetch with first temporal loop disabled" should " pass" in test(
    new AddressGenUnit(
      AddressGenUnitParam(
        spatialBounds = List(8),
        temporalDimension = 2,
        numChannel = 8,
        outputBufferDepth = 2,
        tcdmSize = 128
      )
    )
  )
    .withAnnotations(Seq(WriteVcdAnnotation, VerilatorBackendAnnotation)) {
      dut =>
        dut.io.cfg.ptr.poke(0x1000.U)
        dut.io.cfg.spatialStrides(0).poke(8)
        dut.io.cfg.temporalStrides(0).poke(64)
        dut.io.cfg.temporalStrides(1).poke(64)
        dut.io.cfg.temporalBounds(0).poke(1)
        dut.io.cfg.temporalBounds(1).poke(16)

        dut.io.start.poke(true)
        dut.clock.step()
        dut.io.start.poke(false)
        for (i <- 0 until 16) {
          dut.clock.step()
        }

        dut.io.addr.foreach(_.ready.poke(true.B))
        for (i <- 0 until 48) {
          dut.clock.step()
        }

    }

  "AddressGenUnit: continuous fetch with first temporal loop enabled" should " pass" in test(
    new AddressGenUnit(
      AddressGenUnitParam(
        spatialBounds = List(8),
        temporalDimension = 2,
        numChannel = 8,
        outputBufferDepth = 2,
        tcdmSize = 128
      )
    )
  )
    .withAnnotations(Seq(WriteVcdAnnotation, VerilatorBackendAnnotation)) {
      dut =>
        dut.io.cfg.ptr.poke(0x1000.U)
        dut.io.cfg.spatialStrides(0).poke(8)
        dut.io.cfg.temporalStrides(0).poke(64)
        dut.io.cfg.temporalStrides(1).poke(256)
        dut.io.cfg.temporalBounds(0).poke(4)
        dut.io.cfg.temporalBounds(1).poke(4)

        dut.io.start.poke(true)
        dut.clock.step()
        dut.io.start.poke(false)
        for (i <- 0 until 16) {
          dut.clock.step()
        }

        dut.io.addr.foreach(_.ready.poke(true.B))
        for (i <- 0 until 48) {
          dut.clock.step()
        }
    }
}
