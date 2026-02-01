// ignore_for_file: unnecessary_import, implementation_imports

import 'dart:math' as math;
import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart'
    hide PdfTextStyle, PdfBorderStyle;

import '../../../core/pdf_config.dart';
import '../../../core/pdf_print_theme.dart';
import '../../models/chart_models.dart';

/// مخطط دائري للـ PDF
/// Pie chart component for PDF documents
class GeniusPdfPieChart {
  GeniusPdfPieChart({
    this.title,
    this.titleAr,
    required this.dataPoints,
    this.legend = const GeniusChartLegend(),
    required this.config,
    this.settings = const GeniusPieChartSettings(),
    this.width,
    this.height = 250,
    this.colors,
  }) : style = _chartStyleFromTheme(config.printTheme);

  /// عنوان المخطط
  final String? title;

  /// عنوان المخطط بالعربية
  final String? titleAr;

  /// نقاط البيانات
  final List<GeniusChartDataPoint> dataPoints;

  /// وسيلة الإيضاح
  final GeniusChartLegend legend;

  /// نمط المخطط
  final GeniusChartStyle style;

  /// PDF configuration
  final GeniusPdfConfig config;

  /// إعدادات المخطط الدائري
  final GeniusPieChartSettings settings;

  /// العرض
  final double? width;

  /// الارتفاع
  final double height;

  /// ألوان مخصصة
  final List<Color>? colors;

  static GeniusChartStyle _chartStyleFromTheme(GeniusPdfPrintTheme theme) {
    final colors = theme.colorScheme;
    final typography = theme.typography;

    return GeniusChartStyle(
      backgroundColor: colors.surface,
      textColor: colors.onSurface,
      axisColor: colors.dividerColor,
      titleFontSize: typography.headingSize,
      labelFontSize: typography.bodySize,
      valueFontSize: typography.captionSize,
      padding: theme.spacing.md,
      showBorder: true,
      borderColor: colors.borderColor,
    );
  }

  /// الحصول على العنوان حسب اتجاه النص
  String? get displayTitle => config.isRTL ? (titleAr ?? title) : title;

  /// الحصول على المجموع الكلي
  double get total => dataPoints.fold(0, (sum, p) => sum + p.value);

  /// رسم المخطط على الصفحة
  PdfLayoutResult draw(PdfPage page, Rect bounds) {
    final graphics = page.graphics;
    final chartWidth = width ?? bounds.width;
    final chartBounds =
        Rect.fromLTWH(bounds.left, bounds.top, chartWidth, height);

    // رسم الخلفية
    _drawBackground(graphics, chartBounds);

    // حساب مناطق الرسم
    final areas = _calculateAreas(chartBounds);

    // رسم العنوان
    if (displayTitle != null) {
      _drawTitle(graphics, areas.titleArea);
    }

    // رسم المخطط الدائري
    _drawPie(graphics, areas.pieArea);

    // رسم وسيلة الإيضاح
    if (legend.show) {
      _drawLegend(graphics, areas.legendArea);
    }

    // رسم الحدود
    if (style.showBorder) {
      graphics.drawRectangle(
        pen: PdfPen(_colorToPdfColor(style.borderColor)),
        bounds: chartBounds,
      );
    }

    return _createLayoutResult(page, chartBounds)!;
  }

  void _drawBackground(PdfGraphics graphics, Rect bounds) {
    graphics.drawRectangle(
      brush: PdfSolidBrush(_colorToPdfColor(style.backgroundColor)),
      bounds: bounds,
    );
  }

  _PieChartAreas _calculateAreas(Rect bounds) {
    double titleHeight = 0;
    double legendHeight = 0;

    if (displayTitle != null) {
      titleHeight = style.titleFontSize + style.padding * 2;
    }

    if (legend.show) {
      if (legend.position == GeniusChartLegendPosition.bottom) {
        legendHeight = (dataPoints.length * (legend.iconSize + 4))
            .clamp(30, 80)
            .toDouble();
      } else if (legend.position == GeniusChartLegendPosition.right) {
        // سيتم حساب العرض بدلاً من الارتفاع
      }
    }

    final titleArea = Rect.fromLTWH(
      bounds.left,
      bounds.top,
      bounds.width,
      titleHeight,
    );

    double pieWidth = bounds.width;
    double legendWidth = 0;

    if (legend.show && legend.position == GeniusChartLegendPosition.right) {
      legendWidth = 120;
      pieWidth = bounds.width - legendWidth;
    }

    final availableHeight =
        bounds.height - titleHeight - legendHeight - style.padding * 2;
    final pieSize = math.min(pieWidth - style.padding * 2, availableHeight);

    final pieArea = Rect.fromLTWH(
      bounds.left + (pieWidth - pieSize) / 2,
      bounds.top +
          titleHeight +
          style.padding +
          (availableHeight - pieSize) / 2,
      pieSize,
      pieSize,
    );

    Rect legendArea;
    if (legend.position == GeniusChartLegendPosition.right) {
      legendArea = Rect.fromLTWH(
        bounds.left + pieWidth,
        bounds.top + titleHeight,
        legendWidth,
        bounds.height - titleHeight,
      );
    } else {
      legendArea = Rect.fromLTWH(
        bounds.left,
        bounds.bottom - legendHeight,
        bounds.width,
        legendHeight,
      );
    }

    return _PieChartAreas(
      titleArea: titleArea,
      pieArea: pieArea,
      legendArea: legendArea,
    );
  }

  void _drawTitle(PdfGraphics graphics, Rect area) {
    // Font - baseFont and boldFont are required for Arabic support, no fallback to Helvetica
    final font = config.boldFont;
    graphics.drawString(
      displayTitle!,
      font,
      brush: PdfSolidBrush(_colorToPdfColor(style.textColor)),
      bounds: area,
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
        lineAlignment: PdfVerticalAlignment.middle,
      ),
    );
  }

  void _drawPie(PdfGraphics graphics, Rect pieArea) {
    if (dataPoints.isEmpty || total == 0) return;

    final center = pieArea.center;
    final outerRadius = pieArea.width / 2;
    final innerRadius = outerRadius * settings.innerRadiusRatio;

    double currentAngle = settings.startAngle * math.pi / 180;
    // Font - baseFont is required for Arabic support, no fallback to Helvetica
    final labelFont = config.baseFont;
    final valueFont = config.baseFont;

    for (int i = 0; i < dataPoints.length; i++) {
      final point = dataPoints[i];
      final sweepAngle = (point.value / total) * 2 * math.pi;
      final color = point.color ??
          colors?[i % (colors?.length ?? 1)] ??
          GeniusChartColors.getColor(i);

      // رسم الشريحة
      _drawSlice(
        graphics,
        center,
        outerRadius,
        innerRadius,
        currentAngle,
        sweepAngle,
        color,
      );

      // رسم التسمية
      if (settings.showLabels ||
          settings.showPercentages ||
          settings.showValues) {
        _drawLabel(
          graphics,
          center,
          outerRadius,
          currentAngle,
          sweepAngle,
          point,
          labelFont,
          valueFont,
        );
      }

      currentAngle += sweepAngle + (settings.sliceSpacing * math.pi / 180);
    }

    // رسم الدائرة الداخلية للمخطط المجوف
    if (settings.innerRadiusRatio > 0) {
      graphics.drawEllipse(
        Rect.fromCircle(center: center, radius: innerRadius),
        brush: PdfSolidBrush(_colorToPdfColor(style.backgroundColor)),
      );

      // رسم المجموع في المنتصف
      if (settings.innerRadiusRatio >= 0.4) {
        // Font - baseFont and boldFont are required for Arabic support
        final totalFont = config.boldFont;
        graphics.drawString(
          _formatValue(total),
          totalFont,
          brush: PdfSolidBrush(_colorToPdfColor(style.textColor)),
          bounds: Rect.fromCircle(center: center, radius: innerRadius * 0.8),
          format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle,
          ),
        );
      }
    }
  }

  void _drawSlice(
    PdfGraphics graphics,
    Offset center,
    double outerRadius,
    double innerRadius,
    double startAngle,
    double sweepAngle,
    Color color,
  ) {
    final path = PdfPath();

    if (innerRadius > 0) {
      // مخطط دائري مجوف (Donut)
      // النقطة الخارجية الأولى
      final outerStart = Offset(
        center.dx + outerRadius * math.cos(startAngle),
        center.dy + outerRadius * math.sin(startAngle),
      );

      // القوس الخارجي
      path.addArc(
        Rect.fromCircle(center: center, radius: outerRadius),
        startAngle * 180 / math.pi,
        sweepAngle * 180 / math.pi,
      );

      // الخط إلى الدائرة الداخلية
      final outerEnd = Offset(
        center.dx + outerRadius * math.cos(startAngle + sweepAngle),
        center.dy + outerRadius * math.sin(startAngle + sweepAngle),
      );
      final innerEnd = Offset(
        center.dx + innerRadius * math.cos(startAngle + sweepAngle),
        center.dy + innerRadius * math.sin(startAngle + sweepAngle),
      );
      path.addLine(outerEnd, innerEnd);

      // القوس الداخلي (عكس الاتجاه)
      path.addArc(
        Rect.fromCircle(center: center, radius: innerRadius),
        (startAngle + sweepAngle) * 180 / math.pi,
        -sweepAngle * 180 / math.pi,
      );

      // الخط لإغلاق المسار
      final innerStart = Offset(
        center.dx + innerRadius * math.cos(startAngle),
        center.dy + innerRadius * math.sin(startAngle),
      );
      path.addLine(innerStart, outerStart);

      path.closeFigure();
    } else {
      // مخطط دائري كامل - استخدام addPie
      path.addPie(
        Rect.fromCircle(center: center, radius: outerRadius),
        startAngle * 180 / math.pi,
        sweepAngle * 180 / math.pi,
      );
    }

    graphics.drawPath(
      path,
      brush: PdfSolidBrush(_colorToPdfColor(color)),
      pen: PdfPen(PdfColor(255, 255, 255), width: 1),
    );
  }

  void _drawLabel(
    PdfGraphics graphics,
    Offset center,
    double radius,
    double startAngle,
    double sweepAngle,
    GeniusChartDataPoint point,
    PdfFont labelFont,
    PdfFont valueFont,
  ) {
    final midAngle = startAngle + sweepAngle / 2;
    final percentage = (point.value / total) * 100;

    String labelText = '';
    if (settings.showLabels) {
      labelText = point.getLabel(config.isRTL);
    }
    if (settings.showPercentages) {
      final percentText = '${percentage.toStringAsFixed(1)}%';
      labelText = labelText.isEmpty ? percentText : '$labelText\n$percentText';
    }
    if (settings.showValues) {
      final valueText = _formatValue(point.value);
      labelText = labelText.isEmpty ? valueText : '$labelText\n$valueText';
    }

    if (labelText.isEmpty) return;

    Offset labelPos;
    PdfTextAlignment alignment;

    if (settings.labelPosition == GeniusPieLabelPosition.inside) {
      final labelRadius = radius * (settings.innerRadiusRatio > 0 ? 0.75 : 0.6);
      labelPos = Offset(
        center.dx + labelRadius * math.cos(midAngle),
        center.dy + labelRadius * math.sin(midAngle),
      );
      alignment = PdfTextAlignment.center;
    } else {
      final labelRadius = radius * 1.15;
      labelPos = Offset(
        center.dx + labelRadius * math.cos(midAngle),
        center.dy + labelRadius * math.sin(midAngle),
      );
      alignment =
          midAngle.abs() < math.pi / 2 || midAngle.abs() > 3 * math.pi / 2
              ? PdfTextAlignment.left
              : PdfTextAlignment.right;
    }

    graphics.drawString(
      labelText,
      settings.labelPosition == GeniusPieLabelPosition.inside
          ? valueFont
          : labelFont,
      brush: PdfSolidBrush(_colorToPdfColor(
        settings.labelPosition == GeniusPieLabelPosition.inside
            ? const Color(0xFFFFFFFF)
            : style.textColor,
      )),
      bounds: Rect.fromCenter(center: labelPos, width: 80, height: 40),
      format: PdfStringFormat(
        alignment: alignment,
        lineAlignment: PdfVerticalAlignment.middle,
      ),
    );
  }

  void _drawLegend(PdfGraphics graphics, Rect area) {
    // Font - baseFont is required for Arabic support, no fallback to Helvetica
    final font = config.baseFont;
    final itemHeight = legend.iconSize + 4;

    if (legend.position == GeniusChartLegendPosition.right ||
        legend.orientation == GeniusChartLegendOrientation.vertical) {
      // وسيلة إيضاح عمودية
      var y = area.top + style.padding;

      for (int i = 0; i < dataPoints.length; i++) {
        final point = dataPoints[i];
        final color = point.color ??
            colors?[i % (colors?.length ?? 1)] ??
            GeniusChartColors.getColor(i);

        // رسم أيقونة اللون
        graphics.drawRectangle(
          brush: PdfSolidBrush(_colorToPdfColor(color)),
          bounds: Rect.fromLTWH(
              area.left + style.padding, y, legend.iconSize, legend.iconSize),
        );

        // رسم الاسم والنسبة
        final percentage = (point.value / total) * 100;
        final text =
            '${point.getLabel(config.isRTL)} (${percentage.toStringAsFixed(1)}%)';
        graphics.drawString(
          text,
          font,
          brush: PdfSolidBrush(_colorToPdfColor(style.textColor)),
          bounds: Rect.fromLTWH(
            area.left + style.padding + legend.iconSize + 4,
            y,
            area.width - legend.iconSize - style.padding * 2 - 4,
            legend.iconSize,
          ),
          format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle),
        );

        y += itemHeight;
      }
    } else {
      // وسيلة إيضاح أفقية
      const itemWidth = 100.0;
      final totalWidth = dataPoints.length * itemWidth;
      var x = area.left + (area.width - totalWidth) / 2;
      final y = area.top + style.padding;

      for (int i = 0; i < dataPoints.length; i++) {
        final point = dataPoints[i];
        final color = point.color ??
            colors?[i % (colors?.length ?? 1)] ??
            GeniusChartColors.getColor(i);

        // رسم أيقونة اللون
        graphics.drawRectangle(
          brush: PdfSolidBrush(_colorToPdfColor(color)),
          bounds: Rect.fromLTWH(x, y, legend.iconSize, legend.iconSize),
        );

        // رسم الاسم
        graphics.drawString(
          point.getLabel(config.isRTL),
          font,
          brush: PdfSolidBrush(_colorToPdfColor(style.textColor)),
          bounds: Rect.fromLTWH(x + legend.iconSize + 4, y,
              itemWidth - legend.iconSize - 4, legend.iconSize),
          format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle),
        );

        x += itemWidth;
      }
    }
  }

  String _formatValue(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }

  PdfColor _colorToPdfColor(Color color) {
    return PdfColor(color.red, color.green, color.blue);
  }

  /// Creates a PdfLayoutResult for the given bounds using PdfTextElement.
  PdfLayoutResult? _createLayoutResult(PdfPage page, Rect bounds) {
    final dummyElement = PdfTextElement(
      text: ' ',
      font: config.baseFont,
    );
    return dummyElement.draw(
      page: page,
      bounds: Rect.fromLTWH(bounds.left, bounds.bottom, 1, 1),
    );
  }
}

class _PieChartAreas {
  _PieChartAreas({
    required this.titleArea,
    required this.pieArea,
    required this.legendArea,
  });
  final Rect titleArea;
  final Rect pieArea;
  final Rect legendArea;
}
