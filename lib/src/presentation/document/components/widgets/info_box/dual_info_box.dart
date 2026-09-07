part of '../pdf_info_box.dart';

enum GeniusPdfDualInfoBoxLayout {
  /// Boxes side by side (horizontal).
  horizontal,

  /// Boxes stacked (vertical).
  vertical,

  /// Left box on top left, right box on bottom right (diagonal).
  diagonal,
}

/// A two-column info section for displaying parallel information.
///
/// Useful for invoice headers with customer and invoice details side by side.
///
/// Enhanced features:
/// - Multiple layout modes (horizontal, vertical, diagonal)
/// - RTL support (boxes swap positions)
/// - Equal height synchronization (draws both boxes at the taller height)
/// - Customizable proportions
/// - Connecting line between boxes
///
/// ## Example
/// ```dart
/// GeniusPdfDualInfoBox(
///   leftBox: customerInfo,
///   rightBox: invoiceInfo,
///   layout: GeniusPdfDualInfoBoxLayout.horizontal,
///   equalHeight: true,
/// )
/// ```
class GeniusPdfDualInfoBox {
  GeniusPdfDualInfoBox({
    required this.leftBox,
    required this.rightBox,
    this.spacing = 20,
    this.leftWidth,
    this.rightWidth,
    this.leftFlex = 1,
    this.rightFlex = 1,
    this.layout = GeniusPdfDualInfoBoxLayout.horizontal,
    this.equalHeight = false,
    this.verticalSpacing = 12,
    this.swapForRTL = true,
    this.showConnectingLine = false,
    this.connectingLineColor,
    this.connectingLineWidth = 0.5,
    this.backgroundColor,
    this.borderStyle,
    this.padding = const GeniusPdfCellPadding.all(0),
    this.alignment = GeniusPdfInfoBoxAlignment.top,
  });

  /// Creates a dual box from customer and invoice info.
  factory GeniusPdfDualInfoBox.customerInvoice({
    required GeniusPdfInfoBox customerBox,
    required GeniusPdfInfoBox invoiceBox,
    double spacing = 20,
    bool isRTL = false,
  }) {
    return GeniusPdfDualInfoBox(
      leftBox: isRTL ? invoiceBox : customerBox,
      rightBox: isRTL ? customerBox : invoiceBox,
      spacing: spacing,
      leftFlex: 1,
      rightFlex: 1,
      equalHeight: true,
      swapForRTL: false,
    );
  }

  /// Creates a dual box from shipping and billing info.
  factory GeniusPdfDualInfoBox.shippingBilling({
    required GeniusPdfInfoBox shippingBox,
    required GeniusPdfInfoBox billingBox,
    double spacing = 20,
  }) {
    return GeniusPdfDualInfoBox(
      leftBox: shippingBox,
      rightBox: billingBox,
      spacing: spacing,
      equalHeight: true,
    );
  }

  /// Left (or top in vertical layout) info box.
  final GeniusPdfInfoBox leftBox;

  /// Right (or bottom in vertical layout) info box.
  final GeniusPdfInfoBox rightBox;

  /// Horizontal spacing between boxes.
  final double spacing;

  /// Fixed width for left box (null for flex-based).
  final double? leftWidth;

  /// Fixed width for right box (null for flex-based).
  final double? rightWidth;

  /// Flex factor for left box width.
  final int leftFlex;

  /// Flex factor for right box width.
  final int rightFlex;

  /// Layout mode for the boxes.
  final GeniusPdfDualInfoBoxLayout layout;

  /// Whether both boxes should have equal height.
  final bool equalHeight;

  /// Vertical spacing when in vertical layout.
  final double verticalSpacing;

  /// Whether to swap boxes for RTL layout.
  final bool swapForRTL;

  /// Whether to show a connecting line between boxes.
  final bool showConnectingLine;

  /// Color for connecting line.
  final Color? connectingLineColor;

  /// Width of connecting line.
  final double connectingLineWidth;

  /// Background color for the combined area.
  final Color? backgroundColor;

  /// Border style for the combined area.
  final GeniusPdfBorderStyle? borderStyle;

  /// Padding around both boxes.
  final GeniusPdfCellPadding padding;

  /// Vertical alignment of boxes.
  final GeniusPdfInfoBoxAlignment alignment;

  /// Gets the effective left box based on RTL.
  GeniusPdfInfoBox _getLeftBox() {
    if (swapForRTL && leftBox.config.isRTL) {
      return rightBox;
    }
    return leftBox;
  }

  /// Gets the effective right box based on RTL.
  GeniusPdfInfoBox _getRightBox() {
    if (swapForRTL && leftBox.config.isRTL) {
      return leftBox;
    }
    return rightBox;
  }

  /// Draws both info boxes.
  Rect draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    GeniusPdfLogger.debug('Drawing DualInfoBox: layout=${layout.name}',
        tag: 'InfoBox');
    final graphics = page.graphics;
    final contentBounds = Rect.fromLTWH(
      bounds.left + padding.left,
      bounds.top + padding.top,
      bounds.width - padding.left - padding.right,
      bounds.height - padding.top - padding.bottom,
    );

    // Draw background if specified
    if (backgroundColor != null) {
      graphics.drawRectangle(
        brush: PdfSolidBrush(backgroundColor!.toPdfColor()),
        bounds: bounds,
      );
    }

    Rect resultBounds;

    switch (layout) {
      case GeniusPdfDualInfoBoxLayout.horizontal:
        resultBounds = _drawHorizontal(page, contentBounds);
        break;
      case GeniusPdfDualInfoBoxLayout.vertical:
        resultBounds = _drawVertical(page, contentBounds);
        break;
      case GeniusPdfDualInfoBoxLayout.diagonal:
        resultBounds = _drawDiagonal(page, contentBounds);
        break;
    }

    // Draw border if specified
    if (borderStyle != null && borderStyle!.width > 0) {
      final finalBounds = Rect.fromLTWH(
        bounds.left,
        bounds.top,
        bounds.width,
        resultBounds.height + padding.top + padding.bottom,
      );
      GeniusPdfInfoBox._drawBorder(graphics, finalBounds, borderStyle!);
    }

    return Rect.fromLTWH(
      bounds.left,
      bounds.top,
      bounds.width,
      resultBounds.height + padding.top + padding.bottom,
    );
  }

  Rect _drawHorizontal(PdfPage page, Rect bounds) {
    final graphics = page.graphics;
    final totalWidth = bounds.width;
    final effectiveLeft = _getLeftBox();
    final effectiveRight = _getRightBox();

    // Calculate widths
    double leftW;
    double rightW;
    if (leftWidth != null) {
      leftW = leftWidth!;
      rightW = rightWidth ?? (totalWidth - leftW - spacing);
    } else if (rightWidth != null) {
      rightW = rightWidth!;
      leftW = totalWidth - rightW - spacing;
    } else {
      final totalFlex = leftFlex + rightFlex;
      final availableWidth = totalWidth - spacing;
      leftW = availableWidth * leftFlex / totalFlex;
      rightW = availableWidth * rightFlex / totalFlex;
    }

    // When equalHeight is enabled, pre-calculate heights and use the max
    double? forcedHeight;
    if (equalHeight) {
      final leftH = effectiveLeft.estimateHeight(leftW);
      final rightH = effectiveRight.estimateHeight(rightW);
      forcedHeight = leftH > rightH ? leftH : rightH;

      // Apply minHeight from styles
      if (effectiveLeft.style.minHeight != null &&
          forcedHeight < effectiveLeft.style.minHeight!) {
        forcedHeight = effectiveLeft.style.minHeight!;
      }
      if (effectiveRight.style.minHeight != null &&
          forcedHeight < effectiveRight.style.minHeight!) {
        forcedHeight = effectiveRight.style.minHeight!;
      }
    }

    final leftBoxWithHeight = equalHeight && forcedHeight != null
        ? effectiveLeft.copyWith(
            style: effectiveLeft.style.copyWith(minHeight: forcedHeight))
        : effectiveLeft;
    final rightBoxWithHeight = equalHeight && forcedHeight != null
        ? effectiveRight.copyWith(
            style: effectiveRight.style.copyWith(minHeight: forcedHeight))
        : effectiveRight;

    final leftBounds = Rect.fromLTWH(
      bounds.left,
      bounds.top,
      leftW,
      bounds.height,
    );

    final rightBounds = Rect.fromLTWH(
      bounds.left + leftW + spacing,
      bounds.top,
      rightW,
      bounds.height,
    );

    final leftResult = leftBoxWithHeight.draw(page: page, bounds: leftBounds);
    final rightResult =
        rightBoxWithHeight.draw(page: page, bounds: rightBounds);

    // Draw connecting line if enabled
    if (showConnectingLine) {
      final lineX = bounds.left + leftW + spacing / 2;
      final lineColor = connectingLineColor ?? const Color(0xFFE0E0E0);
      final maxH = leftResult.height > rightResult.height
          ? leftResult.height
          : rightResult.height;
      graphics.drawLine(
        PdfPen(lineColor.toPdfColor(), width: connectingLineWidth),
        Offset(lineX, bounds.top),
        Offset(lineX, bounds.top + maxH),
      );
    }

    // Return combined bounds
    final maxHeight = leftResult.height > rightResult.height
        ? leftResult.height
        : rightResult.height;

    return Rect.fromLTWH(
      bounds.left,
      bounds.top,
      bounds.width,
      maxHeight,
    );
  }

  Rect _drawVertical(PdfPage page, Rect bounds) {
    final effectiveLeft = _getLeftBox();
    final effectiveRight = _getRightBox();

    final topBounds = Rect.fromLTWH(
      bounds.left,
      bounds.top,
      bounds.width,
      bounds.height / 2,
    );

    final topResult = effectiveLeft.draw(page: page, bounds: topBounds);

    final bottomBounds = Rect.fromLTWH(
      bounds.left,
      bounds.top + topResult.height + verticalSpacing,
      bounds.width,
      bounds.height - topResult.height - verticalSpacing,
    );

    final bottomResult = effectiveRight.draw(page: page, bounds: bottomBounds);

    // Draw connecting line if enabled
    if (showConnectingLine) {
      final lineY = bounds.top + topResult.height + verticalSpacing / 2;
      final lineColor = connectingLineColor ?? const Color(0xFFE0E0E0);
      page.graphics.drawLine(
        PdfPen(lineColor.toPdfColor(), width: connectingLineWidth),
        Offset(bounds.left, lineY),
        Offset(bounds.right, lineY),
      );
    }

    return Rect.fromLTWH(
      bounds.left,
      bounds.top,
      bounds.width,
      topResult.height + verticalSpacing + bottomResult.height,
    );
  }

  Rect _drawDiagonal(PdfPage page, Rect bounds) {
    // Diagonal layout: left on top-left area, right on bottom-right area
    final effectiveLeft = _getLeftBox();
    final effectiveRight = _getRightBox();

    final halfWidth = (bounds.width - spacing) / 2;

    final topLeftBounds = Rect.fromLTWH(
      bounds.left,
      bounds.top,
      halfWidth,
      bounds.height / 2,
    );

    final topLeftResult = effectiveLeft.draw(page: page, bounds: topLeftBounds);

    final bottomRightBounds = Rect.fromLTWH(
      bounds.left + halfWidth + spacing,
      bounds.top + topLeftResult.height + verticalSpacing,
      halfWidth,
      bounds.height / 2,
    );

    final bottomRightResult =
        effectiveRight.draw(page: page, bounds: bottomRightBounds);

    return Rect.fromLTWH(
      bounds.left,
      bounds.top,
      bounds.width,
      topLeftResult.height + verticalSpacing + bottomRightResult.height,
    );
  }
}

/// Title position options for section.
