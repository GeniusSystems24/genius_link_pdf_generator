import 'grid_watermark_confidential_audit_demo_builder.dart';

/// Backward-compatible entry point for the former multi-example
/// [GridWatermarkDemoBuilder] document.
///
/// The aggregate demo has been split into focused builders. Existing callers
/// keep working and are routed to **Confidential Audit**.
@Deprecated('Use a focused builder such as GridWatermarkConfidentialAuditDemoBuilder.')
class GridWatermarkDemoBuilder extends GridWatermarkConfidentialAuditDemoBuilder {
  GridWatermarkDemoBuilder(super.config);
}
