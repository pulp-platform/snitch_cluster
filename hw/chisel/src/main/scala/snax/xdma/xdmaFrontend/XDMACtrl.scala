package snax.xdma.xdmaFrontend

import chisel3._
import chisel3.util._

import snax.csr_manager._
import snax.utils.DecoupledCut._
import snax.utils.DemuxDecoupled
import snax.utils._
import snax.xdma.DesignParams.XDMAParam
import snax.xdma.xdmaIO.{XDMACfgIO, XDMAInterClusterCfgIO, XDMAIntraClusterCfgIO}

class XDMACtrlIO(readerParam: XDMAParam, writerParam: XDMAParam) extends Bundle {
  // clusterBaseAddress to determine if it is the local command or remote command
  val clusterBaseAddress = Input(
    UInt(writerParam.axiParam.addrWidth.W)
  )
  // Local DMADatapath control signal (Which is connected to DMADataPath)
  val localXDMACfg       = new Bundle {
    val readerCfg = Output(new XDMAIntraClusterCfgIO(readerParam))
    val writerCfg = Output(new XDMAIntraClusterCfgIO(writerParam))

    // Two start signal will inform the new cfg is available, trigger agu, and inform all extension that a stream is coming
    val readerStart = Output(Bool())
    val writerStart = Output(Bool())
    // Two busy signal only go down if a stream fully passthrough the reader / writter, which is provided by DataPath
    // These signals should be readable by the outside; these two will also be used to determine whether the next task can be executed.
    val readerBusy  = Input(Bool())
    val writerBusy  = Input(Bool())
  }
  // Remote control signal, which include the signal from other cluster or signal to other cluster. Both of them is AXI related, serialized signal
  // The remote control signal will contain only src information, in other words, the DMA system can proceed remote read or local read, but only local write
  val remoteXDMACfg      = new Bundle {
    val fromRemote = Flipped(Decoupled(UInt(readerParam.axiParam.dataWidth.W)))
    val toRemote   = Decoupled(UInt(readerParam.axiParam.dataWidth.W))
  }
  // This is the port for CSR Manager to SNAX port
  val csrIO              = new SnaxCsrIO(csrAddrWidth = 32)

  // The external port to indicate the finish of one task
  val remoteTaskFinished = Input(Bool())
}

class SrcConfigRouter(dataType: XDMACfgIO, clusterName: String = "unnamed_cluster")
    extends Module
    with RequireAsyncReset {

  override val desiredName = s"${clusterName}_xdma_ctrl_srcConfigRouter"

  val io = IO(new Bundle {
    val clusterBaseAddress = Input(UInt(dataType.readerPtr.getWidth.W))
    val from               = Flipped(new Bundle {
      val remote = Decoupled(dataType)
      val local  = Decoupled(dataType)
    })
    val to                 = new Bundle {
      val remote = Decoupled(dataType)
      val local  = Decoupled(dataType)
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
  val cValue                                           = Wire(chiselTypeOf(cTypeDiscard))

  when(
    outputCfgDemux.io.in.bits.readerPtr(
      outputCfgDemux.io.in.bits.readerPtr.getWidth - 1,
      log2Ceil(outputCfgDemux.io.in.bits.param.rwParam.tcdmParam.tcdmSize) + 10
    ) === io
      .clusterBaseAddress(
        outputCfgDemux.io.in.bits.readerPtr.getWidth - 1,
        log2Ceil(
          outputCfgDemux.io.in.bits.param.rwParam.tcdmParam.tcdmSize
        ) + 10
      )
  ) {
    cValue := cTypeLocal // When cfg has the Ptr that fall within local TCDM, the data should be forwarded to the local ctrl path
  }.elsewhen(outputCfgDemux.io.in.bits.readerPtr === 0.U) {
    cValue := cTypeDiscard // When cfg has the Ptr that is zero, This means that the frame need to be thrown away. This is important as when the data is moved from DRAM to TCDM or vice versa, DRAM part is handled by iDMA, thus only one config instead of two is submitted
  }.otherwise {
    cValue := cTypeRemote // For the remaining condition, the config is forward to remote DMA
  }

  outputCfgDemux.io.sel                                    := cValue
  // Port local is connected to the outside
  outputCfgDemux.io.out(cTypeLocal.litValue.toInt) <> io.to.local
  // Port remote is connected to the outside
  outputCfgDemux.io.out(cTypeRemote.litValue.toInt) <> io.to.remote
  // Port discard is not connected and will always be discarded
  outputCfgDemux.io.out(cTypeDiscard.litValue.toInt).ready := true.B
}

class DstConfigRouter(dataType: XDMACfgIO, clusterName: String = "unnamed_cluster")
    extends Module
    with RequireAsyncReset {

  override val desiredName = s"${clusterName}_xdma_ctrl_dstConfigRouter"

  val io = IO(new Bundle {
    val clusterBaseAddress = Input(UInt(dataType.writerPtr(0).getWidth.W))
    val from               = Flipped(new Bundle {
      val remote = Decoupled(dataType)
      val local  = Decoupled(dataType)
    })
    val to                 = new Bundle {
      val remote = Decoupled(dataType)
      val local  = Decoupled(dataType)
    }
  })

  val inputCfgArbiter = Module(new Arbiter(dataType, 2) {
    override val desiredName =
      s"${clusterName}_xdma_ctrl_SrcConfigRouter_Arbiter"
  })
  inputCfgArbiter.io.in(0) <> io.from.local
  inputCfgArbiter.io.in(1) <> io.from.remote

  val bufferedCfg = Wire(chiselTypeOf(inputCfgArbiter.io.out))
  inputCfgArbiter.io.out -|> bufferedCfg

  // At the output of cut: Do the rule check
  val forwardToLocal  = {
    bufferedCfg.bits
      .writerPtr(0)
      .apply(
        bufferedCfg.bits.writerPtr(0).getWidth - 1,
        log2Ceil(bufferedCfg.bits.param.rwParam.tcdmParam.tcdmSize) + 10
      ) === io
      .clusterBaseAddress(
        bufferedCfg.bits.writerPtr(0).getWidth - 1,
        log2Ceil(bufferedCfg.bits.param.rwParam.tcdmParam.tcdmSize) + 10
      )
  }
  val isChainedWrite  = if (bufferedCfg.bits.writerPtr.length > 1) {
    bufferedCfg.bits.writerPtr(
      1
    ) =/= 0.U && bufferedCfg.bits.origination === bufferedCfg.bits.originationIsFromRemote.B
  } else false.B
  val forwardToRemote =
    (~forwardToLocal | isChainedWrite) && bufferedCfg.bits.writerPtr(0) =/= 0.U

  val outputCfgSplitter = Module(
    new SplitterDecoupled(
      dataType  = chiselTypeOf(bufferedCfg.bits),
      numOutput = 2
    ) {
      override val desiredName =
        s"${clusterName}_xdma_ctrl_DstConfigRouter_Splitter"
    }
  )
  outputCfgSplitter.io.in <> bufferedCfg

  outputCfgSplitter.io.sel(0) := forwardToLocal
  outputCfgSplitter.io.sel(1) := forwardToRemote
  outputCfgSplitter.io.out(0) <> io.to.local
  outputCfgSplitter.io.out(1) <> io.to.remote

  when(isChainedWrite) {
    io.to.remote.bits.readerPtr      := bufferedCfg.bits.writerPtr(0)
    io.to.remote.bits.writerPtr
      .zip(bufferedCfg.bits.writerPtr.tail)
      .foreach { case (a, b) =>
        a := b
      }
    io.to.remote.bits.writerPtr.last := 0.U
  }
}

class XDMACtrl(readerparam: XDMAParam, writerparam: XDMAParam, clusterName: String = "unnamed_cluster")
    extends Module
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
      csrNumReadWrite  = numCSRPerPtr + // Reader Pointer needs numCSRPerPtr CSRs
        readerparam.crossClusterParam.maxSpatialDimension +      // Spatial Strides for reader
        readerparam.crossClusterParam.maxTemporalDimension * 2 + // Temporal Strides + Bounds for reader
        {
          if (readerparam.rwParam.configurableChannel) 1 else 0
        } +                                                      // Enabled Channel for reader
        0 + // Enabled Byte for reader: non-effective, so donot assign CSR
        {
          if (readerparam.extParam.length == 0) 0
          else
            readerparam.extParam.map { i => i.extensionParam.userCsrNum }
              .reduce(_ + _) + 1
        } + // The total num of param on reader extension (custom CSR + bypass CSR)
        numCSRPerPtr * writerparam.crossClusterParam.maxMulticastDest + // Writer Pointer needs numCSRPerPtr * maxMulticastDest CSRs
        writerparam.crossClusterParam.maxSpatialDimension +      // Spatial Strides for writer
        writerparam.crossClusterParam.maxTemporalDimension * 2 + // Temporal Strides + Bounds for writer
        {
          if (writerparam.rwParam.configurableChannel) 1 else 0
        } +                                                      // Enabled Channel for writer
        {
          if (writerparam.rwParam.configurableByteMask) 1 else 0
        } +                                                      // Enabled Byte for writer
        {
          if (writerparam.extParam.length == 0) 0
          else
            writerparam.extParam.map { i => i.extensionParam.userCsrNum }
              .reduce(_ + _) + 1
        } + // The total num of param on writer (custom CSR + bypass CSR)
        1, // The start CSR
      csrNumReadOnly   = 4,
      // Set to four at current, 1) The number of submitted local request; 2) The number of submitted remote request; 3) The number of finished local request; 4) The number of finished remote request
      csrAddrWidth     = 32,
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
  var remainingCSR       = csrManager.io.csr_config_out.bits.toIndexedSeq

  // Connect readerPtr + writerPtr with the CSR list
  preRoute_src_local.bits.connectPtrWithList(remainingCSR)
  preRoute_dst_local.bits.connectPtrWithList(remainingCSR)
  val nextSrcPtrCSR = remainingCSR.take(numCSRPerPtr)
  val nextDstPtrCSR = remainingCSR.drop(numCSRPerPtr).take(numCSRPerPtr)

  // Drop readerPtr + writerPtr from the CSR list
  remainingCSR = preRoute_src_local.bits.dropPtrFromList(remainingCSR)

  // Connect reader + writer + ext to the structured signal: Src side
  remainingCSR = preRoute_src_local.bits.connectWithList(nextSrcPtrCSR ++ remainingCSR)

  // Connect reader + writer + ext to the structured signal: Dst side
  remainingCSR = preRoute_dst_local.bits.connectWithList(nextDstPtrCSR ++ remainingCSR)

  if (remainingCSR.length > 1)
    println("There is some error in CSR -> Structured CFG assigning")

  // LocalLoopback: The loopback indicator to enable the reader's data directly sending back to the writer
  // Connect the loopBack signal: The loopBack signal is generated by comparing the Ptr of two side

  val localLoopback =
    preRoute_dst_local.bits.readerPtr(
      preRoute_dst_local.bits.readerPtr.getWidth - 1,
      log2Ceil(preRoute_dst_local.bits.param.rwParam.tcdmParam.tcdmSize) + 10
    ) === preRoute_dst_local.bits
      .writerPtr(0)
      .apply(
        preRoute_dst_local.bits.writerPtr(0).getWidth - 1,
        log2Ceil(preRoute_dst_local.bits.param.rwParam.tcdmParam.tcdmSize) + 10
      )
  preRoute_src_local.bits.localLoopback := localLoopback
  preRoute_dst_local.bits.localLoopback := localLoopback

  // RemoteLoopback: The loopback indicator to enable fromRemoteData directly sending back to toRemoteData
  // Connect the loopBack signal: currently, the remoteLoopback signal is always set to false; it will be judgen after the cfgRouter
  preRoute_src_local.bits.remoteLoopback := false.B
  preRoute_dst_local.bits.remoteLoopback := false.B

  // Connect Valid and bits: Only when both preRoutes are ready, postRulecheck is ready
  csrManager.io.csr_config_out.ready := preRoute_src_local.ready & preRoute_dst_local.ready
  preRoute_src_local.valid           := csrManager.io.csr_config_out.ready & csrManager.io.csr_config_out.valid
  preRoute_dst_local.valid           := csrManager.io.csr_config_out.ready & csrManager.io.csr_config_out.valid

  // Task ID Counter to assign the ID for each transaction
  val localSubmittedTaskIDCounter = Module(
    new BasicCounter(
      width   = 8,
      hasCeil = false
    ) {
      override val desiredName = s"${clusterName}_xdmaCtrl_localTaskIDCounter"
    }
  )
  localSubmittedTaskIDCounter.io.ceil := DontCare
  localSubmittedTaskIDCounter.io.tick  := localLoopback && csrManager.io.csr_config_out.fire
  localSubmittedTaskIDCounter.io.reset := false.B

  val remoteSubmittedTaskIDCounter = Module(
    new BasicCounter(
      width   = 8,
      hasCeil = false
    ) {
      override val desiredName = s"${clusterName}_xdmaCtrl_remoteTaskIDCounter"
    }
  )
  remoteSubmittedTaskIDCounter.io.ceil := DontCare
  remoteSubmittedTaskIDCounter.io.tick  := (~localLoopback) && csrManager.io.csr_config_out.fire
  remoteSubmittedTaskIDCounter.io.reset := false.B

  csrManager.io.read_only_csr(0) := localSubmittedTaskIDCounter.io.value
  csrManager.io.read_only_csr(1) := remoteSubmittedTaskIDCounter.io.value

  // Connect the task ID to the structured signal
  val taskID = Mux(
    localLoopback,
    localSubmittedTaskIDCounter.io.value,
    remoteSubmittedTaskIDCounter.io.value
  ) + 1.U
  preRoute_src_local.bits.taskID := taskID
  preRoute_dst_local.bits.taskID := taskID

  // Cfg from remote side
  val cfgFromRemote = Wire(
    Decoupled(new XDMAInterClusterCfgIO(readerparam, writerparam))
  )
  cfgFromRemote.bits.deserialize(io.remoteXDMACfg.fromRemote.bits)
  cfgFromRemote.valid               := io.remoteXDMACfg.fromRemote.valid
  io.remoteXDMACfg.fromRemote.ready := cfgFromRemote.ready

  // Demux the cfg from the cfg_in port
  val cfgFromRemoteDemux = Module(
    new DemuxDecoupled(
      dataType  = chiselTypeOf(cfgFromRemote.bits),
      numOutput = 2
    ) {
      override val desiredName = s"${clusterName}_xdma_ctrl_remoteCfgDemux"
    }
  )

  cfgFromRemoteDemux.io.in <> cfgFromRemote
  cfgFromRemoteDemux.io.sel := cfgFromRemote.bits.isWriterSide

  // Cfg to remote side
  val cfgToRemote = Wire(
    Decoupled(new XDMAInterClusterCfgIO(readerparam, writerparam))
  )
  io.remoteXDMACfg.toRemote.bits  := cfgToRemote.bits.serialize
  io.remoteXDMACfg.toRemote.valid := cfgToRemote.valid
  cfgToRemote.ready               := io.remoteXDMACfg.toRemote.ready

  // Mux+Arbitrator the Cfg to cfg_out port
  val cfgToRemoteMux = Module(
    new Arbiter(
      gen = chiselTypeOf(cfgToRemote.bits),
      n   = 2
    ) {
      override val desiredName = s"${clusterName}_xdma_ctrl_remoteCfgMux"
    }
  )

  cfgToRemoteMux.io.out <> cfgToRemote
  // Arbitration is done by Arbiter, no sel signal is needed

  // Command Router
  val srcCfgRouter = Module(
    new SrcConfigRouter(
      dataType    = chiselTypeOf(preRoute_src_local.bits),
      clusterName = clusterName
    )
  )
  srcCfgRouter.io.clusterBaseAddress := io.clusterBaseAddress

  srcCfgRouter.io.from.local <> preRoute_src_local
  srcCfgRouter.io.from.remote.valid  := cfgFromRemoteDemux.io.out(0).valid
  srcCfgRouter.io.from.remote.bits   := cfgFromRemoteDemux.io
    .out(0)
    .bits
    .convertToXDMACfgIO(readerSide = true)
  cfgFromRemoteDemux.io.out(0).ready := srcCfgRouter.io.from.remote.ready

  val postRoute_src_local  = Wire(
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
    val srcRemoteCfg = Wire(new XDMAInterClusterCfgIO(readerparam, writerparam))
    srcRemoteCfg.convertFromXDMACfgIO(
      writerSide = false,
      cfg        = postRoute_src_remote.bits
    )
    srcRemoteCfg
  }

  cfgToRemoteMux.io.in(1).valid := postRoute_src_remote.valid
  postRoute_src_remote.ready    := cfgToRemoteMux.io.in(1).ready

  // Command Router
  val dstCfgRouter = Module(
    new DstConfigRouter(
      dataType    = chiselTypeOf(preRoute_dst_local.bits),
      clusterName = clusterName
    )
  )
  dstCfgRouter.io.clusterBaseAddress := io.clusterBaseAddress

  dstCfgRouter.io.from.local <> preRoute_dst_local
  dstCfgRouter.io.from.remote.valid  := cfgFromRemoteDemux.io.out(1).valid
  dstCfgRouter.io.from.remote.bits   := cfgFromRemoteDemux.io
    .out(1)
    .bits
    .convertToXDMACfgIO(readerSide = false)
  cfgFromRemoteDemux.io.out(1).ready := dstCfgRouter.io.from.remote.ready

  val postRoute_dst_local  = Wire(
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
    val dstRemoteCfg = Wire(new XDMAInterClusterCfgIO(readerparam, writerparam))
    dstRemoteCfg.convertFromXDMACfgIO(
      writerSide = true,
      cfg        = postRoute_dst_remote.bits
    )
    dstRemoteCfg
  }

  cfgToRemoteMux.io.in(0).valid := postRoute_dst_remote.valid
  postRoute_dst_remote.ready    := cfgToRemoteMux.io.in(0).ready

  // Judge remoteLoopback signal
  postRoute_src_local.bits.remoteLoopback := false.B
  postRoute_dst_local.bits.remoteLoopback := {
    if (writerparam.crossClusterParam.maxMulticastDest == 1)
      false.B
    else
      postRoute_dst_local.bits.writerPtr(
        1
      ) =/= 0.U
  }

  // Connect these two cfg to the actual input: Need two small (Mealy) FSMs to manage the start signal and pop out the consumed cfg
  val sIdle :: sWaitBusy :: sBusy :: Nil = Enum(3)

  sIdle.suggestName("sIdle")
  sWaitBusy.suggestName("sWaitBusy")
  sBusy.suggestName("sBusy")

  // Two registers to store the current state
  val nextStateSrc    = Wire(chiselTypeOf(sIdle))
  val nextStateDst    = Wire(chiselTypeOf(sIdle))
  dontTouch(nextStateSrc)
  dontTouch(nextStateDst)
  val currentStateSrc = RegNext(nextStateSrc, sIdle)
  val currentStateDst = RegNext(nextStateDst, sIdle)

  // Two Data Cut to store the buffer the current cfg
  val currentCfgSrc = Wire(chiselTypeOf(postRoute_src_local))
  val currentCfgDst = Wire(chiselTypeOf(postRoute_dst_local))
  postRoute_src_local -|> currentCfgSrc
  postRoute_dst_local -|> currentCfgDst

  // Default value: Not pop out config, not start reader/writer, not change state
  io.localXDMACfg.readerStart := false.B
  io.localXDMACfg.writerStart := false.B
  currentCfgSrc.ready         := false.B
  currentCfgDst.ready         := false.B
  nextStateSrc                := currentStateSrc
  nextStateDst                := currentStateDst

  // Control signals in Src Path
  switch(currentStateSrc) {
    is(sIdle) {
      when {
        // Cfg at source side is valid, Reader is not busy, the Writer's current / next cfg is not Chained Write
        currentCfgSrc.valid && (~(currentCfgDst.valid && currentCfgDst.bits.remoteLoopback)) && (
          // The local loopback condition: The next cfg at the writer side is its counterpart
          (currentCfgSrc.bits.localLoopback && currentCfgSrc.bits.readerPtr === currentCfgDst.bits.readerPtr && currentCfgSrc.bits
            .writerPtr(0) === currentCfgDst.bits.writerPtr(0)) ||
            // The remote read condition: All loopback is false
            (currentCfgSrc.bits.localLoopback === false.B && currentCfgSrc.bits.remoteLoopback === false.B)
        )
      } {
        // Start the reader side
        nextStateSrc                := sWaitBusy
        io.localXDMACfg.readerStart := true.B
      }
    }
    is(sWaitBusy) {
      when(io.localXDMACfg.readerBusy) {
        nextStateSrc := sBusy
      }
    }
    is(sBusy) {
      when(~io.localXDMACfg.readerBusy) {
        nextStateSrc        := sIdle
        currentCfgSrc.ready := true.B
      }
    }
  }

  // Control signals in Dst Path
  switch(currentStateDst) {
    is(sIdle) {
      when {
        // Cfg at destination side is valid, Writer is not busy
        currentCfgDst.valid && (
          // The local loopback condition: The next cfg at the writer side is its counterpart
          (currentCfgDst.bits.localLoopback && currentCfgSrc.bits.readerPtr === currentCfgDst.bits.readerPtr && currentCfgSrc.bits
            .writerPtr(0) === currentCfgDst.bits.writerPtr(0)) ||
            // The remote write condition: All loopback is false
            (currentCfgDst.bits.localLoopback === false.B && currentCfgDst.bits.remoteLoopback === false.B) ||
            // The remote chained write condition: The remote loopback is true and the next state of the counterpart is sIdle
            (currentCfgDst.bits.remoteLoopback === true.B && currentStateSrc === sIdle)
        )
      } {
        // Start the reader side
        nextStateDst                := sWaitBusy
        io.localXDMACfg.writerStart := true.B
      }
    }
    is(sWaitBusy) {
      when(io.localXDMACfg.writerBusy) {
        nextStateDst := sBusy
      }
    }
    is(sBusy) {
      when(~io.localXDMACfg.writerBusy) {
        nextStateDst        := sIdle
        currentCfgDst.ready := true.B
      }
    }
  }

  // Data Signals in Src Path
  io.localXDMACfg.readerCfg.convertFromXDMACfgIO(currentCfgSrc.bits)
  // Data Signals in Dst Path
  io.localXDMACfg.writerCfg.convertFromXDMACfgIO(currentCfgDst.bits)

  // Counter for finished task
  val localFinishedTaskIDCounter = Module(new BasicCounter(8, hasCeil = false) {
    override val desiredName =
      s"${clusterName}_xdma_ctrl_localFinishedTaskCounter"
  })
  localFinishedTaskIDCounter.io.ceil := DontCare
  localFinishedTaskIDCounter.io.reset := false.B
  localFinishedTaskIDCounter.io.tick  := currentCfgDst.fire && currentCfgDst.bits.localLoopback

  val remoteFinishedTaskIDCounter = Module(
    new BasicCounter(8, hasCeil = false) {
      override val desiredName =
        s"${clusterName}_xdma_ctrl_remoteFinishedTaskCounter"
    }
  )
  remoteFinishedTaskIDCounter.io.ceil := DontCare
  remoteFinishedTaskIDCounter.io.reset := false.B
  remoteFinishedTaskIDCounter.io.tick  := io.remoteTaskFinished

  // Connect the finished task counter to the read-only CSR
  csrManager.io.read_only_csr(2) := localFinishedTaskIDCounter.io.value
  csrManager.io.read_only_csr(3) := remoteFinishedTaskIDCounter.io.value
}
