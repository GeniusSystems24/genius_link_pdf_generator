
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';
import 'package:genius_pdf_example/features/components/models/documents/components_demo_documents.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/create_save_open_pdf_button.dart';
enum _S00Scenario {
  mixedBaseline,
  summary,
  infoBox,
  reportHeader,
  dataGrid,
  richText,
  qrCode,
  watermark,
  longContent,
}

class S00BaselineRegressionVerificationPage extends StatefulWidget {
  const S00BaselineRegressionVerificationPage({super.key});

  @override
  State<S00BaselineRegressionVerificationPage> createState() =>
      _S00BaselineRegressionVerificationPageState();
}

class _S00BaselineRegressionVerificationPageState
    extends State<S00BaselineRegressionVerificationPage> {
  _S00Scenario _scenario = _S00Scenario.mixedBaseline;
  bool _rtl = true;
  late Future<Uint8List> _pdf;

  @override
  void initState() {
    super.initState();
    _pdf = _buildPdf();
  }

  GeniusPdfConfig get _config => geniusPdfConfig.copyWith(
        textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
      );

  void _refresh() {
    final nextPdf = _buildPdf();
    setState(() {
      _pdf = nextPdf;
    });
  }

  Future<Uint8List> _buildPdf() async {
    final config = _config;
    switch (_scenario) {
      case _S00Scenario.mixedBaseline:
        return _generate(_S00ManualBaselineDocument(config));
      case _S00Scenario.summary:
        return buildComponentDemoBytes(component: 'summary', config: config);
      case _S00Scenario.infoBox:
        return buildComponentDemoBytes(component: 'info_box', config: config);
      case _S00Scenario.reportHeader:
        return buildComponentDemoBytes(component: 'headers', config: config);
      case _S00Scenario.dataGrid:
        return buildComponentDemoBytes(component: 'data_grid', config: config);
      case _S00Scenario.richText:
        return buildComponentDemoBytes(component: 'rich_text', config: config);
      case _S00Scenario.qrCode:
        return buildComponentDemoBytes(component: 'grid_qrcode', config: config);
      case _S00Scenario.watermark:
        return buildComponentDemoBytes(component: 'grid_watermark', config: config);
      case _S00Scenario.longContent:
        return _generate(_S00LongManualDocument(config));
    }
  }

  Uint8List _generate(GeniusPdfDocumentBuilder builder) {
    final bytes = Uint8List.fromList(builder.generate());
    builder.dispose();
    return bytes;
  }

  String _name(_S00Scenario scenario) => switch (scenario) {
        _S00Scenario.mixedBaseline => 'Mixed ERP baseline',
        _S00Scenario.summary => 'Summary',
        _S00Scenario.infoBox => 'InfoBox',
        _S00Scenario.reportHeader => 'ReportHeader',
        _S00Scenario.dataGrid => 'DataGrid',
        _S00Scenario.richText => 'RichText',
        _S00Scenario.qrCode => 'QR / Barcode context',
        _S00Scenario.watermark => 'Watermark',
        _S00Scenario.longContent => 'Long / multi-page',
      };

  String get _expected => switch (_scenario) {
        _S00Scenario.mixedBaseline => _rtl
            ? 'S00 known baseline: Arabic labels should occupy the logical start '
                '(right) and amounts the opposite region. Check 13,650.00 SAR, '
                '2,047.50 SAR, 15,697.50 SAR, document number, SKU, IBAN, phone, '
                'email and URL. Independent value direction is a known S00 defect '
                'and is intentionally not fixed here.'
            : 'LTR control: labels should be left, values right, and all numeric/Latin '
                'ERP identifiers should remain readable.',
        _S00Scenario.summary =>
          'Review subtotal, VAT, grand total, wrapping, highlighting and placement. '
              'Compare LTR and RTL visually.',
        _S00Scenario.infoBox =>
          'Review label/value and icon placement plus mixed numeric/Latin values. '
              'S00 records current behavior rather than correcting it.',
        _S00Scenario.reportHeader =>
          'Header blocks, bilingual text and metadata must remain visible and unclipped.',
        _S00Scenario.dataGrid =>
          'Headers, rows, numeric cells and page flow must remain stable.',
        _S00Scenario.richText =>
          'Rich text must wrap without clipping or overlap.',
        _S00Scenario.qrCode =>
          'QR/barcode graphics must not be mirrored or corrupted by document direction.',
        _S00Scenario.watermark =>
          'Watermark must remain visible without clipping or accidental mirroring.',
        _S00Scenario.longContent =>
          'Output must span multiple pages without clipping/overlap; inspect transitions.',
      };

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
                    'Sprint S00 — Baseline & Regression Verification',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Manual acceptance harness for the current 4.0.0 baseline. '
                    'Known RTL issues are intentionally visible so S01/S02 can fix '
                    'them against a stable reference.',
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    children: [
                      SizedBox(
                        width: 250,
                        child: DropdownButtonFormField<_S00Scenario>(
                          initialValue: _scenario,
                          decoration: const InputDecoration(
                            labelText: 'Scenario',
                            border: OutlineInputBorder(),
                          ),
                          items: _S00Scenario.values
                              .map((value) => DropdownMenuItem(
                                    value: value,
                                    child: Text(_name(value)),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            _scenario = value;
                            _refresh();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: DropdownButtonFormField<bool>(
                          initialValue: _rtl,
                          decoration: const InputDecoration(
                            labelText: 'Direction',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(value: false, child: Text('LTR / EN')),
                            DropdownMenuItem(value: true, child: Text('RTL / AR')),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            _rtl = value;
                            _refresh();
                          },
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: _refresh,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Regenerate'),
                      ),
                      CreateSaveOpenPdfButton(
                        onCreate: _buildPdf,
                        fileName: 's00_baseline_regression.pdf',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text('Expected result: $_expected'),
                    ),
                  ),
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
                        'PDF generation failed:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
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

class _S00ManualBaselineDocument extends GeniusPdfDocumentBuilder {
  _S00ManualBaselineDocument(super.config);

  @override
  void build() {
    newPage();
    addSectionDivider(
      title: config.isRTL
          ? 'S00 — خط الأساس لاتجاه المحتوى'
          : 'S00 — Directionality baseline',
      spacing: 8,
    );
    addSpace(8);
    addReportSummary(
      summary: GeniusPdfSummarySection(
        config: config,
        width: 390,
        items: const [
          GeniusPdfSummaryItem(
            label: 'Subtotal',
            labelAr: 'المجموع الفرعي',
            value: '13,650.00 SAR',
          ),
          GeniusPdfSummaryItem(
            label: 'Tax (VAT)',
            labelAr: 'الضريبة (VAT)',
            value: '2,047.50 SAR',
          ),
          GeniusPdfSummaryItem.total(
            label: 'Grand Total',
            labelAr: 'الإجمالي النهائي',
            value: '15,697.50 SAR',
          ),
        ],
        style: GeniusPdfSummaryStyle.invoice(),
      ),
      spacing: 8,
    );
    addSpace(16);
    addInfoBox(
      GeniusPdfInfoBox(
        config: config,
        title: 'ERP mixed values',
        titleAr: 'قيم ERP مختلطة',
        showEmptyItems: true,
        items: [
          GeniusPdfLabeledValue(
            config: config,
            label: 'Document No.',
            labelAr: 'رقم المستند',
            value: 'INV-2026-000123',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: 'SKU',
            labelAr: 'رمز الصنف',
            value: 'SKU-AR-ENG-001',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: 'Serial',
            labelAr: 'الرقم التسلسلي',
            value: 'SN-AZ09-998877',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: 'IBAN',
            labelAr: 'الآيبان',
            value: 'SA0380000000608010167519',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: 'Phone',
            labelAr: 'الهاتف',
            value: '+966 55 123 4567',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: 'Email',
            labelAr: 'البريد',
            value: 'accounts@example.test',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: 'URL',
            labelAr: 'الرابط',
            value: 'https://erp.example.test/invoices/INV-2026-000123',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: 'Empty value',
            labelAr: 'قيمة فارغة',
            value: '',
          ),
        ],
      ),
      spacing: 8,
    );
  }
}

class _S00LongManualDocument extends GeniusPdfDocumentBuilder {
  _S00LongManualDocument(super.config);

  @override
  void build() {
    newPage();
    for (var i = 0; i < 90; i++) {
      addLine(
        config.isRTL
            ? '${i + 1}. هذا نص عربي طويل للتحقق من تدفق الصفحات — '
                'SKU-AR-ENG-001 — INV-2026-000123'
            : '${i + 1}. Long baseline content for page-flow verification — '
                'SKU-AR-ENG-001 — INV-2026-000123',
        topMargin: i == 0 ? 0 : 5,
      );
    }
  }
}
