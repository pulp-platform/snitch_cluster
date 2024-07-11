package snax.xdma.xdmaTop

import chisel3._
import chisel3.util._

import snax.csr_manager._
import snax.utils._

import snax.xdma.xdmaFrontend._
import snax.xdma.xdmaExtension.HasMemset
import snax.xdma.xdmaExtension.HasTransposer
import snax.xdma.xdmaExtension.HasMaxPool
import snax.xdma.DesignParams._

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
    csrAddrWidth: Int = 32
) extends Module
    with RequireAsyncReset {
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
      readerparam = readerparam,
      writerparam = writerparam,
      axiWidth = axiWidth,
      csrAddrWidth = csrAddrWidth
    )
  )

  val i_dmadatapath = Module(
    new DMADataPath(
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

object xdmaTopTester extends App {
  emitVerilog(
    new xdmaTop(
      readerparam = new DMADataPathParam(new ReaderWriterParam, Seq()),
      writerparam = new DMADataPathParam(
        new ReaderWriterParam,
        Seq(HasMemset, HasTransposer, HasMaxPool)
      )
    ),
    args = Array("--target-dir", "generated")
  )
}
