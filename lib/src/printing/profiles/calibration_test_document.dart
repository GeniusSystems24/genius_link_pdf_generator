
import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../builders/pdf_document_builder.dart';
import '../../core/pdf_config.dart';
import 'print_profile.dart';

/// S11 calibration test page for labels/pre-printed/thermal profiles.
///
/// It draws physical rulers, a 10mm grid, corner markers, profile safe-area and
/// calibration offsets. Use a physical print at 100% scale to measure drift.
class GeniusPdfCalibrationTestDocument extends GeniusPdfDocumentBuilder {
  GeniusPdfCalibrationTestDocument({
    required GeniusPdfConfig config,
    required this.profile,
  }) : super(profile.apply(config));

  final GeniusPdfPrintProfile profile;

  @override
  void build() {
    final page = newPage();
    final size = page.getClientSize();
    final graphics = page.graphics;

    const tenMm = 10 * GeniusPdfPrintProfile.pointsPerMillimeter;
    final pen = PdfPen(PdfColor(205, 205, 205), width: 0.25);
    final majorPen = PdfPen(PdfColor(90, 90, 90), width: 0.5);

    for (double x = 0; x <= size.width; x += tenMm) {
      graphics.drawLine(
        x == 0 ? majorPen : pen,
        Offset(x, 0),
        Offset(x, size.height),
      );
    }

    for (double y = 0; y <= size.height; y += tenMm) {
      graphics.drawLine(
        y == 0 ? majorPen : pen,
        Offset(0, y),
        Offset(size.width, y),
      );
    }

    _cross(
      graphics,
      Offset(
        profile.calibration.offset.dx,
        profile.calibration.offset.dy,
      ),
    );
    _cross(
      graphics,
      Offset(size.width / 2, size.height / 2),
    );
    _cross(
      graphics,
      Offset(size.width - 1, size.height - 1),
    );

    final safe = profile.safeArea;
    final safeBounds = Rect.fromLTWH(
      safe.left,
      safe.top,
      (size.width - safe.horizontal)
          .clamp(0.0, size.width)
          .toDouble(),
      (size.height - safe.vertical)
          .clamp(0.0, size.height)
          .toDouble(),
    );
    graphics.drawRectangle(
      pen: PdfPen(PdfColor(30, 120, 200), width: 0.6),
      bounds: safeBounds,
    );

    addTextAt(
      'Profile: ${profile.id}',
      x: 4,
      y: 4,
      font: config.smallFont,
      format: PdfStringFormat(
        textDirection: PdfTextDirection.leftToRight,
      ),
    );
    addTextAt(
      'Offset: ${profile.calibration.offset.dx.toStringAsFixed(2)}, '
      '${profile.calibration.offset.dy.toStringAsFixed(2)} pt',
      x: 4,
      y: 18,
      font: config.smallFont,
      format: PdfStringFormat(
        textDirection: PdfTextDirection.leftToRight,
      ),
    );
    addTextAt(
      'Scale: ${profile.calibration.scaleX.toStringAsFixed(4)} × '
      '${profile.calibration.scaleY.toStringAsFixed(4)}',
      x: 4,
      y: 32,
      font: config.smallFont,
      format: PdfStringFormat(
        textDirection: PdfTextDirection.leftToRight,
      ),
    );
  }

  void _cross(PdfGraphics graphics, Offset point) {
    const radius = 6.0;
    final pen = PdfPen(PdfColor(220, 40, 40), width: 0.7);
    graphics.drawLine(
      pen,
      Offset(point.dx - radius, point.dy),
      Offset(point.dx + radius, point.dy),
    );
    graphics.drawLine(
      pen,
      Offset(point.dx, point.dy - radius),
      Offset(point.dx, point.dy + radius),
    );
  }
}
