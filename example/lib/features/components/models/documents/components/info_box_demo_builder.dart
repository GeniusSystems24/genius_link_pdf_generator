import 'info_box_customer_company_info_boxes_demo_builder.dart';

/// Backward-compatible entry point for the former multi-example
/// [InfoBoxDemoBuilder] document.
///
/// The aggregate demo has been split into focused builders. Existing callers
/// keep working and are routed to **Customer & Company Boxes**.
@Deprecated('Use a focused builder such as CustomerCompanyInfoBoxesDemoBuilder.')
class InfoBoxDemoBuilder extends CustomerCompanyInfoBoxesDemoBuilder {
  InfoBoxDemoBuilder(super.config);
}
