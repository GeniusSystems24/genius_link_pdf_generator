
import '../../builders/pdf_document_builder.dart';
import '../../components/components.dart';
import '../shared/erp_pack_shared.dart';
import 'models.dart';

/// S18-T25 renderer for nested operation/material tables.
///
/// It reuses the existing DataGrid grouped-row implementation rather than
/// introducing a second grid/page-flow engine.
extension GeniusManufacturingNestedTableRendering
    on GeniusPdfDocumentBuilder {
  void renderManufacturingNestedTable(
    GeniusManufacturingNestedTableData data,
  ) {
    newPage();

    addLine(
      config.isRTL
          ? (data.titleAr ?? data.title)
          : data.title,
      font: config.headerFont,
      topMargin: 4,
    );
    addSpace(8);

    final columns = <GeniusPdfGridColumn>[
      for (final column in data.columns)
        if (column.kind == GeniusErpPackReportColumnKind.money)
          GeniusPdfGridColumn.currency(
            id: column.id,
            title: column.title,
            titleAr: column.titleAr,
            width: column.width,
            currencySymbol: '',
          )
        else
          GeniusPdfGridColumn(
            id: column.id,
            title: column.title,
            titleAr: column.titleAr,
            width: column.width,
            flexFactor: column.flexFactor,
            alignment:
                column.kind == GeniusErpPackReportColumnKind.number
                    ? GeniusPdfTextAlign.center
                    : GeniusPdfTextAlign.start,
          ),
    ];

    Map<String, Object?> resolve(
      Map<String, Object?> cells,
    ) =>
        {
          for (final entry in cells.entries)
            entry.key: entry.value is GeniusErpPackLocalizedValue
                ? (entry.value as GeniusErpPackLocalizedValue)
                    .resolve(isRtl: config.isRTL)
                : entry.value,
        };

    final rows = <GeniusPdfGridRow>[
      for (final section in data.sections) ...[
        GeniusPdfGridRow.groupHeader(
          section.title,
          textAr: section.titleAr,
          level: section.level,
          keepWithNext: true,
        ),
        for (final row in section.rows)
          GeniusPdfGridRow(
            cells: resolve(row),
            groupLevel: section.level + 1,
            keepTogether: true,
          ),
      ],
    ];

    final grid = GeniusPdfDataGrid(
      config: config,
      columns: columns,
      rows: rows,
      style: GeniusPdfGridStyle.modern(),
      directionality: directionality,
    );

    final result = addGrid(grid, spacing: 8);
    if (result != null) {
      updateFromLayoutResult(result, spacing: 8);
    }
  }
}
