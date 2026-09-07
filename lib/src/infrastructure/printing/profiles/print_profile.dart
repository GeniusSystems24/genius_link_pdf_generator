// ignore_for_file: sort_unnamed_constructors_first

import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../core/pdf_config.dart';
import '../../../presentation/document/families/erp/erp_families.dart';

/// Print-profile category introduced in S11.
enum GeniusPdfPrintProfileKind {
  a4Portrait,
  a4Landscape,
  a5,
  letter,
  legal,
  thermal58,
  thermal80,
  continuous,
  customLabel,
  labelSheet,
  prePrinted,
}

/// Content-density hint used by print-profile-aware engines.
enum GeniusPdfPrintDensity {
  compact,
  normal,
  comfortable,
}

/// Header/footer policy owned by a print profile.
enum GeniusPdfHeaderFooterPolicy {
  repeat,
  firstPageOnly,
  none,
}

/// Original/copy classification for print metadata.
enum GeniusPdfCopyKind {
  original,
  copy,
  reprint,
}

/// Copy metadata that can be surfaced by templates/engines.
class GeniusPdfCopyMetadata {
  const GeniusPdfCopyMetadata({
    this.kind = GeniusPdfCopyKind.original,
    this.copyNumber = 1,
    this.totalCopies = 1,
    this.originalLabel = 'Original',
    this.originalLabelAr = 'الأصل',
    this.copyLabel = 'Copy',
    this.copyLabelAr = 'نسخة',
    this.reprintLabel = 'Reprint',
    this.reprintLabelAr = 'إعادة طباعة',
  })  : assert(copyNumber > 0),
        assert(totalCopies > 0),
        assert(copyNumber <= totalCopies);

  final GeniusPdfCopyKind kind;
  final int copyNumber;
  final int totalCopies;
  final String originalLabel;
  final String originalLabelAr;
  final String copyLabel;
  final String copyLabelAr;
  final String reprintLabel;
  final String reprintLabelAr;

  String label({required bool isRtl}) {
    final base = switch (kind) {
      GeniusPdfCopyKind.original =>
        isRtl ? originalLabelAr : originalLabel,
      GeniusPdfCopyKind.copy =>
        isRtl ? copyLabelAr : copyLabel,
      GeniusPdfCopyKind.reprint =>
        isRtl ? reprintLabelAr : reprintLabel,
    };
    return totalCopies == 1
        ? base
        : '$base $copyNumber/$totalCopies';
  }
}

/// Immutable point in print coordinates.
class GeniusPdfPrintOffset {
  const GeniusPdfPrintOffset({
    this.dx = 0,
    this.dy = 0,
  });

  final double dx;
  final double dy;
}

/// Immutable edge values used by print profiles.
///
/// This intentionally does not expose mutable `PdfMargins`.
class GeniusPdfPrintInsets {
  const GeniusPdfPrintInsets({
    this.left = 0,
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
  })  : assert(left >= 0),
        assert(top >= 0),
        assert(right >= 0),
        assert(bottom >= 0);

  const GeniusPdfPrintInsets.all(double value)
      : left = value,
        top = value,
        right = value,
        bottom = value,
        assert(value >= 0);

  const GeniusPdfPrintInsets.symmetric({
    double horizontal = 0,
    double vertical = 0,
  })  : left = horizontal,
        right = horizontal,
        top = vertical,
        bottom = vertical,
        assert(horizontal >= 0),
        assert(vertical >= 0);

  final double left;
  final double top;
  final double right;
  final double bottom;

  double get horizontal => left + right;
  double get vertical => top + bottom;

  PdfMargins toPdfMargins() => PdfMargins()
    ..left = left
    ..top = top
    ..right = right
    ..bottom = bottom;
}

/// Label-sheet geometry.
class GeniusPdfLabelSheetSpec {
  const GeniusPdfLabelSheetSpec({
    required this.columns,
    required this.rows,
    required this.labelWidth,
    required this.labelHeight,
    this.horizontalGap = 0,
    this.verticalGap = 0,
    this.bleed = 0,
  })  : assert(columns > 0),
        assert(rows > 0),
        assert(labelWidth > 0),
        assert(labelHeight > 0),
        assert(horizontalGap >= 0),
        assert(verticalGap >= 0),
        assert(bleed >= 0);

  final int columns;
  final int rows;
  final double labelWidth;
  final double labelHeight;
  final double horizontalGap;
  final double verticalGap;

  /// Bleed kept inside each physical label rectangle.
  final double bleed;

  int get labelsPerSheet => columns * rows;
}

/// Calibration data applied after the profile's nominal geometry.
class GeniusPdfPrintCalibration {
  const GeniusPdfPrintCalibration({
    this.offset = const GeniusPdfPrintOffset(),
    this.scaleX = 1,
    this.scaleY = 1,
  })  : assert(scaleX > 0),
        assert(scaleY > 0);

  final GeniusPdfPrintOffset offset;
  final double scaleX;
  final double scaleY;
}

/// Complete S11 print profile.
///
/// Page geometry and calibration are immutable. `apply()` creates a new
/// `GeniusPdfConfig` and never mutates the caller's config.
class GeniusPdfPrintProfile {

  /// ISO A4 portrait.
  factory GeniusPdfPrintProfile.a4Portrait({
    GeniusPdfPrintInsets margins = const GeniusPdfPrintInsets.all(20),
    GeniusPdfPrintInsets safeArea = const GeniusPdfPrintInsets.all(4),
    double fontScale = 1,
  }) =>
      GeniusPdfPrintProfile(
        id: 'a4-portrait',
        kind: GeniusPdfPrintProfileKind.a4Portrait,
        pageSize: GeniusPdfPageSize.a4,
        margins: margins,
        safeArea: safeArea,
        fontScale: fontScale,
        description: 'A4 portrait',
      );

  /// ISO A4 landscape.
  factory GeniusPdfPrintProfile.a4Landscape({
    GeniusPdfPrintInsets margins = const GeniusPdfPrintInsets.all(20),
    GeniusPdfPrintInsets safeArea = const GeniusPdfPrintInsets.all(4),
    double fontScale = 1,
  }) =>
      GeniusPdfPrintProfile(
        id: 'a4-landscape',
        kind: GeniusPdfPrintProfileKind.a4Landscape,
        pageSize: GeniusPdfPageSize.a4,
        orientation: PdfPageOrientation.landscape,
        margins: margins,
        safeArea: safeArea,
        fontScale: fontScale,
        description: 'A4 landscape',
      );

  /// ISO A5 portrait (148 x 210 mm).
  factory GeniusPdfPrintProfile.a5({
    GeniusPdfPrintInsets margins = const GeniusPdfPrintInsets.all(16),
    GeniusPdfPrintInsets safeArea = const GeniusPdfPrintInsets.all(3),
    double fontScale = 0.92,
  }) =>
      GeniusPdfPrintProfile(
        id: 'a5',
        kind: GeniusPdfPrintProfileKind.a5,
        pageSize: const Size(420, 595),
        margins: margins,
        safeArea: safeArea,
        fontScale: fontScale,
        description: 'A5 portrait',
      );

  /// US Letter.
  factory GeniusPdfPrintProfile.letter({
    GeniusPdfPrintInsets margins = const GeniusPdfPrintInsets.all(20),
    GeniusPdfPrintInsets safeArea = const GeniusPdfPrintInsets.all(4),
  }) =>
      GeniusPdfPrintProfile(
        id: 'letter',
        kind: GeniusPdfPrintProfileKind.letter,
        pageSize: GeniusPdfPageSize.letter,
        margins: margins,
        safeArea: safeArea,
        description: 'US Letter',
      );

  /// US Legal.
  factory GeniusPdfPrintProfile.legal({
    GeniusPdfPrintInsets margins = const GeniusPdfPrintInsets.all(20),
    GeniusPdfPrintInsets safeArea = const GeniusPdfPrintInsets.all(4),
  }) =>
      GeniusPdfPrintProfile(
        id: 'legal',
        kind: GeniusPdfPrintProfileKind.legal,
        pageSize: GeniusPdfPageSize.legal,
        margins: margins,
        safeArea: safeArea,
        description: 'US Legal',
      );

  /// 58mm thermal profile.
  factory GeniusPdfPrintProfile.thermal58({
    double nominalHeight = 600,
    double marginMm = 2,
    double cutSpacingMm = 4,
  }) =>
      GeniusPdfPrintProfile(
        id: 'thermal-58mm',
        kind: GeniusPdfPrintProfileKind.thermal58,
        pageSize: Size(
          58 * pointsPerMillimeter,
          nominalHeight,
        ),
        margins: GeniusPdfPrintInsets.symmetric(
          horizontal: marginMm * pointsPerMillimeter,
          vertical: marginMm * pointsPerMillimeter,
        ),
        safeArea: const GeniusPdfPrintInsets.all(1),
        density: GeniusPdfPrintDensity.compact,
        fontScale: 0.78,
        headerFooterPolicy: GeniusPdfHeaderFooterPolicy.none,
        cutSpacing: cutSpacingMm * pointsPerMillimeter,
        description: '58mm thermal receipt',
      );

  /// 80mm thermal profile.
  factory GeniusPdfPrintProfile.thermal80({
    double nominalHeight = 700,
    double marginMm = 3,
    double cutSpacingMm = 4,
  }) =>
      GeniusPdfPrintProfile(
        id: 'thermal-80mm',
        kind: GeniusPdfPrintProfileKind.thermal80,
        pageSize: Size(
          80 * pointsPerMillimeter,
          nominalHeight,
        ),
        margins: GeniusPdfPrintInsets.symmetric(
          horizontal: marginMm * pointsPerMillimeter,
          vertical: marginMm * pointsPerMillimeter,
        ),
        safeArea: const GeniusPdfPrintInsets.all(1),
        density: GeniusPdfPrintDensity.compact,
        fontScale: 0.82,
        headerFooterPolicy: GeniusPdfHeaderFooterPolicy.none,
        cutSpacing: cutSpacingMm * pointsPerMillimeter,
        description: '80mm thermal receipt',
      );

  /// Continuous paper profile.
  factory GeniusPdfPrintProfile.continuous({
    required double width,
    required double nominalHeight,
    GeniusPdfPrintInsets margins = const GeniusPdfPrintInsets.all(8),
    double fontScale = 0.9,
  }) =>
      GeniusPdfPrintProfile(
        id: 'continuous',
        kind: GeniusPdfPrintProfileKind.continuous,
        pageSize: Size(width, nominalHeight),
        margins: margins,
        density: GeniusPdfPrintDensity.compact,
        fontScale: fontScale,
        headerFooterPolicy: GeniusPdfHeaderFooterPolicy.none,
        description: 'Continuous paper',
      );

  /// One physical custom label.
  factory GeniusPdfPrintProfile.customLabel({
    required double width,
    required double height,
    GeniusPdfPrintInsets margins = const GeniusPdfPrintInsets.all(4),
    GeniusPdfPrintInsets safeArea = const GeniusPdfPrintInsets.all(2),
    double bleed = 0,
    GeniusPdfPrintCalibration calibration = const GeniusPdfPrintCalibration(),
  }) =>
      GeniusPdfPrintProfile(
        id: 'custom-label',
        kind: GeniusPdfPrintProfileKind.customLabel,
        pageSize: Size(width, height),
        margins: margins,
        safeArea: safeArea,
        density: GeniusPdfPrintDensity.compact,
        fontScale: 0.82,
        headerFooterPolicy: GeniusPdfHeaderFooterPolicy.none,
        labelSheet: GeniusPdfLabelSheetSpec(
          columns: 1,
          rows: 1,
          labelWidth: width - margins.horizontal,
          labelHeight: height - margins.vertical,
          bleed: bleed,
        ),
        calibration: calibration,
        description: 'Custom single label',
      );

  /// Sheet of repeated labels.
  factory GeniusPdfPrintProfile.labelSheet({
    Size pageSize = GeniusPdfPageSize.a4,
    required int columns,
    required int rows,
    required double labelWidth,
    required double labelHeight,
    double horizontalGap = 0,
    double verticalGap = 0,
    double bleed = 0,
    GeniusPdfPrintInsets margins = const GeniusPdfPrintInsets.all(12),
    GeniusPdfPrintCalibration calibration = const GeniusPdfPrintCalibration(),
  }) =>
      GeniusPdfPrintProfile(
        id: 'label-sheet',
        kind: GeniusPdfPrintProfileKind.labelSheet,
        pageSize: pageSize,
        margins: margins,
        safeArea: const GeniusPdfPrintInsets(),
        density: GeniusPdfPrintDensity.compact,
        fontScale: 0.82,
        headerFooterPolicy: GeniusPdfHeaderFooterPolicy.none,
        labelGapX: horizontalGap,
        labelGapY: verticalGap,
        labelSheet: GeniusPdfLabelSheetSpec(
          columns: columns,
          rows: rows,
          labelWidth: labelWidth,
          labelHeight: labelHeight,
          horizontalGap: horizontalGap,
          verticalGap: verticalGap,
          bleed: bleed,
        ),
        calibration: calibration,
        description: 'Label sheet',
      );

  /// Pre-printed paper with explicit physical coordinates.
  factory GeniusPdfPrintProfile.prePrinted({
    Size pageSize = GeniusPdfPageSize.a4,
    PdfPageOrientation orientation = PdfPageOrientation.portrait,
    GeniusPdfPrintInsets margins = const GeniusPdfPrintInsets(),
    GeniusPdfPrintCalibration calibration = const GeniusPdfPrintCalibration(),
    int copies = 1,
  }) =>
      GeniusPdfPrintProfile(
        id: 'pre-printed',
        kind: GeniusPdfPrintProfileKind.prePrinted,
        pageSize: pageSize,
        orientation: orientation,
        margins: margins,
        safeArea: const GeniusPdfPrintInsets(),
        density: GeniusPdfPrintDensity.normal,
        headerFooterPolicy: GeniusPdfHeaderFooterPolicy.none,
        copies: copies,
        calibration: calibration,
        physicalPlacement: true,
        description: 'Pre-printed physical-coordinate form',
      );
  GeniusPdfPrintProfile({
    required this.id,
    required this.kind,
    required this.pageSize,
    this.orientation = PdfPageOrientation.portrait,
    this.margins = const GeniusPdfPrintInsets.all(20),
    this.safeArea = const GeniusPdfPrintInsets(),
    this.density = GeniusPdfPrintDensity.normal,
    this.fontScale = 1,
    this.headerFooterPolicy = GeniusPdfHeaderFooterPolicy.repeat,
    this.cutSpacing = 0,
    this.labelGapX = 0,
    this.labelGapY = 0,
    this.copies = 1,
    this.copyMetadata = const GeniusPdfCopyMetadata(),
    this.labelSheet,
    this.calibration = const GeniusPdfPrintCalibration(),
    this.physicalPlacement = false,
    this.description,
  })  : assert(fontScale > 0),
        assert(cutSpacing >= 0),
        assert(labelGapX >= 0),
        assert(labelGapY >= 0),
        assert(copies > 0),
        assert(pageSize.width > 0),
        assert(pageSize.height > 0);

  static const double pointsPerMillimeter = 72 / 25.4;

  final String id;
  final String? description;
  final GeniusPdfPrintProfileKind kind;
  final Size pageSize;
  final PdfPageOrientation orientation;
  final GeniusPdfPrintInsets margins;
  final GeniusPdfPrintInsets safeArea;
  final GeniusPdfPrintDensity density;
  final double fontScale;
  final GeniusPdfHeaderFooterPolicy headerFooterPolicy;
  final double cutSpacing;
  final double labelGapX;
  final double labelGapY;
  final int copies;
  final GeniusPdfCopyMetadata copyMetadata;
  final GeniusPdfLabelSheetSpec? labelSheet;
  final GeniusPdfPrintCalibration calibration;

  /// True only for explicitly physical pre-printed layouts.
  ///
  /// Physical placement means x/y anchors must NOT be logically mirrored in
  /// RTL. Text direction inside those anchors can still be RTL/LTR.
  final bool physicalPlacement;

  bool get isThermal =>
      kind == GeniusPdfPrintProfileKind.thermal58 ||
      kind == GeniusPdfPrintProfileKind.thermal80;

  bool get isLabel =>
      kind == GeniusPdfPrintProfileKind.customLabel ||
      kind == GeniusPdfPrintProfileKind.labelSheet;

  bool get isPrePrinted => kind == GeniusPdfPrintProfileKind.prePrinted;

  /// Copy metadata normalized to this profile's [copies] count.
  GeniusPdfCopyMetadata get effectiveCopyMetadata => GeniusPdfCopyMetadata(
        kind: copyMetadata.kind,
        copyNumber: copyMetadata.copyNumber.clamp(1, copies).toInt(),
        totalCopies: copies,
        originalLabel: copyMetadata.originalLabel,
        originalLabelAr: copyMetadata.originalLabelAr,
        copyLabel: copyMetadata.copyLabel,
        copyLabelAr: copyMetadata.copyLabelAr,
      );

  /// Effective physical page dimensions after orientation is applied.
  Size get effectivePageSize {
    if (orientation == PdfPageOrientation.landscape &&
        pageSize.height > pageSize.width) {
      return Size(pageSize.height, pageSize.width);
    }
    return pageSize;
  }

  double get contentWidth =>
      effectivePageSize.width - margins.horizontal - safeArea.horizontal;

  double get contentHeight =>
      effectivePageSize.height - margins.vertical - safeArea.vertical;

  /// Applies page geometry/margins/font scale to a package config.
  GeniusPdfConfig apply(GeniusPdfConfig config) {
    return config.copyWith(
      pageSize: pageSize,
      orientation: orientation,
      margins: margins.toPdfMargins(),
      baseFontSize: config.baseFontSize * fontScale,
      boldFontSize: config.boldFontSize * fontScale,
      headerFontSize: config.headerFontSize * fontScale,
      smallFontSize: config.smallFontSize * fontScale,
    );
  }

  /// Adapts S11's concrete profile to the generic S08 family profile hook.
  GeniusErpPrintProfile toFamilyProfile() => GeniusErpPrintProfile(
        id: id,
        description: description,
        apply: apply,
      );

  GeniusPdfPrintProfile copyWith({
    String? id,
    GeniusPdfPrintProfileKind? kind,
    Size? pageSize,
    PdfPageOrientation? orientation,
    GeniusPdfPrintInsets? margins,
    GeniusPdfPrintInsets? safeArea,
    GeniusPdfPrintDensity? density,
    double? fontScale,
    GeniusPdfHeaderFooterPolicy? headerFooterPolicy,
    double? cutSpacing,
    double? labelGapX,
    double? labelGapY,
    int? copies,
    GeniusPdfCopyMetadata? copyMetadata,
    GeniusPdfLabelSheetSpec? labelSheet,
    GeniusPdfPrintCalibration? calibration,
    bool? physicalPlacement,
    String? description,
  }) =>
      GeniusPdfPrintProfile(
        id: id ?? this.id,
        kind: kind ?? this.kind,
        pageSize: pageSize ?? this.pageSize,
        orientation: orientation ?? this.orientation,
        margins: margins ?? this.margins,
        safeArea: safeArea ?? this.safeArea,
        density: density ?? this.density,
        fontScale: fontScale ?? this.fontScale,
        headerFooterPolicy: headerFooterPolicy ?? this.headerFooterPolicy,
        cutSpacing: cutSpacing ?? this.cutSpacing,
        labelGapX: labelGapX ?? this.labelGapX,
        labelGapY: labelGapY ?? this.labelGapY,
        copies: copies ?? this.copies,
        copyMetadata: copyMetadata ?? this.copyMetadata,
        labelSheet: labelSheet ?? this.labelSheet,
        calibration: calibration ?? this.calibration,
        physicalPlacement: physicalPlacement ?? this.physicalPlacement,
        description: description ?? this.description,
      );
}
