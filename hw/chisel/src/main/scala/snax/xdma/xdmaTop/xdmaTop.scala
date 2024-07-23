package snax.xdma.xdmaTop

import chisel3._
import chisel3.util._

import snax.csr_manager._
import snax.utils._

import snax.xdma.xdmaFrontend._
import snax.xdma.xdmaExtension._
import snax.xdma.DesignParams._
import os.write

class xdmaTopIO(
    readerparam: DMADataPathParam,
    writerparam: DMADataPathParam,
    axiWidth: Int = 512,
    csrAddrWidth: Int = 32
) extends Bundle {
  val clusterBaseAddress = Input(
    UInt(readerparam.rwParam.agu_param.addressWidth.W)
  )
  val csrIO = new SnaxCsrIO(csrAddrWidth)

  val remoteDMADataPathCfg = new Bundle {
    val fromRemote = Flipped(Decoupled(UInt(axiWidth.W)))
    val toRemote = Decoupled(UInt(axiWidth.W))
  }
  val tcdm_reader = new Bundle {
    val req = Vec(
      readerparam.rwParam.tcdm_param.numChannel,
      Decoupled(
        new TcdmReq(
          readerparam.rwParam.tcdm_param.addrWidth,
          readerparam.rwParam.tcdm_param.dataWidth
        )
      )
    )
    val rsp = Vec(
      readerparam.rwParam.tcdm_param.numChannel,
      Flipped(
        Valid(
          new TcdmRsp(tcdmDataWidth = readerparam.rwParam.tcdm_param.dataWidth)
        )
      )
    )
  }
  val tcdm_writer = new Bundle {
    val req = Vec(
      writerparam.rwParam.tcdm_param.numChannel,
      Decoupled(
        new TcdmReq(
          writerparam.rwParam.tcdm_param.addrWidth,
          writerparam.rwParam.tcdm_param.dataWidth
        )
      )
    )
  }

  val remoteDMADataPath = new Bundle {
    val fromRemote = Flipped(
      Decoupled(
        UInt(
          (writerparam.rwParam.tcdm_param.dataWidth * writerparam.rwParam.tcdm_param.numChannel).W
        )
      )
    )
    val toRemote = Decoupled(
      UInt(
        (writerparam.rwParam.tcdm_param.dataWidth * writerparam.rwParam.tcdm_param.numChannel).W
      )
    )
  }
}

class xdmaTop(
    readerparam: DMADataPathParam,
    writerparam: DMADataPathParam,
    axiWidth: Int = 512,
    csrAddrWidth: Int = 32,
    clusterName: String = "unnamed_cluster"
) extends Module
    with RequireAsyncReset {
  override val desiredName = s"${clusterName}_xdma"
  val io = IO(
    new xdmaTopIO(
      readerparam = readerparam,
      writerparam = writerparam,
      axiWidth = axiWidth,
      csrAddrWidth = csrAddrWidth
    )
  )

  val i_dmactrl = Module(
    new DMACtrl(
      clusterName = clusterName,
      readerparam = readerparam,
      writerparam = writerparam,
      axiWidth = axiWidth,
      csrAddrWidth = csrAddrWidth
    )
  )

  val i_dmadatapath = Module(
    new DMADataPath(
      clusterName = clusterName,
      readerparam = readerparam,
      writerparam = writerparam
    )
  )

  // Give the dmactrl the current cluster address
  i_dmactrl.io.clusterBaseAddress := io.clusterBaseAddress

  // IO0: Start to connect datapath to TCDM
  io.tcdm_reader <> i_dmadatapath.io.tcdm_reader
  io.tcdm_writer <> i_dmadatapath.io.tcdm_writer

  // IO1: Start to connect datapath to axi
  io.remoteDMADataPath.fromRemote <> i_dmadatapath.io.remoteDMADataPath.fromRemote
  io.remoteDMADataPath.toRemote <> i_dmadatapath.io.remoteDMADataPath.toRemote

  // IO2: Start to coonect ctrl to csr
  io.csrIO <> i_dmactrl.io.csrIO

  // IO3: Start to connect ctrl to remoteDMADataPath
  io.remoteDMADataPathCfg <> i_dmactrl.io.remoteDMADataPathCfg

  // Intercoonection between ctrl and datapath
  i_dmactrl.io.localDMADataPath.reader_cfg_o <> i_dmadatapath.io.reader_cfg_i

  i_dmactrl.io.localDMADataPath.writer_cfg_o <> i_dmadatapath.io.writer_cfg_i

  i_dmadatapath.io.reader_start_i := i_dmactrl.io.localDMADataPath.reader_start_o

  i_dmadatapath.io.writer_start_i := i_dmactrl.io.localDMADataPath.writer_start_o

  i_dmactrl.io.localDMADataPath.reader_busy_i := i_dmadatapath.io.reader_busy_o

  i_dmactrl.io.localDMADataPath.writer_busy_i := i_dmadatapath.io.writer_busy_o

}

object xdmaTopEmitter extends App {
  emitVerilog(
    new xdmaTop(
      clusterName = "test_cluster",
      readerparam = new DMADataPathParam(new ReaderWriterParam, Seq()),
      writerparam = new DMADataPathParam(
        new ReaderWriterParam,
        Seq(HasMaxPool, HasMemset, HasTransposer)
      )
    ),
    args = Array("--target-dir", "generated")
  )
}

object xdmaTopGen extends App {
  val parsed_args = snax.utils.ArgParser.parse(args)

  /*
  Needed Parameters:
    tcdmDataWidth: Int
    axiDataWidth: Int
    addressWidth: Int
    tcdmSize: Int

    readerDimension: Int
    writerDimension: Int
    readerBufferDepth: Int
    writerBufferDepth: Int
    HasMemset
    HasMaxPool
    HasTranspopser
   */

  val readerparam = new ReaderWriterParam(
    dimension = parsed_args("readerDimension").toInt,
    tcdmDataWidth = parsed_args("tcdmDataWidth").toInt,
    tcdmSize = parsed_args("tcdmSize").toInt,
    tcdmAddressWidth = parsed_args("addressWidth").toInt,
    numChannel =
      parsed_args("axiDataWidth").toInt / parsed_args("tcdmDataWidth").toInt,
    addressBufferDepth = parsed_args("readerBufferDepth").toInt
  )

  val writerparam = new ReaderWriterParam(
    dimension = parsed_args("writerDimension").toInt,
    tcdmDataWidth = parsed_args("tcdmDataWidth").toInt,
    tcdmSize = parsed_args("tcdmSize").toInt,
    tcdmAddressWidth = parsed_args("addressWidth").toInt,
    numChannel =
      parsed_args("axiDataWidth").toInt / parsed_args("tcdmDataWidth").toInt,
    addressBufferDepth = parsed_args("writerBufferDepth").toInt
  )

  var extensionparam = Seq[HasDMAExtension]()
  if (parsed_args.contains("HasMemset"))
    extensionparam = extensionparam :+ HasMemset
  if (parsed_args.contains("HasMaxPool"))
    extensionparam = extensionparam :+ HasMaxPool
  if (parsed_args.contains("HasTransposer"))
    extensionparam = extensionparam :+ HasTransposer

  emitVerilog(
    new xdmaTop(
      clusterName = parsed_args.getOrElse("clusterName", ""),
      readerparam = new DMADataPathParam(readerparam, Seq()),
      writerparam = new DMADataPathParam(writerparam, extensionparam)
    ),
    args =
      Array("--target-dir", parsed_args.getOrElse("target-dir", "generated"))
  )
}
