part of '../pdf_report_header.dart';

class GeniusPdfReportHeaderStyle {
  const GeniusPdfReportHeaderStyle({
    this.backgroundColor,
    this.titleStyle = const GeniusPdfTextStyle.title(fontSize: 16),
    this.subtitleStyle = const GeniusPdfTextStyle.subtitle(fontSize: 12),
    this.companyNameStyle = const GeniusPdfTextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
    this.companyInfoStyle = const GeniusPdfTextStyle.caption(),
    this.sloganStyle,
    this.dateStyle,
    this.showBorder = true,
    this.borderStyle = const GeniusPdfBorderStyle.bottom(width: 1),
    this.topBorderStyle,
    this.padding = const GeniusPdfCellPadding.all(10),
    this.spacing = 8,
    this.titleSpacing = 4,
    this.logoMaxWidth = 150,
    this.logoMaxHeight = 60,
    this.logoMinWidth,
    this.logoMinHeight,
    this.logoPosition = GeniusPdfLogoPosition.end,
    this.logoSpacing = 12,
    this.secondaryLogoMaxWidth = 60,
    this.secondaryLogoMaxHeight = 40,
    this.titleAlignment = GeniusPdfTitleAlignment.center,
    this.companyInfoAlignment = GeniusPdfTitleAlignment.end,
    this.showCompanyDivider = false,
    this.companyDividerColor,
    this.companyDividerWidth = 0.5,
    this.showTitleUnderline = false,
    this.titleUnderlineColor,
    this.titleUnderlineWidth = 2.0,
    this.titleUnderlineSpacing = 4,
    this.headerMinHeight,
    this.headerMaxHeight,
    this.showDateOnRight = true,
    this.dateFormat = 'dd/MM/yyyy HH:mm',
    this.showPageInfo = false,
    this.shadowEnabled = false,
    this.shadowColor,
    this.shadowOffset = 2,
    this.accentColor,
    this.accentLinePosition,
    this.accentLineWidth = 4,
    this.dateSpacing = 6,
  });

  /// Creates a header style from [GeniusPdfPrintTheme].
  factory GeniusPdfReportHeaderStyle.fromTheme(GeniusPdfPrintTheme theme) {
    final headerTheme =
        theme.headerTheme ?? const GeniusPdfHeaderTheme.defaults();
    final typography = theme.typography;

    return GeniusPdfReportHeaderStyle(
      backgroundColor: headerTheme.backgroundColor,
      titleStyle: GeniusPdfTextStyle.title(
        fontSize: typography.titleSize,
        color: headerTheme.titleColor,
      ),
      subtitleStyle: GeniusPdfTextStyle.subtitle(
        fontSize: typography.subheadingSize,
        color: headerTheme.subtitleColor,
      ),
      companyNameStyle: GeniusPdfTextStyle(
        fontSize: typography.headingSize,
        fontWeight: FontWeight.bold,
        color: headerTheme.companyNameColor,
      ),
      companyInfoStyle: GeniusPdfTextStyle(
        fontSize: typography.bodySize,
        color: headerTheme.companyInfoColor,
      ),
      dateStyle: GeniusPdfTextStyle(
        fontSize: typography.captionSize,
        color: headerTheme.subtitleColor,
      ),
      borderStyle: headerTheme.showBorder
          ? GeniusPdfBorderStyle.all(
              width: headerTheme.borderWidth,
              color: headerTheme.borderColor,
            )
          : const GeniusPdfBorderStyle.none(),
      padding: headerTheme.padding,
      spacing: headerTheme.spacing,
      logoMaxWidth: headerTheme.logoMaxWidth,
      logoMaxHeight: headerTheme.logoMaxHeight,
      showBorder: headerTheme.showBorder,
    );
  }

  /// Creates a modern header style with accent colors.
  const GeniusPdfReportHeaderStyle.modern()
      : backgroundColor = const Color(0xFFF5F5F5),
        titleStyle = const GeniusPdfTextStyle.title(
          fontSize: 18,
          color: Color(0xFF1565C0),
        ),
        subtitleStyle = const GeniusPdfTextStyle.subtitle(
          fontSize: 11,
          color: Color(0xFF757575),
        ),
        companyNameStyle = const GeniusPdfTextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF212121),
        ),
        companyInfoStyle = const GeniusPdfTextStyle(
          fontSize: 9,
          color: Color(0xFF616161),
        ),
        sloganStyle = const GeniusPdfTextStyle(
          fontSize: 8,
          color: Color(0xFF757575),
        ),
        dateStyle = null,
        showBorder = true,
        borderStyle = const GeniusPdfBorderStyle.bottom(
          width: 2,
          color: Color(0xFF1565C0),
        ),
        topBorderStyle = null,
        padding = const GeniusPdfCellPadding.all(12),
        spacing = 10,
        titleSpacing = 4,
        logoMaxWidth = 150,
        logoMaxHeight = 60,
        logoMinWidth = null,
        logoMinHeight = null,
        logoPosition = GeniusPdfLogoPosition.end,
        logoSpacing = 12,
        secondaryLogoMaxWidth = 60,
        secondaryLogoMaxHeight = 40,
        titleAlignment = GeniusPdfTitleAlignment.center,
        companyInfoAlignment = GeniusPdfTitleAlignment.start,
        showCompanyDivider = false,
        companyDividerColor = null,
        companyDividerWidth = 0.5,
        showTitleUnderline = false,
        titleUnderlineColor = null,
        titleUnderlineWidth = 2.0,
        titleUnderlineSpacing = 4,
        headerMinHeight = null,
        headerMaxHeight = null,
        showDateOnRight = true,
        dateFormat = 'dd/MM/yyyy HH:mm',
        showPageInfo = false,
        shadowEnabled = false,
        shadowColor = null,
        shadowOffset = 2,
        accentColor = const Color(0xFF1565C0),
        accentLinePosition = null,
        accentLineWidth = 4,
        dateSpacing = 6;

  /// Creates a classic header style.
  const GeniusPdfReportHeaderStyle.classic()
      : backgroundColor = null,
        titleStyle = const GeniusPdfTextStyle.title(fontSize: 14),
        subtitleStyle = const GeniusPdfTextStyle.subtitle(fontSize: 10),
        companyNameStyle = const GeniusPdfTextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
        companyInfoStyle = const GeniusPdfTextStyle.caption(fontSize: 9),
        sloganStyle = null,
        dateStyle = null,
        showBorder = true,
        borderStyle = const GeniusPdfBorderStyle.bottom(width: 0.5),
        topBorderStyle = null,
        padding = const GeniusPdfCellPadding.all(8),
        spacing = 6,
        titleSpacing = 3,
        logoMaxWidth = 120,
        logoMaxHeight = 50,
        logoMinWidth = null,
        logoMinHeight = null,
        logoPosition = GeniusPdfLogoPosition.start,
        logoSpacing = 10,
        secondaryLogoMaxWidth = 50,
        secondaryLogoMaxHeight = 35,
        titleAlignment = GeniusPdfTitleAlignment.center,
        companyInfoAlignment = GeniusPdfTitleAlignment.end,
        showCompanyDivider = false,
        companyDividerColor = null,
        companyDividerWidth = 0.5,
        showTitleUnderline = false,
        titleUnderlineColor = null,
        titleUnderlineWidth = 1.0,
        titleUnderlineSpacing = 3,
        headerMinHeight = null,
        headerMaxHeight = null,
        showDateOnRight = true,
        dateFormat = 'dd/MM/yyyy HH:mm',
        showPageInfo = false,
        shadowEnabled = false,
        shadowColor = null,
        shadowOffset = 2,
        accentColor = null,
        accentLinePosition = null,
        accentLineWidth = 4,
        dateSpacing = 6;

  /// Creates a corporate/professional header style.
  factory GeniusPdfReportHeaderStyle.corporate({
    Color primaryColor = const Color(0xFF1565C0),
    Color? accentColor,
    Color? backgroundColor,
    bool showAccentLine = true,
  }) {
    final effectiveAccent = accentColor ?? primaryColor;
    return GeniusPdfReportHeaderStyle(
      backgroundColor: backgroundColor,
      titleStyle: GeniusPdfTextStyle.title(
        fontSize: 16,
        color: primaryColor,
      ),
      subtitleStyle: const GeniusPdfTextStyle.subtitle(
        fontSize: 11,
        color: Color(0xFF616161),
      ),
      companyNameStyle: const GeniusPdfTextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Color(0xFF212121),
      ),
      companyInfoStyle: const GeniusPdfTextStyle(
        fontSize: 9,
        color: Color(0xFF616161),
      ),
      sloganStyle: GeniusPdfTextStyle(
        fontSize: 8,
        color: primaryColor.withValues(alpha: 0.7),
      ),
      showBorder: true,
      borderStyle: GeniusPdfBorderStyle.bottom(
        width: 2,
        color: primaryColor,
      ),
      padding: const GeniusPdfCellPadding.all(12),
      spacing: 10,
      logoPosition: GeniusPdfLogoPosition.end,
      titleAlignment: GeniusPdfTitleAlignment.center,
      companyInfoAlignment: GeniusPdfTitleAlignment.start,
      accentColor: effectiveAccent,
      accentLinePosition: showAccentLine ? GeniusPdfLogoPosition.start : null,
      accentLineWidth: 4,
    );
  }

  /// Creates a minimal/clean header style.
  factory GeniusPdfReportHeaderStyle.minimal({
    Color accentColor = const Color(0xFF424242),
  }) {
    return GeniusPdfReportHeaderStyle(
      backgroundColor: null,
      titleStyle: GeniusPdfTextStyle.title(
        fontSize: 14,
        color: accentColor,
      ),
      subtitleStyle: GeniusPdfTextStyle.subtitle(
        fontSize: 10,
        color: accentColor.withValues(alpha: 0.7),
      ),
      companyNameStyle: GeniusPdfTextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: accentColor,
      ),
      companyInfoStyle: GeniusPdfTextStyle(
        fontSize: 8,
        color: accentColor.withValues(alpha: 0.6),
      ),
      showBorder: true,
      borderStyle: GeniusPdfBorderStyle.bottom(
        width: 1,
        color: accentColor,
      ),
      padding: const GeniusPdfCellPadding.symmetric(horizontal: 0, vertical: 8),
      spacing: 6,
      logoMaxWidth: 100,
      logoMaxHeight: 40,
      logoPosition: GeniusPdfLogoPosition.start,
      titleAlignment: GeniusPdfTitleAlignment.start,
      companyInfoAlignment: GeniusPdfTitleAlignment.end,
    );
  }

  /// Creates a Saudi-themed header style with green colors.
  factory GeniusPdfReportHeaderStyle.saudi({
    Color primaryColor = const Color(0xFF006C35),
    Color? accentColor,
  }) {
    final effectiveAccent = accentColor ?? primaryColor;
    return GeniusPdfReportHeaderStyle(
      backgroundColor: primaryColor.withValues(alpha: 0.03),
      titleStyle: GeniusPdfTextStyle.title(
        fontSize: 16,
        color: primaryColor,
      ),
      subtitleStyle: const GeniusPdfTextStyle.subtitle(
        fontSize: 11,
        color: Color(0xFF616161),
      ),
      companyNameStyle: GeniusPdfTextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: effectiveAccent,
      ),
      companyInfoStyle: const GeniusPdfTextStyle(
        fontSize: 9,
        color: Color(0xFF616161),
      ),
      showBorder: true,
      borderStyle: GeniusPdfBorderStyle.bottom(
        width: 2,
        color: primaryColor,
      ),
      topBorderStyle: GeniusPdfBorderStyle.top(
        width: 4,
        color: primaryColor,
      ),
      padding: const GeniusPdfCellPadding.all(12),
      spacing: 10,
      logoPosition: GeniusPdfLogoPosition.end,
      titleAlignment: GeniusPdfTitleAlignment.center,
      companyInfoAlignment: GeniusPdfTitleAlignment.start,
      accentColor: effectiveAccent,
    );
  }

  /// Creates an invoice-style header.
  factory GeniusPdfReportHeaderStyle.invoice({
    Color primaryColor = const Color(0xFF333333),
    bool showBackground = true,
  }) {
    return GeniusPdfReportHeaderStyle(
      backgroundColor: showBackground ? const Color(0xFFF8F8F8) : null,
      titleStyle: GeniusPdfTextStyle.title(
        fontSize: 20,
        color: primaryColor,
      ),
      subtitleStyle: const GeniusPdfTextStyle.subtitle(
        fontSize: 10,
        color: Color(0xFF666666),
      ),
      companyNameStyle: GeniusPdfTextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
      companyInfoStyle: const GeniusPdfTextStyle(
        fontSize: 9,
        color: Color(0xFF666666),
      ),
      showBorder: true,
      borderStyle: const GeniusPdfBorderStyle.all(
        width: 1,
        color: Color(0xFFCCCCCC),
      ),
      padding: const GeniusPdfCellPadding.all(15),
      spacing: 12,
      logoPosition: GeniusPdfLogoPosition.start,
      logoMaxWidth: 180,
      logoMaxHeight: 70,
      titleAlignment: GeniusPdfTitleAlignment.end,
      companyInfoAlignment: GeniusPdfTitleAlignment.start,
      showCompanyDivider: true,
      companyDividerColor: const Color(0xFFCCCCCC),
    );
  }

  /// Creates a bilingual split header style (Arabic right, English left).
  factory GeniusPdfReportHeaderStyle.bilingualSplit({
    Color primaryColor = const Color(0xFF006C35),
    Color? accentColor,
  }) {
    final effectiveAccent = accentColor ?? primaryColor;
    return GeniusPdfReportHeaderStyle(
      backgroundColor: null,
      titleStyle: GeniusPdfTextStyle.title(
        fontSize: 16,
        color: primaryColor,
      ),
      subtitleStyle: const GeniusPdfTextStyle.subtitle(
        fontSize: 11,
        color: Color(0xFF616161),
      ),
      companyNameStyle: GeniusPdfTextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: effectiveAccent,
      ),
      companyInfoStyle: const GeniusPdfTextStyle(
        fontSize: 9,
        color: Color(0xFF616161),
      ),
      showBorder: true,
      borderStyle: GeniusPdfBorderStyle.bottom(
        width: 2,
        color: primaryColor,
      ),
      topBorderStyle: GeniusPdfBorderStyle.top(
        width: 3,
        color: primaryColor,
      ),
      padding: const GeniusPdfCellPadding.all(10),
      spacing: 8,
      logoPosition: GeniusPdfLogoPosition.center,
      logoMaxWidth: 100,
      logoMaxHeight: 80,
      titleAlignment: GeniusPdfTitleAlignment.center,
      companyInfoAlignment: GeniusPdfTitleAlignment.start,
      accentColor: effectiveAccent,
    );
  }

  /// Background color for header area.
  final Color? backgroundColor;

  /// Style for main title.
  final GeniusPdfTextStyle titleStyle;

  /// Style for subtitle.
  final GeniusPdfTextStyle subtitleStyle;

  /// Style for company name.
  final GeniusPdfTextStyle companyNameStyle;

  /// Style for company info (address, phone, etc.).
  final GeniusPdfTextStyle companyInfoStyle;

  /// Style for company slogan.
  final GeniusPdfTextStyle? sloganStyle;

  /// Style for date/time display.
  final GeniusPdfTextStyle? dateStyle;

  /// Whether to show bottom border.
  final bool showBorder;

  /// Bottom border style.
  final GeniusPdfBorderStyle borderStyle;

  /// Top border style (optional).
  final GeniusPdfBorderStyle? topBorderStyle;

  /// Padding around header content.
  final GeniusPdfCellPadding padding;

  /// General spacing between sections.
  final double spacing;

  /// Spacing between title and subtitle.
  final double titleSpacing;

  /// Maximum logo width.
  final double logoMaxWidth;

  /// Maximum logo height.
  final double logoMaxHeight;

  /// Minimum logo width.
  final double? logoMinWidth;

  /// Minimum logo height.
  final double? logoMinHeight;

  /// Logo position in header.
  final GeniusPdfLogoPosition logoPosition;

  /// Spacing around logo.
  final double logoSpacing;

  /// Maximum width for secondary logo.
  final double secondaryLogoMaxWidth;

  /// Maximum height for secondary logo.
  final double secondaryLogoMaxHeight;

  /// Title text alignment.
  final GeniusPdfTitleAlignment titleAlignment;

  /// Company info alignment.
  final GeniusPdfTitleAlignment companyInfoAlignment;

  /// Whether to show divider below company info.
  final bool showCompanyDivider;

  /// Color for company divider.
  final Color? companyDividerColor;

  /// Width of company divider.
  final double companyDividerWidth;

  /// Whether to show underline under title.
  final bool showTitleUnderline;

  /// Color for title underline.
  final Color? titleUnderlineColor;

  /// Width of title underline.
  final double titleUnderlineWidth;

  /// Spacing around title underline.
  final double titleUnderlineSpacing;

  /// Minimum height for header.
  final double? headerMinHeight;

  /// Maximum height for header.
  final double? headerMaxHeight;

  /// Whether to show date on the right side.
  final bool showDateOnRight;

  /// Date format string.
  final String dateFormat;

  /// Whether to show page info (Page X of Y).
  final bool showPageInfo;

  /// Whether to show shadow.
  final bool shadowEnabled;

  /// Shadow color.
  final Color? shadowColor;

  /// Shadow offset.
  final double shadowOffset;

  /// Accent color for decorative elements.
  final Color? accentColor;

  /// Position for accent line (null to hide).
  final GeniusPdfLogoPosition? accentLinePosition;

  /// Width of accent line.
  final double accentLineWidth;

  /// Spacing between date and border line.
  final double dateSpacing;

  /// Creates a copy with modified values.
  GeniusPdfReportHeaderStyle copyWith({
    Color? backgroundColor,
    GeniusPdfTextStyle? titleStyle,
    GeniusPdfTextStyle? subtitleStyle,
    GeniusPdfTextStyle? companyNameStyle,
    GeniusPdfTextStyle? companyInfoStyle,
    GeniusPdfTextStyle? sloganStyle,
    GeniusPdfTextStyle? dateStyle,
    bool? showBorder,
    GeniusPdfBorderStyle? borderStyle,
    GeniusPdfBorderStyle? topBorderStyle,
    GeniusPdfCellPadding? padding,
    double? spacing,
    double? titleSpacing,
    double? logoMaxWidth,
    double? logoMaxHeight,
    double? logoMinWidth,
    double? logoMinHeight,
    GeniusPdfLogoPosition? logoPosition,
    double? logoSpacing,
    double? secondaryLogoMaxWidth,
    double? secondaryLogoMaxHeight,
    GeniusPdfTitleAlignment? titleAlignment,
    GeniusPdfTitleAlignment? companyInfoAlignment,
    bool? showCompanyDivider,
    Color? companyDividerColor,
    double? companyDividerWidth,
    bool? showTitleUnderline,
    Color? titleUnderlineColor,
    double? titleUnderlineWidth,
    double? titleUnderlineSpacing,
    double? headerMinHeight,
    double? headerMaxHeight,
    bool? showDateOnRight,
    String? dateFormat,
    bool? showPageInfo,
    bool? shadowEnabled,
    Color? shadowColor,
    double? shadowOffset,
    Color? accentColor,
    GeniusPdfLogoPosition? accentLinePosition,
    double? accentLineWidth,
    double? dateSpacing,
  }) {
    return GeniusPdfReportHeaderStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      titleStyle: titleStyle ?? this.titleStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      companyNameStyle: companyNameStyle ?? this.companyNameStyle,
      companyInfoStyle: companyInfoStyle ?? this.companyInfoStyle,
      sloganStyle: sloganStyle ?? this.sloganStyle,
      dateStyle: dateStyle ?? this.dateStyle,
      showBorder: showBorder ?? this.showBorder,
      borderStyle: borderStyle ?? this.borderStyle,
      topBorderStyle: topBorderStyle ?? this.topBorderStyle,
      padding: padding ?? this.padding,
      spacing: spacing ?? this.spacing,
      titleSpacing: titleSpacing ?? this.titleSpacing,
      logoMaxWidth: logoMaxWidth ?? this.logoMaxWidth,
      logoMaxHeight: logoMaxHeight ?? this.logoMaxHeight,
      logoMinWidth: logoMinWidth ?? this.logoMinWidth,
      logoMinHeight: logoMinHeight ?? this.logoMinHeight,
      logoPosition: logoPosition ?? this.logoPosition,
      logoSpacing: logoSpacing ?? this.logoSpacing,
      secondaryLogoMaxWidth:
          secondaryLogoMaxWidth ?? this.secondaryLogoMaxWidth,
      secondaryLogoMaxHeight:
          secondaryLogoMaxHeight ?? this.secondaryLogoMaxHeight,
      titleAlignment: titleAlignment ?? this.titleAlignment,
      companyInfoAlignment: companyInfoAlignment ?? this.companyInfoAlignment,
      showCompanyDivider: showCompanyDivider ?? this.showCompanyDivider,
      companyDividerColor: companyDividerColor ?? this.companyDividerColor,
      companyDividerWidth: companyDividerWidth ?? this.companyDividerWidth,
      showTitleUnderline: showTitleUnderline ?? this.showTitleUnderline,
      titleUnderlineColor: titleUnderlineColor ?? this.titleUnderlineColor,
      titleUnderlineWidth: titleUnderlineWidth ?? this.titleUnderlineWidth,
      titleUnderlineSpacing:
          titleUnderlineSpacing ?? this.titleUnderlineSpacing,
      headerMinHeight: headerMinHeight ?? this.headerMinHeight,
      headerMaxHeight: headerMaxHeight ?? this.headerMaxHeight,
      showDateOnRight: showDateOnRight ?? this.showDateOnRight,
      dateFormat: dateFormat ?? this.dateFormat,
      showPageInfo: showPageInfo ?? this.showPageInfo,
      shadowEnabled: shadowEnabled ?? this.shadowEnabled,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowOffset: shadowOffset ?? this.shadowOffset,
      accentColor: accentColor ?? this.accentColor,
      accentLinePosition: accentLinePosition ?? this.accentLinePosition,
      accentLineWidth: accentLineWidth ?? this.accentLineWidth,
      dateSpacing: dateSpacing ?? this.dateSpacing,
    );
  }
}

// ---------------------------------------------------------------------------
// Header Component
// ---------------------------------------------------------------------------

/// A professional report header component.
///
/// [GeniusPdfReportHeader] creates headers suitable for business reports with:
/// - Company logo and information
/// - Bilingual title support (Arabic/English)
/// - Print date and document metadata
/// - Multiple layout options
/// - Customizable styling
///
/// ## Example
/// ```dart
/// final header = GeniusPdfReportHeader(
///   title: 'Trial Balance',
///   titleAr: 'ميزان المراجعة',
///   subtitle: 'As of December 31, 2025',
///   subtitleAr: 'كما في 31 ديسمبر 2025',
///   company: GeniusPdfCompanyInfo(
///     name: 'Integrated Solutions Co.',
///     nameAr: 'شركة الحلول المتكاملة',
///     logo: logoImage,
///   ),
///   style: GeniusPdfReportHeaderStyle.corporate(),
/// );
///
/// header.draw(page: page, bounds: bounds);
/// ```
