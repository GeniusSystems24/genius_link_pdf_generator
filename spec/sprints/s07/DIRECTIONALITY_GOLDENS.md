
# S07 Directionality Golden Matrix

The automated S07 golden layer intentionally records semantic direction
contracts rather than raw PDF bytes, because PDF metadata/object ordering can
change without a visual regression.

Tracked fixtures:

| Fixture | Layout | Prose | Money/ID/phone/email/date |
|---|---|---|---|
| `en_ltr_expected.txt` | LTR | LTR | LTR |
| `ar_rtl_expected.txt` | RTL | RTL | LTR |
| `bilingual_expected.txt` | RTL | RTL/mixed | LTR |

The render-smoke test additionally draws the real identity, party and mixed
address components in both LTR and RTL.

For visual acceptance, use the Dashboard page
`S07 ERP Semantic Components`. It renders the same public APIs into a real PDF
preview and provides dedicated identity/party, financial, operational,
null-collapse, empty-state, bilingual and long/multi-page scenarios.

Do not approve a directionality change solely by updating these text fixtures.
Check the actual PDF preview whenever geometry or rendering changed.
