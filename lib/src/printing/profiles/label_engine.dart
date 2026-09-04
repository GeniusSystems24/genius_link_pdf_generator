
import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../components/components.dart';
import '../../core/directionality.dart';
import '../../core/pdf_config.dart';
import '../../families/erp/erp_families.dart';
import 'print_profile.dart';

/// Data for one ERP/product label.
class GeniusPdfLabelData {
  const GeniusPdfLabelData({
    required this.title,
    this.titleAr,
    this.sku,
    this.batch,
    this.serial,
    this.expiry,
    this.barcodeData,
    this.qrData,
    this.customFields = const {},
  });

  final String title;
  final String? titleAr;
  final String? sku;
  final String? batch;
  final String? serial;
  final DateTime? expiry;
  final String? barcodeData;
  final String? qrData;
  final Map<String, String> customFields;
}

GeniusPdfConfig _labelConfig(
  GeniusPdfConfig config,
  GeniusPdfPrintProfile profile,
) {
  if (!profile.isLabel) {
    throw ArgumentError.value(
      profile.kind,
      'profile',
      'Label documents require customLabel or labelSheet profile.',
    );
  }
  return profile.apply(config);
}

/// S11 single-label and label-sheet renderer.
///
/// Sheet cell geometry stays physical and deterministic. RTL changes text
/// direction inside a label; it does not reverse sheet calibration geometry.
class GeniusPdfLabelPrintDocument extends GeniusErpLabelDocument {
  GeniusPdfLabelPrintDocument({
    required GeniusPdfConfig config,
    required this.profile,
    required this.labels,
  }) : super(_labelConfig(config, profile));

  final GeniusPdfPrintProfile profile;
  final List<GeniusPdfLabelData> labels;

  @override
  void build() {
    final spec = profile.labelSheet;
    if (spec == null) {
      throw StateError(
        'Label profile is missing GeniusPdfLabelSheetSpec.',
      );
    }

    if (labels.isEmpty) {
      newPage();
      return;
    }

    final perPage = spec.labelsPerSheet;
    var labelIndex = 0;

    while (labelIndex < labels.length) {
      final page = newPage();

      for (var cell = 0;
          cell < perPage && labelIndex < labels.length;
          cell++) {
        final row = cell ~/ spec.columns;
        final column = cell % spec.columns;

        final x = profile.safeArea.left +
            profile.calibration.offset.dx +
            column * (spec.labelWidth + spec.horizontalGap);
        final y = profile.safeArea.top +
            profile.calibration.offset.dy +
            row * (spec.labelHeight + spec.verticalGap);

        _drawLabel(
          page,
          labels[labelIndex],
          Rect.fromLTWH(
            x,
            y,
            spec.labelWidth * profile.calibration.scaleX,
            spec.labelHeight * profile.calibration.scaleY,
          ),
          bleed: spec.bleed,
        );
        labelIndex++;
      }
    }
  }

  void _drawLabel(
    PdfPage page,
    GeniusPdfLabelData data,
    Rect bounds, {
    required double bleed,
  }) {
    final safeBleed = bleed.clamp(
      0.0,
      (bounds.shortestSide / 4).clamp(0.0, 20.0),
    ).toDouble();

    final content = Rect.fromLTWH(
      bounds.left + safeBleed,
      bounds.top + safeBleed,
      bounds.width - safeBleed * 2,
      bounds.height - safeBleed * 2,
    );

    page.graphics.drawRectangle(
      pen: PdfPen(PdfColor(180, 180, 180), width: 0.4),
      bounds: bounds,
    );

    final title = config.isRTL
        ? (data.titleAr ?? data.title)
        : data.title;

    var y = content.top + 3;

    y = _drawText(
      page,
      title,
      Rect.fromLTWH(
        content.left + 3,
        y,
        content.width - 6,
        28,
      ),
      font: config.boldFont,
      direction: resolvedLayoutDirection,
      alignment: PdfTextAlignment.center,
    );

    if (data.sku != null && data.sku!.isNotEmpty) {
      y = _drawStructuredField(
        page,
        label: config.isRTL ? 'SKU' : 'SKU',
        value: data.sku!,
        bounds: Rect.fromLTWH(
          content.left + 3,
          y + 2,
          content.width - 6,
          18,
        ),
      );
    }

    if (data.batch != null && data.batch!.isNotEmpty) {
      y = _drawStructuredField(
        page,
        label: config.isRTL ? 'الدفعة' : 'Batch',
        value: data.batch!,
        bounds: Rect.fromLTWH(
          content.left + 3,
          y + 1,
          content.width - 6,
          18,
        ),
      );
    }

    if (data.serial != null && data.serial!.isNotEmpty) {
      y = _drawStructuredField(
        page,
        label: config.isRTL ? 'التسلسلي' : 'Serial',
        value: data.serial!,
        bounds: Rect.fromLTWH(
          content.left + 3,
          y + 1,
          content.width - 6,
          18,
        ),
      );
    }

    if (data.expiry != null) {
      y = _drawStructuredField(
        page,
        label: config.isRTL ? 'الصلاحية' : 'Expiry',
        value: config.formatter.formatDate(data.expiry!),
        bounds: Rect.fromLTWH(
          content.left + 3,
          y + 1,
          content.width - 6,
          18,
        ),
      );
    }

    for (final entry in data.customFields.entries) {
      if (y + 18 > content.bottom) break;
      y = _drawStructuredField(
        page,
        label: entry.key,
        value: entry.value,
        bounds: Rect.fromLTWH(
          content.left + 3,
          y + 1,
          content.width - 6,
          18,
        ),
      );
    }

    final remainingHeight = content.bottom - y - 3;
    if (remainingHeight <= 24) return;

    if (data.qrData != null && data.qrData!.isNotEmpty) {
      final size = remainingHeight
          .clamp(24.0, content.width * 0.58)
          .toDouble();
      final qr = GeniusPdfQRCodeGenerator(
        data: data.qrData!,
        caption: 'QR',
        captionAr: 'QR',
        config: config,
        directionality: directionality,
      );
      qr.draw(
        page: page,
        bounds: Rect.fromLTWH(
          content.left,
          y,
          content.width,
          size,
        ),
      );
      return;
    }

    if (data.barcodeData != null &&
        data.barcodeData!.isNotEmpty) {
      final barcode = GeniusPdfBarcode(
        data: data.barcodeData!,
        type: GeniusBarcodeType.code128,
        caption: data.sku ?? data.barcodeData!,
        captionAr: data.sku ?? data.barcodeData!,
        config: config,
        directionality: directionality,
        height: remainingHeight,
      );
      barcode.draw(
        page: page,
        bounds: Rect.fromLTWH(
          content.left,
          y,
          content.width,
          remainingHeight,
        ),
      );
    }
  }

  double _drawStructuredField(
    PdfPage page, {
    required String label,
    required String value,
    required Rect bounds,
  }) {
    final isRtl =
        resolvedLayoutDirection == GeniusPdfResolvedDirection.rtl;
    final labelWidth = bounds.width * 0.42;
    final valueWidth = bounds.width - labelWidth;

    final labelBounds = Rect.fromLTWH(
      isRtl ? bounds.right - labelWidth : bounds.left,
      bounds.top,
      labelWidth,
      bounds.height,
    );
    final valueBounds = Rect.fromLTWH(
      isRtl ? bounds.left : bounds.left + labelWidth,
      bounds.top,
      valueWidth,
      bounds.height,
    );

    page.graphics.drawString(
      label,
      config.smallFont,
      bounds: labelBounds,
      brush: PdfBrushes.black,
      format: PdfStringFormat(
        alignment:
            isRtl ? PdfTextAlignment.right : PdfTextAlignment.left,
        textDirection: isRtl
            ? PdfTextDirection.rightToLeft
            : PdfTextDirection.leftToRight,
      ),
    );

    // SKU/batch/serial/date values are structured runs and remain LTR.
    page.graphics.drawString(
      value,
      config.smallFont,
      bounds: valueBounds,
      brush: PdfBrushes.black,
      format: PdfStringFormat(
        alignment:
            isRtl ? PdfTextAlignment.left : PdfTextAlignment.right,
        textDirection: PdfTextDirection.leftToRight,
      ),
    );

    return bounds.bottom;
  }

  double _drawText(
    PdfPage page,
    String text,
    Rect bounds, {
    required PdfFont font,
    required GeniusPdfResolvedDirection direction,
    required PdfTextAlignment alignment,
  }) {
    final result = PdfTextElement(
      text: text,
      font: font,
      format: PdfStringFormat(
        alignment: alignment,
        textDirection: direction == GeniusPdfResolvedDirection.rtl
            ? PdfTextDirection.rightToLeft
            : PdfTextDirection.leftToRight,
      ),
    ).draw(
      page: page,
      bounds: bounds,
    );
    return result?.bounds.bottom ?? (bounds.top + font.height);
  }
}
