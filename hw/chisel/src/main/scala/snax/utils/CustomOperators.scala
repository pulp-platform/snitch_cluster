package snax.utils

import chisel3._
import chisel3.util._
import chisel3.reflect.DataMirror

/** The definition of -|> / -||> / -|||> connector for decoupled signal it
  * connects leftward Decoupled signal (Decoupled port) and rightward Decoupled
  * signal (Flipped port); and insert one level of pipeline in between to avoid
  * long combinatorial datapath
  */

class DataCut[T <: Data](gen: T, delay: Int) extends Module {
  val io = IO(new Bundle {
    val in = Flipped(Decoupled(gen))
    val out = Decoupled(gen)
  })

  val in = Wire(ValidIO(gen))
  val out = Wire(ValidIO(gen))
  val shiftPermission = Wire(Bool())
  val shiftSuggestion = Wire(Bool())
  val shift =
    shiftPermission && shiftSuggestion // shift is true when both shiftPermission and shiftSuggestion are true
  in.bits := io.in.bits
  in.valid := io.in.valid
  io.in.ready := shiftPermission
  io.out.valid := out.valid
  io.out.bits := out.bits
  out := ShiftRegister(in, delay, shift)

  // shiftPermission is true when last item's valid is true and io.out.ready is true or last item's valid is false
  shiftPermission := (out.valid && io.out.ready) || !out.valid

  val dataInsideShiftRegister = Wire(Bool())

  // shiftSuggestion is true when dataInsideShiftRegister is true or input.valid is true
  shiftSuggestion := dataInsideShiftRegister || io.in.valid

  // When the counter is abbout to overflow, data does not inside the shift register
  val insideCounter = Counter(0 to delay, shift, io.in.valid)
  dataInsideShiftRegister := insideCounter._1 =/= delay.U

}

object DecoupledCut {
  implicit class BufferedDecoupledConnectionOp[T <: Data](
      val left: DecoupledIO[T]
  ) {
    // This class defines the implicit class for the new operand -|>,-||>, -|||> for DecoupleIO

    def -|>(
        right: DecoupledIO[T]
    )(implicit sourceInfo: chisel3.experimental.SourceInfo): DecoupledIO[T] = {
      val buffer = Module(
        new Queue(chiselTypeOf(left.bits), entries = 1, pipe = false)
      )
      buffer.suggestName("fullCutHalfBandwidth")

      left <> buffer.io.enq
      buffer.io.deq <> right
      right
    }

    def -||>(
        right: DecoupledIO[T]
    )(implicit sourceInfo: chisel3.experimental.SourceInfo): DecoupledIO[T] = {
      val buffer = Module(
        new Queue(chiselTypeOf(left.bits), entries = 2, pipe = false)
      )
      buffer.suggestName("fullCutFullBandwidth")
      left <> buffer.io.enq
      buffer.io.deq <> right
      right
    }

    def -\>(
        right: DecoupledIO[T]
    )(implicit sourceInfo: chisel3.experimental.SourceInfo): DecoupledIO[T] = {
      val buffer = Module(
        new DataCut(chiselTypeOf(left.bits), delay = 1)
      )
      buffer.suggestName("dataCut1")

      left <> buffer.io.in
      buffer.io.out <> right
      right
    }

    def -\\>(
        right: DecoupledIO[T]
    )(implicit sourceInfo: chisel3.experimental.SourceInfo): DecoupledIO[T] = {
      val buffer = Module(
        new DataCut(chiselTypeOf(left.bits), delay = 2)
      )
      buffer.suggestName("dataCut2")

      left <> buffer.io.in
      buffer.io.out <> right
      right
    }

    def -\\\>(
        right: DecoupledIO[T]
    )(implicit sourceInfo: chisel3.experimental.SourceInfo): DecoupledIO[T] = {
      val buffer = Module(
        new DataCut(chiselTypeOf(left.bits), delay = 3)
      )
      buffer.suggestName("dataCut3")

      left <> buffer.io.in
      buffer.io.out <> right
      right
    }
  }
}

object BitsConcat {
  implicit class UIntConcatOp[T <: Bits](val left: T) {
    // This class defines the implicit class for the new operand ++ for UInt
    def ++(
        right: T
    )(implicit sourceInfo: chisel3.experimental.SourceInfo): T =
      Cat(left, right).asInstanceOf[T]
  }
}
