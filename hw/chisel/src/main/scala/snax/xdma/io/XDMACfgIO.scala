package snax.xdma.io

import chisel3._
import chisel3.util._

import snax.readerWriter.AddressGenUnitCfgIO
import snax.readerWriter.AddressGenUnitParam
import snax.readerWriter.ReaderWriterCfgIO
import snax.xdma.DesignParams._

// The sturctured class that used to store the CFG of reader and writer, connected with the CSR
// The full address (readerPtr, writerPtr) is included in this class, for the purpose of cross-cluster communication
// The truncated version of address is assigned to aguCfg for the generation of local address which will be consumed by TCDM
// Loopback signal is also included in this class, for the purpose of early judgement
// Also the extension cfg is included in this class
class XDMACfgIO(val param: XDMAParam) extends Bundle {
  val taskID = UInt(8.W)

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
  val taskID = UInt(8.W)

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
  val taskID        = UInt(8.W)
  val isWriterSide  = Bool()
  val readerPtr     = UInt(readerParam.crossClusterParam.AxiAddressWidth.W)
  val writerPtr     = Vec(
    readerParam.crossClusterParam.maxMulticastDest,
    UInt(readerParam.crossClusterParam.AxiAddressWidth.W)
  )
  val spatialStride = UInt(readerParam.crossClusterParam.tcdmAddressWidth.W)

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
    taskID          := cfg.taskID
    isWriterSide    := writerSide.B
    readerPtr       := cfg.readerPtr
    writerPtr       := cfg.writerPtr
    spatialStride   := cfg.aguCfg
      .spatialStrides(0)
      .apply(
        cfg.aguCfg.spatialStrides(0).getWidth - 1,
        log2Ceil(readerParam.crossClusterParam.wordlineWidth / 8)
      )
    temporalStrides := cfg.aguCfg.temporalStrides.map(
      _.apply(
        cfg.aguCfg.temporalStrides(0).getWidth - 1,
        log2Ceil(readerParam.crossClusterParam.wordlineWidth / 8)
      )
    )
    temporalBounds  := cfg.aguCfg.temporalBounds
    enabledChannel  := cfg.readerwriterCfg.enabledChannel
    enabledByte     := cfg.readerwriterCfg.enabledByte
  }

  def convertToXDMACfgIO(readerSide: Boolean): XDMACfgIO = {
    val xdmaCfg = if (readerSide) { Wire(new XDMACfgIO(readerParam)) }
    else { Wire(new XDMACfgIO(writerParam)) }

    xdmaCfg                          := 0.U.asTypeOf(xdmaCfg)
    xdmaCfg.taskID                   := taskID
    xdmaCfg.readerPtr                := readerPtr
    xdmaCfg.writerPtr                := writerPtr
    xdmaCfg.aguCfg.ptr               := { if (readerSide) readerPtr else writerPtr(0) }
    xdmaCfg.aguCfg.spatialStrides(0) := spatialStride ## 0.U(
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
      xdmaCfg.extCfg(0) := BigInt("ffffffff", 16).U

    xdmaCfg.readerwriterCfg.enabledChannel := enabledChannel
    xdmaCfg.readerwriterCfg.enabledByte    := enabledByte
    xdmaCfg.origination                    := xdmaCfg.originationIsFromRemote.B
    xdmaCfg
  }

  def serialize: UInt =
    enabledByte ## enabledChannel ## temporalStrides.reverse.reduce(
      _ ## _
    ) ## temporalBounds.reverse.reduce(
      _ ## _
    ) ## spatialStride ## writerPtr.reverse.reduce(
      _ ## _
    ) ## readerPtr ## isWriterSide.asUInt ## taskID

  def deserialize(data: UInt): Unit = {
    var remainingData = data
    taskID := remainingData(
      taskID.getWidth - 1,
      0
    )
    remainingData = remainingData(remainingData.getWidth - 1, taskID.getWidth)
    isWriterSide := remainingData(0)
    remainingData = remainingData(remainingData.getWidth - 1, 1)
    readerPtr := remainingData(
      readerParam.crossClusterParam.AxiAddressWidth - 1,
      0
    )
    remainingData = remainingData(
      remainingData.getWidth - 1,
      readerParam.crossClusterParam.AxiAddressWidth
    )
    writerPtr.foreach { i =>
      i := remainingData(
        readerParam.crossClusterParam.AxiAddressWidth - 1,
        0
      )
      remainingData = remainingData(
        remainingData.getWidth - 1,
        readerParam.crossClusterParam.AxiAddressWidth
      )
    }
    spatialStride := remainingData(
      readerParam.crossClusterParam.tcdmAddressWidth - 1,
      0
    )
    remainingData = remainingData(
      remainingData.getWidth - 1,
      readerParam.crossClusterParam.tcdmAddressWidth
    )

    temporalBounds.foreach { i =>
      i := remainingData(
        readerParam.crossClusterParam.tcdmAddressWidth - 1,
        0
      )
      remainingData = remainingData(
        remainingData.getWidth - 1,
        readerParam.crossClusterParam.tcdmAddressWidth
      )
    }

    temporalStrides.foreach { i =>
      i := remainingData(
        readerParam.crossClusterParam.tcdmAddressWidth - 1,
        0
      )
      remainingData = remainingData(
        remainingData.getWidth - 1,
        readerParam.crossClusterParam.tcdmAddressWidth
      )
    }

    enabledChannel := remainingData(
      readerParam.crossClusterParam.channelNum - 1,
      0
    )
    remainingData = remainingData(
      remainingData.getWidth - 1,
      readerParam.crossClusterParam.channelNum
    )

    enabledByte := remainingData(
      readerParam.crossClusterParam.wordlineWidth / 8 - 1,
      0
    )
  }
}

class XDMADataPathCfgIO(axiParam: AXIParam, crossClusterParam: CrossClusterParam) extends Bundle {
  val readyToTransfer       = Bool()
  val taskID                = UInt(8.W)
  val length                = UInt(crossClusterParam.tcdmAddressWidth.W)
  val taskType              = Bool()
  val taskTypeIsRemoteRead  = false
  val taskTypeIsRemoteWrite = true
  val src                   = UInt(axiParam.addrWidth.W)
  val dst                   = UInt(axiParam.addrWidth.W)

  def convertFromXDMAIntraClusterCfgIO(
    cfg:            XDMAIntraClusterCfgIO,
    isChainedWrite: Boolean
  ): Unit = {
    taskID := cfg.taskID
    length := cfg.aguCfg.temporalBounds.reduceTree { case (a, b) =>
      (a * b).apply(length.getWidth - 1, 0)
    }
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
  }
}
