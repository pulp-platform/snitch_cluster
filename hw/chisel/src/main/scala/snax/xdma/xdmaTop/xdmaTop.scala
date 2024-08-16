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
    readerParam: DMADataPathParam,
    writerParam: DMADataPathParam
) extends Bundle {
  val clusterBaseAddress = Input(
    UInt(writerParam.axiParam.addrWidth.W)
  )
  val csrIO = new SnaxCsrIO(32)

  val remoteDMADataPathCfg = new Bundle {
    val fromRemote = Flipped(Decoupled(UInt(writerParam.axiParam.dataWidth.W)))
    val toRemote = Decoupled(UInt(writerParam.axiParam.dataWidth.W))
  }

  val tcdmReader = new Bundle {
    val req = Vec(
      readerParam.rwParam.tcdmParam.numChannel,
      Decoupled(
        new TcdmReq(
          readerParam.rwParam.tcdmParam.addrWidth,
          readerParam.rwParam.tcdmParam.dataWidth
        )
      )
    )
    val rsp = Vec(
      readerParam.rwParam.tcdmParam.numChannel,
      Flipped(
        Valid(
          new TcdmRsp(tcdmDataWidth = readerParam.rwParam.tcdmParam.dataWidth)
        )
      )
    )
  }
  val tcdmWriter = new Bundle {
    val req = Vec(
      writerParam.rwParam.tcdmParam.numChannel,
      Decoupled(
        new TcdmReq(
          writerParam.rwParam.tcdmParam.addrWidth,
          writerParam.rwParam.tcdmParam.dataWidth
        )
      )
    )
  }

  val remoteDMADataPath = new Bundle {
    val fromRemote = Flipped(
      Decoupled(
        UInt(
          (writerParam.rwParam.tcdmParam.dataWidth * writerParam.rwParam.tcdmParam.numChannel).W
        )
      )
    )
    val toRemote = Decoupled(
      UInt(
        (writerParam.rwParam.tcdmParam.dataWidth * writerParam.rwParam.tcdmParam.numChannel).W
      )
    )
  }
}

class xdmaTop(
    readerParam: DMADataPathParam,
    writerParam: DMADataPathParam,
    clusterName: String = "unnamed_cluster"
) extends Module
    with RequireAsyncReset {
  override val desiredName = s"${clusterName}_xdma"
  val io = IO(
    new xdmaTopIO(
      readerParam = readerParam,
      writerParam = writerParam
    )
  )

  val dmaCtrl = Module(
    new DMACtrl(
      readerparam = readerParam,
      writerparam = writerParam,
      clusterName = clusterName
    )
  )

  val dmaDatapath = Module(
    new DMADataPath(
      readerparam = readerParam,
      writerparam = writerParam,
      clusterName = clusterName
    )
  )

  // Give the dmactrl the current cluster address
  dmaCtrl.io.clusterBaseAddress := io.clusterBaseAddress

  // IO0: Start to connect datapath to TCDM
  io.tcdmReader <> dmaDatapath.io.tcdmReader
  io.tcdmWriter <> dmaDatapath.io.tcdmWriter

  // IO1: Start to connect datapath to axi
  io.remoteDMADataPath.fromRemote <> dmaDatapath.io.remoteDMADataPath.fromRemote
  io.remoteDMADataPath.toRemote <> dmaDatapath.io.remoteDMADataPath.toRemote

  // IO2: Start to coonect ctrl to csr
  io.csrIO <> dmaCtrl.io.csrIO

  // IO3: Start to connect ctrl to remoteDMADataPath
  io.remoteDMADataPathCfg <> dmaCtrl.io.remoteDMADataPathCfg

  // Interconnection between ctrl and datapath
  dmaCtrl.io.localDMADataPath.reader_cfg_o <> dmaDatapath.io.readerCfg

  dmaCtrl.io.localDMADataPath.writer_cfg_o <> dmaDatapath.io.writerCfg

  dmaDatapath.io.readerStart := dmaCtrl.io.localDMADataPath.reader_start_o

  dmaDatapath.io.writerStart := dmaCtrl.io.localDMADataPath.writer_start_o

  dmaCtrl.io.localDMADataPath.reader_busy_i := dmaDatapath.io.readerBusy

  dmaCtrl.io.localDMADataPath.writer_busy_i := dmaDatapath.io.writerBusy

}

object xdmaTopGen extends App {
  val parsedArgs = snax.utils.ArgParser.parse(args)

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
  val axiParam = new AXIParam(
    dataWidth = parsedArgs("axiDataWidth").toInt,
    addrWidth = parsedArgs("axiAddrWidth").toInt
  )

  val readerparam = new ReaderWriterParam(
    dimension = parsedArgs("readerDimension").toInt,
    tcdmDataWidth = parsedArgs("tcdmDataWidth").toInt,
    tcdmSize = parsedArgs("tcdmSize").toInt,
    numChannel =
      parsedArgs("axiDataWidth").toInt / parsedArgs("tcdmDataWidth").toInt,
    addressBufferDepth = parsedArgs("readerBufferDepth").toInt
  )

  val writerparam = new ReaderWriterParam(
    dimension = parsedArgs("writerDimension").toInt,
    tcdmDataWidth = parsedArgs("tcdmDataWidth").toInt,
    tcdmSize = parsedArgs("tcdmSize").toInt,
    numChannel =
      parsedArgs("axiDataWidth").toInt / parsedArgs("tcdmDataWidth").toInt,
    addressBufferDepth = parsedArgs("writerBufferDepth").toInt
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
  parsedArgs
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
  var sv_string = getVerilogString(
    new xdmaTop(
      clusterName = parsedArgs.getOrElse("clusterName", ""),
      readerParam =
        new DMADataPathParam(axiParam, readerparam, readerextensionparam),
      writerParam =
        new DMADataPathParam(axiParam, writerparam, writerextensionparam)
    )
  )

  // Perform dirty fix on the Chisel's bug that append the file list at the end of the file
  sv_string = sv_string
    .split("\n")
    .takeWhile(
      !_.contains(
        """// ----- 8< ----- FILE "firrtl_black_box_resource_files.f" ----- 8< -----"""
      )
    )
    .mkString("\n")

  // Write the sv_string to the SystemVerilog file
  val hardware_dir = parsedArgs.getOrElse(
    "hw-target-dir",
    "generated"
  ) + "/" + s"${parsedArgs.getOrElse("clusterName", "")}_xdma.sv"
  java.nio.file.Files.write(
    java.nio.file.Paths.get(hardware_dir),
    sv_string.getBytes(java.nio.charset.StandardCharsets.UTF_8)
  )

  // Generation of the software #define macros
  val macro_dir = parsedArgs.getOrElse(
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
#define XDMA_WIDTH ${writerparam.tcdmParam.numChannel * writerparam.tcdmParam.dataWidth / 8}
#define XDMA_SPATIAL_CHAN ${writerparam.tcdmParam.numChannel}
#define XDMA_SRC_ADDR_PTR_LSB XDMA_BASE_ADDR
#define XDMA_SRC_ADDR_PTR_MSB XDMA_SRC_ADDR_PTR_LSB + 1
#define XDMA_SRC_DIM ${readerparam.aguParam.dimension}
#define XDMA_SRC_BOUND_PTR XDMA_SRC_ADDR_PTR_MSB + 1
#define XDMA_SRC_STRIDE_PTR XDMA_SRC_BOUND_PTR + XDMA_SRC_DIM
#define XDMA_SRC_BYPASS_PTR XDMA_SRC_STRIDE_PTR + XDMA_SRC_DIM
#define XDMA_SRC_EXT_NUM ${readerextensionparam.length}
#if XDMA_SRC_EXT_NUM > 0
#define XDMA_SRC_EXT_CSR_PTR XDMA_SRC_BYPASS_PTR + 1
#else
#define XDMA_SRC_EXT_CSR_PTR XDMA_SRC_BYPASS_PTR
#endif
#define XDMA_SRC_EXT_CSR_NUM ${readerextensionparam
        .map(_.extensionParam.userCsrNum)
        .sum}
#define XDMA_SRC_EXT_CUSTOM_CSR_NUM \\
    { ${readerextensionparam.map(_.extensionParam.userCsrNum).mkString(", ")} }

#define XDMA_DST_ADDR_PTR_LSB XDMA_SRC_EXT_CSR_PTR + XDMA_SRC_EXT_CSR_NUM
#define XDMA_DST_ADDR_PTR_MSB XDMA_DST_ADDR_PTR_LSB + 1
#define XDMA_DST_DIM ${writerparam.aguParam.dimension}
#define XDMA_DST_BOUND_PTR XDMA_DST_ADDR_PTR_MSB + 1
#define XDMA_DST_STRIDE_PTR XDMA_DST_BOUND_PTR + XDMA_DST_DIM
#define XDMA_DST_STRB_PTR XDMA_DST_STRIDE_PTR + XDMA_DST_DIM
#define XDMA_DST_BYPASS_PTR XDMA_DST_STRB_PTR + 1
#define XDMA_DST_EXT_NUM ${writerextensionparam.length}
#if XDMA_DST_EXT_NUM > 0
#define XDMA_DST_EXT_CSR_PTR XDMA_DST_BYPASS_PTR + 1
#else
#define XDMA_DST_EXT_CSR_PTR XDMA_DST_BYPASS_PTR
#endif
#define XDMA_DST_EXT_CSR_NUM ${writerextensionparam
        .map(_.extensionParam.userCsrNum)
        .sum}
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
