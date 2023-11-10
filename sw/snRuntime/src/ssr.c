// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

/// Synchronize the integer and float pipelines.
extern void snrt_fpu_fence();

/// Enable SSR.
extern void snrt_ssr_enable();

/// Disable SSR.
extern void snrt_ssr_disable();

extern uint32_t read_ssr_cfg(uint32_t reg, uint32_t dm);

extern void write_ssr_cfg(uint32_t reg, uint32_t dm, uint32_t value);

// Configure an SSR data mover for a 1D loop nest.
extern void snrt_ssr_loop_1d(enum snrt_ssr_dm dm, size_t b0, size_t s0);

// Configure an SSR data mover for a 2D loop nest.
// b0: Inner-most bound (limit of loop)
// b1: Outer-most bound (limit of loop)
// s0: increment size of inner-most loop
// s1: increment size of outer-most loop
extern void snrt_ssr_loop_2d(enum snrt_ssr_dm dm, size_t b0, size_t b1,
                             size_t s0, size_t s1);


// Configure an SSR data mover for a 3D loop nest.
extern void snrt_ssr_loop_3d(enum snrt_ssr_dm dm, size_t b0, size_t b1,
                             size_t b2, size_t s0, size_t s1, size_t s2);

// Configure an SSR data mover for a 4D loop nest.
// b0: Inner-most bound (limit of loop)
// b3: Outer-most bound (limit of loop)
// s0: increment size of inner-most loop
extern void snrt_ssr_loop_4d(enum snrt_ssr_dm dm, size_t b0, size_t b1,
                             size_t b2, size_t b3, size_t s0, size_t s1,
                             size_t s2, size_t s3);

/// Configure the repetition count for a stream.
extern void snrt_ssr_repeat(enum snrt_ssr_dm dm, size_t count);

/// Start a streaming read.
extern void snrt_ssr_read(enum snrt_ssr_dm dm, enum snrt_ssr_dim dim,
                          volatile void *ptr);

/// Start a streaming write.
extern void snrt_ssr_write(enum snrt_ssr_dm dm, enum snrt_ssr_dim dim,
                           volatile void *ptr);
