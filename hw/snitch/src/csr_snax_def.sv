// verilog_lint: waive-start parameter-name-style
package csr_snax_def;
localparam logic [11:0] CSR_SNAX_BEGIN = 12'h3c0;
localparam logic [11:0] CSR_SNAX_END = 12'h5ff;
localparam logic [11:0] SNAX_CSR_BARRIER_EN = 12'h7c3;
localparam logic [11:0] SNAX_CSR_BARRIER = 12'h7c4;
endpackage
// verilog_lint: waive-stop parameter-name-style
