# SNAX Data Reshuffler Datapath

Even with efficient data streamers, the data layout in memory should be adapted to the accelerator's parallel data access needs. For example, when parallel inputs are lying within the same bank, even with data streamers, contention cannot be avoided unless we dynamically reshuffle the data. To efficiently support this, SNAX provides an optional dedicated data reshuffle accelerator, that supports parallel data transfers between different banks, as well as sub-word transposition. 


The figure below illustrates the SNAX data resuffler in more detail:

![image](https://github.com/KULeuven-MICAS/snax_cluster/assets/143962462/08be0ac4-4bcc-47ed-b304-36bf3dc1d230)


You can find all related files of resuffler under `./hw/snax_alu/src/.` directory. The main files are:

- `data_reshuffler.sv` as the procesing unit
- `snax_data_reshuffler_shell_wrapper.sv` as the top-level shell wrapper encapsulating the data reshuffler and glue logic to interface between the CSR manager and the SNAX streamer.

## (1) SNAX Data Reshuffler
In a single cycle, the `data reshuffler` can read a 512-bit package, i.e., `a_i`, via 16-port data streamer, which contains a data block of 8 by 8 bytes from a specific address in the shared memory, and simultaneously write back the transformed data block, i.e., `z_o`, to addresses dictated by a new data layout pattern programmed by the CSRs. As such, it achieves two-level data reshuffling within the data memory with minimal hardware overhead, which avoids frequent CPU-controlled data reorganization. The transpose option `csr_en_transpose_i` allows within-word reshuffling, by splitting each word into eight byte-sized vectors, and recombining them along the 8 ports, enabling byte-level data transposition.

## (2) SNAX Data Reshuffler Shell Wrapper

The `snax_data_reshuffler_shell_wrapper` is the main wrapper for encapsulating the data reshuffler and glue logic to interface between the CSR manager and the SNAX streamer. The top-level shell has configurable parameters tabulated below:

|  parameter    |       description                      | default values |
| :-----------: | :------------------------------------: | :------------: |
|  RegRWCount   | Number of RW registers                 | 2              |
|  RegROCount   | Number of RO registers                 | 0              |
|  RegDataWidth | Data width of each register            | 32             |
|  RegAddrwidth | Address width for selecting a register | 32             |

For the CSR side, we have the RW ports directly connecting to the CSR manager. The RW ports have a decoupled interface to properly handle the register writes. The shell module's ports for the CSR are:

```verilog
//-------------------------------
// CSR manager ports
//-------------------------------
input  logic [RegRWCount-1:0[RegDataWidth-1:0] csr_reg_set_i,
input logic                                    csr_reg_set_valid_i,
output logic                                    csr_reg_set_ready_o,
output logic [RegROCount-1:0][RegDataWidth-1:0] csr_reg_ro_set_o
```

The reshuffler that connects to an external data streamer have data signals (both input and output) concatenated together, which are decoupled interfaces. The module ports are:

```verilog
//-------------------------------
// Accelerator ports
//-------------------------------
// Note, we maintained the form of these signals
// just to comply with the top-level wrapper
// Ports from accelerator to streamer
output logic [(512)-1:0]acc2stream_0_data_o,
output logic acc2stream_0_valid_o,
input  logic acc2stream_0_ready_i,
// Ports from streamer to accelerator
input  logic [(512)-1:0]stream2acc_0_data_i,
input  logic stream2acc_0_valid_i,
output logic stream2acc_0_ready_o,
```

Where `stream2acc` and `acc2stream` indicate the input and output ports respectively. You could also treat `stream2acc` as read ports of the streamer and `acc2stream` as write ports to the streamer.

Any user attaching their accelerator to the SNAX platform must **create their own shell wrapper** with the correct CSR manager and streamer interfaces. This shell should serve as an example on how to attach the interfaces.

# What is a Decoupled Interface Anyway?

The decoupled interface uses two signals: `valid` and `ready` with the following rules.

- The initiator asserts `valid`. The assertion of `valid` **must not depend on**
  `ready`. However, `ready` may depend on `valid`.
- Once `valid` has been asserted all data must remain stable.
- The receiver asserts `ready` whenever it is ready to receive the transaction.
- When both `valid` and `ready` are high the transaction is successful.

This is an interface that is common in AXI protocol. You can find more details [here](https://vhdlwhiz.com/how-the-axi-style-ready-valid-handshake-works/).
