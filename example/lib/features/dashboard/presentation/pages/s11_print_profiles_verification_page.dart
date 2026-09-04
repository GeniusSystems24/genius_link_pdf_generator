
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/create_save_open_pdf_button.dart';
enum _S11Scenario {
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

class S11PrintProfilesVerificationPage extends StatefulWidget {
  const S11PrintProfilesVerificationPage({super.key});

  @override
  State<S11PrintProfilesVerificationPage> createState() =>
      _S11PrintProfilesVerificationPageState();
}

class _S11PrintProfilesVerificationPageState
    extends State<S11PrintProfilesVerificationPage> {
  _S11Scenario _scenario = _S11Scenario.thermal80;
  bool _rtl = false;
  late Future<Uint8List> _pdf;

  @override
  void initState() {
    super.initState();
    _pdf = _generate();
  }

  String _name(_S11Scenario value) => switch (value) {
        _S11Scenario.a4Portrait => 'A4 portrait',
        _S11Scenario.a4Landscape => 'A4 landscape',
        _S11Scenario.a5 => 'A5',
        _S11Scenario.letter => 'Letter',
        _S11Scenario.legal => 'Legal',
        _S11Scenario.thermal58 => '58mm thermal',
        _S11Scenario.thermal80 => '80mm thermal',
        _S11Scenario.continuous => 'Continuous paper',
        _S11Scenario.singleLabel => 'Single label',
        _S11Scenario.labelSheet => 'Label sheet',
        _S11Scenario.prePrinted => 'Pre-printed physical anchors',
        _S11Scenario.calibration => 'Calibration page',
      };

  String get _expected => switch (_scenario) {
        _S11Scenario.a4Portrait =>
          'A4 portrait geometry, margins and safe-area metadata apply.',
        _S11Scenario.a4Landscape =>
          'A4 landscape rotates through the profile, not ad-hoc template code.',
        _S11Scenario.a5 =>
          'A5 uses 420×595pt with scaled typography.',
        _S11Scenario.letter =>
          'Letter uses the package Letter page size.',
        _S11Scenario.legal =>
          'Legal uses the package Legal page size.',
        _S11Scenario.thermal58 =>
          '58mm receipt uses compact variable-height content with no cut-edge '
              'clipping; money/date/IDs remain LTR inside RTL.',
        _S11Scenario.thermal80 =>
          '80mm receipt uses compact variable-height content with payment '
              'lines, totals, QR and barcode.',
        _S11Scenario.continuous =>
          'Continuous profile uses explicit width and nominal variable height.',
        _S11Scenario.singleLabel =>
          'One calibrated label renders SKU/batch/serial/expiry and Code128.',
        _S11Scenario.labelSheet =>
          'Sheet grid preserves physical gaps/bleed/calibration; captions '
              'follow LTR/RTL without reordering printer geometry.',
        _S11Scenario.prePrinted =>
          'Physical x/y anchors stay identical in LTR and RTL; structured '
              'document numbers remain LTR.',
        _S11Scenario.calibration =>
          '10mm physical grid/crosses allow measuring printer offset/scale.',
      };

  GeniusPdfConfig get _config => geniusPdfConfig.copyWith(
        textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
      );

  Future<Uint8List> _generate() async {
    final config = _config;
    late final GeniusPdfDocumentBuilder document;

    switch (_scenario) {
      case _S11Scenario.a4Portrait:
        final profile = GeniusPdfPrintProfile.a4Portrait();
        document = _ProfileProofDocument(
          profile.apply(config),
          profile: profile,
        );
        break;
      case _S11Scenario.a4Landscape:
        final profile = GeniusPdfPrintProfile.a4Landscape();
        document = _ProfileProofDocument(
          profile.apply(config),
          profile: profile,
        );
        break;
      case _S11Scenario.a5:
        final profile = GeniusPdfPrintProfile.a5();
        document = _ProfileProofDocument(
          profile.apply(config),
          profile: profile,
        );
        break;
      case _S11Scenario.letter:
        final profile = GeniusPdfPrintProfile.letter();
        document = _ProfileProofDocument(
          profile.apply(config),
          profile: profile,
        );
        break;
      case _S11Scenario.legal:
        final profile = GeniusPdfPrintProfile.legal();
        document = _ProfileProofDocument(
          profile.apply(config),
          profile: profile,
        );
        break;
      case _S11Scenario.continuous:
        final profile = GeniusPdfPrintProfile.continuous(
          width: 80 * GeniusPdfPrintProfile.pointsPerMillimeter,
          nominalHeight: 800,
        );
        document = _ProfileProofDocument(
          profile.apply(config),
          profile: profile,
        );
        break;
      case _S11Scenario.thermal58:
        document = GeniusPdfThermalReceiptEngine(
          config: config,
          profile: GeniusPdfPrintProfile.thermal58(),
          data: _receiptData(),
        );
        break;
      case _S11Scenario.thermal80:
        document = GeniusPdfThermalReceiptEngine(
          config: config,
          profile: GeniusPdfPrintProfile.thermal80(),
          data: _receiptData(),
        );
        break;
      case _S11Scenario.singleLabel:
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
      case _S11Scenario.labelSheet:
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
      case _S11Scenario.prePrinted:
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
      case _S11Scenario.calibration:
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

  void _change(VoidCallback action) {
    action();
    setState(() {
      _pdf = _generate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Sprint S11 — Print Profiles, Thermal & Labels',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 290,
                        child: DropdownButtonFormField<_S11Scenario>(
                          key: ValueKey(_scenario),
                          initialValue: _scenario,
                          decoration: const InputDecoration(
                            labelText: 'Scenario',
                            border: OutlineInputBorder(),
                          ),
                          items: _S11Scenario.values
                              .map(
                                (value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(_name(value)),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            _change(() => _scenario = value);
                          },
                        ),
                      ),
                      SegmentedButton<bool>(
                        segments: const [
                          ButtonSegment(
                            value: false,
                            label: Text('LTR'),
                          ),
                          ButtonSegment(
                            value: true,
                            label: Text('RTL'),
                          ),
                        ],
                        selected: {_rtl},
                        onSelectionChanged: (selection) {
                          _change(() => _rtl = selection.first);
                        },
                      ),
                      FilledButton.icon(
                        onPressed: () => _change(() {}),
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Regenerate PDF'),
                      ),
                      CreateSaveOpenPdfButton(
                        onCreate: _generate,
                        fileName: 's11_print_profiles.pdf',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Expected Result: $_expected'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: FutureBuilder<Uint8List>(
                future: _pdf,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: SelectableText(
                        'Generation failed:\n${snapshot.error}',
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return GeniusPdfPreviewWidget(
                    pdfData: snapshot.data!,
                    canChangeOrientation: false,
                    canChangePageFormat: false,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
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
