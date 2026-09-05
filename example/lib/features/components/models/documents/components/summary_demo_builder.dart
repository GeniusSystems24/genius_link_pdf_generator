import 'summary_basic_invoice_summary_demo_builder.dart';

/// Backward-compatible entry point for the former multi-example
/// [SummaryDemoBuilder] document.
///
/// The aggregate demo has been split into focused builders. Existing callers
/// keep working and are routed to **Basic Invoice Summary**.
@Deprecated('Use a focused builder such as BasicInvoiceSummaryDemoBuilder.')
class SummaryDemoBuilder extends BasicInvoiceSummaryDemoBuilder {
  SummaryDemoBuilder(super.config);
}
