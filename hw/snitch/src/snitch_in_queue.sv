/// Floating Point Queue (instructions reading from int RF and writing to float RF)

module snitch_in_queue #(
  parameter int unsigned AddrWidth           = 32,
  parameter int unsigned DataWidth           = 32,

  parameter int unsigned Depth               = 32,
  /// Derived parameter *Do not override*
  parameter type addr_t = logic [AddrWidth-1:0],
  parameter type data_t = logic [DataWidth-1:0]
) (
  input  logic                 clk_i,
  input  logic                 rst_i,
  // IN to fifo input channel
  input  data_t                inq_qdata_i,   // Data to be written into IN queue
  input  logic                 inq_qvalid_i,  // Whether this data is valid
  output logic                 inq_qready_o,  // Whether the IN Queue is ready to take in data
  // fifo to IN output channel
  output data_t                inq_pdata_o,   // Data coming out of IN Queue
  output logic                 inq_pvalid_o,  // Whether this data is valid
  input  logic                 inq_pready_i   // Whether the int cc is ready to take in this data
);

  `include "common_cells/assertions.svh"

  logic is_full, is_empty;
  assign inq_qready_o = ~is_full;  // If FIFO is not full, ready to take input
  assign inq_pvalid_o = ~is_empty; // If FIFO is not empty, ready to be read

  fifo_v3 #(
    .FALL_THROUGH ( 1'b0   ),
    .DEPTH        ( Depth  ),
    .dtype        ( data_t )
  ) i_fifo (
    .clk_i,
    .rst_ni (~rst_i),
    .flush_i (1'b0),
    .testmode_i(1'b0),
    .full_o (is_full),
    .empty_o (is_empty),
    .usage_o (/* open */),
    .data_i (inq_qdata_i),  // Data that will be enqueued
    .push_i (inq_qvalid_i), // If valid data is available
    .data_o (inq_pdata_o),  // Data that will be popped
    .pop_i (inq_pready_i)   // If int cc is ready to read
  );


endmodule
