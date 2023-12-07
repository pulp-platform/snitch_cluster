# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

from Simulation import QuestaSimulation, VCSSimulation, VerilatorSimulation, BansheeSimulation, \
                       CustomSimulation


class Simulator(object):

    def __init__(self, name, simulation_cls):
        self.name = name
        self.simulation_cls = simulation_cls

    def supports(self, test):
        return 'simulators' not in test or self.name in test['simulators']

    def get_simulation(self, test):
        return self.simulation_cls(test['elf'])


class RTLSimulator(Simulator):

    def __init__(self, name, simulation_cls, binary):
        super().__init__(name, simulation_cls)
        self.binary = binary

    def get_simulation(self, test):
        if 'cmd' in test:
            return CustomSimulation(test['elf'], self.binary, test['cmd'])
        else:
            return self.simulation_cls(
                test['elf'],
                retcode=test['exit_code'] if 'exit_code' in test else 0,
                sim_bin=self.binary
            )


class VCSSimulator(RTLSimulator):

    def __init__(self, binary):
        super().__init__('vcs', VCSSimulation, binary)


class QuestaSimulator(RTLSimulator):

    def __init__(self, binary):
        super().__init__('vsim', QuestaSimulation, binary)


class VerilatorSimulator(RTLSimulator):

    def __init__(self, binary):
        super().__init__('verilator', VerilatorSimulation, binary)


class BansheeSimulator(Simulator):

    def __init__(self, cfg):
        super().__init__('banshee', BansheeSimulation)
        self.cfg = cfg

    def supports(self, test):
        supported = super().supports(test)
        if 'cmd' in test:
            return False
        else:
            return supported

    def get_simulation(self, test):
        return self.simulation_cls(
            test['elf'],
            retcode=test['exit_code'] if 'exit_code' in test else 0,
            banshee_cfg=self.cfg
        )
