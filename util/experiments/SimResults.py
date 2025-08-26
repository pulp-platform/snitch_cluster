# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import functools
import json
from pathlib import Path
import re


class SimRegion():
    """A region in the simulation results.

    A region is identified by a thread and a region ID. The ID is the
    index of the region in the thread's trace. Alternatively, if a
    label was associated to the region using a region-of-interest (ROI)
    specification, this can also be used as an identifier. In case of
    multiple regions with the same label (as e.g. in a loop) you need to
    provide an additional index, to select the specific occurrence of the
    label.
    """
    def __init__(self, thread, id, occurrence=0):
        # Validate thread identifier
        pattern = r'^(hart|dma)_[0-9]+$'
        assert re.match(pattern, str(thread)), \
            f"Thread '{thread}' does not match pattern '(hart|dma)_#'"

        # Save arguments
        self.thread = thread
        self.id = id
        self.occurrence = occurrence


class MissingRegionError(Exception):

    def __init__(self, region):
        self.region = region

    def __str__(self):
        if isinstance(self.region.id, int):
            return f"Region {self.region.id} not found in thread {self.region.thread}."
        else:
            return f"Region {self.region.id} (occurrence {self.region.occurrence}) not found " \
                   f"in thread {self.region.thread}."


class SimResults():

    def __init__(self, sim_dir, source=None):
        """Initializes a simulation results object from the run directory.
        """
        self.sim_dir = Path(sim_dir)
        self.roi_json = Path(self.sim_dir) / 'logs' / 'roi.json'
        self.perf_json = Path(self.sim_dir) / 'logs' / 'perf.json'

        # Get data from ROI file, if available, and perf file otherwise
        if source is not None:
            assert source in ['perf', 'roi'], f'Invalid source {source}.'
            self.source = source
        else:
            self.source = 'perf'
            if self.roi_json.exists():
                self.source = 'roi'

        # Raise exception if no performance data is available
        source = self.perf_json if self.source == 'perf' else self.roi_json
        if not source.exists():
            raise FileNotFoundError(f'File not found {source}. Performance data is not available.')

    @functools.cached_property
    def performance_data(self):
        """Returns all performance data logged during simulation."""
        source = self.perf_json if self.source == 'perf' else self.roi_json
        with open(source, 'r') as f:
            return json.load(f)

    def get_metric(self, region, metric):
        """Get a performance metric from a simulation region.

        Args:
            region: The region to extract the metric from. Should be an
                instance of the `SimRegion` class.
            metric: The name of the metric to extract.
        """
        # Get region index: trivial if SimRegion is already defined by its
        # index, otherwise search for the region with the given label
        # and occurrence.
        id = None
        if isinstance(region.id, int):
            id = region.id
        else:
            if self.source == 'perf':
                raise ValueError('Regions can only be identified by string labels if a ROI file'
                                 ' is available.')
            cnt = 0
            for i, reg in enumerate(self.performance_data[region.thread]):
                if reg['label'] == region.id:
                    if cnt == region.occurrence:
                        id = i
                        break
                    else:
                        cnt += 1
        if id is None:
            raise MissingRegionError(region)

        # Get metric
        thread_data = self.performance_data[region.thread]
        if id < len(thread_data):
            if metric in ['tstart', 'tend'] or self.source == 'perf':
                return thread_data[id][metric]
            else:
                return thread_data[id]['attrs'][metric]
        else:
            raise MissingRegionError(region)

    def get_metrics(self, regions, metric):
        """Get a performance metric from multiple simulation regions.

        Args:
            regions: A list of regions to extract the metric from. Should
                be a list of `SimRegion` instances.
            metric: The name of the metric to extract.

        Returns:
            A list of metrics corresponding to each region in the input list.
        """
        metrics = []
        for region in regions:
            metrics.append(self.get_metric(region, metric))
        return metrics

    def get_interval(self, start_region, end_region=None):
        """Get the start and end times of a simulation interval.

        Args:
            start_region: The region to start from.
            end_region: The region to end at. If not provided, the start
                region is used.

        Returns:
            A tuple with the start and end times of the interval.
        """
        if end_region is None:
            end_region = start_region
        start_time = self.get_metric(start_region, 'tstart')
        end_time = self.get_metric(end_region, 'tend')
        return start_time, end_time

    def get_timespan(self, start_region, end_region=None):
        """Get the timespan between two regions.

        Args:
            start_region: The region to start from.
            end_region: The region to end at. If not provided, the start
                region is used.
        """
        start_time, end_time = self.get_interval(start_region, end_region)
        return end_time - start_time
