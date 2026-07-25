// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Paul Scheffler <paulsc@iis.ee.ethz.ch>

#pragma once

#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include <algorithm>
#include <atomic>

class IpcIface {
   private:
    static const int IPC_BUF_SIZE = 4096;
    static const int IPC_BUF_SIZE_STRB = IPC_BUF_SIZE / 8 + 1;
    static const int IPC_ERR_DOUBLE_ARG = 30;
    static const long IPC_WAIT_PERIOD_NS = 100000L;

    // Possible IPC operations
    enum ipc_opcode_e {
        Read = 0,
        Write = 1,
        // Block until the simulation has finished, then return its exit code.
        Wait = 2,
    };

    // Operations are 3 doubles, followed by data streams in either direction
    typedef struct {
        uint64_t opcode;
        uint64_t addr;
        uint64_t len;
    } ipc_op_t;

    // Args passed to IPC thread
    typedef struct {
        char* tx;
        char* rx;
        // Set once the simulation has finished, to release a pending `Wait`
        // command. See `notify_finished()`.
        std::atomic<bool>* finished;
        // The simulation exit code, valid once `finished` is set. Returned to
        // the host by a `Wait` command.
        std::atomic<int>* exit_code;
        // Set by the IPC thread once the host closes the TX FIFO, i.e. once it
        // has finished issuing commands (see `session_open()`).
        std::atomic<bool>* disconnected;
    } ipc_targs_t;

    // Thread to asynchronously handle FIFOs
    ipc_targs_t targs;
    pthread_t thread;
    bool active;
    // Signals the IPC thread that the simulation has terminated, and the
    // corresponding exit code (valid once `finished` is set).
    std::atomic<bool> finished{false};
    std::atomic<int> exit_code{0};
    // Set by the IPC thread once the host has disconnected (closed TX).
    std::atomic<bool> disconnected{false};

    static void* ipc_thread_handle(void* in);

   public:
    IpcIface(int argc, char** argv);
    ~IpcIface();

    // Notify the IPC thread that the simulation has finished, with the given
    // exit code. This releases a pending `Wait` command, which the host uses
    // to detect end-of-simulation.
    void notify_finished(int exit_code);

    // Whether an IPC session is active and the host has not disconnected yet.
    // The testbench keeps evaluating the RTL while this holds, so that memory
    // writes still in flight when the program exits drain to the global memory
    // before the host reads them back. Returns false when IPC is not in use.
    bool session_open() const { return active && !disconnected.load(); }
};
