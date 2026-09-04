
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final templates = <String, String>{
    'quotation': File(
      'lib/templates/quotation_template.dart',
    ).readAsStringSync(),
    'purchaseOrder': File(
      'lib/templates/purchase_order_template.dart',
    ).readAsStringSync(),
    'taxInvoice': File(
      'lib/templates/tax_invoice_template.dart',
    ).readAsStringSync(),
  };

  test('all three templates extend the same Transaction family', () {
    for (final entry in templates.entries) {
      expect(
        entry.value,
        contains('extends GeniusErpTransactionDocument'),
        reason: entry.key,
      );
      expect(
        entry.value,
        contains('GeniusErpFamilyPlan createFamilyPlan()'),
        reason: entry.key,
      );
    }
  });

  test('legacy adapters exist', () {
    expect(
      templates['quotation'],
      contains('class QuotationErpAdapter'),
    );
    expect(
      templates['purchaseOrder'],
      contains('class PurchaseOrderErpAdapter'),
    );
    expect(
      templates['taxInvoice'],
      contains('class TaxInvoiceErpAdapter'),
    );
  });

  test('template rendering no longer duplicates grid/info/summary helpers', () {
    for (final entry in templates.entries) {
      expect(
        entry.value,
        isNot(contains('GeniusPdfDataGrid(')),
        reason: entry.key,
      );
      expect(
        entry.value,
        isNot(contains('GeniusPdfSummarySection(')),
        reason: entry.key,
      );
      expect(
        entry.value,
        isNot(contains('void _drawItemsTable(')),
        reason: entry.key,
      );
      expect(
        entry.value,
        isNot(contains('String _formatCurrency(')),
        reason: entry.key,
      );
    }
  });

  test('family owns shared renderer construction once', () {
    final family = File(
      'lib/src/families/erp/family_document.dart',
    ).readAsStringSync();

    expect(family, contains('GeniusPdfDataGrid('));
    expect(family, contains('GeniusPdfPartyBlock('));
    expect(family, contains('GeniusPdfTaxSummary('));
    expect(family, contains('GeniusPdfTermsSection('));
  });
}
