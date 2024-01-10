# SNitch Acceleration eXtension (SNAX) Cluster Documentation

This section discusses the modifications to the Snitch cluster to makthe acceleration extensions as easy as possible. The figure below shows a simplified figure of the SNAX architecture.

![SNAX Cluster](https://drive.google.com/uc?id=1PqMhcxbqWnJdn-EawCfGetc0CbqfFCK_)

The SNAX cluster is a shell that provides the fundamental needs of an accelerator:

* A manager core (Snitch core) used to control the accelerator.
* A memory which accelerators can stream data to and from. The number of TCDM ports connected to the accelerator is parametrizable.
* An interconnect shell that can connect to other SNAX or Snitch clusters.

These basic components allow users to conveniently create their own heterogenous architecture.

## Architectural Modifications

There are three modifications in the SNAX cluster:

1. Adding CSR decoding for the SNAX control.
2. Attaching the Snitch accelerator ports to control the accelerator.
3. Adding TCDM ports to the accelerator's memory ports.

The figure below shows a zoomed-in visualization highlighting the changes in the original Snitch micro-architecture:

![SNAX modifications](https://drive.google.com/uc?id=11dr-GN-QwNBFIywlYFiX9Mdg9COQ_2vU)


### CSR Decoding

The [RISCV ISA](https://drive.google.com/file/d/1s0lZxUZaa7eV_O0_WsZzaurFLLww7ou5/view?usp=drive_link) has a standard for control and status register (CSR) instructions. Check the section about Zicsr in the specification document. In SNAX, we assume that each custom accelerator has its own CSRs. In the RISCV CSR instructions, we just specify the target CSR address and the value we want to write unto that address. Using CSRs is a more general and configurable approach as opposed to writing custom instructions. Note that these instructions treat the CSRs via register-mapped IOs. 

!!! note

    Using custom instructions allows users to create a co-processor because the control is tightly embedded in the Snitch decoder. It is possible to pack more information in the custom instructions. However, this requires each Snitch core's decoder to have that custom instruction even when a different accelerator is attached. Moreover, RISCV compilers need to always update to include these instructions. The CSR approach only requires us to provide the CSR addresses since RISCV ISA has a standard for CSR instructions.

The RISCV CSR instruction has a 12-bit CSR address. There are other existing CSRs in Snitch, but we reserved CSR addresses `[0x3c0:0x5ff]` giving us a total of 575 different registers to use. Note that the Snitch does not instantiate any registers. Rather it offloads the CSR reads and writes unto the accelerator's.

For example the table below describes the the [HWPE MAC engine](https://github.com/KULeuven-MICAS/hwpe-mac-engine) CSRs. First, we consider the `CSR Address Offset` which we add to any reserved register space. For example, if we allocate `[0x3c0:0x3d7]` space for the entire register mapping of the HWPE, then we have the equivalent `CSR Address` listed in the third column. Any user has the freedom to set these mappings as long as it is consistent with the register spacing they need.

| Register          | CSR Address Offset | CSR Address if <br /> Starting from `0x3c0`  | Description                                                             |
| ----------------- | -----------------  | -------------------------------------------- |-----------------------------------------------------------------------  |
| Trigger           | 0                  | 0x3c0                                        | Write 0 to start                                                        |
| Acquire           | 1                  | 0x3c1                                        | Lock the accelerator                                                    |
| Finsihed          | 2                  | 0x3c2                                        | Finished signal (1 pulse only)                                          |
| Status            | 3                  | 0x3c3                                        | 1: busy; 0: free                                                        |
| Running           | 4                  | 0x3c4                                        | 1: running; 0: free                                                     |
| Softclear         | 5                  | 0x3c5                                        | write 1 to reset the accelerator                                        |
| Reserved          | 6                  | 0x3c6                                        | Reserved                                                                |
| SWEVT             | 7                  | 0x3c7                                        | Events                                                                  |
| Generic           | 8-15               | 0x3c8 - 0x3cf                                | General purpose registers (RW access)                                   |
| Address A         | 16                 | 0x3d0                                        | Starting address for input A                                            |
| Address B         | 17                 | 0x3d1                                        | Starting address for input B                                            |
| Address C         | 18                 | 0x3d2                                        | Starting address for input C                                            |
| Address D         | 19                 | 0x3d3                                        | Starting address for output D                                           |
| Iterations        | 20                 | 0x3d4                                        | Number of iterations                                                    |
| Vector Length     | 21                 | 0x3d5                                        | Number of elements                                                      |
| Multiplier Mode   | 22                 | 0x3d6                                        | 1: $d_i = a_i \cdot b_i$;  <br /> 0: $D = ( \sum a_i \cdot b_i) + C$    |
| Vector Stide      | 23                 | 0x3d7                                        | Vectore tride                                                           |

There are no registers in the unused addresses `[0x3d8:0x5ff]`. However, a user can utilize the unused addresses for their needs.

### Snitch Accelerator Ports

The Snitch has accelerator ports that connect to the co-processors or accelerator units like the floating point sub-system (FPSS), integer processing units (IPU), stream semantic registers (SSRs), and also the DMA. The SNAX version also uses the same ports to control any custom accelerator. The figure below shows the the Snitch / SNAX ports for controlling an acccelerator:

![Accelerator Request Response Ports](https://drive.google.com/uc?id=18QRV3U6FrEvX3-0q908MgRKv-pq02eKq)

There are two channels, the request and response channels. The request channels are used for sending data and control from the Snitch core to the accelerator. The response channel is the return channel if the request command requires data to be sent back to the Snitch core. The tables below describe the request and response channels.

#### Request Channels

| Signal            | Description                                                                                                   | 
| ----------------- | ------------------------------------------------------------------------------------------------------------  |
| addr              | Accelerator address. SNAX ports is 5.                                                                         |
| id                | Transaction ID that is equal to the destination register specified in the custom or CSR instruction.          |
| data_op           | The RISCV instruction that was executed.                                                                      |
| data_arga         | The rs1 field of the custom or CSR RISCV instruction executed.                                                |
| data_argb         | The rs2 field of the custom or CSR RISCV instruction executed.                                                |
| data_argc         | The rs3 field of the custom RISCV instruction executed. <br />  Snitch SSR instructions have an rs3 field.    |
| snax_qvalid       | Request valid signal.                                                                                         |
| snax_qready       | Request ready signal.                                                                                         |

#### Response Channels

| Signal            | Description                                                                                                   | 
| ----------------- | ------------------------------------------------------------------------------------------------------------  |
| id                | Transaction ID that is equal to the destination register specified in the requested custom or CSR instruction.|
| error             | Error signal.                                                                                                 |
| data              | The return value of the requested transaction.                                                                |
| snax_pvalid       | Response valid signal.                                                                                        |
| snax_pready       | Response ready signal.                                                                                        |

### CSR Instruction and Accelerator Port Mapping

It is important to know how to map the CSR instruction into the request and response channel ports. For example, consider the `csrrw` instruction:

```asm
csrrw rd, csr_addr, rs1
```

Where `csrrw` is a CSR read-write instruction which reads the current data located at `csr_addr` and stores it in `rd` and writes the data `rs1` at `csr_addr` simultanesouly. The `csr_addr` is a 12-bit unsigned value (e.g., `0x3c0`). This instruction maps to the request channel as:

* `addr` - will point to the accelerator port (e.g., 0 is for the FPSS, 1 is for the shared multiply and divide, and 5 is for SNAX ports. Always use 5 if you want to use the SNAX accelerator ports.).
* `id` - will be the register number `rd` (not the contents of `rd`).
* `data_op` - is the machine code for the CSR instruction (e.g., the machine code equivalent of `csrrw rd, csr_addr, rs1`).
* `data_arga` - will contain `csr_addr`.
* `data_argb` - will contain the contents of `rs1`.
* `data_argc` - not used for SNAX but used in SSR.

Then for the response ports we have:

* `id` - this indicates which destination register should the `data` be stored. This is equivalent to the requested `rd`.
* `error` - this is custom to the accelerator.
* `data` - the data returned by the request.

### Timing Diagram for Request and Response

The section [Request and Response](reqrsp_interface.md) discusses the valid-ready handshake. It is used for the request and response channels. Below are some sample timing diagrams for the request and response ports.

![SNAX accelerator ports](https://drive.google.com/uc?id=1ORWy6HhMxf3Q21EetJjOpklhCiqumZyX)

In the figure above, observe the following:

* The transaction only progresses when `valid` and `ready` signals for each `request` and `response` ports are both high. The transaction progresses, otherwise, cycles are stalled.
* In the request channel:
    * `addr` has 5 set to it because it goes into the SNAX accelerator ports. This is fixed.
    * `id` pertains to the destination register `r3`.
    * `data_arga` is the CSR address `0x3c0`
    * `data_argb` contains the contents inside register `r1`
    * `data_argc` is unused for SNAX.
* In the response channel:
    * `id` returned comes from the original request which was `r3`.
    * `error` is 0 but can be any number depending on response.
    * `data` is whatever the accelerator returns back. It's possible that write only requests don't need to return anything back.


### Snitch TCDM Ports

The Snitch TCDM ports function similarly like the accelerator request-response ports. The figure below shows the TCDM connection:

![SNAX TCDM ports](https://drive.google.com/uc?id=1GWrK3lolX0v89iy3oNbgR8guhpaXnRFa)

It also uses the same valid-ready handshake similar to the accelerator ports. The signal definitions for the request port are:

| Signal            | Description                                                                                                   | 
| ----------------- | ------------------------------------------------------------------------------------------------------------  |
| q_valid           | Request side valid signal.                                                                                    |
| write             | Write signal. 1 means to write.                                                                               |
| addr              | Memory address to write to.                                                                                   |
| amo               | Atomic memory operation. Details are in [Request and Response](reqrsp_interface.md) section                   |
| data              | The data to be written.                                                                                       |
| user              | User field pertains to which core is accessing the port.                                                      |
| strb              | Byte masking for data writes                                                                                  |

The signal definitions for the response port are:

| Signal            | Description                                                                                                   | 
| ----------------- | ------------------------------------------------------------------------------------------------------------  |
| p_valid           | Response side valid signal.                                                                                   |
| q_ready           | Request side ready signal.                                                                                    |
| data              | The read data to be returned to the core.                                                                     |

Notice that the `q_ready` signal of the TCDM was placed in the response ports. This is just to indicate that the direction is from the TCDM interconnect towards the Snitch core. Also, there is no `p_ready` signal indicating that the `p_ready` is invisibly always ready. The accelerator needs to buffer this data as soon as they can. Note that the `p_valid` signal asserts immediately along with the appropriate data at that cycle.

## Attaching a Custom Accelerator

To attach an accelerator to the SNAX cluster, you only need:

1. To attach the accelerator's ports to the SNAX ports for control.
2. Attach the accelerator's memory ports to the TCDM ports.

You can find the examples inside the `/hw/snitch_cluster/src/snitch_cluster.sv`:

```systemverilog
snax_mac # (
    .DataWidth          ( 32                    ),
    .SnaxTcdmPorts      ( LocalSnaxTcdmPorts    ),
    .acc_req_t          ( acc_req_t             ),
    .acc_rsp_t          ( acc_resp_t            ),
    .tcdm_req_t         ( tcdm_req_t            ),
    .tcdm_rsp_t         ( tcdm_rsp_t            )
) i_snax_mac (
    .clk_i              ( clk_i                 ),
    .rst_ni             ( rst_ni                ),
    .snax_req_i         ( snax_req[i]           ),
    .snax_qvalid_i      ( snax_qvalid[i]        ),
    .snax_qready_o      ( snax_qready[i]        ),
    .snax_resp_o        ( snax_resp[i]          ),
    .snax_pvalid_o      ( snax_pvalid[i]        ),
    .snax_pready_i      ( snax_pready[i]        ),
    .snax_tcdm_req_o    ( hang_snax_tcdm_req    ),
    .snax_tcdm_rsp_i    ( hang_snax_tcdm_rsp    )
);
```

The `snax_mac` is the top-level wrapper of the entire HWPE MAC engine. Observe that the main ports are just the accelerator ports and the TCDM ports. Moreover there is a `SnaxTcdmPorts` parameter at the top of the `snitch_cluster.sv`. This indicates the number of TCDM ports connected to the accelerator. You can also configure these in the configuration `.hjson` files found in `/target/snitch_cluster/cfg/`. Checkout the `snax-mac.hjson` as an example where it indicates the `SnaxTcdmPorts` size and the accelerator.