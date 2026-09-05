import 'package:flutter/material.dart' show Scaffold;
import 'package:flutter/widgets.dart';

/// Compatibility entry point for the former multi-example Advanced Architecture screen.
///
/// The example application now exposes every example as a dedicated navigation
/// destination. [initialTab] is retained only for existing callers and selects
/// one focused example; no tab bar or multi-example page is rendered.
@Deprecated('Use one of the dedicated Advanced Architecture example screens.')
class V2ArchitectureDemoScreen extends StatelessWidget {
  const V2ArchitectureDemoScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  Widget build(BuildContext context) {
    // return V2ArchitectureSingleExampleHost(initialTab: initialTab);
    return Scaffold();
  }
}
