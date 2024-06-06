package snax.streamer

import snax.utils._

import chisel3._
import chisel3.util._

/** This Data Mover module is a common base class for Data Reader and Data
  * Writer. It has the common IO and common function that Data Reader and Data
  * Writer both has, including interface with the spatial address generation
  * units and the finite state machine for the data movement process.
  */

/** This class represents the input/output interface for Data Mover module
  * @param params
  *   The parameter class contains all the parameters of a data mover module
  */
class DataMoverIO(params: DataMoverParams) extends Bundle {

  // signals for write request address generation
  val ptr_agu_i = Flipped(Decoupled(UInt(params.addrWidth.W)))

  val spatialStrides_csr_i = Flipped(
    Decoupled(Vec(params.spatialDim, UInt(params.addrWidth.W)))
  )

  // tcdm request ports
  val tcdm_req = (Vec(
    params.tcdmPortsNum,
    Decoupled(new TcdmReq(params.addrWidth, params.tcdmDataWidth))
  ))

  // input signal from the temporal address generation unit to indicate
  // all the temporal addresses have been produced
  val addr_gen_done = Input(Bool())

  // output signal to indicate the data movement process is done
  val data_movement_done = Output(Bool())
}

/** DataMover is a base class for Data Reader and Data Writer. It contains the
  * logic of getting temporal address from the TemporalAddrGenUnit, generating
  * spatial address and sending request to the tcdm.
  *
  * @param params
  *   The parameter class contains all the parameters of a data mover module
  */
class DataMover(
    params: DataMoverParams,
    tagName: String = ""
) extends Module
    with RequireAsyncReset {
  override val desiredName = tagName + "DataMover"

  lazy val io = IO(new DataMoverIO(params))

  // ******************************************************************************************
  // *********** Logic for programming the spatial address generation unit ********************
  // ******************************************************************************************

  // registers for storing the configuration
  val spatialStrides = RegInit(
    VecInit(Seq.fill(params.spatialDim)(0.U(params.addrWidth.W)))
  )

  val config_valid = WireInit(0.B)
  config_valid := io.spatialStrides_csr_i.fire

  // write the configuration to the register when it is valid
  when(config_valid) {
    spatialStrides := io.spatialStrides_csr_i.bits
  }

  // Instantiate the spatial address generation unit
  lazy val spatial_addr_gen_unit = Module(
    new SpatialAddrGenUnit(
      SpatialAddrGenUnitParams(
        params.spatialDim,
        params.spatialBounds,
        params.addrWidth
      ),
      tagName
    )
  )
  spatial_addr_gen_unit.io.valid_i := 1.B
  spatial_addr_gen_unit.io.ptr_i := io.ptr_agu_i.bits
  spatial_addr_gen_unit.io.strides_i := spatialStrides

  // ******************************************************************************************
  // *********** Logic for the finite sate machine ********************************************
  // ******************************************************************************************

  // State declaration
  val sIDLE :: sBUSY :: Nil = Enum(2)
  val cstate = RegInit(sIDLE)
  val nstate = WireInit(sIDLE)

  // State changes
  cstate := nstate

  chisel3.dontTouch(cstate)
  switch(cstate) {
    is(sIDLE) {
      when(config_valid) {
        nstate := sBUSY
      }.otherwise {
        nstate := sIDLE
      }

    }
    is(sBUSY) {
      when(io.addr_gen_done) {
        nstate := sIDLE
      }.otherwise {
        nstate := sBUSY
      }
    }
  }

  // ready for a new config in the idle state
  io.spatialStrides_csr_i.ready := cstate === sIDLE

  // ******************************************************************************************
  // *********** Logic for handling TCDM requests *********************************************
  // ******************************************************************************************

  // for every TCDM port, we send out a request to read/write some data at a given address.
  // When all requests succeed, the data movement is done, and we can process the next temporal
  // address. To keep track of the state of the TCDM requests, we use a valid register for each
  // TCDM port. When a request is sent, we set the ready register to 0. When the request is
  // acknowledged, we set the ready register to 1. When all ready registers are 1, we know that
  // all requests have been acknowledged. We must make sure that the overhead of this mechanism
  // is zero in the ideal case where every request is acknowledged immediately.

  // registers to store the success of the TCDM requests in previous cycles
  val tcdm_req_ready_reg = RegInit(VecInit(Seq.fill(params.tcdmPortsNum)(0.B)))

  // the request is ready if all transactions are successful in this cycle
  // or have been successfully processed in a previous cycle
  val tcdm_req_ready = WireInit(0.B)
  // tcdm_req_ready_signals is a vector of ready signals for each TCDM port
  val tcdm_req_ready_signals = WireInit(
    VecInit(Seq.fill(params.tcdmPortsNum)(0.B))
  )
  for (i <- 0 until params.tcdmPortsNum) {
    tcdm_req_ready_signals(i) := io.tcdm_req(i).ready || tcdm_req_ready_reg(i)
  }
  // the full request is ready if seperate ready signals are all true
  tcdm_req_ready := tcdm_req_ready_signals.reduce(_ && _)

  // outstanding requests are valid if they have not been acknowledged yet
  // or if we are processing a new request in this cycle
  for (i <- 0 until params.tcdmPortsNum) {
    io.tcdm_req(i).valid := io.ptr_agu_i.valid && ~tcdm_req_ready_reg(i)
  }

  // in the busy state, we can process the next pointer
  // if there is no current request which must be acknowledged
  io.ptr_agu_i.ready := cstate === sBUSY && tcdm_req_ready

  // logic for assigning the ready bits per tcdm port
  for (i <- 0 until params.tcdmPortsNum) {
    when(io.ptr_agu_i.fire) { // on a new pointer, clear the ready bits
      tcdm_req_ready_reg(i) := 0.B
    }.elsewhen(io.tcdm_req(i).fire) { // on a successful tcdm transaction, set the ready bit
      tcdm_req_ready_reg(i) := 1.B
    }.elsewhen(~io.ptr_agu_i.valid) { // if there is no request, set to 0
      tcdm_req_ready_reg(i) := 0.B
    }.otherwise {
      tcdm_req_ready_reg(i) := tcdm_req_ready_reg(i)
    }
  }

  // connect the tcdm request address ports to the generated spatial addresses
  // this is a bit tricky because there is a discrepancy between the data
  // width of the TCDM and the element width. For now, this discrepancy is
  // only supported  if all the accesses within a bank are contiguous.
  // We must assert that the addresses are packed together nicely in one TCDM bank.

  // we can define the number of elements that are packed together in one TCDM bank
  def nb_packed_elements =
    (params.tcdmDataWidth / 8) / (params.elementWidth / 8)

  // simulation time address constraint check. The addresses should be aligned with
  // a TCDM bank and contiguous within a bank
  when(cstate =/= sIDLE) {
    for (i <- 0 until params.tcdmPortsNum) {
      assert(
        spatial_addr_gen_unit.io.ptr_o(
          i * nb_packed_elements
        ) % (params.tcdmDataWidth / 8).U === 0.U,
        "read access is not aligned with a bank!"
      )
      for (j <- 0 until nb_packed_elements - 1) {
        assert(
          spatial_addr_gen_unit.io.ptr_o(i * nb_packed_elements + j + 1) ===
            spatial_addr_gen_unit.io.ptr_o(i * nb_packed_elements + j) +
            ((params.tcdmDataWidth / 8) / nb_packed_elements).U,
          "read access is not contiguous within a bank!"
        )
      }
    }
  }

  // we can now connect the spatial addresses to the TCDM request address ports
  for (i <- 0 until params.tcdmPortsNum) {
    io.tcdm_req(i).bits.addr := spatial_addr_gen_unit.io.ptr_o(
      i * nb_packed_elements
    )
  }

  // finally, we can signal the data movement process is finished when all requests
  // have been acknowledged and all temporal addresses have been processed
  val data_movement_done = WireInit(0.B)
  data_movement_done := io.addr_gen_done && tcdm_req_ready
  io.data_movement_done := data_movement_done

}

// A small class which asserts the non-initialized signals
// of the DataMover module. These must be set by the
// classes which extend the DataMover module, but are just
// set to 0 here for testing purposes.
class DataMoverTester(
    params: DataMoverParams
) extends DataMover(params) {

  for (i <- 0 until params.tcdmPortsNum) {
    io.tcdm_req(i).bits.data := 0.U
    io.tcdm_req(i).bits.write := 0.B
  }

}
