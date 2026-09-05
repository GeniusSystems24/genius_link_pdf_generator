import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/models/documents/s02_components_rtl_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S02 example for Nested Direction Override.
class S02NestedOverrideVerificationExampleScreen extends StatelessWidget {
  const S02NestedOverrideVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S02 Components RTL',
      title: pdfLocalization.nestedDirectionOverride,
      description: pdfLocalization.s02NestedDirectionOverrideVerify,
      apiName: 'buildS02NestedOverrideVerificationPdf',
      icon: Icons.compare_arrows_outlined,
      generator: buildS02NestedOverrideVerificationPdf,
      fileName: 's02_components_rtl_nested_override.pdf',
      usageCode: r'''Future<Uint8List> buildS02NestedOverrideVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S02ComponentsRtlDocument(
    config: config,
    directionality: directionality,
    scenario: S02ComponentsRtlScenario.nestedOverride,
    showOptional: false,
    preserveGridOrder: false,
  );
  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}''',
    );
  }
}
