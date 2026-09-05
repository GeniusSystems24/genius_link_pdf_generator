import 'package:flutter/widgets.dart';
import 'package:genius_pdf_example/features/sharing/presentation/controllers/sharing_demo_controller.dart';
import 'package:genius_pdf_example/features/sharing/presentation/internal/sharing_single_example_host.dart';

/// Compatibility entry point for the former multi-example Sharing screen.
///
/// The example application now exposes every example as a dedicated navigation
/// destination. [initialTab] is retained only for existing callers and selects
/// one focused example; no tab bar or multi-example page is rendered.
@Deprecated('Use one of the dedicated Sharing example screens.')
class SharingDemoScreen extends StatelessWidget {
  const SharingDemoScreen({
    super.key,
    this.initialTab = 0,
    this.controller,
  });

  final int initialTab;
  final SharingDemoController? controller;

  @override
  Widget build(BuildContext context) {
    return SharingSingleExampleHost(initialTab: initialTab, controller: controller);
  }
}
