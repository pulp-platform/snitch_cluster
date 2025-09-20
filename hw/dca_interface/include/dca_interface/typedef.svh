`ifndef DCA_INTERFACE_TYPEDEF_SVH_
`define DCA_INTERFACE_TYPEDEF_SVH_

`include "reqrsp_interface/typedef.svh"

`define DCA_REQ_CHAN_STRUCT(__data_width, __tag_width) \
  struct packed {                                      \
    logic [2:0][__data_width-1:0] dca_operands;        \
    fpnew_pkg::roundmode_e        dca_rnd_mode;        \
    fpnew_pkg::operation_e        dca_op_code;         \
    logic                         dca_op_mode;         \
    fpnew_pkg::fp_format_e        dca_src_format;      \
    fpnew_pkg::fp_format_e        dca_dst_format;      \
    fpnew_pkg::int_format_e       dca_int_format;      \
    logic                         dca_vector_op;       \
    logic [__tag_width-1:0]       dca_tag;             \
  }

`define DCA_RSP_CHAN_STRUCT(__data_width, __tag_width) \
  struct packed {                                      \
    logic [__tag_width-1:0]  dca_tag;                  \
    fpnew_pkg::status_t      dca_status;               \
    logic [__data_width-1:0] dca_result;               \
  }

`define DCA_REQ_STRUCT(__data_width, __tag_width) \
  `GENERIC_REQRSP_REQ_STRUCT(`DCA_REQ_CHAN_STRUCT(__data_width, __tag_width))

`define DCA_RSP_STRUCT(__data_width, __tag_width) \
  `GENERIC_REQRSP_RSP_STRUCT(`DCA_RSP_CHAN_STRUCT(__data_width, __tag_width))

`define DCA_TYPEDEF_REQ_CHAN_T(__name, __data_width, __tag_width) \
  typedef `DCA_REQ_CHAN_STRUCT(__data_width, __tag_width) __name``_req_chan_t;

`define DCA_TYPEDEF_RSP_CHAN_T(__name, __data_width, __tag_width) \
  typedef `DCA_RSP_CHAN_STRUCT(__data_width, __tag_width) __name``_rsp_chan_t;

`define DCA_TYPEDEF_ALL(__name, __data_width, __tag_width)   \
  `DCA_TYPEDEF_REQ_CHAN_T(__name, __data_width, __tag_width) \
  `DCA_TYPEDEF_RSP_CHAN_T(__name, __data_width, __tag_width) \
  `GENERIC_REQRSP_TYPEDEF_ALL(__name, __name``_req_chan_t, __name``_rsp_chan_t)

`endif // DCA_INTERFACE_TYPEDEF_SVH_
