import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

/// Demonstrates the fluent report composer with a paginated grid + summary.
///
/// The data set is intentionally large enough to exercise the composer path
/// for grid continuation and post-grid summary placement near page breaks.
List<int> buildComposerDemoReport({
  required GeniusPdfConfig config,
  String userName = 'Demo User',
}) {
  final isRTL = config.isRTL;

  final salesRows = List.generate(24, (index) {
    final amount = 1800 + ((index % 6) * 375);
    return GeniusPdfGridRow(
      cells: {
        'no': index + 1,
        'product': 'Service Package ${index + 1}',
        'amount': amount.toDouble(),
      },
    );
  });

  final subtotal = salesRows.fold<double>(
    0,
    (sum, row) => sum + (row.cells['amount'] as double),
  );
  final vat = subtotal * 0.15;
  final grandTotal = subtotal + vat;

  final salesGrid = GeniusPdfDataGrid(
    config: config,
    columns: [
      const GeniusPdfGridColumn(
        id: 'no',
        title: '#',
        width: 30,
        alignment: GeniusPdfTextAlign.center,
      ),
      const GeniusPdfGridColumn(
        id: 'product',
        title: 'Product',
        flexFactor: 3,
      ),
      GeniusPdfGridColumn.currency(
        id: 'amount',
        title: 'Amount',
        width: 90,
        currencySymbol: '',
      ),
    ],
    rows: salesRows,
    style: GeniusPdfGridStyle.classic(),
  );

  final salesSummary = GeniusPdfSummarySection(
    config: config,
    items: [
      GeniusPdfSummaryItem.formatted(
        label: 'Subtotal',
        isBold: true,
        rawValue: subtotal,
        formatter: config.formatter,
        formatSpec: const GeniusPdfFormatSpec.number(decimalPlaces: 2),
      ),
      GeniusPdfSummaryItem.formatted(
        label: 'VAT (15%)',
        rawValue: vat,
        formatter: config.formatter,
        formatSpec: const GeniusPdfFormatSpec.number(decimalPlaces: 2),
      ),
      GeniusPdfSummaryItem.formatted(
        label: 'Grand Total',
        isBold: true,
        isHighlighted: true,
        rawValue: grandTotal,
        formatter: config.formatter,
        formatSpec: const GeniusPdfFormatSpec.number(decimalPlaces: 2),
      ),
    ],
    style: const GeniusPdfSummaryStyle.bordered(),
    alignment: GeniusPdfSummaryAlignment.right,
    width: 220,
  );

  final composer = GeniusPdfReportComposer(config: config);
  final bytes = composer
      .withHeader(
        title: isRTL ? 'RTL Sales Report Fixture' : 'Sales Report Fixture',
      )
      .withFooter(
        userName: userName,
        showPageNumber: true,
        printTime: DateTime.now().toString().substring(0, 19),
      )
      .section(
        isRTL ? 'RTL Sales Overview' : 'Sales Overview',
        sectionAr: isRTL ? 'RTL Sales Overview' : 'Sales Overview',
      )
      .text(
        'This composer example intentionally pushes the summary flow through a '
        'larger grid so manual verification can confirm safe footer handling.',
      )
      .space(8)
      .gridWithSummary(
        dataGrid: salesGrid,
        summarySection: salesSummary,
        gridSpacing: 5,
        summarySpacing: 10,
      )
      .space(12)
      .section(
        isRTL ? 'RTL Notes' : 'Notes',
        sectionAr: isRTL ? 'RTL Notes' : 'Notes',
      )
      .text(
        'The summary above should remain attached to the final grid page or '
        'move safely to a new page without overlapping the footer area.',
      )
      .boldText(
        isRTL ? 'RTL Status: Complete' : 'Status: Complete',
        topMargin: 5,
      )
      .buildPdf();

  composer.dispose();
  return bytes;
}
