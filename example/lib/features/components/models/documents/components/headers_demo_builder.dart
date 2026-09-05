import 'headers_invoice_header_demo_builder.dart';

/// Backward-compatible entry point for the former multi-example
/// [HeadersDemoBuilder] document.
///
/// The aggregate demo has been split into focused builders. Existing callers
/// keep working and are routed to **Invoice Header**.
@Deprecated('Use a focused builder such as InvoiceHeaderDemoBuilder.')
class HeadersDemoBuilder extends InvoiceHeaderDemoBuilder {
  HeadersDemoBuilder(super.config);
}
