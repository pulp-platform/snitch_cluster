#!/usr/bin/env bash
# Copyright 2026 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Blocks `git push` and `gh pr create` (which pushes implicitly) unless
# `make ci` has already passed against the exact current tree state.

set -euo pipefail

command=$(jq -r '.tool_input.command // empty')

# Anything that isn't push-like passes straight through.
if ! grep -qE 'git([[:space:]]+-C[[:space:]]+[^[:space:]]+)*[[:space:]]+push\b|gh[[:space:]]+pr[[:space:]]+create\b' <<< "$command"; then
  exit 0
fi

repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
git_dir=$(git rev-parse --git-dir 2>/dev/null) || exit 0
receipt="$git_dir/claude-ci-receipt"

current_fingerprint=$("$repo_root/util/ci/fingerprint.sh")

if [ -f "$receipt" ] && [ "$(cat "$receipt")" = "$current_fingerprint" ]; then
  exit 0
fi

cat >&2 <<'EOF'
Blocked: `make ci` has not passed against the current working tree.

Run `make ci-fast` to iterate quickly, then `make ci` for the full local CI
suite. Only a successful `make ci` — not `ci-fast` — writes the receipt that
unblocks this push. Prefer delegating the full run to the `ci-runner` subagent,
since its logs are too large for this context.
EOF
exit 2
