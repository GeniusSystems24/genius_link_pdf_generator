import 'rich_text_fluent_formatting_demo_builder.dart';

/// Backward-compatible entry point for the former multi-example
/// [RichTextDemoBuilder] document.
///
/// The aggregate demo has been split into focused builders. Existing callers
/// keep working and are routed to **Fluent Formatting**.
@Deprecated('Use a focused builder such as RichTextFluentFormattingDemoBuilder.')
class RichTextDemoBuilder extends RichTextFluentFormattingDemoBuilder {
  RichTextDemoBuilder(super.config);
}
