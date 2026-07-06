import 'package:flutter/material.dart' as material;
import 'package:syncfusion_flutter_pdf/pdf.dart';

/// Extension on Flutter's Color class to convert to PDF color format.
///
/// ## Example
/// ```dart
/// final flutterColor = Colors.blue;
/// final pdfColor = flutterColor.toPdfColor();
///
/// // Use in PDF drawing
/// graphics.drawRectangle(
///   brush: PdfSolidBrush(pdfColor),
///   bounds: rect,
/// );
/// ```
extension ColorToPdfExtension on material.Color {
  /// Converts this Flutter Color to a [PdfColor].
  ///
  /// The conversion maps the RGB components from Flutter's 0.0-1.0 range
  /// to PDF's 0-255 integer range.
  PdfColor toPdfColor() {
    return PdfColor(
      (r * 255).round(),
      (g * 255).round(),
      (b * 255).round(),
      (a * 255).round(),
    );
  }

  /// Creates a [PdfBrush] from this color.
  PdfBrush toPdfBrush() => PdfSolidBrush(toPdfColor());

  /// Creates a [PdfPen] from this color.
  PdfPen toPdfPen({
    double width = 1.0,
    PdfDashStyle dashStyle = PdfDashStyle.solid,
  }) {
    return PdfPen(toPdfColor(), width: width, dashStyle: dashStyle);
  }
}

/// Extension on Flutter's Color class for additional PDF utilities.
extension PdfColorUtilities on material.Color {
  /// Creates a lighter version of this color for PDF.
  PdfColor toPdfLightColor([double amount = 0.1]) {
    final hsl = material.HSLColor.fromColor(this);
    final lightened = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0).toDouble(),
    );
    return lightened.toColor().toPdfColor();
  }

  /// Creates a darker version of this color for PDF.
  PdfColor toPdfDarkColor([double amount = 0.1]) {
    final hsl = material.HSLColor.fromColor(this);
    final darkened = hsl.withLightness(
      (hsl.lightness - amount).clamp(0.0, 1.0).toDouble(),
    );
    return darkened.toColor().toPdfColor();
  }
}
