
import 'dart:ui';


import '../src/presentation/document/builders/pdf_document_builder.dart';
import '../src/presentation/document/components/components.dart';
import '../src/core/directionality.dart';

/// One signature definition for shared legacy-template family layout.
class GeniusErpTemplateSignatureSpec {
  const GeniusErpTemplateSignatureSpec({
    required this.title,
    this.titleAr,
    this.showDate = false,
  });

  final String title;
  final String? titleAr;
  final bool showDate;
}

/// S10 shared layout helpers for legacy public templates.
extension GeniusErpSharedTemplateLayout on GeniusPdfDocumentBuilder {
  /// Draws a logical signature row with 1..N signatures.
  ///
  /// Definition order is logical start-to-end. RTL changes physical placement
  /// without duplicating left/right branches in every template.
  void drawErpSignatureRow({
    required List<GeniusErpTemplateSignatureSpec> signatures,
    double itemWidth = 120,
    double lineWidth = 110,
    double itemHeight = 60,
    double spacingBefore = 20,
    double separatorSpacing = 10,
    double spacingAfter = 70,
    double minimumRemainingHeight = 100,
  }) {
    if (signatures.isEmpty) return;

    if (remainingHeight < minimumRemainingHeight &&
        currentY > headerHeight) {
      newPage();
    }

    addSpace(spacingBefore);
    addHorizontalLine(spacing: separatorSpacing);

    final y = currentY;
    final count = signatures.length;
    final isRtl =
        resolvedLayoutDirection == GeniusPdfResolvedDirection.rtl;

    for (var physicalIndex = 0;
        physicalIndex < count;
        physicalIndex++) {
      final definitionIndex =
          isRtl ? count - 1 - physicalIndex : physicalIndex;
      final spec = signatures[definitionIndex];

      final x = count == 1
          ? (pageWidth - itemWidth) / 2
          : physicalIndex *
              ((pageWidth - itemWidth) / (count - 1));

      final signature = GeniusPdfSignatureArea(
        config: config,
        title: spec.title,
        titleAr: spec.titleAr,
        lineWidth: lineWidth,
        showDate: spec.showDate,
        directionality: directionality,
      );

      signature.draw(
        page: currentPage,
        bounds: Rect.fromLTWH(
          x,
          y,
          itemWidth,
          itemHeight,
        ),
      );
    }

    addSpace(spacingAfter);
  }
}
