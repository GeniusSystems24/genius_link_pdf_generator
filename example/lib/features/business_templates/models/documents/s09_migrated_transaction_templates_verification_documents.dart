// Generated from the former aggregate verification page.
// ignore_for_file: unused_element

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

/// Scenarios extracted from the former S09MigratedTransactionTemplatesVerificationPage.
enum S09MigratedTransactionTemplatesScenario {
  quotation1,
  purchaseOrder50,
  taxInvoice500,
  longContent,
  nullOptional,
  bilingual,
}

/// Executes one focused S09 verification scenario.
class S09MigratedTransactionTemplatesRunner {
  S09MigratedTransactionTemplatesRunner({
    required GeniusPdfConfig baseConfig,
    required S09MigratedTransactionTemplatesScenario scenario,
  })  : _baseConfig = baseConfig,
        _scenario = scenario;

  final GeniusPdfConfig _baseConfig;
  final S09MigratedTransactionTemplatesScenario _scenario;
GeniusPdfDirection _direction = GeniusPdfDirection.ltr;
String _label(S09MigratedTransactionTemplatesScenario value) => switch (value) {
        S09MigratedTransactionTemplatesScenario.quotation1 => 'Quotation — 1 line',
        S09MigratedTransactionTemplatesScenario.purchaseOrder50 => 'Purchase Order — 50 lines',
        S09MigratedTransactionTemplatesScenario.taxInvoice500 => 'Tax Invoice — 500 lines',
        S09MigratedTransactionTemplatesScenario.longContent => 'Long party / notes / terms',
        S09MigratedTransactionTemplatesScenario.nullOptional => 'Null optional sections',
        S09MigratedTransactionTemplatesScenario.bilingual => 'Bilingual / RTL structured values',
      };

  String get _expected => switch (_scenario) {
        S09MigratedTransactionTemplatesScenario.quotation1 =>
          'QuotationTemplate extends the common Transaction family; customer, '
              'line, totals, notes/terms, QR and signatures remain available.',
        S09MigratedTransactionTemplatesScenario.purchaseOrder50 =>
          '50 PO lines use shared multipage body/summary; vendor, shipping, '
              'notes/terms and three signatures remain available.',
        S09MigratedTransactionTemplatesScenario.taxInvoice500 =>
          '500 invoice lines flow across pages; VAT summary, amount-in-words, '
              'QR and authorized signature remain available.',
        S09MigratedTransactionTemplatesScenario.longContent =>
          'Long customer names and long notes/terms wrap without rebuilding '
              'template-local layout helpers.',
        S09MigratedTransactionTemplatesScenario.nullOptional =>
          'Null address/notes/terms/QR/signature sections collapse with no '
              'residual gap.',
        S09MigratedTransactionTemplatesScenario.bilingual =>
          'Arabic prose follows RTL while invoice/PO numbers, tax IDs, phone, '
              'email, dates and money remain readable LTR.',
      };

  Future<Uint8List> generate() async {
    final config = _baseConfig.copyWith(
      textDirection: _direction == GeniusPdfDirection.rtl
          ? TextDirection.rtl
          : TextDirection.ltr,
    );

    final GeniusPdfDocumentBuilder builder = switch (_scenario) {
      S09MigratedTransactionTemplatesScenario.quotation1 => _quotation(config, 1),
      S09MigratedTransactionTemplatesScenario.purchaseOrder50 => _purchaseOrder(config, 50),
      S09MigratedTransactionTemplatesScenario.taxInvoice500 => _invoice(config, 500),
      S09MigratedTransactionTemplatesScenario.longContent => _quotation(config, 50, long: true),
      S09MigratedTransactionTemplatesScenario.nullOptional => _invoice(config, 1, nullOptional: true),
      S09MigratedTransactionTemplatesScenario.bilingual => _invoice(config, 50),
    };

    final bytes = Uint8List.fromList(builder.generate());
    builder.dispose();
    return bytes;
  }

  GeniusPdfCompanyInfo get _company => const GeniusPdfCompanyInfo(
        name: 'Genius Systems',
        nameAr: 'أنظمة جينيس',
        address: 'King Fahd Road, Riyadh',
        addressAr: 'طريق الملك فهد، الرياض',
        phone: '+966 11 555 0000',
        email: 'info@example.com',
        vatNumber: '310123456700003',
      );

  QuotationTemplate _quotation(
    GeniusPdfConfig config,
    int lines, {
    bool long = false,
  }) {
    return QuotationTemplate(
      config: config,
      company: _company,
      quotation: QuotationData(
        quotationNumber: 'QUO-2026-0001',
        quotationDate: DateTime(2026, 9, 4),
        validUntil: DateTime(2026, 10, 4),
        customer: QuotationCustomer(
          name: long
              ? 'A Very Long International Customer Trading and '
                  'Professional Services Company LLC'
              : 'Acme Trading',
          nameAr: long
              ? 'شركة العميل الدولية الطويلة جداً للتجارة والخدمات المهنية'
              : 'شركة أكمي للتجارة',
          address: 'Riyadh',
          addressAr: 'الرياض',
          phone: '+966 50 123 4567',
          email: 'finance@example.com',
          vatNumber: '310987654300003',
        ),
        items: List.generate(
          lines,
          (index) => QuotationItem(
            itemNumber: index + 1,
            description: 'Quotation item ${index + 1}',
            descriptionAr: 'بند عرض السعر ${index + 1}',
            quantity: ((index % 4) + 1).toDouble(),
            unitPrice: 100.0 + index,
            discount: index % 5 == 0 ? 5 : 0,
            tax: index % 3 == 0 ? 15 : 0,
          ),
        ),
        notes: long
            ? List.filled(
                8,
                'Long quotation notes verify wrapping and page flow.',
              ).join(' ')
            : 'Quotation note',
        notesAr: long
            ? List.filled(
                8,
                'ملاحظات طويلة للتحقق من الالتفاف وتدفق الصفحات.',
              ).join(' ')
            : 'ملاحظة عرض السعر',
        terms: long
            ? List.filled(
                8,
                'Payment and delivery terms remain shared and reusable.',
              ).join(' ')
            : 'Valid for 30 days.',
        termsAr: long
            ? List.filled(
                8,
                'تبقى شروط الدفع والتسليم مشتركة وقابلة لإعادة الاستخدام.',
              ).join(' ')
            : 'صالح لمدة 30 يوماً.',
      ),
      reportId: 'QUO-2026-0001',
      printedBy: 'S09 verification',
    );
  }

  PurchaseOrderTemplate _purchaseOrder(
    GeniusPdfConfig config,
    int lines,
  ) {
    return PurchaseOrderTemplate(
      config: config,
      company: _company,
      vendor: const PurchaseOrderVendor(
        name: 'Example Vendor',
        nameAr: 'المورد التجريبي',
        address: 'Dammam',
        addressAr: 'الدمام',
        vatNumber: '310111111100003',
        phone: '+966 50 765 4321',
        email: 'vendor@example.com',
        contactPerson: 'Purchasing Contact',
        vendorCode: 'VEN-001',
      ),
      purchaseOrder: PurchaseOrderData(
        poNumber: 'PO-2026-0001',
        poDate: DateTime(2026, 9, 4),
        expectedDeliveryDate: DateTime(2026, 9, 20),
        quotationRef: 'QUO-2026-0001',
        paymentTerms: 'Net 30',
        paymentTermsAr: '30 يوماً',
        shippingInfo: const ShippingInfo(
          address: 'Warehouse 7, Riyadh',
          addressAr: 'المستودع 7، الرياض',
          contactPerson: 'Warehouse Team',
          phone: '+966 11 222 3333',
          instructions: 'Call before delivery',
          instructionsAr: 'الاتصال قبل التسليم',
        ),
        items: List.generate(
          lines,
          (index) => PurchaseOrderItem(
            itemNumber: index + 1,
            productCode: 'SKU-${index + 1}',
            description: 'PO item ${index + 1}',
            descriptionAr: 'بند أمر الشراء ${index + 1}',
            quantity: ((index % 5) + 1).toDouble(),
            unitPrice: 50.0 + index,
            discount: index % 7 == 0 ? 3 : 0,
          ),
        ),
        taxes: const [
          (name: 'VAT', nameAr: 'ضريبة القيمة المضافة', rate: 15),
        ],
        notes: 'Deliver to the main warehouse.',
        notesAr: 'التسليم إلى المستودع الرئيسي.',
        termsAndConditions: 'Goods are subject to inspection.',
        termsAndConditionsAr: 'البضاعة خاضعة للفحص.',
      ),
    );
  }

  TaxInvoiceTemplate _invoice(
    GeniusPdfConfig config,
    int lines, {
    bool nullOptional = false,
  }) {
    return TaxInvoiceTemplate(
      config: config,
      company: _company,
      customer: InvoiceCustomer(
        name: 'Acme Customer',
        nameAr: 'عميل أكمي',
        address: nullOptional ? null : 'Jeddah',
        addressAr: nullOptional ? null : 'جدة',
        vatNumber: '310222222200003',
        phone: '+966 50 222 3333',
        email: 'customer@example.com',
        accountNumber: 'CUST-001',
      ),
      invoice: InvoiceData(
        invoiceNumber: 'INV-2026-0001',
        invoiceDate: DateTime(2026, 9, 4),
        poNumber: nullOptional ? null : 'PO-2026-0001',
        paymentTerms: nullOptional ? null : 'Due in 30 days',
        paymentTermsAr: nullOptional ? null : 'مستحق خلال 30 يوماً',
        dueDate: nullOptional ? null : DateTime(2026, 10, 4),
        items: List.generate(
          lines,
          (index) => InvoiceLineItem(
            itemNumber: index + 1,
            description: 'Invoice item ${index + 1}',
            descriptionAr: 'بند الفاتورة ${index + 1}',
            quantity: ((index % 4) + 1).toDouble(),
            unitPrice: 75.0 + index,
            discount: index % 6 == 0 ? 2 : 0,
          ),
        ),
        taxes: const [
          InvoiceTax(
            name: 'VAT',
            nameAr: 'ضريبة القيمة المضافة',
            rate: 15,
          ),
        ],
        notes: nullOptional ? null : 'Thank you for your business.',
        notesAr: nullOptional ? null : 'شكراً لتعاملكم معنا.',
      ),
      showQRCode: !nullOptional,
      showSignature: !nullOptional,
    );
  }
}


Future<Uint8List> buildS09Quotation1VerificationPdf(GeniusPdfConfig config) {
  final runner = S09MigratedTransactionTemplatesRunner(
    baseConfig: config,
    scenario: S09MigratedTransactionTemplatesScenario.quotation1,
  );
  runner._direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  return runner.generate();
}

Future<Uint8List> buildS09PurchaseOrder50VerificationPdf(GeniusPdfConfig config) {
  final runner = S09MigratedTransactionTemplatesRunner(
    baseConfig: config,
    scenario: S09MigratedTransactionTemplatesScenario.purchaseOrder50,
  );
  runner._direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  return runner.generate();
}

Future<Uint8List> buildS09TaxInvoice500VerificationPdf(GeniusPdfConfig config) {
  final runner = S09MigratedTransactionTemplatesRunner(
    baseConfig: config,
    scenario: S09MigratedTransactionTemplatesScenario.taxInvoice500,
  );
  runner._direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  return runner.generate();
}

Future<Uint8List> buildS09LongContentVerificationPdf(GeniusPdfConfig config) {
  final runner = S09MigratedTransactionTemplatesRunner(
    baseConfig: config,
    scenario: S09MigratedTransactionTemplatesScenario.longContent,
  );
  runner._direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  return runner.generate();
}

Future<Uint8List> buildS09NullOptionalVerificationPdf(GeniusPdfConfig config) {
  final runner = S09MigratedTransactionTemplatesRunner(
    baseConfig: config,
    scenario: S09MigratedTransactionTemplatesScenario.nullOptional,
  );
  runner._direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  return runner.generate();
}

Future<Uint8List> buildS09BilingualVerificationPdf(GeniusPdfConfig config) {
  final runner = S09MigratedTransactionTemplatesRunner(
    baseConfig: config,
    scenario: S09MigratedTransactionTemplatesScenario.bilingual,
  );
  runner._direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  return runner.generate();
}
