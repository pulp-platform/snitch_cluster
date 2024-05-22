# Streamer

The SNAX streamer is a Chisel-generated module to help streamline the data delivery from memory to the accelerator and vice versa. There is a [detailed streamer documentation](../../hw/chisel/doc/streamer.md), but in this tutorial section, we will only cover the high-level aspects and how to configure the streamer.


# Why Do We Need a Streamer?

Accelerators attain peak performance when data continuously streams into them; otherwise, they spend cycles waiting for data availability. Delays often occur due to mismatched data arrangements in shared memory or congestion among accelerators accessing the same banks concurrently.

It's crucial to differentiate between the data layout in memory and the access pattern of an accelerator. The figure below shows two data layouts and how an accelerator would get the data. 

![image](https://github.com/KULeuven-MICAS/snitch_cluster/assets/26665295/d59ace4e-7802-444f-99ee-c124abf2397b)

The memory address on the top-right corner is a guide to show the addresses of each data element. Assume each column represents a separate memory bank and each block signifies a data element, with each bank having only one read and one write access port.

The data layout refers to the arrangement of data contents in memory, while the access pattern pertains to how accelerators retrieve data from memory, such as contiguous or strided access.

On the left of the figure, the data layout in memory organizes the inputs and outputs on each bank. The accelerator's data access needs to be configured to access data continuously with appropriate memory address strides pointing to the memory addresses.

For example, if the data is arranged in data layout 1, input A needs to get data in addresses `[0, 4, 8, 12]` and in the exact order. That means the starting `base_address_a=0` and skip counts with `temporal_stride_a=4`. The `target_address_a` is computed in a simple loop:

```
for(i = 0; i < 4; i++):
  target_address_a = base_address_a + temporal_stride_a*i;
```

Another arrangement in data layout 2 shows that the data can be arranged contiguously. This time, input A accesses the data in the address sequence `[0,1,2,3]`. Here we set `base_address_a=0` and `temporal_stride_a=1`.

A more complicated example is when a streamer can get multiple data in parallel. This necessitates that we need to also have an address generation that can do spatial parallelism. Particularly it would be convenient to provide a base address and a stride but have all other ports automatically increment per accelerator port. The figure below shows an example accelerator that takes in 3 inputs in parallel and also produces 3 outputs in parallel:

![image](https://github.com/KULeuven-MICAS/snitch_cluster/assets/26665295/cd0e8c3e-3348-4b3e-81ee-e4e784af2965)

Consider the data layout 1. Each port of the accelerator needs to compute the target address as:

```
for(i = 0; i < 4; i++):
  target_address_a[0] = base_address_a + temporal_stride_a*i;
  target_address_a[1] = base_address_a + temporal_stride_a*i + 1;
  target_address_a[2] = base_address_a + temporal_stride_a*i + 2;
```

Where each `target_address_a[i]` pertains to the address of one port. Here, `base_address_a=0` and `temporal_stride_a=12`. Note that the temporal stride is different to accommodate the new memory addressing. Equivalently, we can also rewrite this with another loop and call it a `parfor` loop.

```
for(i = 0; i < 4; i++):
  # Parfor equivalent
  parfor(j = 0; j < 3; j++):
    target_address_a[j] = base_address_a + temporal_stride_a*i + spatial_stride_i*j;
```

We also define a `spatial_stride` to indicate the "skip-count" in the spatial dimension. For data layout 1 we use `spatial_stride_a=1`. Thus the equivalent sequences per port are:

```
target_address_a[0] = [0,12,24,36]
target_address_a[1] = [1,13,25,37]
target_address_a[2] = [2,14,26,38]
```

More specifically, in cycle 1, the addresses 0, 1, and 2 are generated. In cycle 2, the addresses 12, 13, 14 are generated, and so on.

This spatial stride is useful for parallel accesses. For example, accessing data for data layout 2 can be expressed using the same for loop but with `spatial_stride_a=2`. This results in the sequences below:

```
target_address_a[0] = [0,12,24,36]
target_address_a[1] = [2,14,26,38]
target_address_a[2] = [4,16,28,40]
```

Another example in data layout 3 shows that data is placed semi-contiguously in memory. To get the data in this manner, we need a second temporal loop bound. Such that:

```
for(i = 0; i < 2; i++):
  for(j = 0; j <2; j++):
    # Parfor equivalent
    parfor(k = 0; k < 3; k++):
      target_address_a[k] = base_address_a + temporal_stride_a_i*i + temporal_stride_a_j*j + spatial_stride_i*k;
```

Where `temporal_stride_a_i` is the stride for the outer temporal loop bound and `temporal_stride_a_j` is the stride for the inner temporal loop bound. We can set `temporal_stride_a_i=12` and `temporal_stride_a_j=3` to access data of data layout 3. This results in a sequence:

```
target_address_a[0] = [0,3,12,15]
target_address_a[1] = [1,4,13,16]
target_address_a[2] = [2,5,14,17]
```

Because data can be arranged differently in memory, a streamer becomes useful for configuring how to access that data. To alleviate the burden of an accelerator designer on building their streamer, we provide a design- and run-time configurable streamer, as will be shown in the section [Configuring the Generated Streamer](#configuring-the-generated-streamer). 

# Flexible Affine Address Generation

As discussed above, it is crucial to provide support for accelerators to access data in various places. Our SNAX streamer solves this through a flexible affine address generation. We can generalize the address generation for one input or output port with the pseudo-code below:

```
for(tb_n_1 = 0; tb_n_1 < temporal_bound[n-1]; tb_n_1++)
  for(tb_n_2 = 0; tb_n_2 < temporal_bound[n-2]; tb_n_2++)
   …
    for(tb_0 = 0; tb_0 < temporal_bound[0]; tb_0++)
     parfor(sb_m_1 = 0; sb_m_1 < spatial_bound[m-1]; sb_m_1++)
      parfor(sb_m_1 = 0; sb_m_2 < spatial_bound[m-2]; sb_m_1++)
       …
        parfor(sb_0 = 0; sb_0 < spatial_bound[0]; sb_0++)

          temporal_address = tb_n_1*temporal_stride[n-1] + tb_n_2*temporal_stride[n-2] + ... +
                             tb_1*temporal_stride[1] + tb_1*temporal_stride[0]
                        
          spatial_address = sb_n_1*spatial_stride[n-1] + sb_n_2*spatial_stride[n-2] + ... +
                            sb_1*spatial_stride[1] + sb_0*spatial_stride[0]

          target_address = base_address + temporal_address + spatial_address
```

Where `temporal_bound[*]` pertains to the bounds of the temporal loops and `tb_*` pertains to the temporal indices. The `spatial_bound[*]` pertains to the bounds of the spatial loops and `sb_*` pertains to the spatial indices. Group them according to `temporal_address` and `spatial_address` and add them to the `base_address` which results in the `target_address`.

The `temporal_bound[*]`, `tb_*`, and `sb_*` are run-time configurable. The number of the temporal loops and `sb_*` is design-time configurable.

The affine address generation is the working principle of the SNAX streamer. With this, we can flexibly access data in various places of the memory. 

# Streamer Microarchitecture

The figure below shows a more detailed architecture of the streamer. The **(1) streamer** sits between the TCDM interconnect and the accelerator as a flexible and efficient data movement unit. There is also a **(2) streamer wrapper** to re-wire the Chisel-generated signals. More details of the wrappers are in the [Building the Architecture](./build_system.md) section.

![image](https://github.com/KULeuven-MICAS/snitch_cluster/assets/26665295/e26af3c9-43f8-4de5-b07e-02dbacecc9fd)

## Streamer Interfaces

### **(3) TCDM interface** 

The **TCDM interface** has request and response channels and uses a decoupled interface. The table below describes the details of the request and response channels:

| signal name        | description                                |
| :-----------------:| :----------------------------------------: |
| tcdm_req_addr_o    | Target address in memory.                  |
| tcdm_req_data_o    | Data to write in memory.                   |
| tcdm_req_write_o   | Write enable signal. 1 = write, 0 = read.  |
| tcdm_req_strb_o    | Byte strobe.                               |
| tcdm_req_core_id_o | Core ID. Currently unused.                 |
| tcdm_req_is_core_o | Request from core.       Currently unused. |
| tcdm_req_valid_o   | Request channel is valid.                  |
| tcdm_req_ready_i   | Request channel is ready.                  |
| tcdm_rsp_data_i    | Response data coming from memory.          |
| tcdm_rsp_valid_i   | Response data is valid.                    |

!!! note

    Some of the signals are currently unused by the streamer. However, we needed to comply with the TCDM IP of the Snitch platform.

The response channel only has a `valid` signal but no `ready` signal. The TCDM assumes that the receiving end will always be ready. The streamer automatically handles these response data through FIFO buffers and makes sure no more new request is sent unless there is idle space to store the new responses.

### (4) Accelerator Interface

The accelerator interface connects the streamer to the accelerator. It only has a single data channel with a decoupled interface. There are two directions. We have the `acc2stream` and `stream2acc` interfaces which pertain to writing and reading directions, respectively. This means that `acc2stream` ports will always be for write directions only and `stream2acc` will always be for read directions only.

## Streamer Submodules

### (5) Data Movers

The core of the streamers are the data movers which handle all write or read transactions. Each mover contains a *data mover* for handling transactions with the TCDM interconnect, FIFO buffers for handling transactions with the accelerator, and an *Address Generation Unit* (AGU) for providing the affine address generation to the data mover.

We can also configure several settings for the streamers. This includes a number of read-and-write data movers, the depth of the FIFOs, and even the data widths to use for each accelerator port. These are design-time parameters. The section [Configuring the Generated Streamer](#configuring-the-generated-streamer) will demonstrate how to configure these.

### (6) Streamer CSR Manager

The streamer has its own *(5) streamer CSR manager* which functions the same way as the [CSR Manager](./csrman_design.md) for the accelerator. Therefore, it has its own set of registers that are mainly used for the affine address generation.

The number of registers varies depending on the configured parameters in the configuration file. The section [Configuring the Generated Streamer](#configuring-the-generated-streamer) talks more about how the configuration file generates the registers. For now, it is important to understand the general set of registers that exist in the CSR manager. The table below shows the list of registers with their corresponding type and description.

| register name           | type  | description                  |
| :---------------------: | :---- | :--------------------------- |
| temporal loop bounds    | RW    | Temporal loop bound for each temporal dimension. Can be more than 1 depending on several loop bounds indicated. |
| temporal loop strides   | RW    | Temporal loop strides for each temporal dimension. Can be more than 1 depending on the number of data movers. |
| spatial loop strides    | RW    | Spatial loop strides for each data mover for corresponding spatial dimension. The spatial dimension for each data mover can be different. It depends on the accelerator. |
| base pointer            | RW    | Base pointer for each data mover |
| start streamer          | RW    | This is the last RW register to transfer configurations to the actual streamer CSRs. |
| performance counter     | RO    | Single performance counter which tracks how many cycles the streamer ran. |

# Configuring the Generated Streamer

There are two things to consider when we configure the streamers: first is the microarchitecture and second are the CSR registers that it generates. It is important to configure the streamer to what your accelerator needs.

## SNAX ALU Streamer Microarchitecture
For our SNAX ALU accelerator, we want the streamer to have the microarchitecture shown in the figure below:

![image](https://github.com/KULeuven-MICAS/snitch_cluster/assets/26665295/156e30c3-c682-4f01-b801-fee5ba7bb139)

Some notable characteristics:
- We need two reader ports each with a data width that is 256 bits wide. We also want to use 8 FIFO buffers for each reader port. The SNAX ALU will have 4 PEs in parallel each taking in 64 bits of data in each PE. Hence, the a need for a 256-bit wide reader port.
- We need one writer port with a data width of 512 bits and uses 8 FIFO buffers. The SNAX ALU output is double the data width: 128 bits per port of a PE and hence with 4 PEs results in 512 bits-wide write port.
- We only need one temporal loob bound for this streamer. 
- The general affine address generation for this streamer is:

```
for(i = 0; i < N; i++):
  # Parfor equivalent
  parfor(j = 0; j < 4; j++):
    target_address_a[j] = base_address_a + temporal_stride_a*i + spatial_stride_i*j;
```

## SNAX ALU Streamer Configuration
Recall that from the `snax-alu.hjson`, the `snax_acc_cfg` contains a `snax_streamer_cfg` which references a streamer template. The `snax_acc_cfg` is shown below for reference:

```hjson
snax_acc_cfg: {
  snax_acc_name: "snax_alu"
  snax_module: "snax_alu_wrapper",
  snax_tcdm_ports: 16,
  snax_num_rw_csr: 3,
  snax_num_ro_csr: 2,
  snax_streamer_cfg: {$ref: "#/snax_alu_streamer_template" }
},
```

If you scroll down to the bottom of the configuration file, you should see the `snax_alu_streamer_template` dictionary set. This template describes the streamer configurations. Let's go through each component.


The `temporal_addrgen_unit_params` component with `loop_dim` generates the number of temporal loop bounds. Since it's just 1, then we only have 1 temporal loop bound.

```hjson
temporal_addrgen_unit_params: {
  loop_dim: 1,
}
```

The `fifo_reader_params` and `fifo_writer_params` configure the FIFOs. Take note that the FIFOs are directly connected to the accelerator interface. It consists of the `fifo_width` which configures the datawidth of the accelerator interface ports. It also has the FIFO depths `fifo_depth` which configures the depth of the FIFOs.

```hjson
fifo_reader_params: {
  fifo_width: [256, 256],
  fifo_depth: [8, 8],
}

fifo_writer_params: {
  fifo_width: [512],
  fifo_depth: [8],
}
```

The `data_reader_params` and `data_writer_params` effectively configure the TCDM interface ports. It consists of `tcdm_ports_num` which controls how many TCDM ports are needed. The `spatial_bounds` pertain to the spatial unrolling factors (your parfor) for each data mover. The `spatial_dim` is the dimension of spatial unrolling factors (your parfor) for each data mover. The `element_width` is the single data element width for each data mover, useful for generating spatial addresses.

```hjson
data_reader_params:{
  tcdm_ports_num: [4, 4],
  spatial_bounds: [[4], [4]],
  spatial_dim: [1,1],
  element_width: [64,64],
}

data_writer_params:{
  tcdm_ports_num: [8],
  spatial_bounds: [[8]],
  spatial_dim: [1],
  element_width: [64],
}
```

The number of elements in a list pertains to how many data movers there are. For example, there are 2 elements in the `data_reader_params` and therefore it instantiates two read data movers. There is only 1 element in the `data_writer_params` and hence only instantiates 1 write data mover.

Finally, there is the `stationarity` configuration which is for stationarity for each data mover. If the stationarity bit is set, the innermost loop for that data mover is set to 1. This does not instantiate anything but rather affects the loop bound for a data mover. It only fixes the loop bound to 1. This is a special case scenario only, such as for output-stationary or weight-stationary accelerators. In the SNAX ALU, this is 0. 

## SNAX ALU Streamer CSRs

Based on the configuration file we expect the CSR registers to have:

- 1 register for a single loop bound as specified in the `temporal_addrgen_unit_params -> loop_dim = 1`. If the number is 2 then we would have 2 loop bounds.
- 3 temporal stride registers, 3 spatial stride registers, and 3 base address pointers since we have 3 data movers in total (2 read data movers and 1 write data mover).
- 1 start register to start the streamer.
- 1 performance counter register for how many cycles the streamer was active.

Below is a tabulated version of the CSRs of the streamers with the register offset addresses, type, and description:

|  register name      |  register offset  |   type  |                   description                             |
| :-----------------: | :-------------:   | :-----: |:--------------------------------------------------------- |
| temporal loop bound |       0           |   RW    | Temporal loop bound for address generation                |
| temporal stride 0   |       1           |   RW    | Temporal stride for input A                               |
| temporal stride 1   |       2           |   RW    | Temporal stride for input B                               |
| temporal stride 2   |       3           |   RW    | Temporal stride for output OUT                            |
| spatial stride 0    |       4           |   RW    | Spatial stride for input A                                |
| spatial stride 1    |       5           |   RW    | Spatial stride for input B                                |     
| spatial stride 2    |       6           |   RW    | Spatial stride for output OUT                             |     
| base addr 0         |       7           |   RW    | Base address for input A                                  |
| base addr 1         |       8           |   RW    | Base address for input B                                  |
| base addr 2         |       9           |   RW    | Base address for output OUT                               |
| start               |       10          |   RW    | Start register to send configurations and start streaming |
| perf. counter       |       11          |   RO    | Performance counter indicating the number of cycles ran   | 


# Example Streamer Generation

This is a good time to test our wrapper generation and see the changes in the CSR manager. More details about the wrapper generation are in the [Building the Architecture](./build_system.md) section. Do the following (this assumes that you are running within the container):

1 - Go to the root directory.

2 - Run the command:

If you are working in Codespaces:

```bash
/workspaces/snax_cluster/util/wrappergen/wrappergen.py --cfg_path="/workspaces/snax_cluster/target/snitch_cluster/cfg/snax-alu.hjson" --tpl_path="/workspaces/snax_cluster/hw/templates/" --chisel_path="/workspaces/snax_cluster/hw/chisel/" --gen_path="/workspaces/snax_cluster/target/snitch_cluster/generated/"
```

If you are working in a docker container:

```bash
/repo/util/wrappergen/wrappergen.py --cfg_path="/repo/target/snitch_cluster/cfg/snax-alu.hjson" --tpl_path="/repo/hw/templates/" --chisel_path="/repo/hw/chisel/" --gen_path="/repo/target/snitch_cluster/generated/"
```

!!! note

    If you are working outside of the container, note that the `/repo` pertains to the root of the repository.

3 - Wait a while since this generates the CSR manager, streamer, and all other wrappers.

4 - When finished, navigate to `./target/snitch_cluster/generated/snax_alu/`

5 - Open the file `snax_alu_streamer_StreamerTop.sv`. This is the Chisel-generated file. It looks like a synthesized netlist. All modules required for the streamer are declared in this file. 

6 - Find the top module `snax_alu_streamer_StreamerTop` within the `snax_alu_streamer_StreamerTop.sv` file. Can you identify the signals discussed in this section?

<details>
  <summary> Which are the interfaces for the accelerator side? </summary>
  All signals with `*_streamer2accelerator_*` and `*_accelerator2streamer_*` in their signal names.
</details>

<details>
  <summary> Can you identify which are for the write and read ports? </summary>
  Signals with `*_streamer2accelerator_*` are for read ports and signals with `*_accelerator2streamer_*` are for write ports.
</details>

<details>
  <summary> How many are for write ports and how many are for read ports? </summary>
  There are 2 read ports (`*_streamer2accelerator_*`) and 1 write port (`*_accelerator2streamer_*`).
</details>

<details>
  <summary> Which are the interfaces for the TCDM side? </summary>
  All signals with `*_tcdm_*` in their signal names.
</details>

<details>
  <summary> How many TCDM ports are there? </summary>
  16 TCDM ports for both request and response channels.
</details>

7 - In the same `snax_alu_streamer_StreamerTop.sv` file find the `snax_alu_streamer_CsrManager` module. This is the CSR manager of the streamer.

<details>
  <summary> Can you verify and count how many RW and RO ports there are? </summary>
  Referring to the table above, there should be 11 RW ports and 1 RO port. In the streamer's CSR manager it shows only 10 but the 11 is just not outputted. There is only 1 RO port.
</details>

<details>
  <summary> Why do you think the start register is missing in the listed ports? </summary>
  Because it only sends the register set configuration to the accelerator data path.
</details>

<details>
  <summary> Which register offset do you think pertains to the spatial stride for input A? </summary>
  Referring to the table above, it should be number 4.
</details>

8 - Find the generated wrapper `snax_alu_streamer_wrapper.sv`. 

<details>
  <summary> Can you see where the Chisel-generated streamer is instanced? </summary>
  Yes! It should be with the instance name `i_snax_alu_streamer_top`.
</details>

<details>
  <summary> Can you tell what the SNAX streamer wrapper is trying to fix? </summary>
  It's basically repacking the unpacked signals of the Chisel-generated file into packed signals for easy integration in System Verilog.
</details>

# Try Modifying the Streamer!

Let's try a simple exercise but we will spoil the answer to you already. Suppose we want the following streamer characteristics:
- 2 temporal loop bounds
- 1 reader and 1 writer that takes in 8 parallel inputs (and outputs) each 64 bits wide and with a FIFO depth of 16.
- 8 TCDM ports for each reader and writer.

The configuration streamer template should look like this:

```hjson
snax_test_template :{

  temporal_addrgen_unit_params: {
    loop_dim: 2,
  }

  fifo_reader_params: {
    fifo_width: [512],
    fifo_depth: [16],
  }

  fifo_writer_params: {
    fifo_width: [512],
    fifo_depth: [16],
  }

  data_reader_params:{
    tcdm_ports_num: [8],
    spatial_bounds: [[8]],
    spatial_dim: [1],
    element_width: [64],
  }

  data_writer_params:{
    tcdm_ports_num: [8],
    spatial_bounds: [[8]],
    spatial_dim: [1],
    element_width: [64],
  }

  stationarity: [0,0]
}
```
Microarchitecturally, the streamer would look like the figure below:

![image](https://github.com/KULeuven-MICAS/snitch_cluster/assets/26665295/0776d3b8-79d7-4a37-ba30-f60f8ca026f4)

Some details include:
- Since there are 8 parallel ports for the input and output then the accelerator interfaces would have 512-bit channels.
- Each FIFO would have a depth of 16.
- There would be 8 TCDM ports in the TCDM interface for each input and output data movers.

In terms of CSR registers, the streamer would have the following:

|  register name                 |  register offset  |   type  |                   description                            |
| :----------------------------: | :---------------: | :-----: |:-------------------------------------------------------- |
| temporal loop bound 0          |       0           |   RW    | First temporal loop bound                                |
| temporal loop bound 1          |       1           |   RW    | second temporal loop bound                               |
| temporal stride 0 for bound 0  |       2           |   RW    | Temporal stride for loop bound 0 for input               |
| temporal stride 1 for bound 0  |       3           |   RW    | Temporal stride for loop bound 0 for output              |
| temporal stride 0 for bound 1  |       4           |   RW    | Temporal stride for loop bound 1 for input               |
| temporal stride 1 for bound 1  |       5           |   RW    | Temporal stride for loop bound 1 for output              |
| spatial stride 0               |       6           |   RW    | Spatial stride for input                                 |
| spatial stride 1               |       7           |   RW    | Spatial stride for output                                |        
| base addr 0                    |       8           |   RW    | Base address for input                                   |
| base addr 1                    |       9           |   RW    | Base address for output                                  |
| start                          |       10          |   RW    | Start register to send configurations                    |
| perf. counter                  |       11          |   RO    | Performance counter indicating the number of cycles ran  | 

Because we now have two temporal loop bounds, the temporal stride registers are also doubled. We need two temporal strides, one for input and one for output, for each temporal loop bound. Therefore there are a total of 2 temporal strides for the first loop bound and another 2 temporal strides for the second loop bound.

Finally, the affine address generation that this streamer can do is:

```
for(i = 0; i < N; i++):
  for(j = 0; i < M; j++):
    # Parfor equivalent
    parfor(k = 0; k < 8; k++):
      temporal_address = temporal_stride_i*i + temporal_stride_j*j
      spatial_address = spatial_stride*k
      target_address = base_address + temporal_address + spatial_address
```

Finally, one can calculate the number of CSR registers of the streamer with:

``` Python
# Total number of temporal loop dimensions
num_loop_dim = snax_streamer_cfg["temporal_addrgen_unit_params"]["loop_dim"]

# Total number of data movers
num_data_mover = len(snax_streamer_cfg["data_reader_params"]["tcdm_ports_num"]) + len(snax_streamer_cfg["data_writer_params"]["tcdm_ports_num"])

# This is essentially the total number of temporal loops and data movers combined
num_dmove_x_loop_dim = num_data_mover * num_loop_dim

# Total number of spatial registers
num_spatial_dim = sum(snax_streamer_cfg["data_reader_params"]["spatial_dim"]) + sum(snax_streamer_cfg["data_writer_params"]["spatial_dim"])

# Total number of registers!
# The last two +1 are for the start register and the performance counter
streamer_csr_num = num_loop_dim + num_dmove_x_loop_dim + num_data_mover + num_spatial_dim + 1 + 1
```
