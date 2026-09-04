# S04 DataGrid Benchmark Baseline

Version: **4.0.0**

S04 requires a 1k/10k-row benchmark according to the target environment.

The migration creates:

```text
benchmark/s04_data_grid_benchmark.dart
```

Run it locally, then replace the pending values below. A source-editing Python
migration cannot provide truthful runtime numbers for a Flutter/Dart target it
did not execute.

| Rows | Cold preparation | Warm preparation | Width cache | Notes |
|---:|---:|---:|---|---|
| 1,000 | PENDING_LOCAL_RUN | PENDING_LOCAL_RUN | expected warm hit | |
| 10,000 | PENDING_LOCAL_RUN | PENDING_LOCAL_RUN | expected warm hit | |

Record the OS/device, Flutter version, Dart version, dependency lockfile and any
release/debug mode information used for the accepted baseline.
