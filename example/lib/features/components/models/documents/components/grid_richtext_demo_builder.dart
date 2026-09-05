import 'grid_richtext_financial_analysis_demo_builder.dart';

/// Backward-compatible entry point for the former multi-example
/// [GridRichtextDemoBuilder] document.
///
/// The aggregate demo has been split into focused builders. Existing callers
/// keep working and are routed to **Financial Analysis**.
@Deprecated('Use a focused builder such as GridRichtextFinancialAnalysisDemoBuilder.')
class GridRichtextDemoBuilder extends GridRichtextFinancialAnalysisDemoBuilder {
  GridRichtextDemoBuilder(super.config);
}
