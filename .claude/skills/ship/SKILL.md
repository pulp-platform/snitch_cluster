---
name: ship
description: Verify local CI passes before pushing or opening a PR. Use this whenever a feature is implementation-complete and about to be pushed — it delegates verification to the ci-runner subagent and only pushes once it reports a receipt-writing `make ci` has succeeded against the current tree.
---

This repo enforces that `git push` and `gh pr create` are blocked
until a successful `make ci` run has stamped a receipt for the *exact*
current working tree. This skill is the procedure to get there.

## Why this exists

A green `make ci` is a genuine local stand-in for "would GitHub + GitLab CI
pass".

The receipt is a fingerprint of the tree (HEAD + diff + untracked files),
touching *anything* invalidates it, so this must be the last step before
pushing, not a one-time box to tick.

## The loop

1. **Delegate.** Ask the `ci-runner` subagent to verify the tree is ready to
   push. Don't run CI yourself — its logs are too large for this context, and
   how it gets there (a fast lane before the full suite) is its own concern,
   not something to manage from here.

2. **Iterate on real failures.** `ci-runner` reports only a real failure or a
   fully green `make ci` — never an intermediate pass. Fix what it reports
   and re-invoke it.

3. **Push.** Once `ci-runner` reports green, the receipt is written and
   current — `git push` (or `gh pr create`) will no longer be blocked. Don't
   re-run any other check first; the receipt check is exact.

## If the hook still blocks after a green run

The fingerprint is sensitive to *any* tree change, including ones made after
`make ci` finished — e.g. a last commit message edit that touches no tracked
content still updates `HEAD`, or a stray file created afterwards. If this
happens, that's the fingerprint correctly doing its job: re-run `make ci`
(via `ci-runner`) rather than trying to work around the block.

## Limitations, honestly

- The receipt check is not cryptographic proof that CI actually ran — it's a
  file comparison, and defends against *forgetting* this step, not against
  deliberately fabricating a receipt. Don't do that; run the real thing.
