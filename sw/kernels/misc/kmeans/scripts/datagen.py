#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Authors: Luca Colagrande <colluca@iis.ee.ethz.ch>

import matplotlib.pyplot as plt
from sklearn.datasets import make_blobs
from sklearn.cluster import KMeans
import numpy as np

import snitch.util.sim.data_utils as du

# AXI splits bursts crossing 4KB address boundaries. To minimize
# the occurrence of these splits the data should be aligned to 4KB
BURST_ALIGNMENT = 4096


class KmeansDataGen(du.DataGen):

    def parser(self):
        p = super().parser()
        p.add_argument(
            '--no-gui',
            action='store_true',
            help='Run without visualization')
        return p

    def main(self):
        super().main()

        # Visualize centroids
        args = self.parse_args()
        gui = not args.no_gui
        if gui:
            self.visualize_clusters(self.X, self.initial_centroids)
            self.visualize_clusters(self.X, self.expected_centroids)

    def golden_model(self, samples, n_clusters, initial_centroids, max_iter):
        # Apply k-means clustering
        kmeans = KMeans(
            n_clusters=n_clusters,
            init=initial_centroids,
            max_iter=max_iter
        )
        kmeans.fit(samples)
        return kmeans.cluster_centers_, kmeans.n_iter_

    def visualize_clusters(self, samples, centroids, title=None):
        plt.scatter(samples[:, 0], samples[:, 1], s=30)
        plt.scatter(centroids[:, 0], centroids[:, 1], marker='x', s=200, linewidths=3, color='red')
        if not title:
            title = "K-means clusters"
        plt.title(title)
        plt.xlabel("Feature 1")
        plt.ylabel("Feature 2")
        plt.show()

    def validate(self, **kwargs):
        assert (kwargs['n_samples'] % 8) == 0, 'Number of samples must be a multiple of the' \
                                               ' number of cores'

    def emit_header(self, **kwargs):
        header = [super().emit_header()]

        # Validate parameters
        self.validate(**kwargs)

        # Aliases
        n_samples = kwargs['n_samples']
        n_features = kwargs['n_features']
        n_clusters = kwargs['n_clusters']
        seed = kwargs['seed']
        max_iter = kwargs['max_iter']

        # Generate random samples
        X, _ = make_blobs(
            n_samples=n_samples,
            n_features=n_features,
            centers=n_clusters,
            random_state=seed
        )

        # Generate initial centroids randomly
        rng = np.random.default_rng(seed=seed)
        initial_centroids = rng.uniform(low=X.min(axis=0), high=X.max(axis=0),
                                        size=(n_clusters, n_features))

        # Calculate expected centroids and number of iterations
        expected_centroids, n_iter = self.golden_model(X, n_clusters, initial_centroids, max_iter)

        # Generate header
        header += [du.format_scalar_definition('uint32_t', 'n_samples', n_samples)]
        header += [du.format_scalar_definition('uint32_t', 'n_features', n_features)]
        header += [du.format_scalar_definition('uint32_t', 'n_clusters', n_clusters)]
        header += [du.format_scalar_definition('uint32_t', 'n_iter', n_iter)]
        header += [du.format_array_definition('double', 'centroids', initial_centroids.flatten(),
                   alignment=BURST_ALIGNMENT, section=kwargs['section'])]
        header += [du.format_array_definition('double', 'samples', X.flatten(),
                   alignment=BURST_ALIGNMENT, section=kwargs['section'])]
        header = '\n\n'.join(header)

        # Internalize variables to use in other functions
        self.X = X
        self.initial_centroids = initial_centroids
        self.expected_centroids = expected_centroids

        return header


if __name__ == '__main__':
    KmeansDataGen().main()
