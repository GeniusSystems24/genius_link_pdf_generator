
# S24 — Performance, Visual & Semantic Regression

Version: **4.0.0**

## Performance

S24 introduces portable benchmark infrastructure for every document family,
bounded caches for immutable resource/media bytes, measurement caching,
large-grid profiling proxies, background generation benchmarks and batch
generation benchmarks.

Performance baselines are identifiers and measured samples, not hard-coded
machine-independent pass/fail claims. CI can persist accepted thresholds for
its own hardware/runtime.

## Visual regression

`GeniusPdfGoldenManifest.core` provides component/family/core-ERP-pack coverage
for EN/LTR, AR/RTL, bilingual, thermal and label scenarios. The manifest is
renderer-neutral so environments can use raster goldens, normalized PDF
snapshots or other approved render baselines.

## Semantic regression

`GeniusPdfSemanticRegression` validates extracted text for document number,
party, totals, tax, page number, currency and required compliance metadata.

## Manual verification

The S24 Dashboard page demonstrates benchmark sampling, cache reuse and
semantic expectations. It also produces a real PDF preview for LTR/RTL and
large row-count scenarios.
