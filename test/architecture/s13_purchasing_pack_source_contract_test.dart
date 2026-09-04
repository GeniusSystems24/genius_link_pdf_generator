
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('S13 document types are present and family backed', () {
    final source = File(
      'lib/src/packs/purchasing/purchasing_documents.dart',
    ).readAsStringSync();

    for (final marker in <String>[
      'class GeniusPurchasingTransactionDocument',
      'extends GeniusErpTransactionDocument',
      'class GeniusPurchaseRequisitionDocument',
      'class GeniusRequestForQuotationDocument',
      'class GeniusSupplierQuotationDocument',
      'class GeniusQuotationComparisonDocument',
      'class GeniusPurchaseOrderDocument',
      'class GeniusGoodsReceiptNoteDocument',
      'class GeniusPurchaseInvoiceDocument',
      'class GeniusPurchaseAdjustmentDocument',
      'class GeniusSupplierReturnDocument',
      'class GeniusSupplierStatementDocument',
      'class GeniusSupplierAgingDocument',
      'class GeniusPurchaseRegisterDocument',
      'class GeniusPurchaseAnalysisReport',
      'class GeniusOutstandingPurchaseOrdersReport',
      'GeniusPurchasingLandedChargesHook',
    ]) {
      expect(source, contains(marker), reason: marker);
    }
  });

  test('current PurchaseOrderTemplate joins the S13 pack base', () {
    final source = File(
      'lib/templates/purchase_order_template.dart',
    ).readAsStringSync();

    expect(
      source,
      contains(
        'class PurchaseOrderTemplate '
        'extends GeniusPurchasingTransactionDocument',
      ),
    );
  });

  test('S13 approval trail stays in shared family input', () {
    final calculation = File(
      'lib/src/packs/shared/erp_pack_calculation.dart',
    ).readAsStringSync();

    expect(calculation, contains('document: document'));
    expect(calculation, contains('showApprovals: showApprovals'));
  });

  test('mixed item codes and null shipping do not need renderer branches', () {
    final models = File(
      'lib/src/packs/purchasing/purchasing_models.dart',
    ).readAsStringSync();
    final documents = File(
      'lib/src/packs/purchasing/purchasing_documents.dart',
    ).readAsStringSync();

    expect(models, contains('final String itemCode;'));
    expect(documents, isNot(contains('shippingAddress!')));
  });
}
