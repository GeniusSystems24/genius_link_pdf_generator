import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s18_mfg_quality_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S18 verification example for Audit Form.
class S18AuditVerificationExampleScreen extends StatelessWidget {
  const S18AuditVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS18AuditVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.audit,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S18 Manufacturing & Quality Pack',
      title: pdfLocalization.auditForm,
      description: pdfLocalization.s18AuditFormVerify,
      apiName: 'buildS18AuditVerificationPdf',
      icon: Icons.precision_manufacturing_outlined,
      generator: buildS18AuditVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's18_mfg_quality_audit.pdf',
    );
  }
}
