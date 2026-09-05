/// Styling configuration for voucher templates.
library;

import 'dart:ui';

/// Visual style configuration for all voucher templates.
class GeniusPdfVoucherStyle {
  const GeniusPdfVoucherStyle({
    this.primaryColor = const Color(0xFF1565C0),
    this.secondaryColor = const Color(0xFF1E88E5),
    this.headerTextColor = const Color(0xFFFFFFFF),
    this.borderColor = const Color(0xFFBDBDBD),
    this.tableHeaderColor = const Color(0xFFE0E0E0),
    this.tableHeaderTextColor = const Color(0xFF1565C0),
    this.tableAltRowColor = const Color(0xFFF5F5F5),
    this.accentColor = const Color(0xFF1565C0),
    this.amountHighlightColor = const Color(0xFFE3F2FD),
    this.debitColor = const Color(0xFFC62828),
    this.creditColor = const Color(0xFF2E7D32),
    this.badgeColor = const Color(0xFF1565C0),
    this.badgeTextColor = const Color(0xFFFFFFFF),
    this.headerHeight = 75,
    this.marginTop = 20,
    this.marginBottom = 20,
    this.marginLeft = 25,
    this.marginRight = 25,
    this.sectionSpacing = 10,
    this.signatureBlockHeight = 65,
    this.titleFontSize = 16,
    this.subtitleFontSize = 12,
    this.bodyFontSize = 9,
    this.smallFontSize = 7.5,
    this.tableFontSize = 8.5,
    this.showBorder = false,
    this.showServiceIdBadge = true,
    this.showCopyLabel = true,
    this.showWatermark = false,
    this.watermarkText,
    this.borderWidth = 1.0,
    this.headerBorderRadius = 0,
    this.cellPadding = 4,
  });

  // ── Pre-built Styles ──

  /// Standard professional style with dark blue header.
  factory GeniusPdfVoucherStyle.standard() =>
      const GeniusPdfVoucherStyle();

  /// Formal style with thicker borders and larger fonts.
  factory GeniusPdfVoucherStyle.formal() => const GeniusPdfVoucherStyle(
        primaryColor: Color(0xFF212121),
        secondaryColor: Color(0xFF424242),
        headerTextColor: Color(0xFFFFFFFF),
        borderColor: Color(0xFF616161),
        tableHeaderColor: Color(0xFFEEEEEE),
        tableHeaderTextColor: Color(0xFF212121),
        accentColor: Color(0xFF37474F),
        headerHeight: 80,
        titleFontSize: 18,
        subtitleFontSize: 13,
        bodyFontSize: 10,
        borderWidth: 1.5,
        signatureBlockHeight: 75,
      );

  /// Minimal clean style with light colors.
  factory GeniusPdfVoucherStyle.minimal() => const GeniusPdfVoucherStyle(
        primaryColor: Color(0xFF455A64),
        secondaryColor: Color(0xFF607D8B),
        headerTextColor: Color(0xFFFFFFFF),
        borderColor: Color(0xFFE0E0E0),
        tableHeaderColor: Color(0xFFFAFAFA),
        tableHeaderTextColor: Color(0xFF455A64),
        accentColor: Color(0xFF78909C),
        headerHeight: 60,
        sectionSpacing: 8,
        borderWidth: 0.5,
        showServiceIdBadge: false,
      );

  /// Green-themed style for financial vouchers.
  factory GeniusPdfVoucherStyle.financial() => const GeniusPdfVoucherStyle(
        primaryColor: Color(0xFF1B5E20),
        secondaryColor: Color(0xFF2E7D32),
        headerTextColor: Color(0xFFFFFFFF),
        borderColor: Color(0xFFA5D6A7),
        tableHeaderColor: Color(0xFFE8F5E9),
        tableHeaderTextColor: Color(0xFF1B5E20),
        accentColor: Color(0xFF388E3C),
        amountHighlightColor: Color(0xFFE8F5E9),
        badgeColor: Color(0xFF1B5E20),
      );

  /// Red-themed style for tax/government vouchers.
  factory GeniusPdfVoucherStyle.government() => const GeniusPdfVoucherStyle(
        primaryColor: Color(0xFF880E4F),
        secondaryColor: Color(0xFFAD1457),
        headerTextColor: Color(0xFFFFFFFF),
        borderColor: Color(0xFFF48FB1),
        tableHeaderColor: Color(0xFFFCE4EC),
        tableHeaderTextColor: Color(0xFF880E4F),
        accentColor: Color(0xFFC2185B),
        badgeColor: Color(0xFF880E4F),
      );

  // ── Colors ──
  final Color primaryColor;
  final Color secondaryColor;
  final Color headerTextColor;
  final Color borderColor;
  final Color tableHeaderColor;
  final Color tableHeaderTextColor;
  final Color tableAltRowColor;
  final Color accentColor;
  final Color amountHighlightColor;
  final Color debitColor;
  final Color creditColor;
  final Color badgeColor;
  final Color badgeTextColor;

  // ── Layout ──
  final double headerHeight;
  final double marginTop;
  final double marginBottom;
  final double marginLeft;
  final double marginRight;
  final double sectionSpacing;
  final double signatureBlockHeight;

  // ── Typography ──
  final double titleFontSize;
  final double subtitleFontSize;
  final double bodyFontSize;
  final double smallFontSize;
  final double tableFontSize;

  // ── Options ──
  final bool showBorder;
  final bool showServiceIdBadge;
  final bool showCopyLabel;
  final bool showWatermark;
  final String? watermarkText;
  final double borderWidth;
  final double headerBorderRadius;
  final double cellPadding;

  GeniusPdfVoucherStyle copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? headerTextColor,
    Color? borderColor,
    Color? tableHeaderColor,
    Color? tableHeaderTextColor,
    Color? tableAltRowColor,
    Color? accentColor,
    Color? amountHighlightColor,
    Color? debitColor,
    Color? creditColor,
    Color? badgeColor,
    Color? badgeTextColor,
    double? headerHeight,
    double? marginTop,
    double? marginBottom,
    double? marginLeft,
    double? marginRight,
    double? sectionSpacing,
    double? signatureBlockHeight,
    double? titleFontSize,
    double? subtitleFontSize,
    double? bodyFontSize,
    double? smallFontSize,
    double? tableFontSize,
    bool? showBorder,
    bool? showServiceIdBadge,
    bool? showCopyLabel,
    bool? showWatermark,
    String? watermarkText,
    double? borderWidth,
    double? headerBorderRadius,
    double? cellPadding,
  }) {
    return GeniusPdfVoucherStyle(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      headerTextColor: headerTextColor ?? this.headerTextColor,
      borderColor: borderColor ?? this.borderColor,
      tableHeaderColor: tableHeaderColor ?? this.tableHeaderColor,
      tableHeaderTextColor: tableHeaderTextColor ?? this.tableHeaderTextColor,
      tableAltRowColor: tableAltRowColor ?? this.tableAltRowColor,
      accentColor: accentColor ?? this.accentColor,
      amountHighlightColor: amountHighlightColor ?? this.amountHighlightColor,
      debitColor: debitColor ?? this.debitColor,
      creditColor: creditColor ?? this.creditColor,
      badgeColor: badgeColor ?? this.badgeColor,
      badgeTextColor: badgeTextColor ?? this.badgeTextColor,
      headerHeight: headerHeight ?? this.headerHeight,
      marginTop: marginTop ?? this.marginTop,
      marginBottom: marginBottom ?? this.marginBottom,
      marginLeft: marginLeft ?? this.marginLeft,
      marginRight: marginRight ?? this.marginRight,
      sectionSpacing: sectionSpacing ?? this.sectionSpacing,
      signatureBlockHeight: signatureBlockHeight ?? this.signatureBlockHeight,
      titleFontSize: titleFontSize ?? this.titleFontSize,
      subtitleFontSize: subtitleFontSize ?? this.subtitleFontSize,
      bodyFontSize: bodyFontSize ?? this.bodyFontSize,
      smallFontSize: smallFontSize ?? this.smallFontSize,
      tableFontSize: tableFontSize ?? this.tableFontSize,
      showBorder: showBorder ?? this.showBorder,
      showServiceIdBadge: showServiceIdBadge ?? this.showServiceIdBadge,
      showCopyLabel: showCopyLabel ?? this.showCopyLabel,
      showWatermark: showWatermark ?? this.showWatermark,
      watermarkText: watermarkText ?? this.watermarkText,
      borderWidth: borderWidth ?? this.borderWidth,
      headerBorderRadius: headerBorderRadius ?? this.headerBorderRadius,
      cellPadding: cellPadding ?? this.cellPadding,
    );
  }
}
