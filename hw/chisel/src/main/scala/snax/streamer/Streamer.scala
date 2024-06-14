package snax.streamer

import snax.utils._

import chisel3._
import chisel3.util._

// data to accelerator interface generator
// a vector of decoupled interface with configurable number and configurable width for each port
class DataToAcceleratorX(
    params: StreamerParams
) extends Bundle {
  val data = MixedVec((0 until params.dataReaderNum).map { i =>
    Decoupled(UInt(params.fifoWidthReader(i).W))
  } ++ (0 until params.dataReaderWriterNum).map { i =>
    Decoupled(UInt(params.fifoWidthReaderWriter(i).W))
  })
}

// data from accelerator interface generator
// a vector of decoupled interface with configurable number and configurable width for each port
class DataFromAcceleratorX(
    params: StreamerParams
) extends Bundle {
  val data = MixedVec((0 until params.dataWriterNum).map { i =>
    Flipped(Decoupled(UInt(params.fifoWidthWriter(i).W)))
  } ++ (0 until params.dataReaderWriterNum).map { i =>
    Flipped(Decoupled(UInt(params.fifoWidthReaderWriter(i).W)))
  })
}

// csr related io
class StreamerCsrIO(
    params: StreamerParams
) extends Bundle {

  // configurations interface for a new data operation
  val loopBounds_i =
    if (params.ifShareTempAddrGenLoopBounds == true)
      Vec(1, Vec(params.temporalDimInt, UInt(params.temporalBoundWidth.W)))
    else
      MixedVec((0 until params.temporalDimSeq.length).map { i =>
        Vec(params.temporalDimSeq(i), UInt(params.temporalBoundWidth.W))
      })

  val temporalStrides_csr_i =
    if (params.ifShareTempAddrGenLoopBounds == true)
      Vec(
        params.dataMoverNum,
        Vec(params.temporalDimInt, UInt(params.addrWidth.W))
      )
    else
      MixedVec((0 until params.temporalDimSeq.length).map { i =>
        Vec(params.temporalDimSeq(i), UInt(params.addrWidth.W))
      })

  val spatialStrides_csr_i =
    MixedVec((0 until params.spatialDim.length).map { i =>
      Vec(params.spatialDim(i), UInt(params.addrWidth.W))
    })

  val ptr_i =
    Vec(params.dataMoverNum, UInt(params.addrWidth.W))

}

// data related io
class StreamerDataIO(
    params: StreamerParams
) extends Bundle {
  // specify the interface to the accelerator
  val streamer2accelerator =
    new DataToAcceleratorX(params)
  val accelerator2streamer =
    new DataFromAcceleratorX(params)

  // specify the interface to the TCDM
  // request interface with q_valid and q_ready
  val tcdm_req =
    (Vec(
      params.tcdmPortsNum,
      Decoupled(new TcdmReq(params.addrWidth, params.tcdmDataWidth))
    ))
  // response interface with p_valid
  val tcdm_rsp = (Vec(
    params.tcdmPortsNum,
    Flipped(Valid(new TcdmRsp(params.tcdmDataWidth)))
  ))
}

// input and output declaration for streamer generator
class StreamerIO(
    params: StreamerParams
) extends Bundle {

  val csr = Flipped(
    Decoupled(
      new StreamerCsrIO(
        params
      )
    )
  )

  val data = new StreamerDataIO(
    params
  )

  val busy_o = Output(Bool())
}

// streamer generator module
class Streamer(
    params: StreamerParams,
    tagName: String = ""
) extends Module
    with RequireAsyncReset {
  override val desiredName = tagName + "Streamer"

  val io = IO(
    new StreamerIO(
      params
    )
  )

  // bandwidth between the tcdm, the fifo and the accelerator should match constrains in Streamer check

  // the tcdmWidth and the fifoWidth in dataMover should match
  def tcdmWidth = params.dataReaderParams.map(i =>
    params.tcdmDataWidth * i.tcdmPortsNum
  ) ++ params.dataWriterParams.map(i =>
    params.tcdmDataWidth * i.tcdmPortsNum
  ) ++ params.dataReaderWriterParams.map(i =>
    params.tcdmDataWidth * i.tcdmPortsNum
  )
  def dataMoverWidth = params.dataReaderParams.map(
    _.fifoWidth
  ) ++ params.dataWriterParams.map(_.fifoWidth) ++ params.dataReaderWriterParams
    .map(
      _.fifoWidth
    )
  require(tcdmWidth == dataMoverWidth)

  // the fifoWidth in dataMover and the FIFO width should match
  def fifoWidth =
    params.fifoWidthReader ++ params.fifoWidthWriter ++ params.fifoWidthReaderWriter
  require(fifoWidth == dataMoverWidth)

  // accelerator spatialBounds and elementWidth should match
  def accDataWidth = params.dataReaderParams.map(i =>
    i.spatialBounds.product * i.elementWidth
  ) ++ params.dataWriterParams.map(i =>
    i.spatialBounds.product * i.elementWidth
  ) ++ params.dataReaderWriterParams.map(i =>
    i.spatialBounds.product * i.elementWidth
  )
  require(fifoWidth == accDataWidth)

  def tcdm_read_ports_num =
    params.dataReaderTcdmPorts.reduceLeftOption(_ + _).getOrElse(0)
  def tcdm_write_ports_num =
    params.dataWriterTcdmPorts.reduceLeftOption(_ + _).getOrElse(0)

  // data readers instantiation
  // a vector of data reader generator instantiation with different parameters for each module
  val data_reader = Seq((0 until params.dataReaderNum).map { i =>
    Module(
      new DataReader(
        params.dataReaderParams(i),
        tagName
      )
    )
  }: _*)

  // data writers instantiation
  // a vector of data writer generator instantiation with different parameters for each module
  val data_writer = Seq((0 until params.dataWriterNum).map { i =>
    Module(
      new DataWriter(
        params.dataWriterParams(i),
        tagName
      )
    )
  }: _*)

  val data_reader_writer = Seq((0 until params.dataReaderWriterNum).map { i =>
    Module(
      new DataReaderWriter(
        params.dataReaderWriterParams(i),
        tagName
      )
    )
  }: _*)

  // address generation units instantiation
  // a vector of address generation unit generator instantiation with different parameters for each module
  val address_gen_unit =
    if (params.ifShareTempAddrGenLoopBounds == true)
      Seq((0 until params.dataMoverNum).map { i =>
        Module(
          new TemporalAddrGenUnit(
            params.temporalAddrGenUnitParams(0),
            tagName
          )
        )
      }: _*)
    else
      Seq((0 until params.dataMoverNum).map { i =>
        Module(
          new TemporalAddrGenUnit(
            params.temporalAddrGenUnitParams(i),
            tagName
          )
        )
      }: _*)

  // signals for state transition
  val config_valid = WireInit(0.B)
  val streamming_finish = WireInit(0.B)

  val datamover_states = RegInit(VecInit(Seq.fill(params.dataMoverNum)(0.B)))

  // State declaration
  val sIDLE :: sBUSY :: Nil = Enum(2)
  val cstate = RegInit(sIDLE)
  val nstate = WireInit(sIDLE)

  // Changing states
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
      when(streamming_finish) {
        nstate := sIDLE
      }.otherwise {
        nstate := sBUSY
      }
    }
  }

  io.busy_o := cstate === sBUSY

  config_valid := io.csr.fire && io.csr.fire && io.csr.fire && io.csr.fire

  var reader_writer_idx: Int = 0
  var reader_writer_idx_rw: Int = 0

  for (i <- 0 until params.dataMoverNum) {
    when(config_valid && cstate === sIDLE) {
      datamover_states(i) := 1.B
    }.otherwise {
      if (i < params.dataReaderNum) {
        when(data_reader(i).io.data_movement_done) {
          datamover_states(i) := 0.B
        }
      } else {
        if (i < params.dataReaderNum + params.dataWriterNum) {
          when(data_writer(i - params.dataReaderNum).io.data_movement_done) {
            datamover_states(i) := 0.B
          }
        } else {
          reader_writer_idx =
            (i - params.dataReaderNum - params.dataWriterNum) / 2
          reader_writer_idx_rw =
            (i - params.dataReaderNum - params.dataWriterNum) % 2
          when(
            data_reader_writer(reader_writer_idx).io
              .data_movement_done(reader_writer_idx_rw)
          ) {
            datamover_states(i) := 0.B
          }
        }
      }
    }
  }

  // data streaming finish when all the data mover finished the data movement
  streamming_finish := !datamover_states.reduce(_ | _)

  io.csr.ready := cstate === sIDLE

  // signals connections for the instantiated modules
  // TODO: try to use case map to connect...
  // address generation units csr configuration interface <> streamer IO
  if (params.ifShareTempAddrGenLoopBounds == true) {
    for (i <- 0 until params.dataMoverNum) {
      if (params.stationarity(i) == 1) {
        for (j <- 0 until params.temporalDimInt) {
          if (j == 0) {
            when(io.csr.bits.loopBounds_i(0)(j) === 0.U) {
              address_gen_unit(i).io.loopBounds_i.bits(j) := 0.U
            }.otherwise {
              address_gen_unit(i).io.loopBounds_i.bits(j) := 1.U
            }
          } else {
            address_gen_unit(i).io.loopBounds_i
              .bits(j) := io.csr.bits.loopBounds_i(0)(j)
          }
        }
      } else {
        address_gen_unit(
          i
        ).io.loopBounds_i.bits := io.csr.bits.loopBounds_i(0)
      }
      address_gen_unit(
        i
      ).io.loopBounds_i.valid := io.csr.valid
      address_gen_unit(
        i
      ).io.strides_i.bits := io.csr.bits.temporalStrides_csr_i(
        i
      )
      address_gen_unit(
        i
      ).io.strides_i.valid := io.csr.valid
      address_gen_unit(i).io.ptr_i.bits := io.csr.bits.ptr_i(i)
      address_gen_unit(i).io.ptr_i.valid := io.csr.valid
    }
  } else {
    for (i <- 0 until params.temporalDimSeq.length) {
      if (params.stationarity(i) == 1) {
        for (j <- 0 until params.temporalDimSeq(i)) {
          if (j == 0) {
            when(io.csr.bits.loopBounds_i(i)(j) === 0.U) {
              address_gen_unit(i).io.loopBounds_i.bits(j) := 0.U
            }.otherwise {
              address_gen_unit(i).io.loopBounds_i.bits(j) := 1.U
            }
          } else {
            address_gen_unit(i).io.loopBounds_i
              .bits(j) := io.csr.bits.loopBounds_i(i)(j)
          }
        }
      } else {
        address_gen_unit(
          i
        ).io.loopBounds_i.bits := io.csr.bits.loopBounds_i(i)
      }
      address_gen_unit(
        i
      ).io.loopBounds_i.valid := io.csr.valid
      address_gen_unit(
        i
      ).io.strides_i.bits := io.csr.bits.temporalStrides_csr_i(
        i
      )
      address_gen_unit(
        i
      ).io.strides_i.valid := io.csr.valid
      address_gen_unit(i).io.ptr_i.bits := io.csr.bits.ptr_i(i)
      address_gen_unit(i).io.ptr_i.valid := io.csr.valid
    }

  }

  // data reader and data writer <> streamer IO
  for (i <- 0 until params.dataMoverNum) {
    if (i < params.dataReaderNum) {
      data_reader(i).io.spatialStrides_csr_i.bits := io.csr.bits
        .spatialStrides_csr_i(i)
      data_reader(
        i
      ).io.spatialStrides_csr_i.valid := io.csr.valid
    } else {
      if (i < params.dataReaderNum + params.dataWriterNum) {
        data_writer(
          i - params.dataReaderNum
        ).io.spatialStrides_csr_i.bits := io.csr.bits.spatialStrides_csr_i(i)
        data_writer(
          i - params.dataReaderNum
        ).io.spatialStrides_csr_i.valid := io.csr.valid
      } else {
        reader_writer_idx =
          (i - params.dataReaderNum - params.dataWriterNum) / 2
        reader_writer_idx_rw =
          (i - params.dataReaderNum - params.dataWriterNum) % 2
        data_reader_writer(
          reader_writer_idx
        ).io.spatialStrides_csr_i(reader_writer_idx_rw).bits := io.csr.bits
          .spatialStrides_csr_i(i)
        data_reader_writer(
          reader_writer_idx
        ).io.spatialStrides_csr_i(reader_writer_idx_rw).valid := io.csr.valid
      }
    }
  }

  // data reader and data writer <> address generation units interface
  for (i <- 0 until params.dataMoverNum) {
    if (i < params.dataReaderNum) {
      address_gen_unit(i).io.ptr_o <> data_reader(i).io.ptr_agu_i
      data_reader(i).io.addr_gen_done := address_gen_unit(i).io.done
      data_reader(i).io.zeroLoopBoundCase := address_gen_unit(
        i
      ).io.zeroLoopBoundCase
    } else {
      if (i < params.dataReaderNum + params.dataWriterNum) {
        address_gen_unit(i).io.ptr_o <> data_writer(
          i - params.dataReaderNum
        ).io.ptr_agu_i
        data_writer(
          i - params.dataReaderNum
        ).io.addr_gen_done := address_gen_unit(i).io.done
        data_writer(
          i - params.dataReaderNum
        ).io.zeroLoopBoundCase := address_gen_unit(i).io.zeroLoopBoundCase
      } else {
        reader_writer_idx =
          (i - params.dataReaderNum - params.dataWriterNum) / 2
        reader_writer_idx_rw =
          (i - params.dataReaderNum - params.dataWriterNum) % 2
        address_gen_unit(i).io.ptr_o <> data_reader_writer(
          reader_writer_idx
        ).io.ptr_agu_i(reader_writer_idx_rw)
        data_reader_writer(
          reader_writer_idx
        ).io.addr_gen_done(reader_writer_idx_rw) := address_gen_unit(i).io.done
        data_reader_writer(
          reader_writer_idx
        ).io.zeroLoopBoundCase(reader_writer_idx_rw) := address_gen_unit(
          i
        ).io.zeroLoopBoundCase
      }
    }
  }

  // data reader and data writer <> accelerator interface
  // with a queue between each data mover and accelerator data decoupled interface

  val ReaderFifo = Seq(
    (0 until params.dataReaderNum + params.dataReaderWriterNum).map { i =>
      if (i < params.dataReaderNum) {
        Module(
          new FIFO(
            params.fifoReaderParams(i).depth,
            params.fifoReaderParams(i).width,
            tagName
          )
        )
      } else {
        Module(
          new FIFO(
            params.fifoReaderWriterParams(i - params.dataReaderNum).depth,
            params.fifoReaderWriterParams(i - params.dataReaderNum).width,
            tagName
          )
        )
      }
    }: _*
  )

  val WriterFifo = Seq(
    (0 until params.dataWriterNum + params.dataReaderWriterNum).map { i =>
      if (i < params.dataWriterNum) {
        Module(
          new FIFO(
            params.fifoWriterParams(i).depth,
            params.fifoWriterParams(i).width,
            tagName
          )
        )
      } else {
        Module(
          new FIFO(
            params.fifoReaderWriterParams(i - params.dataWriterNum).depth,
            params.fifoReaderWriterParams(i - params.dataWriterNum).width,
            tagName
          )
        )
      }
    }: _*
  )

  var reader_writer_fifo_idx: Int = 0
  var reader_writer_acc_ports_idx: Int = 0
  for (i <- 0 until params.dataMoverNum) {
    if (i < params.dataReaderNum) {
      ReaderFifo(i).io.in <> data_reader(i).io.data_fifo_o
      ReaderFifo(i).io.out <> io.data.streamer2accelerator.data(i)
    } else {
      if (i < params.dataReaderNum + params.dataWriterNum) {
        data_writer(
          i - params.dataReaderNum
        ).io.data_fifo_i <> WriterFifo(i - params.dataReaderNum).io.out
        WriterFifo(
          i - params.dataReaderNum
        ).io.in <> io.data.accelerator2streamer
          .data(i - params.dataReaderNum)
      } else {
        reader_writer_idx =
          (i - params.dataReaderNum - params.dataWriterNum) / 2
        reader_writer_idx_rw =
          (i - params.dataReaderNum - params.dataWriterNum) % 2
        if (reader_writer_idx_rw == 0) {
          data_reader_writer(
            reader_writer_idx
          ).io.data_fifo_o <> ReaderFifo(
            (i - params.dataReaderNum - params.dataWriterNum) / 2 + params.dataReaderNum
          ).io.in
          ReaderFifo(
            (i - params.dataReaderNum - params.dataWriterNum) / 2 + params.dataReaderNum
          ).io.out <> io.data.streamer2accelerator.data(
            (i - params.dataReaderNum - params.dataWriterNum) / 2 + params.dataReaderNum
          )
        } else {
          data_reader_writer(
            reader_writer_idx
          ).io.data_fifo_i <> WriterFifo(
            (i - params.dataWriterNum - params.dataReaderNum) / 2 + params.dataWriterNum
          ).io.out
          WriterFifo(
            (i - params.dataWriterNum - params.dataReaderNum) / 2 + params.dataWriterNum
          ).io.in <> io.data.accelerator2streamer
            .data(
              (i - params.dataWriterNum - params.dataReaderNum) / 2 + params.dataWriterNum
            )
        }
      }
    }
  }

  // below does data reader and data writer <> TCDM interface

  // a scala function that flattens the sequenced tcdm ports
  // returns the list of (i,j,k) in which i is data mover index, j is the TCDM port index in ith data mover,
  // k is the overall TCDM port index from the TCDM point of view
  // for instance:
  // flattenSeq(Seq(2,3)) returns List((0,0,0), (0,1,1), (1,0,2), (1,1,3), (1,2,4))
  // flattenSeq(Seq(2,2)) returns List((0,0,0), (0,1,1), (1,0,2), (1,1,3))
  def flattenSeq(inputSeq: Seq[Int]): Seq[(Int, Int, Int)] = {
    var flattenedIndex = -1
    val flattenedSeq = inputSeq.zipWithIndex.flatMap { case (size, dimIndex) =>
      (0 until size).map { innerIndex =>
        flattenedIndex = flattenedIndex + 1
        (dimIndex, innerIndex, flattenedIndex)
      }
    }

    flattenedSeq
  }

  // data reader <> TCDM read ports
  val read_flatten_seq = flattenSeq(params.dataReaderTcdmPorts)
  for ((dimIndex, innerIndex, flattenedIndex) <- read_flatten_seq) {
    // read request to TCDM
    io.data.tcdm_req(flattenedIndex) <> data_reader(dimIndex).io.tcdm_req(
      innerIndex
    )

    // signals from TCDM responses
    data_reader(dimIndex).io.tcdm_rsp(innerIndex) <> io.data.tcdm_rsp(
      flattenedIndex
    )
  }

  // data writer <> TCDM write ports
  // TCDM request port bias based on the read TCDM ports number
  val write_flatten_seq = flattenSeq(params.dataWriterTcdmPorts)
  for ((dimIndex, innerIndex, flattenedIndex) <- write_flatten_seq) {
    // write request to TCDM
    io.data.tcdm_req(flattenedIndex + tcdm_read_ports_num) <> data_writer(
      dimIndex
    ).io.tcdm_req(innerIndex)
  }

  // data reader writer <> TCDM read and write ports
  val read_write_flatten_seq = flattenSeq(params.dataReaderWriterTcdmPorts)
  for ((dimIndex, innerIndex, flattenedIndex) <- read_write_flatten_seq) {
    // read request to TCDM
    io.data.tcdm_req(
      flattenedIndex + tcdm_read_ports_num + tcdm_write_ports_num
    ) <> data_reader_writer(dimIndex).io.tcdm_req(
      innerIndex
    )

    // signals from TCDM responses
    data_reader_writer(dimIndex).io.tcdm_rsp(innerIndex) <> io.data.tcdm_rsp(
      flattenedIndex + tcdm_read_ports_num + tcdm_write_ports_num
    )
  }
}
