import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/sales_templates.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_template_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated example screen for the Credit Note business template.
class CreditNoteTemplateScreen extends StatelessWidget {
  const CreditNoteTemplateScreen({super.key});

  static const String dartUsageCode = r'''// Dart usage code — the same data/template setup used by this example.
// Set isRtl to false for LTR output.

NewTemplatesDemoBuild buildCreditNoteDemo({required bool isRtl}) {
  final party = const NoteParty(
    name: 'Customer ABC',
    nameAr: 'العميل ABC',
    address: '123 Customer Street, Riyadh',
    vatNumber: '300011112200001',
  );

  final note = CreditDebitNoteData(
    noteNumber: 'CN-2026-0015',
    noteDate: DateTime.now(),
    noteType: NoteType.credit,
    originalInvoiceNumber: 'INV-2026-0189',
    reason: 'Goods returned',
    reasonAr: 'إرجاع بضاعة',
    items: const [
      NoteLineItem(
        itemNumber: 1,
        description: 'Defective Product A',
        descriptionAr: 'منتج أ معيب',
        quantity: 5,
        unitPrice: 500,
        reason: 'Quality issue',
        reasonAr: 'مشكلة جودة',
      ),
    ],
    taxes: const [
      (name: 'VAT', nameAr: 'ضريبة القيمة المضافة', rate: 15.0),
    ],
  );

  final template = CreditNoteTemplate(
    config: createNewTemplatesDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    party: party,
    note: note,
  );

  return NewTemplatesDemoBuild(
    builder: template,
    fileName: 'credit_note_demo',
  );
}

final build = buildCreditNoteDemo(isRtl: true);
final pdfBytes = Uint8List.fromList(build.builder.generate());
build.builder.dispose();
''';

  @override
  Widget build(BuildContext context) {
    return  BusinessTemplateDetailScreen(
      category: 'Sales Documents',
      title: pdfLocalization.creditNote,
      titleAr: 'إشعار دائن',
      description: pdfLocalization.creditAdjustmentDocumentReturnedDesc,
      icon: Icons.money_off,
      buildTemplate: buildCreditNoteDemo,
      usageCode: dartUsageCode,
    );
  }
}
