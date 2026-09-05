import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/text_typography/models/documents/s01_directionality_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

/// Dedicated S01 example for Long + Multi-page.
class S01LongMultiPageVerificationExampleScreen extends StatelessWidget {
  const S01LongMultiPageVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S01 Directionality',
      title: 'Long + Multi-page',
      description: 'Focused S01 verification for Long + Multi-page. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.',
      apiName: 'buildS01LongMultiPageVerificationPdf',
      icon: Icons.swap_horiz_outlined,
      generator: buildS01LongMultiPageVerificationPdf,
      fileName: 's01_directionality_long_multi_page.pdf',
      usageCode: r'''Future<Uint8List> buildS01LongMultiPageVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    localeDirection: direction,
    documentDirection: direction,
    templateDirection: GeniusPdfDirection.auto,
    componentDirection: GeniusPdfDirection.auto,
    elementDirection: GeniusPdfDirection.auto,
  );
  final builder = S01DirectionalityDocument(
    config: config,
    directionality: directionality,
    scenario: S01DirectionalityScenario.longMultiPage,
    valueKind: GeniusPdfValueKind.money,
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
