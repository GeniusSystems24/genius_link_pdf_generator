// Generated from the former aggregate verification page.
// ignore_for_file: unused_element

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

/// Scenarios extracted from the former S08ErpDocumentFamiliesVerificationPage.
enum S08ErpDocumentFamiliesScenario {
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

/// Executes one focused S08 verification scenario.
class S08ErpDocumentFamiliesRunner {
  S08ErpDocumentFamiliesRunner({
    required GeniusPdfConfig baseConfig,
    required S08ErpDocumentFamiliesScenario scenario,
  })  : _baseConfig = baseConfig,
        _scenario = scenario;

  final GeniusPdfConfig _baseConfig;
  final S08ErpDocumentFamiliesScenario _scenario;
GeniusPdfDirection _direction = GeniusPdfDirection.ltr;
String _label(S08ErpDocumentFamiliesScenario value) => switch (value) {
        S08ErpDocumentFamiliesScenario.transaction => 'Transaction family',
        S08ErpDocumentFamiliesScenario.statement => 'Statement family',
        S08ErpDocumentFamiliesScenario.voucher => 'Voucher family',
        S08ErpDocumentFamiliesScenario.analytical => 'Analytical report',
        S08ErpDocumentFamiliesScenario.operational => 'Operational form',
        S08ErpDocumentFamiliesScenario.register => 'Register',
        S08ErpDocumentFamiliesScenario.thermal => 'Thermal receipt',
        S08ErpDocumentFamiliesScenario.label => 'Label',
        S08ErpDocumentFamiliesScenario.certificate => 'Certificate',
        S08ErpDocumentFamiliesScenario.customSlots => 'Replacement / custom section',
        S08ErpDocumentFamiliesScenario.longMultiPage => 'Long multi-page transaction',
      };

  String get _expected => switch (_scenario) {
        S08ErpDocumentFamiliesScenario.transaction =>
          'Transaction uses the shared header, identity, party, body, summary, '
              'terms and signature slots.',
        S08ErpDocumentFamiliesScenario.statement =>
          'Statement uses the same slot contract without Sales-module types.',
        S08ErpDocumentFamiliesScenario.voucher =>
          'Voucher reuses the same structural engine and slot policies.',
        S08ErpDocumentFamiliesScenario.analytical =>
          'Analytical report is a separate family class over the same plan.',
        S08ErpDocumentFamiliesScenario.operational =>
          'Operational form remains module-neutral and direction-aware.',
        S08ErpDocumentFamiliesScenario.register =>
          'Register uses the generic family flow and shared DataGrid body.',
        S08ErpDocumentFamiliesScenario.thermal =>
          'Thermal family exists now; standardized 58/80mm profiles remain '
              'an S11 concern and enter through the print-profile hook.',
        S08ErpDocumentFamiliesScenario.label =>
          'Label family uses the same extension contract; label-sheet profiles '
              'remain S11.',
        S08ErpDocumentFamiliesScenario.certificate =>
          'Certificate uses semantic identity/party/footer slots.',
        S08ErpDocumentFamiliesScenario.customSlots =>
          'A slot replacement, custom section, per-slot direction override, '
              'theme override, print-profile hook, first/last-page variants '
              'and renderer-free lifecycle hooks are exercised together.',
        S08ErpDocumentFamiliesScenario.longMultiPage =>
          '500 shared line items flow through the multipage grid while the '
              'family keeps the builder synchronized.',
      };

  Future<Uint8List> generate() async {
    final config = _baseConfig.copyWith(
      textDirection: _direction == GeniusPdfDirection.rtl
          ? TextDirection.rtl
          : TextDirection.ltr,
    );
    final directionality = GeniusPdfDirectionality(
      documentDirection: _direction,
    );

    final lineCount =
        _scenario == S08ErpDocumentFamiliesScenario.longMultiPage ? 500 : 5;
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
      code: _scenario == S08ErpDocumentFamiliesScenario.label
          ? const GeniusErpCodeSpec(
              kind: GeniusErpCodeKind.barcode,
              barcodeType: GeniusBarcodeType.code128,
              data: 'ERP-LABEL-2026-0001',
              caption: 'ERP Label',
              captionAr: 'ملصق ERP',
            )
          : _scenario == S08ErpDocumentFamiliesScenario.customSlots
              ? const GeniusErpCodeSpec(
                  data: 'https://example.com/erp/FAMILY-2026-0001',
                  caption: 'Family QR',
                  captionAr: 'رمز العائلة',
                )
              : null,
      replacements: _scenario == S08ErpDocumentFamiliesScenario.customSlots
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
      customSections: _scenario == S08ErpDocumentFamiliesScenario.customSlots
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
        firstPageHeader: _scenario == S08ErpDocumentFamiliesScenario.customSlots
            ? (slotContext) => GeniusPdfLabel(
                  config: slotContext.config,
                  text: 'FIRST PAGE VARIANT',
                  textAr: 'نسخة الصفحة الأولى',
                  tone: GeniusPdfSemanticTone.success,
                  alignment: GeniusPdfLogicalAlignment.center,
                  directionality: slotContext.directionality,
                )
            : null,
        lastPageFooter: _scenario == S08ErpDocumentFamiliesScenario.customSlots
            ? (slotContext) => GeniusPdfLabel(
                  config: slotContext.config,
                  text: 'LAST PAGE VARIANT',
                  textAr: 'نسخة الصفحة الأخيرة',
                  alignment: GeniusPdfLogicalAlignment.center,
                  directionality: slotContext.directionality,
                )
            : null,
      ),
      hooks: _scenario == S08ErpDocumentFamiliesScenario.customSlots
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
          direction: _scenario == S08ErpDocumentFamiliesScenario.customSlots
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
      S08ErpDocumentFamiliesScenario.transaction => GeniusErpTransactionDocument(
          config,
          plan: plan,
          directionality: directionality,
        ),
      S08ErpDocumentFamiliesScenario.customSlots => GeniusErpTransactionDocument(
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
      S08ErpDocumentFamiliesScenario.longMultiPage => GeniusErpTransactionDocument(
          config,
          plan: plan,
          directionality: directionality,
        ),
      S08ErpDocumentFamiliesScenario.statement => GeniusErpStatementDocument(
          config,
          plan: plan,
          directionality: directionality,
        ),
      S08ErpDocumentFamiliesScenario.voucher => GeniusErpVoucherDocument(
          config,
          plan: plan,
          directionality: directionality,
        ),
      S08ErpDocumentFamiliesScenario.analytical => GeniusErpAnalyticalReport(
          config,
          plan: plan,
          directionality: directionality,
        ),
      S08ErpDocumentFamiliesScenario.operational => GeniusErpOperationalForm(
          config,
          plan: plan,
          directionality: directionality,
        ),
      S08ErpDocumentFamiliesScenario.register => GeniusErpRegisterDocument(
          config,
          plan: plan,
          directionality: directionality,
        ),
      S08ErpDocumentFamiliesScenario.thermal => GeniusErpThermalReceipt(
          config,
          plan: plan,
          directionality: directionality,
        ),
      S08ErpDocumentFamiliesScenario.label => GeniusErpLabelDocument(
          config,
          plan: plan,
          directionality: directionality,
        ),
      S08ErpDocumentFamiliesScenario.certificate => GeniusErpCertificateDocument(
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
}


Future<Uint8List> buildS08TransactionVerificationPdf(GeniusPdfConfig config) {
  final runner = S08ErpDocumentFamiliesRunner(
    baseConfig: config,
    scenario: S08ErpDocumentFamiliesScenario.transaction,
  );
  runner._direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  return runner.generate();
}

Future<Uint8List> buildS08StatementVerificationPdf(GeniusPdfConfig config) {
  final runner = S08ErpDocumentFamiliesRunner(
    baseConfig: config,
    scenario: S08ErpDocumentFamiliesScenario.statement,
  );
  runner._direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  return runner.generate();
}

Future<Uint8List> buildS08VoucherVerificationPdf(GeniusPdfConfig config) {
  final runner = S08ErpDocumentFamiliesRunner(
    baseConfig: config,
    scenario: S08ErpDocumentFamiliesScenario.voucher,
  );
  runner._direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  return runner.generate();
}

Future<Uint8List> buildS08AnalyticalVerificationPdf(GeniusPdfConfig config) {
  final runner = S08ErpDocumentFamiliesRunner(
    baseConfig: config,
    scenario: S08ErpDocumentFamiliesScenario.analytical,
  );
  runner._direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  return runner.generate();
}

Future<Uint8List> buildS08OperationalVerificationPdf(GeniusPdfConfig config) {
  final runner = S08ErpDocumentFamiliesRunner(
    baseConfig: config,
    scenario: S08ErpDocumentFamiliesScenario.operational,
  );
  runner._direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  return runner.generate();
}

Future<Uint8List> buildS08RegisterVerificationPdf(GeniusPdfConfig config) {
  final runner = S08ErpDocumentFamiliesRunner(
    baseConfig: config,
    scenario: S08ErpDocumentFamiliesScenario.register,
  );
  runner._direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  return runner.generate();
}

Future<Uint8List> buildS08ThermalVerificationPdf(GeniusPdfConfig config) {
  final runner = S08ErpDocumentFamiliesRunner(
    baseConfig: config,
    scenario: S08ErpDocumentFamiliesScenario.thermal,
  );
  runner._direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  return runner.generate();
}

Future<Uint8List> buildS08LabelVerificationPdf(GeniusPdfConfig config) {
  final runner = S08ErpDocumentFamiliesRunner(
    baseConfig: config,
    scenario: S08ErpDocumentFamiliesScenario.label,
  );
  runner._direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  return runner.generate();
}

Future<Uint8List> buildS08CertificateVerificationPdf(GeniusPdfConfig config) {
  final runner = S08ErpDocumentFamiliesRunner(
    baseConfig: config,
    scenario: S08ErpDocumentFamiliesScenario.certificate,
  );
  runner._direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  return runner.generate();
}

Future<Uint8List> buildS08CustomSlotsVerificationPdf(GeniusPdfConfig config) {
  final runner = S08ErpDocumentFamiliesRunner(
    baseConfig: config,
    scenario: S08ErpDocumentFamiliesScenario.customSlots,
  );
  runner._direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  return runner.generate();
}

Future<Uint8List> buildS08LongMultiPageVerificationPdf(GeniusPdfConfig config) {
  final runner = S08ErpDocumentFamiliesRunner(
    baseConfig: config,
    scenario: S08ErpDocumentFamiliesScenario.longMultiPage,
  );
  runner._direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  return runner.generate();
}
