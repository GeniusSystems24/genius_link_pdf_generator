import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s18_manufacturing_quality_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S18 verification example for Machine Operation.
class S18MachineOperationVerificationExampleScreen extends StatelessWidget {
  const S18MachineOperationVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS18MachineOperationVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.machineOperation,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S18 Manufacturing & Quality Pack',
      title: pdfLocalization.machineOperation,
      description: pdfLocalization.s18MachineOperationVerify,
      apiName: 'buildS18MachineOperationVerificationPdf',
      icon: Icons.precision_manufacturing_outlined,
      generator: buildS18MachineOperationVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's18_manufacturing_quality_pack_machine_operation.pdf',
    );
  }
}
