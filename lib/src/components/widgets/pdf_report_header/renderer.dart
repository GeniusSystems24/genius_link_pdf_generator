part of '../pdf_report_header.dart';

class GeniusPdfReportHeader {
  GeniusPdfReportHeader({
    required this.title,
    this.titleAr,
    this.subtitle,
    this.subtitleAr,
    this.secondarySubtitle,
    this.secondarySubtitleAr,
    this.company,
    this.secondaryCompany,
    this.printDate,
    this.documentNumber,
    this.documentNumberLabel,
    this.documentNumberLabelAr,
    this.referenceNumber,
    this.referenceLabel,
    this.referenceLabelAr,
    required this.config,
    GeniusPdfReportHeaderStyle? style,
    this.showPrintDate = true,
    this.showCompanyInfo = true,
    this.showBilingualTitle = true,
    this.bilingualTitleOrder = GeniusPdfBilingualOrder.arabicFirst,
    this.layout = GeniusPdfReportHeaderLayout.standard,
    this.pageNumber,
    this.totalPages,
    this.showPageNumber = false,
    this.customFields,
    this.tag,
    this.infoGroups,
    this.layoutCalculator = const GeniusPdfHeaderLayoutCalculator(),
    this.directionality,
    this.direction = GeniusPdfDirection.auto,
    this.preservePhysicalOrder = false,
  }) : style = _resolveHeaderStyle(style, config);

  /// Creates a report header for invoices/receipts.
  factory GeniusPdfReportHeader.invoice({
    required String title,
    required String documentNumber,
    String? titleAr,
    String? subtitle,
    String? subtitleAr,
    GeniusPdfCompanyInfo? company,
    GeniusPdfCompanyInfo? customerCompany,
    DateTime? date,
    String documentNumberLabel = 'Invoice No',
    String documentNumberLabelAr = 'رقم الفاتورة',
    required GeniusPdfConfig config,
    GeniusPdfReportHeaderStyle? style,
  }) {
    return GeniusPdfReportHeader(
      title: title,
      titleAr: titleAr,
      subtitle: subtitle,
      subtitleAr: subtitleAr,
      company: company,
      secondaryCompany: customerCompany,
      printDate: date,
      documentNumber: documentNumber,
      documentNumberLabel: documentNumberLabel,
      documentNumberLabelAr: documentNumberLabelAr,
      config: config,
      style: style ?? GeniusPdfReportHeaderStyle.invoice(),
      layout: GeniusPdfReportHeaderLayout.invoice,
    );
  }

  /// Creates a simple report header with minimal info.
  factory GeniusPdfReportHeader.simple({
    required String title,
    String? titleAr,
    String? subtitle,
    String? subtitleAr,
    DateTime? date,
    required GeniusPdfConfig config,
    GeniusPdfReportHeaderStyle? style,
  }) {
    return GeniusPdfReportHeader(
      title: title,
      titleAr: titleAr,
      subtitle: subtitle,
      subtitleAr: subtitleAr,
      printDate: date,
      config: config,
      style: style ?? GeniusPdfReportHeaderStyle.minimal(),
      showCompanyInfo: false,
      layout: GeniusPdfReportHeaderLayout.compact,
    );
  }

  /// Creates a header with full company details.
  factory GeniusPdfReportHeader.withCompany({
    required String title,
    required GeniusPdfCompanyInfo company,
    String? titleAr,
    String? subtitle,
    String? subtitleAr,
    DateTime? date,
    required GeniusPdfConfig config,
    GeniusPdfReportHeaderStyle? style,
  }) {
    return GeniusPdfReportHeader(
      title: title,
      titleAr: titleAr,
      subtitle: subtitle,
      subtitleAr: subtitleAr,
      company: company,
      printDate: date,
      config: config,
      style: style ?? const GeniusPdfReportHeaderStyle.modern(),
      showCompanyInfo: true,
      layout: GeniusPdfReportHeaderLayout.standard,
    );
  }

  /// Creates a bilingual split header (Arabic right, English left, logo center).
  factory GeniusPdfReportHeader.bilingualSplit({
    required String title,
    required String titleAr,
    required GeniusPdfCompanyInfo company,
    String? subtitle,
    String? subtitleAr,
    DateTime? date,
    required GeniusPdfConfig config,
    GeniusPdfReportHeaderStyle? style,
  }) {
    return GeniusPdfReportHeader(
      title: title,
      titleAr: titleAr,
      subtitle: subtitle,
      subtitleAr: subtitleAr,
      company: company,
      printDate: date,
      config: config,
      style: style ?? GeniusPdfReportHeaderStyle.bilingualSplit(),
      showCompanyInfo: true,
      showBilingualTitle: true,
      layout: GeniusPdfReportHeaderLayout.bilingualSplit,
    );
  }

  /// Report title (English or default).
  final String title;

  /// Arabic title (optional).
  final String? titleAr;

  /// Report subtitle (English or default).
  final String? subtitle;

  /// Arabic subtitle (optional).
  final String? subtitleAr;

  /// Secondary subtitle (e.g., period range).
  final String? secondarySubtitle;

  /// Secondary subtitle in Arabic.
  final String? secondarySubtitleAr;

  /// Primary company information.
  final GeniusPdfCompanyInfo? company;

  /// Secondary company (e.g., customer for invoices).
  final GeniusPdfCompanyInfo? secondaryCompany;

  /// Print/generation date.
  final DateTime? printDate;

  /// Document number (e.g., invoice number).
  final String? documentNumber;

  /// Label for document number.
  final String? documentNumberLabel;

  /// Arabic label for document number.
  final String? documentNumberLabelAr;

  /// Reference number.
  final String? referenceNumber;

  /// Label for reference.
  final String? referenceLabel;

  /// Arabic label for reference.
  final String? referenceLabelAr;

  /// Header style configuration.
  final GeniusPdfReportHeaderStyle style;

  /// PDF configuration.
  final GeniusPdfConfig config;

  /// Base font for text.
  PdfFont get baseFont => config.baseFont;

  /// Bold font for titles.
  PdfFont get boldFont => config.boldFont;

  /// Whether to use RTL layout.
  bool get isRTL => _layoutDirection == GeniusPdfResolvedDirection.rtl;

  /// Whether to show print date.
  final bool showPrintDate;

  /// Whether to show company info.
  final bool showCompanyInfo;

  /// Whether to show both English and Arabic titles.
  final bool showBilingualTitle;

  /// Order for bilingual title display.
  final GeniusPdfBilingualOrder bilingualTitleOrder;

  /// Header layout type.
  final GeniusPdfReportHeaderLayout layout;

  /// Current page number.
  final int? pageNumber;

  /// Total number of pages.
  final int? totalPages;

  /// Whether to show page number.
  final bool showPageNumber;

  /// Custom fields to display (label -> value).
  final Map<String, String>? customFields;

  /// Custom tag for identification.
  final String? tag;

  /// Information groups for structured header content.
  final List<GeniusPdfHeaderInfoGroup>? infoGroups;

  /// Layout calculator for precise positioning.
  final GeniusPdfHeaderLayoutCalculator layoutCalculator;

  final GeniusPdfDirectionality? directionality;
  final GeniusPdfDirection direction;
  /// Preserve physical left/right block order when true.
  final bool preservePhysicalOrder;

  GeniusPdfDirectionality get _effectiveDirectionality =>
      GeniusPdfComponentDirectionality.context(
        config: config,
        inherited: directionality,
        componentDirection: direction,
      );

  GeniusPdfResolvedDirection get _layoutDirection =>
      _effectiveDirectionality.resolve().direction;

  static GeniusPdfReportHeaderStyle _resolveHeaderStyle(
    GeniusPdfReportHeaderStyle? style,
    GeniusPdfConfig config,
  ) {
    if (style != null) return style;
    return GeniusPdfReportHeaderStyle.fromTheme(config.theme.printTheme);
  }

  /// Gets the display title based on locale.
  String getTitle() {
    if (isRTL && titleAr != null) return titleAr!;
    return title;
  }

  /// Gets the display subtitle based on locale.
  String? getSubtitle() {
    if (isRTL && subtitleAr != null) return subtitleAr;
    return subtitle;
  }

  /// Gets the secondary subtitle based on locale.
  String? getSecondarySubtitle() {
    if (isRTL && secondarySubtitleAr != null) return secondarySubtitleAr;
    return secondarySubtitle;
  }

  /// Gets the document number label based on locale.
  String? getDocumentNumberLabel() {
    if (isRTL && documentNumberLabelAr != null) return documentNumberLabelAr;
    return documentNumberLabel;
  }

  /// Gets the reference label based on locale.
  String? getReferenceLabel() {
    if (isRTL && referenceLabelAr != null) return referenceLabelAr;
    return referenceLabel;
  }

  /// Gets both titles for bilingual display.
  (String, String?) getBilingualTitle() {
    return (title, titleAr);
  }

  /// Gets the page info string.
  String? getPageInfo() {
    if (!showPageNumber || pageNumber == null) return null;
    if (totalPages != null) {
      return isRTL
          ? 'صفحة $pageNumber من $totalPages'
          : 'Page $pageNumber of $totalPages';
    }
    return isRTL ? 'صفحة $pageNumber' : 'Page $pageNumber';
  }

  /// Estimates the rendered height of this header.
  ///
  /// The document builder uses this to keep the full header together when
  /// the current page no longer has enough remaining content height.
  double estimateHeight({double? availableWidth}) {
    var estimated = style.padding.top;

    switch (layout) {
      case GeniusPdfReportHeaderLayout.compact:
        final logoHeight = _estimateLogoHeight(scale: 0.7);
        final titleBlockHeight =
            _estimateTitleBlockHeight() + _estimateSubtitleBlockHeight();
        estimated +=
            logoHeight > titleBlockHeight ? logoHeight : titleBlockHeight;
        break;
      case GeniusPdfReportHeaderLayout.centered:
        final logoHeight = _estimateLogoHeight();
        if (logoHeight > 0) {
          estimated += logoHeight + style.logoSpacing;
        }
        if (showCompanyInfo && company != null) {
          estimated += style.companyNameStyle.fontSize + style.spacing;
        }
        estimated += _estimateTitleBlockHeight();
        estimated += _estimateSubtitleBlockHeight();
        break;
      case GeniusPdfReportHeaderLayout.bilingualSplit:
        final englishHeight = _estimateCompanyInfoHeight(isArabic: false);
        final arabicHeight = _estimateCompanyInfoHeight(isArabic: true);
        final logoHeight = _estimateLogoHeight();
        var topRowHeight = englishHeight;
        if (arabicHeight > topRowHeight) {
          topRowHeight = arabicHeight;
        }
        if (logoHeight > topRowHeight) {
          topRowHeight = logoHeight;
        }
        if (topRowHeight > 0) {
          estimated += topRowHeight + style.spacing;
        }
        estimated += _estimateTitleBlockHeight();
        estimated += _estimateSubtitleBlockHeight();
        estimated += _estimateDocumentInfoHeight();
        break;
      case GeniusPdfReportHeaderLayout.invoice:
      case GeniusPdfReportHeaderLayout.standard:
      case GeniusPdfReportHeaderLayout.letterhead:
      case GeniusPdfReportHeaderLayout.reportCard:
      case GeniusPdfReportHeaderLayout.minimal:
      case GeniusPdfReportHeaderLayout.fullWidth:
        var topRowHeight = _estimateCompanyInfoHeight(isArabic: isRTL);
        final logoHeight = _estimateLogoHeight();
        if (style.logoPosition == GeniusPdfLogoPosition.centerTop &&
            logoHeight > 0) {
          topRowHeight += logoHeight + style.logoSpacing;
        } else if (logoHeight > topRowHeight) {
          topRowHeight = logoHeight;
        }
        if (topRowHeight > 0) {
          estimated += topRowHeight + style.spacing;
        }
        estimated += _estimateTitleBlockHeight();
        estimated += _estimateSubtitleBlockHeight();
        estimated += _estimateDocumentInfoHeight();
        if (layout == GeniusPdfReportHeaderLayout.standard &&
            style.logoPosition == GeniusPdfLogoPosition.centerBottom &&
            logoHeight > 0) {
          estimated += logoHeight + style.logoSpacing;
        }
        break;
    }

    final dateHeight = _estimateDateSectionHeight();
    if (dateHeight > 0) {
      estimated += dateHeight + style.dateSpacing;
    } else {
      estimated += style.padding.bottom;
    }

    if (style.headerMinHeight != null && estimated < style.headerMinHeight!) {
      estimated = style.headerMinHeight!;
    }
    if (style.headerMaxHeight != null && estimated > style.headerMaxHeight!) {
      estimated = style.headerMaxHeight!;
    }

    return estimated;
  }

  // -------------------------------------------------------------------------
  // Alignment helpers
  // -------------------------------------------------------------------------

  /// Resolves logo X position based on [GeniusPdfLogoPosition] and RTL.
  double _resolveLogoX(
    GeniusPdfLogoPosition position,
    double contentLeft,
    double contentRight,
    double logoWidth,
  ) {
    final mirror = isRTL && !preservePhysicalOrder;
    switch (position) {
      case GeniusPdfLogoPosition.end:
        return mirror ? contentLeft : contentRight - logoWidth;
      case GeniusPdfLogoPosition.start:
        return mirror ? contentRight - logoWidth : contentLeft;
      case GeniusPdfLogoPosition.center:
      case GeniusPdfLogoPosition.centerTop:
      case GeniusPdfLogoPosition.centerBottom:
        return contentLeft + ((contentRight - contentLeft) - logoWidth) / 2;
      case GeniusPdfLogoPosition.background:
        return contentLeft + ((contentRight - contentLeft) - logoWidth) / 2;
    }
  }

  /// Creates a [PdfStringFormat] for the given alignment and RTL direction.
  PdfStringFormat _textFormat(GeniusPdfTitleAlignment alignment) {
    return PdfStringFormat(
      alignment: alignment.toPdfTextAlignment(isRTL),
      textDirection:
          isRTL ? PdfTextDirection.rightToLeft : PdfTextDirection.leftToRight,
    );
  }

  /// Creates a [PdfStringFormat] with explicit text direction.
  PdfStringFormat _textFormatDir(
      PdfTextAlignment alignment, PdfTextDirection direction) {
    return PdfStringFormat(alignment: alignment, textDirection: direction);
  }

  // -------------------------------------------------------------------------
  // Common drawing helpers
  // -------------------------------------------------------------------------

  /// Draws the background, top border, and accent line.
  void _drawBackground(PdfGraphics graphics, Rect bounds) {
    // Shadow
    if (style.shadowEnabled) {
      final shadowColor =
          (style.shadowColor ?? const Color(0xFF000000)).withValues(alpha: 0.1);
      graphics.drawRectangle(
        brush: PdfSolidBrush(shadowColor.toPdfColor()),
        bounds: Rect.fromLTWH(
          bounds.left + style.shadowOffset,
          bounds.top + style.shadowOffset,
          bounds.width,
          bounds.height,
        ),
      );
    }

    // Background
    if (style.backgroundColor != null) {
      graphics.drawRectangle(
        brush: PdfSolidBrush(style.backgroundColor!.toPdfColor()),
        bounds: bounds,
      );
    }

    // Top border
    if (style.topBorderStyle != null) {
      graphics.drawLine(
        style.topBorderStyle!.toPen(),
        Offset(bounds.left, bounds.top),
        Offset(bounds.right, bounds.top),
      );
    }

    // Accent line
    if (style.accentLinePosition != null && style.accentColor != null) {
      final pen = PdfPen(
        style.accentColor!.toPdfColor(),
        width: style.accentLineWidth,
      );
      switch (style.accentLinePosition!) {
        case GeniusPdfLogoPosition.start:
          final x = isRTL
              ? bounds.right - style.accentLineWidth / 2
              : bounds.left + style.accentLineWidth / 2;
          graphics.drawLine(
              pen, Offset(x, bounds.top), Offset(x, bounds.bottom));
          break;
        case GeniusPdfLogoPosition.end:
          final x = isRTL
              ? bounds.left + style.accentLineWidth / 2
              : bounds.right - style.accentLineWidth / 2;
          graphics.drawLine(
              pen, Offset(x, bounds.top), Offset(x, bounds.bottom));
          break;
        default:
          break;
      }
    }
  }

  PdfTextDirection get textDirection =>
      isRTL ? PdfTextDirection.rightToLeft : PdfTextDirection.leftToRight;

  double _estimateLogoHeight({double scale = 1.0}) {
    if (!showCompanyInfo || company?.logo == null) {
      return 0;
    }

    final logo = company!.logo!.scaledToFit(
      maxWidth: style.logoMaxWidth * scale,
      maxHeight: style.logoMaxHeight * scale,
    );
    return logo.height;
  }

  double _estimateCompanyInfoHeight({required bool isArabic}) {
    if (!showCompanyInfo || company == null) {
      return 0;
    }

    var height = style.companyNameStyle.fontSize + 3;
    final infoLineHeight = style.companyInfoStyle.fontSize + 2;

    final address = company!.getAddress(isArabic: isArabic);
    if (address != null && address.isNotEmpty) {
      height += infoLineHeight;
    }

    final city = isArabic ? (company!.cityAr ?? company!.city) : company!.city;
    final country =
        isArabic ? (company!.countryAr ?? company!.country) : company!.country;
    if ((city != null && city.isNotEmpty) ||
        (country != null && country.isNotEmpty)) {
      height += infoLineHeight;
    }

    if (company!.vatNumber != null && company!.vatNumber!.isNotEmpty) {
      height += infoLineHeight;
    }
    if (company!.crNumber != null && company!.crNumber!.isNotEmpty) {
      height += infoLineHeight;
    }
    if (company!.phone != null && company!.phone!.isNotEmpty) {
      height += infoLineHeight;
    }
    if (company!.email != null && company!.email!.isNotEmpty) {
      height += infoLineHeight;
    }

    final slogan = company!.getSlogan(isArabic: isArabic);
    if (slogan != null && slogan.isNotEmpty && style.sloganStyle != null) {
      height += style.sloganStyle!.fontSize + 2;
    }

    if (style.showCompanyDivider) {
      height += 5;
    }

    return height;
  }

  double _estimateTitleBlockHeight() {
    final titleLines = showBilingualTitle &&
            titleAr != null &&
            bilingualTitleOrder != GeniusPdfBilingualOrder.primaryOnly
        ? 2
        : 1;
    var height = titleLines * (style.titleStyle.fontSize + style.titleSpacing);
    if (style.showTitleUnderline) {
      height += style.titleUnderlineSpacing;
    }
    return height;
  }

  double _estimateSubtitleBlockHeight() {
    var height = 0.0;

    if (subtitleAr != null) {
      height += style.subtitleStyle.fontSize + 2;
    }
    if (subtitle != null) {
      height += style.subtitleStyle.fontSize + 2;
    }
    if (getSecondarySubtitle() != null) {
      height += style.subtitleStyle.fontSize + 2;
    }

    return height;
  }

  double _estimateDocumentInfoHeight() {
    if (documentNumber == null && referenceNumber == null) {
      return 0;
    }

    final fontSize = style.dateStyle?.fontSize ?? 9;
    var height = 0.0;
    if (documentNumber != null) {
      height += fontSize + 2;
    }
    if (referenceNumber != null) {
      height += fontSize + 2;
    }
    return height;
  }

  double _estimateDateSectionHeight() {
    if ((!showPrintDate || printDate == null) && !showPageNumber) {
      return 0;
    }
    return (style.dateStyle?.fontSize ?? 8) + 2;
  }

  /// Draws date and page info, returns the height consumed.
  double _drawDateSection(
    PdfGraphics graphics,
    double currentY,
    double contentLeft,
    double contentRight,
  ) {
    if (!showPrintDate && !showPageNumber) return 0;

    final dateFont = baseFont;
    final dateBrush = style.dateStyle?.toBrush() ??
        PdfSolidBrush(const Color(0xFF757575).toPdfColor());
    final dateFontSize = style.dateStyle?.fontSize ?? 8;
    double dateHeight = 0;

    if (showPrintDate && printDate != null) {
      final dateText = isRTL
          ? 'تاريخ الطباعة: ${GeniusPdfComponentDirectionality.isolateLtr(_formatDate(printDate!))}'
          : 'Printed: ${GeniusPdfComponentDirectionality.isolateLtr(_formatDate(printDate!))}';

      final dateAlignment = style.showDateOnRight
          ? PdfTextAlignment.right
          : PdfTextAlignment.left;
      final dateX = style.showDateOnRight ? contentLeft : contentLeft;
      final dateWidth = contentRight - contentLeft;

      graphics.drawString(
        dateText,
        dateFont,
        brush: dateBrush,
        bounds: Rect.fromLTWH(dateX, currentY, dateWidth, 0),
        format: PdfStringFormat(
            alignment: dateAlignment, textDirection: textDirection),
      );
      dateHeight = dateFontSize + 2;
    }

    // Page info on the opposite side of date
    final pageInfo = getPageInfo();
    if (pageInfo != null) {
      final pageAlignment = style.showDateOnRight
          ? PdfTextAlignment.left
          : PdfTextAlignment.right;

      graphics.drawString(
        pageInfo,
        dateFont,
        brush: dateBrush,
        bounds:
            Rect.fromLTWH(contentLeft, currentY, contentRight - contentLeft, 0),
        format: PdfStringFormat(
            alignment: pageAlignment, textDirection: textDirection),
      );
      if (dateHeight == 0) dateHeight = dateFontSize + 2;
    }

    return dateHeight;
  }

  /// Draws the bottom border at the given Y position.
  void _drawBottomBorder(PdfGraphics graphics, Rect bounds, double y) {
    if (style.showBorder) {
      graphics.drawLine(
        style.borderStyle.toPen(),
        Offset(bounds.left, y),
        Offset(bounds.right, y),
      );
    }
  }

  /// Draws company info block, returns height consumed.
  double _drawCompanyInfoBlock(
    PdfGraphics graphics,
    double x,
    double y,
    double width,
    GeniusPdfTitleAlignment alignment, {
    bool isArabic = false,
  }) {
    if (company == null) return 0;

    final nameAlignment = alignment.toPdfTextAlignment(isRTL);
    final dir =
        isArabic ? PdfTextDirection.rightToLeft : PdfTextDirection.leftToRight;

    return _drawCompanyInfoBlockExplicit(
      graphics,
      x,
      y,
      width,
      nameAlignment,
      dir,
      isArabic: isArabic,
    );
  }

  /// Draws company info block with explicit alignment and direction.
  /// This method is used for bilingual layouts where we need precise control
  /// over text alignment regardless of global RTL setting.
  double _drawCompanyInfoBlockExplicit(
    PdfGraphics graphics,
    double x,
    double y,
    double width,
    PdfTextAlignment nameAlignment,
    PdfTextDirection dir, {
    bool isArabic = false,
  }) {
    if (company == null) return 0;

    double infoY = y;

    // Company name
    graphics.drawString(
      company!.getName(isArabic: isArabic),
      boldFont,
      brush: style.companyNameStyle.toBrush(),
      bounds: Rect.fromLTWH(x, infoY, width, 0),
      format: _textFormatDir(nameAlignment, dir),
    );
    infoY += style.companyNameStyle.fontSize + 3;

    // Address
    final address = company!.getAddress(isArabic: isArabic);
    if (address != null && address.isNotEmpty) {
      graphics.drawString(
        address,
        baseFont,
        brush: style.companyInfoStyle.toBrush(),
        bounds: Rect.fromLTWH(x, infoY, width, 0),
        format: _textFormatDir(nameAlignment, dir),
      );
      infoY += style.companyInfoStyle.fontSize + 2;
    }

    // City + Country
    final city = isArabic ? (company!.cityAr ?? company!.city) : company!.city;
    final country =
        isArabic ? (company!.countryAr ?? company!.country) : company!.country;
    if (city != null || country != null) {
      final parts = <String>[];
      if (city != null && city.isNotEmpty) parts.add(city);
      if (country != null && country.isNotEmpty) parts.add(country);
      if (parts.isNotEmpty) {
        graphics.drawString(
          parts.join(', '),
          baseFont,
          brush: style.companyInfoStyle.toBrush(),
          bounds: Rect.fromLTWH(x, infoY, width, 0),
          format: _textFormatDir(nameAlignment, dir),
        );
        infoY += style.companyInfoStyle.fontSize + 2;
      }
    }

    // VAT Number
    if (company!.vatNumber != null && company!.vatNumber!.isNotEmpty) {
      final vatLabel = isArabic ? 'الرقم الضريبي: ' : 'VAT No: ';
      graphics.drawString(
        '$vatLabel${company!.vatNumber}',
        baseFont,
        brush: style.companyInfoStyle.toBrush(),
        bounds: Rect.fromLTWH(x, infoY, width, 0),
        format: _textFormatDir(nameAlignment, dir),
      );
      infoY += style.companyInfoStyle.fontSize + 2;
    }

    // CR Number
    if (company!.crNumber != null && company!.crNumber!.isNotEmpty) {
      final crLabel = isArabic ? 'السجل التجاري: ' : 'CR No: ';
      graphics.drawString(
        '$crLabel${company!.crNumber}',
        baseFont,
        brush: style.companyInfoStyle.toBrush(),
        bounds: Rect.fromLTWH(x, infoY, width, 0),
        format: _textFormatDir(nameAlignment, dir),
      );
      infoY += style.companyInfoStyle.fontSize + 2;
    }

    // Phone
    if (company!.phone != null && company!.phone!.isNotEmpty) {
      final phoneLabel = isArabic ? 'الهاتف: ' : 'Phone: ';
      graphics.drawString(
        '$phoneLabel${company!.phone}',
        baseFont,
        brush: style.companyInfoStyle.toBrush(),
        bounds: Rect.fromLTWH(x, infoY, width, 0),
        format: _textFormatDir(nameAlignment, dir),
      );
      infoY += style.companyInfoStyle.fontSize + 2;
    }

    // Email
    if (company!.email != null && company!.email!.isNotEmpty) {
      final emailLabel = isArabic ? 'البريد: ' : 'Email: ';
      graphics.drawString(
        '$emailLabel${company!.email}',
        baseFont,
        brush: style.companyInfoStyle.toBrush(),
        bounds: Rect.fromLTWH(x, infoY, width, 0),
        format: _textFormatDir(nameAlignment, dir),
      );
      infoY += style.companyInfoStyle.fontSize + 2;
    }

    // Slogan
    final slogan = company!.getSlogan(isArabic: isArabic);
    if (slogan != null && slogan.isNotEmpty && style.sloganStyle != null) {
      graphics.drawString(
        slogan,
        baseFont,
        brush: style.sloganStyle!.toBrush(),
        bounds: Rect.fromLTWH(x, infoY, width, 0),
        format: _textFormatDir(nameAlignment, dir),
      );
      infoY += style.sloganStyle!.fontSize + 2;
    }

    // Company divider
    if (style.showCompanyDivider) {
      final dividerColor = style.companyDividerColor ?? const Color(0xFFCCCCCC);
      graphics.drawLine(
        PdfPen(dividerColor.toPdfColor(), width: style.companyDividerWidth),
        Offset(x, infoY + 2),
        Offset(x + width, infoY + 2),
      );
      infoY += 5;
    }

    return infoY - y;
  }

  /// Draws bilingual title block, returns height consumed.
  double _drawTitleBlock(
    PdfGraphics graphics,
    double y,
    double contentLeft,
    double contentWidth,
    GeniusPdfTitleAlignment alignment,
  ) {
    double titleY = y;
    final pdfAlignment = alignment.toPdfTextAlignment(isRTL);

    // Bilingual title
    if (showBilingualTitle && titleAr != null) {
      final firstIsArabic =
          bilingualTitleOrder != GeniusPdfBilingualOrder.englishFirst;

      if (bilingualTitleOrder == GeniusPdfBilingualOrder.primaryOnly) {
        // Only primary language
        graphics.drawString(
          getTitle(),
          boldFont,
          brush: style.titleStyle.toBrush(),
          bounds: Rect.fromLTWH(contentLeft, titleY, contentWidth, 0),
          format: _textFormat(alignment),
        );
        titleY += style.titleStyle.fontSize + style.titleSpacing;
      } else {
        // First title
        final firstTitle = firstIsArabic ? titleAr! : title;
        final firstDir = firstIsArabic
            ? PdfTextDirection.rightToLeft
            : PdfTextDirection.leftToRight;
        graphics.drawString(
          firstTitle,
          boldFont,
          brush: style.titleStyle.toBrush(),
          bounds: Rect.fromLTWH(contentLeft, titleY, contentWidth, 0),
          format: _textFormatDir(pdfAlignment, firstDir),
        );
        titleY += style.titleStyle.fontSize + style.titleSpacing;

        // Second title
        final secondTitle = firstIsArabic ? title : titleAr!;
        final secondDir = firstIsArabic
            ? PdfTextDirection.leftToRight
            : PdfTextDirection.rightToLeft;
        graphics.drawString(
          secondTitle,
          boldFont,
          brush: style.titleStyle.toBrush(),
          bounds: Rect.fromLTWH(contentLeft, titleY, contentWidth, 0),
          format: _textFormatDir(pdfAlignment, secondDir),
        );
        titleY += style.titleStyle.fontSize + style.titleSpacing;
      }
    } else {
      // Single title
      graphics.drawString(
        title,
        boldFont,
        brush: style.titleStyle.toBrush(),
        bounds: Rect.fromLTWH(contentLeft, titleY, contentWidth, 0),
        format: _textFormat(alignment),
      );
      titleY += style.titleStyle.fontSize + style.titleSpacing;
    }

    // Title underline
    if (style.showTitleUnderline) {
      final underlineColor =
          style.titleUnderlineColor ?? style.titleStyle.color;
      graphics.drawLine(
        PdfPen(underlineColor.toPdfColor(), width: style.titleUnderlineWidth),
        Offset(contentLeft, titleY),
        Offset(contentLeft + contentWidth, titleY),
      );
      titleY += style.titleUnderlineSpacing;
    }

    return titleY - y;
  }

  /// Draws subtitle block, returns height consumed.
  double _drawSubtitleBlock(
    PdfGraphics graphics,
    double y,
    double contentLeft,
    double contentWidth,
    GeniusPdfTitleAlignment alignment,
  ) {
    double subY = y;

    if (subtitle == null && subtitleAr == null) return 0;

    final pdfAlignment = alignment.toPdfTextAlignment(isRTL);

    // Arabic subtitle
    if (subtitleAr != null) {
      graphics.drawString(
        subtitleAr!,
        baseFont,
        brush: style.subtitleStyle.toBrush(),
        bounds: Rect.fromLTWH(contentLeft, subY, contentWidth, 0),
        format: _textFormatDir(pdfAlignment, PdfTextDirection.rightToLeft),
      );
      subY += style.subtitleStyle.fontSize + 2;
    }

    // English subtitle
    if (subtitle != null) {
      graphics.drawString(
        subtitle!,
        baseFont,
        brush: style.subtitleStyle.toBrush(),
        bounds: Rect.fromLTWH(contentLeft, subY, contentWidth, 0),
        format: _textFormatDir(pdfAlignment, PdfTextDirection.leftToRight),
      );
      subY += style.subtitleStyle.fontSize + 2;
    }

    // Secondary subtitle
    final secSub = getSecondarySubtitle();
    if (secSub != null) {
      graphics.drawString(
        secSub,
        baseFont,
        brush: style.subtitleStyle.toBrush(),
        bounds: Rect.fromLTWH(contentLeft, subY, contentWidth, 0),
        format: _textFormat(alignment),
      );
      subY += style.subtitleStyle.fontSize + 2;
    }

    return subY - y;
  }

  /// Draws document number and reference, returns height consumed.
  double _drawDocumentInfo(
    PdfGraphics graphics,
    double y,
    double contentLeft,
    double contentWidth,
  ) {
    if (documentNumber == null && referenceNumber == null) return 0;

    double docY = y;
    final dateBrush = style.dateStyle?.toBrush() ??
        PdfSolidBrush(const Color(0xFF616161).toPdfColor());
    final fontSize = style.dateStyle?.fontSize ?? 9;

    if (documentNumber != null) {
      final label = getDocumentNumberLabel() ?? 'Doc No';
      graphics.drawString(
        '$label: ${GeniusPdfComponentDirectionality.isolateLtr(documentNumber!)}',
        baseFont,
        brush: dateBrush,
        bounds: Rect.fromLTWH(contentLeft, docY, contentWidth, 0),
        format: _textFormat(style.showDateOnRight
            ? GeniusPdfTitleAlignment.end
            : GeniusPdfTitleAlignment.start),
      );
      docY += fontSize + 2;
    }

    if (referenceNumber != null) {
      final label = getReferenceLabel() ?? 'Ref';
      graphics.drawString(
        '$label: ${GeniusPdfComponentDirectionality.isolateLtr(referenceNumber!)}',
        baseFont,
        brush: dateBrush,
        bounds: Rect.fromLTWH(contentLeft, docY, contentWidth, 0),
        format: _textFormat(style.showDateOnRight
            ? GeniusPdfTitleAlignment.end
            : GeniusPdfTitleAlignment.start),
      );
      docY += fontSize + 2;
    }

    return docY - y;
  }

  // -------------------------------------------------------------------------
  // Draw dispatcher
  // -------------------------------------------------------------------------

  /// Draws the header on a PDF page.
  ///
  /// Returns the height of the drawn header.
  double draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    GeniusPdfLogger.debug('Drawing report header: layout=$layout, '
        'title="$title", isRTL=$isRTL');

    double result;
    switch (layout) {
      case GeniusPdfReportHeaderLayout.compact:
        result = _drawCompactLayout(page, bounds);
        break;
      case GeniusPdfReportHeaderLayout.centered:
        result = _drawCenteredLayout(page, bounds);
        break;
      case GeniusPdfReportHeaderLayout.invoice:
        result = _drawInvoiceLayout(page, bounds);
        break;
      case GeniusPdfReportHeaderLayout.bilingualSplit:
        result = _drawBilingualSplitLayout(page, bounds);
        break;
      default:
        result = _drawStandardLayout(page, bounds);
        break;
    }

    // Enforce min/max height
    if (style.headerMinHeight != null && result < style.headerMinHeight!) {
      result = style.headerMinHeight!;
    }
    if (style.headerMaxHeight != null && result > style.headerMaxHeight!) {
      result = style.headerMaxHeight!;
    }

    GeniusPdfLogger.debug('Report header drawn: height=$result');
    return result;
  }

  // -------------------------------------------------------------------------
  // Standard layout
  // -------------------------------------------------------------------------

  double _drawStandardLayout(PdfPage page, Rect bounds) {
    final graphics = page.graphics;
    final contentLeft = bounds.left + style.padding.left;
    final contentRight = bounds.right - style.padding.right;
    final contentWidth = contentRight - contentLeft;

    _drawBackground(graphics, bounds);

    double currentY = bounds.top + style.padding.top;

    // --- Logo and company info row ---
    double logoSectionHeight = 0;
    double companySectionHeight = 0;

    // Calculate logo dimensions
    double logoWidth = 0;
    double logoHeight = 0;
    GeniusPdfImage? scaledLogo;
    if (company?.logo != null && showCompanyInfo) {
      scaledLogo = company!.logo!.scaledToFit(
        maxWidth: style.logoMaxWidth,
        maxHeight: style.logoMaxHeight,
      );
      logoWidth = scaledLogo.width;
      logoHeight = scaledLogo.height;
    }

    // Determine layout based on logo position
    final logoPos = style.logoPosition;

    if (logoPos == GeniusPdfLogoPosition.centerTop && scaledLogo != null) {
      // Logo centered above everything
      final logoX =
          _resolveLogoX(logoPos, contentLeft, contentRight, logoWidth);
      graphics.drawImage(
        PdfBitmap(scaledLogo.data),
        Rect.fromLTWH(logoX, currentY, logoWidth, logoHeight),
      );
      currentY += logoHeight + style.logoSpacing;
      logoSectionHeight = logoHeight + style.logoSpacing;
    }

    if (logoPos == GeniusPdfLogoPosition.background && scaledLogo != null) {
      // Logo as watermark in background
      final bgLogoWidth = contentWidth * 0.5;
      final scale = bgLogoWidth / scaledLogo.width;
      final bgLogoHeight = scaledLogo.height * scale;
      final logoX = contentLeft + (contentWidth - bgLogoWidth) / 2;
      final logoY = currentY +
          (bounds.height -
                  style.padding.top -
                  style.padding.bottom -
                  bgLogoHeight) /
              2;
      graphics.setTransparency(0.08);
      graphics.drawImage(
        PdfBitmap(scaledLogo.data),
        Rect.fromLTWH(logoX, logoY, bgLogoWidth, bgLogoHeight),
      );
      graphics.setTransparency(1.0);
    }

    // Side logo (start or end)
    final hasLogoOnSide = scaledLogo != null &&
        (logoPos == GeniusPdfLogoPosition.start ||
            logoPos == GeniusPdfLogoPosition.end ||
            logoPos == GeniusPdfLogoPosition.center);

    double companyAreaLeft = contentLeft;
    double companyAreaWidth = contentWidth;

    if (hasLogoOnSide && logoPos != GeniusPdfLogoPosition.center) {
      final logoX =
          _resolveLogoX(logoPos, contentLeft, contentRight, logoWidth);
      graphics.drawImage(
        PdfBitmap(scaledLogo.data),
        Rect.fromLTWH(logoX, currentY, logoWidth, logoHeight),
      );
      logoSectionHeight = logoHeight;

      // Adjust company area to avoid logo
      if (logoPos == GeniusPdfLogoPosition.start) {
        if (isRTL) {
          // Logo on right, company on left
          companyAreaWidth = contentWidth - logoWidth - style.logoSpacing;
        } else {
          // Logo on left, company on right
          companyAreaLeft = contentLeft + logoWidth + style.logoSpacing;
          companyAreaWidth = contentWidth - logoWidth - style.logoSpacing;
        }
      } else {
        // end
        if (isRTL) {
          // Logo on left, company on right
          companyAreaLeft = contentLeft + logoWidth + style.logoSpacing;
          companyAreaWidth = contentWidth - logoWidth - style.logoSpacing;
        } else {
          // Logo on right, company on left
          companyAreaWidth = contentWidth - logoWidth - style.logoSpacing;
        }
      }
    }

    // Draw company info in the company area
    if (showCompanyInfo && company != null) {
      companySectionHeight = _drawCompanyInfoBlock(
        graphics,
        companyAreaLeft,
        currentY,
        companyAreaWidth,
        style.companyInfoAlignment,
        isArabic: isRTL,
      );
    }

    // Advance past the taller of logo and company info
    final topRowHeight = logoSectionHeight > companySectionHeight
        ? logoSectionHeight
        : companySectionHeight;
    if (topRowHeight > 0) {
      currentY += topRowHeight + style.spacing;
    }

    // --- Title section ---
    final titleHeight = _drawTitleBlock(
      graphics,
      currentY,
      contentLeft,
      contentWidth,
      style.titleAlignment,
    );
    currentY += titleHeight;

    // --- Subtitle section ---
    final subtitleHeight = _drawSubtitleBlock(
      graphics,
      currentY,
      contentLeft,
      contentWidth,
      style.titleAlignment,
    );
    currentY += subtitleHeight;

    // --- Document info ---
    final docInfoHeight =
        _drawDocumentInfo(graphics, currentY, contentLeft, contentWidth);
    currentY += docInfoHeight;

    // --- Date section (drawn ABOVE the border with proper spacing) ---
    final dateHeight =
        _drawDateSection(graphics, currentY, contentLeft, contentRight);
    if (dateHeight > 0) {
      currentY += dateHeight + style.dateSpacing;
    } else {
      currentY += style.padding.bottom;
    }

    // --- CenterBottom logo ---
    if (logoPos == GeniusPdfLogoPosition.centerBottom && scaledLogo != null) {
      final logoX =
          _resolveLogoX(logoPos, contentLeft, contentRight, logoWidth);
      graphics.drawImage(
        PdfBitmap(scaledLogo.data),
        Rect.fromLTWH(logoX, currentY, logoWidth, logoHeight),
      );
      currentY += logoHeight + style.logoSpacing;
    }

    // --- Bottom border (BELOW date — no overlap) ---
    _drawBottomBorder(graphics, bounds, currentY);

    return currentY - bounds.top;
  }

  // -------------------------------------------------------------------------
  // Compact layout
  // -------------------------------------------------------------------------

  double _drawCompactLayout(PdfPage page, Rect bounds) {
    final graphics = page.graphics;
    final contentLeft = bounds.left + style.padding.left;
    final contentRight = bounds.right - style.padding.right;
    final contentWidth = contentRight - contentLeft;

    _drawBackground(graphics, bounds);

    double currentY = bounds.top + style.padding.top;
    final topRowStartY = currentY;

    // Logo on one side, title on other
    double logoWidth = 0;
    double logoHeight = 0;
    if (company?.logo != null) {
      final logo = company!.logo!.scaledToFit(
        maxWidth: style.logoMaxWidth * 0.7,
        maxHeight: style.logoMaxHeight * 0.7,
      );

      final logoX = _resolveLogoX(
          style.logoPosition, contentLeft, contentRight, logo.width);
      graphics.drawImage(
        PdfBitmap(logo.data),
        Rect.fromLTWH(logoX, currentY, logo.width, logo.height),
      );
      logoWidth = logo.width + style.logoSpacing;
      logoHeight = logo.height;
    }

    // Title area (next to logo)
    double titleX;
    double titleWidth;
    if (style.logoPosition == GeniusPdfLogoPosition.start) {
      if (isRTL) {
        titleX = contentLeft;
        titleWidth = contentWidth - logoWidth;
      } else {
        titleX = contentLeft + logoWidth;
        titleWidth = contentWidth - logoWidth;
      }
    } else {
      if (isRTL) {
        titleX = contentLeft + logoWidth;
        titleWidth = contentWidth - logoWidth;
      } else {
        titleX = contentLeft;
        titleWidth = contentWidth - logoWidth;
      }
    }

    // Bilingual title
    final titleHeight = _drawTitleBlock(
      graphics,
      currentY,
      titleX,
      titleWidth,
      style.titleAlignment,
    );
    currentY += titleHeight;

    // Subtitle
    final subtitleHeight = _drawSubtitleBlock(
      graphics,
      currentY,
      titleX,
      titleWidth,
      style.titleAlignment,
    );
    currentY += subtitleHeight;

    final logoBottom = topRowStartY + logoHeight;
    if (logoBottom > currentY) {
      currentY = logoBottom;
    }

    // Date
    final dateHeight =
        _drawDateSection(graphics, currentY, contentLeft, contentRight);
    if (dateHeight > 0) {
      currentY += dateHeight + style.dateSpacing;
    } else {
      currentY += style.padding.bottom;
    }

    _drawBottomBorder(graphics, bounds, currentY);

    return currentY - bounds.top;
  }

  // -------------------------------------------------------------------------
  // Centered layout
  // -------------------------------------------------------------------------

  double _drawCenteredLayout(PdfPage page, Rect bounds) {
    final graphics = page.graphics;
    final contentLeft = bounds.left + style.padding.left;
    final contentRight = bounds.right - style.padding.right;
    final contentWidth = contentRight - contentLeft;

    _drawBackground(graphics, bounds);

    double currentY = bounds.top + style.padding.top;
    const centerAlign = GeniusPdfTitleAlignment.center;

    // Center logo
    if (company?.logo != null) {
      final logo = company!.logo!.scaledToFit(
        maxWidth: style.logoMaxWidth,
        maxHeight: style.logoMaxHeight,
      );

      final logoX = contentLeft + (contentWidth - logo.width) / 2;
      graphics.drawImage(
        PdfBitmap(logo.data),
        Rect.fromLTWH(logoX, currentY, logo.width, logo.height),
      );
      currentY += logo.height + style.logoSpacing;
    }

    // Company name centered
    if (showCompanyInfo && company != null) {
      graphics.drawString(
        company!.getName(isArabic: isRTL),
        boldFont,
        brush: style.companyNameStyle.toBrush(),
        bounds: Rect.fromLTWH(contentLeft, currentY, contentWidth, 0),
        format: _textFormatDir(
            PdfTextAlignment.center,
            isRTL
                ? PdfTextDirection.rightToLeft
                : PdfTextDirection.leftToRight),
      );
      currentY += style.companyNameStyle.fontSize + style.spacing;
    }

    // Title
    final titleHeight = _drawTitleBlock(
      graphics,
      currentY,
      contentLeft,
      contentWidth,
      centerAlign,
    );
    currentY += titleHeight;

    // Subtitle
    final subtitleHeight = _drawSubtitleBlock(
      graphics,
      currentY,
      contentLeft,
      contentWidth,
      centerAlign,
    );
    currentY += subtitleHeight;

    // Date
    final dateHeight =
        _drawDateSection(graphics, currentY, contentLeft, contentRight);
    if (dateHeight > 0) {
      currentY += dateHeight + style.dateSpacing;
    } else {
      currentY += style.padding.bottom;
    }

    _drawBottomBorder(graphics, bounds, currentY);

    return currentY - bounds.top;
  }

  // -------------------------------------------------------------------------
  // Invoice layout
  // -------------------------------------------------------------------------

  double _drawInvoiceLayout(PdfPage page, Rect bounds) {
    final graphics = page.graphics;
    final contentLeft = bounds.left + style.padding.left;
    final contentRight = bounds.right - style.padding.right;
    final contentWidth = contentRight - contentLeft;

    _drawBackground(graphics, bounds);

    double currentY = bounds.top + style.padding.top;

    // Logo on start side
    double logoWidth = 0;
    double logoHeight = 0;
    if (company?.logo != null) {
      final logo = company!.logo!.scaledToFit(
        maxWidth: style.logoMaxWidth,
        maxHeight: style.logoMaxHeight,
      );
      final logoX = _resolveLogoX(
          style.logoPosition, contentLeft, contentRight, logo.width);
      graphics.drawImage(
        PdfBitmap(logo.data),
        Rect.fromLTWH(logoX, currentY, logo.width, logo.height),
      );
      logoWidth = logo.width;
      logoHeight = logo.height;
    }

    // Company info on the opposite side of logo
    final companyAlignment = style.companyInfoAlignment;
    double companyAreaLeft = contentLeft;
    double companyAreaWidth = contentWidth;
    if (logoWidth > 0) {
      if (style.logoPosition == GeniusPdfLogoPosition.start) {
        if (isRTL) {
          companyAreaWidth = contentWidth - logoWidth - style.logoSpacing;
        } else {
          companyAreaLeft = contentLeft + logoWidth + style.logoSpacing;
          companyAreaWidth = contentWidth - logoWidth - style.logoSpacing;
        }
      } else {
        if (isRTL) {
          companyAreaLeft = contentLeft + logoWidth + style.logoSpacing;
          companyAreaWidth = contentWidth - logoWidth - style.logoSpacing;
        } else {
          companyAreaWidth = contentWidth - logoWidth - style.logoSpacing;
        }
      }
    }

    double companySectionHeight = 0;
    if (showCompanyInfo && company != null) {
      companySectionHeight = _drawCompanyInfoBlock(
        graphics,
        companyAreaLeft,
        currentY,
        companyAreaWidth,
        companyAlignment,
        isArabic: isRTL,
      );
    }

    final topRowHeight =
        logoHeight > companySectionHeight ? logoHeight : companySectionHeight;
    if (topRowHeight > 0) {
      currentY += topRowHeight + style.spacing;
    }

    // Title centered
    final titleHeight = _drawTitleBlock(
      graphics,
      currentY,
      contentLeft,
      contentWidth,
      style.titleAlignment,
    );
    currentY += titleHeight;

    // Subtitle
    final subtitleHeight = _drawSubtitleBlock(
      graphics,
      currentY,
      contentLeft,
      contentWidth,
      style.titleAlignment,
    );
    currentY += subtitleHeight;

    // Document info (invoice number, reference)
    final docInfoHeight =
        _drawDocumentInfo(graphics, currentY, contentLeft, contentWidth);
    currentY += docInfoHeight;

    // Date
    final dateHeight =
        _drawDateSection(graphics, currentY, contentLeft, contentRight);
    if (dateHeight > 0) {
      currentY += dateHeight + style.dateSpacing;
    } else {
      currentY += style.padding.bottom;
    }

    _drawBottomBorder(graphics, bounds, currentY);

    return currentY - bounds.top;
  }

  // -------------------------------------------------------------------------
  // Bilingual Split layout
  // Arabic company info on right, English on left, logo in center
  // -------------------------------------------------------------------------

  double _drawBilingualSplitLayout(PdfPage page, Rect bounds) {
    final graphics = page.graphics;
    final contentLeft = bounds.left + style.padding.left;
    final contentRight = bounds.right - style.padding.right;
    final contentWidth = contentRight - contentLeft;

    _drawBackground(graphics, bounds);

    double currentY = bounds.top + style.padding.top;

    // Calculate three columns: [English left] [Logo center] [Arabic right]
    double logoWidth = 0;
    double logoHeight = 0;
    GeniusPdfImage? scaledLogo;
    if (company?.logo != null) {
      scaledLogo = company!.logo!.scaledToFit(
        maxWidth: style.logoMaxWidth,
        maxHeight: style.logoMaxHeight,
      );
      logoWidth = scaledLogo.width;
      logoHeight = scaledLogo.height;
    }

    final logoAreaWidth = logoWidth > 0 ? logoWidth + style.logoSpacing * 2 : 0;
    final sideWidth = (contentWidth - logoAreaWidth) / 2;

    // English company info on the LEFT - ALWAYS left-aligned with LTR direction
    // regardless of global RTL setting
    double enHeight = 0;
    if (showCompanyInfo && company != null) {
      enHeight = _drawCompanyInfoBlockExplicit(
        graphics,
        contentLeft,
        currentY,
        sideWidth,
        PdfTextAlignment.left, // Always left for English side
        PdfTextDirection.leftToRight, // Always LTR for English
        isArabic: false,
      );
    }

    // Logo in the CENTER
    if (scaledLogo != null) {
      final logoX = contentLeft + sideWidth + style.logoSpacing;
      graphics.drawImage(
        PdfBitmap(scaledLogo.data),
        Rect.fromLTWH(logoX, currentY, logoWidth, logoHeight),
      );
    }

    // Arabic company info on the RIGHT - ALWAYS right-aligned with RTL direction
    // regardless of global RTL setting
    double arHeight = 0;
    if (showCompanyInfo && company != null) {
      final arX = contentLeft + sideWidth + logoAreaWidth;
      arHeight = _drawCompanyInfoBlockExplicit(
        graphics,
        arX,
        currentY,
        sideWidth,
        PdfTextAlignment.right, // Always right for Arabic side
        PdfTextDirection.rightToLeft, // Always RTL for Arabic
        isArabic: true,
      );
    }

    // Advance past the tallest column
    double topRowHeight = enHeight > arHeight ? enHeight : arHeight;
    if (logoHeight > topRowHeight) topRowHeight = logoHeight;
    if (topRowHeight > 0) {
      currentY += topRowHeight + style.spacing;
    }

    // Title centered (bilingual)
    const centerAlign = GeniusPdfTitleAlignment.center;
    final titleHeight = _drawTitleBlock(
      graphics,
      currentY,
      contentLeft,
      contentWidth,
      centerAlign,
    );
    currentY += titleHeight;

    // Subtitle
    final subtitleHeight = _drawSubtitleBlock(
      graphics,
      currentY,
      contentLeft,
      contentWidth,
      centerAlign,
    );
    currentY += subtitleHeight;

    // Document info
    final docInfoHeight =
        _drawDocumentInfo(graphics, currentY, contentLeft, contentWidth);
    currentY += docInfoHeight;

    // Date
    final dateHeight =
        _drawDateSection(graphics, currentY, contentLeft, contentRight);
    if (dateHeight > 0) {
      currentY += dateHeight + style.dateSpacing;
    } else {
      currentY += style.padding.bottom;
    }

    _drawBottomBorder(graphics, bounds, currentY);

    return currentY - bounds.top;
  }

  // -------------------------------------------------------------------------
  // Utilities
  // -------------------------------------------------------------------------

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}

// ---------------------------------------------------------------------------
// Layout enum
// ---------------------------------------------------------------------------

/// Layout options for report headers.
