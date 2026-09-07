
import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../presentation/document/builders/pdf_document_builder.dart';
import '../../../core/directionality.dart';
import '../../../core/pdf_config.dart';
import 'print_profile.dart';

/// Physical anchor on pre-printed paper.
///
/// x/y are always measured from the physical page origin after profile
/// calibration. They are never mirrored in RTL.
class GeniusPdfPreprintedFieldAnchor {
  const GeniusPdfPreprintedFieldAnchor({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  })  : assert(width > 0),
        assert(height > 0);

  final double x;
  final double y;
  final double width;
  final double height;
}

/// One anchored pre-printed text field.
class GeniusPdfPreprintedField {
  const GeniusPdfPreprintedField({
    required this.id,
    required this.value,
    required this.anchor,
    this.direction = GeniusPdfDirection.auto,
    this.structuredValue = false,
    this.fontSize,
  });

  final String id;
  final String value;
  final GeniusPdfPreprintedFieldAnchor anchor;

  /// Text direction only. It never changes [anchor] coordinates.
  final GeniusPdfDirection direction;

  /// Structured values (IDs, dates, money, phone, email) stay LTR.
  final bool structuredValue;

  final double? fontSize;
}

GeniusPdfConfig _preprintedConfig(
  GeniusPdfConfig config,
  GeniusPdfPrintProfile profile,
) {
  if (!profile.isPrePrinted || !profile.physicalPlacement) {
    throw ArgumentError.value(
      profile.kind,
      'profile',
      'Pre-printed forms require a physical prePrinted profile.',
    );
  }
  return profile.apply(config);
}

/// S11 pre-printed form engine.
///
/// This is the explicit physical-coordinate opt-in requested by S11. RTL does
/// not mirror field x/y positions. Only text direction inside each anchor is
/// resolved.
class GeniusPdfPreprintedFormDocument extends GeniusPdfDocumentBuilder {
  GeniusPdfPreprintedFormDocument({
    required GeniusPdfConfig config,
    required this.profile,
    required this.fields,
    this.debugAnchors = false,
  }) : super(_preprintedConfig(config, profile));

  final GeniusPdfPrintProfile profile;
  final List<GeniusPdfPreprintedField> fields;
  final bool debugAnchors;

  @override
  void build() {
    final page = newPage();

    for (final field in fields) {
      final calibration = profile.calibration;
      final anchor = field.anchor;

      // Physical placement: intentionally no logicalStartX/logicalEndX and no
      // RTL mirroring. Calibration offsets/scales are the only transforms.
      final bounds = Rect.fromLTWH(
        calibration.offset.dx + anchor.x * calibration.scaleX,
        calibration.offset.dy + anchor.y * calibration.scaleY,
        anchor.width * calibration.scaleX,
        anchor.height * calibration.scaleY,
      );

      if (debugAnchors) {
        page.graphics.drawRectangle(
          pen: PdfPen(PdfColor(200, 60, 60), width: 0.4),
          bounds: bounds,
        );
      }

      final resolvedDirection = field.structuredValue
          ? GeniusPdfResolvedDirection.ltr
          : switch (field.direction) {
              GeniusPdfDirection.ltr => GeniusPdfResolvedDirection.ltr,
              GeniusPdfDirection.rtl => GeniusPdfResolvedDirection.rtl,
              GeniusPdfDirection.auto => resolvedLayoutDirection,
            };

      page.graphics.drawString(
        field.value,
        field.fontSize == null
            ? config.baseFont
            : config.fontBuild(fontSize: field.fontSize!),
        brush: PdfBrushes.black,
        bounds: bounds,
        format: PdfStringFormat(
          alignment: resolvedDirection == GeniusPdfResolvedDirection.rtl
              ? PdfTextAlignment.right
              : PdfTextAlignment.left,
          textDirection:
              resolvedDirection == GeniusPdfResolvedDirection.rtl
                  ? PdfTextDirection.rightToLeft
                  : PdfTextDirection.leftToRight,
        ),
      );
    }
  }
}
