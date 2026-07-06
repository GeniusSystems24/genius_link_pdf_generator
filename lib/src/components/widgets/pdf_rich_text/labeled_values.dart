part of '../pdf_rich_text.dart';

class GeniusPdfLabeledValue {
  const GeniusPdfLabeledValue({
    required this.config,
    required this.label,
    required this.value,
    this.labelAr,
    this.labelStyle,
    this.valueStyle,
    this.valueColor,
    this.separator = ': ',
  });

  /// Creates a labeled value where the value is styled as positive (green).
  factory GeniusPdfLabeledValue.positive({
    required String label,
    required String value,
    String? labelAr,
    required GeniusPdfConfig config,
  }) {
    return GeniusPdfLabeledValue(
      config: config,
      label: label,
      value: value,
      labelAr: labelAr,
      valueColor: const Color(0xFF2E7D32),
    );
  }

  /// Creates a labeled value where the value is styled as negative (red).
  factory GeniusPdfLabeledValue.negative({
    required String label,
    required String value,
    String? labelAr,
    required GeniusPdfConfig config,
    required PdfFont baseFont,
    required PdfFont boldFont,
  }) {
    return GeniusPdfLabeledValue(
      config: config,
      label: label,
      value: value,
      labelAr: labelAr,
      valueColor: const Color(0xFFC62828),
    );
  }

  final GeniusPdfConfig config;
  final String label;
  final String? labelAr;
  final String value;
  final GeniusPdfTextStyle? labelStyle;
  final GeniusPdfTextStyle? valueStyle;
  final Color? valueColor;
  final String separator;

  /// Gets the display label based on locale.
  String getLabel() {
    if (config.isRTL && labelAr != null) return labelAr!;
    return label;
  }

  /// Draws the labeled value.
  PdfLayoutResult? draw({
    required PdfPage page,
    required Rect bounds,
    PdfLayoutFormat? layoutFormat,
  }) {
    final labelText = getLabel();
    final effectiveLabelStyle = labelStyle ??
        GeniusPdfTextStyle(
          fontSize: config.baseFont.size,
          fontWeight: FontWeight.bold,
          alignment: GeniusPdfTextAlign.start,
        );
    final effectiveValueStyle = valueStyle ??
        GeniusPdfTextStyle(
          fontSize: config.baseFont.size,
          alignment: GeniusPdfTextAlign.start,
        );

    final valueSpan = valueColor != null
        ? GeniusPdfTextSpan(
            text: value,
            style: effectiveValueStyle,
            color: valueColor,
            isBold: effectiveValueStyle.isBold,
          )
        : GeniusPdfTextSpan(
            text: value,
            style: effectiveValueStyle,
            isBold: effectiveValueStyle.isBold,
          );

    final richText = GeniusPdfRichText(
      spans: [
        GeniusPdfTextSpan(
          text: labelText,
          style: effectiveLabelStyle,
          isBold: effectiveLabelStyle.isBold,
        ),
        GeniusPdfTextSpan(
          text: separator,
          style: effectiveLabelStyle.copyWith(
            fontWeight: FontWeight.normal,
          ),
        ),
        valueSpan,
      ],
      config: config,
      defaultStyle: effectiveValueStyle,
      baseFont: config.baseFont,
      boldFont: config.boldFont,
      isRTL: config.isRTL,
    );

    return richText.draw(
        page: page, bounds: bounds, layoutFormat: layoutFormat);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Key-Value List
// ─────────────────────────────────────────────────────────────────────────────

/// A key-value list component for displaying multiple labeled values.
class GeniusPdfKeyValueList {
  const GeniusPdfKeyValueList({
    required this.items,
    required this.config,
    this.itemSpacing = 4,
    this.baseFont,
    this.boldFont,
    this.isRTL = true,
    this.columns = 1,
    this.columnSpacing = 20,
  });

  final List<GeniusPdfLabeledValue> items;
  final GeniusPdfConfig config;
  final double itemSpacing;
  final PdfFont? baseFont;
  final PdfFont? boldFont;
  final bool isRTL;
  final int columns;
  final double columnSpacing;

  /// Draws the key-value list.
  PdfLayoutResult? draw({
    required PdfPage page,
    required Rect bounds,
    PdfLayoutFormat? layoutFormat,
  }) {
    if (items.isEmpty) return null;

    double currentY = bounds.top;
    PdfLayoutResult? lastResult;

    if (columns == 1) {
      // Single column layout
      for (final item in items) {
        final labeledValue = GeniusPdfLabeledValue(
          config: config,
          label: item.label,
          labelAr: item.labelAr,
          value: item.value,
          labelStyle: item.labelStyle,
          valueStyle: item.valueStyle,
          valueColor: item.valueColor,
          separator: item.separator,
        );

        lastResult = labeledValue.draw(
          page: page,
          bounds: Rect.fromLTWH(
            bounds.left,
            currentY,
            bounds.width,
            bounds.height - (currentY - bounds.top),
          ),
          layoutFormat: layoutFormat,
        );

        if (lastResult != null) {
          currentY = lastResult.bounds.bottom + itemSpacing;
        }
      }
    } else {
      // Multi-column layout
      final columnWidth =
          (bounds.width - (columnSpacing * (columns - 1))) / columns;
      final itemsPerColumn = (items.length / columns).ceil();

      for (int col = 0; col < columns; col++) {
        final startIndex = col * itemsPerColumn;
        final endIndex =
            (startIndex + itemsPerColumn).clamp(0, items.length).toInt();
        if (startIndex >= items.length) break;
        final columnItems = items.sublist(startIndex, endIndex);

        double colY = bounds.top;
        final colX = bounds.left + (col * (columnWidth + columnSpacing));

        for (final item in columnItems) {
          final labeledValue = GeniusPdfLabeledValue(
            config: config,
            label: item.label,
            labelAr: item.labelAr,
            value: item.value,
            valueColor: item.valueColor,
          );

          lastResult = labeledValue.draw(
            page: page,
            bounds: Rect.fromLTWH(
              colX,
              colY,
              columnWidth,
              bounds.height - (colY - bounds.top),
            ),
            layoutFormat: layoutFormat,
          );

          if (lastResult != null) {
            colY = lastResult.bounds.bottom + itemSpacing;
            if (colY > currentY) currentY = colY;
          }
        }
      }
    }

    return lastResult;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bullet List
// ─────────────────────────────────────────────────────────────────────────────

/// Bullet/number style for [GeniusPdfBulletList].
