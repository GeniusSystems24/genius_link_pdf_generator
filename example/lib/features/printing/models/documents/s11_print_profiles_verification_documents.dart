// Generated from the former aggregate verification page.
// The runner contains generation logic only; presentation lives in
// focused example screens.
// ignore_for_file: unused_element

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

/// Scenarios extracted from the former S11PrintProfilesVerificationPage.
enum S11PrintProfilesScenario {
  a4Portrait,
  a4Landscape,
  a5,
  letter,
  legal,
  thermal58,
  thermal80,
  continuous,
  singleLabel,
  labelSheet,
  prePrinted,
  calibration,
}

/// Executes one focused S11 verification scenario.
class S11PrintProfilesRunner {
  S11PrintProfilesRunner({
    required GeniusPdfConfig baseConfig,
    required S11PrintProfilesScenario scenario,
  })  : _baseConfig = baseConfig,
        _scenario = scenario;

  final GeniusPdfConfig _baseConfig;
  final S11PrintProfilesScenario _scenario;
bool _rtl = false;
String _name(S11PrintProfilesScenario value) => switch (value) {
        S11PrintProfilesScenario.a4Portrait => 'A4 portrait',
        S11PrintProfilesScenario.a4Landscape => 'A4 landscape',
        S11PrintProfilesScenario.a5 => 'A5',
        S11PrintProfilesScenario.letter => 'Letter',
        S11PrintProfilesScenario.legal => 'Legal',
        S11PrintProfilesScenario.thermal58 => '58mm thermal',
        S11PrintProfilesScenario.thermal80 => '80mm thermal',
        S11PrintProfilesScenario.continuous => 'Continuous paper',
        S11PrintProfilesScenario.singleLabel => 'Single label',
        S11PrintProfilesScenario.labelSheet => 'Label sheet',
        S11PrintProfilesScenario.prePrinted => 'Pre-printed physical anchors',
        S11PrintProfilesScenario.calibration => 'Calibration page',
      };

  String get _expected => switch (_scenario) {
        S11PrintProfilesScenario.a4Portrait =>
          'A4 portrait geometry, margins and safe-area metadata apply.',
        S11PrintProfilesScenario.a4Landscape =>
          'A4 landscape rotates through the profile, not ad-hoc template code.',
        S11PrintProfilesScenario.a5 =>
          'A5 uses 420×595pt with scaled typography.',
        S11PrintProfilesScenario.letter =>
          'Letter uses the package Letter page size.',
        S11PrintProfilesScenario.legal =>
          'Legal uses the package Legal page size.',
        S11PrintProfilesScenario.thermal58 =>
          '58mm receipt uses compact variable-height content with no cut-edge '
              'clipping; money/date/IDs remain LTR inside RTL.',
        S11PrintProfilesScenario.thermal80 =>
          '80mm receipt uses compact variable-height content with payment '
              'lines, totals, QR and barcode.',
        S11PrintProfilesScenario.continuous =>
          'Continuous profile uses explicit width and nominal variable height.',
        S11PrintProfilesScenario.singleLabel =>
          'One calibrated label renders SKU/batch/serial/expiry and Code128.',
        S11PrintProfilesScenario.labelSheet =>
          'Sheet grid preserves physical gaps/bleed/calibration; captions '
              'follow LTR/RTL without reordering printer geometry.',
        S11PrintProfilesScenario.prePrinted =>
          'Physical x/y anchors stay identical in LTR and RTL; structured '
              'document numbers remain LTR.',
        S11PrintProfilesScenario.calibration =>
          '10mm physical grid/crosses allow measuring printer offset/scale.',
      };

  GeniusPdfConfig get _config => _baseConfig.copyWith(
        textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
      );

  Future<Uint8List> generate() async {
    final config = _config;
    late final GeniusPdfDocumentBuilder document;

    switch (_scenario) {
      case S11PrintProfilesScenario.a4Portrait:
        final profile = GeniusPdfPrintProfile.a4Portrait();
        document = _ProfileProofDocument(
          profile.apply(config),
          profile: profile,
        );
        break;
      case S11PrintProfilesScenario.a4Landscape:
        final profile = GeniusPdfPrintProfile.a4Landscape();
        document = _ProfileProofDocument(
          profile.apply(config),
          profile: profile,
        );
        break;
      case S11PrintProfilesScenario.a5:
        final profile = GeniusPdfPrintProfile.a5();
        document = _ProfileProofDocument(
          profile.apply(config),
          profile: profile,
        );
        break;
      case S11PrintProfilesScenario.letter:
        final profile = GeniusPdfPrintProfile.letter();
        document = _ProfileProofDocument(
          profile.apply(config),
          profile: profile,
        );
        break;
      case S11PrintProfilesScenario.legal:
        final profile = GeniusPdfPrintProfile.legal();
        document = _ProfileProofDocument(
          profile.apply(config),
          profile: profile,
        );
        break;
      case S11PrintProfilesScenario.continuous:
        final profile = GeniusPdfPrintProfile.continuous(
          width: 80 * GeniusPdfPrintProfile.pointsPerMillimeter,
          nominalHeight: 800,
        );
        document = _ProfileProofDocument(
          profile.apply(config),
          profile: profile,
        );
        break;
      case S11PrintProfilesScenario.thermal58:
        document = GeniusPdfThermalReceiptEngine(
          config: config,
          profile: GeniusPdfPrintProfile.thermal58(),
          data: _receiptData(),
        );
        break;
      case S11PrintProfilesScenario.thermal80:
        document = GeniusPdfThermalReceiptEngine(
          config: config,
          profile: GeniusPdfPrintProfile.thermal80(),
          data: _receiptData(),
        );
        break;
      case S11PrintProfilesScenario.singleLabel:
        final profile = GeniusPdfPrintProfile.customLabel(
          width: 200,
          height: 120,
          calibration: const GeniusPdfPrintCalibration(
            offset: GeniusPdfPrintOffset(dx: 1, dy: -1),
          ),
        );
        document = GeniusPdfLabelPrintDocument(
          config: config,
          profile: profile,
          labels: [_labelData(1)],
        );
        break;
      case S11PrintProfilesScenario.labelSheet:
        final profile = GeniusPdfPrintProfile.labelSheet(
          columns: 3,
          rows: 8,
          labelWidth: 180,
          labelHeight: 90,
          horizontalGap: 6,
          verticalGap: 4,
          bleed: 1.5,
          calibration: const GeniusPdfPrintCalibration(
            offset: GeniusPdfPrintOffset(dx: 1.5, dy: -2),
            scaleX: 1.001,
            scaleY: 0.999,
          ),
        );
        document = GeniusPdfLabelPrintDocument(
          config: config,
          profile: profile,
          labels: List.generate(24, (index) => _labelData(index + 1)),
        );
        break;
      case S11PrintProfilesScenario.prePrinted:
        final profile = GeniusPdfPrintProfile.prePrinted(
          calibration: const GeniusPdfPrintCalibration(
            offset: GeniusPdfPrintOffset(dx: 2, dy: -1),
          ),
        );
        document = GeniusPdfPreprintedFormDocument(
          config: config,
          profile: profile,
          debugAnchors: true,
          fields: const [
            GeniusPdfPreprintedField(
              id: 'document-number',
              value: 'INV-2026-0001',
              structuredValue: true,
              anchor: GeniusPdfPreprintedFieldAnchor(
                x: 370,
                y: 80,
                width: 165,
                height: 22,
              ),
            ),
            GeniusPdfPreprintedField(
              id: 'customer',
              value: 'شركة أكمي / Acme',
              direction: GeniusPdfDirection.rtl,
              anchor: GeniusPdfPreprintedFieldAnchor(
                x: 60,
                y: 145,
                width: 260,
                height: 30,
              ),
            ),
            GeniusPdfPreprintedField(
              id: 'amount',
              value: '1,234.50 SAR',
              structuredValue: true,
              anchor: GeniusPdfPreprintedFieldAnchor(
                x: 370,
                y: 210,
                width: 160,
                height: 24,
              ),
            ),
          ],
        );
        break;
      case S11PrintProfilesScenario.calibration:
        document = GeniusPdfCalibrationTestDocument(
          config: config,
          profile: GeniusPdfPrintProfile.a4Portrait().copyWith(
            calibration: const GeniusPdfPrintCalibration(
              offset: GeniusPdfPrintOffset(dx: 1.5, dy: -2),
              scaleX: 1.001,
              scaleY: 0.999,
            ),
          ),
        );
        break;
    }

    final bytes = Uint8List.fromList(document.generate());
    document.dispose();
    return bytes;
  }

  GeniusPdfThermalReceiptData _receiptData() {
    return GeniusPdfThermalReceiptData(
      merchantName: 'Genius ERP Store',
      merchantNameAr: 'متجر جينيس ERP',
      receiptNumber: 'POS-2026-0001',
      date: DateTime(2026, 9, 4),
      currency: 'SAR',
      items: const [
        GeniusPdfThermalLineItem(
          description: 'Cup of tea',
          descriptionAr: 'كوب شاي',
          sku: 'TEA-001',
          quantity: 2,
          unitPrice: 5,
        ),
        GeniusPdfThermalLineItem(
          description: 'Long product name for thermal wrapping verification',
          descriptionAr: 'اسم منتج طويل للتحقق من الالتفاف في الطباعة الحرارية',
          sku: 'LONG-002',
          quantity: 1,
          unitPrice: 25.50,
          discount: 2,
        ),
      ],
      tax: 5.03,
      discount: 1,
      payments: const [
        GeniusPdfThermalPaymentLine(
          label: 'Cash',
          labelAr: 'نقداً',
          amount: 20,
        ),
        GeniusPdfThermalPaymentLine(
          label: 'Card',
          labelAr: 'بطاقة',
          amount: 17.53,
        ),
      ],
      qrData: 'https://example.com/r/POS-2026-0001',
      barcodeData: 'POS20260001',
      footer: 'Thank you',
      footerAr: 'شكراً لكم',
    );
  }

  GeniusPdfLabelData _labelData(int index) => GeniusPdfLabelData(
        title: 'ERP Product $index',
        titleAr: 'منتج ERP $index',
        sku: 'SKU-${index.toString().padLeft(4, '0')}',
        batch: 'B-2026-09',
        serial: 'SN${100000 + index}',
        expiry: DateTime(2027, 9, 30),
        barcodeData: 'SKU${index.toString().padLeft(8, '0')}',
      );
}

class _ProfileProofDocument extends GeniusPdfDocumentBuilder {
  _ProfileProofDocument(
    super.config, {
    required this.profile,
  });

  final GeniusPdfPrintProfile profile;

  @override
  void build() {
    newPage();
    addLine(
      config.isRTL
          ? 'تحقق ملف الطباعة'
          : 'Print Profile Verification',
      font: config.headerFont,
      topMargin: 4,
    );
    addLine('ID: ${profile.id}', topMargin: 4);
    addLine(
      'Page: ${profile.pageSize.width.toStringAsFixed(1)} × '
      '${profile.pageSize.height.toStringAsFixed(1)} pt',
      topMargin: 4,
    );
    addLine(
      'Margins: ${profile.margins.left}, ${profile.margins.top}, '
      '${profile.margins.right}, ${profile.margins.bottom}',
      topMargin: 4,
    );
    addLine(
      'Safe area: ${profile.safeArea.left}, ${profile.safeArea.top}, '
      '${profile.safeArea.right}, ${profile.safeArea.bottom}',
      topMargin: 4,
    );
    addLine(
      'Density: ${profile.density.name} | '
      'Font scale: ${profile.fontScale}',
      topMargin: 4,
    );
  }
}

Future<Uint8List> buildS11A4PortraitVerificationPdf(GeniusPdfConfig config) {
  final runner = S11PrintProfilesRunner(
    baseConfig: config,
    scenario: S11PrintProfilesScenario.a4Portrait,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS11A4LandscapeVerificationPdf(GeniusPdfConfig config) {
  final runner = S11PrintProfilesRunner(
    baseConfig: config,
    scenario: S11PrintProfilesScenario.a4Landscape,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS11A5VerificationPdf(GeniusPdfConfig config) {
  final runner = S11PrintProfilesRunner(
    baseConfig: config,
    scenario: S11PrintProfilesScenario.a5,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS11LetterVerificationPdf(GeniusPdfConfig config) {
  final runner = S11PrintProfilesRunner(
    baseConfig: config,
    scenario: S11PrintProfilesScenario.letter,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS11LegalVerificationPdf(GeniusPdfConfig config) {
  final runner = S11PrintProfilesRunner(
    baseConfig: config,
    scenario: S11PrintProfilesScenario.legal,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS11Thermal58VerificationPdf(GeniusPdfConfig config) {
  final runner = S11PrintProfilesRunner(
    baseConfig: config,
    scenario: S11PrintProfilesScenario.thermal58,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS11Thermal80VerificationPdf(GeniusPdfConfig config) {
  final runner = S11PrintProfilesRunner(
    baseConfig: config,
    scenario: S11PrintProfilesScenario.thermal80,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS11ContinuousVerificationPdf(GeniusPdfConfig config) {
  final runner = S11PrintProfilesRunner(
    baseConfig: config,
    scenario: S11PrintProfilesScenario.continuous,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS11SingleLabelVerificationPdf(GeniusPdfConfig config) {
  final runner = S11PrintProfilesRunner(
    baseConfig: config,
    scenario: S11PrintProfilesScenario.singleLabel,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS11LabelSheetVerificationPdf(GeniusPdfConfig config) {
  final runner = S11PrintProfilesRunner(
    baseConfig: config,
    scenario: S11PrintProfilesScenario.labelSheet,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS11PrePrintedVerificationPdf(GeniusPdfConfig config) {
  final runner = S11PrintProfilesRunner(
    baseConfig: config,
    scenario: S11PrintProfilesScenario.prePrinted,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS11CalibrationVerificationPdf(GeniusPdfConfig config) {
  final runner = S11PrintProfilesRunner(
    baseConfig: config,
    scenario: S11PrintProfilesScenario.calibration,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}
