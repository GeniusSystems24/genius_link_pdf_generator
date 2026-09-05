import 'data_grid_invoice_footer_rows_demo_builder.dart';

/// Backward-compatible alias for the former multi-example DataGrid document.
///
/// The original file previously generated seven examples in one PDF. DataGrid
/// examples are now intentionally focused: one builder, one screen, one usage
/// sample. Existing callers of [DataGridDemoBuilder] continue to work and are
/// routed to the first focused example.
@Deprecated(
  'Use one of the focused DataGrid builders, such as '
  'DataGridInvoiceFooterRowsDemoBuilder.',
)
class DataGridDemoBuilder extends DataGridInvoiceFooterRowsDemoBuilder {
  DataGridDemoBuilder(super.config);
}
