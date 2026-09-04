
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

GeniusPdfConfig config() => GeniusPdfConfig(
      baseFontBytes: Uint8List(0),
      baseFont: PdfStandardFont(PdfFontFamily.helvetica, 10),
      textDirection: TextDirection.ltr,
    );

ErpDocumentContext contextWithLines(int count) {
  return ErpDocumentContext(
    organization: const ErpOrganization(
      id: 'ORG',
      legalName: 'Organization',
    ),
    identity: ErpDocumentIdentity(
      kind: ErpDocumentKind.invoice,
      number: 'DOC-1',
      issueDate: DateTime(2026, 9, 4),
    ),
    documentCurrency: ErpCurrency.sar,
    lineItems: List.generate(
      count,
      (index) => ErpLineItem(
        id: '${index + 1}',
        description: 'Item ${index + 1}',
        quantity: const ErpQuantity(
          value: 1,
          unit: ErpUnit.each,
        ),
        unitPrice: ErpMoney.fromAmount(
          10,
          currency: ErpCurrency.sar,
        ),
      ),
    ),
  );
}

void main() {
  test('minimal transaction family can be generated', () {
    final context = contextWithLines(1);
    final calculation =
        const ErpCalculationService().calculate(
      ErpCalculationRequest.fromContext(context),
    );

    final document = GeniusErpTransactionDocument(
      config(),
      plan: GeniusErpFamilyPlan(
        document: context,
        calculation: calculation,
        title: 'Transaction',
      ),
    );

    final bytes = document.generate();
    expect(bytes, isNotEmpty);
    document.dispose();
  });

  test('family slot policies support direction and break policy', () {
    const policy = GeniusErpSlotPolicy(
      breakPolicy: GeniusErpSlotBreakPolicy.keepTogether,
      direction: GeniusPdfDirection.rtl,
      estimatedHeight: 90,
    );

    expect(
      policy.breakPolicy,
      GeniusErpSlotBreakPolicy.keepTogether,
    );
    expect(policy.direction, GeniusPdfDirection.rtl);
    expect(policy.estimatedHeight, 90);
  });

  test('all nine family constructors accept one shared plan shape', () {
    final context = contextWithLines(1);
    final calculation =
        const ErpCalculationService().calculate(
      ErpCalculationRequest.fromContext(context),
    );
    final plan = GeniusErpFamilyPlan(
      document: context,
      calculation: calculation,
      title: 'Shared',
    );
    final c = config();

    final families = <GeniusErpDocumentFamily>[
      GeniusErpTransactionDocument(c, plan: plan),
      GeniusErpStatementDocument(c, plan: plan),
      GeniusErpVoucherDocument(c, plan: plan),
      GeniusErpAnalyticalReport(c, plan: plan),
      GeniusErpOperationalForm(c, plan: plan),
      GeniusErpRegisterDocument(c, plan: plan),
      GeniusErpThermalReceipt(c, plan: plan),
      GeniusErpLabelDocument(c, plan: plan),
      GeniusErpCertificateDocument(c, plan: plan),
    ];

    expect(families.length, 9);
    for (final family in families) {
      family.dispose();
    }
  });
}
