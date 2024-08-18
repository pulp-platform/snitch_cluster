package snax.xdma.xdmaStreamer

import chisel3._
import chisel3.util._

import snax.xdma.CommonCells._
import snax.xdma.DesignParams._

/** This class represents a basic counter module in Chisel.
  *
  * @param width
  *   The width of the counter.
  * @param hasCeil
  *   Indicates whether the counter has a ceiling value.
  */

class BasicCounter(width: Int, hasCeil: Boolean = true)
    extends Module
    with RequireAsyncReset {
  val io = IO(new Bundle {
    val tick = Input(Bool())
    val reset = Input(Bool())
    val ceil = Input(UInt(width.W))

    val value = Output(UInt(width.W))
    val lastVal = Output(Bool())
  })
  // 32.W should be enough to count any loops
  val nextValue = Wire(UInt(width.W))
  val value = RegNext(nextValue, 0.U)
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

  io.value := value
  io.lastVal := {
    if (hasCeil) (value === io.ceil - 1.U) else (value.andR)
  }
}

class ProgrammableCounter(width: Int, hasCeil: Boolean = true)
    extends Module
    with RequireAsyncReset {
  val io = IO(new Bundle {
    val tick = Input(Bool())
    val reset = Input(Bool())
    val ceil = Input(UInt(width.W))
    val step = Input(UInt((width - 1).W))

    val value = Output(UInt(width.W))
    val lastVal = Output(Bool())
  })
  val nextValue = Wire(UInt(width.W))
  val value = RegNext(nextValue, 0.U)

  // If has ceil, a small counter is used to count the step
  // The small counter's function is to determine whether the ceil is reached, and a reset is needed.
  if (hasCeil) {
    val smallCounter = Module(new BasicCounter(width, hasCeil) {
      override val desiredName = "ProgrammableCounter_SmallCounter"
    })

    smallCounter.io.tick := io.tick
    smallCounter.io.reset := io.reset
    smallCounter.io.ceil := io.ceil
    io.lastVal := smallCounter.io.lastVal
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

/** AGU is the module to automatically generate the address for all ports.
  * @input
  *   cfg The description of the Address Generation Task. It is normally
  *   configured by CSR manager
  * @input
  *   start The signal to start a address generation task
  * @output
  *   busy The signal to indicate whether all address generation is finished.
  *   Only when busy == 0 the next address generation task can be launched
  * @output
  *   addresses The Vec[Decoupled[UInt]] signal to give tcdm_requestors the
  *   address
  * @param AddressGenUnitParam
  *   The parameter used for generation of the module
  */

class AddressGenUnitCfgIO(param: AddressGenUnitParam) extends Bundle {
  val ptr = UInt(param.addressWidth.W)
  val strides = Vec(param.dimension, UInt(param.addressWidth.W))
  val bounds = Vec(param.dimension, UInt(param.addressWidth.W))
}

/** AGU is the module to automatically generate the address for all ports.
  * @input
  *   cfg The description of the Address Generation Task. It is normally
  *   configured by CSR manager
  * @input
  *   start The signal to start a address generation task
  * @output
  *   busy The signal to indicate whether all address generation is finished.
  *   Only when busy == 0 the next address generation task can be launched
  * @output
  *   addresses The Vec[Decoupled[UInt]] signal to give tcdm_requestors the
  *   address
  * @param AddressGenUnitParam
  *   The parameter used for generation of the module This version of AGU aims
  *   to totally remove multiplication and division in temporal address
  *   generation
  */
class AddressGenUnit(
    param: AddressGenUnitParam,
    module_name_prefix: String = "unnamed_cluster"
) extends Module
    with RequireAsyncReset {
  val io = IO(new Bundle {
    val cfg = Input(new AddressGenUnitCfgIO(param))
    // Take in the new cfg file and reset all the counters
    val start = Input(Bool())
    // If the address is all generated and pushed into FIFO, busy is false
    val busy = Output(Bool())
    // If all signal in address buffer is consumed, bufferEmpty becomes high
    val bufferEmpty = Output(Bool())
    // The calculated address. This equals to # of output channels (64-bit narrow TCDM)
    val addr =
      Vec(param.numChannel, Decoupled(UInt(param.addressWidth.W)))
    val enabled_channels = Vec(param.numChannel, Output(Bool()))
  })

  override val desiredName = s"${module_name_prefix}_AddressGenUnitNoMulDiv"

  // Create counters for each dimension
  // Be aware that counter is not needed for the first dimension, because it is the spatial bound
  val counters = for (i <- 1 until param.dimension) yield {
    val counter = Module(
      new ProgrammableCounter(param.addressWidth, hasCeil = true) {
        override val desiredName =
          s"${module_name_prefix}_AddressGenUnitNoMulDiv_Counter_${i}"
      }
    )
    counter.io.reset := io.start
    // counter.io.tick is conenected later, when all necessary signal becomes available
    counter.io.ceil := io.cfg.bounds(i)
    counter.io.step := io.cfg.strides(i)
    counter
  }

  // Create the outputBuffer to store the generated address: one input + spatialUnrollingFactor outputs
  val outputBuffer = Module(
    new ComplexQueueConcat(
      inputWidth = io.addr.head.bits.getWidth * param.numChannel,
      outputWidth = io.addr.head.bits.getWidth,
      depth = param.outputBufferDepth
    ) {
      override val desiredName = s"${module_name_prefix}_AddressBufferFIFO"
    }
  )

  // Calculate the current base address: the first stride need to be left-shifted
  val temporalOffset = VecInit(counters.map(_.io.value)).reduceTree(_ + _)
  val spatialOffsets = for (i <- 0 until param.numChannel) yield {
    val spatialOffset = temporalOffset + io.cfg.strides.head * i.U
    spatialOffset
  }

  // Calculate all addresses for different channels together
  val currentAddress = Wire(Vec(io.addr.length, UInt(param.addressWidth.W)))
  currentAddress.zipWithIndex.foreach { case (address, index) =>
    address := io.cfg.ptr + spatialOffsets(index)
  }

  // Connect it to the input of outputBuffer
  outputBuffer.io.in.head.bits := currentAddress.reduce((a, b) => Cat(b, a))

  // Connect the outputs of the buffer out
  outputBuffer.io.out.zip(io.addr).foreach { case (a, b) => a <> b }

  // Connect io.bufferEmpty signal: If all output is 0, then all addresses are empty, which means io.bufferEmpty should be high
  io.bufferEmpty := ~(outputBuffer.io.out.map(i => i.valid).reduce(_ | _))

  // The FSM to record if the AddressGenUnit is busy
  val sIDLE :: sBUSY :: Nil = Enum(2)
  val currentState = RegInit(sIDLE)
  when(io.start) {
    currentState := sBUSY
  }.elsewhen(
    counters.map(_.io.lastVal).reduce(_ & _) && outputBuffer.io.in.head.fire
  ) { // The output FIFO already accept the result
    currentState := sIDLE
  }.otherwise {
    currentState := currentState
  }

  // When the AGU becomes busy, the valid signal is pulled up to put address in the fifo
  outputBuffer.io.in.head.valid := currentState === sBUSY
  // io.busy also determined by currentState
  io.busy := currentState === sBUSY

  // Spatial bound
  // The innermost one is the spatial bound, so it should not be multiplied with other bounds.
  // If param.configurableSpatialBound is true, then the spatial bound is configurable
  if (param.configurableSpatialBound) {
    io.enabled_channels.zipWithIndex.foreach { case (a, b) =>
      a := io.cfg.bounds.head > b.U
    }
    assert(
      io.cfg.bounds.head <= param.numChannel.U,
      "[AddressGenUnit] The innermost bound is spatial bound, so it should be less than or equal to the number of channels"
    )
  } else {
    io.enabled_channels.foreach(_ := true.B)
  }

  // Temporal bounds' tick signal (enable signal)
  val counters_tick =
    currentState === sBUSY && outputBuffer.io.in.head.fire // FIFO still have the space to take the new address
  // First counter's tick is connected to the start signal
  counters.head.io.tick := counters_tick
  // Other counters' tick is connected to the previous counter's lastVal & counters_tick
  if (counters.length > 1) {
    counters.tail.zip(counters).foreach { case (a, b) =>
      a.io.tick := b.io.lastVal && counters_tick
    }
  }
}
