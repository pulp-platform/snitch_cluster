# Other Tools

There are two useful tools for debugging and verifying your work. (1) Dumping waveform VCD files and (2) program stack tracing.

# Dumping Wavefors with VCD Files

To dump VCD files through simulation we only need to add the `--vcd` when running simulations.

```bash
bin/snitch_cluster.vlt sw/apps/snax-alu/build/snax-alu.elf --vcd
```
The dumped file will be named as `sim.vcd`. You can view this with your favorite waveform viewing tool. Taking `GTKWave` as an example:

```
gtkwave sim.vcd &
```

!!! note

    If you're using the codespace, you need to download the `sim.vcd` file first and open it locally in your personal work space.

# Program Tracing with Spike

Spike is a nice tool for converting disassembly files into traces of the simulation. When your run the simulations with:

```bash
bin/snitch_cluster.vlt sw/apps/snax-alu/build/snax-alu.elf
```
This creates a set of log files under the `./target/snitch_cluster/logs/.` directory. Then you should see `.dasm` files: 

```
trace_hart_00000.dasm
trace_hart_00001.dasm
```

These are disassembly files for each core. `trace_hart_00000.dasm` is for core 0 which is the core with the SNAX ALU accelerator, while `trace_hart_00001.dasm` is for core 1 which is the core with the DMA. We would like to convert these files into traces that are more readable. We will use `spike` for this.

## Installing Spike

1 - Navigate to `./target/snitch_cluster/work-vlt/riscv-isa-sim/.`

2 - Configure the `spike` installation with:

```bash
./configure --prefix=/opt/spike/
```

3 - Install `spike` and wait for a while for this to finish. This will take quite some time.

```bash
make install -j
```

4 - Add to path environment:

```bash
export PATH="/opt/spike/bin:$PATH"
```

5 - Check if `spike` is correctly installed:

```bash
spike -h
```

## Running Traces

We can now generate traces. Make sure you are in the `./target/snitch_cluster/` directory.

1 - Run simulations first:

```bash
bin/snitch_cluster.vlt sw/apps/snax-alu/build/snax-alu.elf
```

2 - Make traces:

```bash
make traces
```

3 - This file should generated trace files:

```
trace_hart_00000.txt
trace_hart_00001.txt
```

## Investigating Traces

The generated traces are a bit more readable from here. Open `trace_hart_00000.txt` and search for the first instance of the `mcycle` instruction (do a text search like `ctrl+f`).

```bash
663000      660        M 0x8000020c csrr    a4, mcycle             #; mcycle = 659, (wrb) a4  <-- 659
664000      661        M 0x80000210 auipc   a4, 0x2                #; (wrb) a4  <-- 0x80002210
665000      662        M 0x80000214 addi    a4, a4, 1816           #; a4  = 0x80002210, (wrb) a4  <-- 0x80002928
666000      663        M 0x80000218 lw      a6, 4(a4)              #; a4  = 0x80002928, a6  <~~ Word[0x8000292c]
677000      674        M                                           #; (lsu) a6  <-- 0
678000      675        M 0x8000021c lw      a7, 0(a4)              #; a4  = 0x80002928, a7  <~~ Word[0x80002928]
679000      676        M 0x80000220 li      t0, 0                  #; (wrb) t0  <-- 0
689000      686        M                                           #; (lsu) a7  <-- 80
690000      687        M 0x80000224 csrw    unknown_3c0, a7        #; a7  = 80
691000      688        M 0x80000228 add     a3, a5, a3             #; a5  = 0x10000a00, a3  = 2560, (wrb) a3  <-- 0x10001400
692000      689        M 0x8000022c li      a6, 32                 #; (wrb) a6  <-- 32
693000      690        M 0x80000230 csrw    unknown_3c1, a6        #; a6  = 32
694000      691        M 0x80000234 csrw    unknown_3c2, a6        #; a6  = 32
695000      692        M 0x80000238 li      a6, 64                 #; (wrb) a6  <-- 64
696000      693        M 0x8000023c csrw    unknown_3c3, a6        #; a6  = 64
733000      730        M 0x80000240 csrwi   unknown_3c4, 8         #; 
734000      731        M 0x80000244 csrwi   unknown_3c5, 8         #; 
735000      732        M 0x80000248 csrwi   unknown_3c6, 8         #; 
736000      733        M 0x8000024c csrw    unknown_3c7, a0        #; a0  = 0x10000000
737000      734        M 0x80000250 csrw    unknown_3c8, a5        #; a5  = 0x10000a00
738000      735        M 0x80000254 csrw    unknown_3c9, a3        #; a3  = 0x10001400
739000      736        M 0x80000258 csrwi   unknown_3ca, 1         #; 
740000      737        M 0x8000025c auipc   a3, 0x4                #; (wrb) a3  <-- 0x8000425c
757000      754        M 0x80000260 addi    a3, a3, 1412           #; a3  = 0x8000425c, (wrb) a3  <-- 0x800047e0
758000      755        M 0x80000264 lw      a5, 4(a3)              #; a3  = 0x800047e0, a5  <~~ Word[0x800047e4]
769000      766        M                                           #; (lsu) a5  <-- 0
770000      767        M 0x80000268 lw      a3, 0(a3)              #; a3  = 0x800047e0, a3  <~~ Word[0x800047e0]
781000      778        M                                           #; (lsu) a3  <-- 0
782000      779        M 0x8000026c csrw    unknown_3cc, a3        #; a3  = 0
783000      780        M 0x80000270 lw      a3, 4(a4)              #; a4  = 0x80002928, a3  <~~ Word[0x8000292c]
794000      791        M                                           #; (lsu) a3  <-- 0
795000      792        M 0x80000274 lw      a4, 0(a4)              #; a4  = 0x80002928, a4  <~~ Word[0x80002928]
806000      803        M                                           #; (lsu) a4  <-- 80
807000      804        M 0x80000278 csrw    unknown_3cd, a4        #; a4  = 80
808000      805        M 0x8000027c csrwi   unknown_3ce, 1         #; 
809000      806        M 0x80000280 csrr    a3, mcycle             #; mcycle = 805, (wrb) a3  <-- 805
  ```

`trace_hart_00000.txt` is the trace file for core 0 which is also controlling the SNAX ALU accelerator. The columns are arranged as follows:

 - 1st column is the time in ns.
 - 2nd column is the clock cycle count.
 - 3rd column is the instruction address.
 - 4th column is the instruction.
 - 5th column is the arguments for the instruction.
 - 6th column is the comments section to indicate what has happened.

 You can see comments that indicate load operations of the load-store unit of the Snitch core. For example:

 ```bash
 #; (lsu) a4  <-- 80
 ```

This shows that the value 80 was loaded into a4 at this specific cycle.

Recall, from our `snax-alu.c` program, there is a compute core assignment where we tag the `mcycle` count for the CSR setup cycles. The first instance of the `mcycle` for the computer happens before the CSR setup. The second time the `mcycle` appears when the CSR setup is finished. You could visibly locate this in the trace.

Moreover, it is interesting to see the consistency of the CSR write instructions. For example, clock cycles 690 and 691 pertain to the part of the `snax-alu.c` program.

```C
write_csr(0x3c1, 32);
write_csr(0x3c2, 32);
```

# Some Exercise Questions

<details>
    <summary> At what clock cycle was the loop bound register set? </summary>
    Clock cycle 687
</details>

<details>
    <summary> How long does it take to set the CSR cycles from the start of the streamer up to the start of the accelerator? </summary>
    Starts at clock cycle `mcycle=660` and ends at clock cycle `mcycle=806`. A total of 146 clock cycles. This is different from the performance counter we measured: 102 clock cycles.
</details>

<details>
    <summary> Where can I find the `mcycle` tags for the DMA core? </summary>
    We need to check `trace_hart_00001.txt`.
</details>

<details>
    <summary> How many cycles does it take to preload the data with the DMA? (Assuming the default settings for `snax-alu.c`) </summary>
    Starts at `mcycle=620` and ends at `mcycle=657`. A total of 37 clock cycles.
</details>

