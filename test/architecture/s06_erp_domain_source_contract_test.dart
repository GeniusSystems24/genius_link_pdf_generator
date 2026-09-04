
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final models = File(
    'lib/src/domain/erp/models.dart',
  ).readAsStringSync();
  final calc = File(
    'lib/src/domain/erp/calculation.dart',
  ).readAsStringSync();

  test('S06 public model/task markers exist', () {
    final source = '$models\n$calc';
    for (final token in <String>[
      'class ErpDocumentContext',
      'class ErpOrganization',
      'class ErpBranch',
      'class ErpDocumentIdentity',
      'class ErpDocumentReference',
      'class ErpPrintMetadata',
      'enum ErpDocumentStatus',
      'class ErpParty',
      'class ErpAddress',
      'class ErpTaxIdentity',
      'class ErpContactMetadata',
      'enum ErpAddressRole',
      'class ErpMoney',
      'class ErpCurrency',
      'class ErpExchangeRate',
      'class ErpRoundingStrategy',
      'class ErpQuantity',
      'class ErpUnit',
      'class ErpLineItem',
      'class ErpTaxLine',
      'class ErpDiscount',
      'class ErpCharge',
      'class ErpBatchInfo',
      'class ErpSerialInfo',
      'class ErpApproval',
      'class ErpSignature',
      'class ErpAttachment',
      'class ErpCalculationService',
      'class ErpDomainValidator',
    ]) {
      expect(source, contains(token), reason: token);
    }
  });

  test('calculation does not depend on UI/template/rendering', () {
    for (final forbidden in <String>[
      'package:flutter/',
      'syncfusion_flutter_pdf',
      'PdfPage',
      'BuildContext',
      'Widget',
      '/templates/',
      '/components/',
    ]) {
      expect(calc, isNot(contains(forbidden)), reason: forbidden);
    }
  });

  test('serialization is not forced onto domain models', () {
    expect(models, isNot(contains('toJson(')));
    expect(models, isNot(contains('fromJson(')));

    final adapter = File(
      'lib/src/domain/erp/serialization.dart',
    ).readAsStringSync();
    expect(adapter, contains('class ErpDomainSerialization'));
  });
}
