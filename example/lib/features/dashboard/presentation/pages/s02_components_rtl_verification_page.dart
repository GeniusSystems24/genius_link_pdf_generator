
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/create_save_open_pdf_button.dart';
enum _S02Scenario {
  matrix,
  summary,
  infoBox,
  reportHeader,
  richText,
  dataGrid,
  media,
  nestedOverride,
  longMultiPage,
}

class S02ComponentsRtlVerificationPage extends StatefulWidget {
  const S02ComponentsRtlVerificationPage({super.key});

  @override
  State<S02ComponentsRtlVerificationPage> createState() =>
      _S02ComponentsRtlVerificationPageState();
}

class _S02ComponentsRtlVerificationPageState
    extends State<S02ComponentsRtlVerificationPage> {
  _S02Scenario scenario = _S02Scenario.matrix;
  GeniusPdfDirection direction = GeniusPdfDirection.rtl;
  bool showOptional = false;
  bool preserveGridOrder = false;
  late Future<Uint8List> pdf;

  @override
  void initState() {
    super.initState();
    pdf = _generate();
  }

  GeniusPdfDirectionality get directionality =>
      GeniusPdfDirectionality(documentDirection: direction);

  void change(VoidCallback action) {
    action();
    setState(() {
      pdf = _generate();
    });
  }

  Future<Uint8List> _generate() async {
    final resolved = directionality.resolve().direction;
    final config = geniusPdfConfig.copyWith(
      textDirection: resolved == GeniusPdfResolvedDirection.rtl
          ? TextDirection.rtl
          : TextDirection.ltr,
    );
    final builder = _S02Document(
      config: config,
      directionality: directionality,
      scenario: scenario,
      showOptional: showOptional,
      preserveGridOrder: preserveGridOrder,
    );
    final bytes = Uint8List.fromList(builder.generate());
    builder.dispose();
    return bytes;
  }

  String get expected => switch (scenario) {
        _S02Scenario.matrix =>
          'All components follow logical direction while ERP numbers/IDs stay LTR.',
        _S02Scenario.summary =>
          'RTL: label right, amount left. 15,697.50 SAR, negatives and percentages remain readable; empty optional rows leave no gap.',
        _S02Scenario.infoBox =>
          'Key/value rows, leading icon and columns mirror logically; IBAN/phone/email remain LTR.',
        _S02Scenario.reportHeader =>
          'Company/metadata placement follows direction; document/reference/date values remain stable.',
        _S02Scenario.richText =>
          'Arabic + Latin + punctuation wrap without reversing INV-2026-000123 or 15,697.50 SAR.',
        _S02Scenario.dataGrid =>
          preserveGridOrder
              ? 'RTL text with physical definition order preserved.'
              : 'RTL mirrors column order; numeric content remains LTR and right aligned.',
        _S02Scenario.media =>
          'Signer placement mirrors logically; QR/barcode pixels and payload are never mirrored.',
        _S02Scenario.nestedOverride =>
          'Nested LTR block does not change the RTL parent context.',
        _S02Scenario.longMultiPage =>
          'Long content spans multiple pages with the same direction/value rules.',
      };

  String label(_S02Scenario value) => value.name;

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
                    'Sprint S02 — Components RTL Verification',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      SizedBox(
                        width: 220,
                        child: DropdownButtonFormField<_S02Scenario>(
                          initialValue: scenario,
                          decoration: const InputDecoration(
                            labelText: 'Scenario',
                            border: OutlineInputBorder(),
                          ),
                          items: _S02Scenario.values
                              .map(
                                (x) => DropdownMenuItem(
                                  value: x,
                                  child: Text(label(x)),
                                ),
                              )
                              .toList(),
                          onChanged: (x) {
                            if (x != null) change(() => scenario = x);
                          },
                        ),
                      ),
                      SegmentedButton<GeniusPdfDirection>(
                        segments: const [
                          ButtonSegment(
                            value: GeniusPdfDirection.ltr,
                            label: Text('LTR'),
                          ),
                          ButtonSegment(
                            value: GeniusPdfDirection.rtl,
                            label: Text('RTL'),
                          ),
                        ],
                        selected: {direction},
                        onSelectionChanged: (x) =>
                            change(() => direction = x.first),
                      ),
                      FilterChip(
                        label: const Text('Show optional row'),
                        selected: showOptional,
                        onSelected: (x) => change(() => showOptional = x),
                      ),
                      FilterChip(
                        label: const Text('Preserve grid order'),
                        selected: preserveGridOrder,
                        onSelected: (x) =>
                            change(() => preserveGridOrder = x),
                      ),
                      FilledButton.icon(
                        onPressed: () => setState(() {
                          pdf = _generate();
                        }),
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Regenerate PDF'),
                      ),
                      CreateSaveOpenPdfButton(
                        onCreate: _generate,
                        fileName: 's02_components_rtl.pdf',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Expected Result: $expected'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: FutureBuilder<Uint8List>(
              future: pdf,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: SelectableText('${snapshot.error}'));
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
        ],
      ),
    );
  }
}

class _S02Document extends GeniusPdfDocumentBuilder {
  _S02Document({
    required GeniusPdfConfig config,
    required GeniusPdfDirectionality directionality,
    required this.scenario,
    required this.showOptional,
    required this.preserveGridOrder,
  }) : super(config, directionality: directionality);

  final _S02Scenario scenario;
  final bool showOptional;
  final bool preserveGridOrder;

  @override
  void build() {
    newPage();
    switch (scenario) {
      case _S02Scenario.matrix:
        summary();
        addSpace(8);
        infoBox();
        addSpace(8);
        richText();
        addSpace(8);
        grid();
      case _S02Scenario.summary:
        summary();
      case _S02Scenario.infoBox:
        infoBox();
      case _S02Scenario.reportHeader:
        header();
      case _S02Scenario.richText:
        richText();
      case _S02Scenario.dataGrid:
        grid();
      case _S02Scenario.media:
        media();
      case _S02Scenario.nestedOverride:
        nested();
      case _S02Scenario.longMultiPage:
        longPages();
    }
  }

  void summary() {
    addSummary(
      GeniusPdfSummarySection(
        config: config,
        directionality: directionality,
        hideEmptyValues: !showOptional,
        items: [
          GeniusPdfSummaryItem.formatted(
            label: 'Subtotal',
            labelAr: 'المجموع الفرعي',
            rawValue: 13650.0,
            formatter: config.formatter,
            formatSpec: const GeniusPdfFormatSpec.money(currencyCode: 'SAR'),
            isRtl: config.isRTL,
          ),
          GeniusPdfSummaryItem.formatted(
            label: 'Discount',
            labelAr: 'الخصم',
            rawValue: -1250.0,
            formatter: config.formatter,
            formatSpec: const GeniusPdfFormatSpec.money(currencyCode: 'SAR'),
            isRtl: config.isRTL,
          ),
          GeniusPdfSummaryItem.formatted(
            label: 'VAT',
            labelAr: 'ضريبة القيمة المضافة',
            rawValue: 15.0,
            formatter: config.formatter,
            formatSpec: const GeniusPdfFormatSpec.percentage(decimalPlaces: 2),
            isRtl: config.isRTL,
          ),
          const GeniusPdfSummaryItem(
            label: 'Optional charge',
            labelAr: 'رسم اختياري',
            value: '',
          ),
          GeniusPdfSummaryItem.formatted(
            label: 'Grand Total',
            labelAr: 'الإجمالي النهائي',
            rawValue: 15697.5,
            formatter: config.formatter,
            formatSpec: const GeniusPdfFormatSpec.money(currencyCode: 'SAR'),
            isBold: true,
            isHighlighted: true,
            isRtl: config.isRTL,
          ),
        ],
      ),
    );
  }

  void infoBox() {
    addInfoBox(
      GeniusPdfInfoBox(
        config: config,
        directionality: directionality,
        title: 'ERP Information',
        titleAr: 'معلومات ERP',
        subtitle: 'Mixed values',
        subtitleAr: 'قيم مختلطة',
        columns: 2,
        followDirection: true,
        iconPosition: GeniusPdfLogicalPosition.leading,
        items: [
          for (final row in const <(String, String, String)>[
            ('Document', 'المستند', 'INV-2026-000123'),
            ('IBAN', 'الآيبان', 'SA0380000000608010167519'),
            ('Phone', 'الهاتف', '+966 55 123 4567'),
            ('Email', 'البريد', 'accounts@example.test'),
          ])
            GeniusPdfLabeledValue(
              config: config,
              directionality: directionality,
              label: row.$1,
              labelAr: row.$2,
              value: row.$3,
              valueDirection: GeniusPdfDirection.ltr,
            ),
        ],
      ),
    );
  }

  void header() {
    addReportHeader(
      GeniusPdfReportHeader(
        config: config,
        directionality: directionality,
        title: 'Directionality Report',
        titleAr: 'تقرير اتجاه المحتوى',
        subtitle: 'Metadata stability',
        subtitleAr: 'ثبات بيانات المستند',
        documentNumber: 'INV-2026-000123',
        documentNumberLabel: 'Document No',
        documentNumberLabelAr: 'رقم المستند',
        referenceNumber: 'PO-2026-00998',
        referenceLabel: 'Reference',
        referenceLabelAr: 'المرجع',
        printDate: DateTime(2026, 9, 3),
        showCompanyInfo: false,
      ),
      height: 120,
    );
  }

  void richText() {
    final rich = GeniusPdfRichText(
      config: config,
      directionality: directionality,
      spans: const [
        GeniusPdfTextSpan(
          text: 'رقم المستند: ',
          direction: GeniusPdfDirection.rtl,
        ),
        GeniusPdfTextSpan(
          text: 'INV-2026-000123',
          direction: GeniusPdfDirection.ltr,
          isBold: true,
        ),
        GeniusPdfTextSpan(
          text: ' — الإجمالي: ',
          direction: GeniusPdfDirection.rtl,
        ),
        GeniusPdfTextSpan(
          text: '15,697.50 SAR',
          direction: GeniusPdfDirection.ltr,
          isBold: true,
        ),
        GeniusPdfTextSpan(
          text:
              ' — mixed Arabic/Latin punctuation and a long wrapping sentence.',
        ),
      ],
    );
    final result = rich.draw(page: currentPage, bounds: contentBounds);
    if (result != null) updateFromLayoutResult(result, spacing: 8);
  }

  void grid() {
    final component = GeniusPdfDataGrid(
      config: config,
      directionality: directionality,
      followDirection: true,
      preserveDefinitionOrder: preserveGridOrder,
      columns: const [
        GeniusPdfGridColumn(
          id: 'item',
          title: 'Item',
          titleAr: 'الصنف',
          directionalPadding: GeniusPdfDirectionalInsets(
            start: 8,
            end: 4,
            top: 4,
            bottom: 4,
          ),
        ),
        GeniusPdfGridColumn(
          id: 'sku',
          title: 'SKU',
          titleAr: 'رمز الصنف',
          contentDirection: GeniusPdfDirection.ltr,
        ),
        GeniusPdfGridColumn(
          id: 'qty',
          title: 'Qty',
          titleAr: 'الكمية',
          isNumeric: true,
          formatSpec: GeniusPdfFormatSpec.quantity(decimalPlaces: 2),
        ),
        GeniusPdfGridColumn(
          id: 'amount',
          title: 'Amount',
          titleAr: 'المبلغ',
          isNumeric: true,
          formatSpec: GeniusPdfFormatSpec.money(currencyCode: 'SAR'),
        ),
      ],
      rows: const [
        GeniusPdfGridRow(
          cells: {
            'item': 'منتج / Product',
            'sku': 'SKU-AR-ENG-001',
            'qty': 12.5,
            'amount': 15697.50,
          },
        ),
        GeniusPdfGridRow(
          cells: {
            'item': 'خدمة / Service',
            'sku': 'SRV-2026-009',
            'qty': 1,
            'amount': -1250.00,
          },
        ),
      ],
    );
    final result = component.draw(page: currentPage, bounds: contentBounds);
    if (result != null) updateFromLayoutResult(result, spacing: 8);
  }

  void media() {
    final signature = GeniusPdfSignatureArea(
      config: config,
      directionality: directionality,
      title: 'Authorized Signer',
      titleAr: 'الموقع المعتمد',
    );
    final a = signature.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 90),
    );
    resetY(a.bottom + 8);

    final barcode = GeniusPdfBarcode(
      config: config,
      directionality: directionality,
      data: 'INV-2026-000123',
      type: GeniusBarcodeType.code128,
      caption: 'Document barcode',
      captionAr: 'باركود المستند',
    );
    final b = barcode.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, currentY, pageWidth * .65, 110),
    );
    resetY(b.bottom + 8);
  }

  void nested() {
    addLine('RTL parent / سياق خارجي');
    final child = directionality.forComponent(GeniusPdfDirection.ltr);
    addInfoBox(
      GeniusPdfInfoBox(
        config: config,
        directionality: child,
        title: 'Nested LTR',
        titleAr: 'كتلة داخلية',
        items: [
          GeniusPdfLabeledValue(
            config: config,
            directionality: child,
            label: 'Invoice',
            labelAr: 'الفاتورة',
            value: 'INV-2026-000123',
            valueDirection: GeniusPdfDirection.ltr,
          ),
        ],
      ),
    );
    addLine('Parent direction is unchanged / الاتجاه الخارجي لم يتغير');
  }

  void longPages() {
    const ar =
        'هذا نص عربي طويل لاختبار اتجاه المحتوى عبر صفحات متعددة مع '
        'INV-2026-000123 و 15,697.50 SAR. ';
    const en =
        'Long English content validates multi-page direction with '
        'INV-2026-000123 and 15,697.50 SAR. ';
    for (var p = 0; p < 3; p++) {
      if (p > 0) newPage();
      addLine('S02 page ${p + 1}/3');
      for (var i = 0; i < 10; i++) {
        addLine(config.isRTL ? '$ar$ar' : '$en$en', topMargin: 6);
      }
      summary();
    }
  }
}
