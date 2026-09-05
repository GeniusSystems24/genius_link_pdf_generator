import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s19_assets_projects_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S19 verification example for Asset Transfer.
class S19AssetTransferVerificationExampleScreen extends StatelessWidget {
  const S19AssetTransferVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS19AssetTransferVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.assetTransfer,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S19 Fixed Assets & Projects Pack',
      title: pdfLocalization.assetTransfer,
      description: pdfLocalization.s19AssetTransferVerify,
      apiName: 'buildS19AssetTransferVerificationPdf',
      icon: Icons.domain_outlined,
      generator: buildS19AssetTransferVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's19_assets_projects_asset_transfer.pdf',
    );
  }
}
