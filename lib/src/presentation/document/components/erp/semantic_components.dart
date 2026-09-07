
import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../../core/component_directionality.dart';
import '../../../../core/directionality.dart';
import '../../../../core/pdf_config.dart';
import '../../../../domain/erp/erp.dart';
import '../models/pdf_styles.dart';
import '../widgets/pdf_info_box.dart';
import '../widgets/pdf_rich_text.dart';

/// Controls how list/optional semantic sections behave when no data exists.
enum GeniusPdfEmptySectionPolicy {
  /// Do not render anything and consume no layout space.
  hide,

  /// Render a localized empty-state message.
  emptyState,
}

/// Semantic tone used by labels, stamps and metrics.
enum GeniusPdfSemanticTone {
  neutral,
  success,
  warning,
  error,
  info,
}

/// Resolves amount-in-words prose supplied by the application.
///
/// S07 does not invent a locale-specific number-to-words engine. Applications
/// can provide an audited resolver for the currencies/locales they support.
typedef GeniusPdfAmountInWordsResolver = String Function(
  ErpMoney amount,
  bool isRtl,
);

/// Base contract for reusable S07 ERP semantic components.
///
/// Public geometry uses package-owned logical direction primitives. Physical
/// left/right conversion occurs only when [contentBounds] resolves a concrete
/// [Rect] at draw time.
abstract class GeniusPdfErpComponent {
  const GeniusPdfErpComponent({
    required this.config,
    this.directionality,
    this.direction = GeniusPdfDirection.auto,
    this.padding = const GeniusPdfDirectionalInsets(),
  });

  /// Shared PDF configuration.
  final GeniusPdfConfig config;

  /// Inherited document/component directionality.
  final GeniusPdfDirectionality? directionality;

  /// Optional component-level direction override.
  final GeniusPdfDirection direction;

  /// Logical start/end padding.
  final GeniusPdfDirectionalInsets padding;

  /// Fully inherited directionality context.
  GeniusPdfDirectionality get effectiveDirectionality =>
      GeniusPdfComponentDirectionality.context(
        config: config,
        inherited: directionality,
        componentDirection: direction,
      );

  /// Resolved component layout direction.
  GeniusPdfResolvedDirection get resolvedDirection =>
      effectiveDirectionality.resolve().direction;

  /// Whether this component has semantic content to render.
  bool get isVisible;

  /// Resolves logical padding only at the drawing boundary.
  Rect contentBounds(Rect bounds) {
    final resolved = padding.resolve(resolvedDirection);
    final width = bounds.width - resolved.left - resolved.right;
    final height = bounds.height - resolved.top - resolved.bottom;
    return Rect.fromLTWH(
      bounds.left + resolved.left,
      bounds.top + resolved.top,
      width < 0 ? 0 : width,
      height < 0 ? 0 : height,
    );
  }

  /// Draws this component, returning the occupied physical rectangle.
  ///
  /// Returning `null` means the component collapsed and consumed no space.
  Rect? draw({
    required PdfPage page,
    required Rect bounds,
  });
}

/// Composes semantic components without leaving gaps for hidden/null sections.
///
/// Spacing is inserted only between components that actually returned a
/// non-empty drawing rectangle.
class GeniusPdfErpComponentGroup {
  const GeniusPdfErpComponentGroup({
    required this.components,
    this.spacing = 10,
  }) : assert(spacing >= 0);

  final List<GeniusPdfErpComponent> components;
  final double spacing;

  bool get isVisible => components.any((component) => component.isVisible);

  Rect? draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    var currentY = bounds.top;
    var rendered = 0;
    Rect? total;

    for (final component in components) {
      if (!component.isVisible) continue;

      final top = currentY + (rendered == 0 ? 0 : spacing);
      final remaining = bounds.bottom - top;
      if (remaining <= 0) break;

      final result = component.draw(
        page: page,
        bounds: Rect.fromLTWH(
          bounds.left,
          top,
          bounds.width,
          remaining,
        ),
      );

      if (result == null || result.height <= 0) continue;

      total = total == null
          ? result
          : Rect.fromLTRB(
              bounds.left,
              total.top,
              bounds.right,
              result.bottom,
            );
      currentY = result.bottom;
      rendered++;
    }

    return total;
  }
}

GeniusPdfDirection _explicitDirection(
  GeniusPdfDirectionality context,
  GeniusPdfValueKind kind,
) {
  return context.resolveValue(kind) == GeniusPdfResolvedDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
}

GeniusPdfTextAlign _textAlign(
  GeniusPdfLogicalAlignment alignment,
) {
  return switch (alignment) {
    GeniusPdfLogicalAlignment.start => GeniusPdfTextAlign.start,
    GeniusPdfLogicalAlignment.center => GeniusPdfTextAlign.center,
    GeniusPdfLogicalAlignment.end => GeniusPdfTextAlign.end,
  };
}

Color _toneColor(
  GeniusPdfConfig config,
  GeniusPdfSemanticTone tone,
) {
  final colors = config.theme.semanticColors;
  return switch (tone) {
    GeniusPdfSemanticTone.neutral => colors.muted,
    GeniusPdfSemanticTone.success => colors.success,
    GeniusPdfSemanticTone.warning => colors.warning,
    GeniusPdfSemanticTone.error => colors.error,
    GeniusPdfSemanticTone.info => colors.info,
  };
}

GeniusPdfLabeledValue _field({
  required GeniusPdfConfig config,
  required GeniusPdfDirectionality directionality,
  required String label,
  required String value,
  String? labelAr,
  GeniusPdfValueKind valueKind = GeniusPdfValueKind.plainText,
  String separator = ': ',
  Color? valueColor,
}) {
  return GeniusPdfLabeledValue(
    config: config,
    label: label,
    labelAr: labelAr,
    value: value,
    separator: separator,
    valueColor: valueColor,
    directionality: directionality,
    valueDirection: _explicitDirection(
      directionality,
      valueKind,
    ),
  );
}

GeniusPdfLabeledValue _emptyField({
  required GeniusPdfConfig config,
  required GeniusPdfDirectionality directionality,
  required String text,
  required String textAr,
}) {
  final rtl = directionality.resolve().direction.isRtl;
  return GeniusPdfLabeledValue(
    config: config,
    label: '',
    value: rtl ? textAr : text,
    separator: '',
    directionality: directionality,
  );
}

Rect? _drawRichText({
  required GeniusPdfConfig config,
  required GeniusPdfDirectionality directionality,
  required List<GeniusPdfTextSpan> spans,
  required PdfPage page,
  required Rect bounds,
  GeniusPdfLogicalAlignment alignment = GeniusPdfLogicalAlignment.start,
}) {
  if (spans.isEmpty) return null;

  final result = GeniusPdfRichText(
    config: config,
    spans: spans,
    directionality: directionality,
    defaultStyle: GeniusPdfTextStyle(
      fontSize: config.baseFont.size,
      alignment: _textAlign(alignment),
    ),
  ).draw(
    page: page,
    bounds: bounds,
  );

  return result?.bounds;
}

/// S07-T01 — reusable document identity block.
class GeniusPdfDocumentIdentity extends GeniusPdfErpComponent {
  const GeniusPdfDocumentIdentity({
    required super.config,
    required this.data,
    this.title = 'Document',
    this.titleAr = 'المستند',
    this.showStatus = true,
    this.showInternalId = false,
    super.directionality,
    super.direction,
    super.padding,
  });

  final ErpDocumentIdentity? data;
  final String title;
  final String titleAr;
  final bool showStatus;
  final bool showInternalId;

  @override
  bool get isVisible => data != null;

  @override
  Rect? draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    final identity = data;
    if (identity == null) return null;

    final context = effectiveDirectionality;
    final items = <GeniusPdfLabeledValue>[
      _field(
        config: config,
        directionality: context,
        label: 'Number',
        labelAr: 'الرقم',
        value: config.formatter.formatIdentifier(identity.number),
        valueKind: GeniusPdfValueKind.documentNumber,
      ),
      _field(
        config: config,
        directionality: context,
        label: 'Issue Date',
        labelAr: 'تاريخ الإصدار',
        value: config.formatter.formatDate(identity.issueDate),
        valueKind: GeniusPdfValueKind.date,
      ),
    ];

    if (showStatus) {
      items.add(
        _field(
          config: config,
          directionality: context,
          label: 'Status',
          labelAr: 'الحالة',
          value: identity.status.name,
          valueKind: GeniusPdfValueKind.customIdentifier,
        ),
      );
    }

    if (identity.series != null && identity.series!.isNotEmpty) {
      items.add(
        _field(
          config: config,
          directionality: context,
          label: 'Series',
          labelAr: 'السلسلة',
          value: identity.series!,
          valueKind: GeniusPdfValueKind.customIdentifier,
        ),
      );
    }

    if (identity.externalId != null && identity.externalId!.isNotEmpty) {
      items.add(
        _field(
          config: config,
          directionality: context,
          label: 'External ID',
          labelAr: 'المعرف الخارجي',
          value: identity.externalId!,
          valueKind: GeniusPdfValueKind.customIdentifier,
        ),
      );
    }

    if (showInternalId && identity.id != null && identity.id!.isNotEmpty) {
      items.add(
        _field(
          config: config,
          directionality: context,
          label: 'Internal ID',
          labelAr: 'المعرف الداخلي',
          value: identity.id!,
          valueKind: GeniusPdfValueKind.customIdentifier,
        ),
      );
    }

    final box = GeniusPdfInfoBox(
      config: config,
      title: title,
      titleAr: titleAr,
      items: items,
      directionality: context,
    );

    return box.draw(
      page: page,
      bounds: contentBounds(bounds),
    );
  }
}

/// S07-T02 — reusable party/counterparty block.
class GeniusPdfPartyBlock extends GeniusPdfErpComponent {
  const GeniusPdfPartyBlock({
    required super.config,
    required this.party,
    this.title = 'Party',
    this.titleAr = 'الطرف',
    this.showTaxIdentity = true,
    this.showPrimaryContact = true,
    this.emptyPolicy = GeniusPdfEmptySectionPolicy.hide,
    this.emptyText = 'No party data',
    this.emptyTextAr = 'لا توجد بيانات للطرف',
    super.directionality,
    super.direction,
    super.padding,
  });

  final ErpParty? party;
  final String title;
  final String titleAr;
  final bool showTaxIdentity;
  final bool showPrimaryContact;
  final GeniusPdfEmptySectionPolicy emptyPolicy;
  final String emptyText;
  final String emptyTextAr;

  @override
  bool get isVisible =>
      party != null || emptyPolicy == GeniusPdfEmptySectionPolicy.emptyState;

  @override
  Rect? draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    if (!isVisible) return null;
    final context = effectiveDirectionality;

    final source = party;
    final items = <GeniusPdfLabeledValue>[];

    if (source == null) {
      items.add(
        _emptyField(
          config: config,
          directionality: context,
          text: emptyText,
          textAr: emptyTextAr,
        ),
      );
    } else {
      items.add(
        _field(
          config: config,
          directionality: context,
          label: 'Name',
          labelAr: 'الاسم',
          value: source.displayName(isRtl: resolvedDirection.isRtl),
        ),
      );

      if (source.registrationNumber != null &&
          source.registrationNumber!.isNotEmpty) {
        items.add(
          _field(
            config: config,
            directionality: context,
            label: 'Registration',
            labelAr: 'رقم التسجيل',
            value: source.registrationNumber!,
            valueKind: GeniusPdfValueKind.customIdentifier,
          ),
        );
      }

      if (showTaxIdentity && source.taxIdentity != null) {
        items.add(
          _field(
            config: config,
            directionality: context,
            label: source.taxIdentity!.scheme,
            labelAr: 'الرقم الضريبي',
            value: source.taxIdentity!.taxNumber,
            valueKind: GeniusPdfValueKind.taxId,
          ),
        );
      }

      if (showPrimaryContact && source.contacts.isNotEmpty) {
        final contact = source.contacts.first;
        if (contact.contactName != null && contact.contactName!.isNotEmpty) {
          items.add(
            _field(
              config: config,
              directionality: context,
              label: 'Contact',
              labelAr: 'جهة الاتصال',
              value: contact.contactName!,
            ),
          );
        }
        if (contact.phone != null && contact.phone!.isNotEmpty) {
          items.add(
            _field(
              config: config,
              directionality: context,
              label: 'Phone',
              labelAr: 'الهاتف',
              value: contact.phone!,
              valueKind: GeniusPdfValueKind.phone,
            ),
          );
        }
        if (contact.email != null && contact.email!.isNotEmpty) {
          items.add(
            _field(
              config: config,
              directionality: context,
              label: 'Email',
              labelAr: 'البريد الإلكتروني',
              value: contact.email!,
              valueKind: GeniusPdfValueKind.email,
            ),
          );
        }
      }
    }

    final box = GeniusPdfInfoBox(
      config: config,
      title: title,
      titleAr: titleAr,
      items: items,
      directionality: context,
    );
    return box.draw(page: page, bounds: contentBounds(bounds));
  }
}

/// S07-T03 — reusable address block with explicit address roles.
class GeniusPdfAddressBlock extends GeniusPdfErpComponent {
  const GeniusPdfAddressBlock({
    required super.config,
    required this.address,
    this.title = 'Address',
    this.titleAr = 'العنوان',
    this.showRole = true,
    this.emptyPolicy = GeniusPdfEmptySectionPolicy.hide,
    this.emptyText = 'No address',
    this.emptyTextAr = 'لا يوجد عنوان',
    super.directionality,
    super.direction,
    super.padding,
  });

  final ErpAddress? address;
  final String title;
  final String titleAr;
  final bool showRole;
  final GeniusPdfEmptySectionPolicy emptyPolicy;
  final String emptyText;
  final String emptyTextAr;

  @override
  bool get isVisible {
    final value = address;
    if (value == null || value.isEmpty) {
      return emptyPolicy == GeniusPdfEmptySectionPolicy.emptyState;
    }
    return true;
  }

  @override
  Rect? draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    if (!isVisible) return null;

    final context = effectiveDirectionality;
    final source = address;
    final items = <GeniusPdfLabeledValue>[];

    if (source == null || source.isEmpty) {
      items.add(
        _emptyField(
          config: config,
          directionality: context,
          text: emptyText,
          textAr: emptyTextAr,
        ),
      );
    } else {
      if (showRole) {
        items.add(
          _field(
            config: config,
            directionality: context,
            label: 'Role',
            labelAr: 'النوع',
            value: source.role.name,
            valueKind: GeniusPdfValueKind.customIdentifier,
          ),
        );
      }

      void addText(String label, String labelAr, String? value) {
        if (value == null || value.trim().isEmpty) return;
        items.add(
          _field(
            config: config,
            directionality: context,
            label: label,
            labelAr: labelAr,
            value: value,
          ),
        );
      }

      addText('Address', 'العنوان', source.line1);
      addText('Address 2', 'العنوان ٢', source.line2);
      addText('City', 'المدينة', source.city);
      addText('State', 'المنطقة', source.state);
      addText('Country', 'الدولة', source.countryCode);
      addText('Attention', 'عناية', source.attentionTo);

      if (source.postalCode != null && source.postalCode!.isNotEmpty) {
        items.add(
          _field(
            config: config,
            directionality: context,
            label: 'Postal Code',
            labelAr: 'الرمز البريدي',
            value: source.postalCode!,
            valueKind: GeniusPdfValueKind.customIdentifier,
          ),
        );
      }
    }

    return GeniusPdfInfoBox(
      config: config,
      title: title,
      titleAr: titleAr,
      items: items,
      directionality: context,
    ).draw(
      page: page,
      bounds: contentBounds(bounds),
    );
  }
}

/// S07-T04 — document reference list.
class GeniusPdfReferenceBlock extends GeniusPdfErpComponent {
  const GeniusPdfReferenceBlock({
    required super.config,
    this.references,
    this.title = 'References',
    this.titleAr = 'المراجع',
    this.emptyPolicy = GeniusPdfEmptySectionPolicy.hide,
    this.emptyText = 'No references',
    this.emptyTextAr = 'لا توجد مراجع',
    super.directionality,
    super.direction,
    super.padding,
  });

  final List<ErpDocumentReference>? references;
  final String title;
  final String titleAr;
  final GeniusPdfEmptySectionPolicy emptyPolicy;
  final String emptyText;
  final String emptyTextAr;

  bool get _hasItems => references != null && references!.isNotEmpty;

  @override
  bool get isVisible =>
      _hasItems || emptyPolicy == GeniusPdfEmptySectionPolicy.emptyState;

  @override
  Rect? draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    if (!isVisible) return null;
    final context = effectiveDirectionality;
    final items = <GeniusPdfLabeledValue>[];

    if (!_hasItems) {
      items.add(
        _emptyField(
          config: config,
          directionality: context,
          text: emptyText,
          textAr: emptyTextAr,
        ),
      );
    } else {
      for (var i = 0; i < references!.length; i++) {
        final reference = references![i];
        items.add(
          _field(
            config: config,
            directionality: context,
            label: reference.type.isEmpty
                ? 'Reference ${i + 1}'
                : reference.type,
            labelAr: 'مرجع ${i + 1}',
            value: config.formatter.formatIdentifier(reference.number),
            valueKind: GeniusPdfValueKind.documentNumber,
          ),
        );
        if (reference.date != null) {
          items.add(
            _field(
              config: config,
              directionality: context,
              label: 'Reference Date',
              labelAr: 'تاريخ المرجع',
              value: config.formatter.formatDate(reference.date),
              valueKind: GeniusPdfValueKind.date,
            ),
          );
        }
      }
    }

    return GeniusPdfInfoBox(
      config: config,
      title: title,
      titleAr: titleAr,
      items: items,
      directionality: context,
    ).draw(page: page, bounds: contentBounds(bounds));
  }
}

/// S07-T05 — semantic money run.
///
/// Currency formatting comes only from the S05 shared formatter. The value run
/// is always resolved as a money value, independently from surrounding RTL.
class GeniusPdfMoney extends GeniusPdfErpComponent {
  const GeniusPdfMoney({
    required super.config,
    required this.amount,
    this.label,
    this.labelAr,
    this.alignment = GeniusPdfLogicalAlignment.start,
    this.bold = false,
    super.directionality,
    super.direction,
    super.padding,
  });

  final ErpMoney? amount;
  final String? label;
  final String? labelAr;
  final GeniusPdfLogicalAlignment alignment;
  final bool bold;

  @override
  bool get isVisible => amount != null;

  @override
  Rect? draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    final value = amount;
    if (value == null) return null;
    final context = effectiveDirectionality;
    final isRtl = resolvedDirection.isRtl;
    final resolvedLabel =
        isRtl && labelAr != null ? labelAr! : (label ?? '');

    final spans = <GeniusPdfTextSpan>[
      if (resolvedLabel.isNotEmpty)
        GeniusPdfTextSpan(
          text: '$resolvedLabel: ',
          isBold: bold,
        ),
      GeniusPdfTextSpan(
        text: config.formatter.formatMoney(
          value.toDouble(),
          currencyCode: value.currency.code,
          decimalPlaces: value.currency.precision,
        ),
        isBold: bold,
        direction: _explicitDirection(
          context,
          GeniusPdfValueKind.money,
        ),
      ),
    ];

    return _drawRichText(
      config: config,
      directionality: context,
      spans: spans,
      page: page,
      bounds: contentBounds(bounds),
      alignment: alignment,
    );
  }
}

/// S07-T06 — amount-in-words section.
///
/// Words must be supplied explicitly through [text]/[textAr] or [resolver].
/// This keeps legal/localization rules outside the layout component.
class GeniusPdfAmountInWords extends GeniusPdfErpComponent {
  const GeniusPdfAmountInWords({
    required super.config,
    this.amount,
    this.text,
    this.textAr,
    this.resolver,
    this.title = 'Amount in Words',
    this.titleAr = 'المبلغ كتابة',
    super.directionality,
    super.direction,
    super.padding,
  });

  final ErpMoney? amount;
  final String? text;
  final String? textAr;
  final GeniusPdfAmountInWordsResolver? resolver;
  final String title;
  final String titleAr;

  String? _resolvedWords() {
    final rtl = resolvedDirection.isRtl;
    if (rtl && textAr != null && textAr!.trim().isNotEmpty) return textAr;
    if (!rtl && text != null && text!.trim().isNotEmpty) return text;
    if (resolver != null && amount != null) {
      final value = resolver!(amount!, rtl);
      return value.trim().isEmpty ? null : value;
    }
    if (text != null && text!.trim().isNotEmpty) return text;
    if (textAr != null && textAr!.trim().isNotEmpty) return textAr;
    return null;
  }

  @override
  bool get isVisible => _resolvedWords() != null;

  @override
  Rect? draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    final words = _resolvedWords();
    if (words == null) return null;
    final context = effectiveDirectionality;

    return GeniusPdfInfoBox(
      config: config,
      title: title,
      titleAr: titleAr,
      items: [
        _field(
          config: config,
          directionality: context,
          label: '',
          value: words,
          separator: '',
        ),
      ],
      directionality: context,
    ).draw(page: page, bounds: contentBounds(bounds));
  }
}

/// S07-T07 — tax summary based on the typed S06 calculation result.
class GeniusPdfTaxSummary extends GeniusPdfErpComponent {
  const GeniusPdfTaxSummary({
    required super.config,
    required this.result,
    this.title = 'Tax Summary',
    this.titleAr = 'ملخص الضرائب',
    this.showZeroTaxes = false,
    this.emptyPolicy = GeniusPdfEmptySectionPolicy.hide,
    this.emptyText = 'No taxes',
    this.emptyTextAr = 'لا توجد ضرائب',
    super.directionality,
    super.direction,
    super.padding,
  });

  final ErpCalculationResult? result;
  final String title;
  final String titleAr;
  final bool showZeroTaxes;
  final GeniusPdfEmptySectionPolicy emptyPolicy;
  final String emptyText;
  final String emptyTextAr;

  List<ErpTaxTotal> get _taxes {
    final value = result;
    if (value == null) return const [];
    return value.taxTotals
        .where((tax) => showZeroTaxes || !tax.taxAmount.isZero)
        .toList(growable: false);
  }

  @override
  bool get isVisible =>
      _taxes.isNotEmpty ||
      emptyPolicy == GeniusPdfEmptySectionPolicy.emptyState;

  @override
  Rect? draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    if (!isVisible) return null;
    final context = effectiveDirectionality;
    final taxes = _taxes;
    final items = <GeniusPdfLabeledValue>[];

    if (taxes.isEmpty) {
      items.add(
        _emptyField(
          config: config,
          directionality: context,
          text: emptyText,
          textAr: emptyTextAr,
        ),
      );
    } else {
      for (final tax in taxes) {
        items.add(
          _field(
            config: config,
            directionality: context,
            label: '${tax.code} ${tax.ratePercent}%',
            labelAr: '${tax.code} ${tax.ratePercent}%',
            value: config.formatter.formatMoney(
              tax.taxAmount.toDouble(),
              currencyCode: tax.taxAmount.currency.code,
              decimalPlaces: tax.taxAmount.currency.precision,
            ),
            valueKind: GeniusPdfValueKind.money,
          ),
        );
      }
    }

    return GeniusPdfInfoBox(
      config: config,
      title: title,
      titleAr: titleAr,
      items: items,
      directionality: context,
    ).draw(page: page, bounds: contentBounds(bounds));
  }
}

/// S07-T08 — consolidated discount/charge summary.
class GeniusPdfAdjustmentSummary extends GeniusPdfErpComponent {
  const GeniusPdfAdjustmentSummary({
    required super.config,
    required this.result,
    this.title = 'Discounts & Charges',
    this.titleAr = 'الخصومات والرسوم',
    this.showZeroValues = false,
    this.emptyPolicy = GeniusPdfEmptySectionPolicy.hide,
    this.emptyText = 'No discounts or charges',
    this.emptyTextAr = 'لا توجد خصومات أو رسوم',
    super.directionality,
    super.direction,
    super.padding,
  });

  final ErpCalculationResult? result;
  final String title;
  final String titleAr;
  final bool showZeroValues;
  final GeniusPdfEmptySectionPolicy emptyPolicy;
  final String emptyText;
  final String emptyTextAr;

  bool get _hasValues {
    final value = result;
    if (value == null) return false;
    if (showZeroValues) return true;
    return !value.lineDiscountTotal.isZero ||
        !value.documentDiscountTotal.isZero ||
        !value.chargeTotal.isZero;
  }

  @override
  bool get isVisible =>
      _hasValues ||
      emptyPolicy == GeniusPdfEmptySectionPolicy.emptyState;

  @override
  Rect? draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    if (!isVisible) return null;
    final context = effectiveDirectionality;
    final value = result;
    final items = <GeniusPdfLabeledValue>[];

    if (value == null || !_hasValues) {
      items.add(
        _emptyField(
          config: config,
          directionality: context,
          text: emptyText,
          textAr: emptyTextAr,
        ),
      );
    } else {
      void addMoney(
        String label,
        String labelAr,
        ErpMoney money, {
        bool force = false,
      }) {
        if (!force && !showZeroValues && money.isZero) return;
        items.add(
          _field(
            config: config,
            directionality: context,
            label: label,
            labelAr: labelAr,
            value: config.formatter.formatMoney(
              money.toDouble(),
              currencyCode: money.currency.code,
              decimalPlaces: money.currency.precision,
            ),
            valueKind: GeniusPdfValueKind.money,
          ),
        );
      }

      addMoney(
        'Line Discounts',
        'خصومات السطور',
        value.lineDiscountTotal,
      );
      addMoney(
        'Document Discount',
        'خصم المستند',
        value.documentDiscountTotal,
      );
      addMoney(
        'Charges',
        'الرسوم',
        value.chargeTotal,
      );
    }

    return GeniusPdfInfoBox(
      config: config,
      title: title,
      titleAr: titleAr,
      items: items,
      directionality: context,
    ).draw(page: page, bounds: contentBounds(bounds));
  }
}

/// S07-T09 — grand/paid/due semantic block.
class GeniusPdfBalanceDueBlock extends GeniusPdfErpComponent {
  const GeniusPdfBalanceDueBlock({
    required super.config,
    required this.result,
    this.title = 'Balance',
    this.titleAr = 'الرصيد',
    this.showGrandTotal = true,
    super.directionality,
    super.direction,
    super.padding,
  });

  final ErpCalculationResult? result;
  final String title;
  final String titleAr;
  final bool showGrandTotal;

  @override
  bool get isVisible => result != null;

  @override
  Rect? draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    final value = result;
    if (value == null) return null;
    final context = effectiveDirectionality;
    final items = <GeniusPdfLabeledValue>[];

    String money(ErpMoney amount) => config.formatter.formatMoney(
          amount.toDouble(),
          currencyCode: amount.currency.code,
          decimalPlaces: amount.currency.precision,
        );

    if (showGrandTotal) {
      items.add(
        _field(
          config: config,
          directionality: context,
          label: 'Grand Total',
          labelAr: 'الإجمالي',
          value: money(value.grandTotal),
          valueKind: GeniusPdfValueKind.money,
        ),
      );
    }
    if (value.paidAmount != null) {
      items.add(
        _field(
          config: config,
          directionality: context,
          label: 'Paid',
          labelAr: 'المدفوع',
          value: money(value.paidAmount!),
          valueKind: GeniusPdfValueKind.money,
        ),
      );
    }
    if (value.dueAmount != null) {
      items.add(
        _field(
          config: config,
          directionality: context,
          label: 'Due',
          labelAr: 'المتبقي',
          value: money(value.dueAmount!),
          valueKind: GeniusPdfValueKind.money,
        ),
      );
    }

    if (value.baseGrandTotal != null &&
        value.baseGrandTotal!.currency != value.currency) {
      items.add(
        _field(
          config: config,
          directionality: context,
          label: 'Base Grand Total',
          labelAr: 'الإجمالي بالعملة الأساسية',
          value: money(value.baseGrandTotal!),
          valueKind: GeniusPdfValueKind.money,
        ),
      );
    }

    return GeniusPdfInfoBox(
      config: config,
      title: title,
      titleAr: titleAr,
      items: items,
      directionality: context,
    ).draw(page: page, bounds: contentBounds(bounds));
  }
}


/// S07-T10 — reusable terms/conditions section.
class GeniusPdfTermsSection extends GeniusPdfErpComponent {
  const GeniusPdfTermsSection({
    required super.config,
    this.text,
    this.textAr,
    this.title = 'Terms & Conditions',
    this.titleAr = 'الشروط والأحكام',
    super.directionality,
    super.direction,
    super.padding,
  });

  final String? text;
  final String? textAr;
  final String title;
  final String titleAr;

  String? _resolvedText() {
    final rtl = resolvedDirection.isRtl;
    if (rtl && textAr != null && textAr!.trim().isNotEmpty) return textAr;
    if (!rtl && text != null && text!.trim().isNotEmpty) return text;
    if (text != null && text!.trim().isNotEmpty) return text;
    if (textAr != null && textAr!.trim().isNotEmpty) return textAr;
    return null;
  }

  @override
  bool get isVisible => _resolvedText() != null;

  @override
  Rect? draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    final value = _resolvedText();
    if (value == null) return null;
    final context = effectiveDirectionality;

    return GeniusPdfInfoBox(
      config: config,
      title: title,
      titleAr: titleAr,
      items: [
        _field(
          config: config,
          directionality: context,
          label: '',
          value: value,
          separator: '',
          valueKind: GeniusPdfValueKind.plainText,
        ),
      ],
      directionality: context,
    ).draw(page: page, bounds: contentBounds(bounds));
  }
}

/// S07-T11 — approval history block.
class GeniusPdfApprovalTrail extends GeniusPdfErpComponent {
  const GeniusPdfApprovalTrail({
    required super.config,
    this.approvals,
    this.title = 'Approval Trail',
    this.titleAr = 'مسار الاعتماد',
    this.itemSpacing = 6,
    this.emptyPolicy = GeniusPdfEmptySectionPolicy.hide,
    this.emptyText = 'No approvals',
    this.emptyTextAr = 'لا توجد اعتمادات',
    super.directionality,
    super.direction,
    super.padding,
  }) : assert(itemSpacing >= 0);

  final List<ErpApproval>? approvals;
  final String title;
  final String titleAr;
  final double itemSpacing;
  final GeniusPdfEmptySectionPolicy emptyPolicy;
  final String emptyText;
  final String emptyTextAr;

  bool get _hasItems => approvals != null && approvals!.isNotEmpty;

  @override
  bool get isVisible =>
      _hasItems ||
      emptyPolicy == GeniusPdfEmptySectionPolicy.emptyState;

  @override
  Rect? draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    if (!isVisible) return null;

    final outer = contentBounds(bounds);
    final context = effectiveDirectionality;

    if (!_hasItems) {
      return GeniusPdfInfoBox(
        config: config,
        title: title,
        titleAr: titleAr,
        items: [
          _emptyField(
            config: config,
            directionality: context,
            text: emptyText,
            textAr: emptyTextAr,
          ),
        ],
        directionality: context,
      ).draw(page: page, bounds: outer);
    }

    var y = outer.top;
    Rect? total;

    for (var i = 0; i < approvals!.length; i++) {
      final approval = approvals![i];
      final items = <GeniusPdfLabeledValue>[
        _field(
          config: config,
          directionality: context,
          label: 'Stage',
          labelAr: 'المرحلة',
          value: approval.stage,
        ),
        _field(
          config: config,
          directionality: context,
          label: 'Status',
          labelAr: 'الحالة',
          value: approval.status.name,
          valueKind: GeniusPdfValueKind.customIdentifier,
        ),
      ];

      if (approval.approverName != null &&
          approval.approverName!.isNotEmpty) {
        items.add(
          _field(
            config: config,
            directionality: context,
            label: 'Approver',
            labelAr: 'المعتمد',
            value: approval.approverName!,
          ),
        );
      }

      if (approval.decidedAt != null) {
        items.add(
          _field(
            config: config,
            directionality: context,
            label: 'Date',
            labelAr: 'التاريخ',
            value: config.formatter.formatDateTime(approval.decidedAt),
            valueKind: GeniusPdfValueKind.dateTime,
          ),
        );
      }

      if (approval.comment != null && approval.comment!.isNotEmpty) {
        items.add(
          _field(
            config: config,
            directionality: context,
            label: 'Comment',
            labelAr: 'التعليق',
            value: approval.comment!,
          ),
        );
      }

      final top = y + (i == 0 ? 0 : itemSpacing);
      if (top >= outer.bottom) break;

      final result = GeniusPdfInfoBox(
        config: config,
        title: i == 0 ? title : approval.stage,
        titleAr: i == 0 ? titleAr : approval.stage,
        items: items,
        directionality: context,
      ).draw(
        page: page,
        bounds: Rect.fromLTWH(
          outer.left,
          top,
          outer.width,
          outer.bottom - top,
        ),
      );

      total = total == null
          ? result
          : Rect.fromLTRB(
              outer.left,
              total.top,
              outer.right,
              result.bottom,
            );
      y = result.bottom;
    }

    return total;
  }
}

/// S07-T12 — semantic status/stamp text.
///
/// This component intentionally does not mirror pixels or mutate text in RTL.
class GeniusPdfStamp extends GeniusPdfErpComponent {
  const GeniusPdfStamp({
    required super.config,
    required this.text,
    this.textAr,
    this.tone = GeniusPdfSemanticTone.info,
    this.alignment = GeniusPdfLogicalAlignment.center,
    super.directionality,
    super.direction,
    super.padding,
  });

  final String? text;
  final String? textAr;
  final GeniusPdfSemanticTone tone;
  final GeniusPdfLogicalAlignment alignment;

  String? _resolvedText() {
    final rtl = resolvedDirection.isRtl;
    if (rtl && textAr != null && textAr!.trim().isNotEmpty) return textAr;
    if (text != null && text!.trim().isNotEmpty) return text;
    if (textAr != null && textAr!.trim().isNotEmpty) return textAr;
    return null;
  }

  @override
  bool get isVisible => _resolvedText() != null;

  @override
  Rect? draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    final value = _resolvedText();
    if (value == null) return null;

    return _drawRichText(
      config: config,
      directionality: effectiveDirectionality,
      spans: [
        GeniusPdfTextSpan(
          text: value,
          isBold: true,
          backgroundColor: _toneColor(config, tone),
        ),
      ],
      page: page,
      bounds: contentBounds(bounds),
      alignment: alignment,
    );
  }
}

/// Data for one [GeniusPdfMetricCards] card.
class GeniusPdfMetricCardData {
  const GeniusPdfMetricCardData({
    required this.label,
    required this.value,
    this.labelAr,
    this.valueKind = GeniusPdfValueKind.plainText,
    this.tone = GeniusPdfSemanticTone.neutral,
  });

  final String label;
  final String? labelAr;
  final String value;
  final GeniusPdfValueKind valueKind;
  final GeniusPdfSemanticTone tone;
}

/// S07-T13 — compact metric card row.
///
/// The first definition is placed at logical start. RTL conversion occurs only
/// while mapping logical definitions to physical card slots.
class GeniusPdfMetricCards extends GeniusPdfErpComponent {
  const GeniusPdfMetricCards({
    required super.config,
    this.cards,
    this.columns = 3,
    this.gap = 8,
    this.emptyPolicy = GeniusPdfEmptySectionPolicy.hide,
    this.emptyText = 'No metrics',
    this.emptyTextAr = 'لا توجد مؤشرات',
    super.directionality,
    super.direction,
    super.padding,
  })  : assert(columns > 0),
        assert(gap >= 0);

  final List<GeniusPdfMetricCardData>? cards;
  final int columns;
  final double gap;
  final GeniusPdfEmptySectionPolicy emptyPolicy;
  final String emptyText;
  final String emptyTextAr;

  bool get _hasCards => cards != null && cards!.isNotEmpty;

  @override
  bool get isVisible =>
      _hasCards ||
      emptyPolicy == GeniusPdfEmptySectionPolicy.emptyState;

  @override
  Rect? draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    if (!isVisible) return null;
    final context = effectiveDirectionality;
    final outer = contentBounds(bounds);

    if (!_hasCards) {
      return GeniusPdfInfoBox(
        config: config,
        items: [
          _emptyField(
            config: config,
            directionality: context,
            text: emptyText,
            textAr: emptyTextAr,
          ),
        ],
        directionality: context,
      ).draw(page: page, bounds: outer);
    }

    final source = cards!;
    Rect? total;
    var rowTop = outer.top;

    for (var rowStart = 0;
        rowStart < source.length;
        rowStart += columns) {
      final remainingCards = source.length - rowStart;
      final rowCount =
          remainingCards < columns ? remainingCards : columns;
      final width =
          (outer.width - gap * (rowCount - 1)) / rowCount;
      var rowBottom = rowTop;

      if (rowTop >= outer.bottom) break;

      for (var physicalIndex = 0;
          physicalIndex < rowCount;
          physicalIndex++) {
        final definitionIndex =
            GeniusPdfComponentDirectionality.definitionIndex(
          index: physicalIndex,
          count: rowCount,
          direction: resolvedDirection,
          followDirection: true,
        );
        final card = source[rowStart + definitionIndex];
        final x = outer.left + physicalIndex * (width + gap);

        final result = GeniusPdfInfoBox(
          config: config,
          title: card.label,
          titleAr: card.labelAr,
          items: [
            _field(
              config: config,
              directionality: context,
              label: '',
              value: card.value,
              separator: '',
              valueKind: card.valueKind,
              valueColor: _toneColor(config, card.tone),
            ),
          ],
          directionality: context,
        ).draw(
          page: page,
          bounds: Rect.fromLTWH(
            x,
            rowTop,
            width,
            outer.bottom - rowTop,
          ),
        );

        if (result.bottom > rowBottom) {
          rowBottom = result.bottom;
        }

        total = total == null
            ? result
            : Rect.fromLTRB(
                outer.left,
                total.top < result.top ? total.top : result.top,
                outer.right,
                total.bottom > result.bottom
                    ? total.bottom
                    : result.bottom,
              );
      }

      rowTop = rowBottom + gap;
    }

    return total;
  }
}

/// S07-T14 — compact semantic label.
class GeniusPdfLabel extends GeniusPdfErpComponent {
  const GeniusPdfLabel({
    required super.config,
    required this.text,
    this.textAr,
    this.tone = GeniusPdfSemanticTone.neutral,
    this.valueKind = GeniusPdfValueKind.plainText,
    this.alignment = GeniusPdfLogicalAlignment.start,
    super.directionality,
    super.direction,
    super.padding,
  });

  final String? text;
  final String? textAr;
  final GeniusPdfSemanticTone tone;
  final GeniusPdfValueKind valueKind;
  final GeniusPdfLogicalAlignment alignment;

  String? _resolvedText() {
    final rtl = resolvedDirection.isRtl;
    if (rtl && textAr != null && textAr!.trim().isNotEmpty) return textAr;
    if (text != null && text!.trim().isNotEmpty) return text;
    if (textAr != null && textAr!.trim().isNotEmpty) return textAr;
    return null;
  }

  @override
  bool get isVisible => _resolvedText() != null;

  @override
  Rect? draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    final value = _resolvedText();
    if (value == null) return null;
    final context = effectiveDirectionality;

    return _drawRichText(
      config: config,
      directionality: context,
      spans: [
        GeniusPdfTextSpan(
          text: value,
          isBold: true,
          backgroundColor: _toneColor(config, tone),
          direction: _explicitDirection(context, valueKind),
        ),
      ],
      page: page,
      bounds: contentBounds(bounds),
      alignment: alignment,
    );
  }
}
