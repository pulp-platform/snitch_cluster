package snax.xdma.xdmaIO

import chisel3._
import chisel3.util._

import snax.readerWriter.AddressGenUnitCfgIO
import snax.readerWriter.AddressGenUnitParam
import snax.readerWriter.ReaderWriterCfgIO
import snax.utils._
import snax.xdma.DesignParams._

// The sturctured class that used to store the CFG of reader and writer, connected with the CSR
// The full address (readerPtr, writerPtr) is included in this class, for the purpose of cross-cluster communication
// The truncated version of address is assigned to aguCfg for the generation of local address which will be consumed by TCDM
// Loopback signal is also included in this class, for the purpose of early judgement
// Also the extension cfg is included in this class
class XDMACfgIO(val param: XDMAParam) extends Bundle {
  val taskID = UInt(4.W)

  // Definition origination = 0 means the data is from local, origination = 1 means the data is from remote
  val originationIsFromLocal  = false
  val originationIsFromRemote = true
  val origination             = Bool()
  val readerPtr               = UInt(param.axiParam.addrWidth.W)
  // val writerPtr = UInt(param.axiParam.addrWidth.W)
  val writerPtr               =
    Vec(
      param.crossClusterParam.maxMulticastDest,
      UInt(param.axiParam.addrWidth.W)
    )

  val axiTransferBeatSize = UInt(param.crossClusterParam.tcdmAddressWidth.W)

  val aguCfg          =
    new AddressGenUnitCfgIO(param =
      AddressGenUnitParam(
        temporalDimension = param.crossClusterParam.maxTemporalDimension,
        numChannel        = param.axiParam.dataWidth / param.crossClusterParam.wordlineWidth,
        outputBufferDepth = param.rwParam.aguParam.outputBufferDepth,
        tcdmSize          = param.crossClusterParam.tcdmSize
      )
    ) // Buffered within AGU
  val readerwriterCfg = new ReaderWriterCfgIO(param.rwParam)
  // The LocalLoopback signal to control the data in reader directly sending back to writer
  val localLoopback   = Bool()
  // The RemoteLoopback signal to control the data in fromRemoteData directly seending back to toRemoteData
  val remoteLoopback  = Bool()

  val extCfg = if (param.extParam.length != 0) {
    Vec(
      param.extParam.map { i => i.extensionParam.userCsrNum }.reduce(_ + _) + 1,
      UInt(32.W)
    ) // The total csr required by all extension + 1 for the bypass signal
  } else Vec(0, UInt(32.W))

  // Connect the readerPtr + writerPtr with the CSR list (not removed from the list)
  def connectPtrWithList(csrList: IndexedSeq[UInt]): Unit = {
    var remainingCSR = csrList
    val numCSRPerPtr = (param.axiParam.addrWidth + 31) / 32
    readerPtr := Cat(remainingCSR.take(numCSRPerPtr).reverse)
    remainingCSR = remainingCSR.drop(numCSRPerPtr)
    writerPtr.foreach { i =>
      i := Cat(remainingCSR.take(numCSRPerPtr).reverse)
      remainingCSR = remainingCSR.drop(numCSRPerPtr)
    }
  }

  // Drop the readerPtr + writerPtr from the CSR list
  def dropPtrFromList(csrList: IndexedSeq[UInt]): IndexedSeq[UInt] = {
    var remainingCSR = csrList
    val numCSRPerPtr = (param.axiParam.addrWidth + 31) / 32
    remainingCSR = remainingCSR.drop(numCSRPerPtr)
    writerPtr.foreach { _ =>
      remainingCSR = remainingCSR.drop(numCSRPerPtr)
    }
    remainingCSR
  }

  // Connect the remaining CFG with the CSR list
  def connectWithList(
    csrList: IndexedSeq[UInt]
  ): IndexedSeq[UInt] = {
    origination := originationIsFromLocal.B
    var remaincsrList = csrList
    remaincsrList = aguCfg.connectWithList(remaincsrList)
    remaincsrList = readerwriterCfg.connectWithList(remaincsrList)
    extCfg := remaincsrList.take(extCfg.length)
    remaincsrList = remaincsrList.drop(extCfg.length)
    remaincsrList
  }
}

// The structured class that used by reader / writer hardware
class XDMAIntraClusterCfgIO(param: XDMAParam) extends Bundle {
  val taskID = UInt(4.W)

  // Definition origination = 0 means the data is from local, origination = 1 means the data is from remote
  val originationIsFromLocal  = false
  val originationIsFromRemote = true
  val origination             = Bool()
  val readerPtr               = UInt(param.axiParam.addrWidth.W)
  // val writerPtr = UInt(param.axiParam.addrWidth.W)
  val writerPtr               =
    Vec(
      param.crossClusterParam.maxMulticastDest,
      UInt(param.axiParam.addrWidth.W)
    )

  val axiTransferBeatSize = UInt(param.crossClusterParam.tcdmAddressWidth.W)

  val aguCfg          =
    new AddressGenUnitCfgIO(param = param.rwParam.aguParam) // Buffered within AGU
  val readerwriterCfg = new ReaderWriterCfgIO(param.rwParam)
  // The LocalLoopback signal to control the data in reader directly sending back to writer
  val localLoopback   = Bool()
  // The RemoteLoopback signal to control the data in fromRemoteData directly seending back to toRemoteData
  val remoteLoopback  = Bool()

  val extCfg = if (param.extParam.length != 0) {
    Vec(
      param.extParam.map { i => i.extensionParam.userCsrNum }.reduce(_ + _) + 1,
      UInt(32.W)
    ) // The total csr required by all extension + 1 for the bypass signal
  } else Vec(0, UInt(32.W))

  // Convert the XDMACfgIO to XDMAIntraClusterCfgIO
  def convertFromXDMACfgIO(cfg: XDMACfgIO): Unit = {
    taskID                   := cfg.taskID
    origination              := cfg.origination
    readerPtr                := cfg.readerPtr
    writerPtr                := cfg.writerPtr
    axiTransferBeatSize      := cfg.axiTransferBeatSize
    aguCfg.addressRemapIndex := cfg.aguCfg.addressRemapIndex
    aguCfg.ptr               := cfg.aguCfg.ptr
    aguCfg.spatialStrides    := cfg.aguCfg.spatialStrides.take(
      aguCfg.spatialStrides.length
    )

    // The unused fields in the temporalStrides should always be 0
    aguCfg.temporalStrides := cfg.aguCfg.temporalStrides.take(
      aguCfg.temporalStrides.length
    )

    // The unused fields in the temporalBounds should always be 1
    aguCfg.temporalBounds := cfg.aguCfg.temporalBounds.take(
      aguCfg.temporalBounds.length
    )

    readerwriterCfg := cfg.readerwriterCfg
    localLoopback   := cfg.localLoopback
    remoteLoopback  := cfg.remoteLoopback
    extCfg          := cfg.extCfg
  }
}

class XDMAInterClusterCfgIO(readerParam: XDMAParam, writerParam: XDMAParam) extends Bundle {
  val taskID              = UInt(4.W)
  val isWriterSide        = Bool()
  val readerPtr           = UInt(readerParam.crossClusterParam.AxiAddressWidth.W)
  // Writer pointer only needs first two elements, as now the broadcast is tackled in XDMACfgIO level
  val writerPtr           = Vec(
    2,
    UInt(readerParam.crossClusterParam.AxiAddressWidth.W)
  )
  val axiTransferBeatSize = UInt(readerParam.crossClusterParam.tcdmAddressWidth.W)
  val spatialStride       = UInt(readerParam.crossClusterParam.tcdmAddressWidth.W)

  val temporalBounds  = Vec(
    readerParam.crossClusterParam.maxTemporalDimension,
    UInt(readerParam.crossClusterParam.tcdmAddressWidth.W)
  )
  val temporalStrides = Vec(
    readerParam.crossClusterParam.maxTemporalDimension,
    UInt(readerParam.crossClusterParam.tcdmAddressWidth.W)
  )
  val enabledChannel  = UInt(readerParam.crossClusterParam.channelNum.W)
  val enabledByte     = UInt((readerParam.crossClusterParam.wordlineWidth / 8).W)

  def convertFromXDMACfgIO(
    writerSide: Boolean,
    cfg:        XDMACfgIO
  ): Unit = {
    taskID                   := cfg.taskID
    isWriterSide             := writerSide.B
    readerPtr                := cfg.readerPtr
    writerPtr(0)             := cfg.writerPtr(0)
    if (writerPtr.length > 1 && cfg.writerPtr.length > 1) writerPtr(1) := cfg.writerPtr(1)
    else writerPtr(1)        := 0.U(0.W)
    axiTransferBeatSize      := cfg.axiTransferBeatSize
    spatialStride            := cfg.aguCfg
      .spatialStrides(0)
      .apply(
        cfg.aguCfg.spatialStrides(0).getWidth - 1,
        log2Ceil(readerParam.crossClusterParam.wordlineWidth / 8)
      )
    temporalStrides          := cfg.aguCfg.temporalStrides.map(
      _.apply(
        cfg.aguCfg.temporalStrides(0).getWidth - 1,
        log2Ceil(readerParam.crossClusterParam.wordlineWidth / 8)
      )
    )
    temporalBounds           := cfg.aguCfg.temporalBounds
    enabledChannel           := cfg.readerwriterCfg.enabledChannel
    enabledByte              := cfg.readerwriterCfg.enabledByte
  }

  def convertToXDMACfgIO(readerSide: Boolean): XDMACfgIO = {
    val xdmaCfg = if (readerSide) { Wire(new XDMACfgIO(readerParam)) }
    else { Wire(new XDMACfgIO(writerParam)) }

    xdmaCfg                                                := 0.U.asTypeOf(xdmaCfg)
    xdmaCfg.taskID                                         := taskID
    xdmaCfg.readerPtr                                      := readerPtr
    xdmaCfg.writerPtr(0)                                   := writerPtr(0)
    if (xdmaCfg.writerPtr.length > 1) xdmaCfg.writerPtr(1) := writerPtr(1)
    if (xdmaCfg.writerPtr.length > 2) xdmaCfg.writerPtr.tail.tail.foreach(_ := 0.U(0.W))
    xdmaCfg.axiTransferBeatSize                            := axiTransferBeatSize
    xdmaCfg.aguCfg.ptr                                     := { if (readerSide) readerPtr else writerPtr(0) }
    xdmaCfg.aguCfg.spatialStrides(0)                       := spatialStride ## 0.U(
      log2Ceil(readerParam.crossClusterParam.wordlineWidth / 8).W
    )

    xdmaCfg.aguCfg.temporalStrides := temporalStrides
      .map(
        _ ## 0.U(log2Ceil(readerParam.crossClusterParam.wordlineWidth / 8).W)
      )
      .take(
        xdmaCfg.aguCfg.temporalStrides.length
      )

    xdmaCfg.aguCfg.temporalBounds := temporalBounds.take(
      xdmaCfg.aguCfg.temporalStrides.length
    )

    if (xdmaCfg.extCfg.length != 0)
      xdmaCfg.extCfg(0) := 0.U

    xdmaCfg.readerwriterCfg.enabledChannel := enabledChannel
    xdmaCfg.readerwriterCfg.enabledByte    := enabledByte
    xdmaCfg.origination                    := xdmaCfg.originationIsFromRemote.B
    xdmaCfg
  }
}

// Frame head 1:
//  isWriterSide: 1b
//  TotalFrames: 4b

// Frame head n (n > 1):
//  isWriterSide: 1b
//  Frame Index: 4b

//  taskID: 4b
//  readerPtr: 48b
//  writerPtr: 48b
//  Broadcast writerPtr: 48b
//  axiTransferBeatSize: 16b
//  spatialStride: 16b
//  temporalBounds: 16b * Dim
//  temporalStrides: 16b * Dim
//  enabledChannel: 8b
//  enabledByte: 8b

class XDMAInterClusterCfgIOSerializer(readerwriterParam: XDMAParam) extends Module {
  val io = IO(new Bundle {
    val cfgIn  = Flipped(Decoupled(new XDMAInterClusterCfgIO(readerwriterParam, readerwriterParam)))
    val cfgOut = Decoupled(UInt(readerwriterParam.axiParam.dataWidth.W))
  })

  // Serialize the entire cfg to one vector
  var cfgSerialized =
    io.cfgIn.bits.enabledByte ## io.cfgIn.bits.enabledChannel ## io.cfgIn.bits.temporalStrides.reverse.reduce(
      _ ## _
    ) ## io.cfgIn.bits.temporalBounds.reverse.reduce(
      _ ## _
    ) ## io.cfgIn.bits.spatialStride ## io.cfgIn.bits.axiTransferBeatSize ## io.cfgIn.bits.writerPtr(1) ## io.cfgIn.bits
      .writerPtr(0) ## io.cfgIn.bits.readerPtr ## io.cfgIn.bits.taskID

  val frameBodyLength = readerwriterParam.axiParam.dataWidth - 5
  val frameNum        = (cfgSerialized.getWidth + frameBodyLength - 1) / frameBodyLength

  // Pad the zero at the MSB of the CFG so that the data can be aligned to the AXI bus
  cfgSerialized = 0.U((frameBodyLength * frameNum - cfgSerialized.getWidth).W) ## cfgSerialized

  val frames = collection.mutable.Map[Int, UInt]()
  for (i <- 0 until frameNum) {
    frames(i) = cfgSerialized(
      i * frameBodyLength + frameBodyLength - 1,
      i * frameBodyLength
    )
  }

  // Append the frame head to each frame
  for (i <- 0 until frameNum) {
    val frameHead = Wire(UInt(5.W))
    if (i == 0) {
      frameHead := Cat(frameNum.U(4.W), io.cfgIn.bits.isWriterSide)
    } else {
      frameHead := Cat(i.U(4.W), io.cfgIn.bits.isWriterSide)
    }
    frames(i) = Cat(frames(i), frameHead)
  }

  // Use WidthConverter to convert the frames to one port
  val widthConverter = Module(
    new WidthDownConverter(chiselTypeOf(frames(0)), frameNum) {
      override def desiredName: String = "width_down_converter_W_" + frames(0).getWidth + "_D_" + frameNum
    }
  )
  widthConverter.io.in.valid := io.cfgIn.valid
  io.cfgIn.ready          := widthConverter.io.in.ready
  widthConverter.io.in.bits.zipWithIndex.foreach({ case (i, j) =>
    i := frames(j)
  })
  widthConverter.io.start := false.B
  io.cfgOut <> widthConverter.io.out
}

class XDMAInterClusterCfgIODeserializer(readerwriterParam: XDMAParam) extends Module {
  val io = IO(new Bundle {
    val cfgIn  = Flipped(Decoupled(UInt(readerwriterParam.axiParam.dataWidth.W)))
    val cfgOut = Decoupled(new XDMAInterClusterCfgIO(readerwriterParam, readerwriterParam))
  })

  val frameBodyLength = readerwriterParam.axiParam.dataWidth - 5
  val frameNum        = (io.cfgOut.bits.getWidth + frameBodyLength - 1) / frameBodyLength
  val frameBody       = RegInit(VecInit(Seq.fill(frameNum)(0.U(frameBodyLength.W))))

  val frameIndex   = RegInit(2.U(4.W))
  val frameCounter = Module(new BasicCounter(width = 4, hasCeil = true))

  val isWriterSide = RegInit(false.B)

  // The FSM to control multi-frame cfg transfer
  // States
  val sIdle :: sReceiveMoreFrames :: sSendCfg :: Nil = Enum(3)
  val nextState                                      = Wire(chiselTypeOf(sIdle))
  val currentState                                   = RegNext(nextState, sIdle)
  nextState := currentState

  // Default values
  // The counter's ceiling is the number of frames (only in the first frame)
  frameCounter.io.ceil  := frameIndex
  // The counter's synchronized reset signal should be triggered immediately after all the frames are received
  frameCounter.io.reset := currentState === sSendCfg
  frameCounter.io.tick  := false.B
  io.cfgIn.ready        := false.B
  io.cfgOut.valid       := false.B

  switch(currentState) {
    is(sIdle) {
      when(io.cfgIn.valid) {
        io.cfgIn.ready := true.B
        isWriterSide   := io.cfgIn.bits(0)
        frameBody(0)   := io.cfgIn.bits(readerwriterParam.axiParam.dataWidth - 1, 5)
        when(io.cfgIn.bits(4, 1) === 1.U) {
          // There is only one frame
          nextState := sSendCfg
        }.elsewhen(io.cfgIn.bits(4, 1) > 1.U) {
          frameIndex           := io.cfgIn.bits(4, 1)
          frameCounter.io.tick := true.B
          nextState            := sReceiveMoreFrames
        }
      }
    }
    is(sReceiveMoreFrames) {
      when(io.cfgIn.valid) {
        io.cfgIn.ready       := true.B
        frameCounter.io.tick := true.B
        // Tackle the case when the frame is more than cfg's maximum value
        when(frameCounter.io.value < frameNum.U) {
          frameBody(frameCounter.io.value) := io.cfgIn.bits(readerwriterParam.axiParam.dataWidth - 1, 5)
        }
        // Tackle the case when the frame is less than cfg's maximum value: the remaining frames are all 0 (Init in sSendCfg)
        when(frameCounter.io.lastVal) {
          nextState := sSendCfg
        }
      }
    }
    is(sSendCfg) {
      io.cfgOut.valid := true.B
      when(io.cfgOut.ready) {
        nextState := sIdle
        frameBody.foreach(_ := 0.U)
      }
    }
  }

  // The deserializer to convert the buffered frames to the output cfg
  var cfgSerialized = frameBody.reverse.reduce(_ ## _)
  io.cfgOut.bits.isWriterSide := isWriterSide

  // Assign task ID
  io.cfgOut.bits.taskID := cfgSerialized(3, 0)
  cfgSerialized = cfgSerialized(cfgSerialized.getWidth - 1, 4)
  // Assign the readerPtr
  io.cfgOut.bits.readerPtr := cfgSerialized(
    readerwriterParam.crossClusterParam.AxiAddressWidth - 1,
    0
  )
  cfgSerialized = cfgSerialized(
    cfgSerialized.getWidth - 1,
    readerwriterParam.crossClusterParam.AxiAddressWidth
  )

  // Assign the writerPtr
  io.cfgOut.bits.writerPtr.foreach { i =>
    i := cfgSerialized(
      readerwriterParam.crossClusterParam.AxiAddressWidth - 1,
      0
    )
    cfgSerialized = cfgSerialized(
      cfgSerialized.getWidth - 1,
      readerwriterParam.crossClusterParam.AxiAddressWidth
    )
  }

  // Assign axiTransferBeatSize
  io.cfgOut.bits.axiTransferBeatSize := cfgSerialized(
    readerwriterParam.crossClusterParam.tcdmAddressWidth - 1,
    0
  )
  cfgSerialized = cfgSerialized(
    cfgSerialized.getWidth - 1,
    readerwriterParam.crossClusterParam.tcdmAddressWidth
  )
  // Assign spatialStride
  io.cfgOut.bits.spatialStride := cfgSerialized(
    readerwriterParam.crossClusterParam.tcdmAddressWidth - 1,
    0
  )
  cfgSerialized = cfgSerialized(
    cfgSerialized.getWidth - 1,
    readerwriterParam.crossClusterParam.tcdmAddressWidth
  )
  // Assign temporalBounds
  io.cfgOut.bits.temporalBounds.foreach { i =>
    i := cfgSerialized(
      readerwriterParam.crossClusterParam.tcdmAddressWidth - 1,
      0
    )
    cfgSerialized = cfgSerialized(
      cfgSerialized.getWidth - 1,
      readerwriterParam.crossClusterParam.tcdmAddressWidth
    )
  }
  // Assign temporalStrides
  io.cfgOut.bits.temporalStrides.foreach { i =>
    i := cfgSerialized(
      readerwriterParam.crossClusterParam.tcdmAddressWidth - 1,
      0
    )
    cfgSerialized = cfgSerialized(
      cfgSerialized.getWidth - 1,
      readerwriterParam.crossClusterParam.tcdmAddressWidth
    )
  }
  // Assign enabledChannel
  io.cfgOut.bits.enabledChannel := cfgSerialized(
    readerwriterParam.crossClusterParam.channelNum - 1,
    0
  )
  cfgSerialized = cfgSerialized(
    cfgSerialized.getWidth - 1,
    readerwriterParam.crossClusterParam.channelNum
  )
  // Assign enabledByte
  io.cfgOut.bits.enabledByte := cfgSerialized(
    readerwriterParam.crossClusterParam.wordlineWidth / 8 - 1,
    0
  )
  cfgSerialized = cfgSerialized(
    cfgSerialized.getWidth - 1,
    readerwriterParam.crossClusterParam.wordlineWidth / 8
  )
}

class XDMADataPathCfgIO(axiParam: XDMAAXIParam, crossClusterParam: XDMACrossClusterParam) extends Bundle {
  val readyToTransfer       = Bool()
  val taskID                = UInt(4.W)
  val length                = UInt(crossClusterParam.tcdmAddressWidth.W)
  val taskType              = Bool()
  val taskTypeIsRemoteRead  = false
  val taskTypeIsRemoteWrite = true
  val isFirstChainedWrite   = Bool()
  val isLastChainedWrite    = Bool()
  val src                   = UInt(axiParam.addrWidth.W)
  val dst                   = UInt(axiParam.addrWidth.W)

  def convertFromXDMAIntraClusterCfgIO(
    cfg:            XDMAIntraClusterCfgIO,
    isChainedWrite: Boolean
  ): Unit = {
    taskID := cfg.taskID
    length := cfg.axiTransferBeatSize
    src    := {
      if (isChainedWrite)
        cfg.writerPtr(0)
      else cfg.readerPtr
    }
    dst    := {
      if (isChainedWrite)
        cfg.writerPtr(1)
      else cfg.writerPtr(0)
    }

    isFirstChainedWrite := taskType === taskTypeIsRemoteWrite.B && cfg.origination === cfg.originationIsFromLocal.B
    isLastChainedWrite := taskType === taskTypeIsRemoteWrite.B && cfg.origination === cfg.originationIsFromRemote.B && cfg.remoteLoopback === false.B
  }
}
