import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s19_assets_projects_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S19 verification example for Asset Disposal.
class S19AssetDisposalVerificationExampleScreen extends StatelessWidget {
  const S19AssetDisposalVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS19AssetDisposalVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.assetDisposal,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S19 Fixed Assets & Projects Pack',
      title: pdfLocalization.assetDisposal,
      description: pdfLocalization.s19AssetDisposalVerify,
      apiName: 'buildS19AssetDisposalVerificationPdf',
      icon: Icons.domain_outlined,
      generator: buildS19AssetDisposalVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's19_assets_projects_asset_disposal.pdf',
    );
  }
}
