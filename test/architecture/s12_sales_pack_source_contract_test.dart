
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('S12 public documents are family backed', () {
    final source = File(
      'lib/src/packs/sales/sales_documents.dart',
    ).readAsStringSync();

    for (final marker in <String>[
      'class GeniusSalesTransactionDocument extends GeniusErpTransactionDocument',
      'class GeniusSalesOrderDocument',
      'class GeniusProformaInvoiceDocument',
      'class GeniusPosInvoiceDocument',
      'class GeniusSalesDebitNoteDocument',
      'class GeniusSalesReturnDocument',
      'class GeniusCustomerReceiptDocument',
      'class GeniusPickingListDocument',
      'class GeniusPackingListDocument',
      'class GeniusBackorderDocument',
      'class GeniusCustomerAgingDocument',
      'class GeniusSalesRegisterDocument',
      'class GeniusSalesByCustomerReport',
      'class GeniusSalesByItemReport',
      'class GeniusSalesBySalespersonReport',
      'class GeniusPriceListDocument',
      'class GeniusCommissionReport',
    ]) {
      expect(source, contains(marker), reason: marker);
    }
  });

  test('S12 calculations are not implemented in renderers', () {
    final documents = File(
      'lib/src/packs/sales/sales_documents.dart',
    ).readAsStringSync();
    final calculation = File(
      'lib/src/packs/shared/erp_pack_calculation.dart',
    ).readAsStringSync();

    expect(documents, isNot(contains('unitPrice *')));
    expect(documents, isNot(contains('taxRate *')));
    expect(calculation, contains('ErpCalculationService'));
    expect(calculation, contains('GeniusErpPackTaxMode.inclusive'));
  });

  test('legacy sales templates join the S12 pack base', () {
    final quotation =
        File('lib/templates/quotation_template.dart').readAsStringSync();
    final invoice =
        File('lib/templates/tax_invoice_template.dart').readAsStringSync();

    expect(
      quotation,
      contains(
        'class QuotationTemplate extends GeniusSalesTransactionDocument',
      ),
    );
    expect(
      invoice,
      contains(
        'class TaxInvoiceTemplate extends GeniusSalesTransactionDocument',
      ),
    );
  });
}
