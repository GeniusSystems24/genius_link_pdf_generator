import 'web_link_builder_demo_builder.dart';

/// Backward-compatible entry point for the former multi-example
/// [WebLinkDemoBuilder] document.
///
/// The aggregate demo has been split into focused builders. Existing callers
/// keep working and are routed to **Builder Web Links**.
@Deprecated('Use a focused builder such as WebLinkBuilderDemoBuilder.')
class WebLinkDemoBuilder extends WebLinkBuilderDemoBuilder {
  WebLinkDemoBuilder(super.config);
}
