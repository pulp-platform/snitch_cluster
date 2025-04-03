package snax.utils

import chisel3._

/** This class represents a basic counter module in Chisel.
  *
  * @param width
  *   The width of the counter.
  * @param hasCeil
  *   Indicates whether the counter has a ceiling value.
  */

class BasicCounter(width: Int, hasCeil: Boolean = true) extends Module with RequireAsyncReset {
  val io        = IO(new Bundle {
    val tick  = Input(Bool())
    val reset = Input(Bool())
    val ceil  = Input(UInt(width.W))

    val value   = Output(UInt(width.W))
    val lastVal = Output(Bool())
  })
  // 32.W should be enough to count any loops
  val nextValue = Wire(UInt(width.W))
  val value     = RegNext(nextValue, 0.U)
  nextValue := {
    if (hasCeil) {
      Mux(
        io.reset,
        0.U,
        Mux(io.tick, Mux(value < io.ceil - 1.U, value + 1.U, 0.U), value)
      )
    } else {
      Mux(io.reset, 0.U, Mux(io.tick, value + 1.U, value))
    }
  }

  io.value   := value
  io.lastVal := {
    (if (hasCeil) (value === io.ceil - 1.U) else (value.andR)) && io.tick
  }
}

class UpDownCounter(width: Int) extends Module with RequireAsyncReset {
  val io = IO(new Bundle {
    val tickUp   = Input(Bool())
    val tickDown = Input(Bool())
    val reset    = Input(Bool())
    val ceil     = Input(UInt(width.W))

    val value    = Output(UInt(width.W))
    val firstVal = Output(Bool())
    val lastVal  = Output(Bool())
  })

  // Only one tick signal should be high at a time. If both are high, the counter will not change
  val tick = io.tickUp ^ io.tickDown

  // 32.W should be enough to count any loops
  val nextValue = Wire(UInt(width.W))
  val value     = RegNext(nextValue, 0.U)
  nextValue   := {
    Mux(
      io.reset,
      0.U,
      Mux(
        tick,
        Mux(
          io.tickUp, { // increment logic
            Mux(value < io.ceil - 1.U, value + 1.U, 0.U)
          }, { // decrement logic
            Mux(value > 0.U, value - 1.U, io.ceil - 1.U)
          }
        ),
        value
      )
    )
  }
  io.value    := value
  io.lastVal  := value === io.ceil - 1.U
  io.firstVal := value === 0.U
}

class ProgrammableCounter(width: Int, hasCeil: Boolean = true, moduleName: String = "unnamed_counter")
    extends Module
    with RequireAsyncReset {
  override val desiredName = moduleName
  val io                   = IO(new Bundle {
    val tick  = Input(Bool())
    val reset = Input(Bool())
    val ceil  = Input(UInt(width.W))
    val step  = Input(UInt((width - 1).W))

    val value   = Output(UInt(width.W))
    val lastVal = Output(Bool())
  })
  val nextValue            = Wire(UInt(width.W))
  val value                = RegNext(nextValue, 0.U)

  // If has ceil, a small counter is used to count the step
  // The small counter's function is to determine whether the ceil is reached, and a reset is needed.
  if (hasCeil) {
    val smallCounter = Module(new BasicCounter(width, hasCeil) {
      override val desiredName = s"${moduleName}_SmallCounter"
    })

    smallCounter.io.tick  := io.tick
    smallCounter.io.reset := io.reset
    smallCounter.io.ceil  := io.ceil
    io.lastVal            := smallCounter.io.lastVal
  }

  nextValue := {
    if (hasCeil) {
      Mux(
        io.reset || (io.lastVal && io.tick),
        0.U,
        Mux(io.tick, value + io.step, value)
      )
    } else {
      Mux(io.reset, 0.U, Mux(io.tick, value + io.step, value))
    }
  }

  io.value := value
}
