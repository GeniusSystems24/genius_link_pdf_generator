
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 's00_fixture_data.dart';

GeniusPdfSummarySection createS00Summary(GeniusPdfConfig config) {
  return GeniusPdfSummarySection(
    config: config,
    width: 390,
    items: const [
      GeniusPdfSummaryItem(
        label: 'Subtotal',
        labelAr: 'المجموع الفرعي',
        value: S00FixtureData.subtotal,
      ),
      GeniusPdfSummaryItem(
        label: 'Tax (VAT)',
        labelAr: 'الضريبة (VAT)',
        value: S00FixtureData.vat,
      ),
      GeniusPdfSummaryItem.total(
        label: 'Grand Total',
        labelAr: 'الإجمالي النهائي',
        value: S00FixtureData.grandTotal,
      ),
    ],
    style: GeniusPdfSummaryStyle.invoice(),
  );
}

class S00SummaryBaselineDocument extends GeniusPdfDocumentBuilder {
  S00SummaryBaselineDocument(super.config);

  @override
  void build() {
    newPage();
    addReportSummary(summary: createS00Summary(config), spacing: 0);
  }
}

class S00InfoBoxBaselineDocument extends GeniusPdfDocumentBuilder {
  S00InfoBoxBaselineDocument(super.config);

  @override
  void build() {
    newPage();
    addInfoBox(
      GeniusPdfInfoBox(
        config: config,
        title: 'Mixed ERP identifiers',
        titleAr: 'معرفات ERP مختلطة',
        showEmptyItems: true,
        items: [
          GeniusPdfLabeledValue(
            config: config,
            label: 'Document No.',
            labelAr: 'رقم المستند',
            value: S00FixtureData.documentNumber,
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: 'SKU',
            labelAr: 'رمز الصنف',
            value: S00FixtureData.sku,
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: 'Serial',
            labelAr: 'الرقم التسلسلي',
            value: S00FixtureData.serial,
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: 'IBAN',
            labelAr: 'الآيبان',
            value: S00FixtureData.iban,
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: 'Phone',
            labelAr: 'الهاتف',
            value: S00FixtureData.phone,
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: 'Email',
            labelAr: 'البريد',
            value: S00FixtureData.email,
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: 'URL',
            labelAr: 'الرابط',
            value: S00FixtureData.url,
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: 'Empty',
            labelAr: 'فارغ',
            value: S00FixtureData.emptyValue,
          ),
        ],
      ),
      spacing: 0,
    );
  }
}

class S00BilingualBaselineDocument extends GeniusPdfDocumentBuilder {
  S00BilingualBaselineDocument(super.config);

  @override
  void build() {
    newPage();
    addLine(
      config.isRTL ? 'اختبار ثنائي اللغة — S00' : 'Bilingual baseline — S00',
      font: config.boldFont,
      topMargin: 0,
    );
    addSpace(8);
    addLine(
      config.isRTL
          ? 'رقم المستند: ${S00FixtureData.documentNumber}'
          : 'Document number: ${S00FixtureData.documentNumber}',
      topMargin: 0,
    );
    addLine(
      config.isRTL
          ? 'المبلغ: ${S00FixtureData.grandTotal}'
          : 'Amount: ${S00FixtureData.grandTotal}',
      topMargin: 4,
    );
    addSpace(12);
    addSummary(createS00Summary(config));
  }
}

class S00LongContentBaselineDocument extends GeniusPdfDocumentBuilder {
  S00LongContentBaselineDocument(super.config);

  @override
  void build() {
    newPage();
    for (var i = 0; i < 90; i++) {
      addLine(
        config.isRTL
            ? '${i + 1}. ${S00FixtureData.longArabic} ${S00FixtureData.sku}'
            : '${i + 1}. ${S00FixtureData.longEnglish} ${S00FixtureData.sku}',
        topMargin: i == 0 ? 0 : 4,
      );
    }
  }
}

GeniusPdfCompanyInfo s00Company() => const GeniusPdfCompanyInfo(
      name: 'Genius Systems Demo Company',
      nameAr: 'شركة جينيس سيستمز التجريبية',
      address: 'Riyadh, Saudi Arabia',
      addressAr: 'الرياض، المملكة العربية السعودية',
      vatNumber: '310000000000003',
      phone: '+966 11 000 0000',
      email: 'finance@example.test',
    );

QuotationTemplate createS00Quotation(GeniusPdfConfig config) {
  return QuotationTemplate(
    config: config,
    company: s00Company(),
    quotation: QuotationData(
      quotationNumber: 'Q-S00-001',
      quotationDate: DateTime(2026, 9, 3),
      validUntil: DateTime(2026, 9, 30),
      customer: const QuotationCustomer(
        name: 'Baseline Customer',
        nameAr: 'عميل خط الأساس',
        vatNumber: '300000000000003',
      ),
      items: const [
        QuotationItem(
          itemNumber: 1,
          description: 'ERP baseline item',
          descriptionAr: 'صنف خط الأساس',
          quantity: 1,
          unitPrice: 13650,
          tax: 2047.5,
        ),
      ],
    ),
    showQRCode: false,
    showSignatures: false,
    showNotes: false,
  );
}

PurchaseOrderTemplate createS00PurchaseOrder(GeniusPdfConfig config) {
  return PurchaseOrderTemplate(
    config: config,
    company: s00Company(),
    vendor: const PurchaseOrderVendor(
      name: 'Baseline Supplier',
      nameAr: 'مورد خط الأساس',
      vatNumber: '300000000000004',
    ),
    purchaseOrder: PurchaseOrderData(
      poNumber: 'PO-S00-001',
      poDate: DateTime(2026, 9, 3),
      items: const [
        PurchaseOrderItem(
          itemNumber: 1,
          description: 'ERP baseline item',
          descriptionAr: 'صنف خط الأساس',
          quantity: 1,
          unitPrice: 13650,
        ),
      ],
      taxes: const [
        (name: 'VAT', nameAr: 'الضريبة', rate: 15.0),
      ],
    ),
    showShippingInfo: false,
    showTerms: false,
  );
}

TaxInvoiceTemplate createS00TaxInvoice(GeniusPdfConfig config) {
  return TaxInvoiceTemplate(
    config: config,
    company: s00Company(),
    customer: const InvoiceCustomer(
      name: 'Baseline Customer',
      nameAr: 'عميل خط الأساس',
      vatNumber: '300000000000003',
    ),
    invoice: InvoiceData(
      invoiceNumber: S00FixtureData.documentNumber,
      invoiceDate: DateTime(2026, 9, 3),
      items: const [
        InvoiceLineItem(
          itemNumber: 1,
          description: 'ERP baseline item',
          descriptionAr: 'صنف خط الأساس',
          quantity: 1,
          unitPrice: 13650,
        ),
      ],
      taxes: const [
        InvoiceTax(name: 'VAT', nameAr: 'الضريبة', rate: 15),
      ],
    ),
    showQRCode: false,
    showSignature: false,
  );
}
