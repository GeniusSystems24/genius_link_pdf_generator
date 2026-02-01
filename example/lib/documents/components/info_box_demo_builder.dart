import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds an Info Box demo PDF document with extended details.
class InfoBoxDemoBuilder extends GeniusPdfDocumentBuilder {
  InfoBoxDemoBuilder(super.config);

  @override
  void build() {
    newPage();

    // Title using builder method
    addSectionDivider(
      title: config.isRTL
          ? 'صندوق المعلومات - GeniusPdfInfoBox'
          : 'Info Box - GeniusPdfInfoBox',
      spacing: 10,
    );

    addSpace(15);

    final customerBox = GeniusPdfInfoBox(
      config: config,
      title: 'Customer Info',
      titleAr: 'بيانات العميل',
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: 'Name',
          labelAr: 'الاسم',
          value: config.isRTL ? 'أحمد محمد' : 'Ahmed Mohammed',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Phone',
          labelAr: 'الهاتف',
          value: '+966 50 123 4567',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Email',
          labelAr: 'البريد',
          value: 'ahmed@example.com',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Address',
          labelAr: 'العنوان',
          value: config.isRTL ? 'الرياض، السعودية' : 'Riyadh, Saudi Arabia',
        ),
      ],
      style: GeniusPdfInfoBoxStyle.card(),
    );

    final companyBox = GeniusPdfInfoBox.company(
      companyName: config.isRTL ? 'شركة الأمل للتجارة' : 'Al-Amal Trading Co.',
      taxNumber: '300123456789003',
      commercialReg: '1010123456',
      address: config.isRTL
          ? 'الرياض، المملكة العربية السعودية'
          : 'Riyadh, Saudi Arabia',
      phone: '+966 11 123 4567',
      email: 'info@alamal.com',
      config: config,
    );

    // Dual info box using builder method
    addDualInfoBox(
      leftBox: config.isRTL ? companyBox : customerBox,
      rightBox: config.isRTL ? customerBox : companyBox,
      equalHeight: true,
      boxSpacing: 20,
      swapForRTL: false,
      spacing: 15,
    );

    addSpace(10);

    // Info and Warning boxes side by side
    final infoBox = GeniusPdfInfoBox(
      config: config,
      title: config.isRTL ? 'معلومة' : 'Info',
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: config.isRTL ? 'ملاحظة' : 'Note',
          value: config.isRTL
              ? 'يرجى الاحتفاظ بهذه الفاتورة'
              : 'Please keep this invoice',
        ),
      ],
      style: GeniusPdfInfoBoxStyle.info(),
    );

    final warningBox = GeniusPdfInfoBox(
      config: config,
      title: config.isRTL ? 'تحذير' : 'Warning',
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: config.isRTL ? 'تنبيه' : 'Alert',
          value: config.isRTL ? 'مستند للمعاينة فقط' : 'Preview only document',
        ),
      ],
      style: GeniusPdfInfoBoxStyle.warning(),
    );

    addDualInfoBox(
      leftBox: infoBox,
      rightBox: warningBox,
      equalHeight: true,
      boxSpacing: 20,
      spacing: 10,
    );

    addSpace(10);

    // Success and Error boxes side by side
    final successBox = GeniusPdfInfoBox(
      config: config,
      title: config.isRTL ? 'نجاح' : 'Success',
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: config.isRTL ? 'الحالة' : 'Status',
          value:
              config.isRTL ? 'تم إتمام العملية بنجاح' : 'Operation completed',
        ),
      ],
      style: GeniusPdfInfoBoxStyle.success(),
    );

    final errorBox = GeniusPdfInfoBox(
      config: config,
      title: config.isRTL ? 'خطأ' : 'Error',
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: config.isRTL ? 'المشكلة' : 'Issue',
          value: config.isRTL ? 'فشل في معالجة الطلب' : 'Failed to process',
        ),
      ],
      style: GeniusPdfInfoBoxStyle.error(),
    );

    addDualInfoBox(
      leftBox: successBox,
      rightBox: errorBox,
      equalHeight: true,
      boxSpacing: 20,
      spacing: 10,
    );
  }
}
