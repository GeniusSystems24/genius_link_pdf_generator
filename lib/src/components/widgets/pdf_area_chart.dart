import 'dart:math' as math;
import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../models/chart_models.dart';
import 'package:syncfusion_flutter_pdf/src/pdf/implementation/graphics/figures/base/text_layouter.dart';

/// مخطط المساحة للـ PDF
/// Area chart component for PDF documents
class GeniusPdfAreaChart {
  const GeniusPdfAreaChart({
    this.title,
    this.titleAr,
    required this.series,
    this.xAxis = const GeniusChartAxis(),
    this.yAxis = const GeniusChartAxis(),
    this.legend = const GeniusChartLegend(),
    this.style = const GeniusChartStyle(),
    this.settings = const GeniusAreaChartSettings(),
    this.width,
    this.height = 250,
    this.isRtl = false,
    required this.baseFont,
    required this.boldFont,
  });

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

  /// إعدادات مخطط المساحة
  final GeniusAreaChartSettings settings;

  /// العرض
  final double? width;

  /// الارتفاع
  final double height;

  /// اتجاه النص من اليمين لليسار
  final bool isRtl;

  /// الخط الأساسي (مطلوب للنصوص العربية)
  final PdfFont baseFont;

  /// الخط العريض (مطلوب للعناوين)
  final PdfFont boldFont;

  /// الحصول على العنوان حسب اتجاه النص
  String? get displayTitle => isRtl ? (titleAr ?? title) : title;

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

    // رسم المحاور وخطوط الشبكة
    _drawAxes(graphics, areas.plotArea);

    // رسم المناطق
    _drawAreas(graphics, areas.plotArea);

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

    return PdfLayoutResultHelper.load(page, chartBounds);
  }

  void _drawBackground(PdfGraphics graphics, Rect bounds) {
    graphics.drawRectangle(
      brush: PdfSolidBrush(_colorToPdfColor(style.backgroundColor)),
      bounds: bounds,
    );
  }

  _ChartAreas _calculateAreas(Rect bounds) {
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
    final font = boldFont;
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
    // Font - baseFont is required for Arabic support, no fallback to Helvetica
    final font = baseFont;

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

        graphics.drawString(
          dataPoints[i].getLabel(isRtl),
          font,
          brush: PdfSolidBrush(_colorToPdfColor(style.textColor)),
          bounds: Rect.fromLTWH(x - 25, plotArea.bottom + 5, 50, 20),
          format: PdfStringFormat(alignment: PdfTextAlignment.center),
        );
      }
    }
  }

  double _calculateMaxValue() {
    if (settings.stacked) {
      // حساب المجموع الأقصى للقيم المكدسة
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

  void _drawAreas(PdfGraphics graphics, Rect plotArea) {
    if (series.isEmpty) return;

    double maxValue = _calculateMaxValue();
    maxValue = _roundUpToNice(maxValue);

    if (settings.stacked) {
      _drawStackedAreas(graphics, plotArea, maxValue);
    } else {
      _drawOverlappingAreas(graphics, plotArea, maxValue);
    }
  }

  void _drawOverlappingAreas(
      PdfGraphics graphics, Rect plotArea, double maxValue) {
    // رسم المناطق من الخلف للأمام
    for (int seriesIndex = series.length - 1; seriesIndex >= 0; seriesIndex--) {
      final s = series[seriesIndex];
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

      // رسم المنطقة
      _drawAreaPath(graphics, plotArea, points, s.color);

      // رسم الخط
      _drawLine(graphics, points, s.color);

      // رسم النقاط
      if (settings.showPoints) {
        _drawPoints(graphics, points, s.color);
      }
    }
  }

  void _drawStackedAreas(PdfGraphics graphics, Rect plotArea, double maxValue) {
    if (series.isEmpty) return;

    final pointCount = series.first.dataPoints.length;
    final spacing = plotArea.width / (pointCount - 1).clamp(1, double.infinity);

    // حساب القيم التراكمية لكل نقطة
    final stackedValues = List.generate(pointCount, (_) => 0.0);
    final previousPoints = List.generate(
      pointCount,
      (i) => Offset(plotArea.left + spacing * i, plotArea.bottom),
    );

    for (int seriesIndex = 0; seriesIndex < series.length; seriesIndex++) {
      final s = series[seriesIndex];
      final currentPoints = <Offset>[];

      for (int i = 0; i < pointCount && i < s.dataPoints.length; i++) {
        stackedValues[i] += s.dataPoints[i].value;
        final x = plotArea.left + spacing * i;
        final y =
            plotArea.bottom - (stackedValues[i] / maxValue) * plotArea.height;
        currentPoints.add(Offset(x, y));
      }

      // رسم المنطقة المكدسة
      _drawStackedAreaPath(graphics, currentPoints, previousPoints, s.color);

      // رسم الخط
      _drawLine(graphics, currentPoints, s.color);

      // تحديث النقاط السابقة
      for (int i = 0; i < currentPoints.length; i++) {
        previousPoints[i] = currentPoints[i];
      }
    }
  }

  void _drawAreaPath(
      PdfGraphics graphics, Rect plotArea, List<Offset> points, Color color) {
    if (points.isEmpty) return;

    final path = PdfPath();

    // بناء قائمة النقاط للمضلع
    final polygonPoints = <Offset>[];

    // البدء من أسفل اليسار
    polygonPoints.add(Offset(points.first.dx, plotArea.bottom));

    // رسم الخط العلوي
    if (settings.lineType == GeniusLineChartType.curved && points.length > 2) {
      polygonPoints.add(points.first);
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
      // الإغلاق من أسفل اليمين
      path.addLine(points.last, Offset(points.last.dx, plotArea.bottom));
      path.closeFigure();
    } else {
      // إضافة جميع النقاط
      polygonPoints.addAll(points);
      // الإغلاق من أسفل اليمين
      polygonPoints.add(Offset(points.last.dx, plotArea.bottom));
      path.addPolygon(polygonPoints);
    }

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

  void _drawStackedAreaPath(
    PdfGraphics graphics,
    List<Offset> currentPoints,
    List<Offset> previousPoints,
    Color color,
  ) {
    if (currentPoints.isEmpty) return;

    final path = PdfPath();

    // بناء قائمة النقاط للمضلع
    final polygonPoints = <Offset>[];

    // البدء من أول نقطة سابقة
    polygonPoints.add(previousPoints.first);

    // رسم الخط العلوي
    polygonPoints.addAll(currentPoints);

    // رسم الخط السفلي (عكسي)
    for (int i = previousPoints.length - 1; i >= 0; i--) {
      polygonPoints.add(previousPoints[i]);
    }

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

  void _drawLine(PdfGraphics graphics, List<Offset> points, Color color) {
    if (points.length < 2) return;

    final pen = PdfPen(_colorToPdfColor(color), width: settings.lineWidth);

    if (settings.lineType == GeniusLineChartType.curved && points.length > 2) {
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
    } else {
      for (int i = 0; i < points.length - 1; i++) {
        graphics.drawLine(pen, points[i], points[i + 1]);
      }
    }
  }

  void _drawPoints(PdfGraphics graphics, List<Offset> points, Color color) {
    final brush = PdfSolidBrush(_colorToPdfColor(color));
    final whiteBrush = PdfSolidBrush(PdfColor(255, 255, 255));
    final radius = settings.pointSize / 2;

    for (final point in points) {
      graphics.drawEllipse(
        Rect.fromCircle(center: point, radius: radius + 1),
        brush: whiteBrush,
      );
      graphics.drawEllipse(
        Rect.fromCircle(center: point, radius: radius),
        brush: brush,
      );
    }
  }

  void _drawLegend(PdfGraphics graphics, Rect area) {
    // Font - baseFont is required for Arabic support, no fallback to Helvetica
    final font = baseFont;
    const itemWidth = 80.0;
    final totalWidth = series.length * itemWidth;
    var startX = area.left + (area.width - totalWidth) / 2;
    final y = area.top + style.padding;

    for (final s in series) {
      // رسم مربع اللون
      final fillColor = Color.fromRGBO(
        s.color.red,
        s.color.green,
        s.color.blue,
        settings.fillOpacity,
      );

      graphics.drawRectangle(
        brush: PdfSolidBrush(_colorToPdfColor(fillColor)),
        pen: PdfPen(_colorToPdfColor(s.color), width: 1),
        bounds: Rect.fromLTWH(startX, y, legend.iconSize, legend.iconSize),
      );

      // رسم الاسم
      graphics.drawString(
        s.getName(isRtl),
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
    return PdfColor(color.red, color.green, color.blue);
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
