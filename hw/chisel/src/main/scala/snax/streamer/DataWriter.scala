package snax.streamer

import snax.utils._

import chisel3._
import chisel3.util._

/** This class is input and output for data writer (data mover in write mode).
  * It is extended from DataMoverIO. It adds fifo input ports.
  * @param params
  *   The parameter class contains all the parameters of a data mover module
  */
class DataWriterIO(
    params: DataMoverParams
) extends DataMoverIO(params) {

  // valid data from the queue
  val data_fifo_i = Flipped(Decoupled(UInt(params.fifoWidth.W)))

  assert(
    params.fifoWidth == params.tcdmPortsNum * params.tcdmDataWidth,
    "params.fifoWidth should match with TCDM datawidth for now!"
  )

}

/** This class is data writer module.It is responsible for getting valid data
  * from the data queue and sending write request to TCDM. It is the data
  * consumer from the accelerator X aspect. It extends from the DataMover and
  * adds fifo input and split the fifo data to tcdm data ports logic.
  * @param params
  *   The parameter class contains all the parameters of a data mover module
  */
class DataWriter(
    params: DataMoverParams,
    tagName: String = ""
) extends DataMover(params) {
  override val desiredName = tagName + "DataWriter"

  // override the IO of DataMover
  override lazy val io = IO(new DataWriterIO(params))
  io.suggestName("io")

  // For a write request, assert the write bit and assign the data
  for (i <- 0 until params.tcdmPortsNum) {
    io.tcdm_req(i).bits.write := 1.B
    io.tcdm_req(i).bits.data := io.data_fifo_i.bits(
      (i + 1) * params.tcdmDataWidth - 1,
      i * params.tcdmDataWidth
    )
  }

  // A valid TCDM request is overridden to also depend on the valid
  // signal of the data queue
  for (i <- 0 until params.tcdmPortsNum) {
    io.tcdm_req(i).valid := io.ptr_agu_i.valid &&
      ~tcdm_req_ready_reg(i) && io.data_fifo_i.valid
  }

  // we need to fetch a new word from the data queue simultaneously
  // with a new TCDM request (= a new input pointer)
  io.data_fifo_i.ready := io.ptr_agu_i.ready

}
