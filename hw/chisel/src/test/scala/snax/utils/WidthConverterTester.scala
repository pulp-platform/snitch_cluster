package snax.utils

import scala.util.Random

import chisel3._
import chisel3.util._

import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import snax.utils.DecoupledCut._

class WidthConverter[T <: Data](gen: T) extends Module with RequireAsyncReset {
  val io = IO(new Bundle {
    val in  = Flipped(Decoupled(gen))
    val out = Decoupled(gen)
  })

  val upConverter   = Module(new WidthUpConverter(gen, 2))
  val downConverter = Module(new WidthDownConverter(gen, 2))
  io.in -||> upConverter.io.in
  upConverter.io.out <> downConverter.io.in
  downConverter.io.out -||> io.out
  upConverter.io.start   := false.B
  downConverter.io.start := false.B
}

class WidthConverterTester extends AnyFlatSpec with ChiselScalatestTester {
  "WidthConverter" should "work correctly" in {
    test(new WidthConverter(UInt(8.W))).withAnnotations(
      Seq(WriteVcdAnnotation, VerilatorBackendAnnotation)
    ) { dut =>
      var concurrent_threads = new chiseltest.internal.TesterThreadList(Seq())

      concurrent_threads = concurrent_threads.fork {
        for (i <- 0 until 256) {
          dut.io.in.bits.poke(i.U)
          dut.io.in.valid.poke(true.B)
          while (!dut.io.in.ready.peekBoolean()) {
            dut.clock.step()
          }
          dut.clock.step()
          dut.io.in.valid.poke(false.B)
          Random.nextInt(2) match {
            case 0 => ;
            case i: Int => dut.clock.step(i)
          }
        }
      }

      concurrent_threads = concurrent_threads.fork {
        for (i <- 0 until 256) {
          dut.io.out.ready.poke(true.B)
          while (!dut.io.out.valid.peekBoolean()) {
            dut.clock.step()
          }
          dut.io.out.bits.expect(i.U)
          dut.clock.step()
          dut.io.out.ready.poke(false.B)
          Random.nextInt(2) match {
            case 0 => ;
            case i: Int => dut.clock.step(i)
          }
        }
      }

      concurrent_threads.joinAndStep()
    }
  }
}

object WidthUpConverterEmitter   extends App {
  println(emitVerilog(new WidthUpConverter(UInt(8.W), 2)))
}
object WidthDownConverterEmitter extends App {
  println(emitVerilog(new WidthDownConverter(UInt(8.W), 2)))
}
