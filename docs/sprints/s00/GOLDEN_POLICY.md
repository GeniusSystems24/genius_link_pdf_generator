# S00 Golden Acceptance Policy

## Canonical naming

```text
s00__<subject>__<locale>__<direction>__<scenario>__pNN.png
```

Examples:

```text
s00__summary__ar__rtl__money-mixed__p01.png
s00__info-box__ar__rtl__identifiers__p01.png
s00__tax-invoice__en__ltr__minimal__p01.png
```

## Workflow

1. Run S00 tests normally; they must not write baseline files.
2. Capture PDFs with `GENIUS_CAPTURE_S00=1`.
3. Render candidates with `python tool/s00_render_goldens.py`.
4. Visually inspect every page.
5. Only after review run `python tool/s00_render_goldens.py --accept`.
6. Explain every intentional golden change in the relevant sprint/PR.

## Reject a candidate when it introduces

- clipping or overlap;
- unexpected page-count change;
- broken Arabic glyphs;
- incorrect logical placement;
- corrupted amount/identifier ordering;
- accidental QR/barcode/image mirroring.

Known S00 RTL defects remain in the S00 baseline. The reviewed visual
correction belongs to S02 rather than being silently rebased here.
