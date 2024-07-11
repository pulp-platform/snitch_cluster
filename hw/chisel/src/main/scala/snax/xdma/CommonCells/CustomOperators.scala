package snax.xdma.CommonCells

import chisel3._
import chisel3.util._
import chisel3.reflect.DataMirror
import chisel3.internal.throwException
import chisel3.internal.throwException

/** The definition of -|> / -||> / -|||> connector for decoupled signal it
  * connects leftward Decoupled signal (Decoupled port) and rightward Decoupled
  * signal (Flipped port); and insert one level of pipeline in between to avoid
  * long combinatorial datapath
  */
object DecoupledCut {
  implicit class BufferedDecoupledConnectionOp[T <: Data](
      val left: DecoupledIO[T]
  ) {
    // This class defines the implicit class for the new operand -|>,-||>, -|||> for DecoupleIO

    def -|>(
        right: DecoupledIO[T]
    )(implicit sourceInfo: chisel3.experimental.SourceInfo): Unit = {
      val buffer = Module(
        new Queue(chiselTypeOf(left.bits), entries = 1, pipe = false)
      )
      buffer.suggestName("cut1")

      left <> buffer.io.enq
      buffer.io.deq <> right
    }

    def -||>(
        right: DecoupledIO[T]
    )(implicit sourceInfo: chisel3.experimental.SourceInfo): Unit = {
      val buffer = Module(
        new Queue(chiselTypeOf(left.bits), entries = 2, pipe = false)
      )
      buffer.suggestName("cut2")
      left <> buffer.io.enq
      buffer.io.deq <> right
    }

    def -|||>(
        right: DecoupledIO[T]
    )(implicit sourceInfo: chisel3.experimental.SourceInfo): Unit = {
      val buffer = Module(
        new Queue(chiselTypeOf(left.bits), entries = 3, pipe = false)
      )
      buffer.suggestName("cut3")
      left <> buffer.io.enq
      buffer.io.deq <> right
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
