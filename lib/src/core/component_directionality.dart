
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'directionality.dart';
import 'pdf_config.dart';

/// Internal adapter used by S02 components.
///
/// Public components keep package-owned direction types. Syncfusion direction
/// types are created only at the rendering boundary.
abstract final class GeniusPdfComponentDirectionality {
  static GeniusPdfDirectionality context({
    required GeniusPdfConfig config,
    GeniusPdfDirectionality? inherited,
    GeniusPdfDirection componentDirection = GeniusPdfDirection.auto,
  }) {
    final base = inherited ??
        GeniusPdfDirectionality(
          documentDirection:
              config.isRTL ? GeniusPdfDirection.rtl : GeniusPdfDirection.ltr,
        );
    return componentDirection == GeniusPdfDirection.auto
        ? base
        : base.forComponent(componentDirection);
  }

  static PdfTextDirection pdfDirection(GeniusPdfResolvedDirection direction) =>
      direction == GeniusPdfResolvedDirection.rtl
          ? PdfTextDirection.rightToLeft
          : PdfTextDirection.leftToRight;

  static bool looksLikeStructuredValue(String source) {
    final value = source.trim();
    if (value.isEmpty || RegExp(r'[\u0600-\u06FF]').hasMatch(value)) {
      return false;
    }
    return RegExp(r'^[+\-]?[0-9][0-9,.\s]*(?:%|[A-Za-z]{2,6})?$')
            .hasMatch(value) ||
        RegExp(r'^\+?[0-9][0-9()\-\s]{5,}$').hasMatch(value) ||
        RegExp(r'^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$')
            .hasMatch(value) ||
        RegExp(r'^(?:https?://|www\.)\S+$', caseSensitive: false)
            .hasMatch(value) ||
        RegExp(r'^[A-Za-z0-9][A-Za-z0-9._:/@+\-]*$').hasMatch(value);
  }

  static GeniusPdfResolvedDirection valueDirection({
    required String text,
    required GeniusPdfResolvedDirection layoutDirection,
    GeniusPdfDirection explicitDirection = GeniusPdfDirection.auto,
  }) {
    if (explicitDirection == GeniusPdfDirection.ltr) {
      return GeniusPdfResolvedDirection.ltr;
    }
    if (explicitDirection == GeniusPdfDirection.rtl) {
      return GeniusPdfResolvedDirection.rtl;
    }
    return looksLikeStructuredValue(text)
        ? GeniusPdfResolvedDirection.ltr
        : layoutDirection;
  }

  static PdfTextDirection valuePdfDirection({
    required GeniusPdfDirectionality context,
    required String text,
    GeniusPdfDirection explicitDirection = GeniusPdfDirection.auto,
  }) =>
      pdfDirection(
        valueDirection(
          text: text,
          layoutDirection: context.resolve().direction,
          explicitDirection: explicitDirection,
        ),
      );

  static double startX({
    required double left,
    required double width,
    required double itemWidth,
    required GeniusPdfResolvedDirection direction,
    double inset = 0,
  }) =>
      direction == GeniusPdfResolvedDirection.rtl
          ? left + width - itemWidth - inset
          : left + inset;

  static double endX({
    required double left,
    required double width,
    required double itemWidth,
    required GeniusPdfResolvedDirection direction,
    double inset = 0,
  }) =>
      direction == GeniusPdfResolvedDirection.rtl
          ? left + inset
          : left + width - itemWidth - inset;

  static int definitionIndex({
    required int index,
    required int count,
    required GeniusPdfResolvedDirection direction,
    bool followDirection = true,
    bool preserveDefinitionOrder = false,
  }) {
    if (index < 0 || index >= count) {
      throw RangeError.index(index, List<int>.filled(count, 0));
    }
    if (preserveDefinitionOrder ||
        !followDirection ||
        direction != GeniusPdfResolvedDirection.rtl) {
      return index;
    }
    return count - 1 - index;
  }

  /// Unicode directional isolation; no visible-character reversal.
  static String isolateLtr(String text) => '\u2066$text\u2069';
}
