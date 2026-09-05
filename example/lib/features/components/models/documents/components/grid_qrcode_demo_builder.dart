import 'grid_qrcode_zatca_invoice_demo_builder.dart';

/// Backward-compatible entry point for the former multi-example
/// [GridQrcodeDemoBuilder] document.
///
/// The aggregate demo has been split into focused builders. Existing callers
/// keep working and are routed to **ZATCA E-Invoice QR**.
@Deprecated('Use a focused builder such as GridQrcodeZatcaInvoiceDemoBuilder.')
class GridQrcodeDemoBuilder extends GridQrcodeZatcaInvoiceDemoBuilder {
  GridQrcodeDemoBuilder(super.config);
}
