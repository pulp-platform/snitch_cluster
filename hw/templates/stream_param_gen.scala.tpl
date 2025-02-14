// Copyright 2024 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

<%
  import math

  tcdm_data_width = cfg["tcdm_data_width"]
  tcdm_depth = cfg["tcdm_depth"]
  num_banks = cfg["tcdm_num_banks"]
  tcdm_size = int(num_banks * tcdm_depth * (tcdm_data_width/8) / 1024)
  tcdm_addr_width = math.ceil(math.log2(tcdm_size))
%>
<%def name="list_elem(prop)">\
  % for c in cfg["snax_streamer_cfg"][prop]:
${c}${', ' if not loop.last else ''}\
  % endfor
</%def>\
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
% if "has_crossClockDomain" in cfg["snax_streamer_cfg"] and cfg["snax_streamer_cfg"]["has_crossClockDomain"]:
  def hasCrossClockDomain = true
% else:
  def hasCrossClockDomain = false
% endif

% if "data_reader_params" not in cfg["snax_streamer_cfg"]:
  def readerParams = Seq()
% else:
  def readerParams = Seq(
% for idx in range(0,len(cfg["snax_streamer_cfg"]["data_reader_params"]["spatial_bounds"])):
    new ReaderWriterParam(
      spatialBounds = List(
% for jdx in range(0,len(cfg["snax_streamer_cfg"]["data_reader_params"]["spatial_bounds"][idx])):
        ${cfg["snax_streamer_cfg"]["data_reader_params"]["spatial_bounds"][idx][jdx]}${',' if not loop.last else ''}
% endfor
      ),
      temporalDimension = ${cfg["snax_streamer_cfg"]["data_reader_params"]["temporal_dim"][idx]},
      tcdmDataWidth = ${tcdm_data_width},
      tcdmSize = ${tcdm_size},
% if "tcdm_logic_word_size" in cfg["snax_streamer_cfg"]["data_reader_params"]:
      tcdmLogicWordSize = Seq(
% for jdx in range(0,len(cfg["snax_streamer_cfg"]["data_reader_params"]["tcdm_logic_word_size"][idx])):
        ${cfg["snax_streamer_cfg"]["data_reader_params"]["tcdm_logic_word_size"][idx][jdx]}${',' if not loop.last else ''}
% endfor
      ),
% else:
      tcdmLogicWordSize = Seq(256),
% endif
      numChannel = ${cfg["snax_streamer_cfg"]["data_reader_params"]["num_channel"][idx]},
      addressBufferDepth = ${cfg["snax_streamer_cfg"]["data_reader_params"]["fifo_depth"][idx]},
      dataBufferDepth = ${cfg["snax_streamer_cfg"]["data_reader_params"]["fifo_depth"][idx]},
      % if "configurable_channel" in cfg["snax_streamer_cfg"]["data_reader_params"] and cfg["snax_streamer_cfg"]["data_reader_params"]["configurable_channel"][idx]:
      configurableChannel = true,
      % else:
      configurableChannel = false,
      % endif
      crossClockDomain = hasCrossClockDomain
${'   ), ' if not loop.last else '    )'}
% endfor
  )
% endif

% if "data_writer_params" not in cfg["snax_streamer_cfg"]:
  def writerParams = Seq()
% else:
  def writerParams = Seq(
% for idx in range(0,len(cfg["snax_streamer_cfg"]["data_writer_params"]["spatial_bounds"])):
    new ReaderWriterParam(
      spatialBounds = List(
% for jdx in range(0,len(cfg["snax_streamer_cfg"]["data_writer_params"]["spatial_bounds"][idx])):
        ${cfg["snax_streamer_cfg"]["data_writer_params"]["spatial_bounds"][idx][jdx]}${',' if not loop.last else ''}
% endfor
      ),
      temporalDimension = ${cfg["snax_streamer_cfg"]["data_writer_params"]["temporal_dim"][idx]},
      tcdmDataWidth = ${tcdm_data_width},
      tcdmSize = ${tcdm_size},
% if "tcdm_logic_word_size" in cfg["snax_streamer_cfg"]["data_writer_params"]:
      tcdmLogicWordSize = Seq(
% for jdx in range(0,len(cfg["snax_streamer_cfg"]["data_writer_params"]["tcdm_logic_word_size"][idx])):
        ${cfg["snax_streamer_cfg"]["data_writer_params"]["tcdm_logic_word_size"][idx][jdx]}${',' if not loop.last else ''}
% endfor
      ),
% else:
      tcdmLogicWordSize = Seq(256),
% endif
      numChannel = ${cfg["snax_streamer_cfg"]["data_writer_params"]["num_channel"][idx]},
      addressBufferDepth = ${cfg["snax_streamer_cfg"]["data_writer_params"]["fifo_depth"][idx]},
      dataBufferDepth = ${cfg["snax_streamer_cfg"]["data_writer_params"]["fifo_depth"][idx]},
      % if "configurable_channel" in cfg["snax_streamer_cfg"]["data_writer_params"] and cfg["snax_streamer_cfg"]["data_writer_params"]["configurable_channel"][idx]:
      configurableChannel = true,
      % else:
      configurableChannel = false,
      % endif
      crossClockDomain = hasCrossClockDomain
${'   ), ' if not loop.last else '    )'}
% endfor
  )
% endif

% if "data_reader_writer_params" not in cfg["snax_streamer_cfg"]:
  def readerWriterParams = Seq()
% else:
  def readerWriterParams = Seq(
% for idx in range(0,len(cfg["snax_streamer_cfg"]["data_reader_writer_params"]["spatial_bounds"])):
    new ReaderWriterParam(
      spatialBounds = List(
% for jdx in range(0,len(cfg["snax_streamer_cfg"]["data_reader_writer_params"]["spatial_bounds"][idx])):
        ${cfg["snax_streamer_cfg"]["data_reader_writer_params"]["spatial_bounds"][idx][jdx]}${',' if not loop.last else ''}
% endfor
      ),
      temporalDimension = ${cfg["snax_streamer_cfg"]["data_reader_writer_params"]["temporal_dim"][idx]},
      tcdmDataWidth = ${tcdm_data_width},
      tcdmSize = ${tcdm_size},
% if "tcdm_logic_word_size" in cfg["snax_streamer_cfg"]["data_reader_writer_params"]:
      tcdmLogicWordSize = Seq(
% for jdx in range(0,len(cfg["snax_streamer_cfg"]["data_reader_writer_params"]["tcdm_logic_word_size"][idx])):
        ${cfg["snax_streamer_cfg"]["data_reader_writer_params"]["tcdm_logic_word_size"][idx][jdx]}${',' if not loop.last else ''}
% endfor
      ),
% else:
      tcdmLogicWordSize = Seq(256),
% endif
      numChannel = ${cfg["snax_streamer_cfg"]["data_reader_writer_params"]["num_channel"][idx]},
      addressBufferDepth = ${cfg["snax_streamer_cfg"]["data_reader_writer_params"]["fifo_depth"][idx]},
      dataBufferDepth = ${cfg["snax_streamer_cfg"]["data_reader_writer_params"]["fifo_depth"][idx]},
      % if "configurable_channel" in cfg["snax_streamer_cfg"]["data_reader_writer_params"] and cfg["snax_streamer_cfg"]["data_reader_writer_params"]["configurable_channel"][idx]:
      configurableChannel = true,
      % else:
      configurableChannel = false,
      % endif
      crossClockDomain = hasCrossClockDomain
${'   ), ' if not loop.last else '    )'}
% endfor
  )
% endif

  def tagName = "${cfg["tag_name"]}_"
  def headerFilepath = "../../target/snitch_cluster/sw/snax/${cfg["snax_streamer_cfg"]["snax_library_name"]}/include"
}
