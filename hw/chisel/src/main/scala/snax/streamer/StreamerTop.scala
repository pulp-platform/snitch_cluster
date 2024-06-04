package snax.streamer

import snax.csr_manager._

import snax.utils._

import chisel3._
import chisel3.util._
import chisel3.experimental.{prefix, noPrefix}
import scala.annotation.meta.param

/** This class represents the input and output ports of the streamer top module
  *
  * @param params
  *   the parameters class instantiation for the streamer top module
  */
class StreamerTopIO(
    params: StreamerParams,
    csrAddrWidth: Int
) extends Bundle {

  // ports for csr configuration
  val csr = new SnaxCsrIO(csrAddrWidth)

  // ports for data in and out
  val data = new StreamerDataIO(
    params
  )
}

/** This class represents the streamer top module which adds the csr registers
  * as well as csr read and write logic based on the streamer
  *
  * @param params
  *   the parameters class instantiation for the streamer top module
  */
class StreamerTop(
    params: StreamerParams
) extends Module
    with RequireAsyncReset {

  override val desiredName = params.tagName + "StreamerTop"

  var csrNumReadWrite: Int = 0
  if (params.ifShareTempAddrGenLoopBounds == true) {
    csrNumReadWrite =
      params.temporalDimInt + params.dataMoverNum * params.temporalDimInt + params.spatialDim.sum + params.dataMoverNum + 1
  } else {
    csrNumReadWrite =
      params.temporalDimSeq.sum + params.temporalDimSeq.sum + params.spatialDim.sum + params.dataMoverNum + 1
  }

  val io = IO(
    new StreamerTopIO(
      params,
      params.csrAddrWidth
    )
  )

  // csrManager instantiation
  val csr_manager = Module(
    new CsrManager(
      csrNumReadWrite,
      params.readOnlyCsrNum,
      params.csrAddrWidth,
      params.tagName
    )
  )

  // streamer instantiation
  val streamer = Module(new Streamer(params, params.tagName))

  // connect the csrManager input and streamertop csr req input
  csr_manager.io.csr_config_in.req <> io.csr.req

  // io.csr and csrManager input connection
  csr_manager.io.csr_config_in.rsp <> io.csr.rsp

  // connect the streamer and csrManager output
  // control signals
  streamer.io.csr.valid := csr_manager.io.csr_config_out.valid
  csr_manager.io.csr_config_out.ready := streamer.io.csr.ready

  // add performance counter for streamer
  val streamerBusy2Idle = WireInit(false.B)

  streamerBusy2Idle := !streamer.io.busy_o && RegNext(streamer.io.busy_o)

  val performance_counter = RegInit(0.U(32.W))
  when(streamer.io.busy_o) {
    performance_counter := performance_counter + 1.U
  }.elsewhen(streamerBusy2Idle) {
    performance_counter := 0.U
  }

  // connect the performance counter to the first ready only csr
  csr_manager.io.read_only_csr(0) := performance_counter

  // splitting csrManager data ports to the streamer components
  //  Total number of csr is temporalDim + dataMoverNum * temporalDim + spatialDim.sum + dataMoverNum
  // + 1 (launch address) + 1 (performance counter).

  // lowest temporalDim address (0 to temporalDim - 1) is for temporal loop bound.
  //  0 is for innermost loop, temporalDim - 1 is for outermost loop

  // Then address (temporalDim, temporalDim +  dataMoverNum * temporalDim) is for temporal strides.
  // lowest address (temporalDim, temporalDim + temporalDim) is for the first data reader, with address temporalDim for the innermost loop.
  // address (temporalDim + (dataMoverNum - 1) * temporalDim, temporalDim + dataMoverNum * temporalDim -1) is for the first data reader.

  // Then address (temporalDim +  dataMoverNum * temporalDim, temporalDim + dataMoverNum * temporalDim + spatialDim.sum - 1)  is for spatial loop strides. The order is the same as temporal strides.

  // Then address (temporalDim +  dataMoverNum * temporalDim, temporalDim + dataMoverNum * temporalDim + spatialDim.sum + dataMoverNum - 1) is for the base pointers for each data mover.
  // the lowest address for teh first data mover.

  if (params.ifShareTempAddrGenLoopBounds == true) {
    // temporal loop bounds
    for (i <- 0 until params.temporalDimInt) {
      streamer.io.csr.bits
        .loopBounds_i(0)(i) := csr_manager.io.csr_config_out.bits(i)
    }

    // Connect configuration registers for temporal loop strides
    for (i <- 0 until params.dataMoverNum) {
      for (j <- 0 until params.temporalDimInt) {
        streamer.io.csr.bits
          .temporalStrides_csr_i(i)(j) := csr_manager.io.csr_config_out.bits(
          params.temporalDimInt + i * params.temporalDimInt + j
        )
      }
    }
  } else {
    // temporal loop bounds
    for (i <- 0 until params.dataMoverNum) {
      for (j <- 0 until params.temporalDimSeq(i)) {
        streamer.io.csr.bits
          .loopBounds_i(i)(j) := csr_manager.io.csr_config_out.bits(
          params.temporalDimSeq.take(i).sum + j
        )
      }
    }

    // Connect configuration registers for temporal loop strides
    for (i <- 0 until params.dataMoverNum) {
      for (j <- 0 until params.temporalDimSeq(i)) {
        streamer.io.csr.bits
          .temporalStrides_csr_i(i)(j) := csr_manager.io.csr_config_out.bits(
          params.temporalDimSeq.sum + params.temporalDimSeq.take(i).sum + j
        )
      }
    }
  }

  // Connect configuration registers for spatial loop strides
  assert(params.spatialDim.length == params.dataMoverNum)
  if (params.ifShareTempAddrGenLoopBounds == true) {
    for (i <- 0 until params.spatialDim.length) {
      for (j <- 0 until params.spatialDim(i)) {
        streamer.io.csr.bits
          .spatialStrides_csr_i(i)(j) := csr_manager.io.csr_config_out.bits(
          params.temporalDimInt + params.dataMoverNum * params.temporalDimInt + params.spatialDim
            .take(
              i
            )
            .sum + j
        )
      }
    }
  } else {
    for (i <- 0 until params.dataMoverNum) {
      for (j <- 0 until params.spatialDim(i)) {
        streamer.io.csr.bits
          .spatialStrides_csr_i(i)(j) := csr_manager.io.csr_config_out.bits(
          params.temporalDimSeq.sum + params.temporalDimSeq.sum + params.spatialDim
            .take(i)
            .sum + j
        )
      }
    }
  }

  // base ptrs
  if (params.ifShareTempAddrGenLoopBounds == true) {
    for (i <- 0 until params.dataMoverNum) {
      streamer.io.csr.bits.ptr_i(i) := csr_manager.io.csr_config_out.bits(
        params.temporalDimInt + params.dataMoverNum * params.temporalDimInt + params.spatialDim.sum + i
      )
    }
  } else {
    for (i <- 0 until params.dataMoverNum) {
      streamer.io.csr.bits.ptr_i(i) := csr_manager.io.csr_config_out.bits(
        params.temporalDimSeq.sum + params.temporalDimSeq.sum + params.spatialDim.sum + i
      )
    }
  }

  // io.data and streamer data ports connection
  io.data <> streamer.io.data

}
