part of '../pdf_info_box.dart';

class GeniusPdfInfoBox {
  GeniusPdfInfoBox({
    required this.config,
    this.title,
    this.titleAr,
    this.subtitle,
    this.subtitleAr,
    this.items = const [],
    GeniusPdfInfoBoxStyle? style,
    this.icon,
    this.footer,
    this.footerAr,
    this.footerStyle,
    this.showEmptyItems = false,
    this.emptyItemPlaceholder = '-',
    this.columns = 1,
    this.columnSpacing = 16,
    this.tag,
    this.directionality,
    this.direction = GeniusPdfDirection.auto,
    this.iconPosition = GeniusPdfLogicalPosition.leading,
    this.followDirection = true,
  }) : style = _resolveInfoBoxStyle(style, config);

  /// Creates an info box from a map of key-value pairs.
  factory GeniusPdfInfoBox.fromMap({
    required Map<String, dynamic> data,
    Map<String, String>? labelTranslations,
    String? title,
    String? titleAr,
    required GeniusPdfConfig config,
    GeniusPdfInfoBoxStyle? style,
  }) {
    final items = <GeniusPdfLabeledValue>[];
    for (final entry in data.entries) {
      items.add(GeniusPdfLabeledValue(
        config: config,
        label: entry.key,
        labelAr: labelTranslations?[entry.key],
        value: entry.value?.toString() ?? '',
      ));
    }
    return GeniusPdfInfoBox(
      title: title,
      titleAr: titleAr,
      items: items,
      config: config,
      style: style,
    );
  }

  /// Creates an info box for displaying an address.
  factory GeniusPdfInfoBox.address({
    required String name,
    String? nameAr,
    String? line1,
    String? line2,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    String? phone,
    String? email,
    String title = 'Address',
    String titleAr = 'العنوان',
    required GeniusPdfConfig config,
    GeniusPdfInfoBoxStyle? style,
  }) {
    final items = <GeniusPdfLabeledValue>[];

    items.add(GeniusPdfLabeledValue(
      config: config,
      label: 'Name',
      labelAr: 'الاسم',
      value: name,
    ));

    if (line1 != null && line1.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        config: config,
        label: 'Address',
        labelAr: 'العنوان',
        value: line1,
      ));
    }

    if (line2 != null && line2.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        config: config,
        label: '',
        value: line2,
      ));
    }

    final cityLine = [city, state, postalCode]
        .where((s) => s != null && s.isNotEmpty)
        .join(', ');
    if (cityLine.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        config: config,
        label: 'City',
        labelAr: 'المدينة',
        value: cityLine,
      ));
    }

    if (country != null && country.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        config: config,
        label: 'Country',
        labelAr: 'الدولة',
        value: country,
      ));
    }

    if (phone != null && phone.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        config: config,
        label: 'Phone',
        labelAr: 'الهاتف',
        value: phone,
      ));
    }

    if (email != null && email.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        config: config,
        label: 'Email',
        labelAr: 'البريد',
        value: email,
      ));
    }

    return GeniusPdfInfoBox(
      title: title,
      titleAr: titleAr,
      items: items,
      config: config,
      style: style ?? const GeniusPdfInfoBoxStyle.card(),
    );
  }

  /// Creates a company info box with common fields.
  factory GeniusPdfInfoBox.company({
    required String companyName,
    String? companyNameAr,
    String? taxNumber,
    String? commercialReg,
    String? phone,
    String? email,
    String? website,
    String? address,
    String title = 'Company Information',
    String titleAr = 'معلومات الشركة',
    required GeniusPdfConfig config,
    GeniusPdfInfoBoxStyle? style,
  }) {
    final items = <GeniusPdfLabeledValue>[];

    items.add(GeniusPdfLabeledValue(
      config: config,
      label: 'Company',
      labelAr: 'الشركة',
      value: companyName,
    ));

    if (taxNumber != null && taxNumber.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        config: config,
        label: 'Tax Number',
        labelAr: 'الرقم الضريبي',
        value: taxNumber,
      ));
    }

    if (commercialReg != null && commercialReg.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        config: config,
        label: 'Commercial Reg.',
        labelAr: 'السجل التجاري',
        value: commercialReg,
      ));
    }

    if (phone != null && phone.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        config: config,
        label: 'Phone',
        labelAr: 'الهاتف',
        value: phone,
      ));
    }

    if (email != null && email.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        config: config,
        label: 'Email',
        labelAr: 'البريد',
        value: email,
      ));
    }

    if (website != null && website.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        config: config,
        label: 'Website',
        labelAr: 'الموقع',
        value: website,
      ));
    }

    if (address != null && address.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        config: config,
        label: 'Address',
        labelAr: 'العنوان',
        value: address,
      ));
    }

    return GeniusPdfInfoBox(
      title: title,
      titleAr: titleAr,
      items: items,
      config: config,
      style: style ?? GeniusPdfInfoBoxStyle.corporate(),
    );
  }

  /// Creates a contact info box.
  factory GeniusPdfInfoBox.contact({
    required String name,
    String? nameAr,
    String? phone,
    String? mobile,
    String? email,
    String? department,
    String? position,
    String title = 'Contact',
    String titleAr = 'جهة الاتصال',
    required GeniusPdfConfig config,
    GeniusPdfInfoBoxStyle? style,
  }) {
    final items = <GeniusPdfLabeledValue>[];

    items.add(GeniusPdfLabeledValue(
      config: config,
      label: 'Name',
      labelAr: 'الاسم',
      value: name,
    ));

    if (position != null && position.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        config: config,
        label: 'Position',
        labelAr: 'المنصب',
        value: position,
      ));
    }

    if (department != null && department.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        config: config,
        label: 'Department',
        labelAr: 'القسم',
        value: department,
      ));
    }

    if (phone != null && phone.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        config: config,
        label: 'Phone',
        labelAr: 'الهاتف',
        value: phone,
      ));
    }

    if (mobile != null && mobile.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        config: config,
        label: 'Mobile',
        labelAr: 'الجوال',
        value: mobile,
      ));
    }

    if (email != null && email.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        config: config,
        label: 'Email',
        labelAr: 'البريد',
        value: email,
      ));
    }

    return GeniusPdfInfoBox(
      title: title,
      titleAr: titleAr,
      items: items,
      config: config,
      style: style ?? const GeniusPdfInfoBoxStyle.card(),
    );
  }

  /// Box title (English or default).
  final String? title;

  /// Arabic title (optional).
  final String? titleAr;

  /// Subtitle displayed below title.
  final String? subtitle;

  /// Arabic subtitle.
  final String? subtitleAr;

  /// Key-value items to display.
  final List<GeniusPdfLabeledValue> items;

  /// Box style configuration.
  final GeniusPdfInfoBoxStyle style;

  /// PDF configuration.
  final GeniusPdfConfig config;

  /// Optional icon to display in header.
  final GeniusPdfImage? icon;

  /// Footer text (English).
  final String? footer;

  /// Footer text (Arabic).
  final String? footerAr;

  /// Custom footer style.
  final GeniusPdfTextStyle? footerStyle;

  /// Whether to show items with empty values.
  final bool showEmptyItems;

  /// Placeholder for empty item values.
  final String emptyItemPlaceholder;

  /// Number of columns for items layout.
  final int columns;

  /// Spacing between columns.
  final double columnSpacing;

  /// Custom tag for identification.
  final String? tag;

  final GeniusPdfDirectionality? directionality;
  final GeniusPdfDirection direction;
  /// Logical leading/trailing header icon placement.
  final GeniusPdfLogicalPosition iconPosition;
  /// Mirrors multi-column order when true.
  final bool followDirection;

  GeniusPdfDirectionality get _effectiveDirectionality =>
      GeniusPdfComponentDirectionality.context(
        config: config,
        inherited: directionality,
        componentDirection: direction,
      );

  bool get isRTL => _effectiveDirectionality.resolve().direction == GeniusPdfResolvedDirection.rtl;

  /// Gets the display title based on locale.
  String? getTitle() {
    if (isRTL && titleAr != null) return titleAr;
    return title;
  }

  /// Gets the subtitle based on locale.
  String? getSubtitle() {
    if (isRTL && subtitleAr != null) return subtitleAr;
    return subtitle;
  }

  /// Gets the footer text based on locale.
  String? getFooter() {
    if (isRTL && footerAr != null) return footerAr;
    return footer;
  }

  /// Gets items filtered by visibility.
  List<GeniusPdfLabeledValue> get visibleItems {
    if (showEmptyItems) return items;
    return items.where((item) => item.value.isNotEmpty).toList();
  }

  /// Creates a copy of this info box with optional overrides.
  GeniusPdfInfoBox copyWith({
    String? title,
    String? titleAr,
    String? subtitle,
    String? subtitleAr,
    List<GeniusPdfLabeledValue>? items,
    GeniusPdfInfoBoxStyle? style,
    PdfFont? baseFont,
    PdfFont? boldFont,
    bool? isRTL,
    GeniusPdfImage? icon,
    String? footer,
    String? footerAr,
    GeniusPdfTextStyle? footerStyle,
    bool? showEmptyItems,
    String? emptyItemPlaceholder,
    int? columns,
    double? columnSpacing,
    String? tag,
    GeniusPdfDirectionality? directionality,
    GeniusPdfDirection? direction,
    GeniusPdfLogicalPosition? iconPosition,
    bool? followDirection,
  }) {
    return GeniusPdfInfoBox(
      config: config,
      title: title ?? this.title,
      titleAr: titleAr ?? this.titleAr,
      subtitle: subtitle ?? this.subtitle,
      subtitleAr: subtitleAr ?? this.subtitleAr,
      items: items ?? this.items,
      style: style ?? this.style,
      icon: icon ?? this.icon,
      footer: footer ?? this.footer,
      footerAr: footerAr ?? this.footerAr,
      footerStyle: footerStyle ?? this.footerStyle,
      showEmptyItems: showEmptyItems ?? this.showEmptyItems,
      emptyItemPlaceholder: emptyItemPlaceholder ?? this.emptyItemPlaceholder,
      columns: columns ?? this.columns,
      columnSpacing: columnSpacing ?? this.columnSpacing,
      tag: tag ?? this.tag,
      directionality: directionality ?? this.directionality,
      direction: direction ?? this.direction,
      iconPosition: iconPosition ?? this.iconPosition,
      followDirection: followDirection ?? this.followDirection,
    );
  }

  PdfFont get baseFont => config.baseFont;
  PdfFont get boldFont => config.boldFont;

  /// Estimates the rendered height of the info box.
  ///
  /// This is used by the document builder and dual-box layouts to keep the
  /// whole box inside the content area when the remaining space is tight.
  double estimateHeight([double? availableWidth]) {
    var boxHeight =
        _calculateHeight(availableWidth) + style.padding.top + style.padding.bottom;

    if (style.minHeight != null && boxHeight < style.minHeight!) {
      boxHeight = style.minHeight!;
    }
    if (style.maxHeight != null && boxHeight > style.maxHeight!) {
      boxHeight = style.maxHeight!;
    }

    return boxHeight;
  }

  /// Draws the info box on a PDF page.
  ///
  /// Returns the actual bounds of the drawn content.
  Rect draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    GeniusPdfLogger.debug(
      'Drawing InfoBox: "${getTitle() ?? 'untitled'}" with ${visibleItems.length} items',
      tag: 'InfoBox',
    );
    final graphics = page.graphics;
    double currentY = bounds.top;

    // Calculate content height for background
    final boxHeight = estimateHeight(bounds.width);

    final boxBounds = Rect.fromLTWH(
      bounds.left,
      bounds.top,
      bounds.width,
      boxHeight,
    );

    // Draw shadow if enabled
    if (style.shadowEnabled && style.shadowColor != null) {
      graphics.drawRectangle(
        brush: PdfSolidBrush(style.shadowColor!.toPdfColor()),
        bounds: Rect.fromLTWH(
          boxBounds.left + style.shadowOffset,
          boxBounds.top + style.shadowOffset,
          boxBounds.width,
          boxBounds.height,
        ),
      );
    }

    // Draw background
    if (style.backgroundColor != null) {
      graphics.drawRectangle(
        brush: PdfSolidBrush(style.backgroundColor!.toPdfColor()),
        bounds: boxBounds,
      );
    }

    // Draw border
    _drawBorder(graphics, boxBounds, style.borderStyle);

    // Draw title and header
    final displayTitle = getTitle();
    if (displayTitle != null && displayTitle.isNotEmpty) {
      final headerPadding = style.headerPadding ?? style.padding;
      final headerHeight = _getHeaderHeight();

      // Draw header background if specified
      if (style.headerBackgroundColor != null) {
        graphics.drawRectangle(
          brush: PdfSolidBrush(style.headerBackgroundColor!.toPdfColor()),
          bounds: Rect.fromLTWH(
            bounds.left,
            currentY,
            bounds.width,
            headerHeight,
          ),
        );
      }

      currentY += headerPadding.top;
      var titleLeft = bounds.left + headerPadding.left;
      var titleWidth = bounds.width - headerPadding.left - headerPadding.right;

      // Draw icon if present
      if (icon != null) {
        final iconY = currentY + (_getTitleHeight() - style.iconSize) / 2;
        final iconOnRight =
            (iconPosition == GeniusPdfLogicalPosition.leading && isRTL) ||
            (iconPosition == GeniusPdfLogicalPosition.trailing && !isRTL);
        final iconX = iconOnRight
            ? (titleLeft + titleWidth - style.iconSize)
            : titleLeft;

        graphics.drawImage(
          PdfBitmap(icon!.data),
          Rect.fromLTWH(iconX, iconY, style.iconSize, style.iconSize),
        );

        if (iconOnRight) {
          titleWidth -= style.iconSize + style.iconSpacing;
        } else {
          titleLeft += style.iconSize + style.iconSpacing;
          titleWidth -= style.iconSize + style.iconSpacing;
        }
      }

      final titleFormat = PdfStringFormat(
        alignment: style.titleStyle.alignment.toPdfTextAlignment(isRTL),
        textDirection: GeniusPdfComponentDirectionality.pdfDirection(_effectiveDirectionality.resolve().direction)
      );

      graphics.drawString(
        displayTitle,
        boldFont,
        brush: style.titleStyle.toBrush(),
        bounds: Rect.fromLTWH(
          titleLeft,
          currentY,
          titleWidth,
          0,
        ),
        format: titleFormat,
      );

      currentY += _getTitleHeight();

      // Draw subtitle
      final displaySubtitle = getSubtitle();
      if (displaySubtitle != null && displaySubtitle.isNotEmpty) {
        currentY += 2;
        final subtitleColor = style.titleStyle.color.withValues(alpha: 0.7);
        graphics.drawString(
          displaySubtitle,
          baseFont,
          brush: PdfSolidBrush(subtitleColor.toPdfColor()),
          bounds: Rect.fromLTWH(titleLeft, currentY, titleWidth, 0),
          format: titleFormat,
        );
        currentY += style.titleStyle.fontSize * 0.9;
      }

      currentY += headerPadding.bottom;

      // Draw divider
      if (style.showDivider) {
        currentY += style.dividerMargin;
        graphics.drawLine(
          PdfPen(style.dividerColor.toPdfColor(), width: style.dividerWidth),
          Offset(bounds.left, currentY),
          Offset(bounds.right, currentY),
        );
        currentY += style.dividerMargin;
      }
    } else {
      currentY += style.padding.top;
    }

    final contentLeft = bounds.left + style.padding.left;
    final contentWidth =
        bounds.width - style.padding.left - style.padding.right;

    // Draw items
    final filteredItems = visibleItems;
    if (columns > 1) {
      // Multi-column layout
      final columnWidth =
          (contentWidth - (columns - 1) * columnSpacing) / columns;
      int itemIndex = 0;
      double rowY = currentY;
      double maxRowHeight = 0;

      while (itemIndex < filteredItems.length) {
        for (int col = 0;
            col < columns && itemIndex < filteredItems.length;
            col++) {
          final item = filteredItems[itemIndex];
          final physicalColumn = followDirection && isRTL ? columns - 1 - col : col;
          final itemLeft = contentLeft + physicalColumn * (columnWidth + columnSpacing);
          final drawnHeight = _drawItemValue(
            graphics,
            item,
            Rect.fromLTWH(itemLeft, rowY, columnWidth, 20),
          );
          final rowHeight = drawnHeight + style.itemSpacing;
          if (rowHeight > maxRowHeight) {
            maxRowHeight = rowHeight;
          }
          itemIndex++;
        }
        rowY += maxRowHeight;
        currentY = rowY;
      }
    } else {
      // Single column layout
      for (int i = 0; i < filteredItems.length; i++) {
        final item = filteredItems[i];
        final drawnHeight = _drawItemValue(
          graphics,
          item,
          Rect.fromLTWH(contentLeft, currentY, contentWidth, 20),
        );
        currentY += drawnHeight + style.itemSpacing;

        // Draw item separator
        if (style.showItemSeparators && i < filteredItems.length - 1) {
          final separatorColor = style.itemSeparatorColor ??
              style.dividerColor.withValues(alpha: 0.3);
          graphics.drawLine(
            PdfPen(separatorColor.toPdfColor(),
                width: style.itemSeparatorWidth),
            Offset(contentLeft, currentY - style.itemSpacing / 2),
            Offset(
                contentLeft + contentWidth, currentY - style.itemSpacing / 2),
          );
        }
      }
    }

    // Draw footer
    final displayFooter = getFooter();
    if (displayFooter != null && displayFooter.isNotEmpty) {
      currentY += style.itemSpacing;
      final defaultFooterColor =
          style.contentStyle.color.withValues(alpha: 0.7);
      final effectiveFooterStyle = footerStyle ??
          GeniusPdfTextStyle(
            fontSize: style.contentStyle.fontSize * 0.9,
            color: defaultFooterColor,
          );

      final footerFormat = PdfStringFormat(
        alignment:
            effectiveFooterStyle.alignment.toPdfTextAlignment(isRTL),
        textDirection: GeniusPdfComponentDirectionality.pdfDirection(_effectiveDirectionality.resolve().direction)
      );

      graphics.drawString(
        displayFooter,
        baseFont,
        brush: effectiveFooterStyle.toBrush(),
        bounds: Rect.fromLTWH(contentLeft, currentY, contentWidth, 0),
        format: footerFormat,
      );
      currentY += effectiveFooterStyle.fontSize * 1.2;
    }

    // Return actual drawn bounds
    final actualHeight = currentY - bounds.top + style.padding.bottom;
    final finalHeight = boxHeight > actualHeight ? boxHeight : actualHeight;
    return Rect.fromLTWH(bounds.left, bounds.top, bounds.width, finalHeight);
  }

  double _drawItemValue(
    PdfGraphics graphics,
    GeniusPdfLabeledValue item,
    Rect bounds,
  ) {
    final labelText = isRTL && item.labelAr != null
        ? item.labelAr!
        : item.label;
    final valueText = item.value.isEmpty ? emptyItemPlaceholder : item.value;
    final labelStyle = style.labelStyle ??
        item.labelStyle ??
        style.contentStyle.copyWith(fontWeight: FontWeight.w600);
    final valueStyle =
        style.valueStyle ?? item.valueStyle ?? style.contentStyle;
    final labelFont = labelStyle.isBold ? boldFont : baseFont;
    final valueFont = valueStyle.isBold ? boldFont : baseFont;
    final labelFormat = PdfStringFormat(
      alignment: labelStyle.alignment.toPdfTextAlignment(isRTL),
      textDirection: GeniusPdfComponentDirectionality.pdfDirection(_effectiveDirectionality.resolve().direction),
    );
    final valueFormat = PdfStringFormat(
      alignment: valueStyle.alignment.toPdfTextAlignment(isRTL),
      textDirection: GeniusPdfComponentDirectionality.valuePdfDirection(
        context: _effectiveDirectionality,
        text: valueText,
        explicitDirection: item.valueDirection,
      ),
    );
    final labelHeight = labelStyle.fontSize * 1.2;
    final valueHeight = valueStyle.fontSize * 1.2;
    final gap = style.labelValueGap;

    if (style.labelValueLayout == GeniusPdfLabelValueLayout.stacked) {
      var currentItemY = bounds.top;
      if (labelText.isNotEmpty) {
        graphics.drawString(
          labelText,
          labelFont,
          brush: labelStyle.toBrush(),
          bounds: Rect.fromLTWH(bounds.left, currentItemY, bounds.width, 0),
          format: labelFormat,
        );
        currentItemY += labelHeight;
      }

      graphics.drawString(
        valueText,
        valueFont,
        brush: item.valueColor != null
            ? PdfSolidBrush(item.valueColor!.toPdfColor())
            : valueStyle.toBrush(),
        bounds: Rect.fromLTWH(bounds.left, currentItemY, bounds.width, 0),
        format: valueFormat,
      );
      return (currentItemY - bounds.top) + valueHeight;
    }

    final clampedLabelWidth =
        (style.labelWidth ?? (bounds.width * 0.42))
            .clamp(0.0, bounds.width)
            .toDouble();
    final valueWidth = bounds.width - clampedLabelWidth - gap;
    if (valueWidth <= 0) {
      graphics.drawString(
        valueText,
        valueFont,
        brush: item.valueColor != null
            ? PdfSolidBrush(item.valueColor!.toPdfColor())
            : valueStyle.toBrush(),
        bounds: Rect.fromLTWH(bounds.left, bounds.top, bounds.width, 0),
        format: valueFormat,
      );
      return valueHeight;
    }

    Rect labelBounds;
    Rect valueBounds;
    if (style.labelValueLayout == GeniusPdfLabelValueLayout.valueFirst) {
      if (isRTL) {
        valueBounds = Rect.fromLTWH(
          bounds.left + clampedLabelWidth + gap,
          bounds.top,
          valueWidth,
          0,
        );
        labelBounds = Rect.fromLTWH(
          bounds.left,
          bounds.top,
          clampedLabelWidth,
          0,
        );
      } else {
        valueBounds =
            Rect.fromLTWH(bounds.left, bounds.top, valueWidth, 0);
        labelBounds = Rect.fromLTWH(
          bounds.left + valueWidth + gap,
          bounds.top,
          clampedLabelWidth,
          0,
        );
      }
    } else if (isRTL) {
      valueBounds =
          Rect.fromLTWH(bounds.left, bounds.top, valueWidth, 0);
      labelBounds = Rect.fromLTWH(
        bounds.left + valueWidth + gap,
        bounds.top,
        clampedLabelWidth,
        0,
      );
    } else {
      labelBounds = Rect.fromLTWH(
        bounds.left,
        bounds.top,
        clampedLabelWidth,
        0,
      );
      valueBounds = Rect.fromLTWH(
        bounds.left + clampedLabelWidth + gap,
        bounds.top,
        valueWidth,
        0,
      );
    }

    if (labelText.isNotEmpty) {
      graphics.drawString(
        labelText,
        labelFont,
        brush: labelStyle.toBrush(),
        bounds: labelBounds,
        format: labelFormat,
      );
    }
    graphics.drawString(
      valueText,
      valueFont,
      brush: item.valueColor != null
          ? PdfSolidBrush(item.valueColor!.toPdfColor())
          : valueStyle.toBrush(),
      bounds: valueBounds,
      format: valueFormat,
    );

    return labelHeight > valueHeight ? labelHeight : valueHeight;
  }

  double _calculateHeight([double? availableWidth]) {
    double height = 0;

    // Header height
    if (getTitle() != null) {
      height += _getHeaderHeight();
      if (style.showDivider) {
        height += style.dividerMargin * 2;
      }
    }

    // Items height
    final filteredItems = visibleItems;
    if (columns > 1) {
      final rows = (filteredItems.length / columns).ceil();
      height += rows * (_getItemHeight() + style.itemSpacing);
    } else {
      height += filteredItems.length * (_getItemHeight() + style.itemSpacing);
    }

    // Footer height
    if (getFooter() != null) {
      height += style.itemSpacing + (style.contentStyle.fontSize * 0.9) * 1.2;
    }

    return height;
  }

  double _getHeaderHeight() {
    final headerPadding = style.headerPadding ?? style.padding;
    double height =
        headerPadding.top + _getTitleHeight() + headerPadding.bottom;

    if (getSubtitle() != null) {
      height += 2 + style.titleStyle.fontSize * 0.9;
    }

    return height;
  }

  double _getTitleHeight() {
    return style.titleStyle.fontSize * 1.2;
  }

  double _getItemHeight() {
    if (style.labelValueLayout == GeniusPdfLabelValueLayout.stacked) {
      return style.contentStyle.fontSize * 2.4;
    }
    return style.contentStyle.fontSize * 1.4;
  }

  static GeniusPdfInfoBoxStyle _resolveInfoBoxStyle(
    GeniusPdfInfoBoxStyle? style,
    GeniusPdfConfig config,
  ) {
    if (style != null) return style;
    return GeniusPdfInfoBoxStyle.fromTheme(config.printTheme);
  }

  /// Draws border lines around a rectangle based on [GeniusPdfBorderStyle].
  static void _drawBorder(
    PdfGraphics graphics,
    Rect bounds,
    GeniusPdfBorderStyle borderStyle,
  ) {
    if (borderStyle.width <= 0) return;
    final pen = borderStyle.toPen();
    if (borderStyle.top) {
      graphics.drawLine(
        pen,
        Offset(bounds.left, bounds.top),
        Offset(bounds.right, bounds.top),
      );
    }
    if (borderStyle.bottom) {
      graphics.drawLine(
        pen,
        Offset(bounds.left, bounds.bottom),
        Offset(bounds.right, bounds.bottom),
      );
    }
    if (borderStyle.left) {
      graphics.drawLine(
        pen,
        Offset(bounds.left, bounds.top),
        Offset(bounds.left, bounds.bottom),
      );
    }
    if (borderStyle.right) {
      graphics.drawLine(
        pen,
        Offset(bounds.right, bounds.top),
        Offset(bounds.right, bounds.bottom),
      );
    }
  }
}

/// Layout modes for dual info box.
