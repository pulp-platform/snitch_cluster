package snax.readerWriter

import chisel3.util.log2Up
import chisel3.util.log2Ceil

/*
 *  This is the collection of all design Params
 *  Design Params is placed all together with companion object to avoid multiple definition of one config & config conflict
 */

// TCDM Params

class TCDMParam(
    val addrWidth: Int,
    val dataWidth: Int,
    val numChannel: Int,
    val tcdmSize: Int
)

object TCDMParam {
  def apply(dataWidth: Int, numChannel: Int, tcdmSize: Int): TCDMParam =
    new TCDMParam(log2Ceil(tcdmSize) + 10, dataWidth, numChannel, tcdmSize)
  // By default, the TCDM is 128kB, 64bit data width, 8 channels
  def apply(): TCDMParam = apply(dataWidth = 64, numChannel = 8, tcdmSize = 128)
}

// Streamer Sub-module Params

class AddressGenUnitParam(
    val spatialBounds: List[Int],
    val temporalDimension: Int,
    val addressWidth: Int,
    val numChannel: Int,
    val outputBufferDepth: Int,
    val tcdmSize: Int,
    val pipeFifo: Boolean
)

object AddressGenUnitParam {
  def apply(
      spatialBounds: List[Int],
      temporalDimension: Int,
      numChannel: Int,
      outputBufferDepth: Int,
      tcdmSize: Int,
      pipeFifo: Boolean
  ): AddressGenUnitParam = new AddressGenUnitParam(
    spatialBounds = spatialBounds,
    temporalDimension = temporalDimension,
    addressWidth = log2Ceil(tcdmSize) + 10,
    numChannel = numChannel,
    outputBufferDepth = outputBufferDepth,
    tcdmSize = tcdmSize,
    pipeFifo = pipeFifo
  )

  // The Very Simple instantiation of the Param
  def apply(): AddressGenUnitParam = apply(
    spatialBounds = List(8),
    temporalDimension = 2,
    numChannel = 8,
    outputBufferDepth = 8,
    tcdmSize = 128,
    pipeFifo = true
  )
}

class ReaderWriterParam(
    spatialBounds: List[Int] = List(8),
    temporalDimension: Int = 2,
    tcdmDataWidth: Int = 64,
    tcdmSize: Int = 128,
    numChannel: Int = 8,
    addressBufferDepth: Int = 8,
    dataBufferDepth: Int = 8,
    val configurableChannel: Boolean = false,
    val configurableByteMask: Boolean = false,
    val pipeFifo: Boolean = true
) {
  val aguParam = AddressGenUnitParam(
    spatialBounds = spatialBounds,
    temporalDimension = temporalDimension,
    numChannel = numChannel,
    outputBufferDepth = addressBufferDepth,
    tcdmSize = tcdmSize,
    pipeFifo = pipeFifo
  )

  val tcdmParam = TCDMParam(
    dataWidth = tcdmDataWidth,
    numChannel = numChannel,
    tcdmSize = tcdmSize
  )

  // Data buffer's depth
  val bufferDepth = dataBufferDepth

  val csrNum =
    2 + spatialBounds.length + 2 * temporalDimension + (if (configurableChannel)
                                                          1
                                                        else
                                                          0) + (if (
                                                                  configurableByteMask
                                                                ) 1
                                                                else
                                                                  0)
}
