# Accelerator Design

Let's first dive into the SNAX accelerator wrapper which is the yellow box from the main figure in [Architectural Overview](./architectural_overview.md). The figure below is the same shell but with more signal details:

![image](https://github.com/KULeuven-MICAS/snitch_cluster/assets/26665295/ea948d6f-44e9-4602-831c-f4ee0d70e851)

We labeled a few important details about the shell:

(1) - The entire SNAX accelerator wrapper encapsulates the streamers, the CSR manager, and the accelerator data path.

(2) - The CSR manager handles the CSR read and write transactions between the Snitch core and the accelerator data path. Towards the Snitch core side, CSR transactions are handled with decoupled interfaces (`csr_req_*` and `csr_rsp_*`) of requests and responses. Towards the accelerator side, the read-write registers (`register_rw_set`) use a decoupled interface (`register_rw_valid` and `register_rw_ready`) while the read-only registers (`register_ro_set`) use a direct mapping. There are more details in [CSR Manager Design](./csrman_design.md).

(3) - The streamer provides flexible data access from the L1 TCDM to the accelerator. It serves as an intermediate interface between the TCDM interconnect and the accelerator. On the interconnect side the streamer controls the TCDM request and response (`tcdm_req` and `tcdm_rsp`) interfaces towards the memory. On the accelerator side, the streamer has its own data decoupled interfaces (`acc2stream_*` and `stream2acc_*`). The direction from the accelerator to the streamer is write-only ports while the direction from the streamer to the accelerator is read-only ports. More details are in [Streamer Design](./streamer_design.md).

(4) - The accelerator data path is the focus of this section. In our example, we will use a very simple ALU datapath with basic operations only. The SNAX ALU is already built for you. You can find it under the `./hw/snax_alu/` directory. Take time to check the simple design.


# SNAX ALU Datapath

{%
   include-markdown '../../hw/snax_alu/doc/snax_alu.md'
   start="# SNAX ALU Accelerator Datapath"
   comments=false
%}

# Adding Your Accelerator to the Configuration File

You can add your accelerator configurations in a configuration file. The SNAX ALU configuration `snax-alu.hjson` has core templates which configure the Snitch core and how it connects to an accelerator. The `snax-alu` core template is:

```hjson
// SNAX Accelerator Core Templates
snax_alu_core_template: {
    isa: "rv32imafd",
    xssr: true,
    xfrep: true,
    xdma: false,
    xf16: true,
    xf16alt: true,
    xf8: true,
    xf8alt: true,
    xfdotp: true,
    xfvec: true,
    snax_acc_cfg: {
        snax_acc_name: "snax_alu"
        snax_tcdm_ports: 16,
        snax_num_rw_csr: 3,
        snax_num_ro_csr: 2,
        snax_streamer_cfg: {$ref: "#/snax_alu_csr_streamer_template" }
    },
    num_int_outstanding_loads: 1,
    num_int_outstanding_mem: 4,
    num_fp_outstanding_loads: 4,
    num_fp_outstanding_mem: 4,
    num_sequencer_instructions: 16,
    num_dtlb_entries: 1,
    num_itlb_entries: 1,
    // Enable division/square root unit
    // Xdiv_sqrt: true,
},
```
The first operations before the `snax_acc_cfg` pertain to the Snitch core configurations. Particularly what ISA to use and which additional features it includes. You would usually keep this by default.

The `snax_acc_cfg`  contains the configurations for the accelerator. The configuration definitions are:

- `snax_acc_name`: Is the name appended to the different wrappers discussed in [Building the Architecture](./build_system.md) section.
- `snax_tcdm_ports`: Is the number of tightly coupled data memory (TCDM) that your accelerator needs.
- `snax_num_rw_csr`: Is the number of read-write (RW) registers your accelerators has. This affects the connection ports of the CSR manager. More details in [SNAX CSR Manager](./csrman_design.md).
- `snax_num_ro_csr`: Is the number of read-only (RO) registers your accelerator has. This affects the connection ports CSR manager. More details in [SNAX CSR Manager](./csrman_design.md).
- `snax_streamer_cfg`: Contains the settings for your streamer. More details are in [SNAX Streamer](./streamer_design.md)

You can find more details in the [Harware Schema](schema-doc/snitch_cluster.md) section. 
