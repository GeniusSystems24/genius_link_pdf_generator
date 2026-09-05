
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('S16 reuses S11 thermal/label foundation', () {
    final documents = File(
      'lib/src/packs/pos/pos_documents.dart',
    ).readAsStringSync();
    final labels = File(
      'lib/src/packs/pos/pos_labels.dart',
    ).readAsStringSync();

    for (final marker in <String>[
      'GeniusPosReceipt58Document',
      'GeniusPosReceipt80Document',
      'GeniusRefundReceiptDocument',
      'GeniusExchangeReceiptDocument',
      'GeniusGiftReceiptDocument',
      'GeniusKitchenOrderTicketDocument',
      'GeniusShiftOpenReport',
      'GeniusShiftCloseReport',
      'GeniusXReport',
      'GeniusZReport',
      'GeniusCashDrawerReport',
      'GeniusPaymentMethodSummaryReport',
      'extends GeniusPdfThermalReceiptEngine',
    ]) {
      expect(documents, contains(marker), reason: marker);
    }

    for (final marker in <String>[
      'GeniusRetailBarcodeLabelDocument',
      'GeniusRetailPriceLabelDocument',
      'GeniusRetailPromotionLabelDocument',
      'GeniusPdfLabelPrintDocument',
    ]) {
      expect(labels, contains(marker), reason: marker);
    }
  });

  test('S11 thermal engine has S16 non-breaking title/amount controls', () {
    final source = File(
      'lib/src/printing/profiles/thermal_receipt_engine.dart',
    ).readAsStringSync();

    expect(source, contains('this.showAmounts = true'));
    expect(source, contains('final bool showAmounts;'));
    expect(source, contains('data.showAmounts'));
    expect(source, contains('this.title'));
    expect(source, contains('this.titleAr'));
  });
}
