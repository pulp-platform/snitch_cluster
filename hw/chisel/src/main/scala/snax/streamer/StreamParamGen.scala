// Copyright 2024 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

package snax.streamer

import snax.readerWriter._
import snax.csr_manager._
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
          8
        ),
        temporalDimension   = 6,
        tcdmDataWidth       = 64,
        tcdmSize            = 128,
        tcdmLogicWordSize   = Seq(
          256,
          128,
          64
        ),
        numChannel          = 8,
        addressBufferDepth  = 8,
        dataBufferDepth     = 8,
        configurableChannel = false,
        crossClockDomain    = hasCrossClockDomain
      ),
      new ReaderWriterParam(
        spatialBounds       = List(
          8
        ),
        temporalDimension   = 3,
        tcdmDataWidth       = 64,
        tcdmSize            = 128,
        tcdmLogicWordSize   = Seq(
          256,
          128,
          64
        ),
        numChannel          = 8,
        addressBufferDepth  = 8,
        dataBufferDepth     = 8,
        configurableChannel = false,
        crossClockDomain    = hasCrossClockDomain
      )
    )

  def writerParams =
    Seq(
      new ReaderWriterParam(
        spatialBounds       = List(
          8
        ),
        temporalDimension   = 3,
        tcdmDataWidth       = 64,
        tcdmSize            = 128,
        tcdmLogicWordSize   = Seq(
          256,
          128,
          64
        ),
        numChannel          = 8,
        addressBufferDepth  = 1,
        dataBufferDepth     = 1,
        configurableChannel = false,
        crossClockDomain    = hasCrossClockDomain
      )
    )

  def readerWriterParams =
    Seq(
      new ReaderWriterParam(
        spatialBounds       = List(
          8,
          4
        ),
        temporalDimension   = 3,
        tcdmDataWidth       = 64,
        tcdmSize            = 128,
        tcdmLogicWordSize   = Seq(
          256,
          128,
          64
        ),
        numChannel          = 32,
        addressBufferDepth  = 1,
        dataBufferDepth     = 1,
        configurableChannel = true,
        crossClockDomain    = hasCrossClockDomain
      ),
      new ReaderWriterParam(
        spatialBounds       = List(
          8,
          4
        ),
        temporalDimension   = 3,
        tcdmDataWidth       = 64,
        tcdmSize            = 128,
        tcdmLogicWordSize   = Seq(
          256,
          128,
          64
        ),
        numChannel          = 32,
        addressBufferDepth  = 1,
        dataBufferDepth     = 1,
        configurableChannel = false,
        crossClockDomain    = hasCrossClockDomain
      )
    )

  def tagName        = "snax_streamer_gemmX_"
  def headerFilepath = "../../target/snitch_cluster/sw/snax/gemmx/include"
}
