// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

#include <stdio.h>

#include "sim.hh"

extern std::unique_ptr<sim::Sim> s;

int main(int argc, char **argv, char **env) {
    // Write binary path to .rtlbinary for the `make annotate` target
    FILE *fd;
    fd = fopen(".rtlbinary", "w");
    if (fd != NULL && argc >= 2) {
        fprintf(fd, "%s\n", argv[1]);
        fclose(fd);
    } else {
        fprintf(stderr, "Warning: Failed to write binary name to .rtlbinary\n");
    }

    s = std::make_unique<sim::Sim>(argc, argv);
    return s->run();
}
