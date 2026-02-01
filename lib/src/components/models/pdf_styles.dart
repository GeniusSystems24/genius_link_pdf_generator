import 'dart:ui';

import 'package:flutter/material.dart' as material;
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../extensions/color_extensions.dart';

/// Text alignment options for PDF components.
enum GeniusPdfTextAlign {
  start,
  center,
  end,
  justify;

  PdfTextAlignment toPdfTextAlignment(bool isRTL) {
    switch (this) {
      case GeniusPdfTextAlign.start:
      case GeniusPdfTextAlign.justify:
        return isRTL ? PdfTextAlignment.right : PdfTextAlignment.left;
      case GeniusPdfTextAlign.end:
        return isRTL ? PdfTextAlignment.left : PdfTextAlignment.right;
      case GeniusPdfTextAlign.center:
        return PdfTextAlignment.center;
    }
  }
}

/// Vertical alignment options for PDF cells.
enum GeniusPdfVerticalAlign {
  top,
  middle,
  bottom,
}

/// Extension to convert [GeniusPdfTextAlign] to Syncfusion's [PdfTextAlignment].
extension GeniusPdfTextAlignExtension on GeniusPdfTextAlign {
  PdfTextAlignment toPdfTextAlignment() {
    switch (this) {
      case GeniusPdfTextAlign.start:
        return PdfTextAlignment.left;
      case GeniusPdfTextAlign.center:
        return PdfTextAlignment.center;
      case GeniusPdfTextAlign.end:
        return PdfTextAlignment.right;
      case GeniusPdfTextAlign.justify:
        return PdfTextAlignment.justify;
    }
  }
}

/// Extension to convert [GeniusPdfVerticalAlign] to Syncfusion's [PdfVerticalAlignment].
extension GeniusPdfVerticalAlignExtension on GeniusPdfVerticalAlign {
  PdfVerticalAlignment toPdfVerticalAlignment() {
    switch (this) {
      case GeniusPdfVerticalAlign.top:
        return PdfVerticalAlignment.top;
      case GeniusPdfVerticalAlign.middle:
        return PdfVerticalAlignment.middle;
      case GeniusPdfVerticalAlign.bottom:
        return PdfVerticalAlignment.bottom;
    }
  }
}

/// Border style configuration for PDF components.
class GeniusPdfBorderStyle {
  const GeniusPdfBorderStyle({
    this.width = 0.5,
    this.color = const Color(0xFF000000),
    this.dashStyle = PdfDashStyle.solid,
    this.left = true,
    this.right = true,
    this.top = true,
    this.bottom = true,
  });

  /// Creates a border with all sides.
  const GeniusPdfBorderStyle.all({
    this.width = 0.5,
    this.color = const Color(0xFF000000),
    this.dashStyle = PdfDashStyle.solid,
  })  : left = true,
        right = true,
        top = true,
        bottom = true;

  /// Creates a border with no sides.
  const GeniusPdfBorderStyle.none()
      : width = 0,
        color = const Color(0x00000000),
        dashStyle = PdfDashStyle.solid,
        left = false,
        right = false,
        top = false,
        bottom = false;

  /// Creates a border with only horizontal sides.
  const GeniusPdfBorderStyle.horizontal({
    this.width = 0.5,
    this.color = const Color(0xFF000000),
    this.dashStyle = PdfDashStyle.solid,
  })  : left = false,
        right = false,
        top = true,
        bottom = true;

  /// Creates a border with only vertical sides.
  const GeniusPdfBorderStyle.vertical({
    this.width = 0.5,
    this.color = const Color(0xFF000000),
    this.dashStyle = PdfDashStyle.solid,
  })  : left = true,
        right = true,
        top = false,
        bottom = false;

  /// Creates a bottom-only border.
  const GeniusPdfBorderStyle.bottom({
    this.width = 0.5,
    this.color = const Color(0xFF000000),
    this.dashStyle = PdfDashStyle.solid,
  })  : left = false,
        right = false,
        top = false,
        bottom = true;

  /// Creates a top-only border.
  const GeniusPdfBorderStyle.top({
    this.width = 0.5,
    this.color = const Color(0xFF000000),
    this.dashStyle = PdfDashStyle.solid,
  })  : left = false,
        right = false,
        top = true,
        bottom = false;

  final double width;
  final Color color;
  final PdfDashStyle dashStyle;
  final bool left;
  final bool right;
  final bool top;
  final bool bottom;

  /// Creates a [PdfPen] from this border style.
  PdfPen toPen() => PdfPen(
        color.toPdfColor(),
        width: width,
        dashStyle: dashStyle,
      );

  /// Creates a [PdfBorders] for grid cells.
  PdfBorders toPdfBorders() {
    final pen = toPen();
    final noPen = PdfPen(PdfColor(0, 0, 0, 0), width: 0);

    return PdfBorders(
      left: left ? pen : noPen,
      right: right ? pen : noPen,
      top: top ? pen : noPen,
      bottom: bottom ? pen : noPen,
    );
  }

  GeniusPdfBorderStyle copyWith({
    double? width,
    Color? color,
    PdfDashStyle? dashStyle,
    bool? left,
    bool? right,
    bool? top,
    bool? bottom,
  }) {
    return GeniusPdfBorderStyle(
      width: width ?? this.width,
      color: color ?? this.color,
      dashStyle: dashStyle ?? this.dashStyle,
      left: left ?? this.left,
      right: right ?? this.right,
      top: top ?? this.top,
      bottom: bottom ?? this.bottom,
    );
  }
}

/// Text style configuration for PDF text elements.
class GeniusPdfTextStyle {
  const GeniusPdfTextStyle({
    this.fontSize = 10,
    this.fontWeight = material.FontWeight.normal,
    this.color = const Color(0xFF000000),
    this.alignment = GeniusPdfTextAlign.start,
    this.verticalAlignment = GeniusPdfVerticalAlign.middle,
    this.lineSpacing = 1.0,
  });

  /// Creates a header text style.
  const GeniusPdfTextStyle.header({
    this.fontSize = 14,
    this.color = const Color(0xFF000000),
    this.alignment = GeniusPdfTextAlign.center,
  })  : fontWeight = material.FontWeight.bold,
        verticalAlignment = GeniusPdfVerticalAlign.middle,
        lineSpacing = 1.0;

  /// Creates a title text style.
  const GeniusPdfTextStyle.title({
    this.fontSize = 18,
    this.color = const Color(0xFF000000),
    this.alignment = GeniusPdfTextAlign.center,
  })  : fontWeight = material.FontWeight.bold,
        verticalAlignment = GeniusPdfVerticalAlign.middle,
        lineSpacing = 1.0;

  /// Creates a subtitle text style.
  const GeniusPdfTextStyle.subtitle({
    this.fontSize = 12,
    this.color = const Color(0xFF666666),
    this.alignment = GeniusPdfTextAlign.center,
  })  : fontWeight = material.FontWeight.normal,
        verticalAlignment = GeniusPdfVerticalAlign.middle,
        lineSpacing = 1.0;

  /// Creates a body text style.
  const GeniusPdfTextStyle.body({
    this.fontSize = 10,
    this.color = const Color(0xFF000000),
    this.alignment = GeniusPdfTextAlign.start,
  })  : fontWeight = material.FontWeight.normal,
        verticalAlignment = GeniusPdfVerticalAlign.middle,
        lineSpacing = 1.0;

  /// Creates a caption/small text style.
  const GeniusPdfTextStyle.caption({
    this.fontSize = 8,
    this.color = const Color(0xFF666666),
    this.alignment = GeniusPdfTextAlign.start,
  })  : fontWeight = material.FontWeight.normal,
        verticalAlignment = GeniusPdfVerticalAlign.middle,
        lineSpacing = 1.0;

  final double fontSize;
  final material.FontWeight fontWeight;
  final Color color;
  final GeniusPdfTextAlign alignment;
  final GeniusPdfVerticalAlign verticalAlignment;
  final double lineSpacing;

  bool get isBold =>
      fontWeight == material.FontWeight.bold ||
      fontWeight == material.FontWeight.w700 ||
      fontWeight == material.FontWeight.w800 ||
      fontWeight == material.FontWeight.w900;

  /// Creates a [PdfBrush] from this style's color.
  PdfBrush toBrush() => PdfSolidBrush(color.toPdfColor());

  /// Creates a [PdfStringFormat] from this style.
  PdfStringFormat toStringFormat({TextDirection? textDirection}) {
    return PdfStringFormat(
      alignment:
          alignment.toPdfTextAlignment(textDirection == TextDirection.rtl),
      lineAlignment: verticalAlignment.toPdfVerticalAlignment(),
      textDirection: textDirection == TextDirection.rtl
          ? PdfTextDirection.rightToLeft
          : PdfTextDirection.leftToRight,
      lineSpacing: lineSpacing,
    );
  }

  GeniusPdfTextStyle copyWith({
    double? fontSize,
    material.FontWeight? fontWeight,
    Color? color,
    GeniusPdfTextAlign? alignment,
    GeniusPdfVerticalAlign? verticalAlignment,
    double? lineSpacing,
  }) {
    return GeniusPdfTextStyle(
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      color: color ?? this.color,
      alignment: alignment ?? this.alignment,
      verticalAlignment: verticalAlignment ?? this.verticalAlignment,
      lineSpacing: lineSpacing ?? this.lineSpacing,
    );
  }
}

/// Cell style configuration for grid cells.
class GeniusPdfCellStyle {
  const GeniusPdfCellStyle({
    this.textStyle = const GeniusPdfTextStyle(),
    this.backgroundColor,
    this.border = const GeniusPdfBorderStyle.all(),
    this.padding = const GeniusPdfCellPadding.all(4),
  });

  /// Creates a header cell style.
  const GeniusPdfCellStyle.header({
    this.textStyle = const GeniusPdfTextStyle.header(),
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.border = const GeniusPdfBorderStyle.all(),
    this.padding = const GeniusPdfCellPadding.all(6),
  });

  /// Creates an alternating row style (even rows).
  const GeniusPdfCellStyle.alternateEven({
    this.textStyle = const GeniusPdfTextStyle.body(),
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.border = const GeniusPdfBorderStyle.all(),
    this.padding = const GeniusPdfCellPadding.all(4),
  });

  /// Creates an alternating row style (odd rows).
  const GeniusPdfCellStyle.alternateOdd({
    this.textStyle = const GeniusPdfTextStyle.body(),
    this.backgroundColor,
    this.border = const GeniusPdfBorderStyle.all(),
    this.padding = const GeniusPdfCellPadding.all(4),
  });

  /// Creates a total/summary row style.
  const GeniusPdfCellStyle.total({
    this.textStyle = const GeniusPdfTextStyle(
      fontSize: 10,
      fontWeight: material.FontWeight.bold,
    ),
    this.backgroundColor = const Color(0xFFE8E8E8),
    this.border = const GeniusPdfBorderStyle.all(width: 1),
    this.padding = const GeniusPdfCellPadding.all(5),
  });

  final GeniusPdfTextStyle textStyle;
  final Color? backgroundColor;
  final GeniusPdfBorderStyle border;
  final GeniusPdfCellPadding padding;

  GeniusPdfCellStyle copyWith({
    GeniusPdfTextStyle? textStyle,
    Color? backgroundColor,
    GeniusPdfBorderStyle? border,
    GeniusPdfCellPadding? padding,
  }) {
    return GeniusPdfCellStyle(
      textStyle: textStyle ?? this.textStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      border: border ?? this.border,
      padding: padding ?? this.padding,
    );
  }
}

/// Padding configuration for cells.
class GeniusPdfCellPadding {
  const GeniusPdfCellPadding({
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
  });

  const GeniusPdfCellPadding.all(double value)
      : left = value,
        right = value,
        top = value,
        bottom = value;

  const GeniusPdfCellPadding.symmetric({
    double horizontal = 0,
    double vertical = 0,
  })  : left = horizontal,
        right = horizontal,
        top = vertical,
        bottom = vertical;

  final double left;
  final double right;
  final double top;
  final double bottom;

  /// Converts to [PdfPaddings] for grid cells.
  PdfPaddings toPdfPaddings() => PdfPaddings(
        left: left,
        right: right,
        top: top,
        bottom: bottom,
      );
}

/// Predefined color schemes for PDF reports.
class GeniusPdfColorScheme {
  const GeniusPdfColorScheme({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.headerBackground,
    required this.headerText,
    required this.alternateRowBackground,
    required this.borderColor,
    required this.positiveAmount,
    required this.negativeAmount,
  });

  /// Default color scheme (blue-based).
  static const GeniusPdfColorScheme defaultScheme = GeniusPdfColorScheme(
    primary: Color(0xFF1565C0),
    secondary: Color(0xFF424242),
    accent: Color(0xFF0D47A1),
    headerBackground: Color(0xFFE3F2FD),
    headerText: Color(0xFF1565C0),
    alternateRowBackground: Color(0xFFFAFAFA),
    borderColor: Color(0xFFBDBDBD),
    positiveAmount: Color(0xFF2E7D32),
    negativeAmount: Color(0xFFC62828),
  );

  /// Professional gray scheme.
  static const GeniusPdfColorScheme professional = GeniusPdfColorScheme(
    primary: Color(0xFF37474F),
    secondary: Color(0xFF607D8B),
    accent: Color(0xFF263238),
    headerBackground: Color(0xFFECEFF1),
    headerText: Color(0xFF263238),
    alternateRowBackground: Color(0xFFFAFAFA),
    borderColor: Color(0xFF90A4AE),
    positiveAmount: Color(0xFF388E3C),
    negativeAmount: Color(0xFFD32F2F),
  );

  /// Arabic/Saudi style scheme (green-based).
  static const GeniusPdfColorScheme saudi = GeniusPdfColorScheme(
    primary: Color(0xFF006C35),
    secondary: Color(0xFF004D40),
    accent: Color(0xFF00897B),
    headerBackground: Color(0xFFE8F5E9),
    headerText: Color(0xFF1B5E20),
    alternateRowBackground: Color(0xFFF1F8E9),
    borderColor: Color(0xFF81C784),
    positiveAmount: Color(0xFF2E7D32),
    negativeAmount: Color(0xFFC62828),
  );

  final Color primary;
  final Color secondary;
  final Color accent;
  final Color headerBackground;
  final Color headerText;
  final Color alternateRowBackground;
  final Color borderColor;
  final Color positiveAmount;
  final Color negativeAmount;
}
