package snax.xdma.xdmaStreamer

import chisel3._
import chisel3.util._

import snax.xdma.CommonCells._
import snax.xdma.DesignParams._

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
  // io.overFlow := (value === 0.U) && (valuePrevious === io.ceil - 1.U)
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
  val Ptr = UInt(param.addressWidth.W)
  val Strides = Vec(param.dimension, UInt(32.W))
  val Bounds = Vec(param.dimension, UInt(16.W))
}

class AddressGenUnit(param: AddressGenUnitParam)
    extends Module
    with RequireAsyncReset {
  val io = IO(new Bundle {
    val cfg = Input(new AddressGenUnitCfgIO(param))
    // Intake the new cfg file and reset all the counters
    val start = Input(Bool())
    // If the address is all generated and pushed into FIFO, busy is false
    val busy = Output(Bool())
    // If all signal in address buffer is consumed, bufferEmpty becomes high (Dont know if it is useful)
    val bufferEmpty = Output(Bool())
    // The calculated address. This equals to # of output channels (64-bit narrow TCDM)
    val addr =
      Vec(param.spatialUnrollingFactor, Decoupled(UInt(param.addressWidth.W)))
  })

  // Create a counter to count from 0 to product(bounds)
  val counter = Module(new BasicCounter(32))
  // When start signal is high, the counter is rest to zero.
  counter.io.reset := io.start

  // Create the outputBuffer to store the generated address: one input + spatialUnrollingFactor outputs
  val outputBuffer = Module(
    new ComplexQueueConcat(
      inputWidth = io.addr.head.bits.getWidth * param.spatialUnrollingFactor,
      outputWidth = io.addr.head.bits.getWidth,
      depth = param.outputBufferDepth
    )
  )

  // The FSM to record if the AddressGenUnit is busy
  val sIDLE :: sBUSY :: Nil = Enum(2)
  val currentState = RegInit(sIDLE)
  when(io.start) {
    currentState := sBUSY
  }.elsewhen(counter.io.lastVal && outputBuffer.io.in.head.fire) { // The output FIFO already accept the result
    currentState := sIDLE
  }.otherwise {
    currentState := currentState
  }

  // When the AGU becomes busy, the valid signal is pulled up to put address in the fifo
  outputBuffer.io.in.head.valid := currentState === sBUSY
  // io.busy also determined by currentState
  io.busy := currentState === sBUSY

  // Connect the ceil from config to inside
  // The innermost part needs spatial unrolling, but other pats does not needed
  counter.io.ceil := io.cfg.Bounds.reduceTree(
    _ * _
  ) / param.spatialUnrollingFactor.U

  // The counter's tick is the enable signal
  counter.io.tick := currentState === sBUSY && outputBuffer.io.in.head.fire // FIFO still have the space to take the new address

  // The counter's value is split to different rolls and connected to outside
  val currentLoop = Wire(chiselTypeOf(io.cfg.Bounds))
  // temp value is a iterated value, so it is var here.
  var temp = counter.io.value

  // currentLoop(0), is the one need to be divided by the right-shifted loopBound(0)
  currentLoop(0) := temp % (io.cfg.Bounds(0) / param.spatialUnrollingFactor.U)
  temp = temp / (io.cfg.Bounds(0) / param.spatialUnrollingFactor.U)
  // The other loop can be calculated directly
  for (i <- currentLoop.zipWithIndex.tail) {
    i._1 := temp % io.cfg.Bounds(i._2)
    temp = temp / io.cfg.Bounds(i._2)
  }

  // Calculate the current base address: the first stride need to be left-shifted
  val currentPointer =
    io.cfg.Ptr + currentLoop.head * io.cfg.Strides.head * param.spatialUnrollingFactor.U + currentLoop.tail
      .zip(io.cfg.Strides.tail)
      .map { case (a, b) => a * b }
      .reduce(_ + _)

  // Calculate all calculated address together
  val currentAddress = Wire(Vec(io.addr.length, UInt(param.addressWidth.W)))
  currentAddress.zipWithIndex.foreach { case (address, index) =>
    address := currentPointer + io.cfg.Strides.head * index.U
  }

  // Connect it to the input of outputBuffer
  outputBuffer.io.in.head.bits := currentAddress.reduce((a, b) => Cat(b, a))

  // Connect the outputs of the buffer out
  outputBuffer.io.out.zip(io.addr).foreach { case (a, b) => a <> b }

  // Connect io.bufferEmpty signal: If all output is 0, then all addresses are empty, which means io.bufferEmpty should be high
  io.bufferEmpty := ~(outputBuffer.io.out.map(i => i.valid).reduce(_ | _))

}
