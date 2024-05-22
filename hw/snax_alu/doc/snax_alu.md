# SNAX ALU Accelerator Datapath

The figure below shows the SNAX ALU datapath in more detail:

![image](https://github.com/KULeuven-MICAS/snitch_cluster/assets/26665295/53d9f0e7-656a-4754-80ac-674d7af9b2f3)

You can find all accelerator files under `./hw/snax_alu/src/.` directory. The main files are:

- `snax_alu_pe.sv` as the SNAX ALU Processing Element (PE)
- `snax_alu_csr.sv` as the main control-status-register (CSR) component
- `snax_alu_shell_wrapper.sv` as the top-level shell wrapper encapsulating the SNAX PEs, SNAX CSRs, and glue logic to interface between the CSR manager and the SNAX streamer.

Again, we label points of interest with numbers. We facilitate the discussion in a bottom-up approach to see how the accelerator is built:

## (1) SNAX ALU Processing Elements (PE)

The `snax_alu_pe` is the computing unit of the accelerator. The PE can do addition (+), subtraction (-), multiplication (X), and a bit-wise XOR (^). Each processing element takes in two data inputs, `a` and `b`. Each input with a parameter data width size `DataWidth`. By default `DataWidth=64`. The output is `c` of data width size `2*DataWidth` to accommodate the multiplication. The other operations leave the upper bits to 0.

(2) The inputs and outputs of the PE have a simple decoupled interface (valid-ready protocol). The ports only consist of a single `data` channel. The valid signal of the inputs comes from the streamers when the data is valid. The ready signal depends on the busy status register. When the valid signals of inputs `a` and `b` are high, then it combinationally sets the valid signal of output `c`. The ready signal of `c` comes from the streamer when it's ready to load data into the TCDM memory. The entire PE is fully combinational.

## (3) SNAX ALU CSR Register Set

The `snax_alu_csr` is a control and status register set with signals to modify the operation of the ALU PEs. It also contains a busy status signal and a simple performance counter. The table below shows the register set with addresses, type of register (`RW` for read-write and `RO` for read-only), and functional descriptions.

|  register name  |  register addr  |   type  |                   description                       |
| :-------------: | :-------------: | :-----: |:--------------------------------------------------: |
|    mode         |       0         |   RW    | Operating modes: 0 - add, 1 - sub, 2 - mul, 3 - XOR |
|    length       |       1         |   RW    | Number of elements to process                       |
|    start        |       2         |   RW    | Set 1 to LSB only to start the accelerator          |
|    busy         |       3         |   RO    | Busy status. 1 - busy, 0 - idle                     |
|  perf. counter  |       4         |   RO    | Performance counter indicating number of cycles     |

RW registers can read or write from the snitch core’s perspective. The values of these registers are input signals from the accelerator’s perspective, which can used for configurations and start signals that get to the main data path.

RO registers are read-only from the snitch core’s perspective .The values of these registers are output signals from the accelerator’s perspective. These are mostly used for monitoring purposes like status or performance counters. 

The mode signal is broadcast to all PEs to configure the kernel that each PE processes. The busy signal acts like an active state also broadcasted to all PEs. If it's high then the PEs set their input ready signals high to allow data to stream continuously. 

From the outside, a CSR manager (in this case our SNAX CSR manager) handles the read-and-write transactions from and to the accelerator's CSR register set. The `snax_alu_csr` also uses a decoupled interface but with all RW channels linked to the accelerator. The RO channels are wired directly without any decoupled interface. It is up to the accelerator designer to handle these operations.

## (4) SNAX ALU Shell Wrapper

The `snax_alu_shell_wrapper` is the main wrapper for encapsulating the processing elements, the CSR manager, and the glue logic to connect to the streamers. The top-level shell has configurable parameters tabulated below:

|  parameter    |       description                      | default values |
| :-----------: | :------------------------------------: | :------------: |
|  RegRWCount   | Number of RW registers                 | 3              |
|  RegROCount   | Number of RO registers                 | 2              |
|  NumPE        | Number of parallel PEs                 | 4              |
|  DataWidth    | INput data width of each PE            | 64             |
|  OutDataWidth | Output data width of each PE           | DataWidth*2    |
|  RegDataWidth | Data width of each register            | 32             |
|  RegAddrwidth | Address width for selecting a register | 32             |

For the CSR side, we have the RW and RO ports directly connecting the `snax_alu_csr` to the CSR manager. The RW ports have a decoupled interface to properly handle the register writes. The RO ports are directly wired to the CSR manager. The shell module's ports for the CSR are:

```verilog
//-------------------------------
// CSR manager ports
//-------------------------------
input  logic [RegRWCount-1:0][RegDataWidth-1:0] csr_reg_set_i,
input  logic                                    csr_reg_set_valid_i,
output logic                                    csr_reg_set_ready_o,
output logic [RegROCount-1:0][RegDataWidth-1:0] csr_reg_ro_set_o
```

To visualize this better, take note that the CSR register ports are packed signals. Referring to the SNAX ALU's RW register table above then we can "unpack" them to see:

```verilog
csr_reg_set_i [0] = mode;
csr_reg_set_i [1] = len;
csr_reg_set_i [2] = start;
```
The same concept goes for the RO register ports:

```verilog
busy         = csr_reg_ro_set[0];
perf_counter = csr_reg_ro_set[1];
```

The PEs that connect to an external data streamer have data signals (both input and output) concatenated together. (5) For the PEs that connect to an external data streamer, the PE data signals (both input and output) data channels decoupled interfaces. The module ports are:

```verilog
//-------------------------------
// Accelerator ports
//-------------------------------
// Note, we maintained the form of these signals
// just to comply with the top-level wrapper

// Ports from accelerator to streamer
output logic [(NumPE*OutDataWidth)-1:0] acc2stream_0_data_o,
output logic acc2stream_0_valid_o,
input  logic acc2stream_0_ready_i,

// Ports from streamer to accelerator
input  logic [(NumPE*DataWidth)-1:0] stream2acc_0_data_i,
input  logic stream2acc_0_valid_i,
output logic stream2acc_0_ready_o,

input  logic [(NumPE*DataWidth)-1:0] stream2acc_1_data_i,
input  logic stream2acc_1_valid_i,
output logic stream2acc_1_ready_o,

```

Where `stream2acc` and `acc2stream` indicate the input and output ports respectively. You could also treat `stream2acc` as read ports of the streamer and `acc2stream` as write ports to the streamer.

These ports are concatenated signals of the PEs. For example, consider the example where we have `NumPE=4` PEs and each PE can process `DataWidth` size per port (`2*DataWidth` for the output). Then SNAX streamer uses a data width of `4*DataWidth` for both inputs `A` (`stream2acc_0`) and `B` (`stream2acc_1`) . Then we split `A` and `B` contigiously into ports `a` and `b`, respectively. These are annotated with (2) and (5) in the figure. The output `C` is a concatenation of each `c` port. 

Any user attaching their accelerator to the SNAX platform must **create their own shell wrapper** with the correct CSR manager and streamer interfaces. This shell should serve as an example on how to attach the interfaces.

# What is a Decoupled Interface Anyway?

The decoupled interface uses two signals: `valid` and `ready` with the following rules.

- The initiator asserts `valid`. The assertion of `valid` **must not depend on**
  `ready`. However, `ready` may depend on `valid`.
- Once `valid` has been asserted all data must remain stable.
- The receiver asserts `ready` whenever it is ready to receive the transaction.
- When both `valid` and `ready` are high the transaction is successful.

This is an interface that is common in AXI protocol. You can find more details [here](https://vhdlwhiz.com/how-the-axi-style-ready-valid-handshake-works/).

# Some Exercises!!

<details>
  <summary> For the CSR interface connecting to the CSR manager, what are the important ports? </summary>
  We have the RW request and response ports: `csr_reg_set_i`, `csr_reg_set_valid_i`, and `csr_reg_set_ready_o`. Then, we have the RO port: `csr_reg_ro_set_o`. They also use valid-ready responses except for the RO port.
</details>

<details>
  <summary> What are the important ports of the accelerator <-> streamer interfaces? </summary>
  We have reader ports tagged with `stream2acc` names and writer ports tagged with `acc2stream` names. They also use valid-ready responses.
</details>

<details>
  <summary> What is the decoupled interface? </summary>
  The decoupled interface us a valid-ready protocol. A transaction is only successful when both valid and ready are high. 
</details>
