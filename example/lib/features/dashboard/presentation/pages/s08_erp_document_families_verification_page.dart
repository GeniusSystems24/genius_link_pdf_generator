
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/create_save_open_pdf_button.dart';
enum _S08Scenario {
  transaction,
  statement,
  voucher,
  analytical,
  operational,
  register,
  thermal,
  label,
  certificate,
  customSlots,
  longMultiPage,
}

class S08ErpDocumentFamiliesVerificationPage extends StatefulWidget {
  const S08ErpDocumentFamiliesVerificationPage({super.key});

  @override
  State<S08ErpDocumentFamiliesVerificationPage> createState() =>
      _S08ErpDocumentFamiliesVerificationPageState();
}

class _S08ErpDocumentFamiliesVerificationPageState
    extends State<S08ErpDocumentFamiliesVerificationPage> {
  _S08Scenario _scenario = _S08Scenario.transaction;
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

  String _label(_S08Scenario value) => switch (value) {
        _S08Scenario.transaction => 'Transaction family',
        _S08Scenario.statement => 'Statement family',
        _S08Scenario.voucher => 'Voucher family',
        _S08Scenario.analytical => 'Analytical report',
        _S08Scenario.operational => 'Operational form',
        _S08Scenario.register => 'Register',
        _S08Scenario.thermal => 'Thermal receipt',
        _S08Scenario.label => 'Label',
        _S08Scenario.certificate => 'Certificate',
        _S08Scenario.customSlots => 'Replacement / custom section',
        _S08Scenario.longMultiPage => 'Long multi-page transaction',
      };

  String get _expected => switch (_scenario) {
        _S08Scenario.transaction =>
          'Transaction uses the shared header, identity, party, body, summary, '
              'terms and signature slots.',
        _S08Scenario.statement =>
          'Statement uses the same slot contract without Sales-module types.',
        _S08Scenario.voucher =>
          'Voucher reuses the same structural engine and slot policies.',
        _S08Scenario.analytical =>
          'Analytical report is a separate family class over the same plan.',
        _S08Scenario.operational =>
          'Operational form remains module-neutral and direction-aware.',
        _S08Scenario.register =>
          'Register uses the generic family flow and shared DataGrid body.',
        _S08Scenario.thermal =>
          'Thermal family exists now; standardized 58/80mm profiles remain '
              'an S11 concern and enter through the print-profile hook.',
        _S08Scenario.label =>
          'Label family uses the same extension contract; label-sheet profiles '
              'remain S11.',
        _S08Scenario.certificate =>
          'Certificate uses semantic identity/party/footer slots.',
        _S08Scenario.customSlots =>
          'A slot replacement, custom section, per-slot direction override, '
              'theme override, print-profile hook, first/last-page variants '
              'and renderer-free lifecycle hooks are exercised together.',
        _S08Scenario.longMultiPage =>
          '500 shared line items flow through the multipage grid while the '
              'family keeps the builder synchronized.',
      };

  Future<Uint8List> _generate() async {
    final config = geniusPdfConfig.copyWith(
      textDirection: _direction == GeniusPdfDirection.rtl
          ? TextDirection.rtl
          : TextDirection.ltr,
    );
    final directionality = GeniusPdfDirectionality(
      documentDirection: _direction,
    );

    final lineCount =
        _scenario == _S08Scenario.longMultiPage ? 500 : 5;
    final context = _context(lineCount);
    final calculation =
        const ErpCalculationService().calculate(
      ErpCalculationRequest.fromContext(
        context,
        documentTaxes: const [
          ErpTaxLine(code: 'VAT', ratePercent: 15),
        ],
      ),
    );

    final plan = GeniusErpFamilyPlan(
      document: context,
      calculation: calculation,
      company: const GeniusPdfCompanyInfo(
        name: 'Genius Systems',
        nameAr: 'أنظمة جينيس',
        vatNumber: '310123456700003',
      ),
      title: _label(_scenario),
      titleAr: 'عائلة مستند ERP',
      primaryParty: context.recipient,
      primaryPartyTitle: 'Customer',
      primaryPartyTitleAr: 'العميل',
      addresses: [
        GeniusErpAddressSection(
          title: 'Billing Address',
          titleAr: 'عنوان الفوترة',
          address: context.billingAddress,
        ),
      ],
      notes: 'Shared family note.',
      notesAr: 'ملاحظة من العائلة المشتركة.',
      terms: 'Shared terms remain optional.',
      termsAr: 'الشروط المشتركة اختيارية.',
      signatures: const [
        GeniusErpSignatureSpec(
          title: 'Approved By',
          titleAr: 'اعتمده',
        ),
      ],
      code: _scenario == _S08Scenario.label
          ? const GeniusErpCodeSpec(
              kind: GeniusErpCodeKind.barcode,
              barcodeType: GeniusBarcodeType.code128,
              data: 'ERP-LABEL-2026-0001',
              caption: 'ERP Label',
              captionAr: 'ملصق ERP',
            )
          : _scenario == _S08Scenario.customSlots
              ? const GeniusErpCodeSpec(
                  data: 'https://example.com/erp/FAMILY-2026-0001',
                  caption: 'Family QR',
                  captionAr: 'رمز العائلة',
                )
              : null,
      replacements: _scenario == _S08Scenario.customSlots
          ? {
              GeniusErpFamilySlot.summary: (slotContext) =>
                  GeniusPdfLabel(
                    config: slotContext.config,
                    text: 'CUSTOM SUMMARY REPLACEMENT',
                    textAr: 'بديل مخصص للملخص',
                    tone: GeniusPdfSemanticTone.warning,
                    directionality: slotContext.directionality,
                  ),
            }
          : const {},
      customSections: _scenario == _S08Scenario.customSlots
          ? [
              GeniusErpCustomSection(
                id: 'after-body-note',
                slot: GeniusErpFamilySlot.body,
                position: GeniusErpCustomSectionPosition.after,
                builder: (slotContext) => GeniusPdfLabel(
                  config: slotContext.config,
                  text: 'CUSTOM SECTION AFTER BODY',
                  textAr: 'قسم مخصص بعد المحتوى',
                  tone: GeniusPdfSemanticTone.info,
                  directionality: slotContext.directionality,
                ),
              ),
            ]
          : const [],
      pageVariants: GeniusErpPageVariants(
        firstPageHeader: _scenario == _S08Scenario.customSlots
            ? (slotContext) => GeniusPdfLabel(
                  config: slotContext.config,
                  text: 'FIRST PAGE VARIANT',
                  textAr: 'نسخة الصفحة الأولى',
                  tone: GeniusPdfSemanticTone.success,
                  alignment: GeniusPdfLogicalAlignment.center,
                  directionality: slotContext.directionality,
                )
            : null,
        lastPageFooter: _scenario == _S08Scenario.customSlots
            ? (slotContext) => GeniusPdfLabel(
                  config: slotContext.config,
                  text: 'LAST PAGE VARIANT',
                  textAr: 'نسخة الصفحة الأخيرة',
                  alignment: GeniusPdfLogicalAlignment.center,
                  directionality: slotContext.directionality,
                )
            : null,
      ),
      hooks: _scenario == _S08Scenario.customSlots
          ? [
              (event) {
                assert(event.familyKind ==
                    GeniusErpDocumentFamilyKind.transaction);
                assert(event.pageIndex >= 0);
              },
            ]
          : const [],
      slotPolicies: {
        GeniusErpFamilySlot.body: GeniusErpSlotPolicy(
          estimatedHeight: 130,
          direction: _scenario == _S08Scenario.customSlots
              ? GeniusPdfDirection.rtl
              : GeniusPdfDirection.auto,
        ),
        GeniusErpFamilySlot.approvalsSignatures:
            const GeniusErpSlotPolicy(
          breakPolicy: GeniusErpSlotBreakPolicy.keepTogether,
          estimatedHeight: 90,
        ),
      },
    );

    final GeniusErpDocumentFamily builder = switch (_scenario) {
      _S08Scenario.transaction => GeniusErpTransactionDocument(
          config,
          plan: plan,
          directionality: directionality,
        ),
      _S08Scenario.customSlots => GeniusErpTransactionDocument(
          config,
          plan: plan,
          directionality: directionality,
          themeOverride: config.theme,
          printProfile: GeniusErpPrintProfile(
            id: 's08-verification-noop-profile',
            description: 'Exercises the S08 print-profile hook.',
            apply: (profileConfig) => profileConfig,
          ),
        ),
      _S08Scenario.longMultiPage => GeniusErpTransactionDocument(
          config,
          plan: plan,
          directionality: directionality,
        ),
      _S08Scenario.statement => GeniusErpStatementDocument(
          config,
          plan: plan,
          directionality: directionality,
        ),
      _S08Scenario.voucher => GeniusErpVoucherDocument(
          config,
          plan: plan,
          directionality: directionality,
        ),
      _S08Scenario.analytical => GeniusErpAnalyticalReport(
          config,
          plan: plan,
          directionality: directionality,
        ),
      _S08Scenario.operational => GeniusErpOperationalForm(
          config,
          plan: plan,
          directionality: directionality,
        ),
      _S08Scenario.register => GeniusErpRegisterDocument(
          config,
          plan: plan,
          directionality: directionality,
        ),
      _S08Scenario.thermal => GeniusErpThermalReceipt(
          config,
          plan: plan,
          directionality: directionality,
        ),
      _S08Scenario.label => GeniusErpLabelDocument(
          config,
          plan: plan,
          directionality: directionality,
        ),
      _S08Scenario.certificate => GeniusErpCertificateDocument(
          config,
          plan: plan,
          directionality: directionality,
        ),
    };

    final bytes = Uint8List.fromList(builder.generate());
    builder.dispose();
    return bytes;
  }

  ErpDocumentContext _context(int count) {
    const party = ErpParty(
      id: 'C-1',
      name: 'Acme Trading',
      nameAr: 'شركة أكمي للتجارة',
      taxIdentity: ErpTaxIdentity(
        taxNumber: '310987654300003',
      ),
      addresses: [
        ErpAddress(
          role: ErpAddressRole.billing,
          line1: 'King Fahd Road طريق الملك فهد',
          city: 'Riyadh الرياض',
          postalCode: '12211',
          countryCode: 'SA',
        ),
      ],
      contacts: [
        ErpContactMetadata(
          phone: '+966 50 123 4567',
          email: 'finance@example.com',
        ),
      ],
    );

    return ErpDocumentContext(
      organization: const ErpOrganization(
        id: 'ORG-1',
        legalName: 'Genius Systems',
        nameAr: 'أنظمة جينيس',
      ),
      identity: ErpDocumentIdentity(
        kind: ErpDocumentKind.invoice,
        number: 'FAMILY-2026-0001',
        issueDate: DateTime(2026, 9, 4),
        status: ErpDocumentStatus.issued,
      ),
      recipient: party,
      billingAddress:
          party.addressFor(ErpAddressRole.billing),
      documentCurrency: ErpCurrency.sar,
      references: const [
        ErpDocumentReference(
          type: 'Reference',
          number: 'REF-2026-77',
        ),
      ],
      lineItems: List.generate(
        count,
        (index) => ErpLineItem(
          id: '${index + 1}',
          description: 'Line ${index + 1}',
          descriptionAr: 'السطر ${index + 1}',
          sku: 'SKU-${(index + 1).toString().padLeft(4, '0')}',
          quantity: ErpQuantity(
            value: ((index % 5) + 1).toDouble(),
            unit: ErpUnit.each,
          ),
          unitPrice: ErpMoney.fromAmount(
            10 + index,
            currency: ErpCurrency.sar,
          ),
        ),
      ),
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
                    'Sprint S08 — Generic ERP Document Families',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 260,
                        child: DropdownButtonFormField<_S08Scenario>(
                          key: ValueKey(_scenario),
                          initialValue: _scenario,
                          decoration: const InputDecoration(
                            labelText: 'Scenario',
                            border: OutlineInputBorder(),
                          ),
                          items: _S08Scenario.values
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
                        fileName: 's08_erp_document_families.pdf',
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
