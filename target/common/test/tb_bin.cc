// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

#include <printf.h>
#include <cstring>
#include <iostream>
#include <vector>

#include "sim.hh"

// Declare these as global variables
bool WRAPPER_disable_tracing = false;
char *WRAPPER_trace_prefix = nullptr;

void print_usage(const char *prog_name) {
    std::cout << "Usage: " << prog_name
              << " [SNAX WRAPPER Options] [HTIF Options]\n"
              << "  Wrap Rocket Chip Emulator in SNAX RTL Simulator\n\n"
              << "SNAX WRAPPER Options:\n"
              << "  --disable-tracing       Disable Snitch tracing\n"
              << "  --prefix-trace <prefix> Set trace prefix (cannot be used "
                 "with --disable-tracing)\n\n";
}

int main(int argc, char **argv, char **env) {
    // Write binary path to logs/binary for the `make annotate` target
    FILE *fd;
    fd = fopen("logs/.rtlbinary", "w");
    if (fd != NULL && argc >= 2) {
        fprintf(fd, "%s\n", argv[1]);
        fclose(fd);
    } else {
        fprintf(stderr,
                "Warning: Failed to write binary name to logs/.rtlbinary\n");
    }
    // Parse custom wrapper arguments
    for (int i = 1; i < argc; ++i) {
        if (strcmp(argv[i], "--disable-tracing") == 0) {
            WRAPPER_disable_tracing = true;
        } else if (strncmp(argv[i], "--prefix-trace ", 15) == 0) {
            WRAPPER_trace_prefix =
                argv[i] + 15;  // Extract the value after `--prefix-trace=`
        } else if (strcmp(argv[i], "-h") == 0 ||
                   strcmp(argv[i], "--help") == 0) {
            print_usage(argv[0]);
            // Also show help from underlying fesvr function
            // Note:
            // If a binary is supplied, it will show both the snax wrapper help,
            // AND continue with the execution of the program...
            auto sim = std::make_unique<sim::Sim>(argc, argv);
            return sim->run();
            return -1;
        }
    }
    // Validate conflicting options
    if (WRAPPER_disable_tracing && WRAPPER_trace_prefix != nullptr) {
        std::cerr << "Error: --disable-tracing and --prefix-trace cannot be "
                     "used together.\n";
        return 1;
    }
    // Prepare filtered arguments
    std::vector<char *> filtered_argv;
    for (int i = 0; i < argc; ++i) {
        // Skip custom options
        if (strcmp(argv[i], "--disable-tracing") == 0 ||
            strncmp(argv[i], "--prefix-trace ", 15) == 0) {
            continue;
        }
        filtered_argv.push_back(argv[i]);
    }
    filtered_argv.push_back(nullptr);  // Null-terminate for compatibility

    // Pass the filtered arguments to fesvr argument handling
    int filtered_argc =
        static_cast<int>(filtered_argv.size()) - 1;  // Exclude null terminator
    char **filtered_argv_ptr = filtered_argv.data();
    auto sim = std::make_unique<sim::Sim>(filtered_argc, filtered_argv_ptr);
    return sim->run();
}
