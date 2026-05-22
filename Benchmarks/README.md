# Benchmarks

Performance benchmarks for swift-inflect, built with [package-benchmark](https://github.com/ordo-one/package-benchmark).

All commands below must be run from the `Benchmarks/` directory.

## Prerequisites

```bash
brew install jemalloc
```

## Running

```bash
# Run all benchmarks
swift package benchmark

# Run a subset by name (regex)
swift package benchmark run --filter "pluralize|singularize"
```

## Comparing results

### Save a baseline

```bash
swift package benchmark baseline update main
```

Baseline files are written to `.benchmarkBaselines/` — commit them so others have the same reference point.

### Compare against a saved baseline

```bash
swift package benchmark baseline compare main
```

This prints a delta table showing improvements (green) and regressions (red) across all metrics.

### Compare two named baselines

```bash
swift package benchmark baseline update before-my-change
# make changes
swift package benchmark baseline update after-my-change
swift package benchmark baseline compare before-my-change after-my-change
```

## CI regression checks

Thresholds that define acceptable regression bounds live in `Thresholds/`. To fail a build when a benchmark regresses beyond them:

```bash
swift package benchmark baseline compare main \
    --check-absolute-path Thresholds/absolute.json \
    --check-relative-path Thresholds/relative.json
```

Exit code is non-zero on regression, suitable for use in a PR check.
