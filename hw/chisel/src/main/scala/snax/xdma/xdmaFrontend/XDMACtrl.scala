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

class XDMACrossClusterCfgIO(param: XDMAParam) extends Bundle {
  val readerPtr = UInt(param.crossClusterParam.AxiAddressWidth.W)
  val writerPtr = Vec(
    param.crossClusterParam.maxMulticastDest,
    UInt(param.crossClusterParam.AxiAddressWidth.W)
  )
  val spatialStride = UInt(param.crossClusterParam.maxLocalAddressWidth.W)

  val temporalBounds = Vec(
    param.crossClusterParam.maxDimension,
    UInt(param.crossClusterParam.maxLocalAddressWidth.W)
  )
  val temporalStrides = Vec(
    param.crossClusterParam.maxDimension,
    UInt(param.crossClusterParam.maxLocalAddressWidth.W)
  )
  val enabledChannel = UInt(param.crossClusterParam.channelNum.W)
  val enabledByte = UInt((param.crossClusterParam.wordlineWidth / 8).W)

  def convertFromXDMACfgIO(
      cfg: XDMACfgIO
  ): Unit = {
    readerPtr := cfg.readerPtr
    writerPtr := cfg.writerPtr
    spatialStride := cfg.aguCfg
      .spatialStrides(0)
      .apply(
        cfg.aguCfg.spatialStrides(0).getWidth - 1,
        log2Ceil(param.crossClusterParam.wordlineWidth / 8)
      )
    temporalStrides := cfg.aguCfg.temporalStrides.map(
      _.apply(
        cfg.aguCfg.temporalStrides(0).getWidth - 1,
        log2Ceil(param.crossClusterParam.wordlineWidth / 8)
      )
    ) ++ Seq.fill(
      temporalStrides.length - cfg.aguCfg.temporalStrides.length
    )(0.U)

    temporalBounds := cfg.aguCfg.temporalBounds.map(
      _.apply(
        cfg.aguCfg.temporalBounds(0).getWidth - 1,
        log2Ceil(param.crossClusterParam.wordlineWidth / 8)
      )
    ) ++ Seq.fill(
      temporalBounds.length - cfg.aguCfg.temporalBounds.length
    )(1.U)
    enabledChannel := cfg.readerwriterCfg.enabledChannel
    enabledByte := cfg.readerwriterCfg.enabledByte
  }

  def convertToXDMACfgIO(readerSide: Boolean): XDMACfgIO = {
    val xdmaCfg = Wire(new XDMACfgIO(param))
    xdmaCfg := 0.U.asTypeOf(xdmaCfg)
    xdmaCfg.readerPtr := readerPtr
    xdmaCfg.writerPtr := writerPtr
    xdmaCfg.aguCfg.ptr := { if (readerSide) readerPtr else writerPtr(0) }
    xdmaCfg.aguCfg.spatialStrides(0) := spatialStride ## 0.U(
      log2Ceil(param.crossClusterParam.wordlineWidth / 8).W
    )

    xdmaCfg.aguCfg.temporalStrides := temporalStrides
      .map(
        _ ## 0.U(log2Ceil(param.crossClusterParam.wordlineWidth / 8).W)
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
    ) ## spatialStride ## writerPtr.reverse.reduce(_ ## _) ## readerPtr
  def deserialize(data: UInt): UInt = {
    var remainingData = data
    readerPtr := remainingData(
      param.crossClusterParam.AxiAddressWidth - 1,
      0
    )
    remainingData = remainingData(
      remainingData.getWidth - 1,
      param.crossClusterParam.AxiAddressWidth
    )
    writerPtr.foreach { i =>
      i := remainingData(
        param.crossClusterParam.AxiAddressWidth - 1,
        0
      )
      remainingData = remainingData(
        remainingData.getWidth - 1,
        param.crossClusterParam.AxiAddressWidth
      )
    }
    spatialStride := remainingData(
      param.crossClusterParam.maxLocalAddressWidth - 1,
      0
    )
    remainingData = remainingData(
      remainingData.getWidth - 1,
      param.crossClusterParam.maxLocalAddressWidth
    )

    temporalBounds.foreach { i =>
      i := remainingData(
        param.crossClusterParam.maxLocalAddressWidth - 1,
        0
      )
      remainingData = remainingData(
        remainingData.getWidth - 1,
        param.crossClusterParam.maxLocalAddressWidth
      )
    }

    temporalStrides.foreach { i =>
      i := remainingData(
        param.crossClusterParam.maxLocalAddressWidth - 1,
        0
      )
      remainingData = remainingData(
        remainingData.getWidth - 1,
        param.crossClusterParam.maxLocalAddressWidth
      )
    }

    enabledChannel := remainingData(
      param.crossClusterParam.channelNum - 1,
      0
    )
    remainingData = remainingData(
      remainingData.getWidth - 1,
      param.crossClusterParam.channelNum
    )

    enabledByte := remainingData(
      param.crossClusterParam.wordlineWidth / 8 - 1,
      0
    )
    remainingData = remainingData(
      remainingData.getWidth - 1,
      param.crossClusterParam.wordlineWidth / 8
    )

    remainingData
  }
}

class XDMACtrlIO(readerParam: XDMAParam, writerParam: XDMAParam)
    extends Bundle {
  // clusterBaseAddress to determine if it is the local command or remote command
  val clusterBaseAddress = Input(
    UInt(writerParam.axiParam.addrWidth.W)
  )
  // Local DMADatapath control signal (Which is connected to DMADataPath)
  val localDMADataPath = new Bundle {
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
  val remoteDMADataPathCfg = new Bundle {
    val reader = new Bundle {
      val fromRemote = Flipped(
        Decoupled(UInt(readerParam.axiParam.dataWidth.W))
      )
      val toRemote = Decoupled(UInt(readerParam.axiParam.dataWidth.W))
    }
    val writer = new Bundle {
      val fromRemote = Flipped(
        Decoupled(UInt(writerParam.axiParam.dataWidth.W))
      )
      val toRemote = Decoupled(UInt(writerParam.axiParam.dataWidth.W))
    }
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

  val i_from_arbiter = Module(new Arbiter(dataType, 2) {
    override val desiredName =
      s"${clusterName}_xdma_ctrl_SrcConfigRouter_Arbiter"
  })
  i_from_arbiter.io.in(0) <> io.from.local
  i_from_arbiter.io.in(1) <> io.from.remote

  val i_to_demux = Module(
    new DemuxDecoupled(dataType = dataType, numOutput = 3) {
      override val desiredName =
        s"${clusterName}_xdma_ctrl_SrcConfigRouter_Demux"
    }
  )
  i_from_arbiter.io.out -|> i_to_demux.io.in

  // At the output of FIFO: Do the rule check
  val cTypeLocal :: cTypeRemote :: cTypeDiscard :: Nil = Enum(3)
  val cValue = Wire(chiselTypeOf(cTypeDiscard))

  when(
    i_to_demux.io.in.bits.readerPtr(
      i_to_demux.io.in.bits.readerPtr.getWidth - 1,
      i_to_demux.io.in.bits.aguCfg.ptr.getWidth
    ) === io
      .clusterBaseAddress(
        i_to_demux.io.in.bits.readerPtr.getWidth - 1,
        i_to_demux.io.in.bits.aguCfg.ptr.getWidth
      )
  ) {
    cValue := cTypeLocal // When cfg has the Ptr that fall within local TCDM, the data should be forwarded to the local ctrl path
  }.elsewhen(i_to_demux.io.in.bits.readerPtr === 0.U) {
    cValue := cTypeDiscard // When cfg has the Ptr that is zero, This means that the frame need to be thrown away. This is important as when the data is moved from DRAM to TCDM or vice versa, DRAM part is handled by iDMA, thus only one config instead of two is submitted
  }.otherwise {
    cValue := cTypeRemote // For the remaining condition, the config is forward to remote DMA
  }

  i_to_demux.io.sel := cValue
  // Port local is connected to the outside
  i_to_demux.io.out(cTypeLocal.litValue.toInt) <> io.to.local
  // Port remote is connected to the outside
  i_to_demux.io.out(cTypeRemote.litValue.toInt) <> io.to.remote
  // Port discard is not connected and will always be discarded
  i_to_demux.io.out(cTypeDiscard.litValue.toInt).ready := true.B
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

  val i_from_arbiter = Module(new Arbiter(dataType, 2) {
    override val desiredName =
      s"${clusterName}_xdma_ctrl_SrcConfigRouter_Arbiter"
  })
  i_from_arbiter.io.in(0) <> io.from.local
  i_from_arbiter.io.in(1) <> io.from.remote

  val i_to_demux = Module(
    new DemuxDecoupled(dataType = dataType, numOutput = 3) {
      override val desiredName =
        s"${clusterName}_xdma_ctrl_dstConfigRouter_Demux"
    }
  )
  i_from_arbiter.io.out -|> i_to_demux.io.in

  // At the output of cut: Do the rule check
  val cTypeLocal :: cTypeRemote :: cTypeDiscard :: Nil = Enum(3)
  val cValue = Wire(chiselTypeOf(cTypeDiscard))

  when(
    i_to_demux.io.in.bits
      .writerPtr(0)
      .apply(
        i_to_demux.io.in.bits.writerPtr(0).getWidth - 1,
        i_to_demux.io.in.bits.aguCfg.ptr.getWidth
      ) === io
      .clusterBaseAddress(
        i_to_demux.io.in.bits.writerPtr(0).getWidth - 1,
        i_to_demux.io.in.bits.aguCfg.ptr.getWidth
      )
  ) {
    cValue := cTypeLocal // When cfg has the Ptr that fall within local TCDM, the data should be forwarded to the local ctrl path
  }.elsewhen(i_to_demux.io.in.bits.readerPtr === 0.U) {
    cValue := cTypeDiscard // When cfg has the Ptr that is zero, This means that the frame need to be thrown away. This is important as when the data is moved from DRAM to TCDM or vice versa, DRAM part is handled by iDMA, thus only one config instead of two is submitted
  }.otherwise {
    cValue := cTypeRemote // For the remaining condition, the config is forward to remote DMA
  }

  i_to_demux.io.sel := cValue
  // Port local is connected to the outside
  i_to_demux.io.out(cTypeLocal.litValue.toInt) <> io.to.local
  // Port remote is connected to the outside
  i_to_demux.io.out(cTypeRemote.litValue.toInt) <> io.to.remote
  // Port discard is not connected and will always be discarded
  i_to_demux.io.out(cTypeDiscard.litValue.toInt).ready := true.B
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

  val i_csrmanager = Module(
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
      csrNumReadOnly = 2,
      // Set to two at current, 1) The number of submitted request; 2) The number of finished request. Since the reader path may be forward to remote, here I only count the writer branch
      csrAddrWidth = 32,
      // Set a name for the module class so that it will not overlapped with other csrManagers in user-defined accelerators
      csrModuleTagName = s"${clusterName}_xdma_"
    )
  )

  i_csrmanager.io.csr_config_in <> io.csrIO

  val preRoute_src_local = Wire(
    Decoupled(new XDMACfgIO(readerparam))
  )
  val preRoute_dst_local = Wire(
    Decoupled(new XDMACfgIO(writerparam))
  )
  var remainingCSR = i_csrmanager.io.csr_config_out.bits.toIndexedSeq

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
  i_csrmanager.io.csr_config_out.ready := preRoute_src_local.ready & preRoute_dst_local.ready
  preRoute_src_local.valid := i_csrmanager.io.csr_config_out.ready & i_csrmanager.io.csr_config_out.valid
  preRoute_dst_local.valid := i_csrmanager.io.csr_config_out.ready & i_csrmanager.io.csr_config_out.valid

  // Cfg Frame Routing at src side
  val preRoute_src_remote = Wire(
    Decoupled(new XDMACfgIO(readerparam))
  )

  preRoute_src_remote.bits := {
    // Serialized signal => Deserialized to intermediate structured signal => Converted to final structured signal
    val srcRemoteCfg = Wire(new XDMACrossClusterCfgIO(readerparam))
    srcRemoteCfg.deserialize(
      io.remoteDMADataPathCfg.reader.fromRemote.bits
    )
    srcRemoteCfg.convertToXDMACfgIO(readerSide = true)
  }
  preRoute_src_remote.valid := io.remoteDMADataPathCfg.reader.fromRemote.valid
  io.remoteDMADataPathCfg.reader.fromRemote.ready := preRoute_src_remote.ready

  // Command Router
  val i_srcCfgRouter = Module(
    new SrcConfigRouter(
      dataType = chiselTypeOf(preRoute_src_local.bits),
      clusterName = clusterName
    )
  )
  i_srcCfgRouter.io.clusterBaseAddress := io.clusterBaseAddress

  i_srcCfgRouter.io.from.local <> preRoute_src_local
  preRoute_src_remote <> i_srcCfgRouter.io.from.remote

  val postRoute_src_local = Wire(
    Decoupled(new XDMACfgIO(readerparam))
  )
  val postRoute_src_remote = Wire(
    Decoupled(new XDMACfgIO(readerparam))
  )
  i_srcCfgRouter.io.to.local <> postRoute_src_local
  i_srcCfgRouter.io.to.remote <> postRoute_src_remote

  // Connect Port 3 to AXI Mst
  io.remoteDMADataPathCfg.reader.toRemote.bits := {
    // Structured signal => Converted to crossClusterCfg => Serialized to final signal
    val srcRemoteCfg = Wire(new XDMACrossClusterCfgIO(readerparam))
    srcRemoteCfg.convertFromXDMACfgIO(postRoute_src_remote.bits)
    srcRemoteCfg.serialize
  }

  io.remoteDMADataPathCfg.reader.toRemote.valid := postRoute_src_remote.valid
  postRoute_src_remote.ready := io.remoteDMADataPathCfg.reader.toRemote.ready

  // Cfg Frame Routing at dst side
  val preRoute_dst_remote = Wire(
    Decoupled(new XDMACfgIO(writerparam))
  )
  preRoute_dst_remote.bits := {
    // Serialized signal => Deserialized to intermediate structured signal => Converted to final structured signal
    val dstRemoteCfg = Wire(new XDMACrossClusterCfgIO(writerparam))
    dstRemoteCfg.deserialize(
      io.remoteDMADataPathCfg.writer.fromRemote.bits
    )
    dstRemoteCfg.convertToXDMACfgIO(readerSide = false)
  }
  preRoute_dst_remote.valid := io.remoteDMADataPathCfg.writer.fromRemote.valid
  io.remoteDMADataPathCfg.writer.fromRemote.ready := preRoute_dst_remote.ready

  // Command Router
  val i_dstCfgRouter = Module(
    new DstConfigRouter(
      dataType = chiselTypeOf(preRoute_dst_local.bits),
      clusterName = clusterName
    )
  )
  i_dstCfgRouter.io.clusterBaseAddress := io.clusterBaseAddress

  i_dstCfgRouter.io.from.local <> preRoute_dst_local
  preRoute_dst_remote <> i_dstCfgRouter.io.from.remote

  val postRoute_dst_local = Wire(
    Decoupled(new XDMACfgIO(writerparam))
  )
  val postRoute_dst_remote = Wire(
    Decoupled(new XDMACfgIO(writerparam))
  )
  postRoute_dst_local <> i_dstCfgRouter.io.to.local
  postRoute_dst_remote <> i_dstCfgRouter.io.to.remote

  // Connect Port 3 to AXI Mst
  io.remoteDMADataPathCfg.writer.toRemote.bits := {
    // Structured signal => Converted to crossClusterCfg => Serialized to final signal
    val dstRemoteCfg = Wire(new XDMACrossClusterCfgIO(writerparam))
    dstRemoteCfg.convertFromXDMACfgIO(postRoute_dst_remote.bits)
    dstRemoteCfg.serialize
  }

  io.remoteDMADataPathCfg.writer.toRemote.valid := postRoute_dst_remote.valid
  postRoute_dst_remote.ready := io.remoteDMADataPathCfg.writer.toRemote.ready

  // Loopback / Non-loopback seperation for pseudo-OoO commit
  val i_src_LoopbackDemux = Module(
    new DemuxDecoupled(chiselTypeOf(postRoute_src_local.bits), numOutput = 2) {
      override val desiredName = s"${clusterName}_xdma_ctrl_src_LoopbackDemux"
    }
  )
  val i_dst_LoopbackDemux = Module(
    new DemuxDecoupled(chiselTypeOf(postRoute_dst_local.bits), numOutput = 2) {
      override val desiredName = s"${clusterName}_xdma_ctrl_dst_LoopbackDemux"
    }
  )

  // (1) is loopback; (0) is non-loopback
  i_src_LoopbackDemux.io.sel := postRoute_src_local.bits.loopBack
  i_dst_LoopbackDemux.io.sel := postRoute_dst_local.bits.loopBack
  i_src_LoopbackDemux.io.in <> postRoute_src_local
  i_dst_LoopbackDemux.io.in <> postRoute_dst_local

  val i_srcCfgArbiter = Module(
    new Arbiter(chiselTypeOf(postRoute_src_local.bits), 2) {
      override val desiredName = s"${clusterName}_xdma_ctrl_srcCfgArbiter"
    }
  )
  // Non-loopback has lower priority, so that it is connect to 1st port of arbiter
  // Optional FIFO for non-loopback cfg is added (depth = 2)
  i_src_LoopbackDemux.io.out(0) -||> i_srcCfgArbiter.io.in(1)
  // Loopback has higher priority, so that it is connect to 0th port of arbiter
  // Optional FIFO for loopback cfg is not added
  i_src_LoopbackDemux.io.out(1) <> i_srcCfgArbiter.io.in(0)

  val i_dstCfgArbiter = Module(
    new Arbiter(chiselTypeOf(postRoute_dst_local.bits), 2) {
      override val desiredName = s"${clusterName}_xdma_ctrl_dstCfgArbiter"
    }
  )
  // Non-loopback has lower priority, so that it is connect to 1st port of arbiter
  // Optional FIFO for non-loopback cfg is added (depth = 2)
  i_dst_LoopbackDemux.io.out(0) -||> i_dstCfgArbiter.io.in(1)
  // Loopback has higher priority, so that it is connect to 0th port of arbiter
  // Optional FIFO for loopback cfg is not added
  i_dst_LoopbackDemux.io.out(1) <> i_dstCfgArbiter.io.in(0)

  // Connect these two cfg to the actual input: Need two small (Mealy) FSMs to manage the start signal and pop out the consumed cfg
  val sIdle :: sWaitBusy :: sBusy :: Nil = Enum(3)

  sIdle.suggestName("sIdle")
  sWaitBusy.suggestName("sWaitBusy")
  sBusy.suggestName("sBusy")

  // Two registers to store the current state
  val current_state_src = RegInit(sIdle)
  val current_state_dst = RegInit(sIdle)

  // Two Data Cut to store the buffer the current cfg
  val current_cfg_src = Wire(chiselTypeOf(i_srcCfgArbiter.io.out))
  val current_cfg_dst = Wire(chiselTypeOf(i_dstCfgArbiter.io.out))
  i_srcCfgArbiter.io.out -|> current_cfg_src
  i_dstCfgArbiter.io.out -|> current_cfg_dst

  // Default value: Not pop out config, not start reader/writer, not change state
  io.localDMADataPath.readerStart := false.B
  io.localDMADataPath.writerStart := false.B
  current_cfg_src.ready := false.B
  current_cfg_dst.ready := false.B

  // Control signals in Src Path
  switch(current_state_src) {
    is(sIdle) {
      when(current_cfg_src.valid & (~io.localDMADataPath.readerBusy)) {
        current_state_src := sWaitBusy
        io.localDMADataPath.readerStart := true.B
      }
    }
    is(sWaitBusy) {
      when(io.localDMADataPath.readerBusy) {
        current_state_src := sBusy
      }
    }
    is(sBusy) {
      when(~io.localDMADataPath.readerBusy) {
        current_state_src := sIdle
        current_cfg_src.ready := true.B
      }
    }
  }

  // Control signals in Dst Path
  switch(current_state_dst) {
    is(sIdle) {
      when(current_cfg_dst.valid & (~io.localDMADataPath.writerBusy)) {
        current_state_dst := sWaitBusy
        io.localDMADataPath.writerStart := true.B
      }
    }
    is(sWaitBusy) {
      when(io.localDMADataPath.writerBusy) {
        current_state_dst := sBusy
      }
    }
    is(sBusy) {
      when(~io.localDMADataPath.writerBusy) {
        current_state_dst := sIdle
        current_cfg_dst.ready := true.B
      }
    }
  }

  // Data Signals in Src Path
  io.localDMADataPath.readerCfg := current_cfg_src.bits
  // Data Signals in Dst Path
  io.localDMADataPath.writerCfg := current_cfg_dst.bits

  // Counter for submitted cfg and finished cfg (With these two values, the control core knows which task is finished)
  val i_submittedTaskCounter = Module(new BasicCounter(32, hasCeil = false) {
    override val desiredName = s"${clusterName}_xdma_ctrl_submittedTaskCounter"
  })
  i_submittedTaskCounter.io.ceil := DontCare
  i_submittedTaskCounter.io.reset := false.B
  i_submittedTaskCounter.io.tick := i_csrmanager.io.csr_config_out.fire
  i_csrmanager.io.read_only_csr(0) := i_submittedTaskCounter.io.value

  val i_finishedTaskCounter = Module(new BasicCounter(32, hasCeil = false) {
    override val desiredName = s"${clusterName}_xdma_ctrl_finishedTaskCounter"
  })
  i_finishedTaskCounter.io.ceil := DontCare
  i_finishedTaskCounter.io.reset := false.B
  i_finishedTaskCounter.io.tick := (RegNext(
    io.localDMADataPath.writerBusy,
    init = false.B
  ) === true.B) && (io.localDMADataPath.writerBusy === false.B)
  i_csrmanager.io.read_only_csr(1) := i_finishedTaskCounter.io.value
}
