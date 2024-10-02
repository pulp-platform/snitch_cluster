# Code Optimization

The methods covered in the [Debugging and benchmarking](tutorial.md#debugging-and-benchmarking) and [Trace Analysis](trace_analysis.md) pages, show you how to analyze the performance of an application and identify limiting factors.

The following table summarizes the most common bottlenecks and methods to address them in Snitch. In the next sections we will look individually at each method in detail.

|Bottleneck                                                   |Solution                                 |
|-------------------------------------------------------------|-----------------------------------------|
|[I$ misses](#instruction-cache-misses)                       |Cache preheating                         |
|[High-latency load/stores](#high-latency-loadstores)         |Pre-loading to L1 TCDM memory            |
|[TCDM bank conflicts](#tcdm-bank-conflicts)                  |Smart data placement                     |
|[Explicit load/stores](#explicit-loadstores)                 |Stream-semantic registers (SSRs)         |
|[Loop overheads](#loop-overheads)                            |Loop unrolling or hardware loops (FREP)  |
|[Read-after-write (RAW) stalls](#read-after-write-raw-stalls)|Instruction reordering                   |

!!! tip
    Have a look at the optimized kernels within this repository to see how these optimizations can be implemented. [AXPY](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/sw/blas/axpy) and [DOT](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/sw/blas/dot) are accessible examples for beginners.

## Instruction cache misses

While instruction cache (I$) misses are a natural phenomenon which needs to be accounted for, we may want to temporarily remove these to isolate the effect of some other bottleneck.

L1 I$ misses appear as delays on instructions aligned to the L1 I$ line length. This is specified by the `cacheline` parameter in the [hardware configuration file](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/target/snitch_cluster/cfg/default.hjson).

To reduce the effect of I$ misses, you can wrap the code you're interested in benchmarking in a loop, while ensuring the compiler does not unroll it (the `volatile` keyword is required to this end):

```C
for (volatile int i = 0; i < 2; i++) {
    snrt_mcycle();
    <code_to_benchmark>
    snrt_mcycle();
}
```

The first iteration only serves to pre-heat the I$. The second can be benchmarked with the effect of I$ misses reduced to a minimum.

If the working set size of your code is large enough to still observe I$ misses on the second iteration, you can increase the L1 I$ size by tuning the parameters in the hardware configuration file.

## High-latency load/stores

Where variables in your code are placed in memory by the compiler determines the access-latency to these variables.

Most global and constant data is placed by the compiler in the `.data` and `.bss` linker sections. These are mapped to the [last-level (or L3) memory](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/sw/snRuntime/base.ld), that is the simulation memory in the Snitch cluster testbench. Data which is accessed repeatedly from L3 will repeatedly incur the long round-trip access times to L3. In these cases, caching the data in the cluster's L1 TCDM memory can be beneficial. Since the TCDM memory is not a traditional hardware-managed cache, but a software-managed scratch-pad memory, the data must be explicitly loaded into the cluster's TCDM memory from L3 in software.

When data needs to be loaded (stored) in bulk from (to) the L3 memory, using the DMA engine in the cluster can be beneficial. The DMA transfers data in _bursts_ and the round-trip latency is payed once for the burst, while successive items, or _beats_, in the burst are delivered in a pipelined fashion.

## TCDM bank conflicts

The TCDM memory in the cluster is divided into multiple banks, and the TCDM interconnect connects every port from the Snitch cores to every bank of the memory. Accesses to distinct banks can be executed in parallel, while accesses to the same bank result in a conflict, resulting in wasted cycles until access to the bank is granted to each port.

Depending on the access patterns of an application, it may be possible to reduce bank conflicts by smartly arranging the data in memory.

!!! note
    Conflicts may accur within a single core, e.g. between the SSR and LSU ports, between cores in the cluster, or even between the DMA engine and the cores.

## Explicit load/stores

On a single-issue core, such as Snitch, load/store instructions may limit the performance of an application, as useful compute instructions cannot be issued while a load/store is issued, potentially leading to under-utilization of the compute resources.

Snitch provides an ISA extension, _Stream semantic registers (SSRs)_, which can be used to stream data from memory, without having to issue load/store instructions.

!!! info
    For more information, please consult the [SSR paper](https://doi.org/10.1109/TC.2020.2987314).

## Loop overheads

Similar to load/store instructions, loop management instructions may also represent a significant overhead to a computation. In some cases, it is possible to reduce these overheads to some extent through the use of loop unrolling. By unrolling, the overhead is payed once for every N original loop iterations, where N is equal to the applied unrolling factor.

Hardware loops allow to remove a loop's overhead altogether. In Snitch, the FREP ISA extension provides hardware loop capabilities for loops comprising of floating-point instructions exclusively. In addition to eliminating the loop overheads, the FREP extension provides Snitch with pseudo-dual issue capabilities.

!!! info
    For more information, please consult the [Snitch paper](https://doi.org/10.1109/TC.2020.3027900).

## Read-after-write (RAW) stalls

The FPU in Snitch is pipelined, causing instructions to take multiple cycles, from the moment they are issued to the moment they write back to the register file. If the instruction following a floating-point operation depends on the result of the previous operation, i.e. there is a read-after-write (RAW) dependency between successive instructions, the latter will be stalled for a few cycles until the result from the previous is available.

If other independent instructions are present, it may be possible to reorder these between the two dependent instructions, hiding the RAW latency under other useful instructions. In some cases, loop unrolling is coupled to this technique, to provide independent instructions for the reordering.
