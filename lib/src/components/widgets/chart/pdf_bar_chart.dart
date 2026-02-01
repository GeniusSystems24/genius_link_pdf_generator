// ignore_for_file: implementation_imports, unnecessary_import, deprecated_member_use

import 'dart:math' as math;
import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../core/pdf_config.dart';
import '../../../core/pdf_print_theme.dart';
import '../../models/chart_models.dart';

/// مخطط الأعمدة للـ PDF
/// Bar chart component for PDF documents
class GeniusPdfBarChart {
  GeniusPdfBarChart({
    this.title,
    this.titleAr,
    required this.series,
    this.xAxis = const GeniusChartAxis(),
    this.yAxis = const GeniusChartAxis(),
    this.legend = const GeniusChartLegend(),
    required this.config,
    this.settings = const GeniusBarChartSettings(),
    this.width,
    this.height = 250,
  }) : style = _chartStyleFromTheme(config.printTheme);

  /// عنوان المخطط
  final String? title;

  /// عنوان المخطط بالعربية
  final String? titleAr;

  /// سلاسل البيانات
  final List<GeniusChartSeries> series;

  /// إعدادات المحور السيني
  final GeniusChartAxis xAxis;

  /// إعدادات المحور الصادي
  final GeniusChartAxis yAxis;

  /// وسيلة الإيضاح
  final GeniusChartLegend legend;

  /// نمط المخطط
  final GeniusChartStyle style;

  /// PDF configuration
  final GeniusPdfConfig config;

  /// إعدادات المخطط الشريطي
  final GeniusBarChartSettings settings;

  /// العرض
  final double? width;

  /// الارتفاع
  final double height;

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

  /// رسم المخطط على الصفحة
  PdfLayoutResult draw(PdfPage page, Rect bounds) {
    final graphics = page.graphics;
    final chartWidth = width ?? bounds.width;
    final chartBounds =
        Rect.fromLTWH(bounds.left, bounds.top, chartWidth, height);

    // رسم الخلفية
    _drawBackground(graphics, chartBounds);

    // حساب مناطق الرسم
    final areas = _calculateAreas(chartBounds, graphics);

    // رسم العنوان
    if (displayTitle != null) {
      _drawTitle(graphics, areas.titleArea);
    }

    // رسم المحاور
    _drawAxes(graphics, areas.plotArea);

    // رسم الأعمدة
    _drawBars(graphics, areas.plotArea);

    // رسم وسيلة الإيضاح
    if (legend.show && series.length > 1) {
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

  _ChartAreas _calculateAreas(Rect bounds, PdfGraphics graphics) {
    double titleHeight = 0;
    double legendHeight = 0;
    const double axisLabelWidth = 50;
    const double axisLabelHeight = 30;

    if (displayTitle != null) {
      titleHeight = style.titleFontSize + style.padding * 2;
    }

    if (legend.show && series.length > 1) {
      legendHeight = legend.iconSize + style.padding * 2;
    }

    final titleArea = Rect.fromLTWH(
      bounds.left,
      bounds.top,
      bounds.width,
      titleHeight,
    );

    final legendArea = Rect.fromLTWH(
      bounds.left,
      bounds.bottom - legendHeight,
      bounds.width,
      legendHeight,
    );

    final plotArea = Rect.fromLTWH(
      bounds.left + axisLabelWidth,
      bounds.top + titleHeight + style.padding,
      bounds.width - axisLabelWidth - style.padding,
      bounds.height -
          titleHeight -
          legendHeight -
          axisLabelHeight -
          style.padding * 2,
    );

    return _ChartAreas(
      titleArea: titleArea,
      plotArea: plotArea,
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

  /// حساب القيمة القصوى بحسب نوع المخطط
  double _calculateMaxValue() {
    if (settings.type == GeniusBarChartType.stacked) {
      if (series.isEmpty) return 0;
      final pointCount = series.first.dataPoints.length;
      double maxStacked = 0;
      for (int i = 0; i < pointCount; i++) {
        double stackedValue = 0;
        for (final s in series) {
          if (i < s.dataPoints.length) {
            stackedValue += s.dataPoints[i].value;
          }
        }
        if (stackedValue > maxStacked) maxStacked = stackedValue;
      }
      return maxStacked;
    } else {
      double maxValue = 0;
      for (final s in series) {
        if (s.maxValue > maxValue) maxValue = s.maxValue;
      }
      return maxValue;
    }
  }

  void _drawAxes(PdfGraphics graphics, Rect plotArea) {
    final axisPen = PdfPen(_colorToPdfColor(style.axisColor), width: 1);
    final gridPen = PdfPen(_colorToPdfColor(xAxis.gridLineColor), width: 0.5);
    // Font - baseFont is required for Arabic support, no fallback to Helvetica
    final font = config.baseFont;

    // حساب القيم القصوى
    double maxValue = _calculateMaxValue();
    maxValue = _roundUpToNice(maxValue);

    // رسم المحور الصادي
    graphics.drawLine(
      axisPen,
      Offset(plotArea.left, plotArea.top),
      Offset(plotArea.left, plotArea.bottom),
    );

    // رسم المحور السيني
    graphics.drawLine(
      axisPen,
      Offset(plotArea.left, plotArea.bottom),
      Offset(plotArea.right, plotArea.bottom),
    );

    // رسم خطوط الشبكة والتسميات على المحور الصادي
    final divisions = yAxis.divisions;
    for (int i = 0; i <= divisions; i++) {
      final y = plotArea.bottom - (plotArea.height * i / divisions);
      final value = maxValue * i / divisions;

      if (yAxis.showGridLines && i > 0) {
        graphics.drawLine(
            gridPen, Offset(plotArea.left, y), Offset(plotArea.right, y));
      }

      final valueText = yAxis.formatValue(value);
      graphics.drawString(
        valueText,
        font,
        brush: PdfSolidBrush(_colorToPdfColor(style.textColor)),
        bounds: Rect.fromLTWH(plotArea.left - 45, y - 6, 40, 12),
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
      );
    }

    // رسم تسميات المحور السيني
    if (series.isNotEmpty && series.first.dataPoints.isNotEmpty) {
      final dataPoints = series.first.dataPoints;
      final barTotalWidth = _calculateBarTotalWidth();
      final totalBarsWidth = barTotalWidth * dataPoints.length;
      final startX = plotArea.left + (plotArea.width - totalBarsWidth) / 2;

      for (int i = 0; i < dataPoints.length; i++) {
        final x = startX + barTotalWidth * i + barTotalWidth / 2;
        graphics.drawString(
          dataPoints[i].getLabel(config.isRTL),
          font,
          brush: PdfSolidBrush(_colorToPdfColor(style.textColor)),
          bounds: Rect.fromLTWH(x - 30, plotArea.bottom + 5, 60, 20),
          format: PdfStringFormat(alignment: PdfTextAlignment.center),
        );
      }
    }
  }

  void _drawBars(PdfGraphics graphics, Rect plotArea) {
    if (series.isEmpty) return;

    double maxValue = _calculateMaxValue();
    maxValue = _roundUpToNice(maxValue);

    final dataPoints = series.first.dataPoints;
    final barTotalWidth = _calculateBarTotalWidth();
    final totalBarsWidth = barTotalWidth * dataPoints.length;
    final startX = plotArea.left + (plotArea.width - totalBarsWidth) / 2;

    // Font - baseFont is required for Arabic support, no fallback to Helvetica
    final valueFont = config.baseFont;

    switch (settings.type) {
      case GeniusBarChartType.vertical:
      case GeniusBarChartType.grouped:
        _drawGroupedBars(
            graphics, plotArea, maxValue, startX, barTotalWidth, valueFont);
        break;
      case GeniusBarChartType.stacked:
        _drawStackedBars(
            graphics, plotArea, maxValue, startX, barTotalWidth, valueFont);
        break;
      case GeniusBarChartType.horizontal:
        _drawHorizontalBars(graphics, plotArea, maxValue, valueFont);
        break;
    }
  }

  void _drawGroupedBars(
    PdfGraphics graphics,
    Rect plotArea,
    double maxValue,
    double startX,
    double barTotalWidth,
    PdfFont valueFont,
  ) {
    final dataPoints = series.first.dataPoints;
    final seriesCount = series.length;
    final singleBarWidth = seriesCount > 1
        ? (settings.barWidth - settings.barSpacing * (seriesCount - 1)) /
            seriesCount
        : settings.barWidth;

    for (int i = 0; i < dataPoints.length; i++) {
      final groupX =
          startX + barTotalWidth * i + (barTotalWidth - settings.barWidth) / 2;

      for (int s = 0; s < series.length; s++) {
        if (i >= series[s].dataPoints.length) continue;

        final value = series[s].dataPoints[i].value;
        final barHeight = (value / maxValue) * plotArea.height;
        final barX = groupX + s * (singleBarWidth + settings.barSpacing);
        final barY = plotArea.bottom - barHeight;

        final color = series[s].dataPoints[i].color ?? series[s].color;

        // رسم العمود
        if (settings.cornerRadius > 0) {
          _drawRoundedBar(
              graphics, barX, barY, singleBarWidth, barHeight, color);
        } else {
          graphics.drawRectangle(
            brush: PdfSolidBrush(_colorToPdfColor(color)),
            bounds: Rect.fromLTWH(barX, barY, singleBarWidth, barHeight),
          );
        }

        // رسم القيمة
        if (settings.showValues) {
          graphics.drawString(
            yAxis.formatValue(value),
            valueFont,
            brush: PdfSolidBrush(_colorToPdfColor(style.textColor)),
            bounds: Rect.fromLTWH(barX - 5, barY - 15, singleBarWidth + 10, 12),
            format: PdfStringFormat(alignment: PdfTextAlignment.center),
          );
        }
      }
    }
  }

  void _drawStackedBars(
    PdfGraphics graphics,
    Rect plotArea,
    double maxValue,
    double startX,
    double barTotalWidth,
    PdfFont valueFont,
  ) {
    final dataPoints = series.first.dataPoints;

    for (int i = 0; i < dataPoints.length; i++) {
      final barX =
          startX + barTotalWidth * i + (barTotalWidth - settings.barWidth) / 2;
      double currentY = plotArea.bottom;

      for (int s = 0; s < series.length; s++) {
        if (i >= series[s].dataPoints.length) continue;

        final value = series[s].dataPoints[i].value;
        final barHeight = (value / maxValue) * plotArea.height;
        currentY -= barHeight;

        final color = series[s].color;

        graphics.drawRectangle(
          brush: PdfSolidBrush(_colorToPdfColor(color)),
          bounds: Rect.fromLTWH(barX, currentY, settings.barWidth, barHeight),
        );
      }
    }
  }

  void _drawHorizontalBars(
    PdfGraphics graphics,
    Rect plotArea,
    double maxValue,
    PdfFont valueFont,
  ) {
    if (series.isEmpty) return;

    final dataPoints = series.first.dataPoints;
    final barHeight =
        (plotArea.height - settings.barSpacing * (dataPoints.length - 1)) /
            dataPoints.length;
    final actualBarHeight = math.min(barHeight, settings.barWidth);
    final barSpacing = (plotArea.height - actualBarHeight * dataPoints.length) /
        (dataPoints.length + 1);

    for (int i = 0; i < dataPoints.length; i++) {
      final value = dataPoints[i].value;
      final barWidth = (value / maxValue) * plotArea.width;
      final barY =
          plotArea.top + barSpacing + i * (actualBarHeight + barSpacing);

      final color = dataPoints[i].color ?? series.first.color;

      graphics.drawRectangle(
        brush: PdfSolidBrush(_colorToPdfColor(color)),
        bounds: Rect.fromLTWH(plotArea.left, barY, barWidth, actualBarHeight),
      );

      if (settings.showValues) {
        graphics.drawString(
          yAxis.formatValue(value),
          valueFont,
          brush: PdfSolidBrush(_colorToPdfColor(style.textColor)),
          bounds: Rect.fromLTWH(
              plotArea.left + barWidth + 5, barY, 50, actualBarHeight),
          format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle),
        );
      }
    }
  }

  void _drawRoundedBar(
    PdfGraphics graphics,
    double x,
    double y,
    double width,
    double height,
    Color color,
  ) {
    final path = PdfPath();
    final radius = math.min(settings.cornerRadius, width / 2);

    // رسم مستطيل بحواف مستديرة من الأعلى فقط باستخدام الأقواس والخطوط
    // البدء من أسفل اليسار والذهاب لأعلى
    path.addLine(Offset(x, y + height), Offset(x, y + radius));
    path.addArc(
      Rect.fromLTWH(x, y, radius * 2, radius * 2),
      180,
      90,
    );
    // الخط العلوي من اليسار لليمين
    path.addLine(Offset(x + radius, y), Offset(x + width - radius, y));
    path.addArc(
      Rect.fromLTWH(x + width - radius * 2, y, radius * 2, radius * 2),
      270,
      90,
    );
    // الخط الأيمن من الأعلى للأسفل
    path.addLine(Offset(x + width, y + radius), Offset(x + width, y + height));
    path.closeFigure();

    graphics.drawPath(
      path,
      brush: PdfSolidBrush(_colorToPdfColor(color)),
    );
  }

  void _drawLegend(PdfGraphics graphics, Rect area) {
    // Font - baseFont is required for Arabic support, no fallback to Helvetica
    final font = config.baseFont;
    const itemWidth = 80.0;
    final totalWidth = series.length * itemWidth;
    var startX = area.left + (area.width - totalWidth) / 2;
    final y = area.top + style.padding;

    for (final s in series) {
      // رسم أيقونة اللون
      graphics.drawRectangle(
        brush: PdfSolidBrush(_colorToPdfColor(s.color)),
        bounds: Rect.fromLTWH(startX, y, legend.iconSize, legend.iconSize),
      );

      // رسم الاسم
      graphics.drawString(
        s.getName(config.isRTL),
        font,
        brush: PdfSolidBrush(_colorToPdfColor(style.textColor)),
        bounds: Rect.fromLTWH(startX + legend.iconSize + 4, y,
            itemWidth - legend.iconSize - 4, legend.iconSize),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle),
      );

      startX += itemWidth;
    }
  }

  double _calculateBarTotalWidth() {
    if (settings.type == GeniusBarChartType.grouped && series.length > 1) {
      return settings.barWidth + settings.groupSpacing;
    }
    return settings.barWidth + settings.barSpacing;
  }

  double _roundUpToNice(double value) {
    if (value == 0) return 10;
    final magnitude = math.pow(10, (math.log(value) / math.ln10).floor());
    final normalized = value / magnitude;
    double niceNormalized;
    if (normalized <= 1) {
      niceNormalized = 1;
    } else if (normalized <= 2) {
      niceNormalized = 2;
    } else if (normalized <= 5) {
      niceNormalized = 5;
    } else {
      niceNormalized = 10;
    }
    return niceNormalized * magnitude;
  }

  PdfColor _colorToPdfColor(Color color) {
    return PdfColor(color.red, color.green, color.blue, color.alpha);
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

class _ChartAreas {
  _ChartAreas({
    required this.titleArea,
    required this.plotArea,
    required this.legendArea,
  });
  final Rect titleArea;
  final Rect plotArea;
  final Rect legendArea;
}
