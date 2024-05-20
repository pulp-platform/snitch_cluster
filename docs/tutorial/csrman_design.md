# CSR Manager

The **(1) Control-Status Register (CSR) manager** is a chisel-generated module to handle CSR transactions from the Snitch core to the accelerator. The accelerator only needs to comply with the CSR interface. The detailed diagram is shown below:

![image](https://github.com/KULeuven-MICAS/snitch_cluster/assets/26665295/97af01e6-fcb0-48f7-880c-8bfdb1166308)

There is a **(2) `snax_csr_wrapper`** which is a wrapper to combine signals from the Chisel-generated module. As you will see later in [Example CSR Generation](#example-csr-generation), the Chisel-generated SNAX CSR Manager will have several unpacked signals. The purpose of the wrapper is to pack these signals and make it easier to connect to other modules. Section [Connecting the Shell](./connect_shell.md) has more details about the wrappers.

# CSR Manager Interfaces

There are two sides to the CSR interfaces. First is the **(3) Snitch core interface** that handles transactions between the CPU core and the CSR manager. You control these interfaces using RISCV CSR instructions. This will be discussed in the [Programming Your Accelerator](./programming.md) section.

There are two sets of channels, the request channel and the response channel. The request channel is where you specify a write or read request to the CSR manager. The response channels are the responses of the CSR manager to the Snitch core. Both channels use the decoupled interface (valid-ready protocol). Each request and response signal channels are tagged with `req` and `rsp` in the table below:

|  signal name         |  channel type  | description                                  |
| :------------------: | :------------: | :------------------------------------------: |
| csr_req_addr_i[31:0] | req            |  Register address                            |
| csr_req_data_i[31:0] | req            |  Data to write unto the specified address    |
| csr_req_write_i      | req            |  Write/read signal: 1 = write, 0 = read      |
| csr_req_valid_i      | req            |  Transaction is valid                        |
| csr_req_ready_o      | req            |  CSR manager is ready to accept transactions |
| csr_rsp_data_o[31:0] | rsp            |  Data in response to reads                   |
| csr_rsp_valid_o      | rsp            |  Response data is valid                      |
| csr_rsp_ready_i      | rsp            |  Core side is ready to accept transactions   |


The second side is the **(4) accelerator datapath interface**. The CSR manager sends the configurations of the read-write (RW) registers through a decoupled interface. However, the accelerator may have read-only (RO) registers that are meant for status monitoring. These are directly wired from the accelerator towards the CSR manager but without the need for a decoupled interface. When a user reads one of the RO registers, the CSR manager directly transmits the wired RO signals to the response ports. The table below describes these signals:

|  signal name                      | description                                         |
| :-------------------------------: | :-------------------------------------------------: |
| csr_reg_rw_set_o [NumRwCsr][31:0] |  Packed RW configurations to send to accelerator    |
| csr_reg_set_valid_o               |  Configurations are valid                           |
| csr_reg_set_ready_i               |  Accelerator side is ready to accept configurations |
| csr_reg_ro_set_i [NumRoCsr][31:0] |  Packed RO register data                            |

The `NumRwCsr` and `NumRoCsr` pertain to the number of RW and RO registers, respectively. These are design-time parameters which we configure for the CSR manager. See section [Configuring the Generated CSR Manager](#configuring-the-generated-csr-manager)

# CSR Manager Features for SNAX ALU

The CSR manager has a set of read-write (RW) registers and read-only (RO) registers. Our CSR manager has a mechanism that bulk transfers a set of configurations to the main accelerator. The last RW register is always the start or send signal to transact all configurations into the accelerator. The figure below demonstrates this:

![image](https://github.com/KULeuven-MICAS/snitch_cluster/assets/26665295/b9c4758a-ad20-4e3b-86f8-5dc7b649df09)

In our [SNAX ALU accelerator](./accelerator_design.md), we have 2 main configuration RW registers: the mode and the data length to process. The 3rd RW register is the start that sends the configured settings to the accelerator data path. It is only when you assert the LSB of the last RW register (which we named as the start register) that the CSR manager transacts all configurations to the accelerator.

When the accelerator is not available to accept configuration transactions, the CSR holds the last transaction until it is successful. The timing diagram below shows this:

![image](https://github.com/KULeuven-MICAS/snitch_cluster/assets/26665295/bb31e9e5-4f80-4acc-b9ee-72f6866bec13)

The CSR manager is useful for double buffering. For example, when an accelerator is already processing an old configuration, the Snitch core can already configure new settings. This does not overwrite the old configuration. This is particularly useful in hiding CSR setup cycles because we can set up configurations while the accelerator is running.

The RO registers are read-only registers that the CSR manager can read from. These are mostly used for monitoring purposes like status or performance counters. The addresses of the RO registers are immediately after the RW registers. For example, the register table in [Accelerator Design](./accelerator_design.md) is copied below. Observe that all RO registers are after the RW registers.


|  register name  |  register addr  |   type  |                   description                       |
| :-------------: | :-------------: | :-----: |:--------------------------------------------------: |
|    mode         |       0         |   RW    | Operating modes: 0 - add, 1 - sub, 2 - mul, 3 - XOR |
|    length       |       1         |   RW    | Number of elements to process                       |
|    start        |       2         |   RW    | Set 1 to LSB only to start the accelerator          |
|    busy         |       3         |   RO    | Busy status. 1 - busy, 0 - idle                     |
|  perf. counter  |       4         |   RO    | Performance counter indicating number of cycles     |



# Configuring the Generated CSR Manager

You only need to specify the number of RW and RO registers of the CSR manager in the `snax-alu.hjson` configuration file. The snippet below shows the `snax_acc_cfg` dictionary:

```hjson
snax_acc_cfg: {
    snax_acc_name: "snax_alu"
    snax_tcdm_ports: 16,
    snax_num_rw_csr: 3,
    snax_num_ro_csr: 2,
    snax_streamer_cfg: {$ref: "#/snax_alu_streamer_template" }
},
```

The `snax_num_rw_csr` sets the number of RW CSRs while the `snax_num_ro_csr` sets the number of RO CSRs. These settings go into our accelerator wrapper script to generate Chisel parameters for generation. Then it automatically generates the CSR manager and stores it under the `./target/snitch_cluster/generated/snax_alu/` directory. See [Connecting the Shell](./connect_shell.md) for more details later.

# Example CSR Generation

This is a good time to test our wrapper generation and see the changes in the CSR manager. More details about the wrapper generation are in the [Connect The Shell](./connect_shell.md) section. Do the following (this assumes that you are running within the container):

1 - Go to the root directory.

2 - Run the command:

```bash
/repo/util/wrappergen/wrappergen.py --cfg_path="/repo/target/snitch_cluster/cfg/snax-alu.hjson" --tpl_path="/repo/hw/templates/" --chisel_path="/repo/hw/chisel/" --gen_path="/repo/target/snitch_cluster/generated/"
```

!!! note

    If you are working outside of the container, note that the `/repo` pertains to the root of the repository.

3 - Wait a while since this generates the CSR manager, streamer, and all other wrappers.

4 - When finished, navigate to `/repo/target/snitch_cluster/generated/snax_alu/`

5 - Open the file `snax_alu_csrman_CsrManager.sv`. This is the Chisel-generated file. It looks like a synthesized netlist. All modules required for the CSR manager are declared in this file. 

6 - Find the top module `snax_alu_csrman_CsrManager` within the `snax_alu_csrman_CsrManager.sv` file. Can you identify the signals discussed in this section?

- Which are the interfaces for the Snitch core?
- Which are the interfaces for the accelerator side?
- How many ports are generated for the RW registers?
- How many ports are generated for the RO registers?

7 - Find the generated wrapper `snax_alu_csrman_wrapper.sv`. Can you identify the following?

 - Can you see where the SNAX CSR manager is instanced?
 - Can you tell what the SNAX CSR wrapper is trying to fix?

# Try Modifying CSR Manager Yourself!

1 - Modify the number of RW and RO registers with the `snax_num_rw_csr` and `snax_num_ro_csr` parameters in the `snax-alu.hjson` file.

2 - Then re-generate again and see what changes are in both the Chisel-generated file and the wrapper file.
