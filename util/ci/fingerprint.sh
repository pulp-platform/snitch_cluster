#!/usr/bin/env bash
# Copyright 2026 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Fingerprints the current working tree (HEAD, its diff against the tree, and
# untracked files). Shared single source of truth between the `ci` target in
# the Makefile, which writes it to a receipt on a successful run, and
# .claude/hooks/require-ci.sh, which blocks `git push` unless the receipt
# matches the tree's current fingerprint.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
{
  git rev-parse HEAD
  git diff HEAD
  git status --porcelain=v1 --untracked-files=all
} | sha256sum | cut -d' ' -f1
