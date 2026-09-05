import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds the focused Mixed ERP Baseline S00 regression example.
class S00MixedBaselineDemoBuilder extends GeniusPdfDocumentBuilder {
  S00MixedBaselineDemoBuilder(super.config);

  @override
  void build() {
    newPage();
    addSectionDivider(
      title: config.isRTL
          ? 'S00 — خط الأساس لاتجاه المحتوى'
          : 'S00 — Directionality baseline',
      spacing: 8,
    );
    addSpace(8);
    addReportSummary(
      summary: GeniusPdfSummarySection(
        config: config,
        width: 390,
        items: const [
          GeniusPdfSummaryItem(
            label: 'Subtotal',
            labelAr: 'المجموع الفرعي',
            value: '13,650.00 SAR',
          ),
          GeniusPdfSummaryItem(
            label: 'Tax (VAT)',
            labelAr: 'الضريبة (VAT)',
            value: '2,047.50 SAR',
          ),
          GeniusPdfSummaryItem.total(
            label: 'Grand Total',
            labelAr: 'الإجمالي النهائي',
            value: '15,697.50 SAR',
          ),
        ],
        style: GeniusPdfSummaryStyle.invoice(),
      ),
      spacing: 8,
    );
    addSpace(16);
    addInfoBox(
      GeniusPdfInfoBox(
        config: config,
        title: 'ERP mixed values',
        titleAr: 'قيم ERP مختلطة',
        showEmptyItems: true,
        items: [
          GeniusPdfLabeledValue(
            config: config,
            label: 'Document No.',
            labelAr: 'رقم المستند',
            value: 'INV-2026-000123',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: 'SKU',
            labelAr: 'رمز الصنف',
            value: 'SKU-AR-ENG-001',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: 'Serial',
            labelAr: 'الرقم التسلسلي',
            value: 'SN-AZ09-998877',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: 'IBAN',
            labelAr: 'الآيبان',
            value: 'SA0380000000608010167519',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: 'Phone',
            labelAr: 'الهاتف',
            value: '+966 55 123 4567',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: 'Email',
            labelAr: 'البريد',
            value: 'accounts@example.test',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: 'URL',
            labelAr: 'الرابط',
            value: 'https://erp.example.test/invoices/INV-2026-000123',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: 'Empty value',
            labelAr: 'قيمة فارغة',
            value: '',
          ),
        ],
      ),
      spacing: 8,
    );
  }
}
