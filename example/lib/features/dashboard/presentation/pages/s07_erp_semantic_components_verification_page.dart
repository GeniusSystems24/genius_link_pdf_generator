
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/create_save_open_pdf_button.dart';
enum _S07Scenario {
  identityParty,
  financial,
  operational,
  nullCollapse,
  emptyState,
  bilingual,
  composition,
  longMultiPage,
}

class S07ErpSemanticComponentsVerificationPage extends StatefulWidget {
  const S07ErpSemanticComponentsVerificationPage({super.key});

  @override
  State<S07ErpSemanticComponentsVerificationPage> createState() =>
      _S07ErpSemanticComponentsVerificationPageState();
}

class _S07ErpSemanticComponentsVerificationPageState
    extends State<S07ErpSemanticComponentsVerificationPage> {
  _S07Scenario _scenario = _S07Scenario.identityParty;
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

  String _label(_S07Scenario scenario) => switch (scenario) {
        _S07Scenario.identityParty => 'Identity / Party / Address',
        _S07Scenario.financial => 'Financial semantic blocks',
        _S07Scenario.operational => 'Operational components',
        _S07Scenario.nullCollapse => 'Null collapse / no gap',
        _S07Scenario.emptyState => 'Explicit empty state',
        _S07Scenario.bilingual => 'Bilingual mixed values',
        _S07Scenario.composition => 'Reusable composition',
        _S07Scenario.longMultiPage => 'Long / multi-page',
      };

  String get _expected => switch (_scenario) {
        _S07Scenario.identityParty =>
          'Document identity, party, address and references render from S06 '
              'domain objects. Number/tax/phone/email/date values remain LTR '
              'inside RTL while labels and geometry follow start/end.',
        _S07Scenario.financial =>
          'Money, tax, discounts/charges and balance all use the S05 formatter '
              'and S06 calculation result; no calculation is duplicated by '
              'the PDF components.',
        _S07Scenario.operational =>
          'Terms, approval trail, stamp, metric cards and label render using '
              'the shared semantic APIs with inherited directionality.',
        _S07Scenario.nullCollapse =>
          'Null party/address/terms are completely absent. The component group '
              'adds spacing only between sections that actually rendered.',
        _S07Scenario.emptyState =>
          'Empty reference/approval/metric lists deliberately show localized '
              'empty-state content instead of silently disappearing.',
        _S07Scenario.bilingual =>
          'Arabic prose and English identifiers/contact values coexist without '
              'manual string reversal; structured values remain readable LTR.',
        _S07Scenario.composition =>
          'A reusable group composes identity, party, address, tax, balance '
              'and terms without rebuilding their layout logic.',
        _S07Scenario.longMultiPage =>
          'The same reference/terms semantic components are reused across '
              'multiple real PDF pages with long content and stable values.',
      };

  Future<Uint8List> _generate() async {
    final config = geniusPdfConfig.copyWith(
      textDirection: _direction == GeniusPdfDirection.rtl
          ? TextDirection.rtl
          : TextDirection.ltr,
    );

    final builder = _S07Document(
      config: config,
      directionality: GeniusPdfDirectionality(
        documentDirection: _direction,
      ),
      scenario: _scenario,
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
                    'Sprint S07 — ERP Semantic Components',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 250,
                        child: DropdownButtonFormField<_S07Scenario>(
                          key: ValueKey(_scenario),
                          initialValue: _scenario,
                          decoration: const InputDecoration(
                            labelText: 'Scenario',
                            border: OutlineInputBorder(),
                          ),
                          items: _S07Scenario.values
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
                        fileName: 's07_erp_semantic_components.pdf',
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

class _S07Document extends GeniusPdfDocumentBuilder {
  _S07Document({
    required GeniusPdfConfig config,
    required GeniusPdfDirectionality directionality,
    required this.scenario,
  }) : super(config, directionality: directionality);

  final _S07Scenario scenario;

  ErpDocumentContext _context({
    bool withAddress = true,
    bool withTerms = true,
  }) {
    final billing = withAddress
        ? const ErpAddress(
            role: ErpAddressRole.billing,
            line1: 'King Fahd Road طريق الملك فهد',
            city: 'Riyadh الرياض',
            postalCode: '12211',
            countryCode: 'SA',
          )
        : null;

    return ErpDocumentContext(
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
        kind: ErpDocumentKind.invoice,
        number: 'INV-2026-000123',
        issueDate: DateTime(2026, 9, 4),
        status: ErpDocumentStatus.issued,
        externalId: 'ERP-INV-8821',
      ),
      recipient: ErpParty(
        id: 'CUST-001',
        name: 'Acme Trading',
        nameAr: 'شركة أكمي للتجارة',
        registrationNumber: 'CR-1010099999',
        taxIdentity: const ErpTaxIdentity(
          taxNumber: '310987654300003',
          countryCode: 'SA',
        ),
        addresses: billing == null ? const [] : [billing],
        contacts: const [
          ErpContactMetadata(
            contactName: 'Finance المالية',
            phone: '+966 50 123 4567',
            email: 'finance@example.com',
          ),
        ],
      ),
      billingAddress: billing,
      shippingAddress: null,
      documentCurrency: ErpCurrency.sar,
      references: [
        ErpDocumentReference(
          type: 'Purchase Order',
          number: 'PO-2026-00421',
          date: DateTime(2026, 9, 1),
        ),
      ],
      lineItems: [
        ErpLineItem(
          id: '1',
          description: 'ERP Consulting',
          descriptionAr: 'استشارات ERP',
          sku: 'SKU-ERP-001',
          quantity: const ErpQuantity(
            value: 2,
            unit: ErpUnit.each,
          ),
          unitPrice: ErpMoney.fromAmount(
            1000,
            currency: ErpCurrency.sar,
          ),
          discounts: [
            ErpDiscount.percentage(percentage: 5),
          ],
          charges: [
            ErpCharge.fixed(
              amount: ErpMoney.fromAmount(
                25,
                currency: ErpCurrency.sar,
              ),
            ),
          ],
          taxes: const [
            ErpTaxLine(
              code: 'VAT',
              ratePercent: 15,
            ),
          ],
        ),
      ],
      approvals: [
        ErpApproval(
          stage: 'Finance Review',
          status: ErpApprovalStatus.approved,
          approverName: 'A. Reviewer',
          decidedAt: DateTime(2026, 9, 4, 10, 30),
          comment: 'Approved for posting',
        ),
        const ErpApproval(
          stage: 'Manager Review',
          status: ErpApprovalStatus.pending,
        ),
      ],
      terms: withTerms
          ? 'Payment due within 30 days. Reference the invoice number '
              'on every payment.'
          : null,
    );
  }

  ErpCalculationResult _calculation(ErpDocumentContext context) {
    return const ErpCalculationService().calculate(
      ErpCalculationRequest.fromContext(
        context,
        paidAmount: ErpMoney.fromMinorUnits(
          100000,
          currency: ErpCurrency.sar,
        ),
      ),
    );
  }

  void _draw(
    GeniusPdfErpComponent component, {
    double spacing = 10,
  }) {
    if (!component.isVisible) return;
    final result = component.draw(
      page: currentPage,
      bounds: contentBounds,
    );
    if (result != null) {
      setCurrentPage(
        currentPage,
        y: result.bottom + spacing,
      );
    }
  }

  void _drawGroup(
    GeniusPdfErpComponentGroup group, {
    double spacing = 10,
  }) {
    if (!group.isVisible) return;
    final result = group.draw(
      page: currentPage,
      bounds: contentBounds,
    );
    if (result != null) {
      setCurrentPage(
        currentPage,
        y: result.bottom + spacing,
      );
    }
  }

  @override
  void build() {
    newPage();

    final context = _context();
    final result = _calculation(context);

    switch (scenario) {
      case _S07Scenario.identityParty:
        _draw(
          GeniusPdfDocumentIdentity(
            config: config,
            data: context.identity,
            directionality: directionality,
          ),
        );
        _draw(
          GeniusPdfPartyBlock(
            config: config,
            party: context.recipient,
            title: 'Customer',
            titleAr: 'العميل',
            directionality: directionality,
          ),
        );
        _draw(
          GeniusPdfAddressBlock(
            config: config,
            address: context.billingAddress,
            title: 'Billing Address',
            titleAr: 'عنوان الفوترة',
            directionality: directionality,
          ),
        );
        _draw(
          GeniusPdfReferenceBlock(
            config: config,
            references: context.references,
            directionality: directionality,
          ),
        );
        return;

      case _S07Scenario.financial:
        _draw(
          GeniusPdfMoney(
            config: config,
            amount: result.grandTotal,
            label: 'Grand Total',
            labelAr: 'الإجمالي',
            bold: true,
            directionality: directionality,
          ),
        );
        _draw(
          GeniusPdfAmountInWords(
            config: config,
            amount: result.grandTotal,
            text: 'Two thousand two hundred and thirteen Saudi riyals '
                'and seventy-five halalas only',
            textAr: 'ألفان ومئتان وثلاثة عشر ريالاً سعودياً '
                'وخمس وسبعون هللة فقط',
            directionality: directionality,
          ),
        );
        _draw(
          GeniusPdfAdjustmentSummary(
            config: config,
            result: result,
            directionality: directionality,
          ),
        );
        _draw(
          GeniusPdfTaxSummary(
            config: config,
            result: result,
            directionality: directionality,
          ),
        );
        _draw(
          GeniusPdfBalanceDueBlock(
            config: config,
            result: result,
            directionality: directionality,
          ),
        );
        return;

      case _S07Scenario.operational:
        _draw(
          GeniusPdfTermsSection(
            config: config,
            text: context.terms,
            textAr: 'يستحق السداد خلال 30 يوماً. يرجى ذكر رقم الفاتورة '
                'في كل دفعة.',
            directionality: directionality,
          ),
        );
        _draw(
          GeniusPdfApprovalTrail(
            config: config,
            approvals: context.approvals,
            directionality: directionality,
          ),
        );
        _draw(
          GeniusPdfStamp(
            config: config,
            text: 'APPROVED',
            textAr: 'معتمد',
            tone: GeniusPdfSemanticTone.success,
            directionality: directionality,
          ),
        );
        _draw(
          GeniusPdfMetricCards(
            config: config,
            cards: [
              GeniusPdfMetricCardData(
                label: 'Subtotal',
                labelAr: 'المجموع',
                value: config.formatter.formatMoney(
                  result.subtotal.toDouble(),
                  currencyCode: result.currency.code,
                ),
                valueKind: GeniusPdfValueKind.money,
              ),
              GeniusPdfMetricCardData(
                label: 'VAT',
                labelAr: 'الضريبة',
                value: config.formatter.formatMoney(
                  result.taxTotal.toDouble(),
                  currencyCode: result.currency.code,
                ),
                valueKind: GeniusPdfValueKind.money,
              ),
              GeniusPdfMetricCardData(
                label: 'Due',
                labelAr: 'المتبقي',
                value: config.formatter.formatMoney(
                  result.dueAmount!.toDouble(),
                  currencyCode: result.currency.code,
                ),
                valueKind: GeniusPdfValueKind.money,
              ),
            ],
            directionality: directionality,
          ),
        );
        _draw(
          GeniusPdfLabel(
            config: config,
            text: 'POSTED-ERP-2026-77',
            tone: GeniusPdfSemanticTone.info,
            valueKind: GeniusPdfValueKind.customIdentifier,
            directionality: directionality,
          ),
        );
        return;

      case _S07Scenario.nullCollapse:
        final nullContext = _context(
          withAddress: false,
          withTerms: false,
        );
        _drawGroup(
          GeniusPdfErpComponentGroup(
            spacing: 14,
            components: [
              GeniusPdfDocumentIdentity(
                config: config,
                data: nullContext.identity,
                directionality: directionality,
              ),
              GeniusPdfPartyBlock(
                config: config,
                party: null,
                directionality: directionality,
              ),
              GeniusPdfAddressBlock(
                config: config,
                address: null,
                directionality: directionality,
              ),
              GeniusPdfTermsSection(
                config: config,
                text: null,
                textAr: null,
                directionality: directionality,
              ),
              GeniusPdfLabel(
                config: config,
                text: 'VISIBLE AFTER NULL SECTIONS',
                textAr: 'ظاهر بعد الأقسام الفارغة',
                tone: GeniusPdfSemanticTone.success,
                directionality: directionality,
              ),
            ],
          ),
        );
        return;

      case _S07Scenario.emptyState:
        _draw(
          GeniusPdfReferenceBlock(
            config: config,
            references: const [],
            emptyPolicy: GeniusPdfEmptySectionPolicy.emptyState,
            directionality: directionality,
          ),
        );
        _draw(
          GeniusPdfApprovalTrail(
            config: config,
            approvals: const [],
            emptyPolicy: GeniusPdfEmptySectionPolicy.emptyState,
            directionality: directionality,
          ),
        );
        _draw(
          GeniusPdfMetricCards(
            config: config,
            cards: const [],
            emptyPolicy: GeniusPdfEmptySectionPolicy.emptyState,
            directionality: directionality,
          ),
        );
        return;

      case _S07Scenario.bilingual:
        _draw(
          GeniusPdfPartyBlock(
            config: config,
            party: context.recipient,
            title: 'Customer / العميل',
            titleAr: 'العميل / Customer',
            directionality: directionality,
          ),
        );
        _draw(
          GeniusPdfAddressBlock(
            config: config,
            address: context.billingAddress,
            directionality: directionality,
          ),
        );
        _draw(
          GeniusPdfLabel(
            config: config,
            text: 'INV-2026-000123',
            valueKind: GeniusPdfValueKind.documentNumber,
            tone: GeniusPdfSemanticTone.info,
            directionality: directionality,
          ),
        );
        _draw(
          GeniusPdfMoney(
            config: config,
            amount: result.grandTotal,
            label: 'Total الإجمالي',
            labelAr: 'الإجمالي Total',
            directionality: directionality,
          ),
        );
        return;

      case _S07Scenario.composition:
        _drawGroup(
          GeniusPdfErpComponentGroup(
            spacing: 10,
            components: [
              GeniusPdfDocumentIdentity(
                config: config,
                data: context.identity,
                directionality: directionality,
              ),
              GeniusPdfPartyBlock(
                config: config,
                party: context.recipient,
                title: 'Customer',
                titleAr: 'العميل',
                directionality: directionality,
              ),
              GeniusPdfAddressBlock(
                config: config,
                address: context.shippingAddress,
                title: 'Shipping Address',
                titleAr: 'عنوان الشحن',
                directionality: directionality,
              ),
              GeniusPdfTaxSummary(
                config: config,
                result: result,
                directionality: directionality,
              ),
              GeniusPdfBalanceDueBlock(
                config: config,
                result: result,
                directionality: directionality,
              ),
              GeniusPdfTermsSection(
                config: config,
                text: context.terms,
                textAr: 'يستحق السداد خلال 30 يوماً.',
                directionality: directionality,
              ),
            ],
          ),
        );
        return;

      case _S07Scenario.longMultiPage:
        for (var pageIndex = 0; pageIndex < 4; pageIndex++) {
          if (pageIndex > 0) newPage();

          final references = List<ErpDocumentReference>.generate(
            8,
            (index) => ErpDocumentReference(
              type: 'Reference ${pageIndex * 8 + index + 1}',
              number:
                  'REF-2026-${(pageIndex * 8 + index + 1).toString().padLeft(4, '0')}',
              date: DateTime(2026, 9, 1 + (index % 4)),
            ),
          );

          _draw(
            GeniusPdfReferenceBlock(
              config: config,
              references: references,
              title: 'Page ${pageIndex + 1} References',
              titleAr: 'مراجع الصفحة ${pageIndex + 1}',
              directionality: directionality,
            ),
            spacing: 8,
          );

          _draw(
            GeniusPdfTermsSection(
              config: config,
              text: List.filled(
                6,
                'Long ERP terms remain reusable and keep identifiers such as '
                    'INV-2026-000123 unchanged.',
              ).join(' '),
              textAr: List.filled(
                6,
                'نص شروط طويل للتحقق من الالتفاف مع بقاء المعرف '
                    'INV-2026-000123 بدون عكس.',
              ).join(' '),
              directionality: directionality,
            ),
          );
        }
        return;
    }
  }
}
