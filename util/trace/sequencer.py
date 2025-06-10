# Copyright 2020 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Authors: Luca Colagrande <colluca@iis.ee.ethz.ch>

import warnings


class Sequencer(object):

    def __init__(self):
        # Currently active loop (-1 if none)
        self.loop_idx = -1

        # Loop nest configuration
        self.loop_cfg = []
        self.nest_depth = 0

        # Instructions issued to the sequencer, including FREPs,
        # instructions which bypass the ring buffer, and instructions
        # to buffer.
        self.insns = []
        self.curr_sec = 0

        # Read pointer points to the next instruction to be issued
        # from the instruction queue
        self.rd_ptr = 0

    # insn contains {pc, sec, is_frep}
    def push_insn(self, insn):
        self.insns.append(insn)

        # If the offloaded instruction is an FREP,
        # save configuration for the new loop
        if insn['is_frep']:
            self.loop_cfg.append({
                # PC of the FREP instruction associated to the loop
                "pc": insn['pc'],
                # Iteration of the loop
                "iter_idx": 0,
                # Index of the current instruction in the loop
                "inst_idx": 0,
                # Pointer to the loop body's first instruction
                # in the instruction queue
                "base_ptr": 0
            })

    def decode_frep(self, frep):

        # Fill loop configuration
        self.loop_cfg[-1].update(frep)
        pc = self.loop_cfg[-1]['pc']

        # Build instruction string
        insn = f'{"frep":<8}{frep["max_iter"] + 1}'
        insn += f', {frep["max_inst"] + 1}'
        if frep['stg_mask']:
            insn += f', {bin(frep["stg_mask"])}'
            insn += f', {frep["stg_max"] + 1}'

        # Build annotation string
        n_issues = (frep['max_inst'] + 1) * (frep['max_iter'] + 1)
        annot = f'{n_issues} issues'

        return pc, insn, annot

    def last_iter(self, loop_idx=None):
        if loop_idx is None:
            loop_idx = self.loop_idx
        return self.loop_cfg[loop_idx]['iter_idx'] == self.loop_cfg[loop_idx]['max_iter']

    def last_inst(self, loop_idx=None):
        if loop_idx is None:
            loop_idx = self.loop_idx
        return self.loop_cfg[loop_idx]['inst_idx'] == self.loop_cfg[loop_idx]['max_inst']

    def emulate(self, permissive=False):

        # If the current instruction is an FREP we pop it from the instruction
        # queue, entering the loop body, and set the base_ptr of the entered loop
        # to the current rd_ptr. As there may be multiple consecutive FREP
        # instructions before the start of a loop body, we repeat the process until
        # we reach the first non-FREP instruction.
        while self.insns:
            if self.insns[self.rd_ptr]['is_frep']:
                self.loop_idx += 1
                self.nest_depth += 1
                self.insns.pop(self.rd_ptr)
                self.loop_cfg[self.loop_idx]['base_ptr'] = self.rd_ptr
            else:
                break

        # If we are in a loop, we issue the next instruction in the loop
        if self.loop_idx > -1:

            # Get current instruction info and loop status for printing.
            # The loops status PC identifies the active loop by the PC
            # of the FREP instruction it was defined by.
            pc_str, curr_sec = [self.insns[self.rd_ptr][key] for key in ['pc', 'sec']]
            loop_status = {
                'pc': self.loop_cfg[self.loop_idx]['pc'],
                'iter_idx': self.loop_cfg[self.loop_idx]['iter_idx'],
                'inst_idx': self.loop_cfg[self.loop_idx]['inst_idx'],
            }

            # If we are not at the last instruction of the loop, advance to the
            # following instruction.
            if not self.last_inst():
                self.loop_cfg[self.loop_idx]['inst_idx'] += 1
                self.rd_ptr += 1

                # If the loop is in the last iteration we can also increment the instruction
                # index of the outer loop, and so on until we reach the outermost loop not
                # at the last iteration.
                i = self.loop_idx
                while i >= 1 and self.last_iter(i):
                    i -= 1
                    self.loop_cfg[i]['inst_idx'] += 1

                # If there are inner loops in the active one, check if we reached the start
                # of the next inner loop, and increment the loop index accordingly. As multiple
                # nested inner loops may start at the same instruction, we repeat the process.
                while len(self.loop_cfg) > self.loop_idx + 1:
                    if self.loop_cfg[self.loop_idx + 1]['base_ptr'] == self.rd_ptr:
                        self.loop_idx += 1
                    else:
                        break

            # If we are at the last instruction of the loop, reset the instruction index.
            else:
                self.loop_cfg[self.loop_idx]['inst_idx'] = 0

                # If it's not the last iteration of the loop, reset the read pointer to the base
                # and increment the iteration index.
                if not self.last_iter():
                    self.rd_ptr = self.loop_cfg[self.loop_idx]['base_ptr']
                    self.loop_cfg[self.loop_idx]['iter_idx'] += 1

                # If it is the last iteration of the loop, reset the iteration index.
                else:
                    self.loop_cfg[self.loop_idx]['iter_idx'] = 0

                    # Move to the outer loop, if any. If the outer loop is also finished
                    # move to the next outer level. Repeat until we reach the outermost
                    # incomplete loop.
                    self.loop_idx -= 1
                    while self.loop_idx > -1 and self.last_iter() and self.last_inst():
                        self.loop_cfg[self.loop_idx]['inst_idx'] = 0
                        self.loop_cfg[self.loop_idx]['iter_idx'] = 0
                        self.loop_idx -= 1

                    # If we finished all loops, the loop nest configuration and instructions
                    # can be deleted, and the read pointer reset.
                    if self.loop_idx == -1:
                        tot_inst_num = self.loop_cfg[0]['max_inst'] + 1
                        del self.insns[:tot_inst_num]
                        del self.loop_cfg[:self.nest_depth]
                        self.nest_depth = 0
                        self.rd_ptr = 0
                    else:
                        # If the outer loop to which we moved is not at the last instruction
                        # of the loop, advance to the following instruction.
                        if not self.last_inst():
                            self.loop_cfg[self.loop_idx]['inst_idx'] += 1
                            self.rd_ptr += 1

                            # If the loop is in the last iteration we can also increment the
                            # instruction index of the outer loop, and so on until we reach
                            # the outermost loop not at the last iteration.
                            i = self.loop_idx
                            while i >= 1 and self.last_iter(i):
                                i -= 1
                                self.loop_cfg[i]['inst_idx'] += 1

                        # Otherwise, reset the instruction index and the read pointer to the base
                        else:
                            self.loop_cfg[self.loop_idx]['inst_idx'] = 0
                            self.loop_cfg[self.loop_idx]['iter_idx'] += 1
                            self.rd_ptr = self.loop_cfg[self.loop_idx]['base_ptr']

        # We are in pass-through mode, and just issue the next instruction.
        else:
            pc_str, curr_sec, _ = self.insns.pop(self.rd_ptr).values()
            loop_status = None

        # Return instruction info and loop status for printing.
        return pc_str, curr_sec, loop_status

    def terminate(self):
        unseq_insns = len(self.insns)
        warn = False
        if self.loop_cfg:
            warn = True
            loop_nest = ', '.join([str(loop['pc']) for loop in self.loop_cfg])
            warnings.warn(f'Not all FPSS instructions from loop nest ({loop_nest}) were issued.')
        if unseq_insns:
            warn = True
            warnings.warn(f'{unseq_insns} unsequenced FPSS instructions were not issued.')
        return warn
