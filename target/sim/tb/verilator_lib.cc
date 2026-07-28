// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

#include <stdio.h>

#include <cstdlib>

#include "Vtestharness.h"
#include "Vtestharness__Dpi.h"
#include "sim.hh"
#include "tb_lib.hh"
#include "verilated.h"
#if VM_TRACE_FST
#include "verilated_fst_c.h"
#endif

std::unique_ptr<sim::Sim> s;

namespace sim {

// Number of cycles between HTIF checks.
const int HTIFTimeInterval = 200;

// We want to return timestamp in picosecond accuracy, assuming that one cycle
// takes 1ns Since 1 cycle takes 2 sim::TIME increments, scale by 500 to get
// time = cycle * 1000 + <some constant>
const int TIME_CYCLES_TO_TIMESTAMP = 500;
void sim_thread_main(void *arg) { ((Sim *)arg)->main(); }

// Sim time.
vluint64_t TIME = 0;

#if VM_TRACE_FST
// The "target" fiber (running `Sim::main()`'s eval/dump loop) can be
// abandoned mid-loop: if no `--ipc` host is attached, `Sim::run()` returns as
// soon as `htif_t::run()` does, without resuming the target fiber again, so
// it never reaches its own post-loop cleanup below (only reachable once the
// loop itself sees `Verilated::gotFinish()`). That drops any FST data not
// yet flushed on a failing test, exactly the run we most want a usable
// waveform for. Register a process-exit hook so the trace gets closed
// regardless of which path terminates the process.
VerilatedFstC *g_fst = nullptr;
void close_fst_at_exit() {
    if (g_fst != nullptr) {
        g_fst->close();
        g_fst = nullptr;
    }
}
#endif

Sim::Sim(int argc, char **argv) : htif_t(argc, argv), ipc(argc, argv) {
#if VM_TRACE_FST
    // Search arguments for `--fst` flag and enable waves if requested
    for (auto i = 1; i < argc; ++i) {
        if (strcmp(argv[i], "--fst") == 0) {
            printf("FST wave generation enabled\n");
            vlt_fst = true;
        }
    }
#endif
    Verilated::commandArgs(argc, argv);
}

void Sim::idle() { target.switch_to(); }

/// Execute the simulation.
int Sim::run() {
    host = context_t::current();
    target.init(sim_thread_main, this);
    int exit_code = htif_t::run();
    // The program has signalled end-of-computation (fesvr/HTIF observed the
    // `tohost` write), but memory writes it issued just before exiting may
    // still be in flight in the interconnect and not yet committed to the
    // global memory. Release the host's pending `Wait` command so it can read
    // back results, but keep evaluating the RTL until the host disconnects, so
    // those writes drain and the read-back observes committed data. (Once the
    // program has exited its cores are parked, so this just drains pending
    // transactions and then idles.)
    ipc.notify_finished(exit_code);
    while (ipc.session_open() && !Verilated::gotFinish()) {
        idle();
    }
    return exit_code;
}

void Sim::main() {
    // Initialize verilator environment.
    Verilated::traceEverOn(true);
    // Allocate the simulation state.
    auto top = std::make_unique<Vtestharness>();
#if VM_TRACE_FST
    // Allocate the FST trace.
    auto fst = std::make_unique<VerilatedFstC>();

    // Trace 8 levels of hierarchy.
    if (vlt_fst) {
        top->trace(fst.get(), 8);
        fst->open("sim.fst");
        fst->dump(TIME);
        g_fst = fst.get();
        std::atexit(close_fst_at_exit);
    }
#endif
    TIME += 2;

    while (!Verilated::gotFinish()) {
        // Evaluate the DUT.
        top->eval();
#if VM_TRACE_FST
        if (vlt_fst) fst->dump(TIME);
#endif
        // Increase global time.
        TIME++;
        // Switch to the HTIF interface in regular intervals.
        if (TIME % HTIFTimeInterval == 0) {
            host->switch_to();
        }
    }

#if VM_TRACE_FST
    // Clean up. (`close_fst_at_exit` guards against a second close() if this
    // path is reached normally, by clearing `g_fst` once closed here.)
    if (vlt_fst) close_fst_at_exit();
#endif
}
}  // namespace sim

// Verilator callback to get the current time.
double sc_time_stamp() { return sim::TIME * sim::TIME_CYCLES_TO_TIMESTAMP; }

// DPI calls.
void tb_memory_read(long long addr, int len, const svOpenArrayHandle data) {
    // std::cout << "[TB] Read " << std::hex << addr << std::dec << " (" << len
    //           << " bytes)\n";
    void *data_ptr = svGetArrayPtr(data);
    assert(data_ptr);
    sim::MEM.read(addr, len, (uint8_t *)data_ptr);
}

void tb_memory_write(long long addr, int len, const svOpenArrayHandle data,
                     const svOpenArrayHandle strb) {
    // std::cout << "[TB] Write " << std::hex << addr << std::dec << " (" << len
    //           << " bytes)\n";
    const void *data_ptr = svGetArrayPtr(data);
    const void *strb_ptr = svGetArrayPtr(strb);
    assert(data_ptr);
    assert(strb_ptr);
    sim::MEM.write(addr, len, (const uint8_t *)data_ptr,
                   (const uint8_t *)strb_ptr);
}

const long long clint_addr = sim::BOOTDATA.clint_base;
const long num_cores = sim::BOOTDATA.core_count;

void clint_tick(const svOpenArrayHandle msip) {
    uint8_t *msip_ptr = (uint8_t *)svGetArrayPtr(msip);
    assert(msip_ptr);
    uint32_t read_val;
    for (int i = 0; i < num_cores; i++) {
        if (i % 32 == 0)
            sim::MEM.read(clint_addr + i / 32, sizeof(uint32_t),
                          (uint8_t *)&read_val);
        msip_ptr[i] = (read_val & (1 << (i % 32))) != 0 ? 1 : 0;
    }
}

uint32_t get_bin_entry() { return s->get_bin_entry(); }
