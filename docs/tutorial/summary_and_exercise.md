# Summarizing the Steps

Congratulations! You're now an expert in using the SNAX shell. Let's review the major steps you worked on.

1 - Building your accelerator.

- We first built the toy SNAX ALU accelerator.
- The important component is to have an accelerator shell that complies with the interface of our system.

2 - Configuring the CSR manager for your accelerator.

- Specifying the planned number of read-write (RW) and read-only (RO) registers.

3 - Configuring the streamer for your accelerator.

- Specifying the number of read and write ports of your accelerator.
- Configuring the data widths, FIFO depths, even the spatial parallelism considerations, etc.

4 - Configuring the system according to your needs.

- Attaching the accelerator configurations.
- Specifying the memory sizes.

5 - Setting up the file list and makefiles.

- Modifying the `Bender.yml` to add the file list.
- Modifying `Makefiles` 

6 - Programming your system.

- Making the C code.
- Making the data generation.
- Building the software.
- Run the RISC-V binary program

7 - Profiling your system.

- Using waveforms.
- Using stack tracing with `spike`.

# Summarizing Commands

For building hardware you do:

```bash
cd target/snitch_cluster
make CFG_OVERRIDE=cfg/snax-alu.hjson bin/snitch_cluster.vlt
```

For building software you do:

```bash
make CFG_OVERRIDE=cfg/snax-alu.hjson SELECT_RUNTIME=rtl-generic SELECT_TOOLCHAIN=llvm-generic sw
```

# You Need an Exercise to Get Strong!!!

With everything you've learned, let's do a simple exercise for a new accelerator! The figure below shows the accelerator data path of interest. This accelerator is built for you already but you need to integrate it into the SNAX system.

![image](https://github.com/KULeuven-MICAS/snax_cluster/assets/26665295/28f30943-75e0-455b-bb32-957651ba720e)

You can get the `snax_exercise` RTL files from the `snax-exercise-tutorial` branch.

```bash
git checkout snax-exercise-tutorial
```

## Accelerator Datapath Specifications

There are specific features for this accelerator:

- Let's name the accelerator `snax_exercise`

- Name your accelerator configuration file as `snax_exercise.hjson`

- The accelerator processes the kernel fully combinationally. Written in pseudo-code as:

```C
O = 0;
parfor (int i = 0; i < 8; i++):
    O += A[i]*B[i]
O += bias
```

- Take note that the `parfor` indicates that the MAC needs to be processed spatially in 8 parallel ports.

- The accelerator is an oversimplified MAC with a bias addition that takes in 16 inputs, 8 parallel ports for input A, and 8 parallel ports for input B.

- Each input port takes in 64 bits of data. Each input port for A and B is multiplied together and accumulated at the end. This should be done fully-combinationally.

- We also add a feature that adds a 64-bit fixed bias.

- Since the bias is 64 bits wide, you need to set the upper and lower bits of the bias through CSR registers.

- The output produces a single 128-bit output.

- For the inputs and outputs, make sure to comply with the decoupled interface.

- The CSR registers it has are tabulated below:

| register name     | register offset  | type    | description                                         |
| :---------------: | :--------------: | :-----: |:--------------------------------------------------- |
| upper bias        | 0                | RW      | Upper 32 bits of the bias.                          |
| lower bias        | 1                | RW      | Lower 32 bits of the bias.                          |
| num. of iter.     | 2                | RW      | Number of iterations to process.                    |
| accelerator start | 3                | RW      | Set 1 to LSB only to start the accelerator          |
| busy              | 4                | RO      | Busy status. 1 - busy, 0 - idle                     |
| perf. counter     | 5                | RO      | Performance counter indicating number of cycles     |

- There is a `snax_exercise_top.sv` which is the top module already of the data path shown above.

- The control side signals are unpacked registers but with the labels per port. They should correspond to the register table above.

```verilog
//-------------------------------
// Register RW from CSR manager
//-------------------------------
input  logic [RegDataWidth-1:0]   csr_rw_reg_upper_i,
input  logic [RegDataWidth-1:0]   csr_rw_reg_lower_i,
input  logic [RegDataWidth-1:0]   csr_rw_reg_len_i,
input  logic [RegDataWidth-1:0]   csr_rw_reg_start_i,
input  logic                      csr_rw_reg_valid_i,
output logic                      csr_rw_reg_ready_o,
//-------------------------------
// Register RO to CSR manager
//-------------------------------
output logic [RegDataWidth-1:0]   csr_ro_reg_busy_o,
output logic [RegDataWidth-1:0]   csr_ro_reg_perf_count_o,
```

- The data ports are packed signals. Observe that we have the 8 input ports of size `DataWidth`. We have only 1 output port of size `2*DataWidth`.

```verilog
//-------------------------------
// Data path IO
//-------------------------------
input  logic [7:0][DataWidth-1:0] a_i,
input  logic                      a_valid_i,
output logic                      a_ready_o,
input  logic [7:0][DataWidth-1:0] b_i,
input  logic                      b_valid_i,
output logic                      b_ready_o,
output logic [2*DataWidth-1:0]    out_o,
output logic                      out_valid_o,
input  logic                      out_ready_i
```


## CSR Manager and Streamer Specifications

For the CSR manager, you just need to ensure that the register configurations match that of the accelerator's register specs.

For the streamer, you have the following specifications:

- You need to feed 512 bits for each input port A and B. Then you split them inside the accelerator's data path, just like in the `snax_alu` example.

- This necessitates 16 TCDM ports for all the inputs.

- The output is just a single 128-bit port output and hence leads to 2 TCDM ports only.

- This leads to a total of 18 TCDM ports for the streamer.

- Use a depth of 16 for all FIFOs.

- Let's keep 1 loop dimension only.

## Your Goal

Since the accelerator is already prepared for you, your goals are to:

1. Create the `snax_exercise_shell_wrapper.sv` that complies with the interface of the generated `snax_exericse_wrapper.sv`.
2. Modify the necessary RTL setups: `snax_exercise.hjson`, `Bender.yml`, and the `Makefile` for handling HW builds.
3. Plan and create a simple C-code test, have your own data generation, and modify the necessary `Makefiles` for handling SW builds.
4. Run your code and see if it works!
5. Have fun!


