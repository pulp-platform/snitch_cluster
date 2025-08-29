package snax.utils
import chisel3._
import chisel3.util._
import chisel3.experimental.requireIsChiselType

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

  // Use ShiftRegister with reset values to avoid X propagation
  out      := ShiftRegister(in, delay, 0.U.asTypeOf(gen), shift)
  outValid := ShiftRegister(inValid, delay, false.B, shift)

  // shiftPermission is true when last item's valid is true and io.out.ready is true or last item's valid is false
  shiftPermission := (outValid && io.out.ready) || !outValid
  val dataInsideShiftRegister = Wire(Bool())
  // shiftSuggestion is true when dataInsideShiftRegister is true or input.valid is true
  shiftSuggestion := dataInsideShiftRegister || io.in.valid
  // When the counter is about to overflow, data does not inside the shift register
  val insideCounter = Counter(0 to delay, shift, io.in.valid)
  dataInsideShiftRegister := insideCounter._1 =/= delay.U
}

/** RegQueue - A hardware module implementing a Queue with proper reset handling This is a drop-in replacement for the
  * standard Queue that properly resets all internal registers
  */
class RegQueue[T <: Data](
  val gen:            T,
  val entries:        Int,
  val pipe:           Boolean = false,
  val flow:           Boolean = false,
  val useSyncReadMem: Boolean = false,
  val hasFlush:       Boolean = false
) extends Module() {
  require(entries > -1, "Queue must have non-negative number of entries")
  require(entries != 0, "Use companion object Queue.apply for zero entries")
  requireIsChiselType(gen)

  val io         = IO(new QueueIO(gen, entries, hasFlush))
  val ram        = RegInit(VecInit(Seq.fill(entries)(0.U.asTypeOf(gen))))
  val enq_ptr    = Counter(entries)
  val deq_ptr    = Counter(entries)
  val maybe_full = RegInit(false.B)
  val ptr_match  = enq_ptr.value === deq_ptr.value
  val empty      = ptr_match && !maybe_full
  val full       = ptr_match && maybe_full
  val do_enq     = WireDefault(io.enq.fire)
  val do_deq     = WireDefault(io.deq.fire)
  val flush      = io.flush.getOrElse(false.B)

  // when flush is high, empty the queue
  // Semantically, any enqueues happen before the flush.
  when(do_enq) {
    ram(enq_ptr.value) := io.enq.bits
    enq_ptr.inc()
  }
  when(do_deq) {
    deq_ptr.inc()
  }
  when(do_enq =/= do_deq) {
    maybe_full := do_enq
  }
  when(flush) {
    enq_ptr.reset()
    deq_ptr.reset()
    maybe_full := false.B
  }

  io.deq.valid := !empty
  io.enq.ready := !full

  io.deq.bits := ram(deq_ptr.value)

  if (flow) {
    when(io.enq.valid) { io.deq.valid := true.B }
    when(empty) {
      io.deq.bits := io.enq.bits
      do_deq      := false.B
      when(io.deq.ready) { do_enq := false.B }
    }
  }

  if (pipe) {
    when(io.deq.ready) { io.enq.ready := true.B }
  }

  val ptr_diff = enq_ptr.value - deq_ptr.value

  if (isPow2(entries)) {
    io.count := Mux(maybe_full && ptr_match, entries.U, 0.U) | ptr_diff
  } else {
    io.count := Mux(
      ptr_match,
      Mux(maybe_full, entries.asUInt, 0.U),
      Mux(deq_ptr.value > enq_ptr.value, entries.asUInt + ptr_diff, ptr_diff)
    )
  }

  /** Give this Queue a default, stable desired name using the supplied `Data` generator's `typeName`
    */
  override def desiredName = s"Queue${entries}_${gen.typeName}"
}

object DecoupledCut {
  implicit class BufferedDecoupledConnectionOp[T <: Data](val left: DecoupledIO[T]) {
    // This class defines the implicit class for the new operand -|>,-||>, -|||> for DecoupleIO
    def -|>(
      right: DecoupledIO[T]
    )(implicit sourceInfo: chisel3.experimental.SourceInfo): DecoupledIO[T] = {
      val buffer = Module(
        new RegQueue(chiselTypeOf(left.bits), entries = 1, pipe = false) {
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
        new RegQueue(chiselTypeOf(left.bits), entries = 2, pipe = false) {
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
