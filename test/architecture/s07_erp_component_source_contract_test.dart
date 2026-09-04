
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final source = File(
    'lib/src/components/erp/semantic_components.dart',
  ).readAsStringSync();

  test('S07 component API surface is present', () {
    for (final token in <String>[
      'class GeniusPdfDocumentIdentity',
      'class GeniusPdfPartyBlock',
      'class GeniusPdfAddressBlock',
      'class GeniusPdfReferenceBlock',
      'class GeniusPdfMoney',
      'class GeniusPdfAmountInWords',
      'class GeniusPdfTaxSummary',
      'class GeniusPdfAdjustmentSummary',
      'class GeniusPdfBalanceDueBlock',
      'class GeniusPdfTermsSection',
      'class GeniusPdfApprovalTrail',
      'class GeniusPdfStamp',
      'class GeniusPdfMetricCards',
      'class GeniusPdfLabel',
      'class GeniusPdfErpComponentGroup',
      'enum GeniusPdfEmptySectionPolicy',
    ]) {
      expect(source, contains(token), reason: token);
    }
  });

  test('new S07 geometry is logical and physical conversion is draw-time', () {
    expect(source, contains('GeniusPdfDirectionalInsets'));
    expect(source, contains('GeniusPdfLogicalAlignment'));
    expect(source, contains('padding.resolve(resolvedDirection)'));
    expect(
      source,
      isNot(contains('this.left =')),
    );
    expect(
      source,
      isNot(contains('this.right =')),
    );
  });

  test('mixed values use value-kind direction policy', () {
    for (final token in <String>[
      'GeniusPdfValueKind.money',
      'GeniusPdfValueKind.documentNumber',
      'GeniusPdfValueKind.taxId',
      'GeniusPdfValueKind.phone',
      'GeniusPdfValueKind.email',
      'GeniusPdfValueKind.date',
      'GeniusPdfValueKind.dateTime',
    ]) {
      expect(source, contains(token), reason: token);
    }
  });

  test('no manual string reversal or UI/template business dependency', () {
    expect(source, isNot(contains('.reversed.join')));
    expect(source, isNot(contains("split('').reversed")));
    expect(source, isNot(contains('/templates/')));
    expect(source, isNot(contains('ErpCalculationService().calculate')));
  });
}
