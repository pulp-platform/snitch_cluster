package snax.xdma.xdmaFrontend

import chisel3._
import chisel3.util._

import snax.utils._
import snax.utils.DecoupledCut._
import snax.utils.BitsConcat._
import snax.utils.DemuxDecoupled

import snax.readerWriter.{AddressGenUnitCfgIO, Reader, Writer}

import snax.csr_manager._

import snax.xdma.DesignParams.{XDMADataPathParam, XDMAParam}

// The sturctured class that used to store the CFG of reader and writer
// The full address is included in this class, for the purpose of cross-cluster communication
// Loopback signal is also included in this class, for the purpose of early judgement
// Also the extension cfg is included in this class
class XDMACfgIO(param: XDMAParam) extends XDMADataPathCfgIO(param: XDMAParam) {
  val taskID = UInt(8.W)
  val readerPtr = UInt(param.axiParam.addrWidth.W)
  // val writerPtr = UInt(param.axiParam.addrWidth.W)
  val writerPtr =
    Vec(
      param.crossClusterParam.maxMulticastDest,
      UInt(param.axiParam.addrWidth.W)
    )

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
    writerPtr.foreach { i =>
      remainingCSR = remainingCSR.drop(numCSRPerPtr)
    }
    remainingCSR
  }

  // Connect the remaining CFG with the CSR list
  override def connectWithList(
      csrList: IndexedSeq[UInt]
  ): IndexedSeq[UInt] = {
    var remainingCSR = csrList
    remainingCSR = super.connectWithList(remainingCSR)
    remainingCSR
  }
}

class XDMACrossClusterCfgIO(readerParam: XDMAParam, writerParam: XDMAParam)
    extends Bundle {
  val taskID = UInt(8.W)
  val isReaderSide = Bool()
  val readerPtr = UInt(readerParam.crossClusterParam.AxiAddressWidth.W)
  val writerPtr = Vec(
    readerParam.crossClusterParam.maxMulticastDest,
    UInt(readerParam.crossClusterParam.AxiAddressWidth.W)
  )
  val spatialStride = UInt(readerParam.crossClusterParam.maxLocalAddressWidth.W)

  val temporalBounds = Vec(
    readerParam.crossClusterParam.maxDimension,
    UInt(readerParam.crossClusterParam.maxLocalAddressWidth.W)
  )
  val temporalStrides = Vec(
    readerParam.crossClusterParam.maxDimension,
    UInt(readerParam.crossClusterParam.maxLocalAddressWidth.W)
  )
  val enabledChannel = UInt(readerParam.crossClusterParam.channelNum.W)
  val enabledByte = UInt((readerParam.crossClusterParam.wordlineWidth / 8).W)

  def convertFromXDMACfgIO(
      readerSide: Boolean,
      cfg: XDMACfgIO
  ): Unit = {
    taskID := cfg.taskID
    isReaderSide := readerSide.B
    readerPtr := cfg.readerPtr
    writerPtr := cfg.writerPtr
    spatialStride := cfg.aguCfg
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
    ) ++ Seq.fill(
      temporalStrides.length - cfg.aguCfg.temporalStrides.length
    )(0.U)

    temporalBounds := cfg.aguCfg.temporalBounds ++ Seq.fill(
      temporalBounds.length - cfg.aguCfg.temporalBounds.length
    )(1.U)
    enabledChannel := cfg.readerwriterCfg.enabledChannel
    enabledByte := cfg.readerwriterCfg.enabledByte
  }

  def convertToXDMACfgIO(readerSide: Boolean): XDMACfgIO = {
    val xdmaCfg = if (readerSide) { Wire(new XDMACfgIO(readerParam)) }
    else { Wire(new XDMACfgIO(writerParam)) }

    xdmaCfg := 0.U.asTypeOf(xdmaCfg)
    xdmaCfg.taskID := taskID
    xdmaCfg.readerPtr := readerPtr
    xdmaCfg.writerPtr := writerPtr
    xdmaCfg.aguCfg.ptr := { if (readerSide) readerPtr else writerPtr(0) }
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
    xdmaCfg.readerwriterCfg.enabledByte := enabledByte
    xdmaCfg
  }

  def serialize: UInt =
    enabledByte ## enabledChannel ## temporalStrides.reverse.reduce(
      _ ## _
    ) ## temporalBounds.reverse.reduce(
      _ ## _
    ) ## spatialStride ## writerPtr.reverse.reduce(
      _ ## _
    ) ## readerPtr ## isReaderSide.asUInt ## taskID

  def deserialize(data: UInt): Unit = {
    var remainingData = data
    taskID := remainingData(
      taskID.getWidth - 1,
      0
    )
    remainingData = remainingData(remainingData.getWidth - 1, taskID.getWidth)
    isReaderSide := remainingData(0)
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
      readerParam.crossClusterParam.maxLocalAddressWidth - 1,
      0
    )
    remainingData = remainingData(
      remainingData.getWidth - 1,
      readerParam.crossClusterParam.maxLocalAddressWidth
    )

    temporalBounds.foreach { i =>
      i := remainingData(
        readerParam.crossClusterParam.maxLocalAddressWidth - 1,
        0
      )
      remainingData = remainingData(
        remainingData.getWidth - 1,
        readerParam.crossClusterParam.maxLocalAddressWidth
      )
    }

    temporalStrides.foreach { i =>
      i := remainingData(
        readerParam.crossClusterParam.maxLocalAddressWidth - 1,
        0
      )
      remainingData = remainingData(
        remainingData.getWidth - 1,
        readerParam.crossClusterParam.maxLocalAddressWidth
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

class XDMACtrlIO(readerParam: XDMAParam, writerParam: XDMAParam)
    extends Bundle {
  // clusterBaseAddress to determine if it is the local command or remote command
  val clusterBaseAddress = Input(
    UInt(writerParam.axiParam.addrWidth.W)
  )
  // Local DMADatapath control signal (Which is connected to DMADataPath)
  val localXDMACfg = new Bundle {
    val readerCfg = Output(new XDMADataPathCfgIO(readerParam))
    val writerCfg = Output(new XDMADataPathCfgIO(writerParam))

    // Two start signal will inform the new cfg is available, trigger agu, and inform all extension that a stream is coming
    val readerStart = Output(Bool())
    val writerStart = Output(Bool())
    // Two busy signal only go down if a stream fully passthrough the reader / writter, which is provided by DataPath
    // These signals should be readable by the outside; these two will also be used to determine whether the next task can be executed.
    val readerBusy = Input(Bool())
    val writerBusy = Input(Bool())
  }
  // Remote control signal, which include the signal from other cluster or signal to other cluster. Both of them is AXI related, serialized signal
  // The remote control signal will contain only src information, in other words, the DMA system can proceed remote read or local read, but only local write
  val remoteXDMACfg = new Bundle {
    val fromRemote = Flipped(Decoupled(UInt(readerParam.axiParam.dataWidth.W)))
    val toRemote = Decoupled(UInt(readerParam.axiParam.dataWidth.W))
  }
  // This is the port for CSR Manager to SNAX port
  val csrIO = new SnaxCsrIO(csrAddrWidth = 32)
}

class SrcConfigRouter(
    dataType: XDMACfgIO,
    clusterName: String = "unnamed_cluster"
) extends Module
    with RequireAsyncReset {

  override val desiredName = s"${clusterName}_xdma_ctrl_srcConfigRouter"

  val io = IO(new Bundle {
    val clusterBaseAddress = Input(UInt(dataType.readerPtr.getWidth.W))
    val from = Flipped(new Bundle {
      val remote = Decoupled(dataType)
      val local = Decoupled(dataType)
    })
    val to = new Bundle {
      val remote = Decoupled(dataType)
      val local = Decoupled(dataType)
    }
  })

  val inputCfgArbiter = Module(new Arbiter(dataType, 2) {
    override val desiredName =
      s"${clusterName}_xdma_ctrl_SrcConfigRouter_Arbiter"
  })
  inputCfgArbiter.io.in(0) <> io.from.local
  inputCfgArbiter.io.in(1) <> io.from.remote

  val outputCfgDemux = Module(
    new DemuxDecoupled(dataType = dataType, numOutput = 3) {
      override val desiredName =
        s"${clusterName}_xdma_ctrl_SrcConfigRouter_Demux"
    }
  )
  inputCfgArbiter.io.out -|> outputCfgDemux.io.in

  // At the output of FIFO: Do the rule check
  val cTypeLocal :: cTypeRemote :: cTypeDiscard :: Nil = Enum(3)
  val cValue = Wire(chiselTypeOf(cTypeDiscard))

  when(
    outputCfgDemux.io.in.bits.readerPtr(
      outputCfgDemux.io.in.bits.readerPtr.getWidth - 1,
      outputCfgDemux.io.in.bits.aguCfg.ptr.getWidth
    ) === io
      .clusterBaseAddress(
        outputCfgDemux.io.in.bits.readerPtr.getWidth - 1,
        outputCfgDemux.io.in.bits.aguCfg.ptr.getWidth
      )
  ) {
    cValue := cTypeLocal // When cfg has the Ptr that fall within local TCDM, the data should be forwarded to the local ctrl path
  }.elsewhen(outputCfgDemux.io.in.bits.readerPtr === 0.U) {
    cValue := cTypeDiscard // When cfg has the Ptr that is zero, This means that the frame need to be thrown away. This is important as when the data is moved from DRAM to TCDM or vice versa, DRAM part is handled by iDMA, thus only one config instead of two is submitted
  }.otherwise {
    cValue := cTypeRemote // For the remaining condition, the config is forward to remote DMA
  }

  outputCfgDemux.io.sel := cValue
  // Port local is connected to the outside
  outputCfgDemux.io.out(cTypeLocal.litValue.toInt) <> io.to.local
  // Port remote is connected to the outside
  outputCfgDemux.io.out(cTypeRemote.litValue.toInt) <> io.to.remote
  // Port discard is not connected and will always be discarded
  outputCfgDemux.io.out(cTypeDiscard.litValue.toInt).ready := true.B
}

class DstConfigRouter(
    dataType: XDMACfgIO,
    clusterName: String = "unnamed_cluster"
) extends Module
    with RequireAsyncReset {

  override val desiredName = s"${clusterName}_xdma_ctrl_dstConfigRouter"

  val io = IO(new Bundle {
    val clusterBaseAddress = Input(UInt(dataType.writerPtr(0).getWidth.W))
    val from = Flipped(new Bundle {
      val remote = Decoupled(dataType)
      val local = Decoupled(dataType)
    })
    val to = new Bundle {
      val remote = Decoupled(dataType)
      val local = Decoupled(dataType)
    }
  })

  val inputCfgArbiter = Module(new Arbiter(dataType, 2) {
    override val desiredName =
      s"${clusterName}_xdma_ctrl_SrcConfigRouter_Arbiter"
  })
  inputCfgArbiter.io.in(0) <> io.from.local
  inputCfgArbiter.io.in(1) <> io.from.remote

  val outputCfgDemux = Module(
    new DemuxDecoupled(dataType = dataType, numOutput = 3) {
      override val desiredName =
        s"${clusterName}_xdma_ctrl_dstConfigRouter_Demux"
    }
  )
  inputCfgArbiter.io.out -|> outputCfgDemux.io.in

  // At the output of cut: Do the rule check
  val cTypeLocal :: cTypeRemote :: cTypeDiscard :: Nil = Enum(3)
  val cValue = Wire(chiselTypeOf(cTypeDiscard))

  when(
    outputCfgDemux.io.in.bits
      .writerPtr(0)
      .apply(
        outputCfgDemux.io.in.bits.writerPtr(0).getWidth - 1,
        outputCfgDemux.io.in.bits.aguCfg.ptr.getWidth
      ) === io
      .clusterBaseAddress(
        outputCfgDemux.io.in.bits.writerPtr(0).getWidth - 1,
        outputCfgDemux.io.in.bits.aguCfg.ptr.getWidth
      )
  ) {
    cValue := cTypeLocal // When cfg has the Ptr that fall within local TCDM, the data should be forwarded to the local ctrl path
  }.elsewhen(outputCfgDemux.io.in.bits.readerPtr === 0.U) {
    cValue := cTypeDiscard // When cfg has the Ptr that is zero, This means that the frame need to be thrown away. This is important as when the data is moved from DRAM to TCDM or vice versa, DRAM part is handled by iDMA, thus only one config instead of two is submitted
  }.otherwise {
    cValue := cTypeRemote // For the remaining condition, the config is forward to remote DMA
  }

  outputCfgDemux.io.sel := cValue
  // Port local is connected to the outside
  outputCfgDemux.io.out(cTypeLocal.litValue.toInt) <> io.to.local
  // Port remote is connected to the outside
  outputCfgDemux.io.out(cTypeRemote.litValue.toInt) <> io.to.remote
  // Port discard is not connected and will always be discarded
  outputCfgDemux.io.out(cTypeDiscard.litValue.toInt).ready := true.B
}

class XDMACtrl(
    readerparam: XDMAParam,
    writerparam: XDMAParam,
    clusterName: String = "unnamed_cluster"
) extends Module
    with RequireAsyncReset {
  val io = IO(
    new XDMACtrlIO(
      readerParam = readerparam,
      writerParam = writerparam
    )
  )

  override val desiredName = s"${clusterName}_xdma_ctrl"

  val numCSRPerPtr = (writerparam.axiParam.addrWidth + 31) / 32

  val csrManager = Module(
    new CsrManager(
      csrNumReadWrite = numCSRPerPtr + // Reader Pointer needs numCSRPerPtr CSRs
        readerparam.rwParam.aguParam.spatialBounds.length + // Spatiaial Strides for reader
        readerparam.rwParam.aguParam.temporalDimension * 2 + // Temporal Strides + Bounds for reader
        {
          if (readerparam.rwParam.configurableChannel) 1 else 0
        } + // Enabled Channel for reader
        0 + // Enabled Byte for reader: non-effective, so donot assign CSR
        {
          if (readerparam.extParam.length == 0) 0
          else
            readerparam.extParam
              .map { i => i.extensionParam.userCsrNum }
              .reduce(_ + _) + 1
        } + // The total num of param on reader extension (custom CSR + bypass CSR)
        numCSRPerPtr * writerparam.crossClusterParam.maxMulticastDest + // Writer Pointer needs numCSRPerPtr * maxMulticastDest CSRs
        writerparam.rwParam.aguParam.spatialBounds.length + // Spatiaial Strides for writer
        writerparam.rwParam.aguParam.temporalDimension * 2 + // Strides + Bounds for writer
        {
          if (writerparam.rwParam.configurableChannel) 1 else 0
        } + // Enabled Channel for writer
        {
          if (writerparam.rwParam.configurableByteMask) 1 else 0
        } + // Enabled Byte for writer
        {
          if (writerparam.extParam.length == 0) 0
          else
            writerparam.extParam
              .map { i => i.extensionParam.userCsrNum }
              .reduce(_ + _) + 1
        } + // The total num of param on writer (custom CSR + bypass CSR)
        1, // The start CSR
      csrNumReadOnly = 4,
      // Set to four at current, 1) The number of submitted local request; 2) The number of submitted remote request; 3) The number of finished local request; 4) The number of finished remote request
      csrAddrWidth = 32,
      // Set a name for the module class so that it will not overlapped with other csrManagers in user-defined accelerators
      csrModuleTagName = s"${clusterName}_xdma_"
    )
  )

  csrManager.io.csr_config_in <> io.csrIO

  // Cfg from local side
  val preRoute_src_local = Wire(
    Decoupled(new XDMACfgIO(readerparam))
  )
  val preRoute_dst_local = Wire(
    Decoupled(new XDMACfgIO(writerparam))
  )
  var remainingCSR = csrManager.io.csr_config_out.bits.toIndexedSeq

  // Connect readerPtr + writerPtr with the CSR list
  preRoute_src_local.bits.connectPtrWithList(remainingCSR)
  preRoute_dst_local.bits.connectPtrWithList(remainingCSR)
  val nextSrcPtrCSR = remainingCSR.take(numCSRPerPtr)
  val nextDstPtrCSR = remainingCSR.drop(numCSRPerPtr).take(numCSRPerPtr)

  // Drop readerPtr + writerPtr from the CSR list
  remainingCSR = preRoute_src_local.bits.dropPtrFromList(remainingCSR)

  // Connect reader + writer + ext to the structured signal: Src side
  remainingCSR =
    preRoute_src_local.bits.connectWithList(nextSrcPtrCSR ++ remainingCSR)

  // Connect reader + writer + ext to the structured signal: Dst side
  remainingCSR =
    preRoute_dst_local.bits.connectWithList(nextDstPtrCSR ++ remainingCSR)

  if (remainingCSR.length > 1)
    println("There is some error in CSR -> Structured CFG assigning")

  // Connect the loopBack signal: The loopBack signal is generated by comparing the Ptr of two side

  val loopBack =
    preRoute_dst_local.bits.readerPtr(
      preRoute_dst_local.bits.readerPtr.getWidth - 1,
      preRoute_dst_local.bits.aguCfg.ptr.getWidth
    ) === preRoute_dst_local.bits
      .writerPtr(0)
      .apply(
        preRoute_dst_local.bits.writerPtr(0).getWidth - 1,
        preRoute_dst_local.bits.aguCfg.ptr.getWidth
      )
  preRoute_src_local.bits.loopBack := loopBack
  preRoute_dst_local.bits.loopBack := loopBack

  // Connect Valid and bits: Only when both preRoutes are ready, postRulecheck is ready
  csrManager.io.csr_config_out.ready := preRoute_src_local.ready & preRoute_dst_local.ready
  preRoute_src_local.valid := csrManager.io.csr_config_out.ready & csrManager.io.csr_config_out.valid
  preRoute_dst_local.valid := csrManager.io.csr_config_out.ready & csrManager.io.csr_config_out.valid

  // Task ID Counter to assign the ID for each transaction
  val localSubmittedTaskIDCounter = Module(
    new BasicCounter(
      width = 8,
      hasCeil = false
    ) {
      override val desiredName = s"${clusterName}_xdmaCtrl_localTaskIDCounter"
    }
  )
  localSubmittedTaskIDCounter.io.ceil := DontCare
  localSubmittedTaskIDCounter.io.tick := loopBack && csrManager.io.csr_config_out.fire
  localSubmittedTaskIDCounter.io.reset := false.B

  val remoteSubmittedTaskIDCounter = Module(
    new BasicCounter(
      width = 8,
      hasCeil = false
    ) {
      override val desiredName = s"${clusterName}_xdmaCtrl_remoteTaskIDCounter"
    }
  )
  remoteSubmittedTaskIDCounter.io.ceil := DontCare
  remoteSubmittedTaskIDCounter.io.tick := (~loopBack) && csrManager.io.csr_config_out.fire
  remoteSubmittedTaskIDCounter.io.reset := false.B

  csrManager.io.read_only_csr(0) := localSubmittedTaskIDCounter.io.value
  csrManager.io.read_only_csr(1) := remoteSubmittedTaskIDCounter.io.value

  // Connect the task ID to the structured signal
  val taskID = Mux(
    loopBack,
    localSubmittedTaskIDCounter.io.value,
    remoteSubmittedTaskIDCounter.io.value
  ) + 1.U
  preRoute_src_local.bits.taskID := taskID
  preRoute_dst_local.bits.taskID := taskID

  // Cfg from remote side
  val cfgFromRemote = Wire(
    Decoupled(new XDMACrossClusterCfgIO(readerparam, writerparam))
  )
  cfgFromRemote.bits.deserialize(io.remoteXDMACfg.fromRemote.bits)
  cfgFromRemote.valid := io.remoteXDMACfg.fromRemote.valid
  io.remoteXDMACfg.fromRemote.ready := cfgFromRemote.ready

  // Demux the cfg from the cfg_in port
  val cfgFromRemoteDemux = Module(
    new DemuxDecoupled(
      dataType = chiselTypeOf(cfgFromRemote.bits),
      numOutput = 2
    ) {
      override val desiredName = s"${clusterName}_xdma_ctrl_remoteCfgDemux"
    }
  )

  cfgFromRemoteDemux.io.in <> cfgFromRemote
  cfgFromRemoteDemux.io.sel := cfgFromRemote.bits.isReaderSide

  // Cfg to remote side
  val cfgToRemote = Wire(
    Decoupled(new XDMACrossClusterCfgIO(readerparam, writerparam))
  )
  io.remoteXDMACfg.toRemote.bits := cfgToRemote.bits.serialize
  io.remoteXDMACfg.toRemote.valid := cfgToRemote.valid
  cfgToRemote.ready := io.remoteXDMACfg.toRemote.ready

  // Mux+Arbitrator the Cfg to cfg_out port
  val cfgToRemoteMux = Module(
    new Arbiter(
      gen = chiselTypeOf(cfgToRemote.bits),
      n = 2
    ) {
      override val desiredName = s"${clusterName}_xdma_ctrl_remoteCfgMux"
    }
  )

  cfgToRemoteMux.io.out <> cfgToRemote
  // Arbitration is done by Arbiter, no sel signal is needed

  // Command Router
  val srcCfgRouter = Module(
    new SrcConfigRouter(
      dataType = chiselTypeOf(preRoute_src_local.bits),
      clusterName = clusterName
    )
  )
  srcCfgRouter.io.clusterBaseAddress := io.clusterBaseAddress

  srcCfgRouter.io.from.local <> preRoute_src_local
  srcCfgRouter.io.from.remote.valid := cfgFromRemoteDemux.io.out(1).valid
  srcCfgRouter.io.from.remote.bits := cfgFromRemoteDemux.io
    .out(1)
    .bits
    .convertToXDMACfgIO(readerSide = true)
  cfgFromRemoteDemux.io.out(1).ready := srcCfgRouter.io.from.remote.ready

  val postRoute_src_local = Wire(
    Decoupled(new XDMACfgIO(readerparam))
  )
  val postRoute_src_remote = Wire(
    Decoupled(new XDMACfgIO(readerparam))
  )
  srcCfgRouter.io.to.local <> postRoute_src_local
  srcCfgRouter.io.to.remote <> postRoute_src_remote

  // Connect Port 3 to remoteCfgMux to send to the remote side
  cfgToRemoteMux.io.in(1).bits := {
    // Structured signal => Converted to crossClusterCfg => Serialized to final signal
    val srcRemoteCfg = Wire(new XDMACrossClusterCfgIO(readerparam, writerparam))
    srcRemoteCfg.convertFromXDMACfgIO(
      readerSide = true,
      cfg = postRoute_src_remote.bits
    )
    srcRemoteCfg
  }

  cfgToRemoteMux.io.in(1).valid := postRoute_src_remote.valid
  postRoute_src_remote.ready := cfgToRemoteMux.io.in(1).ready

  // Command Router
  val dstCfgRouter = Module(
    new DstConfigRouter(
      dataType = chiselTypeOf(preRoute_dst_local.bits),
      clusterName = clusterName
    )
  )
  dstCfgRouter.io.clusterBaseAddress := io.clusterBaseAddress

  dstCfgRouter.io.from.local <> preRoute_dst_local
  dstCfgRouter.io.from.remote.valid := cfgFromRemoteDemux.io.out(0).valid
  dstCfgRouter.io.from.remote.bits := cfgFromRemoteDemux.io
    .out(0)
    .bits
    .convertToXDMACfgIO(readerSide = false)
  cfgFromRemoteDemux.io.out(0).ready := dstCfgRouter.io.from.remote.ready

  val postRoute_dst_local = Wire(
    Decoupled(new XDMACfgIO(writerparam))
  )
  val postRoute_dst_remote = Wire(
    Decoupled(new XDMACfgIO(writerparam))
  )
  postRoute_dst_local <> dstCfgRouter.io.to.local
  postRoute_dst_remote <> dstCfgRouter.io.to.remote

  // Connect Port 3 to remoteCfgMux to send to the remote side
  cfgToRemoteMux.io.in(0).bits := {
    // Structured signal => Converted to crossClusterCfg => Serialized to final signal
    val dstRemoteCfg = Wire(new XDMACrossClusterCfgIO(readerparam, writerparam))
    dstRemoteCfg.convertFromXDMACfgIO(
      readerSide = false,
      cfg = postRoute_dst_remote.bits
    )
    dstRemoteCfg
  }

  cfgToRemoteMux.io.in(0).valid := postRoute_dst_remote.valid
  postRoute_dst_remote.ready := cfgToRemoteMux.io.in(0).ready

  // Loopback / Non-loopback seperation for pseudo-OoO commit
  val srcLoopbackDemux = Module(
    new DemuxDecoupled(chiselTypeOf(postRoute_src_local.bits), numOutput = 2) {
      override val desiredName = s"${clusterName}_xdma_ctrl_src_LoopbackDemux"
    }
  )
  val dstLoopbackDemux = Module(
    new DemuxDecoupled(chiselTypeOf(postRoute_dst_local.bits), numOutput = 2) {
      override val desiredName = s"${clusterName}_xdma_ctrl_dst_LoopbackDemux"
    }
  )

  // (1) is loopback; (0) is non-loopback
  srcLoopbackDemux.io.sel := postRoute_src_local.bits.loopBack
  dstLoopbackDemux.io.sel := postRoute_dst_local.bits.loopBack
  srcLoopbackDemux.io.in <> postRoute_src_local
  dstLoopbackDemux.io.in <> postRoute_dst_local

  val srcCfgArbiter = Module(
    new Arbiter(chiselTypeOf(postRoute_src_local.bits), 2) {
      override val desiredName = s"${clusterName}_xdma_ctrl_srcCfgArbiter"
    }
  )
  // Non-loopback has lower priority, so that it is connect to 1st port of arbiter
  // Optional FIFO for non-loopback cfg is added (depth = 2)
  srcLoopbackDemux.io.out(0) -||> srcCfgArbiter.io.in(1)
  // Loopback has higher priority, so that it is connect to 0th port of arbiter
  // Optional FIFO for loopback cfg is not added
  srcLoopbackDemux.io.out(1) <> srcCfgArbiter.io.in(0)

  val dstCfgArbiter = Module(
    new Arbiter(chiselTypeOf(postRoute_dst_local.bits), 2) {
      override val desiredName = s"${clusterName}_xdma_ctrl_dstCfgArbiter"
    }
  )
  // Non-loopback has lower priority, so that it is connect to 1st port of arbiter
  // Optional FIFO for non-loopback cfg is added (depth = 2)
  dstLoopbackDemux.io.out(0) -||> dstCfgArbiter.io.in(1)
  // Loopback has higher priority, so that it is connect to 0th port of arbiter
  // Optional FIFO for loopback cfg is not added
  dstLoopbackDemux.io.out(1) <> dstCfgArbiter.io.in(0)

  // Connect these two cfg to the actual input: Need two small (Mealy) FSMs to manage the start signal and pop out the consumed cfg
  val sIdle :: sWaitBusy :: sBusy :: Nil = Enum(3)

  sIdle.suggestName("sIdle")
  sWaitBusy.suggestName("sWaitBusy")
  sBusy.suggestName("sBusy")

  // Two registers to store the current state
  val current_state_src = RegInit(sIdle)
  val current_state_dst = RegInit(sIdle)

  // Two Data Cut to store the buffer the current cfg
  val current_cfg_src = Wire(chiselTypeOf(srcCfgArbiter.io.out))
  val current_cfg_dst = Wire(chiselTypeOf(dstCfgArbiter.io.out))
  srcCfgArbiter.io.out -|> current_cfg_src
  dstCfgArbiter.io.out -|> current_cfg_dst

  // Default value: Not pop out config, not start reader/writer, not change state
  io.localXDMACfg.readerStart := false.B
  io.localXDMACfg.writerStart := false.B
  current_cfg_src.ready := false.B
  current_cfg_dst.ready := false.B

  // Control signals in Src Path
  switch(current_state_src) {
    is(sIdle) {
      when(current_cfg_src.valid & (~io.localXDMACfg.readerBusy)) {
        current_state_src := sWaitBusy
        io.localXDMACfg.readerStart := true.B
      }
    }
    is(sWaitBusy) {
      when(io.localXDMACfg.readerBusy) {
        current_state_src := sBusy
      }
    }
    is(sBusy) {
      when(~io.localXDMACfg.readerBusy) {
        current_state_src := sIdle
        current_cfg_src.ready := true.B
      }
    }
  }

  // Control signals in Dst Path
  switch(current_state_dst) {
    is(sIdle) {
      when(current_cfg_dst.valid & (~io.localXDMACfg.writerBusy)) {
        current_state_dst := sWaitBusy
        io.localXDMACfg.writerStart := true.B
      }
    }
    is(sWaitBusy) {
      when(io.localXDMACfg.writerBusy) {
        current_state_dst := sBusy
      }
    }
    is(sBusy) {
      when(~io.localXDMACfg.writerBusy) {
        current_state_dst := sIdle
        current_cfg_dst.ready := true.B
      }
    }
  }

  // Data Signals in Src Path
  io.localXDMACfg.readerCfg := current_cfg_src.bits
  // Data Signals in Dst Path
  io.localXDMACfg.writerCfg := current_cfg_dst.bits

  // Counter for finished task
  val localFinishedTaskCounter = Module(new BasicCounter(8, hasCeil = false) {
    override val desiredName =
      s"${clusterName}_xdma_ctrl_localFinishedTaskCounter"
  })
  localFinishedTaskCounter.io.ceil := DontCare
  localFinishedTaskCounter.io.reset := false.B
  localFinishedTaskCounter.io.tick := current_cfg_dst.fire && current_cfg_dst.bits.loopBack

  val remoteFinishedTaskCounter = Module(new BasicCounter(8, hasCeil = false) {
    override val desiredName =
      s"${clusterName}_xdma_ctrl_remoteFinishedTaskCounter"
  })
  remoteFinishedTaskCounter.io.ceil := DontCare
  remoteFinishedTaskCounter.io.reset := false.B
  remoteFinishedTaskCounter.io.tick := io.remoteXDMACfg.toRemote.fire

  // Connect the finished task counter to the read-only CSR
  csrManager.io.read_only_csr(2) := localFinishedTaskCounter.io.value
  csrManager.io.read_only_csr(3) := remoteFinishedTaskCounter.io.value
}
