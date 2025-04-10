package snax.utils

import chisel3._
import chisel3.util._

class WidthUpConverter[T <: Data](gen: T, ratio: Int) extends Module with RequireAsyncReset {
  val io = IO(new Bundle {
    val in    = Flipped(Decoupled(gen))
    val out   = Decoupled(Vec(ratio, gen))
    val start = Input(Bool())
  })

  val storeData = Wire(Vec(ratio - 1, Bool()))

  io.out.bits.dropRight(1).zip(storeData).foreach { case (out, enable) =>
    out := RegEnable(io.in.bits, enable)
  }
  io.out.bits.last := io.in.bits

  val counter = Module(new BasicCounter(width = log2Ceil(ratio), hasCeil = true))
  counter.io.ceil  := ratio.U
  counter.io.reset := io.start
  counter.io.tick  := io.in.fire

  storeData.zipWithIndex.foreach({ case (a, b) => a := counter.io.value === b.U })

  when(counter.io.value === (ratio - 1).U) {
    io.out.valid := io.in.valid
    io.in.ready  := io.out.ready
  } otherwise {
    io.out.valid := false.B
    io.in.ready  := true.B
  }
}

class WidthDownConverter[T <: Data](gen: T, ratio: Int) extends Module with RequireAsyncReset {
  val io = IO(new Bundle {
    val in    = Flipped(Decoupled(Vec(ratio, gen)))
    val out   = Decoupled(gen)
    val start = Input(Bool())
  })

  val storedData = Seq(io.in.bits(0)) ++ io.in.bits.drop(1).map { i =>
    RegEnable(i, io.in.fire)
  }

  val counter = Module(new BasicCounter(width = log2Ceil(ratio), hasCeil = true))
  counter.io.ceil  := ratio.U
  counter.io.reset := io.start
  counter.io.tick  := io.out.fire

  io.out.bits := MuxLookup(counter.io.value, 0.U.asTypeOf(gen))(storedData.zipWithIndex.map { case (i, j) =>
    j.U -> i
  })

  when(counter.io.value === 0.U) {
    io.out.valid := io.in.valid
    io.in.ready  := io.out.ready
  } otherwise {
    io.out.valid := true.B
    io.in.ready  := false.B
  }
}
