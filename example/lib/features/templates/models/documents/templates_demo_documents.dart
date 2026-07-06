import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'package:genius_pdf_example/shared/data/sample_data.dart';
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart' show geniusPdfConfig;

GeniusPdfConfig createTemplatesDemoConfig({required bool isRtl}) {
  return geniusPdfConfig.copyWith(
    textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
  );
}

TaxInvoiceTemplate buildTaxInvoiceTemplate({required bool isRtl}) {
  final config = createTemplatesDemoConfig(isRtl: isRtl);
  return TaxInvoiceTemplate(
    config: config,
    company: SampleData.companyInfo,
    customer: SampleData.invoiceCustomer,
    invoice: SampleData.invoiceData,
    showQRCode: false,
  );
}

TrialBalanceTemplate buildTrialBalanceTemplate({required bool isRtl}) {
  final config = createTemplatesDemoConfig(isRtl: isRtl);
  return TrialBalanceTemplate(
    config: config,
    company: SampleData.companyInfo,
    data: SampleData.trialBalanceData,
    reportId: "123456789",
    printedBy: config.isRTL ? "أنور السياري" : "Anwar Al-saiary",
    showSignatures: true,
    showQRCode: true,
  );
}

CustomerStatementTemplate buildCustomerStatementTemplate({
  required bool isRtl,
}) {
  final config = createTemplatesDemoConfig(isRtl: isRtl);
  return CustomerStatementTemplate(
    config: config,
    company: SampleData.companyInfo,
    customer: SampleData.statementCustomer,
    data: SampleData.statementData,
  );
}

InventoryReportTemplate buildInventoryReportTemplate({required bool isRtl}) {
  final config = createTemplatesDemoConfig(isRtl: isRtl);
  return InventoryReportTemplate(
    config: config,
    company: SampleData.companyInfo,
    data: SampleData.inventoryData,
    printedBy: config.isRTL ? "أنور السياري" : "Anwar Al-saiary",
    reportId: "123456789",
    showSignatures: true,
    showQRCode: true,
  );
}
