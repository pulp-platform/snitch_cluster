package snax_acc.utils

import chisel3._
import chisel3.util._

/** The definition of -|> / -||> / -|||> connector for decoupled signal it connects leftward Decoupled signal (Decoupled
  * port) and rightward Decoupled signal (Flipped port); and insert one level of pipeline in between to avoid long
  * combinatorial datapath
  */

class DataCut[T <: Data](gen: T, delay: Int) extends Module {
  val io              = IO(new Bundle {
    val in  = Flipped(Decoupled(gen))
    val out = Decoupled(gen)
  })
  val in              = Wire(gen)
  val inValid         = Wire(Bool())
  val out             = Wire(gen)
  val outValid        = Wire(Bool())
  val shiftPermission = Wire(Bool())
  val shiftSuggestion = Wire(Bool())
  val shift           =
    shiftPermission && shiftSuggestion // shift is true when both shiftPermission and shiftSuggestion are true
  inValid           := io.in.valid
  in                := io.in.bits
  io.in.ready       := shiftPermission
  io.out.valid      := outValid
  io.out.bits       := out
  out               := ShiftRegister(in, delay, shift)
  outValid          := ShiftRegister(inValid, delay, false.B, shift)

  // shiftPermission is true when last item's valid is true and io.out.ready is true or last item's valid is false
  shiftPermission := (outValid && io.out.ready) || !outValid

  val dataInsideShiftRegister = Wire(Bool())

  // shiftSuggestion is true when dataInsideShiftRegister is true or input.valid is true
  shiftSuggestion := dataInsideShiftRegister || io.in.valid

  // When the counter is about to overflow, data does not inside the shift register
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
        new Queue(chiselTypeOf(left.bits), entries = 1, pipe = false) {
          override val desiredName =
            "FullCutHalfBandwidth_W_" + left.bits.getWidth.toString + "_T_" + left.bits.getClass.getSimpleName
        }
      )
      buffer.suggestName(left.circuitName + "_fullCutHalfBandwidth")
      left <> buffer.io.enq
      buffer.io.deq <> right
      right
    }

    def -||>(
      right: DecoupledIO[T]
    )(implicit sourceInfo: chisel3.experimental.SourceInfo): DecoupledIO[T] = {
      val buffer = Module(
        new Queue(chiselTypeOf(left.bits), entries = 2, pipe = false) {
          override val desiredName =
            "FullCutFullBandwidth_W_" + left.bits.getWidth.toString + "_T_" + left.bits.getClass.getSimpleName
        }
      )
      buffer.suggestName(left.circuitName + "_fullCutFullBandwidth")
      left <> buffer.io.enq
      buffer.io.deq <> right
      right
    }

    def -\>(
      right: DecoupledIO[T]
    )(implicit sourceInfo: chisel3.experimental.SourceInfo): DecoupledIO[T] = {
      val buffer = Module(
        new DataCut(chiselTypeOf(left.bits), delay = 1) {
          override val desiredName =
            "DataCut1_W_" + left.bits.getWidth.toString + "_T_" + left.bits.getClass.getSimpleName
        }
      )
      buffer.suggestName(left.circuitName + "_dataCut1")
      left <> buffer.io.in
      buffer.io.out <> right
      right
    }

    def -\\>(
      right: DecoupledIO[T]
    )(implicit sourceInfo: chisel3.experimental.SourceInfo): DecoupledIO[T] = {
      val buffer = Module(
        new DataCut(chiselTypeOf(left.bits), delay = 2) {
          override val desiredName =
            "DataCut2_W_" + left.bits.getWidth.toString + "_T_" + left.bits.getClass.getSimpleName
        }
      )
      buffer.suggestName(left.circuitName + "_dataCut2")
      left <> buffer.io.in
      buffer.io.out <> right
      right
    }

    def -\\\>(
      right: DecoupledIO[T]
    )(implicit sourceInfo: chisel3.experimental.SourceInfo): DecoupledIO[T] = {
      val buffer = Module(
        new DataCut(chiselTypeOf(left.bits), delay = 3) {
          override val desiredName =
            "DataCut3_W_" + left.bits.getWidth.toString + "_T_" + left.bits.getClass.getSimpleName
        }
      )
      buffer.suggestName(left.circuitName + "_dataCut3")
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
    )(implicit sourceInfo: chisel3.experimental.SourceInfo): T = Cat(left, right).asInstanceOf[T]
  }
}
