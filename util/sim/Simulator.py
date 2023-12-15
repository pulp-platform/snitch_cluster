# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

from Simulation import QuestaSimulation, VCSSimulation, VerilatorSimulation, BansheeSimulation, \
                       CustomSimulation


class Simulator(object):
    """An object capable of constructing Simulation objects.

    A simulator constructs a [Simulation][Simulation.Simulation] object
    from a test object, as defined e.g. in a test suite specification
    file.

    At minimum, a test is defined by a binary (`elf`) which is to be
    simulated and a set of simulators it can be run on. A test could be
    defined by a class of its own, but at the moment we assume a test
    to be represented by a dictionary with the `elf` and `simulators`
    keys at minimum.
    """

    def __init__(self, name, simulation_cls):
        """Constructor for the Simulator class.

        A simulator must be identifiable by a unique identifier string
        and construct at least one type of
        [Simulation][Simulation.Simulation] object.

        Arguments:
            name: The unique identifier of the simulator.
            simulation_cls: One type of
                [Simulation][Simulation.Simulation] object the
                simulator can construct.
        """
        self.name = name
        self.simulation_cls = simulation_cls

    def supports(self, test):
        """Check whether a certain test is supported by the simulator.

        Arguments:
            test: The test to check.
        """
        return 'simulators' not in test or self.name in test['simulators']

    def get_simulation(self, test):
        """Construct a Simulation object from the specified test.

        Arguments:
            test: The test for which a Simulation object must be
                constructed.
        """
        return self.simulation_cls(test['elf'])


class RTLSimulator(Simulator):
    """Base class for RTL simulators.

    An RTL simulator requires a simulation binary built from an RTL
    design to launch a simulation.

    A test may need to be run with a custom command, itself invoking
    the simulation binary behind the scenes, e.g. for verification
    purposes. Such a test carries the custom command (a list of args)
    under the `cmd` key. In such case, the RTL simulator constructs a
    [CustomSimulation][Simulation.CustomSimulation] object from the
    given test, with the custom command and simulation binary.
    """

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
    """VCS simulator

    An [RTL simulator][Simulator.RTLSimulator], identified by the name
    `vcs`, tailored to the creation of
    [VCS simulations][Simulation.VCSSimulation].
    """

    def __init__(self, binary):
        super().__init__('vcs', VCSSimulation, binary)


class QuestaSimulator(RTLSimulator):
    """QuestaSim simulator

    An [RTL simulator][Simulator.RTLSimulator], identified by the name
    `vsim`, tailored to the creation of
    [QuestaSim simulations][Simulation.QuestaSimulation].
    """

    def __init__(self, binary):
        super().__init__('vsim', QuestaSimulation, binary)


class VerilatorSimulator(RTLSimulator):
    """Verilator simulator

    An [RTL simulator][Simulator.RTLSimulator], identified by the name
    `verilator`, tailored to the creation of
    [Verilator simulations][Simulation.VerilatorSimulation].
    """

    def __init__(self, binary):
        super().__init__('verilator', VerilatorSimulation, binary)


class BansheeSimulator(Simulator):
    """Banshee simulator

    A simulator, identified by the name `banshee`, tailored to the
    creation of [Banshee simulations][Simulation.BansheeSimulation].
    """

    def __init__(self, cfg):
        super().__init__('banshee', BansheeSimulation)
        self.cfg = cfg

    def supports(self, test):
        """See base class.

        The Banshee simulator does not support tests carrying a custom
        command.
        """
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
