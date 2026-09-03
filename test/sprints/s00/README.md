
# Sprint S00 Regression Harness

This directory captures the pre-fix ERP-printing directionality baseline.

Normal S00 tests verify openability, A4/page-count baselines, canonical fixture
values, QR/barcode payload stability, LTR/RTL generation, bilingual content,
and long multi-page flow. Normal tests do not write files.

## Reproduce documented target failures

Set:

```text
GENIUS_RUN_KNOWN_FAILURES=1
```

The opt-in group is intentionally expected to fail on the S00 implementation.
It is isolated from normal CI and becomes an implementation target for S01/S02.

## Capture reference PDFs

Set:

```text
GENIUS_CAPTURE_S00=1
```

Captured PDFs/metadata are written to `test/sprints/s00/baselines/generated/`.

## Render visual candidates

```text
python tool/s00_render_goldens.py
```

After manual review only:

```text
python tool/s00_render_goldens.py --accept
```

Never accept a changed golden only to make a test pass.
