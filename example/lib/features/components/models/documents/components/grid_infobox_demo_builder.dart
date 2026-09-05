import 'grid_infobox_order_document_demo_builder.dart';

/// Backward-compatible entry point for the former multi-example
/// [GridInfoboxDemoBuilder] document.
///
/// The aggregate demo has been split into focused builders. Existing callers
/// keep working and are routed to **Order Document**.
@Deprecated('Use a focused builder such as GridInfoboxOrderDocumentDemoBuilder.')
class GridInfoboxDemoBuilder extends GridInfoboxOrderDocumentDemoBuilder {
  GridInfoboxDemoBuilder(super.config);
}
