import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s19_assets_projects_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S19 verification example for Asset Register.
class S19AssetRegisterVerificationExampleScreen extends StatelessWidget {
  const S19AssetRegisterVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS19AssetRegisterVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.assetRegister,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S19 Fixed Assets & Projects Pack',
      title: pdfLocalization.assetRegister,
      description: pdfLocalization.s19AssetRegisterVerify,
      apiName: 'buildS19AssetRegisterVerificationPdf',
      icon: Icons.domain_outlined,
      generator: buildS19AssetRegisterVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's19_assets_projects_asset_register.pdf',
    );
  }
}
