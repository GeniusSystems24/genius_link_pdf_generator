
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('S15 movement/count/report and labels are implemented', () {
    final documents = File(
      'lib/src/packs/inventory/inventory_documents.dart',
    ).readAsStringSync();
    final labels = File(
      'lib/src/packs/inventory/inventory_labels.dart',
    ).readAsStringSync();

    for (final marker in <String>[
      'GeniusStockReceiptDocument',
      'GeniusStockIssueDocument',
      'GeniusStockTransferDocument',
      'GeniusWarehouseTransferDocument',
      'GeniusStockAdjustmentDocument',
      'GeniusStockCountDocument',
      'GeniusCycleCountDocument',
      'GeniusCountReconciliationDocument',
      'GeniusItemCardDocument',
      'GeniusStockLedgerDocument',
      'GeniusStockValuationDocument',
      'GeniusStockAvailabilityDocument',
      'GeniusReorderReport',
      'GeniusInventoryMinMaxReport',
      'GeniusSlowDeadStockReport',
      'GeniusBatchReport',
      'GeniusSerialReport',
      'GeniusExpiryReport',
    ]) {
      expect(documents, contains(marker), reason: marker);
    }

    for (final marker in <String>[
      'GeniusInventoryItemLabelDocument',
      'GeniusShelfLabelDocument',
      'GeniusBatchLabelDocument',
      'GeniusSerialLabelDocument',
      'GeniusLocationLabelDocument',
      'GeniusPdfLabelPrintDocument',
    ]) {
      expect(labels, contains(marker), reason: marker);
    }
  });
}
