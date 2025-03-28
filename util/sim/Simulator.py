# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

from snitch.util.sim import Simulation


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

    def get_simulation(self, test, simulation_cls=None, **kwargs):
        """Construct a Simulation object from the specified test.

        Arguments:
            test: The test for which a Simulation object must be
                constructed.
            simulation_cls: Create a simulation instance of this
                Simulation subclass. Use `self.simulation_cls` by
                default.
        """
        kwargs.update({key: test[key] for key in ['elf', 'run_dir', 'retcode', 'name']
                       if key in test})
        if simulation_cls is not None:
            return simulation_cls(**kwargs)
        else:
            return self.simulation_cls(**kwargs)


class RTLSimulator(Simulator):
    """Base class for RTL simulators.

    An RTL simulator requires a simulation binary built from an RTL
    design to launch a simulation.

    A test may need to be run with a custom command, itself invoking
    the simulation binary behind the scenes, e.g. for verification
    purposes. Such a test carries the custom command (a list of args)
    under the `cmd` key.
    """

    def __init__(self, binary, **kwargs):
        """Constructor for the RTLSimulator class.

        Arguments:
            binary: The simulation binary.
            kwargs: Arguments passed to the base class constructor.
        """
        super().__init__(**kwargs)
        self.binary = binary

    def get_simulation(self, test):
        if 'cmd' in test:
            cmd = test['cmd']
        else:
            cmd = None
        return super().get_simulation(
            test,
            sim_bin=self.binary,
            cmd=cmd
        )


class GvsocSimulator(Simulator):
    """Gvsoc simulator

    A simulator, identified by the name
    `gvsoc`, tailored to the creation of
    [Gvsoc simulations][Simulation.GvsocSimulation].
    """

    def __init__(self, binary):
        """Constructor for the GvsocSimulator class.

        Arguments:
            binary: The Gvsoc simulation binary.
            kwargs: Arguments passed to the base class constructor.
        """
        super().__init__(name='gvsoc', simulation_cls=Simulation.GvsocSimulation)
        self.binary = binary

    def get_simulation(self, test):
        if 'cmd' in test:
            cmd = test['cmd']
        else:
            cmd = None
        return super().get_simulation(
            test,
            sim_bin=self.binary,
            cmd=cmd
        )


class VCSSimulator(RTLSimulator):
    """VCS simulator

    An [RTL simulator][Simulator.RTLSimulator], identified by the name
    `vcs`, tailored to the creation of
    [VCS simulations][Simulation.VCSSimulation].
    """

    def __init__(self, binary):
        """Constructor for the VCSSimulator class.

        Arguments:
            binary: The VCS simulation binary.
        """
        super().__init__(binary, name='vcs', simulation_cls=Simulation.VCSSimulation)


class QuestaSimulator(RTLSimulator):
    """QuestaSim simulator

    An [RTL simulator][Simulator.RTLSimulator], identified by the name
    `vsim`, tailored to the creation of
    [QuestaSim simulations][Simulation.QuestaSimulation].
    """

    def __init__(self, binary):
        """Constructor for the QuestaSimulator class.

        Arguments:
            binary: The QuestaSim simulation binary.
        """
        super().__init__(binary, name='vsim', simulation_cls=Simulation.QuestaSimulation)


class VerilatorSimulator(RTLSimulator):
    """Verilator simulator

    An [RTL simulator][Simulator.RTLSimulator], identified by the name
    `verilator`, tailored to the creation of
    [Verilator simulations][Simulation.VerilatorSimulation].
    """

    def __init__(self, binary):
        """Constructor for the VerilatorSimulator class.

        Arguments:
            binary: The Verilator simulation binary.
        """
        super().__init__(binary, name='verilator', simulation_cls=Simulation.VerilatorSimulation)
