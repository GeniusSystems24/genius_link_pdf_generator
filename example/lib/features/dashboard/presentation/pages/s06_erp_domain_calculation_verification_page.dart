
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/create_save_open_pdf_button.dart';
enum _S06Scenario {
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

class S06ErpDomainCalculationVerificationPage extends StatefulWidget {
  const S06ErpDomainCalculationVerificationPage({super.key});

  @override
  State<S06ErpDomainCalculationVerificationPage> createState() =>
      _S06ErpDomainCalculationVerificationPageState();
}

class _S06ErpDomainCalculationVerificationPageState
    extends State<S06ErpDomainCalculationVerificationPage> {
  _S06Scenario _scenario = _S06Scenario.baseline;
  ErpDocumentKind _kind = ErpDocumentKind.invoice;
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

  String _label(_S06Scenario value) => switch (value) {
        _S06Scenario.baseline => 'Baseline calculation',
        _S06Scenario.beforeTaxDiscount => 'Discount before tax',
        _S06Scenario.afterTaxDiscount => 'Discount after tax',
        _S06Scenario.multiTax => 'Multi-tax / compound',
        _S06Scenario.multiCurrency => 'Document/base currency',
        _S06Scenario.rounding => 'Rounding adjustment',
        _S06Scenario.paidDue => 'Paid / due',
        _S06Scenario.zeroNegative => 'Zero / negative policy',
        _S06Scenario.optionalNulls => 'Null optional metadata',
        _S06Scenario.longMultiPage => 'Long / multi-page',
      };

  String get _expected => switch (_scenario) {
        _S06Scenario.baseline =>
          '2 × 100 SAR, 10% line discount, 10 SAR taxable charge and 15% VAT '
              'produce subtotal 200.00, discount 20.00, taxable 190.00, '
              'tax 28.50 and grand total 218.50 SAR.',
        _S06Scenario.beforeTaxDiscount =>
          '10% document discount reduces 100 SAR taxable base to 90 SAR; '
              'VAT is 13.50 and grand total is 103.50.',
        _S06Scenario.afterTaxDiscount =>
          'VAT is calculated on 100 SAR first (15.00), then the 10 SAR '
              'document discount is applied; grand total is 105.00.',
        _S06Scenario.multiTax =>
          '15% VAT plus a 5% compound levy produces tax 20.75 and grand '
              'total 120.75 on a 100 SAR line.',
        _S06Scenario.multiCurrency =>
          'A 100 USD document converted with 1 USD = 3.75 SAR exposes '
              'document grand total 100 USD and base grand total 375 SAR.',
        _S06Scenario.rounding =>
          '10.03 SAR with a 5-minor-unit increment rounds to 10.05; '
              'rounding adjustment is +0.02.',
        _S06Scenario.paidDue =>
          '115 SAR grand total with 50 SAR paid produces 65 SAR due. '
              'Without paid metadata, paid/due remain null.',
        _S06Scenario.zeroNegative =>
          'The explicit calculation config allows negative quantity and '
              'negative grand total for the credit-note scenario.',
        _S06Scenario.optionalNulls =>
          'Branch, optional contact/tax/print/attachment metadata remain '
              'null/empty; no dummy values are generated.',
        _S06Scenario.longMultiPage =>
          'The shared domain represents many lines while the real PDF builder '
              'flows them across pages; calculations stay independent from UI.',
      };

  Future<Uint8List> _generate() async {
    final config = geniusPdfConfig.copyWith(
      textDirection: _direction == GeniusPdfDirection.rtl
          ? TextDirection.rtl
          : TextDirection.ltr,
    );

    final builder = _S06Document(
      config: config,
      directionality: GeniusPdfDirectionality(
        documentDirection: _direction,
      ),
      scenario: _scenario,
      kind: _kind,
    );

    final bytes = Uint8List.fromList(builder.generate());
    builder.dispose();
    return bytes;
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
                    'Sprint S06 — ERP Domain & Calculations',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 235,
                        child: DropdownButtonFormField<_S06Scenario>(
                          key: ValueKey(_scenario),
                          initialValue: _scenario,
                          decoration: const InputDecoration(
                            labelText: 'Scenario',
                            border: OutlineInputBorder(),
                          ),
                          items: _S06Scenario.values
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
                      DropdownButton<ErpDocumentKind>(
                        value: _kind,
                        items: const [
                          DropdownMenuItem(
                            value: ErpDocumentKind.quotation,
                            child: Text('Quotation'),
                          ),
                          DropdownMenuItem(
                            value: ErpDocumentKind.purchaseOrder,
                            child: Text('Purchase Order'),
                          ),
                          DropdownMenuItem(
                            value: ErpDocumentKind.invoice,
                            child: Text('Invoice'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          _change(() => _kind = value);
                        },
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
                        fileName: 's06_erp_domain_calculation.pdf',
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

class _S06Document extends GeniusPdfDocumentBuilder {
  _S06Document({
    required GeniusPdfConfig config,
    required GeniusPdfDirectionality directionality,
    required this.scenario,
    required this.kind,
  }) : super(config, directionality: directionality);

  final _S06Scenario scenario;
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
      case _S06Scenario.baseline:
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

      case _S06Scenario.beforeTaxDiscount:
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

      case _S06Scenario.afterTaxDiscount:
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

      case _S06Scenario.multiTax:
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

      case _S06Scenario.multiCurrency:
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

      case _S06Scenario.rounding:
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

      case _S06Scenario.paidDue:
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

      case _S06Scenario.zeroNegative:
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

      case _S06Scenario.optionalNulls:
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

      case _S06Scenario.longMultiPage:
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
