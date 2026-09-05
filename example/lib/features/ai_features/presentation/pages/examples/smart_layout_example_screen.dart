import 'package:flutter/widgets.dart';
import 'package:genius_pdf_example/features/ai_features/presentation/internal/ai_features_single_example_host.dart';

/// Dedicated single-example screen for **Smart Layout**.
///
/// This screen deliberately contains no tabs and no sibling examples. It keeps
/// the original AI Features implementation and behavior through the
/// shared internal host while selecting only this example.
class SmartLayoutExampleScreen extends StatelessWidget {
  const SmartLayoutExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AiFeaturesSingleExampleHost(initialTab: 1);
  }
}
