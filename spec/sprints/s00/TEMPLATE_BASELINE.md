# S00 Template Baseline

Version: **4.0.0**  
Sprint: **S00**  
Baseline date: **2026-09-03**

S00 records deterministic minimal scenarios for the three templates that
are intentionally migrated much later in S09:

- `QuotationTemplate`
- `PurchaseOrderTemplate`
- `TaxInvoiceTemplate`

## Canonical financial scenario

| Field | Value |
|---|---:|
| Subtotal | `13,650.00 SAR` |
| VAT 15% | `2,047.50 SAR` |
| Grand total | `15,697.50 SAR` |

Fixtures use fixed dates/identifiers and one line item. They use A4
(`595 x 842` points) and assert that each minimal template currently stays
on one page. Any future intentional page-count change must be reviewed and
accepted explicitly.

## Runtime capture

Normal tests never mutate repository artifacts. Set the shell environment
variable below to capture the actual generated PDFs and page metadata:

```text
GENIUS_CAPTURE_S00=1
```

Captures are written to:

```text
test/sprints/s00/baselines/generated/
```

Then render candidate PNGs with:

```text
python tool/s00_render_goldens.py
```

The migration script itself deliberately does not invoke Flutter.

## Scope boundary

S00 captures current RTL/LTR behavior. It does **not** correct RTL/BiDi
layout or value direction. Those changes belong to S01/S02.
