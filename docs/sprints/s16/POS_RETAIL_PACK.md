
# S16 — POS & Retail Pack

Version: **4.0.0**

S16 builds POS/Retail on the S11 thermal and label foundation instead of
creating another receipt renderer.

## Receipts

- `GeniusPosReceipt58Document`
- `GeniusPosReceipt80Document`
- `GeniusRefundReceiptDocument`
- `GeniusExchangeReceiptDocument`
- `GeniusGiftReceiptDocument`

`GeniusPosService.thermalData()` maps typed receipt inputs into
`GeniusPdfThermalReceiptData`.

S16 extends the S11 thermal payload non-breakingly with:

- optional receipt `title` / `titleAr`;
- `showAmounts`, defaulting to `true`.

This lets Gift Receipt and Kitchen Order Ticket suppress amount sections
without duplicating thermal layout.

## Restaurant option

`GeniusKitchenOrderTicketDocument` is an optional restaurant-oriented KOT.
It uses the same thermal engine and hides monetary sections.

## Operations

- Shift Open
- Shift Close
- X Report
- Z Report
- Cash Drawer Report
- Payment Method Summary

`GeniusPosShiftSummary` and `GeniusPosPaymentSummary` keep operational
calculations outside PDF rendering.

## Retail labels

S16 reuses the S11 label engine:

- Barcode Label
- Price Label
- Promotion Label

## Receipt behavior

`GeniusPosReceiptRequest` supports:

- tax summary;
- line/document discounts and promotions;
- cash received/change;
- multiple payment methods;
- QR and barcode;
- original/reprint markers;
- bilingual item text;
- Arabic line notes;
- high item counts.

The 58mm/80mm profile remains owned by S11.

## QA

The S16 verification page includes 58mm/80mm, refund/exchange/gift/KOT,
shift/X/Z/cash/payment reports, retail labels, LTR/RTL, long product names,
Arabic notes and high item-count scenarios.
