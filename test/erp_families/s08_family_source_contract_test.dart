
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final models = File(
    'lib/src/families/erp/family_models.dart',
  ).readAsStringSync();
  final document = File(
    'lib/src/families/erp/family_document.dart',
  ).readAsStringSync();
  final types = File(
    'lib/src/families/erp/family_types.dart',
  ).readAsStringSync();

  test('S08 family classes exist', () {
    for (final token in <String>[
      'class GeniusErpTransactionDocument',
      'class GeniusErpStatementDocument',
      'class GeniusErpVoucherDocument',
      'class GeniusErpAnalyticalReport',
      'class GeniusErpOperationalForm',
      'class GeniusErpRegisterDocument',
      'class GeniusErpThermalReceipt',
      'class GeniusErpLabelDocument',
      'class GeniusErpCertificateDocument',
    ]) {
      expect(types, contains(token), reason: token);
    }
  });

  test('all required structural slots exist', () {
    for (final token in <String>[
      'header,',
      'identity,',
      'parties,',
      'references,',
      'body,',
      'summary,',
      'notesTerms,',
      'approvalsSignatures,',
      'attachmentsCodes,',
      'footer,',
    ]) {
      expect(models, contains(token), reason: token);
    }
  });

  test('S08 policies/extensions are explicit', () {
    for (final token in <String>[
      'enum GeniusErpSlotBreakPolicy',
      'class GeniusErpSlotPolicy',
      'class GeniusErpPageVariants',
      'class GeniusErpPrintProfile',
      'enum GeniusErpCodeKind',
      'class GeniusErpCodeSpec',
      'class GeniusErpCustomSection',
      'GeniusErpSlotComponentFactory',
      'class GeniusErpDocumentAdapter',
      'final Map<GeniusErpFamilySlot, GeniusErpSlotComponentFactory>',
    ]) {
      expect(models, contains(token), reason: token);
    }
  });

  test('before/after hooks do not expose renderer internals', () {
    final hookStart = models.indexOf(
      'class GeniusErpFamilyHookContext',
    );
    final hookEnd = models.indexOf(
      'typedef GeniusErpFamilyHook',
      hookStart,
    );
    final hookBlock = models.substring(hookStart, hookEnd);

    expect(hookBlock, isNot(contains('PdfPage')));
    expect(hookBlock, isNot(contains('PdfGraphics')));
    expect(hookBlock, isNot(contains('PdfDocument')));
  });

  test('family implementation uses shared S07/S06 structures', () {
    expect(document, contains('GeniusPdfDocumentIdentity('));
    expect(document, contains('GeniusPdfPartyBlock('));
    expect(document, contains('GeniusPdfTaxSummary('));
    expect(document, contains('GeniusPdfTermsSection('));
    expect(document, contains('GeniusPdfApprovalTrail('));
    expect(document, contains('_defaultSlotHasContent('));
    expect(document, contains('component == null || !component.isVisible'));
    expect(document, contains('updateFromLayoutResult('));
    expect(document, isNot(contains('/templates/')));
  });
}
