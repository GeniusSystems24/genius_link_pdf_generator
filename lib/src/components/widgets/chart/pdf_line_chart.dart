// ignore_for_file: unnecessary_import, implementation_imports, deprecated_member_use

import 'dart:math' as math;
import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../core/pdf_config.dart';
import '../../../core/pdf_print_theme.dart';
import '../../models/chart_models.dart';

/// مخطط خطي للـ PDF — إصدار محسن
/// Line chart component for PDF documents — Enhanced version
class GeniusPdfLineChart {
  GeniusPdfLineChart({
    this.title,
    this.titleAr,
    required this.series,
    this.groups,
    this.xAxis = const GeniusChartAxis(),
    this.yAxis = const GeniusChartAxis(),
    this.legend = const GeniusChartLegend(),
    required this.config,
    this.settings = const GeniusLineChartSettings(),
    this.layoutConfig = const GeniusChartLayoutConfig(),
    this.width,
    this.height = 250,
  }) : style = _chartStyleFromTheme(config.printTheme);

  /// عنوان المخطط
  final String? title;

  /// عنوان المخطط بالعربية
  final String? titleAr;

  /// سلاسل البيانات
  final List<GeniusChartSeries> series;

  /// مجموعات البيانات (اختياري)
  final List<GeniusChartDataGroup>? groups;

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

  /// إعدادات المخطط الخطي
  final GeniusLineChartSettings settings;

  /// إعدادات التخطيط
  final GeniusChartLayoutConfig layoutConfig;

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

  /// التحقق من وجود مجموعات
  bool get hasGroups => groups != null && groups!.isNotEmpty;

  /// رسم المخطط على الصفحة
  PdfLayoutResult draw(PdfPage page, Rect bounds) {
    final graphics = page.graphics;
    final chartWidth = width ?? bounds.width;
    final chartBounds =
        Rect.fromLTWH(bounds.left, bounds.top, chartWidth, height);

    // رسم الخلفية
    _drawBackground(graphics, chartBounds);

    // حساب مناطق الرسم
    final areas = _calculateAreasImproved(chartBounds);

    // رسم العنوان
    if (displayTitle != null) {
      _drawTitle(graphics, areas.titleArea);
    }

    // رسم المحاور وخطوط الشبكة
    _drawAxes(graphics, areas.plotArea);

    // رسم الخطوط
    _drawLines(graphics, areas.plotArea);

    // رسم وسيلة الإيضاح
    if (legend.show && (series.length > 1 || hasGroups)) {
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

  _ChartAreas _calculateAreasImproved(Rect bounds) {
    double titleHeight = 0;
    if (displayTitle != null) {
      titleHeight = layoutConfig.calculateTitleHeight(
          style.titleFontSize, style.padding);
    }

    double legendHeight = 0;
    if (legend.show && (series.length > 1 || hasGroups)) {
      legendHeight =
          layoutConfig.calculateLegendHeight(legend.iconSize, style.padding);
    }

    final axisLabelWidth =
        layoutConfig.calculateAxisLabelWidth(style.labelFontSize);
    final axisLabelHeight =
        layoutConfig.calculateAxisLabelHeight(style.labelFontSize);

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

  void _drawAxes(PdfGraphics graphics, Rect plotArea) {
    final axisPen = PdfPen(_colorToPdfColor(style.axisColor), width: 1);
    final gridPen = PdfPen(_colorToPdfColor(xAxis.gridLineColor), width: 0.5);
    final font = config.baseFont;

    // حساب القيم القصوى
    double maxValue = 0;
    double minValue = double.infinity;
    for (final s in series) {
      if (s.maxValue > maxValue) maxValue = s.maxValue;
      if (s.minValue < minValue) minValue = s.minValue;
    }
    if (minValue > 0) minValue = 0;
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

    // حساب عرض تسميات المحور
    final labelWidth =
        layoutConfig.calculateAxisLabelWidth(style.labelFontSize);

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
        bounds: Rect.fromLTWH(plotArea.left - labelWidth - 5,
            y - style.labelFontSize / 2, labelWidth, style.labelFontSize * 1.2),
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
      );
    }

    // رسم تسميات المحور السيني
    if (series.isNotEmpty && series.first.dataPoints.isNotEmpty) {
      final dataPoints = series.first.dataPoints;
      final spacing =
          plotArea.width / (dataPoints.length - 1).clamp(1, double.infinity);

      for (int i = 0; i < dataPoints.length; i++) {
        final x = plotArea.left + spacing * i;

        if (xAxis.showGridLines && i > 0 && i < dataPoints.length - 1) {
          graphics.drawLine(
            gridPen,
            Offset(x, plotArea.top),
            Offset(x, plotArea.bottom),
          );
        }

        final labelBoundsWidth = spacing * 0.9;
        graphics.drawString(
          dataPoints[i].getLabel(config.isRTL),
          font,
          brush: PdfSolidBrush(_colorToPdfColor(style.textColor)),
          bounds: Rect.fromLTWH(x - labelBoundsWidth / 2, plotArea.bottom + 5,
              labelBoundsWidth, style.labelFontSize * 1.5),
          format: PdfStringFormat(alignment: PdfTextAlignment.center),
        );
      }
    }
  }

  void _drawLines(PdfGraphics graphics, Rect plotArea) {
    if (series.isEmpty) return;

    // حساب القيم القصوى
    double maxValue = 0;
    for (final s in series) {
      if (s.maxValue > maxValue) maxValue = s.maxValue;
    }
    maxValue = _roundUpToNice(maxValue);

    for (final s in series) {
      if (s.dataPoints.length < 2) continue;

      final points = <Offset>[];
      final spacing =
          plotArea.width / (s.dataPoints.length - 1).clamp(1, double.infinity);

      for (int i = 0; i < s.dataPoints.length; i++) {
        final x = plotArea.left + spacing * i;
        final y = plotArea.bottom -
            (s.dataPoints[i].value / maxValue) * plotArea.height;
        points.add(Offset(x, y));
      }

      // رسم منطقة التعبئة
      if (settings.fillArea) {
        _drawFillArea(graphics, plotArea, points, s.color);
      }

      // رسم الخط
      _drawLine(graphics, points, s.color);

      // رسم النقاط
      if (settings.showPoints) {
        _drawPoints(graphics, points, s.color);
      }

      // رسم القيم
      if (settings.showValues) {
        _drawValues(graphics, s.dataPoints, points);
      }
    }
  }

  void _drawLine(PdfGraphics graphics, List<Offset> points, Color color) {
    final pen = PdfPen(_colorToPdfColor(color), width: settings.lineWidth);

    switch (settings.type) {
      case GeniusLineChartType.straight:
        for (int i = 0; i < points.length - 1; i++) {
          graphics.drawLine(pen, points[i], points[i + 1]);
        }
        break;

      case GeniusLineChartType.curved:
        if (points.length < 2) return;
        final path = PdfPath();
        path.startFigure();

        for (int i = 0; i < points.length - 1; i++) {
          final p0 = i > 0 ? points[i - 1] : points[i];
          final p1 = points[i];
          final p2 = points[i + 1];
          final p3 = i < points.length - 2 ? points[i + 2] : p2;

          final cp1 = Offset(
            p1.dx + (p2.dx - p0.dx) / 6,
            p1.dy + (p2.dy - p0.dy) / 6,
          );
          final cp2 = Offset(
            p2.dx - (p3.dx - p1.dx) / 6,
            p2.dy - (p3.dy - p1.dy) / 6,
          );

          path.addBezier(p1, cp1, cp2, p2);
        }

        graphics.drawPath(path, pen: pen);
        break;

      case GeniusLineChartType.stepped:
        for (int i = 0; i < points.length - 1; i++) {
          final midX = points[i + 1].dx;
          graphics.drawLine(pen, points[i], Offset(midX, points[i].dy));
          graphics.drawLine(pen, Offset(midX, points[i].dy), points[i + 1]);
        }
        break;
    }
  }

  void _drawFillArea(
      PdfGraphics graphics, Rect plotArea, List<Offset> points, Color color) {
    if (points.isEmpty) return;

    final path = PdfPath();

    // بناء قائمة النقاط للمضلع
    final polygonPoints = <Offset>[];
    polygonPoints.add(Offset(points.first.dx, plotArea.bottom));
    polygonPoints.addAll(points);
    polygonPoints.add(Offset(points.last.dx, plotArea.bottom));

    path.addPolygon(polygonPoints);

    final fillColor = Color.fromRGBO(
      color.red,
      color.green,
      color.blue,
      settings.fillOpacity,
    );

    graphics.drawPath(
      path,
      brush: PdfSolidBrush(_colorToPdfColor(fillColor)),
    );
  }

  void _drawPoints(PdfGraphics graphics, List<Offset> points, Color color) {
    final brush = PdfSolidBrush(_colorToPdfColor(color));
    final whiteBrush = PdfSolidBrush(PdfColor(255, 255, 255));
    final radius = settings.pointSize / 2;

    for (final point in points) {
      // رسم دائرة بيضاء خلفية
      graphics.drawEllipse(
        Rect.fromCircle(center: point, radius: radius + 1),
        brush: whiteBrush,
      );
      // رسم النقطة الملونة
      graphics.drawEllipse(
        Rect.fromCircle(center: point, radius: radius),
        brush: brush,
      );
    }
  }

  void _drawValues(PdfGraphics graphics, List<GeniusChartDataPoint> dataPoints,
      List<Offset> points) {
    final font = config.baseFont;
    final brush = PdfSolidBrush(_colorToPdfColor(style.textColor));

    for (int i = 0; i < points.length && i < dataPoints.length; i++) {
      final valueY =
          points[i].dy - layoutConfig.valueLabelOffset - style.valueFontSize;
      graphics.drawString(
        yAxis.formatValue(dataPoints[i].value),
        font,
        brush: brush,
        bounds: Rect.fromLTWH(
            points[i].dx - 25, valueY, 50, style.valueFontSize * 1.2),
        format: PdfStringFormat(alignment: PdfTextAlignment.center),
      );
    }
  }

  void _drawLegend(PdfGraphics graphics, Rect area) {
    final font = config.baseFont;
    const itemWidth = 80.0;
    final totalWidth = series.length * itemWidth;
    var startX = area.left + (area.width - totalWidth) / 2;
    final y = area.top + style.padding;

    for (final s in series) {
      // رسم خط اللون
      final linePen = PdfPen(_colorToPdfColor(s.color), width: 2);
      graphics.drawLine(
        linePen,
        Offset(startX, y + legend.iconSize / 2),
        Offset(startX + legend.iconSize, y + legend.iconSize / 2),
      );

      // رسم نقطة
      if (settings.showPoints) {
        graphics.drawEllipse(
          Rect.fromCircle(
            center:
                Offset(startX + legend.iconSize / 2, y + legend.iconSize / 2),
            radius: 3,
          ),
          brush: PdfSolidBrush(_colorToPdfColor(s.color)),
        );
      }

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
