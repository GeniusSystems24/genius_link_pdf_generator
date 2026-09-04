
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/create_save_open_pdf_button.dart';
enum _S09Scenario {
  quotation1,
  purchaseOrder50,
  taxInvoice500,
  longContent,
  nullOptional,
  bilingual,
}

class S09MigratedTransactionTemplatesVerificationPage
    extends StatefulWidget {
  const S09MigratedTransactionTemplatesVerificationPage({super.key});

  @override
  State<S09MigratedTransactionTemplatesVerificationPage> createState() =>
      _S09MigratedTransactionTemplatesVerificationPageState();
}

class _S09MigratedTransactionTemplatesVerificationPageState
    extends State<S09MigratedTransactionTemplatesVerificationPage> {
  _S09Scenario _scenario = _S09Scenario.quotation1;
  GeniusPdfDirection _direction = GeniusPdfDirection.ltr;
  late Future<Uint8List> _pdfFuture;

  @override
  void initState() {
    super.initState();
    _pdfFuture = _generate();
  }

  void _change(VoidCallback action) {
    action();
    setState(() {
      _pdfFuture = _generate();
    });
  }

  String _label(_S09Scenario value) => switch (value) {
        _S09Scenario.quotation1 => 'Quotation — 1 line',
        _S09Scenario.purchaseOrder50 => 'Purchase Order — 50 lines',
        _S09Scenario.taxInvoice500 => 'Tax Invoice — 500 lines',
        _S09Scenario.longContent => 'Long party / notes / terms',
        _S09Scenario.nullOptional => 'Null optional sections',
        _S09Scenario.bilingual => 'Bilingual / RTL structured values',
      };

  String get _expected => switch (_scenario) {
        _S09Scenario.quotation1 =>
          'QuotationTemplate extends the common Transaction family; customer, '
              'line, totals, notes/terms, QR and signatures remain available.',
        _S09Scenario.purchaseOrder50 =>
          '50 PO lines use shared multipage body/summary; vendor, shipping, '
              'notes/terms and three signatures remain available.',
        _S09Scenario.taxInvoice500 =>
          '500 invoice lines flow across pages; VAT summary, amount-in-words, '
              'QR and authorized signature remain available.',
        _S09Scenario.longContent =>
          'Long customer names and long notes/terms wrap without rebuilding '
              'template-local layout helpers.',
        _S09Scenario.nullOptional =>
          'Null address/notes/terms/QR/signature sections collapse with no '
              'residual gap.',
        _S09Scenario.bilingual =>
          'Arabic prose follows RTL while invoice/PO numbers, tax IDs, phone, '
              'email, dates and money remain readable LTR.',
      };

  Future<Uint8List> _generate() async {
    final config = geniusPdfConfig.copyWith(
      textDirection: _direction == GeniusPdfDirection.rtl
          ? TextDirection.rtl
          : TextDirection.ltr,
    );

    final GeniusPdfDocumentBuilder builder = switch (_scenario) {
      _S09Scenario.quotation1 => _quotation(config, 1),
      _S09Scenario.purchaseOrder50 => _purchaseOrder(config, 50),
      _S09Scenario.taxInvoice500 => _invoice(config, 500),
      _S09Scenario.longContent => _quotation(config, 50, long: true),
      _S09Scenario.nullOptional => _invoice(config, 1, nullOptional: true),
      _S09Scenario.bilingual => _invoice(config, 50),
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Sprint S09 — Migrated Transaction Templates',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 275,
                        child: DropdownButtonFormField<_S09Scenario>(
                          key: ValueKey(_scenario),
                          initialValue: _scenario,
                          decoration: const InputDecoration(
                            labelText: 'Scenario',
                            border: OutlineInputBorder(),
                          ),
                          items: _S09Scenario.values
                              .map(
                                (value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(_label(value)),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            _change(() => _scenario = value);
                          },
                        ),
                      ),
                      SegmentedButton<GeniusPdfDirection>(
                        segments: const [
                          ButtonSegment(
                            value: GeniusPdfDirection.ltr,
                            label: Text('LTR'),
                          ),
                          ButtonSegment(
                            value: GeniusPdfDirection.rtl,
                            label: Text('RTL'),
                          ),
                        ],
                        selected: {_direction},
                        onSelectionChanged: (selection) {
                          _change(() => _direction = selection.first);
                        },
                      ),
                      FilledButton.icon(
                        onPressed: () {
                          setState(() {
                            _pdfFuture = _generate();
                          });
                        },
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Regenerate PDF'),
                      ),
                      CreateSaveOpenPdfButton(
                        onCreate: _generate,
                        fileName: 's09_migrated_transaction_templates.pdf',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Expected Result: $_expected'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: FutureBuilder<Uint8List>(
                future: _pdfFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: SelectableText(
                        'Generation failed:\n${snapshot.error}',
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return GeniusPdfPreviewWidget(
                    pdfData: snapshot.data!,
                    canChangeOrientation: false,
                    canChangePageFormat: false,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
