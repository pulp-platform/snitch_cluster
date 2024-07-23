// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Yunhao Deng <yunhao.deng@kuleuven.be>

#include "data.h"
#include "snax-xdma-lib.h"
#include "snrt.h"

int main() {
    // Set err value for checking
    int err = 0;

    // Obtain the start address of the TCDM memory
    uint8_t *tcdm_baseaddress = (uint8_t *)snrt_l1_next();
    uint8_t *tcdm_0 = tcdm_baseaddress;
    uint8_t *tcdm_16 = tcdm_baseaddress + 0x4000 * sizeof(uint8_t);
    uint8_t *tcdm_32 = tcdm_baseaddress + 0x8000 * sizeof(uint8_t);
    uint8_t *tcdm_48 = tcdm_baseaddress + 0xc000 * sizeof(uint8_t);
    uint8_t *tcdm_64 = tcdm_baseaddress + 0x10000 * sizeof(uint8_t);
    uint8_t *tcdm_80 = tcdm_baseaddress + 0x14000 * sizeof(uint8_t);
    uint8_t *tcdm_96 = tcdm_baseaddress + 0x18000 * sizeof(uint8_t);
    uint8_t *tcdm_112 = tcdm_baseaddress + 0x1c000 * sizeof(uint8_t);

    // Using xdma core only
    if (snrt_cluster_core_idx() == snrt_cluster_compute_core_num() - 1) {
        // The xdma core is the last compute core in the cluster
        if (xdma_memcpy_1d(tcdm_0, tcdm_0, 0x4000 * sizeof(uint8_t)) != 0) {
            printf("Error in xdma agu configuration\n");
            err++;
        } else {
            printf("The xdma agu is configured\n");
        }

        uint32_t ext_param[1] = {0xFFFFFFFF};
        if (xdma_enable_dst_ext(0, ext_param) != 0) {
            printf("Error in enabling xdma extension 0\n");
            err++;
        } else {
            printf("The xdma extension 0 is enabled\n");
        }

        if (xdma_disable_dst_ext(1) != 0) {
            printf("Error in disabling xdma extension 1\n");
            err++;
        } else {
            printf("The xdma extension 1 is disabled\n");
        }

        if (xdma_disable_dst_ext(2) != 0) {
            printf("Error in disabling xdma extension 2\n");
            err++;
        } else {
            printf("The xdma extension 2 is disabled\n");
        }

        if (err != 0) {
            return err;
        }

        int task_id = xdma_start();
        printf(
            "The xdma is started, setting memory region to 0xFF. The task id "
            "is %d\n",
            task_id);
        xdma_wait(task_id);

        printf("The xdma is finished\n");
        // Check the data
        for (int i = 0; i < 0x4000; i++) {
            if (tcdm_0[i] != 0xFF) {
                printf("The memset of 0KB - 16KB is not correct\n");
                return -1;
            }
        }
        printf("The memset of 0KB - 16KB is correct\n");

        // Setting the 4K-12K region back to 0
        if (xdma_memcpy_1d(tcdm_0, tcdm_0 + 0x1000 * sizeof(uint8_t),
                           0x2000 * sizeof(uint8_t)) != 0) {
            printf("Error in xdma agu configuration\n");
            err++;
        } else {
            printf("The xdma agu is configured\n");
        }

        ext_param[0] = 0;
        if (xdma_enable_dst_ext(0, ext_param) != 0) {
            printf("Error in enabling xdma extension 0\n");
            err++;
        } else {
            printf("The xdma extension 0 is enabled\n");
        }

        if (err != 0) {
            return err;
        }

        task_id = xdma_start();
        printf(
            "The xdma is started, setting memory region to 0x00. The task id "
            "is %d\n",
            task_id);
        xdma_wait(task_id);

        printf("The xdma is finished\n");
        // Check the data
        for (int i = 0; i < 0x1000; i++) {
            if (tcdm_0[i] != 0xFF) {
                printf("Error in memset (region 0)\n");
                return -1;
            }
        }
        for (int i = 0x1000; i < 0x3000; i++) {
            if (tcdm_0[i] != 0x00) {
                printf("The memset is incorrect (region 1)\n");
                return -1;
            }
        }
        for (int i = 0x3000; i < 0x4000; i++) {
            if (tcdm_0[i] != 0xFF) {
                printf("The memset is incorrect (region 2)\n");
                return -1;
            }
        }
        printf("The memset of 4KB - 12KB is correct\n");

    } else {
        printf("Core %d is not xdma core. \n", snrt_cluster_core_idx());
    }

    return 0;
}
