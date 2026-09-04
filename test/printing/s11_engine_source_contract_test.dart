
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final thermal = File(
    'lib/src/printing/profiles/thermal_receipt_engine.dart',
  ).readAsStringSync();
  final label = File(
    'lib/src/printing/profiles/label_engine.dart',
  ).readAsStringSync();
  final preprinted = File(
    'lib/src/printing/profiles/preprinted_form_engine.dart',
  ).readAsStringSync();
  final calibration = File(
    'lib/src/printing/profiles/calibration_test_document.dart',
  ).readAsStringSync();

  test('thermal foundation covers compact variable-height ERP receipts', () {
    for (final marker in <String>[
      'class GeniusPdfThermalReceiptEngine',
      'class GeniusPdfThermalPaymentLine',
      '_thermalReceiptConfig(',
      'data.payments',
      'GeniusPdfQRCodeGenerator(',
      'GeniusPdfBarcode.code128(',
      'PdfTextDirection.leftToRight',
      'profile.cutSpacing',
    ]) {
      expect(thermal, contains(marker), reason: marker);
    }
  });

  test('label foundation covers sheet, gap, bleed and ERP identifiers', () {
    for (final marker in <String>[
      'class GeniusPdfLabelPrintDocument',
      'profile.calibration.offset.dx',
      'spec.horizontalGap',
      'spec.verticalGap',
      'bleed',
      'data.sku',
      'data.batch',
      'data.serial',
      'data.expiry',
      'GeniusPdfQRCodeGenerator(',
      'GeniusPdfBarcode(',
      'PdfTextDirection.leftToRight',
    ]) {
      expect(label, contains(marker), reason: marker);
    }
  });

  test('pre-printed engine never mirrors physical anchors', () {
    expect(preprinted, contains('profile.physicalPlacement'));
    expect(preprinted, contains('anchor.x * calibration.scaleX'));
    expect(preprinted, contains('anchor.y * calibration.scaleY'));
    expect(preprinted, contains('structuredValue'));
    expect(preprinted, isNot(contains('logicalStartX(')));
    expect(preprinted, isNot(contains('logicalEndX(')));
    expect(preprinted, isNot(contains('pageWidth - anchor.x')));
  });

  test('calibration page exposes physical grid and scale metadata', () {
    expect(calibration, contains('10 * GeniusPdfPrintProfile.pointsPerMillimeter'));
    expect(calibration, contains('profile.calibration.offset.dx'));
    expect(calibration, contains('profile.calibration.scaleX'));
    expect(calibration, contains('_cross('));
  });
}
