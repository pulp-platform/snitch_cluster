package snax.streamer

import snax.utils._

import chisel3._
import chisel3.util._

/** This class is input and output for data reader (data mover in read mode). It
  * is extended from DataMoverIO. It adds tcdm_rsp input ports and fifo output
  * ports.
  * @param params
  *   The parameter class contains all the parameters of a data mover module
  */
class DataReaderIO(
    params: DataMoverParams
) extends DataMoverIO(params) {

  // tcdm response
  val tcdm_rsp =
    Vec(params.tcdmPortsNum, Flipped(Valid(new TcdmRsp(params.tcdmDataWidth))))

  // output data -> going to the fifo
  val data_fifo_o = Decoupled(UInt(params.fifoWidth.W))

  assert(
    params.fifoWidth == params.tcdmPortsNum * params.tcdmDataWidth,
    "fifoWidth should match with TCDM datawidth for now!"
  )

  // this signal should disappear!
  val fifo_almost_full = Input(Bool())
}

/** This class is data reader module,.It is responsible for sending read request
  * to TCDM and collect data from TCDM response, pushing valid data into the
  * queue It is the data producer from the accelerator X aspect. It extends from
  * the DataMover and add extract waiting and collecting tcdm response logic,
  * fifo output logic.
  * @param params
  *   The parameter class contains all the parameters of a data mover module
  */
class DataReader(
    params: DataMoverParams,
    tagName: String = ""
) extends DataMover(params, tagName) {
  override val desiredName = tagName + "DataReader"

  // override the IO of DataMover
  override lazy val io = IO(new DataReaderIO(params))
  io.suggestName("io")

  // For a read request, data can be set to 0, deassert write bit
  for (i <- 0 until params.tcdmPortsNum) {
    io.tcdm_req(i).bits.data := 0.U
    io.tcdm_req(i).bits.write := 0.B
  }

  // ************************************************************
  // ********** Logic for processing TCDM response **************
  // ************************************************************

  // Similar to the TCDM request, we need to keep track of the valid bits of the
  // TCDM response
  val tcdm_rsp_valid_reg =
    RegInit(VecInit(Seq.fill(params.tcdmPortsNum)(0.B)))
  val tcdm_rsp_valid_signals =
    WireInit(VecInit(Seq.fill(params.tcdmPortsNum)(0.B)))
  for (i <- 0 until params.tcdmPortsNum) {
    tcdm_rsp_valid_signals(i) := io.tcdm_rsp(i).valid || tcdm_rsp_valid_reg(i)
  }
  // the full request is ready if seperate ready signals are all true
  val tcdm_rsp_valid = WireInit(0.B)
  tcdm_rsp_valid := tcdm_rsp_valid_signals.reduce(_ && _)

  // instantiate a data buffer to store the TCDM response data
  val data_buffer =
    RegInit(VecInit(Seq.fill(params.tcdmPortsNum)(0.U(params.tcdmDataWidth.W))))

  for (i <- 0 until params.tcdmPortsNum) {
    // valid reg logic
    when(io.data_fifo_o.fire) {
      // we reset the valid bit when a the data gets dispatched to the fifo
      tcdm_rsp_valid_reg(i) := 0.B
    }.elsewhen(io.tcdm_rsp(i).valid) {
      // we set the valid bit on a succesfull response,
      // but not a successfull dispatch to the data fifo
      tcdm_rsp_valid_reg(i) := 1.B
    }.otherwise {
      tcdm_rsp_valid_reg(i) := tcdm_rsp_valid_reg(i)
    }

    // we write to the data buffer when the response is valid
    when(io.tcdm_rsp(i).valid) {
      data_buffer(i) := io.tcdm_rsp(i).bits.data
    }.otherwise {
      data_buffer(i) := data_buffer(i)
    }
  }

  // the output data to the fifo is connected to the data buffer if the
  // request succeeded in a previous cycle (known from the req_ready_reg),
  // otherwise it is directly connected to the TCDM response data
  val data_fifo_input = WireInit(
    VecInit(Seq.fill(params.tcdmPortsNum)(0.U(params.tcdmDataWidth.W)))
  )
  for (i <- 0 until params.tcdmPortsNum) {
    data_fifo_input(i) := Mux(
      tcdm_rsp_valid_reg(i),
      data_buffer(i),
      io.tcdm_rsp(i).bits.data
    )
  }

  // gether all the response data
  io.data_fifo_o.bits := Cat(data_fifo_input.reverse)

  // ************************************************************
  // ********** Logic for handling fifo handshake ***************
  // ************************************************************

  // // the output data is valid when all requests are successful
  io.data_fifo_o.valid := tcdm_rsp_valid

  // new pointers can be generated only when the fifo is not full (override base class assignment)
  io.ptr_agu_i.ready := cstate === sBUSY && tcdm_req_ready && io.data_fifo_o.ready

  // override the base class assignment for tcdm req valid
  // we cannot send a request signal if the fifo is not ready,
  // otherwise the data in the buffer may be overwritten,
  // we can make an exception if the buffer is empty
  // the buffer is empty if the valid bit is not set
  for (i <- 0 until params.tcdmPortsNum) {
    io.tcdm_req(i).valid := io.ptr_agu_i.valid &&
      ~tcdm_req_ready_reg(i) && (io.data_fifo_o.ready || ~tcdm_rsp_valid)
  }

}
