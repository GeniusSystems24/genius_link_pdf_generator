import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import '../../data/sample_data.dart';
import 'shared_build.dart';

NewTemplatesDemoBuild buildQuotationDemo({required bool isRtl}) {
  final customer = const QuotationCustomer(
    name: 'ABC Trading Company',
    nameAr: 'شركة ABC للتجارة',
    company: 'ABC Trading Co. Ltd',
    address: '456 Commercial Street, Jeddah',
    phone: '+966 12 345 6789',
    email: 'purchasing@abctrading.com',
  );

  final quotation = QuotationData(
    quotationNumber: 'QT-2026-0001',
    quotationDate: DateTime.now(),
    validUntil: DateTime.now().add(const Duration(days: 30)),
    paymentTerms: 'Net 30',
    paymentTermsAr: 'صافي 30 يوم',
    items: const [
      QuotationItem(
        itemNumber: 1,
        description: 'Office Desk - Executive Model',
        descriptionAr: 'مكتب تنفيذي',
        quantity: 5,
        unitPrice: 2500,
      ),
      QuotationItem(
        itemNumber: 2,
        description: 'Executive Chair',
        descriptionAr: 'كرسي تنفيذي',
        quantity: 5,
        unitPrice: 1800,
      ),
    ],
    taxes: const [
      (name: 'VAT', nameAr: 'ضريبة القيمة المضافة', rate: 15.0),
    ],
  );

  final template = QuotationTemplate(
    config: createNewTemplatesDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    customer: customer,
    quotation: quotation,
  );

  return NewTemplatesDemoBuild(
    builder: template,
    fileName: 'quotation_demo',
  );
}

NewTemplatesDemoBuild buildPurchaseOrderDemo({required bool isRtl}) {
  final vendor = const PurchaseOrderVendor(
    name: 'Tech Supplies Co.',
    nameAr: 'شركة مستلزمات التقنية',
    vendorCode: 'VND-001',
    address: '789 Industrial Area, Dammam',
    vatNumber: '300098765400001',
  );

  final po = PurchaseOrderData(
    poNumber: 'PO-2026-0042',
    poDate: DateTime.now(),
    expectedDeliveryDate: DateTime.now().add(const Duration(days: 14)),
    paymentTerms: 'Net 45',
    status: 'Approved',
    items: const [
      PurchaseOrderItem(
        itemNumber: 1,
        productCode: 'LAP-001',
        description: 'Laptop - Business Model',
        descriptionAr: 'لابتوب - موديل الأعمال',
        quantity: 10,
        unitPrice: 4500,
      ),
      PurchaseOrderItem(
        itemNumber: 2,
        productCode: 'MON-002',
        description: 'Monitor 27" 4K',
        descriptionAr: 'شاشة 27 بوصة 4K',
        quantity: 10,
        unitPrice: 1200,
      ),
    ],
    taxes: const [
      (name: 'VAT', nameAr: 'ضريبة القيمة المضافة', rate: 15.0),
    ],
  );

  final template = PurchaseOrderTemplate(
    config: createNewTemplatesDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    vendor: vendor,
    purchaseOrder: po,
  );

  return NewTemplatesDemoBuild(
    builder: template,
    fileName: 'purchase_order_demo',
  );
}

NewTemplatesDemoBuild buildDeliveryNoteDemo({required bool isRtl}) {
  final recipient = const DeliveryRecipient(
    name: 'Ahmed Al-Farsi',
    nameAr: 'أحمد الفارسي',
    company: 'XYZ Corp',
    companyAr: 'شركة XYZ',
    address: '321 Business Park, Riyadh',
    phone: '+966 55 123 4567',
  );

  final delivery = DeliveryNoteData(
    deliveryNumber: 'DN-2026-0089',
    deliveryDate: DateTime.now(),
    salesOrderRef: 'SO-2026-0156',
    driverName: 'Khalid Mohammed',
    vehicleNumber: 'ABC 1234',
    items: const [
      DeliveryItem(
        itemNumber: 1,
        productCode: 'PROD-001',
        description: 'Widget A',
        descriptionAr: 'منتج أ',
        orderedQty: 100,
        deliveredQty: 100,
        unit: 'pcs',
      ),
      DeliveryItem(
        itemNumber: 2,
        productCode: 'PROD-002',
        description: 'Widget B',
        descriptionAr: 'منتج ب',
        orderedQty: 50,
        deliveredQty: 45,
        unit: 'pcs',
      ),
    ],
  );

  final template = DeliveryNoteTemplate(
    config: createNewTemplatesDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    recipient: recipient,
    delivery: delivery,
  );

  return NewTemplatesDemoBuild(
    builder: template,
    fileName: 'delivery_note_demo',
  );
}

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
