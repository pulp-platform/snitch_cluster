// Copyright 2024 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

<%
  import math

  tcdm_data_width = cfg["tcdm_data_width"]
  tcdm_depth = cfg["tcdm_depth"]
  num_banks = cfg["tcdm_num_banks"]
  tcdm_size = num_banks * tcdm_depth * (tcdm_data_width/8)
  tcdm_addr_width = math.ceil(math.log2(tcdm_size))
%>
<%def name="list_elem(prop)">\
  % for c in cfg["snax_streamer_cfg"][prop]:
${c}${', ' if not loop.last else ''}\
  % endfor
</%def>\
package snax.streamer

import snax.csr_manager._

import snax.utils._

import chisel3._
import chisel3.util._

/** Parameter definitions fifoWidthReader - FIFO width for the data readers
  * fifoDepthReader - FIFO depth for the data readers fifoWidthWriter - FIFO
  * width for the data writers fifoDepthWriter - FIFO depth for the data writers
  * dataReaderNum - number of data readers dataWriterNum - number of data
  * writers dataReaderTcdmPorts - the number of connections to TCDM ports for
  * each data reader dataWriterTcdmPorts - the number of connections to TCDM
  * ports for each data writer readElementWidth - single data element width for
  * each data reader, useful for generating unrolling addresses
  * writeElementWidth - single data element width for each data writer, useful
  * for generating unrolling addresses tcdmDataWidth - data width for each TCDm
  * port spatialBoundsReader - spatial unrolling factors (your parfor) for
  * each data reader spatialBoundsWriter - spatial unrolling factors (your
  * parfor) for each data writer temporalLoopDim - the dimension of the temporal
  * loop temporalLoopBoundWidth - the register width for storing the temporal
  * loop bound addrWidth - the address width stationarity - accelerator
  * stationarity feature for each data mover (data reader and data writer)
  */

// Streamer parameters
object StreamerParametersGen extends CommonParams {
  def temporalAddrGenUnitParams: TemporalAddrGenUnitParams =
    TemporalAddrGenUnitParams(
      loopDim = ${cfg["snax_streamer_cfg"]["temporal_addrgen_unit_params"]["loop_dim"]},
      loopBoundWidth = 32,
      addrWidth = ${tcdm_addr_width}
    )
  def fifoReaderParams: Seq[FIFOParams] = Seq(
% for idx in range(0,len(cfg["snax_streamer_cfg"]["fifo_reader_params"]["fifo_width"])):
    FIFOParams(\
${cfg["snax_streamer_cfg"]["fifo_reader_params"]["fifo_width"][idx]},\
${cfg["snax_streamer_cfg"]["fifo_reader_params"]["fifo_depth"][idx]})\
${', ' if not loop.last else ''}
% endfor
  )
  def fifoWriterParams: Seq[FIFOParams] = Seq(
% for idx in range(0,len(cfg["snax_streamer_cfg"]["fifo_writer_params"]["fifo_width"])):
    FIFOParams(\
${cfg["snax_streamer_cfg"]["fifo_writer_params"]["fifo_width"][idx]},\
${cfg["snax_streamer_cfg"]["fifo_writer_params"]["fifo_depth"][idx]})\
${', ' if not loop.last else ''}
% endfor
  )
  def dataReaderParams: Seq[DataMoverParams] = Seq(
% for idx in range(0,len(cfg["snax_streamer_cfg"]["data_reader_params"]["tcdm_ports_num"])):
    DataMoverParams(
      tcdmPortsNum = ${cfg["snax_streamer_cfg"]["data_reader_params"]["tcdm_ports_num"][idx]},
      spatialBounds = Seq(\
  % for c in cfg["snax_streamer_cfg"]["data_reader_params"]["spatial_bounds"][idx]:
${c}${', ' if not loop.last else ''}\
  % endfor
),
      spatialDim = ${cfg["snax_streamer_cfg"]["data_reader_params"]["spatial_dim"][idx]},
      elementWidth = ${cfg["snax_streamer_cfg"]["data_reader_params"]["element_width"][idx]},
      fifoWidth = fifoReaderParams(${idx}).width
    )${', ' if not loop.last else ''}
% endfor
  )
  def dataWriterParams: Seq[DataMoverParams] = Seq(
 % for idx in range(0,len(cfg["snax_streamer_cfg"]["data_writer_params"]["tcdm_ports_num"])):
    DataMoverParams(
      tcdmPortsNum = ${cfg["snax_streamer_cfg"]["data_writer_params"]["tcdm_ports_num"][idx]},
      spatialBounds = Seq(\
  % for c in cfg["snax_streamer_cfg"]["data_writer_params"]["spatial_bounds"][idx]:
${c}${', ' if not loop.last else ''}\
  % endfor
),
      spatialDim = ${cfg["snax_streamer_cfg"]["data_writer_params"]["spatial_dim"][idx]},
      elementWidth = ${cfg["snax_streamer_cfg"]["data_writer_params"]["element_width"][idx]},
      fifoWidth = fifoWriterParams(${idx}).width
    )${', ' if not loop.last else ''}
% endfor
  )
  def stationarity = Seq(${list_elem('stationarity')})
}

object StreamerTopGen {
  def main(args: Array[String]) : Unit = {
    val outPath = args.headOption.getOrElse("../../target/snitch_cluster/generated/.")
    emitVerilog(
      new StreamerTop(
        StreamerParams(
          temporalAddrGenUnitParams =
            StreamerParametersGen.temporalAddrGenUnitParams,
          fifoReaderParams = StreamerParametersGen.fifoReaderParams,
          fifoWriterParams = StreamerParametersGen.fifoWriterParams,
          stationarity = StreamerParametersGen.stationarity,
          dataReaderParams = StreamerParametersGen.dataReaderParams,
          dataWriterParams = StreamerParametersGen.dataWriterParams,
          tagName = "${cfg["tag_name"]}"
        )
      ),
      Array("--target-dir", outPath)
    )
  }
}
