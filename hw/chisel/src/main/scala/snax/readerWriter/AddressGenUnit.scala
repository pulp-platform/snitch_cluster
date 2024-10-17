package snax.readerWriter

import snax.utils._
import chisel3._
import chisel3.util._

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
  val spatialStrides =
    Vec(param.spatialBounds.length, UInt(param.addressWidth.W))
  val temporalBounds = Vec(param.temporalDimension, UInt(param.addressWidth.W))
  val temporalStrides = Vec(param.temporalDimension, UInt(param.addressWidth.W))
  val addressRemapIndex = UInt(log2Ceil(param.tcdmLogicWordSize.length).W)

  def connectWithList(csrList: IndexedSeq[UInt]): IndexedSeq[UInt] = {
    var remainingCSR = csrList
    // Connect the ptr
    ptr := Cat(remainingCSR(1), remainingCSR(0))
    remainingCSR = remainingCSR.drop(2)
    // Connect the spatial strides
    for (i <- 0 until spatialStrides.length) {
      spatialStrides(i) := remainingCSR.head
      remainingCSR = remainingCSR.tail
    }
    // Connect the temporal bounds
    for (i <- 0 until temporalBounds.length) {
      temporalBounds(i) := remainingCSR.head
      remainingCSR = remainingCSR.tail
    }
    // Connect the temporal strides
    for (i <- 0 until temporalStrides.length) {
      temporalStrides(i) := remainingCSR.head
      remainingCSR = remainingCSR.tail
    }

    // Connect the address remap index
    if (param.tcdmLogicWordSize.length > 1) {
      addressRemapIndex := remainingCSR.head
      remainingCSR = remainingCSR.tail
    } else {
      addressRemapIndex := 0.U
    }

    remainingCSR
  }
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
    moduleNamePrefix: String = "unnamed_cluster"
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
  })

  require(param.spatialBounds.reduce(_ * _) <= param.numChannel)
  if (param.spatialBounds.reduce(_ * _) > param.numChannel) {
    Console.err.print(
      s"The multiplication of temporal bounds (${param.spatialBounds
          .reduce(_ * _)}) is larger than the number of channels(${param.numChannel}). Check the design parameter if you do not design it intentionally."
    )
  }

  override val desiredName = s"${moduleNamePrefix}_AddressGenUnit"

  // Create counters for each dimension
  val counters = for (i <- 0 until param.temporalDimension) yield {
    val counter = Module(
      new ProgrammableCounter(
        param.addressWidth,
        hasCeil = true,
        s"${moduleNamePrefix}_AddressGenUnitCounter"
      )
    )
    counter.io.reset := io.start
    // counter.io.tick is conenected later, when all necessary signal becomes available
    counter.io.ceil := io.cfg.temporalBounds(i)
    counter.io.step := io.cfg.temporalStrides(i)
    counter
  }

  // Create the outputBuffer to store the generated address
  val outputBuffer = Module(
    new ComplexQueueConcat(
      inputWidth = io.addr.head.bits.getWidth * param.numChannel,
      outputWidth = io.addr.head.bits.getWidth,
      depth = param.outputBufferDepth,
      pipe = true
    ) {
      override val desiredName = s"${moduleNamePrefix}_AddressBufferFIFO"
    }
  )

  // Calculate the current base address: the first stride need to be left-shifted
  val temporalOffset = VecInit(counters.map(_.io.value)).reduceTree(_ + _)

  // This is a table for all possible values that the spatial offset can take
  val spatialOffsetTable = for (i <- 0 until param.spatialBounds.length) yield {
    (0 until param.spatialBounds(i)).map(io.cfg.spatialStrides(i) * _.U)
  }

  val spatialOffsets = for (i <- 0 until param.numChannel) yield {
    var remainder = i
    var spatialOffset = temporalOffset
    for (j <- 0 until param.spatialBounds.length) {
      spatialOffset = spatialOffset + spatialOffsetTable(j)(
        remainder % param.spatialBounds(j)
      )
      remainder = remainder / param.spatialBounds(j)
    }
    spatialOffset
  }

  // Calculate all addresses for different channels together
  val currentAddress = Wire(Vec(io.addr.length, UInt(param.addressWidth.W)))
  currentAddress.zipWithIndex.foreach { case (address, index) =>
    address := io.cfg.ptr + spatialOffsets(index)
  }

  // Connect it to the input of outputBuffer
  // Before the connecting to outputBuffer, the address can be remapped to another address space
  // The Function to do the mapping is defined below:
  def AffineAddressMapping(
      inputAddress: UInt,
      physWordSize: Int,
      logicalWordSize: Int
  ): UInt = {
    import snax.utils.BitsConcat._
    require(logicalWordSize <= physWordSize)
    require(physWordSize % logicalWordSize == 0)
    require(isPow2(logicalWordSize))
    require(isPow2(physWordSize))
    if (logicalWordSize == physWordSize) {
      return inputAddress
    } else {
      return inputAddress(
        inputAddress.getWidth - (log2Ceil(physWordSize) - log2Ceil(
          logicalWordSize
        )) - 1,
        log2Ceil(logicalWordSize)
      ) ++ inputAddress(
        // inputAddress.getWidth - 1,
        inputAddress.getWidth - 1,
        inputAddress.getWidth - (log2Ceil(physWordSize) - log2Ceil(
          logicalWordSize
        ))
      ) ++ inputAddress(log2Ceil(logicalWordSize) - 1, 0)
    }
  }

  // The calling of the functions
  val remappedAddress = param.tcdmLogicWordSize.map { logicalWordSize =>
    currentAddress
      .map(i =>
        AffineAddressMapping(
          i,
          param.tcdmPhysWordSize,
          logicalWordSize
        )
      )
      .reduce((a, b) => Cat(b, a))
  }

  // Which mapping is used can be configured at the runtime. The default is the first mapping
  outputBuffer.io.in.head.bits := MuxLookup(
    io.cfg.addressRemapIndex,
    remappedAddress.head
  )(
    (0 until param.tcdmLogicWordSize.length).map(i => i.U -> remappedAddress(i))
  )
  // outputBuffer.io.in.head.bits := currentAddress.reduce((a, b) => Cat(b, a))

  // Connect the outputs of the buffer out
  outputBuffer.io.out.zip(io.addr).foreach { case (a, b) => a <> b }

  // Connect io.bufferEmpty signal: If all output is 0, then all addresses are empty, which means io.bufferEmpty should be high
  io.bufferEmpty := ~(outputBuffer.io.out.map(i => i.valid).reduce(_ | _))

  // The FSM to record if the AddressGenUnit is busy
  val sIDLE :: sBUSY :: Nil = Enum(2)
  val currentState = RegInit(sIDLE)
  when(io.start && io.cfg.temporalBounds.map(_ =/= 0.U).reduce(_ && _)) { // The cfg is valid, and the start signal is high
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
