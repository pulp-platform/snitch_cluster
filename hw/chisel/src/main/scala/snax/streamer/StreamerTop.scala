package snax.streamer

import snax.csr_manager._

import snax.utils._

import chisel3._
import chisel3.util._
import chisel3.experimental.{prefix, noPrefix}

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

  // add extra performance counter
  val csrNum: Int =
    params.temporalDim + params.dataMoverNum * params.temporalDim + params.spatialDim.sum + params.dataMoverNum + 1 + 1
  val csrAddrWidth: Int = log2Up(csrNum)

  val io = IO(
    new StreamerTopIO(
      params,
      csrAddrWidth
    )
  )

  // csrManager instantiation
  val csr_manager = Module(new CsrManager(csrNum, csrAddrWidth, params.tagName))

  // streamer instantiation
  val streamer = Module(new Streamer(params, params.tagName))

  // io.csr and csrManager input connection
  csr_manager.io.csr_config_in.rsp <> io.csr.rsp

  val csr_config_in_req_valid = WireInit(false.B)
  val csr_config_in_req_bits = Wire(new CsrReq(csrAddrWidth))
  val csr_config_in_req_ready = WireInit(false.B)

  val streamerIdle2Busy = WireInit(false.B)
  val streamerBusy2Idle = WireInit(false.B)

  streamerIdle2Busy := streamer.io.busy_o && !RegNext(streamer.io.busy_o)
  streamerBusy2Idle := !streamer.io.busy_o && RegNext(streamer.io.busy_o)

  val performance_counter = RegInit(0.U(32.W))
  when(streamer.io.busy_o) {
    performance_counter := performance_counter + 1.U
  }.elsewhen(streamerBusy2Idle) {
    performance_counter := 0.U
  }

  csr_config_in_req_valid := io.csr.req.valid
  when(streamerBusy2Idle) {
    csr_config_in_req_bits.addr := csrNum.U - 2.U
    csr_config_in_req_bits.data := performance_counter
    csr_config_in_req_bits.write := true.B
  }.otherwise {
    csr_config_in_req_bits := io.csr.req.bits
  }

  csr_manager.io.csr_config_in.req.valid := csr_config_in_req_valid
  csr_manager.io.csr_config_in.req.bits := csr_config_in_req_bits
  io.csr.req.ready := csr_manager.io.csr_config_in.req.ready

  // csr_manager.io.streamerBusy2Idle := streamerBusy2Idle

  // connect the streamer and csrManager output
  // control signals
  streamer.io.csr.valid := csr_manager.io.csr_config_out.valid
  csr_manager.io.csr_config_out.ready := streamer.io.csr.ready

  // splitting csrManager data ports to the streamer components
  // Total number of csr is temporalDim + dataMoverNum * temporalDim + spatialDim.sum + dataMoverNum + 1.

  // lowest temporalDim address (0 to temporalDim - 1) is for temporal loop bound.
  //  0 is for innermost loop, temporalDim - 1 is for outermost loop

  // Then address (temporalDim, temporalDim +  dataMoverNum * temporalDim) is for temporal strides.
  // lowest address (temporalDim, temporalDim + temporalDim) is for the first data reader, with address temporalDim for the innermost loop.
  // address (temporalDim + (dataMoverNum - 1) * temporalDim, temporalDim + dataMoverNum * temporalDim -1) is for the first data reader.

  // Then address (temporalDim +  dataMoverNum * temporalDim, temporalDim + dataMoverNum * temporalDim + spatialDim.sum - 1)  is for spatial loop strides. The order is the same as temporal strides.

  // Then address (temporalDim +  dataMoverNum * temporalDim, temporalDim + dataMoverNum * temporalDim + spatialDim.sum + dataMoverNum - 1) is for the base pointers for each data mover.
  // the lowest address for teh first data mover.

  // temporal loop bounds
  for (i <- 0 until params.temporalDim) {
    streamer.io.csr.bits
      .loopBounds_i(i) := csr_manager.io.csr_config_out.bits(i)
  }

  // Connect configuration registers for temporal loop strides
  for (i <- 0 until params.dataMoverNum) {
    for (j <- 0 until params.temporalDim) {
      streamer.io.csr.bits
        .temporalStrides_csr_i(i)(j) := csr_manager.io.csr_config_out.bits(
        params.temporalDim + i * params.temporalDim + j
      )
    }
  }

  // Connect configuration registers for spatial loop strides
  for (i <- 0 until params.spatialDim.length) {
    for (j <- 0 until params.spatialDim(i)) {
      streamer.io.csr.bits
        .spatialStrides_csr_i(i)(j) := csr_manager.io.csr_config_out.bits(
        params.temporalDim + params.dataMoverNum * params.temporalDim + i * params
          .spatialDim(
            i
          ) + j
      )
    }
  }

  // base ptrs
  for (i <- 0 until params.dataMoverNum) {
    streamer.io.csr.bits.ptr_i(i) := csr_manager.io.csr_config_out.bits(
      params.temporalDim + params.dataMoverNum * params.temporalDim + params.spatialDim.sum + i
    )
  }

  // io.data and streamer data ports connection
  io.data <> streamer.io.data

}
