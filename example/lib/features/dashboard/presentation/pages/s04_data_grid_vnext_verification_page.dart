import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/create_save_open_pdf_button.dart';
enum _S04Scenario {
  sizing,
  longContent,
  pagination,
  grouping,
  spansAndBuilders,
  erpFormatting,
  directionality,
  emptyState,
  largeData,
}

class S04DataGridVNextVerificationPage extends StatefulWidget {
  const S04DataGridVNextVerificationPage({super.key});

  @override
  State<S04DataGridVNextVerificationPage> createState() =>
      _S04DataGridVNextVerificationPageState();
}

class _S04DataGridVNextVerificationPageState
    extends State<S04DataGridVNextVerificationPage> {
  _S04Scenario _scenario = _S04Scenario.sizing;
  GeniusPdfDirection _direction = GeniusPdfDirection.ltr;
  bool _preserveOrder = false;
  late Future<Uint8List> _pdfFuture;

  @override
  void initState() {
    super.initState();
    _pdfFuture = _generate();
  }

  void _change(VoidCallback mutation) {
    mutation();
    setState(() {
      _pdfFuture = _generate();
    });
  }

  String _scenarioLabel(_S04Scenario value) {
    switch (value) {
      case _S04Scenario.sizing:
        return 'Column sizing';
      case _S04Scenario.longContent:
        return 'Long content / overflow';
      case _S04Scenario.pagination:
        return 'Multi-page / repeated header';
      case _S04Scenario.grouping:
        return 'Nested groups / subtotals';
      case _S04Scenario.spansAndBuilders:
        return 'Spans / builders / conditional style';
      case _S04Scenario.erpFormatting:
        return 'ERP formatting / accounting';
      case _S04Scenario.directionality:
        return 'RTL / per-column direction';
      case _S04Scenario.emptyState:
        return 'Null / empty state';
      case _S04Scenario.largeData:
        return '1k-row large-data mode';
    }
  }

  String _expectedResult() {
    switch (_scenario) {
      case _S04Scenario.sizing:
        return 'SKU keeps a fixed width, description auto-fits inside min/max, '
            'and amount receives flex space without overflowing the page.';
      case _S04Scenario.longContent:
        return 'The description wraps without overlap. Ellipsis/clip policies '
            'stay inside the resolved column width.';
      case _S04Scenario.pagination:
        return 'The grid spans multiple pages, its column header repeats, and '
            'rows stay together by default.';
      case _S04Scenario.grouping:
        return 'Region/category groups are nested; group subtotals are placed '
            'after each group; grand total is last; RTL indentation moves right.';
      case _S04Scenario.spansAndBuilders:
        return 'The configured row/column span is applied. Row/cell builders '
            'and conditional styles affect only matching data.';
      case _S04Scenario.erpFormatting:
        return 'Money/percentage/quantity/date hooks are usable, negative '
            'accounting values use parentheses, and currency can vary per row.';
      case _S04Scenario.directionality:
        return _preserveOrder
            ? 'RTL text is used while physical definition order stays unchanged.'
            : 'RTL follows logical column order; numeric and identifier runs remain LTR.';
      case _S04Scenario.emptyState:
        return 'A single bilingual empty-state row spans every visible column.';
      case _S04Scenario.largeData:
        return '1,000 rows are lazily prepared, widths/styles are cacheable, '
            'and repeated headers remain correct across generated pages.';
    }
  }

  Future<Uint8List> _generate() async {
    final config = geniusPdfConfig.copyWith(
      textDirection: _direction == GeniusPdfDirection.rtl
          ? TextDirection.rtl
          : TextDirection.ltr,
    );

    final builder = _S04GridDocument(
      config: config,
      directionality: GeniusPdfDirectionality(
        documentDirection: _direction,
      ),
      scenario: _scenario,
      preserveOrder: _preserveOrder,
    );

    final bytes = Uint8List.fromList(builder.generate());
    builder.dispose();
    return bytes;
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
                    'Sprint S04 — DataGrid vNext',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Manual acceptance matrix for sizing, pagination, grouping, '
                    'spans, ERP formatter hooks, RTL, empty state and large data.',
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 270,
                        child: DropdownButtonFormField<_S04Scenario>(
                          key: ValueKey(_scenario),
                          initialValue: _scenario,
                          decoration: const InputDecoration(
                            labelText: 'Scenario',
                            border: OutlineInputBorder(),
                          ),
                          items: _S04Scenario.values
                              .map(
                                (value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(_scenarioLabel(value)),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            _change(() {
                              _scenario = value;
                            });
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
                        selected: {_direction},
                        onSelectionChanged: (selection) {
                          _change(() {
                            _direction = selection.first;
                          });
                        },
                      ),
                      FilterChip(
                        label: const Text('Preserve column order'),
                        selected: _preserveOrder,
                        onSelected: (value) {
                          _change(() {
                            _preserveOrder = value;
                          });
                        },
                      ),
                      FilledButton.icon(
                        onPressed: () {
                          setState(() {
                            _pdfFuture = _generate();
                          });
                        },
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Regenerate PDF'),
                      ),
                      CreateSaveOpenPdfButton(
                        onCreate: _generate,
                        fileName: 's04_data_grid_vnext.pdf',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'Expected Result: ${_expectedResult()}',
                      ),
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
                future: _pdfFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: SelectableText(
                        'Generation failed:\n${snapshot.error}',
                        textAlign: TextAlign.center,
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

class _S04GridDocument extends GeniusPdfDocumentBuilder {
  _S04GridDocument({
    required GeniusPdfConfig config,
    required GeniusPdfDirectionality directionality,
    required this.scenario,
    required this.preserveOrder,
  }) : super(config, directionality: directionality);

  final _S04Scenario scenario;
  final bool preserveOrder;

  @override
  void build() {
    newPage();
    final result = _buildGrid().draw(
      page: currentPage,
      bounds: contentBounds,
    );
    if (result != null) {
      updateFromLayoutResult(result, spacing: 8);
    }
  }

  List<GeniusPdfGridColumn> get _columns => const [
        GeniusPdfGridColumn(
          id: 'sku',
          title: 'SKU',
          titleAr: 'رمز الصنف',
        ),
        GeniusPdfGridColumn(
          id: 'description',
          title: 'Description',
          titleAr: 'الوصف',
        ),
        GeniusPdfGridColumn(
          id: 'qty',
          title: 'Qty',
          titleAr: 'الكمية',
          isNumeric: true,
        ),
        GeniusPdfGridColumn(
          id: 'amount',
          title: 'Amount',
          titleAr: 'المبلغ',
          isNumeric: true,
        ),
      ];

  Map<String, GeniusPdfGridColumnPolicy> get _standardPolicies => const {
        'sku': GeniusPdfGridColumnPolicy(
          widthMode: GeniusPdfGridWidthMode.fixed,
          fixedWidth: 90,
          contentDirection: GeniusPdfDirection.ltr,
        ),
        'description': GeniusPdfGridColumnPolicy(
          widthMode: GeniusPdfGridWidthMode.flex,
          flex: 3,
          minWidth: 170,
          overflow: GeniusPdfGridTextOverflow.wrap,
        ),
        'qty': GeniusPdfGridColumnPolicy(
          widthMode: GeniusPdfGridWidthMode.fixed,
          fixedWidth: 55,
          valueKind: GeniusPdfGridValueKind.quantity,
        ),
        'amount': GeniusPdfGridColumnPolicy(
          widthMode: GeniusPdfGridWidthMode.fixed,
          fixedWidth: 115,
          valueKind: GeniusPdfGridValueKind.money,
          currencyCode: 'SAR',
        ),
      };

  GeniusPdfDataGridVNext _buildGrid() {
    switch (scenario) {
      case _S04Scenario.sizing:
        return GeniusPdfDataGridVNext(
          config: config,
          columns: _columns,
          rows: _rows(18),
          preserveDefinitionOrder: preserveOrder,
          columnPolicies: const {
            'sku': GeniusPdfGridColumnPolicy(
              widthMode: GeniusPdfGridWidthMode.fixed,
              fixedWidth: 86,
              contentDirection: GeniusPdfDirection.ltr,
            ),
            'description': GeniusPdfGridColumnPolicy(
              widthMode: GeniusPdfGridWidthMode.autoFit,
              minWidth: 145,
              maxWidth: 250,
            ),
            'qty': GeniusPdfGridColumnPolicy(
              widthMode: GeniusPdfGridWidthMode.fixed,
              fixedWidth: 58,
              valueKind: GeniusPdfGridValueKind.quantity,
            ),
            'amount': GeniusPdfGridColumnPolicy(
              widthMode: GeniusPdfGridWidthMode.flex,
              flex: 2,
              minWidth: 92,
              valueKind: GeniusPdfGridValueKind.money,
              currencyCode: 'SAR',
            ),
          },
        );

      case _S04Scenario.longContent:
        return GeniusPdfDataGridVNext(
          config: config,
          columns: _columns,
          rows: [
            ..._rows(8),
            const GeniusPdfGridRow(
              cells: {
                'sku': 'LONG-001',
                'description':
                    'وصف عربي طويل جدًا مع English product description '
                    'وملاحظات إضافية لاختبار الالتفاف وعدم تداخل النص.',
                'qty': 2,
                'amount': 15697.50,
              },
            ),
          ],
          columnPolicies: const {
            'sku': GeniusPdfGridColumnPolicy(
              widthMode: GeniusPdfGridWidthMode.fixed,
              fixedWidth: 80,
              overflow: GeniusPdfGridTextOverflow.ellipsis,
              contentDirection: GeniusPdfDirection.ltr,
            ),
            'description': GeniusPdfGridColumnPolicy(
              widthMode: GeniusPdfGridWidthMode.flex,
              flex: 3,
              overflow: GeniusPdfGridTextOverflow.wrap,
              minWidth: 180,
            ),
            'qty': GeniusPdfGridColumnPolicy(
              widthMode: GeniusPdfGridWidthMode.fixed,
              fixedWidth: 55,
              valueKind: GeniusPdfGridValueKind.quantity,
            ),
            'amount': GeniusPdfGridColumnPolicy(
              widthMode: GeniusPdfGridWidthMode.fixed,
              fixedWidth: 105,
              valueKind: GeniusPdfGridValueKind.money,
              currencyCode: 'SAR',
            ),
          },
        );

      case _S04Scenario.pagination:
        return GeniusPdfDataGridVNext(
          config: config,
          columns: _columns,
          rows: _rows(140),
          repeatHeaderOnPages: true,
          rowSplitPolicy: GeniusPdfGridRowSplitPolicy.keepTogether,
          columnPolicies: _standardPolicies,
        );

      case _S04Scenario.grouping:
        final rows = List<GeniusPdfGridRow>.generate(
          90,
          (index) => GeniusPdfGridRow(
            cells: {
              'sku': 'SKU-${index.toString().padLeft(4, '0')}',
              'description': 'Grouped ERP item $index',
              'qty': (index % 8) + 1,
              'amount': (index + 1) * 17.25,
              'region': index.isEven ? 'north' : 'south',
              'category': index % 3 == 0 ? 'hardware' : 'services',
            },
          ),
        );
        return GeniusPdfDataGridVNext(
          config: config,
          columns: _columns,
          rows: rows,
          repeatHeaderOnPages: true,
          repeatGroupHeaders: true,
          groupBy: [
            GeniusPdfGridGroupDefinition(
              keySelector: (row) => row.cells['region'],
              titleBuilder: (key) => 'Region: $key',
              titleArBuilder: (key) => 'المنطقة: $key',
            ),
            GeniusPdfGridGroupDefinition(
              keySelector: (row) => row.cells['category'],
              titleBuilder: (key) => 'Category: $key',
              titleArBuilder: (key) => 'الفئة: $key',
            ),
          ],
          groupSummaries: const [
            GeniusPdfGridSummaryExpression.sum(
              outputColumnId: 'amount',
              sourceColumnId: 'amount',
              label: 'Subtotal',
              labelAr: 'المجموع الفرعي',
              labelColumnId: 'description',
            ),
          ],
          grandTotals: const [
            GeniusPdfGridSummaryExpression.sum(
              outputColumnId: 'amount',
              sourceColumnId: 'amount',
              label: 'Grand Total',
              labelAr: 'الإجمالي العام',
              labelColumnId: 'description',
            ),
          ],
          columnPolicies: _standardPolicies,
        );

      case _S04Scenario.spansAndBuilders:
        return GeniusPdfDataGridVNext(
          config: config,
          columns: _columns,
          rows: _rows(20),
          cellSpans: const [
            GeniusPdfGridCellSpan(
              rowIndex: 0,
              columnId: 'sku',
              rowSpan: 2,
              columnSpan: 2,
            ),
          ],
          rowStyleBuilder: (context) {
            if (context.rowIndex == 5) {
              return const GeniusPdfCellStyle(
                backgroundColor: Color(0xFFFFF3CD),
              );
            }
            return null;
          },
          cellStyleBuilder: (context) {
            if (context.column.id == 'amount' &&
                context.value is num &&
                (context.value as num) > 200) {
              return const GeniusPdfCellStyle(
                backgroundColor: Color(0xFFE8F5E9),
              );
            }
            return null;
          },
          cellBuilder: (context) {
            if (context.column.id == 'description' &&
                context.rowIndex == 3) {
              return const GeniusPdfGridCellBuildResult(
                value: 'Built by cellBuilder',
              );
            }
            return null;
          },
          columnPolicies: _standardPolicies,
        );

      case _S04Scenario.erpFormatting:
        return GeniusPdfDataGridVNext(
          config: config,
          columns: _columns,
          rows: const [
            GeniusPdfGridRow(
              cells: {
                'sku': 'INV-2026-000123',
                'description': 'Debit / مدين',
                'qty': 0.15,
                'amount': -1250.0,
                'currency': 'SAR',
              },
            ),
            GeniusPdfGridRow(
              cells: {
                'sku': 'PO-2026-00998',
                'description': 'Credit / دائن',
                'qty': 12.5,
                'amount': 2047.50,
                'currency': 'USD',
              },
            ),
          ],
          columnPolicies: {
            'sku': const GeniusPdfGridColumnPolicy(
              widthMode: GeniusPdfGridWidthMode.autoFit,
              valueKind: GeniusPdfGridValueKind.identifier,
              contentDirection: GeniusPdfDirection.ltr,
            ),
            'description': const GeniusPdfGridColumnPolicy(
              widthMode: GeniusPdfGridWidthMode.flex,
              flex: 2,
            ),
            'qty': const GeniusPdfGridColumnPolicy(
              widthMode: GeniusPdfGridWidthMode.fixed,
              fixedWidth: 68,
              valueKind: GeniusPdfGridValueKind.percentage,
              percentageIsFraction: true,
              decimalPlaces: 2,
            ),
            'amount': GeniusPdfGridColumnPolicy(
              widthMode: GeniusPdfGridWidthMode.fixed,
              fixedWidth: 120,
              valueKind: GeniusPdfGridValueKind.money,
              accountingNegative: true,
              currencyResolver: (row) =>
                  row.cells['currency']?.toString(),
            ),
          },
        );

      case _S04Scenario.directionality:
        return GeniusPdfDataGridVNext(
          config: config,
          columns: _columns,
          rows: _rows(40),
          followDirection: true,
          preserveDefinitionOrder: preserveOrder,
          columnPolicies: const {
            'sku': GeniusPdfGridColumnPolicy(
              widthMode: GeniusPdfGridWidthMode.fixed,
              fixedWidth: 92,
              contentDirection: GeniusPdfDirection.ltr,
              headerPadding: GeniusPdfGridDirectionalPadding(
                start: 10,
                end: 4,
                top: 4,
                bottom: 4,
              ),
              cellPadding: GeniusPdfGridDirectionalPadding(
                start: 8,
                end: 4,
                top: 4,
                bottom: 4,
              ),
            ),
            'description': GeniusPdfGridColumnPolicy(
              widthMode: GeniusPdfGridWidthMode.flex,
              flex: 3,
            ),
            'qty': GeniusPdfGridColumnPolicy(
              widthMode: GeniusPdfGridWidthMode.fixed,
              fixedWidth: 58,
              valueKind: GeniusPdfGridValueKind.quantity,
            ),
            'amount': GeniusPdfGridColumnPolicy(
              widthMode: GeniusPdfGridWidthMode.fixed,
              fixedWidth: 115,
              valueKind: GeniusPdfGridValueKind.money,
              currencyCode: 'SAR',
            ),
          },
        );

      case _S04Scenario.emptyState:
        return GeniusPdfDataGridVNext(
          config: config,
          columns: _columns,
          rows: const [],
          emptyState: const GeniusPdfGridEmptyState(
            message: 'No inventory transactions',
            messageAr: 'لا توجد حركات مخزون',
          ),
          columnPolicies: _standardPolicies,
        );

      case _S04Scenario.largeData:
        return GeniusPdfDataGridVNext(
          config: config,
          columns: _columns,
          rowSource: GeniusPdfGridLazyRowSource(
            length: 1000,
            builder: (index) => GeniusPdfGridRow(
              cells: {
                'sku': 'SKU-${index.toString().padLeft(6, '0')}',
                'description': 'Large-data item $index',
                'qty': (index % 100) + 1,
                'amount': index * 3.75,
              },
            ),
          ),
          repeatHeaderOnPages: true,
          performance: const GeniusPdfGridPerformanceOptions(
            veryLargeDataMode: true,
            autoFitSampleSize: 50,
            cacheMeasuredWidths: true,
            cacheResolvedStyles: true,
          ),
          columnPolicies: _standardPolicies,
        );
    }
  }

  List<GeniusPdfGridRow> _rows(int count) {
    return List<GeniusPdfGridRow>.generate(
      count,
      (index) => GeniusPdfGridRow(
        cells: {
          'sku': 'SKU-${index.toString().padLeft(5, '0')}',
          'description': index % 4 == 0
              ? 'منتج تجريبي مع English description $index'
              : 'Demo item $index',
          'qty': (index % 12) + 1,
          'amount': (index + 1) * 13.65,
        },
      ),
    );
  }
}
