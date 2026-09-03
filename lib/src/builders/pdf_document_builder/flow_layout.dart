
part of '../pdf_document_builder.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Sprint S03 — Flow Layout, Blocks, Bands & Pagination Engine
// ─────────────────────────────────────────────────────────────────────────────

/// Placement of a repeatable or page-level band.
enum PdfBandPlacement {
  top,
  bottom,
}

/// Semantic role of a band.
///
/// The engine treats all roles consistently for pagination. The role exists so
/// ERP callers and verification tools can distinguish page, section, group,
/// table and document-marker bands without duplicating layout logic.
enum PdfBandKind {
  pageHeader,
  pageFooter,
  sectionHeader,
  groupHeader,
  tableHeader,
  tableFooter,
  documentMarker,
  custom,
}

/// Page-number scope used by [PdfPageNumberBand].
enum PdfPageNumberScope {
  /// Number pages inside the current [PdfFlowSection].
  section,

  /// Number pages relative to the document state at flow-render time.
  ///
  /// If more pages are appended after the flow section, use the existing
  /// document-level `addFooter(showPageNumber: true)` API for a final whole
  /// document `Page X of Y` field.
  document,
}

/// Conditional page-break predicate.
typedef PdfPageBreakPredicate = bool Function(PdfPaginationContext context);

/// Measurement callback used by [PdfCallbackBlock].
typedef PdfBlockMeasureCallback = PdfBlockMeasurement Function(
  PdfMeasureContext context,
);

/// Render callback used by [PdfCallbackBlock].
typedef PdfBlockRenderCallback = PdfBlockRenderResult Function(
  PdfFlowRenderContext context,
);

/// Compatibility callback matching the existing custom page/bounds pattern.
typedef PdfLegacyFlowCallback = double Function(
  PdfPage page,
  Rect bounds,
);

/// Pagination policy attached to a [PdfBlock].
class PdfPageBreakPolicy {
  const PdfPageBreakPolicy({
    this.keepTogether = false,
    this.keepWithNext = false,
    this.pageBreakBefore = false,
    this.pageBreakAfter = false,
    this.breakBeforeWhen,
    this.allowOverflow = false,
  });

  /// Keeps the block on one page whenever it can fit on an empty page.
  final bool keepTogether;

  /// Moves this block with the beginning of the next block when both can fit
  /// together on an empty page.
  final bool keepWithNext;

  /// Forces a page break before this block.
  final bool pageBreakBefore;

  /// Forces a page break after this block when more content remains.
  final bool pageBreakAfter;

  /// Optional runtime planning predicate for a break before the block.
  final PdfPageBreakPredicate? breakBeforeWhen;

  /// Allows a non-splittable block to exceed the page body height.
  ///
  /// Defaults to false because silent clipping is unsafe for ERP printouts.
  final bool allowOverflow;

  PdfPageBreakPolicy copyWith({
    bool? keepTogether,
    bool? keepWithNext,
    bool? pageBreakBefore,
    bool? pageBreakAfter,
    PdfPageBreakPredicate? breakBeforeWhen,
    bool clearBreakBeforeWhen = false,
    bool? allowOverflow,
  }) {
    return PdfPageBreakPolicy(
      keepTogether: keepTogether ?? this.keepTogether,
      keepWithNext: keepWithNext ?? this.keepWithNext,
      pageBreakBefore: pageBreakBefore ?? this.pageBreakBefore,
      pageBreakAfter: pageBreakAfter ?? this.pageBreakAfter,
      breakBeforeWhen: clearBreakBeforeWhen
          ? null
          : (breakBeforeWhen ?? this.breakBeforeWhen),
      allowOverflow: allowOverflow ?? this.allowOverflow,
    );
  }
}

/// Context passed to a conditional page-break predicate.
class PdfPaginationContext {
  const PdfPaginationContext({
    required this.pageIndex,
    required this.blockIndex,
    required this.usedHeight,
    required this.remainingHeight,
    required this.pageBodyHeight,
    required this.directionality,
    this.blockId,
    this.nextBlockId,
  });

  /// Zero-based page index inside the flow section.
  final int pageIndex;

  /// Zero-based source block index.
  final int blockIndex;

  /// Height already consumed in the current page body.
  final double usedHeight;

  /// Height currently available in the page body.
  final double remainingHeight;

  /// Full page body height after all header/footer reservations.
  final double pageBodyHeight;

  /// Effective directionality inherited by the section.
  final GeniusPdfDirectionality directionality;

  final String? blockId;
  final String? nextBlockId;

  int get pageNumber => pageIndex + 1;
}

/// Result of a measurement pass for one [PdfBlock].
class PdfBlockMeasurement {
  const PdfBlockMeasurement({
    required this.height,
  }) : assert(height >= 0);

  final double height;
}

/// Result returned by a block render callback.
class PdfBlockRenderResult {
  const PdfBlockRenderResult({
    required this.usedHeight,
  }) : assert(usedHeight >= 0);

  final double usedHeight;
}

/// A split result used for orphan/widow-aware blocks.
class PdfBlockSplit {
  const PdfBlockSplit({
    required this.head,
    required this.tail,
  });

  final PdfBlock head;
  final PdfBlock tail;
}

/// Section-level page size/orientation configuration.
class PdfFlowPageSpec {
  const PdfFlowPageSpec({
    this.size,
    this.orientation,
  });

  /// Raw page size before orientation is applied.
  final Size? size;

  final PdfPageOrientation? orientation;

  PdfPageOrientation resolveOrientation(GeniusPdfConfig config) =>
      orientation ?? config.orientation;

  Size resolveRawSize(GeniusPdfConfig config) => size ?? config.pageSize;

  /// Effective full-page size used by the planner.
  Size resolveEffectiveSize(GeniusPdfConfig config) {
    final raw = resolveRawSize(config);
    final resolvedOrientation = resolveOrientation(config);

    if (resolvedOrientation == PdfPageOrientation.landscape &&
        raw.height > raw.width) {
      return Size(raw.height, raw.width);
    }
    if (resolvedOrientation == PdfPageOrientation.portrait &&
        raw.width > raw.height) {
      return Size(raw.height, raw.width);
    }
    return raw;
  }
}

/// Measurement-only context.
///
/// S03 keeps measurement separate from rendering. Heavy drawing callbacks are
/// never called from this context.
class PdfMeasureContext {
  const PdfMeasureContext({
    required this.width,
    required this.maxHeight,
    required this.pageSize,
    required this.baseFont,
    required this.directionality,
  });

  final double width;
  final double maxHeight;
  final Size pageSize;
  final PdfFont baseFont;
  final GeniusPdfDirectionality directionality;

  PdfMeasureContext copyWith({
    double? width,
    double? maxHeight,
    Size? pageSize,
    PdfFont? baseFont,
    GeniusPdfDirectionality? directionality,
  }) {
    return PdfMeasureContext(
      width: width ?? this.width,
      maxHeight: maxHeight ?? this.maxHeight,
      pageSize: pageSize ?? this.pageSize,
      baseFont: baseFont ?? this.baseFont,
      directionality: directionality ?? this.directionality,
    );
  }
}

/// Metadata known before the render pass starts.
class PdfFlowPageMetadata {
  const PdfFlowPageMetadata({
    required this.sectionPageNumber,
    required this.sectionPageCount,
    required this.documentPageNumber,
    required this.documentPageCount,
    required this.directionality,
    this.documentStatus,
    this.copyLabel,
  });

  final int sectionPageNumber;
  final int sectionPageCount;
  final int documentPageNumber;
  final int documentPageCount;
  final GeniusPdfDirectionality directionality;
  final String? documentStatus;
  final String? copyLabel;

  bool get isFirstPage => sectionPageNumber == 1;
  bool get isLastPage => sectionPageNumber == sectionPageCount;
}

/// Render context for one planned block.
class PdfFlowRenderContext {
  const PdfFlowRenderContext({
    required this.builder,
    required this.bounds,
    required this.metadata,
    required this.directionality,
    required this.expectedHeight,
  });

  final GeniusPdfDocumentBuilder builder;
  final Rect bounds;
  final PdfFlowPageMetadata metadata;
  final GeniusPdfDirectionality directionality;
  final double expectedHeight;

  PdfPage get page => builder.currentPage;

  PdfFlowRenderContext copyWith({
    Rect? bounds,
    double? expectedHeight,
  }) {
    return PdfFlowRenderContext(
      builder: builder,
      bounds: bounds ?? this.bounds,
      metadata: metadata,
      directionality: directionality,
      expectedHeight: expectedHeight ?? this.expectedHeight,
    );
  }
}

/// Base abstraction for flow content.
abstract class PdfBlock {
  const PdfBlock({
    this.id,
    this.breakPolicy = const PdfPageBreakPolicy(),
  });

  final String? id;
  final PdfPageBreakPolicy breakPolicy;

  /// Pure measurement pass.
  PdfBlockMeasurement measure(PdfMeasureContext context);

  /// Render pass executed only after the page plan is finalized.
  PdfBlockRenderResult render(PdfFlowRenderContext context);

  /// Optionally splits this block to fit [availableHeight].
  ///
  /// Returning null means the block is not splittable at the requested point.
  PdfBlockSplit? split(
    PdfMeasureContext context,
    double availableHeight,
  ) =>
      null;
}

/// Base abstraction for top/bottom page bands.
abstract class PdfBand extends PdfBlock {
  const PdfBand({
    super.id,
    super.breakPolicy,
    required this.placement,
    this.kind = PdfBandKind.custom,
  });

  final PdfBandPlacement placement;
  final PdfBandKind kind;
}

/// Wraps a block as a repeatable band.
class PdfRepeatableBand extends PdfBand {
  const PdfRepeatableBand({
    required this.child,
    required super.placement,
    super.id,
    super.kind,
    this.includeFirstPage = true,
    this.reservedHeight,
  });

  final PdfBlock child;

  /// When false, the band starts from section page 2.
  final bool includeFirstPage;

  /// Optional fixed reservation. When null, the child is measured.
  final double? reservedHeight;

  @override
  PdfBlockMeasurement measure(PdfMeasureContext context) {
    if (reservedHeight != null) {
      return PdfBlockMeasurement(height: reservedHeight!);
    }
    return child.measure(context);
  }

  @override
  PdfBlockRenderResult render(PdfFlowRenderContext context) {
    child.render(context);
    return PdfBlockRenderResult(
      usedHeight: context.expectedHeight,
    );
  }
}

/// Wraps an existing block with `keepTogether`.
class PdfKeepTogether extends PdfBlock {
  PdfKeepTogether(
    this.child, {
    String? id,
  }) : super(
          id: id ?? child.id,
          breakPolicy: child.breakPolicy.copyWith(
            keepTogether: true,
          ),
        );

  final PdfBlock child;

  @override
  PdfBlockMeasurement measure(PdfMeasureContext context) =>
      child.measure(context);

  @override
  PdfBlockRenderResult render(PdfFlowRenderContext context) =>
      child.render(context);

  @override
  PdfBlockSplit? split(
    PdfMeasureContext context,
    double availableHeight,
  ) {
    final result = child.split(context, availableHeight);
    if (result == null) return null;
    return PdfBlockSplit(
      head: PdfKeepTogether(result.head),
      tail: PdfKeepTogether(result.tail),
    );
  }
}

/// A fixed-height flow block.
///
/// Useful for deterministic spacers, pre-measured custom widgets and tests.
class PdfFixedBlock extends PdfBlock {
  const PdfFixedBlock({
    required this.height,
    this.renderer,
    super.id,
    super.breakPolicy,
  }) : assert(height >= 0);

  final double height;
  final PdfBlockRenderCallback? renderer;

  @override
  PdfBlockMeasurement measure(PdfMeasureContext context) =>
      PdfBlockMeasurement(height: height);

  @override
  PdfBlockRenderResult render(PdfFlowRenderContext context) =>
      renderer?.call(context) ??
      PdfBlockRenderResult(usedHeight: height);
}

/// Custom two-pass block.
///
/// Measurement and drawing are explicitly separate so expensive drawing never
/// runs during pagination planning.
class PdfCallbackBlock extends PdfBlock {
  const PdfCallbackBlock({
    required this.measureCallback,
    required this.renderCallback,
    super.id,
    super.breakPolicy,
  });

  final PdfBlockMeasureCallback measureCallback;
  final PdfBlockRenderCallback renderCallback;

  @override
  PdfBlockMeasurement measure(PdfMeasureContext context) =>
      measureCallback(context);

  @override
  PdfBlockRenderResult render(PdfFlowRenderContext context) =>
      renderCallback(context);
}

/// Compatibility adapter for existing callbacks with `(PdfPage, Rect)`.
///
/// Existing callback signatures are not removed or changed. S03 simply makes
/// them usable inside the new flow engine.
class PdfLegacyCallbackBlock extends PdfCallbackBlock {
  PdfLegacyCallbackBlock({
    required double estimatedHeight,
    required PdfLegacyFlowCallback callback,
    super.id,
    super.breakPolicy = const PdfPageBreakPolicy(),
  }) : super(
          measureCallback: (_) =>
              PdfBlockMeasurement(height: estimatedHeight),
          renderCallback: (context) => PdfBlockRenderResult(
            usedHeight: callback(context.page, context.bounds),
          ),
        );
}

/// Text block with measurement, wrapping and orphan/widow protection.
class PdfTextBlock extends PdfBlock {
  const PdfTextBlock({
    required this.text,
    this.font,
    this.brush,
    this.direction = GeniusPdfDirection.auto,
    this.alignment = GeniusPdfLogicalAlignment.start,
    this.lineHeightFactor = 1.2,
    this.paddingTop = 0,
    this.paddingBottom = 0,
    this.minOrphanLines = 2,
    this.minWidowLines = 2,
    super.id,
    super.breakPolicy,
  }) : _preparedLines = null;

  const PdfTextBlock._prepared({
    required this.text,
    required List<String> preparedLines,
    required this.font,
    required this.brush,
    required this.direction,
    required this.alignment,
    required this.lineHeightFactor,
    required this.paddingTop,
    required this.paddingBottom,
    required this.minOrphanLines,
    required this.minWidowLines,
    required super.id,
    required super.breakPolicy,
  }) : _preparedLines = preparedLines;

  final String text;
  final PdfFont? font;
  final PdfBrush? brush;
  final GeniusPdfDirection direction;
  final GeniusPdfLogicalAlignment alignment;
  final double lineHeightFactor;
  final double paddingTop;
  final double paddingBottom;
  final int minOrphanLines;
  final int minWidowLines;
  final List<String>? _preparedLines;

  PdfFont _resolveFont(PdfMeasureContext context) =>
      font ?? context.baseFont;

  double _lineHeight(PdfFont effectiveFont) =>
      effectiveFont.measureString('Ag').height * lineHeightFactor;

  GeniusPdfResolvedDirection _resolveDirection(
    GeniusPdfDirectionality context,
  ) {
    switch (direction) {
      case GeniusPdfDirection.ltr:
        return GeniusPdfResolvedDirection.ltr;
      case GeniusPdfDirection.rtl:
        return GeniusPdfResolvedDirection.rtl;
      case GeniusPdfDirection.auto:
        return context.resolve().direction;
    }
  }

  PdfTextAlignment _resolveAlignment(
    GeniusPdfResolvedDirection resolved,
  ) {
    final physical = GeniusPdfLogicalGeometry.resolveAlignment(
      alignment,
      resolved,
    );
    return switch (physical) {
      GeniusPdfPhysicalHorizontalAlignment.left =>
        PdfTextAlignment.left,
      GeniusPdfPhysicalHorizontalAlignment.center =>
        PdfTextAlignment.center,
      GeniusPdfPhysicalHorizontalAlignment.right =>
        PdfTextAlignment.right,
    };
  }

  List<String> _wrapLines(
    PdfMeasureContext context,
  ) {
    if (_preparedLines != null) {
      return List<String>.unmodifiable(_preparedLines!);
    }

    final effectiveFont = _resolveFont(context);
    final maxWidth = context.width;
    final result = <String>[];

    for (final paragraph in text.split('\n')) {
      if (paragraph.isEmpty) {
        result.add('');
        continue;
      }

      final words = paragraph.trim().split(RegExp(r'\s+'));
      var current = '';

      for (final word in words) {
        final candidate = current.isEmpty ? word : '$current $word';
        final width = effectiveFont.measureString(candidate).width;

        if (width <= maxWidth || current.isEmpty) {
          current = candidate;
          continue;
        }

        result.add(current);
        current = word;
      }

      if (current.isNotEmpty) {
        result.add(current);
      }
    }

    return result.isEmpty ? const [''] : result;
  }

  @override
  PdfBlockMeasurement measure(PdfMeasureContext context) {
    final effectiveFont = _resolveFont(context);
    final lines = _wrapLines(context);
    final lineHeight = _lineHeight(effectiveFont);
    return PdfBlockMeasurement(
      height: paddingTop +
          paddingBottom +
          (lines.length * lineHeight),
    );
  }

  @override
  PdfBlockRenderResult render(PdfFlowRenderContext context) {
    final measureContext = PdfMeasureContext(
      width: context.bounds.width,
      maxHeight: context.bounds.height,
      pageSize: Size(
        context.builder.pageWidth,
        context.builder.pageHeight,
      ),
      baseFont: context.builder.baseFont,
      directionality: context.directionality,
    );
    final effectiveFont = font ?? context.builder.baseFont;
    final lines = _wrapLines(measureContext);
    final resolved = _resolveDirection(context.directionality);
    final lineHeight = _lineHeight(effectiveFont);
    final format = PdfStringFormat(
      alignment: _resolveAlignment(resolved),
      lineAlignment: PdfVerticalAlignment.top,
      textDirection: resolved == GeniusPdfResolvedDirection.rtl
          ? PdfTextDirection.rightToLeft
          : PdfTextDirection.leftToRight,
    );

    var y = context.bounds.top + paddingTop;
    for (final line in lines) {
      context.page.graphics.drawString(
        line,
        effectiveFont,
        brush: brush ?? PdfBrushes.black,
        bounds: Rect.fromLTWH(
          context.bounds.left,
          y,
          context.bounds.width,
          lineHeight,
        ),
        format: format,
      );
      y += lineHeight;
    }

    return PdfBlockRenderResult(
      usedHeight: paddingTop +
          paddingBottom +
          (lines.length * lineHeight),
    );
  }

  @override
  PdfBlockSplit? split(
    PdfMeasureContext context,
    double availableHeight,
  ) {
    final effectiveFont = _resolveFont(context);
    final lines = _wrapLines(context);
    if (lines.length <= 1) return null;

    final lineHeight = _lineHeight(effectiveFont);
    final usable = availableHeight - paddingTop;
    var fit = (usable / lineHeight).floor();

    if (fit >= lines.length) return null;
    if (fit < minOrphanLines) return null;

    final remaining = lines.length - fit;
    if (remaining < minWidowLines) {
      fit = lines.length - minWidowLines;
    }

    if (fit < minOrphanLines || fit <= 0 || fit >= lines.length) {
      return null;
    }

    final headLines = lines.sublist(0, fit);
    final tailLines = lines.sublist(fit);

    final headPolicy = breakPolicy.copyWith(
      keepTogether: false,
      keepWithNext: false,
      pageBreakAfter: false,
    );
    final tailPolicy = breakPolicy.copyWith(
      keepTogether: false,
      pageBreakBefore: false,
    );

    return PdfBlockSplit(
      head: PdfTextBlock._prepared(
        text: headLines.join('\n'),
        preparedLines: headLines,
        font: font,
        brush: brush,
        direction: direction,
        alignment: alignment,
        lineHeightFactor: lineHeightFactor,
        paddingTop: paddingTop,
        paddingBottom: 0,
        minOrphanLines: minOrphanLines,
        minWidowLines: minWidowLines,
        id: id == null ? null : '$id#head',
        breakPolicy: headPolicy,
      ),
      tail: PdfTextBlock._prepared(
        text: tailLines.join('\n'),
        preparedLines: tailLines,
        font: font,
        brush: brush,
        direction: direction,
        alignment: alignment,
        lineHeightFactor: lineHeightFactor,
        paddingTop: 0,
        paddingBottom: paddingBottom,
        minOrphanLines: minOrphanLines,
        minWidowLines: minWidowLines,
        id: id == null ? null : '$id#tail',
        breakPolicy: tailPolicy,
      ),
    );
  }
}

/// Convenience list block using the text splitter for orphan/widow protection.
class PdfListBlock extends PdfTextBlock {
  PdfListBlock({
    required List<String> items,
    String bullet = '•',
    super.font,
    super.brush,
    super.direction = GeniusPdfDirection.auto,
    super.alignment = GeniusPdfLogicalAlignment.start,
    super.lineHeightFactor = 1.2,
    super.paddingTop = 0,
    super.paddingBottom = 0,
    int minOrphanItems = 2,
    int minWidowItems = 2,
    super.id,
    super.breakPolicy = const PdfPageBreakPolicy(),
  }) : super(
          text: items.map((item) => '$bullet $item').join('\n'),
          minOrphanLines: minOrphanItems,
          minWidowLines: minWidowItems,
        );
}

/// Fixed-height text band.
class PdfTextBand extends PdfBand {
  const PdfTextBand({
    required this.text,
    this.textAr,
    this.height = 24,
    this.font,
    this.brush,
    this.direction = GeniusPdfDirection.auto,
    this.alignment = GeniusPdfLogicalAlignment.start,
    required super.placement,
    super.kind,
    super.id,
  }) : assert(height >= 0);

  final String text;
  final String? textAr;
  final double height;
  final PdfFont? font;
  final PdfBrush? brush;
  final GeniusPdfDirection direction;
  final GeniusPdfLogicalAlignment alignment;

  @override
  PdfBlockMeasurement measure(PdfMeasureContext context) =>
      PdfBlockMeasurement(height: height);

  @override
  PdfBlockRenderResult render(PdfFlowRenderContext context) {
    final isRtl =
        context.directionality.resolve().direction ==
            GeniusPdfResolvedDirection.rtl;
    final displayText = isRtl && textAr != null ? textAr! : text;

    final block = PdfTextBlock(
      text: displayText,
      font: font,
      brush: brush,
      direction: direction,
      alignment: alignment,
      lineHeightFactor: 1,
    );
    block.render(
      context.copyWith(
        bounds: Rect.fromLTWH(
          context.bounds.left,
          context.bounds.top,
          context.bounds.width,
          height,
        ),
        expectedHeight: height,
      ),
    );
    return PdfBlockRenderResult(usedHeight: height);
  }
}

/// Dynamic Page X of Y band.
class PdfPageNumberBand extends PdfBand {
  const PdfPageNumberBand({
    this.format = 'Page {page} of {pages}',
    this.formatAr = 'صفحة {page} من {pages}',
    this.scope = PdfPageNumberScope.section,
    this.height = 22,
    this.font,
    this.brush,
    this.alignment = GeniusPdfLogicalAlignment.center,
    super.id = 'page-number',
    super.placement = PdfBandPlacement.bottom,
    super.kind = PdfBandKind.pageFooter,
  });

  final String format;
  final String? formatAr;
  final PdfPageNumberScope scope;
  final double height;
  final PdfFont? font;
  final PdfBrush? brush;
  final GeniusPdfLogicalAlignment alignment;

  @override
  PdfBlockMeasurement measure(PdfMeasureContext context) =>
      PdfBlockMeasurement(height: height);

  @override
  PdfBlockRenderResult render(PdfFlowRenderContext context) {
    final isRtl =
        context.directionality.resolve().direction ==
            GeniusPdfResolvedDirection.rtl;
    final pattern = isRtl && formatAr != null ? formatAr! : format;

    final page = scope == PdfPageNumberScope.section
        ? context.metadata.sectionPageNumber
        : context.metadata.documentPageNumber;
    final pages = scope == PdfPageNumberScope.section
        ? context.metadata.sectionPageCount
        : context.metadata.documentPageCount;

    // Isolate numeric runs rather than reversing them inside RTL prose.
    final pageRun = '\u2066$page\u2069';
    final pagesRun = '\u2066$pages\u2069';
    final text = pattern
        .replaceAll('{page}', pageRun)
        .replaceAll('{pages}', pagesRun);

    final resolved = context.directionality.resolve().direction;
    final physical = GeniusPdfLogicalGeometry.resolveAlignment(
      alignment,
      resolved,
    );
    final pdfAlignment = switch (physical) {
      GeniusPdfPhysicalHorizontalAlignment.left =>
        PdfTextAlignment.left,
      GeniusPdfPhysicalHorizontalAlignment.center =>
        PdfTextAlignment.center,
      GeniusPdfPhysicalHorizontalAlignment.right =>
        PdfTextAlignment.right,
    };

    context.page.graphics.drawString(
      text,
      font ?? context.builder.config.smallFont,
      brush: brush ?? PdfBrushes.black,
      bounds: context.bounds,
      format: PdfStringFormat(
        alignment: pdfAlignment,
        lineAlignment: PdfVerticalAlignment.middle,
        textDirection: resolved == GeniusPdfResolvedDirection.rtl
            ? PdfTextDirection.rightToLeft
            : PdfTextDirection.leftToRight,
      ),
    );

    return PdfBlockRenderResult(usedHeight: height);
  }
}

/// Document status/original-copy marker band.
///
/// If [text]/[textAr] are omitted, the section's `copyLabel` or
/// `documentStatus` metadata is used.
class PdfDocumentMarkerBand extends PdfBand {
  const PdfDocumentMarkerBand({
    this.text,
    this.textAr,
    this.height = 20,
    this.font,
    this.brush,
    this.alignment = GeniusPdfLogicalAlignment.center,
    super.id = 'document-marker',
    super.placement = PdfBandPlacement.top,
    super.kind = PdfBandKind.documentMarker,
  });

  final String? text;
  final String? textAr;
  final double height;
  final PdfFont? font;
  final PdfBrush? brush;
  final GeniusPdfLogicalAlignment alignment;

  @override
  PdfBlockMeasurement measure(PdfMeasureContext context) =>
      PdfBlockMeasurement(height: height);

  @override
  PdfBlockRenderResult render(PdfFlowRenderContext context) {
    final isRtl =
        context.directionality.resolve().direction ==
            GeniusPdfResolvedDirection.rtl;
    final metadataText =
        context.metadata.copyLabel ?? context.metadata.documentStatus ?? '';
    final displayText = isRtl
        ? (textAr ?? text ?? metadataText)
        : (text ?? textAr ?? metadataText);

    if (displayText.isEmpty) {
      return PdfBlockRenderResult(usedHeight: height);
    }

    final resolved = context.directionality.resolve().direction;
    final physical = GeniusPdfLogicalGeometry.resolveAlignment(
      alignment,
      resolved,
    );
    final pdfAlignment = switch (physical) {
      GeniusPdfPhysicalHorizontalAlignment.left =>
        PdfTextAlignment.left,
      GeniusPdfPhysicalHorizontalAlignment.center =>
        PdfTextAlignment.center,
      GeniusPdfPhysicalHorizontalAlignment.right =>
        PdfTextAlignment.right,
    };

    context.page.graphics.drawString(
      displayText,
      font ?? context.builder.config.boldFont,
      brush: brush ?? PdfBrushes.black,
      bounds: context.bounds,
      format: PdfStringFormat(
        alignment: pdfAlignment,
        lineAlignment: PdfVerticalAlignment.middle,
        textDirection: resolved == GeniusPdfResolvedDirection.rtl
            ? PdfTextDirection.rightToLeft
            : PdfTextDirection.leftToRight,
      ),
    );

    return PdfBlockRenderResult(usedHeight: height);
  }
}


// ─────────────────────────────────────────────────────────────────────────────
// S03 convenience components
// ─────────────────────────────────────────────────────────────────────────────

/// A semantic vertical spacer for flow sections.
class PdfSpacerBlock extends PdfFixedBlock {
  const PdfSpacerBlock(
    double height, {
    super.id,
  }) : super(height: height);
}

/// Explicit page-break component.
class PdfPageBreakBlock extends PdfFixedBlock {
  const PdfPageBreakBlock({
    super.id = 'page-break',
  }) : super(
          height: 0,
          breakPolicy: const PdfPageBreakPolicy(
            pageBreakBefore: true,
          ),
        );
}

/// Repeatable section-header component.
class PdfSectionHeaderBand extends PdfRepeatableBand {
  const PdfSectionHeaderBand({
    required super.child,
    super.id,
    super.includeFirstPage = true,
    super.reservedHeight,
  }) : super(
          placement: PdfBandPlacement.top,
          kind: PdfBandKind.sectionHeader,
        );
}

/// Repeatable group-header component.
class PdfGroupHeaderBand extends PdfRepeatableBand {
  const PdfGroupHeaderBand({
    required super.child,
    super.id,
    super.includeFirstPage = true,
    super.reservedHeight,
  }) : super(
          placement: PdfBandPlacement.top,
          kind: PdfBandKind.groupHeader,
        );
}

/// Repeatable table-header component. Advanced grid pagination remains S04.
class PdfTableHeaderBand extends PdfRepeatableBand {
  const PdfTableHeaderBand({
    required super.child,
    super.id,
    super.includeFirstPage = true,
    super.reservedHeight,
  }) : super(
          placement: PdfBandPlacement.top,
          kind: PdfBandKind.tableHeader,
        );
}

/// Repeatable table-footer component. Advanced DataGrid totals remain S04.
class PdfTableFooterBand extends PdfRepeatableBand {
  const PdfTableFooterBand({
    required super.child,
    super.id,
    super.includeFirstPage = true,
    super.reservedHeight,
  }) : super(
          placement: PdfBandPlacement.bottom,
          kind: PdfBandKind.tableFooter,
        );
}

/// Convenience marker for workflow status such as DRAFT/POSTED/CANCELLED.
class PdfStatusMarkerBand extends PdfDocumentMarkerBand {
  const PdfStatusMarkerBand({
    super.text,
    super.textAr,
    super.height = 20,
    super.font,
    super.brush,
    super.alignment = GeniusPdfLogicalAlignment.center,
    super.id = 'document-status',
    super.placement = PdfBandPlacement.top,
  });
}

/// Convenience marker for ORIGINAL/COPY labels.
class PdfOriginalCopyBand extends PdfDocumentMarkerBand {
  const PdfOriginalCopyBand({
    super.text = 'ORIGINAL',
    super.textAr = 'أصل',
    super.height = 20,
    super.font,
    super.brush,
    super.alignment = GeniusPdfLogicalAlignment.center,
    super.id = 'original-copy',
    super.placement = PdfBandPlacement.top,
  });
}

/// A complete flow section.
///
/// A section owns body blocks plus optional page/header/footer bands. The
/// engine measures the entire section first, then renders the finalized plan.
class PdfFlowSection {
  const PdfFlowSection({
    required this.blocks,
    this.id,
    this.pageSpec = const PdfFlowPageSpec(),
    this.pageHeader,
    this.firstPageHeader,
    this.pageFooter,
    this.lastPageFooter,
    this.repeatableBands = const [],
    this.directionality,
    this.direction = GeniusPdfDirection.auto,
    this.documentStatus,
    this.copyLabel,
    this.strictMeasurement = true,
    this.measurementTolerance = 1.0,
  });

  final String? id;
  final List<PdfBlock> blocks;
  final PdfFlowPageSpec pageSpec;

  /// Repeated page header.
  final PdfBand? pageHeader;

  /// Replaces [pageHeader] on section page 1 when supplied.
  final PdfBand? firstPageHeader;

  /// Repeated page footer.
  final PdfBand? pageFooter;

  /// Replaces [pageFooter] on the final section page when supplied.
  ///
  /// The planner conservatively reserves the larger of normal/last footer
  /// heights on every page to avoid a third render/reflow pass.
  final PdfBand? lastPageFooter;

  /// Additional repeated group/section/table/document bands.
  final List<PdfRepeatableBand> repeatableBands;

  final GeniusPdfDirectionality? directionality;
  final GeniusPdfDirection direction;

  /// Optional values exposed through [PdfFlowPageMetadata].
  final String? documentStatus;
  final String? copyLabel;

  /// When true, render height must match measurement within
  /// [measurementTolerance].
  final bool strictMeasurement;

  final double measurementTolerance;
}

/// Public summary for one planned page.
class PdfFlowPagePlan {
  const PdfFlowPagePlan({
    required this.index,
    required this.pageSize,
    required this.orientation,
    required this.clientWidth,
    required this.clientHeight,
    required this.availableBodyHeight,
    required this.usedBodyHeight,
    required this.blockIds,
    required this.headerBandIds,
    required this.footerBandIds,
  });

  final int index;
  final Size pageSize;
  final PdfPageOrientation orientation;
  final double clientWidth;
  final double clientHeight;
  final double availableBodyHeight;
  final double usedBodyHeight;
  final List<String> blockIds;
  final List<String> headerBandIds;
  final List<String> footerBandIds;

  int get pageNumber => index + 1;
}

/// Result of the first measurement/pagination pass.
class PdfFlowPlan {
  PdfFlowPlan._({
    required this.pages,
    required this.measurementCount,
    required PdfFlowSection section,
    required List<_PdfInternalPagePlan> internalPages,
  })  : _section = section,
        _internalPages = internalPages;

  final List<PdfFlowPagePlan> pages;

  /// Number of uncached measurement calls performed by the planner.
  final int measurementCount;

  final PdfFlowSection _section;
  final List<_PdfInternalPagePlan> _internalPages;

  int get pageCount => pages.length;
}

/// Result returned after the render pass.
class PdfFlowResult {
  const PdfFlowResult({
    required this.plan,
    required this.renderedBlockCount,
    required this.firstDocumentPageIndex,
    required this.lastDocumentPageIndex,
    required this.lastY,
  });

  final PdfFlowPlan plan;
  final int renderedBlockCount;
  final int firstDocumentPageIndex;
  final int lastDocumentPageIndex;
  final double lastY;
}

/// Flow-layout exception carrying a deterministic planner/rendering failure.
class PdfFlowLayoutException implements Exception {
  const PdfFlowLayoutException(this.message);

  final String message;

  @override
  String toString() => 'PdfFlowLayoutException: $message';
}

class _PdfPlannedBlock {
  const _PdfPlannedBlock({
    required this.block,
    required this.height,
  });

  final PdfBlock block;
  final double height;
}

class _PdfPlannedBand {
  const _PdfPlannedBand({
    required this.band,
    required this.height,
  });

  final PdfBand band;
  final double height;
}

class _PdfFlowMetrics {
  const _PdfFlowMetrics({
    required this.rawPageSize,
    required this.pageSize,
    required this.orientation,
    required this.clientWidth,
    required this.clientHeight,
    required this.topReserve,
    required this.bottomReserve,
    required this.bodyHeight,
  });

  final Size rawPageSize;
  final Size pageSize;
  final PdfPageOrientation orientation;
  final double clientWidth;
  final double clientHeight;
  final double topReserve;
  final double bottomReserve;
  final double bodyHeight;
}

class _PdfInternalPagePlan {
  _PdfInternalPagePlan({
    required this.index,
    required this.metrics,
    required this.topBands,
    required this.bottomBands,
  });

  final int index;
  final _PdfFlowMetrics metrics;
  final List<_PdfPlannedBand> topBands;
  List<_PdfPlannedBand> bottomBands;
  final List<_PdfPlannedBlock> blocks = <_PdfPlannedBlock>[];
  double usedHeight = 0;

  double get remainingHeight => metrics.bodyHeight - usedHeight;
}

class _PdfFlowPlanner {
  _PdfFlowPlanner(
    this.builder,
    this.section,
  ) : directionality = _resolveSectionDirectionality(builder, section);

  final GeniusPdfDocumentBuilder builder;
  final PdfFlowSection section;
  final GeniusPdfDirectionality directionality;

  final Map<String, PdfBlockMeasurement> _measurementCache =
      <String, PdfBlockMeasurement>{};
  final List<_PdfInternalPagePlan> _pages =
      <_PdfInternalPagePlan>[];
  int _measurementCount = 0;

  PdfFlowPlan plan() {
    _pages.add(_createPage(0));

    for (var sourceIndex = 0;
        sourceIndex < section.blocks.length;
        sourceIndex++) {
      final original = section.blocks[sourceIndex];
      final next = sourceIndex + 1 < section.blocks.length
          ? section.blocks[sourceIndex + 1]
          : null;

      final page = _pages.last;
      final paginationContext = PdfPaginationContext(
        pageIndex: page.index,
        blockIndex: sourceIndex,
        usedHeight: page.usedHeight,
        remainingHeight: page.remainingHeight,
        pageBodyHeight: page.metrics.bodyHeight,
        directionality: directionality,
        blockId: original.id,
        nextBlockId: next?.id,
      );

      final policy = original.breakPolicy;
      final conditionalBreak =
          policy.breakBeforeWhen?.call(paginationContext) ?? false;

      if ((policy.pageBreakBefore || conditionalBreak) &&
          page.blocks.isNotEmpty) {
        _pages.add(_createPage(_pages.length));
      }

      if (policy.keepWithNext && next != null) {
        final currentPage = _pages.last;
        final currentMeasurement = _measure(
          original,
          currentPage.metrics,
        );
        final nextMeasurement = _measure(
          next,
          currentPage.metrics,
        );
        final pairHeight =
            currentMeasurement.height + nextMeasurement.height;

        if (pairHeight > currentPage.remainingHeight &&
            pairHeight <= currentPage.metrics.bodyHeight &&
            currentPage.blocks.isNotEmpty) {
          _pages.add(_createPage(_pages.length));
        }
      }

      _placeBlock(
        original,
        sourceIndex: sourceIndex,
      );

      if (policy.pageBreakAfter &&
          sourceIndex + 1 < section.blocks.length &&
          _pages.last.blocks.isNotEmpty) {
        _pages.add(_createPage(_pages.length));
      }
    }

    if (_pages.length > 1 && _pages.last.blocks.isEmpty) {
      _pages.removeLast();
    }

    _finalizeLastPageFooter();

    final summaries = <PdfFlowPagePlan>[];
    for (var i = 0; i < _pages.length; i++) {
      final page = _pages[i];
      summaries.add(
        PdfFlowPagePlan(
          index: page.index,
          pageSize: page.metrics.pageSize,
          orientation: page.metrics.orientation,
          clientWidth: page.metrics.clientWidth,
          clientHeight: page.metrics.clientHeight,
          availableBodyHeight: page.metrics.bodyHeight,
          usedBodyHeight: page.usedHeight,
          blockIds: List<String>.unmodifiable(
            page.blocks.map((item) => _blockId(item.block)),
          ),
          headerBandIds: List<String>.unmodifiable(
            page.topBands.map((item) => _blockId(item.band)),
          ),
          footerBandIds: List<String>.unmodifiable(
            page.bottomBands.map((item) => _blockId(item.band)),
          ),
        ),
      );
    }

    return PdfFlowPlan._(
      pages: List<PdfFlowPagePlan>.unmodifiable(summaries),
      measurementCount: _measurementCount,
      section: section,
      internalPages:
          List<_PdfInternalPagePlan>.unmodifiable(_pages),
    );
  }

  void _placeBlock(
    PdfBlock source, {
    required int sourceIndex,
  }) {
    var pending = source;

    while (true) {
      var page = _pages.last;
      var measurement = _measure(pending, page.metrics);

      if (measurement.height <= page.remainingHeight) {
        _append(page, pending, measurement);
        return;
      }

      if (pending.breakPolicy.keepTogether &&
          measurement.height <= page.metrics.bodyHeight &&
          page.blocks.isNotEmpty) {
        _pages.add(_createPage(_pages.length));
        continue;
      }

      var split = pending.split(
        _measureContext(page.metrics),
        page.remainingHeight,
      );

      if (split == null &&
          page.blocks.isNotEmpty) {
        _pages.add(_createPage(_pages.length));
        page = _pages.last;
        measurement = _measure(pending, page.metrics);

        if (measurement.height <= page.remainingHeight) {
          _append(page, pending, measurement);
          return;
        }

        split = pending.split(
          _measureContext(page.metrics),
          page.remainingHeight,
        );
      }

      if (split != null) {
        final headMeasurement = _measure(
          split.head,
          _pages.last.metrics,
        );

        if (headMeasurement.height >
            _pages.last.remainingHeight + 0.001) {
          if (_pages.last.blocks.isNotEmpty) {
            _pages.add(_createPage(_pages.length));
            continue;
          }
          throw PdfFlowLayoutException(
            'Block `${_blockId(pending)}` produced a split head '
            'larger than the available page body.',
          );
        }

        _append(_pages.last, split.head, headMeasurement);
        pending = split.tail;
        _pages.add(_createPage(_pages.length));
        continue;
      }

      if (measurement.height > page.metrics.bodyHeight &&
          !pending.breakPolicy.allowOverflow) {
        throw PdfFlowLayoutException(
          'Block `${_blockId(pending)}` requires '
          '${measurement.height.toStringAsFixed(1)}pt but the page body '
          'provides only ${page.metrics.bodyHeight.toStringAsFixed(1)}pt. '
          'Make the block splittable or set allowOverflow explicitly.',
        );
      }

      _append(page, pending, measurement);
      return;
    }
  }

  void _append(
    _PdfInternalPagePlan page,
    PdfBlock block,
    PdfBlockMeasurement measurement,
  ) {
    page.blocks.add(
      _PdfPlannedBlock(
        block: block,
        height: measurement.height,
      ),
    );
    page.usedHeight += measurement.height;
  }

  _PdfInternalPagePlan _createPage(int index) {
    final rawPageSize = section.pageSpec.resolveRawSize(builder.config);
    final effectivePageSize =
        section.pageSpec.resolveEffectiveSize(builder.config);
    final orientation =
        section.pageSpec.resolveOrientation(builder.config);

    final margins = builder.config.margins;
    final clientWidth = effectivePageSize.width -
        margins.left -
        margins.right;
    final clientHeight = effectivePageSize.height -
        margins.top -
        margins.bottom;

    if (clientWidth <= 0 || clientHeight <= 0) {
      throw const PdfFlowLayoutException(
        'Page size and margins leave no drawable client area.',
      );
    }

    final topBands = _topBandsForPage(
      index,
      clientWidth,
      clientHeight,
      effectivePageSize,
    );
    final bottomBands = _normalBottomBandsForPage(
      index,
      clientWidth,
      clientHeight,
      effectivePageSize,
    );

    final topBandHeight = topBands.fold<double>(
      0,
      (sum, item) => sum + item.height,
    );

    final normalFooterHeight = bottomBands.fold<double>(
      0,
      (sum, item) => sum + item.height,
    );

    final lastFooterHeight = _lastFooterReservedHeight(
      index,
      clientWidth,
      clientHeight,
      effectivePageSize,
    );

    final flowFooterReserve =
        normalFooterHeight > lastFooterHeight
            ? normalFooterHeight
            : lastFooterHeight;

    // Existing builder header/footer reservations are part of the same page
    // chrome budget as the new flow bands.
    final topReserve = builder._headerHeight + topBandHeight;
    final bottomReserve =
        builder._footerHeight + flowFooterReserve;
    final bodyHeight =
        clientHeight - topReserve - bottomReserve;

    if (bodyHeight <= 0) {
      throw PdfFlowLayoutException(
        'Header/footer/band reservations consume the complete page. '
        'Client height=${clientHeight.toStringAsFixed(1)}, '
        'top=${topReserve.toStringAsFixed(1)}, '
        'bottom=${bottomReserve.toStringAsFixed(1)}.',
      );
    }

    return _PdfInternalPagePlan(
      index: index,
      metrics: _PdfFlowMetrics(
        rawPageSize: rawPageSize,
        pageSize: effectivePageSize,
        orientation: orientation,
        clientWidth: clientWidth,
        clientHeight: clientHeight,
        topReserve: topReserve,
        bottomReserve: bottomReserve,
        bodyHeight: bodyHeight,
      ),
      topBands: topBands,
      bottomBands: bottomBands,
    );
  }

  List<_PdfPlannedBand> _topBandsForPage(
    int index,
    double width,
    double clientHeight,
    Size effectivePageSize,
  ) {
    final result = <_PdfPlannedBand>[];
    final primary = index == 0 && section.firstPageHeader != null
        ? section.firstPageHeader
        : section.pageHeader;

    if (primary != null) {
      result.add(
        _measureBand(
          primary,
          width,
          clientHeight,
          effectivePageSize,
        ),
      );
    }

    for (final band in section.repeatableBands) {
      if (band.placement != PdfBandPlacement.top) continue;
      if (index == 0 && !band.includeFirstPage) continue;
      result.add(
        _measureBand(
          band,
          width,
          clientHeight,
          effectivePageSize,
        ),
      );
    }

    return result;
  }

  List<_PdfPlannedBand> _normalBottomBandsForPage(
    int index,
    double width,
    double clientHeight,
    Size effectivePageSize,
  ) {
    final result = <_PdfPlannedBand>[];

    if (section.pageFooter != null) {
      result.add(
        _measureBand(
          section.pageFooter!,
          width,
          clientHeight,
          effectivePageSize,
        ),
      );
    }

    for (final band in section.repeatableBands) {
      if (band.placement != PdfBandPlacement.bottom) continue;
      if (index == 0 && !band.includeFirstPage) continue;
      result.add(
        _measureBand(
          band,
          width,
          clientHeight,
          effectivePageSize,
        ),
      );
    }

    return result;
  }

  double _lastFooterReservedHeight(
    int index,
    double width,
    double clientHeight,
    Size effectivePageSize,
  ) {
    var total = 0.0;

    if (section.lastPageFooter != null) {
      total += _measureBand(
        section.lastPageFooter!,
        width,
        clientHeight,
        effectivePageSize,
      ).height;
    } else if (section.pageFooter != null) {
      total += _measureBand(
        section.pageFooter!,
        width,
        clientHeight,
        effectivePageSize,
      ).height;
    }

    for (final band in section.repeatableBands) {
      if (band.placement != PdfBandPlacement.bottom) continue;
      if (index == 0 && !band.includeFirstPage) continue;
      total += _measureBand(
        band,
        width,
        clientHeight,
        effectivePageSize,
      ).height;
    }

    return total;
  }

  void _finalizeLastPageFooter() {
    if (_pages.isEmpty || section.lastPageFooter == null) return;

    final page = _pages.last;
    final replacement = <_PdfPlannedBand>[
      _measureBand(
        section.lastPageFooter!,
        page.metrics.clientWidth,
        page.metrics.clientHeight,
        page.metrics.pageSize,
      ),
    ];

    for (final band in section.repeatableBands) {
      if (band.placement != PdfBandPlacement.bottom) continue;
      if (page.index == 0 && !band.includeFirstPage) continue;
      replacement.add(
        _measureBand(
          band,
          page.metrics.clientWidth,
          page.metrics.clientHeight,
          page.metrics.pageSize,
        ),
      );
    }

    page.bottomBands = replacement;
  }

  _PdfPlannedBand _measureBand(
    PdfBand band,
    double width,
    double clientHeight,
    Size effectivePageSize,
  ) {
    final measurement = _measureWithContext(
      band,
      PdfMeasureContext(
        width: width,
        maxHeight: clientHeight,
        pageSize: effectivePageSize,
        baseFont: builder.baseFont,
        directionality: directionality,
      ),
    );
    return _PdfPlannedBand(
      band: band,
      height: measurement.height,
    );
  }

  PdfBlockMeasurement _measure(
    PdfBlock block,
    _PdfFlowMetrics metrics,
  ) {
    return _measureWithContext(
      block,
      _measureContext(metrics),
    );
  }

  PdfMeasureContext _measureContext(
    _PdfFlowMetrics metrics,
  ) {
    return PdfMeasureContext(
      width: metrics.clientWidth,
      maxHeight: metrics.bodyHeight,
      pageSize: metrics.pageSize,
      baseFont: builder.baseFont,
      directionality: directionality,
    );
  }

  PdfBlockMeasurement _measureWithContext(
    PdfBlock block,
    PdfMeasureContext context,
  ) {
    final key = '${identityHashCode(block)}|'
        '${context.width.toStringAsFixed(3)}|'
        '${context.maxHeight.toStringAsFixed(3)}|'
        '${context.pageSize.width.toStringAsFixed(2)}x'
        '${context.pageSize.height.toStringAsFixed(2)}|'
        '${context.directionality.resolve().direction.name}';

    final cached = _measurementCache[key];
    if (cached != null) return cached;

    final measurement = block.measure(context);
    if (!measurement.height.isFinite || measurement.height < 0) {
      throw PdfFlowLayoutException(
        'Block `${_blockId(block)}` returned an invalid measurement: '
        '${measurement.height}.',
      );
    }

    _measurementCount++;
    _measurementCache[key] = measurement;
    return measurement;
  }
}

String _blockId(PdfBlock block) =>
    block.id ?? block.runtimeType.toString();

GeniusPdfDirectionality _resolveSectionDirectionality(
  GeniusPdfDocumentBuilder builder,
  PdfFlowSection section,
) {
  final inherited = section.directionality ?? builder.directionality;
  if (section.direction == GeniusPdfDirection.auto) {
    return inherited;
  }
  return inherited.forComponent(section.direction);
}

/// S03 flow API for all existing [GeniusPdfDocumentBuilder] subclasses.
///
/// Existing builder methods remain unchanged; callers opt into flow sections
/// only when they need deterministic long-document pagination.
extension GeniusPdfFlowBuilderExtension on GeniusPdfDocumentBuilder {
  /// Runs the measurement/pagination pass without drawing anything.
  PdfFlowPlan planFlowSection(PdfFlowSection section) {
    return _PdfFlowPlanner(this, section).plan();
  }

  /// Measures (unless a compatible [plan] is supplied) and renders a section.
  PdfFlowResult addFlowSection(
    PdfFlowSection section, {
    PdfFlowPlan? plan,
  }) {
    final effectivePlan = plan ?? planFlowSection(section);
    if (!identical(effectivePlan._section, section)) {
      throw const PdfFlowLayoutException(
        'The supplied PdfFlowPlan belongs to a different PdfFlowSection.',
      );
    }

    final sectionDirectionality =
        _resolveSectionDirectionality(this, section);
    final existingPageCount = _document.pages.count;

    final originalOrientation =
        _document.pageSettings.orientation;
    final originalSize = _document.pageSettings.size;

    var renderedBlockCount = 0;
    var firstDocumentPageIndex = -1;
    var lastDocumentPageIndex = -1;

    try {
      for (var i = 0;
          i < effectivePlan._internalPages.length;
          i++) {
        final pagePlan = effectivePlan._internalPages[i];

        // Match the existing builder setting order: orientation, then size.
        _document.pageSettings.orientation =
            pagePlan.metrics.orientation;
        _document.pageSettings.size =
            pagePlan.metrics.rawPageSize;

        newPage();
        if (firstDocumentPageIndex < 0) {
          firstDocumentPageIndex = _currentIndex;
        }
        lastDocumentPageIndex = _currentIndex;

        final metadata = PdfFlowPageMetadata(
          sectionPageNumber: i + 1,
          sectionPageCount: effectivePlan.pageCount,
          documentPageNumber: existingPageCount + i + 1,
          documentPageCount:
              existingPageCount + effectivePlan.pageCount,
          directionality: sectionDirectionality,
          documentStatus: section.documentStatus,
          copyLabel: section.copyLabel,
        );

        var topY = _headerHeight;
        for (final plannedBand in pagePlan.topBands) {
          final bounds = Rect.fromLTWH(
            0,
            topY,
            pageWidth,
            plannedBand.height,
          );
          final before = _currentY;
          plannedBand.band.render(
            PdfFlowRenderContext(
              builder: this,
              bounds: bounds,
              metadata: metadata,
              directionality: sectionDirectionality,
              expectedHeight: plannedBand.height,
            ),
          );
          _currentY = before;
          topY += plannedBand.height;
        }

        _currentY = topY;

        for (final planned in pagePlan.blocks) {
          final startY = _currentY;
          final bounds = Rect.fromLTWH(
            0,
            startY,
            pageWidth,
            planned.height,
          );
          final result = planned.block.render(
            PdfFlowRenderContext(
              builder: this,
              bounds: bounds,
              metadata: metadata,
              directionality: sectionDirectionality,
              expectedHeight: planned.height,
            ),
          );
          renderedBlockCount++;

          final difference =
              (result.usedHeight - planned.height).abs();
          if (section.strictMeasurement &&
              difference > section.measurementTolerance) {
            throw PdfFlowLayoutException(
              'Block `${_blockId(planned.block)}` measured '
              '${planned.height.toStringAsFixed(2)}pt but rendered '
              '${result.usedHeight.toStringAsFixed(2)}pt. '
              'Keep measurement and rendering deterministic or increase '
              'measurementTolerance explicitly.',
            );
          }

          // Measurement is authoritative. This makes currentY predictable and
          // prevents custom callbacks from leaking internal Y mutations.
          _currentY = startY + planned.height;
        }

        final bodyEndY = _currentY;
        final footerHeight = pagePlan.bottomBands.fold<double>(
          0,
          (sum, item) => sum + item.height,
        );
        var footerY =
            pageHeight - _footerHeight - footerHeight;

        for (final plannedBand in pagePlan.bottomBands) {
          final bounds = Rect.fromLTWH(
            0,
            footerY,
            pageWidth,
            plannedBand.height,
          );
          final before = _currentY;
          plannedBand.band.render(
            PdfFlowRenderContext(
              builder: this,
              bounds: bounds,
              metadata: metadata,
              directionality: sectionDirectionality,
              expectedHeight: plannedBand.height,
            ),
          );
          _currentY = before;
          footerY += plannedBand.height;
        }

        _currentY = bodyEndY;
      }
    } finally {
      // Section-level custom page settings never leak to later legacy pages.
      _document.pageSettings.orientation = originalOrientation;
      _document.pageSettings.size = originalSize;
    }

    return PdfFlowResult(
      plan: effectivePlan,
      renderedBlockCount: renderedBlockCount,
      firstDocumentPageIndex: firstDocumentPageIndex,
      lastDocumentPageIndex: lastDocumentPageIndex,
      lastY: _currentY,
    );
  }
}
