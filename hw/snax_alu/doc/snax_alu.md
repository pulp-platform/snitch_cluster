# SNAX ALU

This block is a simple ALU accelerator that consists of processing elements that can do +, -, x, and XOR functions. The figure below shows the SNAX ALU architecture:

![image](https://github.com/KULeuven-MICAS/snitch_cluster/assets/26665295/3ec09177-e7ac-4be9-a7b4-60386bc91c62)


# Main Modules

The three main modules for the architecture are **SNAX ALU Processing Element**, the **SNAX ALU CSR Register Set**, and the **SNAX Top Level ALU Shell Wrapper**.


## SNAX ALU Processing Element

The `snax_alu_pe` is the computing unit of the accelerator. Each processing element takes in two data inputs, `a` and `b`, each with a parameter data width size `DataWidth`. The ALU unit can do addition, subtraction, multiplication, and a bit-wise XOR. The output is `c` of data width size `2*DataWidth` to accommodate the multiplication. The other operations leave the upper bits to 0. At the top-most level, these signals are concatenated to accommodate the streamer ports.

## SNAX ALU CSR Register Set

The `snax_alu_csr` is a control and status register set with signals to modify the operation of the ALU PEs. It also contains a busy status signal and a simple performance counter. The table below shows the register set with addresses, type of register (RW for read-write and RO for read-only), and functional descriptions.


|  register name  |  register addr  |   type  |                   description                       |
| :-------------: | :-------------: | :-----: |:--------------------------------------------------: |
|    mode         |       0         |   RW    | Operating modes: 0 - add, 1 - sub, 2 - mul, 3 - XOR |
|    length       |       1         |   RW    | Number of elements to process                       |
|    start        |       2         |   RW    | Set 1 to LSB only to start the accelerator          |
|    busy         |       3         |   RO    | Busy status. 1 - busy, 0 - idle                     |
|  perf. counter  |       4         |   RO    | Performance counter indicating number of cycles     |

From the outside, a CSR manager (in this case our SNAX CSR manager) handles the read-and-write transactions from and to the accelerator's CSR register set. The `snax_alu_csr` uses a decoupled interface (valid-ready protocol) but with all RW channels linked to the accelerator. The RO channels are wired directly without any decoupled interface. It is up to the receiving end to handle these operations.


## SNAX Top Level ALU Shell Wrapper

The `snax_alu_shell_wrapper` is the all-encompassing top-level wrapper that combines the PEs and the CSR register set. From the CSR manager, we have the RW and RO ports directly connected to the `snax_alu_csr`. For the PEs that connect to an external data streamer, the PE data signals (both input and output) are first concatenated together.

For example, consider the example where we have 4 PEs and each PE can only process `DataWidth` size per port (`2*DataWidth` for the output). Then SNAX streamer uses a data width of `4*DataWidth` for both inputs `A` and `B`. Then we split `A` and `B` contigiously into ports `a` and `b` annotated with numbers from the figure. The output `C` is a concatenation of each `c` port. In Verilog, this is:

```verilog
  for (int i = 0; i < NumPE; i++) begin
    // De-concatenating the input signals
    a_split[i] = stream2acc_0_data_i[i*DataWidth+:DataWidth];
    b_split[i] = stream2acc_1_data_i[i*DataWidth+:DataWidth];

    // Concatenating the output signals
    acc2stream_0_data_o[i*DataWidth+:DataWidth] = c_split[i];
  end
```
The decoupled control signals are broadcasted and AND'd together. For the input side, all `valid` signals from the streamer to the accelerator input ports are broadcasted, while all `ready` signals are AND'd together. For the output side, all `valid` signals are AND'd towards the streamer and all `ready` signals from the streamer to accelerator PEs are broadcasted. The signals in the figure visualize these.

### Top-level Parameters

The top-level shell has configurable parameters tabulated below:

|  parameter    |       description                      |
| :-----------: | :------------------------------------: |
|  RegRWCount   | Number of RW registers                 |
|  RegROCount   | Number of RO registers                 |
|  NumPE        | Number of parallel PEs                 |
|  DataWidth    | Data width of each PE element          |
|  RegDataWidth | Data width of each register            |
|  RegAddrwidth | Address width for selecting a register |
