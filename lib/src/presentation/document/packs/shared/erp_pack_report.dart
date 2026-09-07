
import '../../builders/pdf_document_builder.dart';
import '../../components/components.dart';
import 'erp_pack_models.dart';

/// Shared renderer for S12/S13 pre-calculated register/statement/analysis data.
///
/// This file deliberately performs no business calculations.
extension GeniusErpPackReportRendering on GeniusPdfDocumentBuilder {
  void renderErpPackReport(
    GeniusErpPackReportData report, {
    double titleSpacing = 8,
  }) {
    newPage();

    addLine(
      config.isRTL
          ? (report.titleAr ?? report.title)
          : report.title,
      font: config.headerFont,
      topMargin: 4,
    );

    final subtitle = config.isRTL
        ? (report.subtitleAr ?? report.subtitle)
        : (report.subtitle ?? report.subtitleAr);
    if (subtitle != null && subtitle.trim().isNotEmpty) {
      addLine(
        subtitle,
        font: config.smallFont,
        topMargin: 2,
      );
    }

    for (final detail in report.details) {
      final label = config.isRTL
          ? (detail.labelAr ?? detail.label)
          : detail.label;
      addLine(
        '$label: ${detail.value}',
        font: config.smallFont,
        topMargin: 2,
      );
    }

    addSpace(titleSpacing);

    final columns = <GeniusPdfGridColumn>[
      for (final column in report.columns)
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

    Map<String, Object?> resolveCells(
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
      for (final row in report.rows)
        row.isTotal
            ? GeniusPdfGridRow.total(resolveCells(row.cells))
            : GeniusPdfGridRow(cells: resolveCells(row.cells)),
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

    final notes = config.isRTL
        ? (report.notesAr ?? report.notes)
        : (report.notes ?? report.notesAr);
    if (notes != null && notes.trim().isNotEmpty) {
      addLine(
        notes,
        font: config.smallFont,
        topMargin: 6,
      );
    }
  }
}
