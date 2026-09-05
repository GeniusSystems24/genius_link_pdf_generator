part of '../pdf_print_theme.dart';

class GeniusPdfPrintTypography {
  const GeniusPdfPrintTypography({
    required this.titleSize,
    required this.headingSize,
    required this.subheadingSize,
    required this.bodySize,
    required this.captionSize,
    required this.smallSize,
    required this.lineHeight,
    required this.paragraphSpacing,
    required this.letterSpacing,
  });

  /// Default typography settings.
  const GeniusPdfPrintTypography.defaults()
      : titleSize = 18,
        headingSize = 14,
        subheadingSize = 12,
        bodySize = 10,
        captionSize = 9,
        smallSize = 8,
        lineHeight = 1.4,
        paragraphSpacing = 8,
        letterSpacing = 0;

  /// Corporate typography (slightly larger).
  const GeniusPdfPrintTypography.corporate()
      : titleSize = 20,
        headingSize = 16,
        subheadingSize = 13,
        bodySize = 11,
        captionSize = 9,
        smallSize = 8,
        lineHeight = 1.5,
        paragraphSpacing = 10,
        letterSpacing = 0;

  /// Minimal typography (compact).
  const GeniusPdfPrintTypography.minimal()
      : titleSize = 16,
        headingSize = 12,
        subheadingSize = 10,
        bodySize = 9,
        captionSize = 8,
        smallSize = 7,
        lineHeight = 1.3,
        paragraphSpacing = 6,
        letterSpacing = 0;

  /// Arabic typography (optimized for RTL).
  const GeniusPdfPrintTypography.arabic()
      : titleSize = 18,
        headingSize = 14,
        subheadingSize = 12,
        bodySize = 11,
        captionSize = 9,
        smallSize = 8,
        lineHeight = 1.6,
        paragraphSpacing = 10,
        letterSpacing = 0;

  final double titleSize;
  final double headingSize;
  final double subheadingSize;
  final double bodySize;
  final double captionSize;
  final double smallSize;
  final double lineHeight;
  final double paragraphSpacing;
  final double letterSpacing;

  /// Creates text styles based on typography settings.
  GeniusPdfTextStyle titleStyle({Color? color}) => GeniusPdfTextStyle(
        fontSize: titleSize,
        fontWeight: material.FontWeight.bold,
        color: color ?? const Color(0xFF212121),
        lineSpacing: lineHeight,
      );

  GeniusPdfTextStyle headingStyle({Color? color}) => GeniusPdfTextStyle(
        fontSize: headingSize,
        fontWeight: material.FontWeight.bold,
        color: color ?? const Color(0xFF212121),
        lineSpacing: lineHeight,
      );

  GeniusPdfTextStyle subheadingStyle({Color? color}) => GeniusPdfTextStyle(
        fontSize: subheadingSize,
        fontWeight: material.FontWeight.w500,
        color: color ?? const Color(0xFF424242),
        lineSpacing: lineHeight,
      );

  GeniusPdfTextStyle bodyStyle({Color? color}) => GeniusPdfTextStyle(
        fontSize: bodySize,
        fontWeight: material.FontWeight.normal,
        color: color ?? const Color(0xFF212121),
        lineSpacing: lineHeight,
      );

  GeniusPdfTextStyle captionStyle({Color? color}) => GeniusPdfTextStyle(
        fontSize: captionSize,
        fontWeight: material.FontWeight.normal,
        color: color ?? const Color(0xFF757575),
        lineSpacing: lineHeight,
      );

  GeniusPdfTextStyle smallStyle({Color? color}) => GeniusPdfTextStyle(
        fontSize: smallSize,
        fontWeight: material.FontWeight.normal,
        color: color ?? const Color(0xFF9E9E9E),
        lineSpacing: lineHeight,
      );

  GeniusPdfPrintTypography copyWith({
    double? titleSize,
    double? headingSize,
    double? subheadingSize,
    double? bodySize,
    double? captionSize,
    double? smallSize,
    double? lineHeight,
    double? paragraphSpacing,
    double? letterSpacing,
  }) {
    return GeniusPdfPrintTypography(
      titleSize: titleSize ?? this.titleSize,
      headingSize: headingSize ?? this.headingSize,
      subheadingSize: subheadingSize ?? this.subheadingSize,
      bodySize: bodySize ?? this.bodySize,
      captionSize: captionSize ?? this.captionSize,
      smallSize: smallSize ?? this.smallSize,
      lineHeight: lineHeight ?? this.lineHeight,
      paragraphSpacing: paragraphSpacing ?? this.paragraphSpacing,
      letterSpacing: letterSpacing ?? this.letterSpacing,
    );
  }
}

/// Spacing configuration for PDF printing.
