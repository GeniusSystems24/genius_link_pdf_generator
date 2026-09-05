
# S09 Golden Comparison Matrix

S09 keeps S00 as the historical pre-migration reference and adds semantic/render
verification for the migrated implementation.

| Template | EN/LTR | AR/RTL | Bilingual | 1 line | 50 lines | 500 lines |
|---|---:|---:|---:|---:|---:|---:|
| Quotation | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Purchase Order | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Tax Invoice | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |

Additional verification scenarios:

- long notes/terms;
- long party names;
- null optional address/notes/terms/QR/signature sections;
- tax/discount totals;
- amount-in-words on Tax Invoice;
- QR/image preservation;
- RTL summary direction.

The automated tests intentionally compare deterministic semantic/calculation
snapshots and render-smoke invariants instead of raw PDF byte equality, because
PDF object ordering/metadata can vary while visuals remain equivalent.

Human approval of intentional RTL visual corrections is still required before
the S09 Exit Gate is checked.
