import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

/// Focused scenarios extracted from the former S06ErpDomainCalculationVerificationPage.
enum S06ErpDomainCalculationScenario {
  baseline,
  beforeTaxDiscount,
  afterTaxDiscount,
  multiTax,
  multiCurrency,
  rounding,
  paidDue,
  zeroNegative,
  optionalNulls,
  longMultiPage,
}

class S06ErpDomainCalculationDocument extends GeniusPdfDocumentBuilder {
  S06ErpDomainCalculationDocument({
    required GeniusPdfConfig config,
    required GeniusPdfDirectionality directionality,
    required this.scenario,
    required this.kind,
  }) : super(config, directionality: directionality);

  final S06ErpDomainCalculationScenario scenario;
  final ErpDocumentKind kind;

  static const _service = ErpCalculationService();

  ErpMoney _money(
    num value, [
    ErpCurrency currency = ErpCurrency.sar,
  ]) =>
      ErpMoney.fromAmount(value, currency: currency);

  ErpLineItem _line({
    String id = 'L1',
    double quantity = 1,
    num unitPrice = 100,
    ErpCurrency currency = ErpCurrency.sar,
    List<ErpDiscount> discounts = const [],
    List<ErpCharge> charges = const [],
    List<ErpTaxLine> taxes = const [],
  }) =>
      ErpLineItem(
        id: id,
        description: 'ERP line $id',
        descriptionAr: 'سطر ERP $id',
        sku: 'SKU-${id.padLeft(4, '0')}',
        quantity: ErpQuantity(
          value: quantity,
          unit: ErpUnit.each,
        ),
        unitPrice: _money(unitPrice, currency),
        discounts: discounts,
        charges: charges,
        taxes: taxes,
      );

  ErpDocumentContext _context({
    required List<ErpLineItem> lines,
    ErpCurrency documentCurrency = ErpCurrency.sar,
    ErpCurrency? baseCurrency,
    ErpExchangeRate? rate,
  }) =>
      ErpDocumentContext(
        organization: const ErpOrganization(
          id: 'ORG-001',
          legalName: 'Genius Systems',
          nameAr: 'أنظمة جينيس',
          taxIdentity: ErpTaxIdentity(
            taxNumber: '310123456700003',
            countryCode: 'SA',
          ),
        ),
        identity: ErpDocumentIdentity(
          kind: kind,
          number: '${kind.name.toUpperCase()}-2026-0001',
          issueDate: DateTime(2026, 9, 4),
          status: ErpDocumentStatus.issued,
        ),
        recipient: const ErpParty(
          id: 'PARTY-001',
          name: 'Example Counterparty',
          nameAr: 'الطرف التجريبي',
          contacts: [
            ErpContactMetadata(email: 'erp@example.com'),
          ],
        ),
        documentCurrency: documentCurrency,
        baseCurrency: baseCurrency,
        exchangeRate: rate,
        lineItems: lines,
        references: const [
          ErpDocumentReference(
            type: 'external',
            number: 'REF-2026-99',
          ),
        ],
      );

  @override
  void build() {
    newPage();

    switch (scenario) {
      case S06ErpDomainCalculationScenario.baseline:
        final context = _context(
          lines: [
            _line(
              quantity: 2,
              discounts: [
                ErpDiscount.percentage(percentage: 10),
              ],
              charges: [
                ErpCharge.fixed(amount: _money(10)),
              ],
              taxes: const [
                ErpTaxLine(code: 'VAT', ratePercent: 15),
              ],
            ),
          ],
        );
        _render(
          context,
          _service.calculate(
            ErpCalculationRequest.fromContext(context),
          ),
        );
        return;

      case S06ErpDomainCalculationScenario.beforeTaxDiscount:
        final context = _context(
          lines: [
            _line(
              taxes: const [
                ErpTaxLine(code: 'VAT', ratePercent: 15),
              ],
            ),
          ],
        );
        _render(
          context,
          _service.calculate(
            ErpCalculationRequest.fromContext(
              context,
              documentDiscounts: [
                ErpDiscount.percentage(percentage: 10),
              ],
              config: const ErpCalculationConfig(
                documentDiscountTaxPolicy:
                    ErpDocumentDiscountTaxPolicy.beforeTax,
              ),
            ),
          ),
        );
        return;

      case S06ErpDomainCalculationScenario.afterTaxDiscount:
        final context = _context(
          lines: [
            _line(
              taxes: const [
                ErpTaxLine(code: 'VAT', ratePercent: 15),
              ],
            ),
          ],
        );
        _render(
          context,
          _service.calculate(
            ErpCalculationRequest.fromContext(
              context,
              documentDiscounts: [
                ErpDiscount.percentage(percentage: 10),
              ],
              config: const ErpCalculationConfig(
                documentDiscountTaxPolicy:
                    ErpDocumentDiscountTaxPolicy.afterTax,
              ),
            ),
          ),
        );
        return;

      case S06ErpDomainCalculationScenario.multiTax:
        final context = _context(
          lines: [
            _line(
              taxes: const [
                ErpTaxLine(code: 'VAT', ratePercent: 15),
                ErpTaxLine(
                  code: 'LEVY',
                  ratePercent: 5,
                  compound: true,
                ),
              ],
            ),
          ],
        );
        _render(
          context,
          _service.calculate(
            ErpCalculationRequest.fromContext(context),
          ),
        );
        return;

      case S06ErpDomainCalculationScenario.multiCurrency:
        const rate = ErpExchangeRate(
          from: ErpCurrency.usd,
          to: ErpCurrency.sar,
          rate: 3.75,
        );
        final context = _context(
          documentCurrency: ErpCurrency.usd,
          baseCurrency: ErpCurrency.sar,
          rate: rate,
          lines: [
            _line(currency: ErpCurrency.usd),
          ],
        );
        _render(
          context,
          _service.calculate(
            ErpCalculationRequest.fromContext(context),
          ),
        );
        return;

      case S06ErpDomainCalculationScenario.rounding:
        final context = _context(
          lines: [_line(unitPrice: 10.03)],
        );
        _render(
          context,
          _service.calculate(
            ErpCalculationRequest.fromContext(
              context,
              config: const ErpCalculationConfig(
                roundingIncrementMinorUnits: 5,
              ),
            ),
          ),
        );
        return;

      case S06ErpDomainCalculationScenario.paidDue:
        final context = _context(
          lines: [
            _line(
              taxes: const [
                ErpTaxLine(code: 'VAT', ratePercent: 15),
              ],
            ),
          ],
        );
        _render(
          context,
          _service.calculate(
            ErpCalculationRequest.fromContext(
              context,
              paidAmount: _money(50),
            ),
          ),
        );
        return;

      case S06ErpDomainCalculationScenario.zeroNegative:
        final context = _context(
          lines: [_line(quantity: -1)],
        );
        _render(
          context,
          _service.calculate(
            ErpCalculationRequest.fromContext(
              context,
              config: const ErpCalculationConfig(
                allowNegativeQuantity: true,
                allowNegativeGrandTotal: true,
              ),
            ),
          ),
        );
        return;

      case S06ErpDomainCalculationScenario.optionalNulls:
        final context = ErpDocumentContext(
          organization: const ErpOrganization(
            id: 'ORG',
            legalName: 'Organization',
          ),
          identity: ErpDocumentIdentity(
            kind: kind,
            number: 'NULL-001',
            issueDate: DateTime(2026, 9, 4),
          ),
          documentCurrency: ErpCurrency.sar,
          lineItems: [_line()],
        );
        final validation =
            const ErpDomainValidator().validateDocumentContext(context);
        addLine(
          'Validation: ${validation.isValid ? 'valid' : 'invalid'}',
        );
        addLine('branch = ${context.branch}', topMargin: 4);
        addLine('recipient = ${context.recipient}', topMargin: 4);
        addLine(
          'printMetadata = ${context.printMetadata}',
          topMargin: 4,
        );
        addLine(
          'attachments = ${context.attachments.length}',
          topMargin: 4,
        );
        _render(
          context,
          _service.calculate(
            ErpCalculationRequest.fromContext(context),
          ),
        );
        return;

      case S06ErpDomainCalculationScenario.longMultiPage:
        final lines = List<ErpLineItem>.generate(
          120,
          (index) => _line(
            id: '${index + 1}',
            quantity: (index % 5) + 1,
            unitPrice: (index + 1) * 3.75,
            taxes: const [
              ErpTaxLine(code: 'VAT', ratePercent: 15),
            ],
          ),
        );
        final context = _context(lines: lines);
        final result = _service.calculate(
          ErpCalculationRequest.fromContext(context),
        );
        _header(context);
        for (final line in result.lines) {
          addLine(
            '${line.line.id} ${line.line.sku ?? ''} ${_format(line.total)}',
            topMargin: 3,
          );
        }
        _totals(result);
        return;
    }
  }

  void _render(
    ErpDocumentContext context,
    ErpCalculationResult result,
  ) {
    _header(context);
    for (final line in result.lines) {
      addLine(
        '${line.line.sku ?? line.line.id} — ${line.line.description}',
        topMargin: 6,
      );
      addLine(
        'subtotal ${_format(line.subtotal)} | '
        'discount ${_format(line.lineDiscountTotal)} | '
        'tax ${_format(line.taxTotal)} | total ${_format(line.total)}',
        topMargin: 3,
      );
    }
    _totals(result);
  }

  void _header(ErpDocumentContext context) {
    addLine(
      context.organization.displayName(isRtl: config.isRTL),
    );
    addLine(
      '${context.identity.kind.name} '
      '${config.formatter.formatIdentifier(context.identity.number)}',
      topMargin: 4,
    );
    addLine(
      'Document currency: ${context.documentCurrency.code}'
      '${context.baseCurrency == null ? '' : ' | Base: ${context.baseCurrency!.code}'}',
      topMargin: 4,
    );
  }

  void _totals(ErpCalculationResult result) {
    addSpace(8);
    addLine('Subtotal: ${_format(result.subtotal)}');
    addLine(
      'Document discount: ${_format(result.documentDiscountTotal)}',
      topMargin: 3,
    );
    addLine('Charges: ${_format(result.chargeTotal)}', topMargin: 3);
    addLine('Taxable: ${_format(result.taxableAmount)}', topMargin: 3);
    addLine('Tax: ${_format(result.taxTotal)}', topMargin: 3);
    addLine(
      'Rounding: ${_format(result.roundingAdjustment)}',
      topMargin: 3,
    );
    addLine('Grand: ${_format(result.grandTotal)}', topMargin: 3);

    if (result.paidAmount != null) {
      addLine('Paid: ${_format(result.paidAmount!)}', topMargin: 3);
      addLine('Due: ${_format(result.dueAmount!)}', topMargin: 3);
    }

    if (result.baseGrandTotal != null &&
        result.baseGrandTotal!.currency != result.currency) {
      addLine(
        'Base grand: ${_format(result.baseGrandTotal!)}',
        topMargin: 3,
      );
    }
  }

  String _format(ErpMoney money) =>
      config.formatter.formatMoney(
        money.toDouble(),
        currencyCode: money.currency.code,
        decimalPlaces: money.currency.precision,
      );
}

Future<Uint8List> buildS06BaselineVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S06ErpDomainCalculationDocument(
    config: config,
    directionality: directionality,
    scenario: S06ErpDomainCalculationScenario.baseline,
    kind: ErpDocumentKind.invoice,
  );
  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}

Future<Uint8List> buildS06BeforeTaxDiscountVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S06ErpDomainCalculationDocument(
    config: config,
    directionality: directionality,
    scenario: S06ErpDomainCalculationScenario.beforeTaxDiscount,
    kind: ErpDocumentKind.invoice,
  );
  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}

Future<Uint8List> buildS06AfterTaxDiscountVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S06ErpDomainCalculationDocument(
    config: config,
    directionality: directionality,
    scenario: S06ErpDomainCalculationScenario.afterTaxDiscount,
    kind: ErpDocumentKind.invoice,
  );
  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}

Future<Uint8List> buildS06MultiTaxVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S06ErpDomainCalculationDocument(
    config: config,
    directionality: directionality,
    scenario: S06ErpDomainCalculationScenario.multiTax,
    kind: ErpDocumentKind.invoice,
  );
  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}

Future<Uint8List> buildS06MultiCurrencyVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S06ErpDomainCalculationDocument(
    config: config,
    directionality: directionality,
    scenario: S06ErpDomainCalculationScenario.multiCurrency,
    kind: ErpDocumentKind.invoice,
  );
  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}

Future<Uint8List> buildS06RoundingVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S06ErpDomainCalculationDocument(
    config: config,
    directionality: directionality,
    scenario: S06ErpDomainCalculationScenario.rounding,
    kind: ErpDocumentKind.invoice,
  );
  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}

Future<Uint8List> buildS06PaidDueVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S06ErpDomainCalculationDocument(
    config: config,
    directionality: directionality,
    scenario: S06ErpDomainCalculationScenario.paidDue,
    kind: ErpDocumentKind.invoice,
  );
  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}

Future<Uint8List> buildS06ZeroNegativeVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S06ErpDomainCalculationDocument(
    config: config,
    directionality: directionality,
    scenario: S06ErpDomainCalculationScenario.zeroNegative,
    kind: ErpDocumentKind.invoice,
  );
  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}

Future<Uint8List> buildS06OptionalNullsVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S06ErpDomainCalculationDocument(
    config: config,
    directionality: directionality,
    scenario: S06ErpDomainCalculationScenario.optionalNulls,
    kind: ErpDocumentKind.invoice,
  );
  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}

Future<Uint8List> buildS06LongMultiPageVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S06ErpDomainCalculationDocument(
    config: config,
    directionality: directionality,
    scenario: S06ErpDomainCalculationScenario.longMultiPage,
    kind: ErpDocumentKind.invoice,
  );
  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}
