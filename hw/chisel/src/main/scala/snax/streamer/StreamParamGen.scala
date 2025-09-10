// Copyright 2024 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

package snax.streamer

import snax.readerWriter._
import snax.reqRspManager._
import snax.utils._

import chisel3._
import chisel3.util._

// Streamer parameters
// tcdm_size in KB
object StreamerParametersGen {

// constrain: all the reader and writer needs to have same config of crossClockDomain
  def hasCrossClockDomain = false

  def readerParams =
    Seq(
      new ReaderWriterParam(
        spatialBounds       = List(
          16
        ),
        temporalDimension   = 6,
        tcdmDataWidth       = 64,
        tcdmSize            = 256,
        tcdmLogicWordSize   = Seq(256),
        numChannel          = 16,
        addressBufferDepth  = 2,
        dataBufferDepth     = 2,
        configurableChannel = true,
        crossClockDomain    = hasCrossClockDomain
      ),
      new ReaderWriterParam(
        spatialBounds       = List(
          128
        ),
        temporalDimension   = 3,
        tcdmDataWidth       = 64,
        tcdmSize            = 256,
        tcdmLogicWordSize   = Seq(256),
        numChannel          = 128,
        addressBufferDepth  = 2,
        dataBufferDepth     = 2,
        configurableChannel = true,
        crossClockDomain    = hasCrossClockDomain
      ),
      new ReaderWriterParam(
        spatialBounds       = List(
          64
        ),
        temporalDimension   = 4,
        tcdmDataWidth       = 64,
        tcdmSize            = 256,
        tcdmLogicWordSize   = Seq(256),
        numChannel          = 64,
        addressBufferDepth  = 2,
        dataBufferDepth     = 2,
        configurableChannel = true,
        crossClockDomain    = hasCrossClockDomain
      )
    )

  def writerParams =
    Seq(
      new ReaderWriterParam(
        spatialBounds       = List(
          64
        ),
        temporalDimension   = 4,
        tcdmDataWidth       = 64,
        tcdmSize            = 256,
        tcdmLogicWordSize   = Seq(256),
        numChannel          = 64,
        addressBufferDepth  = 2,
        dataBufferDepth     = 2,
        configurableChannel = true,
        crossClockDomain    = hasCrossClockDomain
      )
    )

  def readerWriterParams = Seq()

  def tagName        = "snax_versacore_"
  def headerFilepath = "../../target/snitch_cluster/sw/snax/versacore/include"
}
