package snax.utils

import chisel3._
import chisel3.util._

class AsyncQueue[T <: Data](dataType: T, depth: Int = 4)
    extends Module
    with RequireAsyncReset {
  require(
    isPow2(depth),
    "AsyncQueue requires perfect overflow with only one bits flipping"
  )
  val io = IO(new Bundle {
    val enq = new Bundle {
      val clock = Input(Clock())
      val data = Flipped(Decoupled(dataType))
    }
    val deq = new Bundle {
      val clock = Input(Clock())
      val data = Decoupled(dataType)
    }
  })

  // The bit is precalculated and will be used by both readCounter and writeCounter
  val counterBits = log2Up(depth)

  val deqPointer = Wire(UInt(counterBits.W))
  val enqPointer = Wire(UInt(counterBits.W))
  val deqPointerGray = Wire(UInt(counterBits.W))
  val enqPointerGray = Wire(UInt(counterBits.W))
  val nextDeqPointerGray = Wire(UInt(counterBits.W))
  val nextEnqPointerGray = Wire(UInt(counterBits.W))

  // empty and full signals will be driven later
  val empty = Wire(Bool())
  val full = Wire(Bool())
  io.enq.data.ready := ~full
  io.deq.data.valid := ~empty

  // The memory array for the FIFO
//   val mem = withClock(io.enq.clock) { Mem(depth, dataType) }
  val mem = Mem(depth, dataType)

  withClock(io.enq.clock) {
    val enqCounter = Counter(depth)
    enqPointer := enqCounter.value
    enqPointerGray := enqPointer ^ (enqPointer >> 1.U)
    nextEnqPointerGray := (enqPointer + 1.U) ^ ((enqPointer + 1.U) >> 1.U)

    full := nextEnqPointerGray === RegNext(
      RegNext(deqPointerGray, 0.U),
      0.U
    )

    when(io.enq.data.fire) {
      mem.write(enqPointer, io.enq.data.bits, io.enq.clock)
      enqCounter.inc()
    }
  }

  withClock(io.deq.clock) {
    val deqCounter = Counter(depth)
    deqPointer := deqCounter.value
    deqPointerGray := deqPointer ^ (deqPointer >> 1.U)
    nextDeqPointerGray := (deqPointer + 1.U) ^ ((deqPointer + 1.U) >> 1.U)

    empty := deqPointerGray === RegNext(
      RegNext(enqPointerGray, 0.U),
      0.U
    )

    when(io.deq.data.fire) {
      deqCounter.inc()
    }
  }

  io.deq.data.bits := mem.read(deqPointer, io.deq.clock)
}

object AsyncQueueEmitter extends App {
  emitVerilog(new AsyncQueue(UInt(8.W), 16), Array("--target-dir", "generated"))
}
