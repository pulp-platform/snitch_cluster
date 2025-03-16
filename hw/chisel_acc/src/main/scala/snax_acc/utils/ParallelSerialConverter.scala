package snax_acc.utils

import chisel3._
import chisel3.util._

import scala.math._

/** Parameter class for ParallelToSerial.
  *
  * @param parallelWidth
  *   The total width of the parallel input data.
  * @param serialWidth
  *   The width of each output serial chunk, must divide parallelWidth evenly.
  */
case class ParallelToSerialParams(
    parallelWidth: Int,
    serialWidth: Int
) {
  require(
    parallelWidth % serialWidth == 0,
    "parallelWidth must be an integer multiple of serialWidth."
  )
}

/** A module that sends a parallel input (via Decoupled I/O) out as multiple
  * serial chunks (also Decoupled I/O).
  */
class ParallelToSerial(val p: ParallelToSerialParams) extends Module {
  val io = IO(new Bundle {
    val in = Flipped(Decoupled(UInt(p.parallelWidth.W)))
    val out = Decoupled(UInt(p.serialWidth.W))
  })

  // Calculate how many serial chunks form one parallel word.
  val factor = p.parallelWidth / p.serialWidth

  // Shift register to hold the parallel data while serializing.
  if (p.parallelWidth <= 2048) {} else {
    // If the parallelWidth is greater than 2048, we need to use several smaller shift register
    require(
      p.parallelWidth % 2048 == 0,
      "parallelWidth must be an integer multiple of 2048."
    )
  }

  val numRegs = math.max(1, p.parallelWidth / 2048) // Number of registers
  val shiftReg = RegInit(VecInit(Seq.fill(numRegs)(0.U(2048.W))))

  // Counts how many chunks remain to be sent.
  val count = RegInit(0.U(log2Ceil(factor + 1).W))

  // Accept a new parallel word only if we have nothing left to send.
  io.in.ready := (count === 0.U)

  // Once we get a new parallel word, store it and prepare to send.
  // store in the vector of regs
  if (p.parallelWidth <= 2048) {
    when(io.in.fire) {
      shiftReg(0) := io.in.bits
    }
    .elsewhen(io.out.fire) {
      shiftReg(0) := shiftReg(0) >> p.serialWidth.U
    }
  } else {
    when(io.in.fire) {
      for (i <- 0 until numRegs) {
        shiftReg(i) := io.in.bits(i * 2048 + 2047, i * 2048)
      }
    }.elsewhen(io.out.fire) {
      for (i <- 0 until numRegs) {
        if (i == numRegs - 1) {
          // If we are at the last register, we need to shift in zeros
          shiftReg(i) := Cat(
            0.U(p.serialWidth.W),
            shiftReg(i)(2047, p.serialWidth)
          )
        } else {
          // Otherwise, shift in the next register
          shiftReg(i) := Cat(
            shiftReg(i + 1)(p.serialWidth - 1, 0),
            shiftReg(i)(2047, p.serialWidth)
          )
        }
      }
    }
  }

  // On handshake, shift to the next chunk and decrement count.
  when(io.in.fire) {
    count := factor.U
  }.elsewhen(io.out.fire) {
    count := count - 1.U
  }

  // The output is valid if there are chunks left to send.
  io.out.valid := (count > 0.U)
  // The current chunk to send is the least significant bits of shiftReg.
  io.out.bits := shiftReg(0)(p.serialWidth - 1, 0)

}

/** Parameter class for SerialToParallel.
  *
  * @param serialWidth
  *   The width of each incoming serial data chunk.
  * @param parallelWidth
  *   The total width of the parallel output data. Must be a multiple of
  *   serialWidth.
  */
case class SerialToParallelParams(
    serialWidth: Int,
    parallelWidth: Int
) {
  require(
    parallelWidth % serialWidth == 0,
    "parallelWidth must be an integer multiple of serialWidth."
  )
}

/** A module that collects multiple serial inputs (via Decoupled I/O) and
  * outputs them as a single parallel word (also Decoupled I/O).
  *
  * This version defers output by one clock after receiving the final serial
  * chunk, ensuring that the shift register contains the correct concatenated
  * data.
  */
class SerialToParallel(val p: SerialToParallelParams) extends Module {
  val io = IO(new Bundle {
    val in = Flipped(Decoupled(UInt(p.serialWidth.W)))
    val out = Decoupled(UInt(p.parallelWidth.W))
  })

  // Number of input chunks required to form one parallel output
  val factor: Int = p.parallelWidth / p.serialWidth

  // Registers to track incoming data and chunk count
  val numRegs = math.max(1, p.parallelWidth / 2048) // Number of registers
  val shiftReg = RegInit(VecInit(Seq.fill(numRegs)(0.U(2048.W))))
  val count = RegInit(0.U(log2Ceil(factor + 1).W))

  io.in.ready := count =/= factor.U

  when(io.in.fire && count === 0.U) {
    // If we're at the first chunk, reset the shift register
    for (i <- 0 until numRegs) {
      if (i == numRegs - 1) {
        shiftReg(i) := Cat(io.in.bits, 0.U((2048 - p.serialWidth).W))
      } else {
        shiftReg(i) := 0.U
      }
    }
  }.elsewhen(io.in.fire && count =/= 0.U) {
    // Shift in the new serial bits at a position based on the count
    for (i <- 0 until numRegs) {
      if (i == numRegs - 1) {
        shiftReg(i) := Cat(io.in.bits, shiftReg(i)(2047, p.serialWidth))
      } else {
        shiftReg(i) := Cat(
          shiftReg(i + 1)(p.serialWidth - 1, 0),
          shiftReg(i)(2047, p.serialWidth)
        )
      }
    }
  }

  when(io.out.fire) {
    count := 0.U
  }.elsewhen(io.in.fire) {
    count := count + 1.U
  }

  io.out.valid := count === factor.U

  // Concatenate the shift register contents to form the parallel output
  if (p.parallelWidth <= 2048) {
    io.out.bits := shiftReg(0)(2047, 2047 - p.parallelWidth + 1)
  } else {
    io.out.bits := Cat(shiftReg.reverse)
  }

}
