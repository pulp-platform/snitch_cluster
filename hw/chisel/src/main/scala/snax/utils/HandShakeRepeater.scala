package snax.utils

import chisel3._
import chisel3.util._

class HandShakeRepeater[T <: Data](gen: T, counterWidth: Int, moduleNamePrefix: String = "unnamed_cluster")
    extends Module {
  val io = IO(new Bundle {
    val in           = Flipped(Decoupled(gen))
    val out          = Decoupled(gen)
    val repeat_times = Input(UInt(counterWidth.W))
    val start        = Input(Bool())
  })

  val dataRepeatCounter = Module(
    new BasicCounter(counterWidth, hasCeil = true) {
      override val desiredName = s"${moduleNamePrefix}_Reader_DataRepeatCounter"
    }
  )
  dataRepeatCounter.io.reset := io.start
  dataRepeatCounter.io.ceil := io.repeat_times
  dataRepeatCounter.io.tick := io.out.fire

  io.in.ready := io.out.fire && dataRepeatCounter.io.lastVal

  io.out.bits  := io.in.bits
  io.out.valid := io.in.valid
}
