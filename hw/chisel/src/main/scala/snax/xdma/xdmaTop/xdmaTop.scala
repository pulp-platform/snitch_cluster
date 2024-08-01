package snax.xdma.xdmaTop

import chisel3._
import chisel3.util._

import snax.csr_manager._
import snax.utils._

import snax.xdma.xdmaFrontend._
import snax.xdma.xdmaExtension._
import snax.xdma.DesignParams._
import os.write

import scala.reflect.runtime.currentMirror
import scala.tools.reflect.ToolBox
import scala.reflect.runtime.universe._

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

  // Interconnection between ctrl and datapath
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
  var readerextensionparam = Seq[HasDMAExtension]()
  var writerextensionparam = Seq[HasDMAExtension]()

  // The following complex code is to dynamically load the extension modules
  // The target is that: 1) the sequence of the extension can be specified by the user 2) users can add their own extensions in the minimal effort (Does not need to modify the generation code)
  // The mechanism is that a small and temporary scala binary is compiled during the execution, to retrieve the instantiation object from the name
  // E.g. "HasMaxPool" -> HasMaxPool object
  // Thus, the generation function does not need to be modified by the extension developers.
  // Extension developers only need to 1) Add the Extension source code 2) Add Has...: #priority in hjson configuration file

  val toolbox = currentMirror.mkToolBox()
  parsed_args
    .filter(i => i._1.startsWith("Has") && i._2.toInt > 0)
    .toSeq
    .map(i => (i._1, i._2.toInt))
    .sortWith(_._2 < _._2)
    .foreach(i => {
      writerextensionparam = writerextensionparam :+ toolbox
        .compile(toolbox.parse(s"""
import snax.xdma.xdmaExtension._
return ${i._1}
      """))()
        .asInstanceOf[HasDMAExtension]
    })

  // Generation of the hardware
  emitVerilog(
    new xdmaTop(
      clusterName = parsed_args.getOrElse("clusterName", ""),
      readerparam = new DMADataPathParam(readerparam, readerextensionparam),
      writerparam = new DMADataPathParam(writerparam, writerextensionparam)
    ),
    args =
      Array("--target-dir", parsed_args.getOrElse("hw-target-dir", "generated"))
  )

  // Generation of the software #define macros
  val macro_dir = parsed_args.getOrElse(
    "sw-target-dir",
    "generated"
  ) + "/include/snax-xdma-csr-addr.h"

  val macro_template =
    s"""// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Yunhao Deng <yunhao.deng@kuleuven.be>

// This file is generated by Chisel in hw/chisel, do not modify it manually

#define XDMA_BASE_ADDR 960
#define XDMA_WIDTH ${writerparam.tcdm_param.numChannel * writerparam.tcdm_param.dataWidth / 8}
#define XDMA_SPATIAL_CHAN ${writerparam.tcdm_param.numChannel}
#define XDMA_SRC_ADDR_PTR_LSB XDMA_BASE_ADDR
#define XDMA_SRC_ADDR_PTR_MSB XDMA_SRC_ADDR_PTR_LSB + 1
#define XDMA_SRC_DIM ${readerparam.agu_param.dimension}
#define XDMA_SRC_BOUND_PTR XDMA_SRC_ADDR_PTR_MSB + 1
#define XDMA_SRC_STRIDE_PTR XDMA_SRC_BOUND_PTR + XDMA_SRC_DIM
#define XDMA_SRC_EXT_CSR_PTR XDMA_SRC_STRIDE_PTR + XDMA_SRC_DIM
#define XDMA_SRC_EXT_NUM ${readerextensionparam.length}
#define XDMA_SRC_EXT_CSR_NUM ${readerextensionparam
        .map(_.extensionParam.userCsrNum)
        .sum + readerextensionparam.length}
#define XDMA_SRC_EXT_CUSTOM_CSR_NUM \\
    { ${readerextensionparam.map(_.extensionParam.userCsrNum).mkString(", ")} }
#define XDMA_DST_ADDR_PTR_LSB XDMA_SRC_EXT_CSR_PTR + XDMA_SRC_EXT_CSR_NUM
#define XDMA_DST_ADDR_PTR_MSB XDMA_DST_ADDR_PTR_LSB + 1
#define XDMA_DST_DIM ${writerparam.agu_param.dimension}
#define XDMA_DST_BOUND_PTR XDMA_DST_ADDR_PTR_MSB + 1
#define XDMA_DST_STRIDE_PTR XDMA_DST_BOUND_PTR + XDMA_DST_DIM
#define XDMA_DST_STRB_PTR XDMA_DST_STRIDE_PTR + XDMA_DST_DIM
#define XDMA_DST_EXT_CSR_PTR XDMA_DST_STRB_PTR + 1
#define XDMA_DST_EXT_NUM ${writerextensionparam.length}
#define XDMA_DST_EXT_CSR_NUM ${writerextensionparam
        .map(_.extensionParam.userCsrNum)
        .sum + writerextensionparam.length}
#define XDMA_DST_EXT_CUSTOM_CSR_NUM \\
    { ${writerextensionparam.map(_.extensionParam.userCsrNum).mkString(", ")} }
#define XDMA_START_PTR XDMA_DST_EXT_CSR_PTR + XDMA_DST_EXT_CSR_NUM
#define XDMA_COMMIT_TASK_PTR XDMA_START_PTR + 1
#define XDMA_FINISH_TASK_PTR XDMA_COMMIT_TASK_PTR + 1
"""

  java.nio.file.Files.write(
    java.nio.file.Paths.get(macro_dir),
    macro_template.getBytes(java.nio.charset.StandardCharsets.UTF_8)
  )
}
