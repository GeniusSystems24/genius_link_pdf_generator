
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/create_save_open_pdf_button.dart';
enum _S16Scenario {
  receipt58,
  receipt80,
  refund,
  exchange,
  gift,
  kot,
  shiftOpen,
  shiftClose,
  xReport,
  zReport,
  cashDrawer,
  paymentSummary,
  barcodeLabel,
  priceLabel,
  promotionLabel,
}

class S16PosRetailPackVerificationPage extends StatefulWidget {
  const S16PosRetailPackVerificationPage({super.key});

  @override
  State<S16PosRetailPackVerificationPage> createState() =>
      _S16PosRetailPackVerificationPageState();
}

class _S16PosRetailPackVerificationPageState
    extends State<S16PosRetailPackVerificationPage> {
  _S16Scenario _scenario = _S16Scenario.receipt80;
  bool _rtl = false;
  bool _reprint = false;
  int _itemCount = 1;
  late Future<Uint8List> _pdf;

  @override
  void initState() {
    super.initState();
    _pdf = _generate();
  }

  GeniusPdfConfig get _config => geniusPdfConfig.copyWith(
        textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
      );

  String _label(_S16Scenario value) => switch (value) {
        _S16Scenario.receipt58 => '58mm Receipt',
        _S16Scenario.receipt80 => '80mm Receipt',
        _S16Scenario.refund => 'Refund Receipt',
        _S16Scenario.exchange => 'Exchange Receipt',
        _S16Scenario.gift => 'Gift Receipt',
        _S16Scenario.kot => 'Kitchen Order Ticket',
        _S16Scenario.shiftOpen => 'Shift Open',
        _S16Scenario.shiftClose => 'Shift Close',
        _S16Scenario.xReport => 'X Report',
        _S16Scenario.zReport => 'Z Report',
        _S16Scenario.cashDrawer => 'Cash Drawer',
        _S16Scenario.paymentSummary => 'Payment Method Summary',
        _S16Scenario.barcodeLabel => 'Barcode Label',
        _S16Scenario.priceLabel => 'Price Label',
        _S16Scenario.promotionLabel => 'Promotion Label',
      };

  String get _expected =>
      'Expected Result: ${_label(_scenario)} uses the S16 public API, '
      '${_rtl ? 'RTL/compact Arabic' : 'LTR'} layout and $_itemCount item(s). '
      'Long names wrap, Arabic notes remain under the item, SKU/QR/barcode '
      'payloads stay LTR, tax/promotion/cash/change/multi-payment remain '
      'visible when applicable, and no content is cut at the thermal end.'
      '${_reprint ? ' Reprint marker must be visible.' : ''}';

  Future<Uint8List> _generate() async {
    final config = _config;
    const service = GeniusPosService();
    final receipt = _receipt(_itemCount);
    final shift = _shift();
    late final GeniusPdfDocumentBuilder document;

    switch (_scenario) {
      case _S16Scenario.receipt58:
        document = GeniusPosReceipt58Document(
          config: config,
          request: receipt,
        );
        break;
      case _S16Scenario.receipt80:
        document = GeniusPosReceipt80Document(
          config: config,
          request: receipt,
        );
        break;
      case _S16Scenario.refund:
        document = GeniusRefundReceiptDocument(
          config: config,
          request: receipt,
        );
        break;
      case _S16Scenario.exchange:
        document = GeniusExchangeReceiptDocument(
          config: config,
          request: receipt,
        );
        break;
      case _S16Scenario.gift:
        document = GeniusGiftReceiptDocument(
          config: config,
          request: receipt,
        );
        break;
      case _S16Scenario.kot:
        document = GeniusKitchenOrderTicketDocument(
          config: config,
          request: receipt,
        );
        break;
      case _S16Scenario.shiftOpen:
        document = GeniusShiftOpenReport(
          config,
          report: service.shiftOpen(shift),
        );
        break;
      case _S16Scenario.shiftClose:
        document = GeniusShiftCloseReport(
          config,
          report: service.shiftClose(shift),
        );
        break;
      case _S16Scenario.xReport:
        document = GeniusXReport(
          config,
          report: service.xReport(shift),
        );
        break;
      case _S16Scenario.zReport:
        document = GeniusZReport(
          config,
          report: service.zReport(shift),
        );
        break;
      case _S16Scenario.cashDrawer:
        document = GeniusCashDrawerReport(
          config,
          report: service.cashDrawer(shift),
        );
        break;
      case _S16Scenario.paymentSummary:
        document = GeniusPaymentMethodSummaryReport(
          config,
          report: service.paymentMethodSummary(shift.payments),
        );
        break;
      case _S16Scenario.barcodeLabel:
        document = GeniusRetailBarcodeLabelDocument(
          config: config,
          labels: _retailLabels(_itemCount.clamp(1, 50).toInt()),
        );
        break;
      case _S16Scenario.priceLabel:
        document = GeniusRetailPriceLabelDocument(
          config: config,
          labels: _retailLabels(_itemCount.clamp(1, 50).toInt()),
        );
        break;
      case _S16Scenario.promotionLabel:
        document = GeniusRetailPromotionLabelDocument(
          config: config,
          labels: _retailLabels(_itemCount.clamp(1, 50).toInt()),
        );
        break;
    }

    final bytes = Uint8List.fromList(document.generate());
    document.dispose();
    return bytes;
  }

  GeniusPosReceiptRequest _receipt(int count) {
    final lines = List.generate(
      count,
      (index) => GeniusPosReceiptLine(
        description: index == 0
            ? 'Very long retail product name that must wrap on narrow thermal paper without clipping'
            : 'Retail Product ${index + 1}',
        descriptionAr: index == 0
            ? 'اسم منتج تجزئة عربي طويل جداً يجب أن يلتف داخل الورق الحراري الضيق دون قص'
            : 'منتج تجزئة ${index + 1}',
        sku: 'SKU-${(index + 1).toString().padLeft(6, '0')}',
        quantity: index.isEven ? 1.5 : 2,
        unitPrice: 10 + index % 7,
        discount: index % 4 == 0 ? 1.5 : 0,
        tax: 1.5 + index % 3,
        promotion: index % 5 == 0 ? 'BUY-MORE' : null,
        promotionAr: index % 5 == 0 ? 'عرض شراء' : null,
        note: index == 0 ? 'No sugar / extra hot' : null,
        noteAr: index == 0 ? 'بدون سكر / ساخن جداً' : null,
      ),
    );

    final tax = lines.fold<double>(
      0,
      (sum, line) => sum + line.tax,
    );
    final taxable = lines.fold<double>(
      0,
      (sum, line) => sum + line.lineSubtotal - line.discount,
    );

    return GeniusPosReceiptRequest(
      merchantName: 'Genius Retail Store',
      merchantNameAr: 'متجر جينيس للتجزئة',
      receiptNumber: 'POS-2026-0001',
      date: DateTime(2026, 9, 4),
      lines: lines,
      documentDiscount: 2,
      payments: const [
        GeniusPosPayment(
          method: GeniusPosPaymentMethod.cash,
          amount: 20,
        ),
        GeniusPosPayment(
          method: GeniusPosPaymentMethod.card,
          amount: 30,
          reference: 'AUTH-001',
        ),
        GeniusPosPayment(
          method: GeniusPosPaymentMethod.wallet,
          amount: 10,
          reference: 'WALLET-01',
        ),
      ],
      taxSummary: [
        GeniusPosTaxSummaryLine(
          code: 'VAT',
          ratePercent: 15,
          taxableAmount: taxable,
          taxAmount: tax,
        ),
      ],
      cashReceived: 50,
      change: 5,
      qrData: 'https://example.com/receipts/POS-2026-0001',
      barcodeData: 'POS20260001',
      reprint: _reprint,
      copyLabel: _reprint ? 'REPRINT COPY' : 'Original',
      copyLabelAr: _reprint ? 'نسخة معاد طباعتها' : 'الأصل',
      footer: 'Thank you — Please keep your receipt.',
      footerAr: 'شكراً لكم — يرجى الاحتفاظ بالإيصال.',
    );
  }

  GeniusPosShiftSummary _shift() => GeniusPosShiftSummary(
        shiftId: 'SHIFT-2026-09-04-A',
        openedAt: DateTime(2026, 9, 4, 8),
        closedAt: DateTime(2026, 9, 4, 20),
        cashier: 'Cashier 01',
        terminal: 'POS-01',
        openingCash: ErpMoney.fromAmount(
          500,
          currency: ErpCurrency.sar,
        ),
        sales: ErpMoney.fromAmount(
          5000,
          currency: ErpCurrency.sar,
        ),
        refunds: ErpMoney.fromAmount(
          200,
          currency: ErpCurrency.sar,
        ),
        discounts: ErpMoney.fromAmount(
          100,
          currency: ErpCurrency.sar,
        ),
        tax: ErpMoney.fromAmount(
          705,
          currency: ErpCurrency.sar,
        ),
        expectedCash: ErpMoney.fromAmount(
          1800,
          currency: ErpCurrency.sar,
        ),
        actualCash: ErpMoney.fromAmount(
          1795,
          currency: ErpCurrency.sar,
        ),
        payments: [
          GeniusPosPaymentSummary(
            method: GeniusPosPaymentMethod.cash,
            amount: ErpMoney.fromAmount(
              1300,
              currency: ErpCurrency.sar,
            ),
            transactionCount: 42,
          ),
          GeniusPosPaymentSummary(
            method: GeniusPosPaymentMethod.card,
            amount: ErpMoney.fromAmount(
              3000,
              currency: ErpCurrency.sar,
            ),
            transactionCount: 70,
          ),
          GeniusPosPaymentSummary(
            method: GeniusPosPaymentMethod.wallet,
            amount: ErpMoney.fromAmount(
              700,
              currency: ErpCurrency.sar,
            ),
            transactionCount: 15,
          ),
        ],
      );

  List<GeniusPosRetailLabel> _retailLabels(int count) =>
      List.generate(
        count,
        (index) => GeniusPosRetailLabel(
          itemCode: 'SKU-${index + 1}',
          itemName: 'Retail Label ${index + 1}',
          itemNameAr: 'ملصق تجزئة ${index + 1}',
          price: ErpMoney.fromAmount(
            25 + index,
            currency: ErpCurrency.sar,
          ),
          oldPrice: index % 2 == 0
              ? ErpMoney.fromAmount(
                  30 + index,
                  currency: ErpCurrency.sar,
                )
              : null,
          promotion: index % 2 == 0 ? '20% OFF' : null,
          promotionAr: index % 2 == 0 ? 'خصم 20%' : null,
          qrData: 'https://example.com/retail/${index + 1}',
        ),
      );

  void _refresh() {
    setState(() {
      _pdf = _generate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Sprint S16 — POS & Retail Pack',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 280,
                        child: DropdownButtonFormField<_S16Scenario>(
                          initialValue: _scenario,
                          decoration: const InputDecoration(
                            labelText: 'Scenario',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            for (final value in _S16Scenario.values)
                              DropdownMenuItem(
                                value: value,
                                child: Text(_label(value)),
                              ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            _scenario = value;
                            _refresh();
                          },
                        ),
                      ),
                      SegmentedButton<int>(
                        segments: const [
                          ButtonSegment(value: 1, label: Text('1')),
                          ButtonSegment(value: 50, label: Text('50')),
                          ButtonSegment(value: 250, label: Text('250')),
                        ],
                        selected: {_itemCount},
                        onSelectionChanged: (value) {
                          _itemCount = value.first;
                          _refresh();
                        },
                      ),
                      FilterChip(
                        label: const Text('RTL'),
                        selected: _rtl,
                        onSelected: (value) {
                          _rtl = value;
                          _refresh();
                        },
                      ),
                      FilterChip(
                        label: const Text('Reprint'),
                        selected: _reprint,
                        onSelected: (value) {
                          _reprint = value;
                          _refresh();
                        },
                      ),
                      FilledButton.icon(
                        onPressed: _refresh,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Regenerate PDF'),
                      ),
                      CreateSaveOpenPdfButton(
                        onCreate: _generate,
                        fileName: 's16_pos_retail_pack.pdf',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(_expected),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: FutureBuilder<Uint8List>(
                future: _pdf,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: SelectableText(
                        'Generation failed:\n${snapshot.error}',
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return GeniusPdfPreviewWidget(
                    pdfData: snapshot.data!,
                    canChangeOrientation: false,
                    canChangePageFormat: false,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
