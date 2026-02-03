import 'dart:ui';

/// مجموعة بيانات للمخططات
/// Data group for charts - groups related data points/series together
class GeniusChartDataGroup {
  const GeniusChartDataGroup({
    required this.name,
    this.nameAr,
    required this.dataPoints,
    this.color,
    this.headerBackgroundColor,
  });

  /// مجموعة مميزة
  /// Highlighted group with grey header
  const GeniusChartDataGroup.highlighted({
    required this.name,
    this.nameAr,
    required this.dataPoints,
    this.color,
  }) : headerBackgroundColor = const Color(0xFFE8E8E8);

  /// مجموعة الإيرادات
  /// Income/revenue group with green tint
  const GeniusChartDataGroup.income({
    required this.name,
    this.nameAr,
    required this.dataPoints,
    this.color,
  }) : headerBackgroundColor = const Color(0xFFE8F5E9);

  /// مجموعة المصروفات
  /// Expense group with red tint
  const GeniusChartDataGroup.expense({
    required this.name,
    this.nameAr,
    required this.dataPoints,
    this.color,
  }) : headerBackgroundColor = const Color(0xFFFFEBEE);

  /// اسم المجموعة
  final String name;

  /// اسم المجموعة بالعربية
  final String? nameAr;

  /// نقاط البيانات في المجموعة
  final List<GeniusChartDataPoint> dataPoints;

  /// لون المجموعة (اختياري)
  final Color? color;

  /// لون خلفية العنوان
  final Color? headerBackgroundColor;

  /// الحصول على الاسم حسب اتجاه النص
  String getName(bool isRtl) => isRtl ? (nameAr ?? name) : name;

  /// الحصول على أعلى قيمة
  double get maxValue => dataPoints.isEmpty
      ? 0
      : dataPoints.map((p) => p.value).reduce((a, b) => a > b ? a : b);

  /// الحصول على أدنى قيمة
  double get minValue => dataPoints.isEmpty
      ? 0
      : dataPoints.map((p) => p.value).reduce((a, b) => a < b ? a : b);

  /// الحصول على مجموع القيم
  double get total => dataPoints.fold(0, (sum, p) => sum + p.value);
}

/// نقطة بيانات في المخطط
/// Data point in a chart
class GeniusChartDataPoint {
  const GeniusChartDataPoint({
    required this.label,
    this.labelAr,
    required this.value,
    this.color,
  });

  /// التسمية
  final String label;

  /// التسمية بالعربية
  final String? labelAr;

  /// القيمة
  final double value;

  /// اللون (اختياري)
  final Color? color;

  /// الحصول على التسمية حسب اتجاه النص
  String getLabel(bool isRtl) => isRtl ? (labelAr ?? label) : label;
}

/// سلسلة بيانات للمخططات
/// Data series for charts
class GeniusChartSeries {
  const GeniusChartSeries({
    required this.name,
    this.nameAr,
    required this.dataPoints,
    required this.color,
    this.showValues = false,
  });

  /// اسم السلسلة
  final String name;

  /// اسم السلسلة بالعربية
  final String? nameAr;

  /// نقاط البيانات
  final List<GeniusChartDataPoint> dataPoints;

  /// لون السلسلة
  final Color color;

  /// إظهار قيم البيانات
  final bool showValues;

  /// الحصول على الاسم حسب اتجاه النص
  String getName(bool isRtl) => isRtl ? (nameAr ?? name) : name;

  /// الحصول على أعلى قيمة
  double get maxValue => dataPoints.isEmpty
      ? 0
      : dataPoints.map((p) => p.value).reduce((a, b) => a > b ? a : b);

  /// الحصول على أدنى قيمة
  double get minValue => dataPoints.isEmpty
      ? 0
      : dataPoints.map((p) => p.value).reduce((a, b) => a < b ? a : b);

  /// الحصول على مجموع القيم
  double get total => dataPoints.fold(0, (sum, p) => sum + p.value);
}

/// إعدادات محور المخطط
/// Chart axis configuration
class GeniusChartAxis {
  const GeniusChartAxis({
    this.title,
    this.titleAr,
    this.min,
    this.max,
    this.divisions = 5,
    this.showGridLines = true,
    this.gridLineColor = const Color(0xFFE0E0E0),
    this.valueFormatter,
  });

  /// عنوان المحور
  final String? title;

  /// عنوان المحور بالعربية
  final String? titleAr;

  /// الحد الأدنى (تلقائي إذا كان null)
  final double? min;

  /// الحد الأقصى (تلقائي إذا كان null)
  final double? max;

  /// عدد التقسيمات
  final int divisions;

  /// إظهار خطوط الشبكة
  final bool showGridLines;

  /// لون خطوط الشبكة
  final Color gridLineColor;

  /// تنسيق القيم
  final String Function(double value)? valueFormatter;

  /// الحصول على العنوان حسب اتجاه النص
  String? getTitle(bool isRtl) => isRtl ? (titleAr ?? title) : title;

  /// تنسيق القيمة
  String formatValue(double value) {
    if (valueFormatter != null) return valueFormatter!(value);
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(1);
  }
}

/// إعدادات وسيلة الإيضاح
/// Legend configuration
class GeniusChartLegend {
  const GeniusChartLegend({
    this.show = true,
    this.position = GeniusChartLegendPosition.bottom,
    this.orientation = GeniusChartLegendOrientation.horizontal,
    this.iconSize = 12,
    this.spacing = 16,
  });

  /// إظهار وسيلة الإيضاح
  final bool show;

  /// موقع وسيلة الإيضاح
  final GeniusChartLegendPosition position;

  /// اتجاه العناصر
  final GeniusChartLegendOrientation orientation;

  /// حجم أيقونة اللون
  final double iconSize;

  /// المسافة بين العناصر
  final double spacing;
}

/// موقع وسيلة الإيضاح
enum GeniusChartLegendPosition {
  top,
  bottom,
  left,
  right,
}

/// اتجاه عناصر وسيلة الإيضاح
enum GeniusChartLegendOrientation {
  horizontal,
  vertical,
}

/// أنماط المخططات
/// Chart styles
class GeniusChartStyle {
  const GeniusChartStyle({
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.textColor = const Color(0xFF333333),
    this.axisColor = const Color(0xFF666666),
    this.titleFontSize = 14,
    this.labelFontSize = 10,
    this.valueFontSize = 9,
    this.padding = 10,
    this.showBorder = false,
    this.borderColor = const Color(0xFFE0E0E0),
  });

  /// النمط الكلاسيكي
  factory GeniusChartStyle.classic() => const GeniusChartStyle();

  /// النمط الحديث
  factory GeniusChartStyle.modern() => const GeniusChartStyle(
        backgroundColor: Color(0xFFF8F9FA),
        textColor: Color(0xFF2C3E50),
        axisColor: Color(0xFF7F8C8D),
        showBorder: true,
        borderColor: Color(0xFFBDC3C7),
      );

  /// النمط الداكن
  factory GeniusChartStyle.dark() => const GeniusChartStyle(
        backgroundColor: Color(0xFF2C3E50),
        textColor: Color(0xFFECF0F1),
        axisColor: Color(0xFF95A5A6),
        showBorder: true,
        borderColor: Color(0xFF34495E),
      );

  /// لون الخلفية
  final Color backgroundColor;

  /// لون النص
  final Color textColor;

  /// لون المحاور
  final Color axisColor;

  /// حجم خط العنوان
  final double titleFontSize;

  /// حجم خط التسميات
  final double labelFontSize;

  /// حجم خط القيم
  final double valueFontSize;

  /// الهوامش الداخلية
  final double padding;

  /// إظهار الحدود
  final bool showBorder;

  /// لون الحدود
  final Color borderColor;
}

/// ألوان افتراضية للمخططات
class GeniusChartColors {
  static const List<Color> defaultPalette = [
    Color(0xFF2196F3), // أزرق
    Color(0xFF4CAF50), // أخضر
    Color(0xFFF44336), // أحمر
    Color(0xFFFF9800), // برتقالي
    Color(0xFF9C27B0), // بنفسجي
    Color(0xFF00BCD4), // سماوي
    Color(0xFFFFEB3B), // أصفر
    Color(0xFF795548), // بني
    Color(0xFF607D8B), // رمادي أزرق
    Color(0xFFE91E63), // وردي
  ];

  static const List<Color> bluePalette = [
    Color(0xFF0D47A1),
    Color(0xFF1565C0),
    Color(0xFF1976D2),
    Color(0xFF1E88E5),
    Color(0xFF2196F3),
    Color(0xFF42A5F5),
    Color(0xFF64B5F6),
    Color(0xFF90CAF9),
  ];

  static const List<Color> greenPalette = [
    Color(0xFF1B5E20),
    Color(0xFF2E7D32),
    Color(0xFF388E3C),
    Color(0xFF43A047),
    Color(0xFF4CAF50),
    Color(0xFF66BB6A),
    Color(0xFF81C784),
    Color(0xFFA5D6A7),
  ];

  static const List<Color> warmPalette = [
    Color(0xFFB71C1C),
    Color(0xFFD32F2F),
    Color(0xFFF44336),
    Color(0xFFFF5722),
    Color(0xFFFF9800),
    Color(0xFFFFC107),
    Color(0xFFFFEB3B),
    Color(0xFFFFF176),
  ];

  /// الحصول على لون من اللوحة
  static Color getColor(int index, [List<Color>? palette]) {
    final colors = palette ?? defaultPalette;
    return colors[index % colors.length];
  }
}

/// نوع المخطط الشريطي
enum GeniusBarChartType {
  /// أعمدة عمودية
  vertical,

  /// أعمدة أفقية
  horizontal,

  /// أعمدة مكدسة
  stacked,

  /// أعمدة مجمعة
  grouped,
}

/// نوع المخطط الخطي
enum GeniusLineChartType {
  /// خط مستقيم
  straight,

  /// خط منحني
  curved,

  /// خط متدرج
  stepped,
}

/// إعدادات المخطط الشريطي
class GeniusBarChartSettings {
  const GeniusBarChartSettings({
    this.type = GeniusBarChartType.vertical,
    this.barWidth = 30,
    this.barSpacing = 8,
    this.groupSpacing = 16,
    this.cornerRadius = 4,
    this.showValues = true,
    this.useGradient = false,
  });

  /// نوع المخطط
  final GeniusBarChartType type;

  /// عرض العمود
  final double barWidth;

  /// المسافة بين الأعمدة
  final double barSpacing;

  /// المسافة بين المجموعات
  final double groupSpacing;

  /// نصف قطر الحواف
  final double cornerRadius;

  /// إظهار القيم فوق الأعمدة
  final bool showValues;

  /// تدرج الألوان
  final bool useGradient;
}

/// إعدادات المخطط الخطي
class GeniusLineChartSettings {
  const GeniusLineChartSettings({
    this.type = GeniusLineChartType.straight,
    this.lineWidth = 2,
    this.showPoints = true,
    this.pointSize = 6,
    this.fillArea = false,
    this.fillOpacity = 0.2,
    this.showValues = false,
  });

  /// نوع الخط
  final GeniusLineChartType type;

  /// سمك الخط
  final double lineWidth;

  /// إظهار النقاط
  final bool showPoints;

  /// حجم النقاط
  final double pointSize;

  /// تعبئة المنطقة تحت الخط
  final bool fillArea;

  /// شفافية التعبئة
  final double fillOpacity;

  /// إظهار القيم
  final bool showValues;
}

/// إعدادات المخطط الدائري
class GeniusPieChartSettings {
  const GeniusPieChartSettings({
    this.innerRadiusRatio = 0,
    this.startAngle = -90,
    this.sliceSpacing = 2,
    this.showLabels = true,
    this.showPercentages = true,
    this.showValues = false,
    this.labelPosition = GeniusPieLabelPosition.outside,
    this.explodeOffset = 0,
  });

  /// مخطط دائري مجوف (Donut)
  factory GeniusPieChartSettings.donut() => const GeniusPieChartSettings(
        innerRadiusRatio: 0.5,
      );

  /// نصف القطر الداخلي (0 للمخطط الدائري الكامل)
  final double innerRadiusRatio;

  /// زاوية البداية (بالدرجات)
  final double startAngle;

  /// المسافة بين الشرائح
  final double sliceSpacing;

  /// إظهار التسميات
  final bool showLabels;

  /// إظهار النسب المئوية
  final bool showPercentages;

  /// إظهار القيم
  final bool showValues;

  /// موقع التسميات
  final GeniusPieLabelPosition labelPosition;

  /// إبراز الشريحة عند التحديد
  final double explodeOffset;
}

/// موقع تسميات المخطط الدائري
enum GeniusPieLabelPosition {
  inside,
  outside,
  none,
}

/// إعدادات مخطط المساحة
class GeniusAreaChartSettings {
  const GeniusAreaChartSettings({
    this.lineType = GeniusLineChartType.straight,
    this.lineWidth = 2,
    this.fillOpacity = 0.3,
    this.showPoints = false,
    this.pointSize = 4,
    this.stacked = false,
  });

  /// نوع الخط
  final GeniusLineChartType lineType;

  /// سمك الخط
  final double lineWidth;

  /// شفافية التعبئة
  final double fillOpacity;

  /// إظهار النقاط
  final bool showPoints;

  /// حجم النقاط
  final double pointSize;

  /// تكديس المناطق
  final bool stacked;
}

/// إعدادات تخطيط المخطط — Chart Layout Configuration
/// Controls spacing, margins, and dimension calculations
class GeniusChartLayoutConfig {
  const GeniusChartLayoutConfig({
    this.titleHeightFactor = 1.8,
    this.legendHeightFactor = 2.0,
    this.axisLabelWidthFactor = 4.5,
    this.axisLabelHeightFactor = 2.5,
    this.minAxisLabelWidth = 40,
    this.maxAxisLabelWidth = 80,
    this.minAxisLabelHeight = 20,
    this.maxAxisLabelHeight = 40,
    this.plotPaddingFactor = 0.5,
    this.valueLabelOffset = 5,
    this.groupSeparatorWidth = 2,
    this.groupHeaderHeight = 18,
  });

  /// Default configuration
  factory GeniusChartLayoutConfig.standard() =>
      const GeniusChartLayoutConfig();

  /// Compact layout for smaller charts
  factory GeniusChartLayoutConfig.compact() => const GeniusChartLayoutConfig(
        titleHeightFactor: 1.5,
        legendHeightFactor: 1.5,
        axisLabelWidthFactor: 3.5,
        axisLabelHeightFactor: 2.0,
        minAxisLabelWidth: 30,
        maxAxisLabelWidth: 60,
        plotPaddingFactor: 0.3,
        groupHeaderHeight: 14,
      );

  /// Spacious layout for larger charts
  factory GeniusChartLayoutConfig.spacious() => const GeniusChartLayoutConfig(
        titleHeightFactor: 2.2,
        legendHeightFactor: 2.5,
        axisLabelWidthFactor: 5.5,
        axisLabelHeightFactor: 3.0,
        minAxisLabelWidth: 50,
        maxAxisLabelWidth: 100,
        plotPaddingFactor: 0.7,
        groupHeaderHeight: 22,
      );

  /// معامل ارتفاع العنوان (مضروب في حجم الخط)
  final double titleHeightFactor;

  /// معامل ارتفاع وسيلة الإيضاح
  final double legendHeightFactor;

  /// معامل عرض تسميات المحور (مضروب في حجم الخط)
  final double axisLabelWidthFactor;

  /// معامل ارتفاع تسميات المحور
  final double axisLabelHeightFactor;

  /// الحد الأدنى لعرض تسميات المحور
  final double minAxisLabelWidth;

  /// الحد الأقصى لعرض تسميات المحور
  final double maxAxisLabelWidth;

  /// الحد الأدنى لارتفاع تسميات المحور
  final double minAxisLabelHeight;

  /// الحد الأقصى لارتفاع تسميات المحور
  final double maxAxisLabelHeight;

  /// معامل هامش منطقة الرسم
  final double plotPaddingFactor;

  /// إزاحة تسميات القيم
  final double valueLabelOffset;

  /// عرض خط فاصل المجموعات
  final double groupSeparatorWidth;

  /// ارتفاع عنوان المجموعة
  final double groupHeaderHeight;

  /// حساب عرض تسميات المحور بناءً على حجم الخط
  double calculateAxisLabelWidth(double fontSize) {
    final calculated = fontSize * axisLabelWidthFactor;
    return calculated.clamp(minAxisLabelWidth, maxAxisLabelWidth);
  }

  /// حساب ارتفاع تسميات المحور بناءً على حجم الخط
  double calculateAxisLabelHeight(double fontSize) {
    final calculated = fontSize * axisLabelHeightFactor;
    return calculated.clamp(minAxisLabelHeight, maxAxisLabelHeight);
  }

  /// حساب ارتفاع العنوان
  double calculateTitleHeight(double titleFontSize, double padding) {
    return titleFontSize * titleHeightFactor + padding;
  }

  /// حساب ارتفاع وسيلة الإيضاح
  double calculateLegendHeight(double iconSize, double padding) {
    return iconSize * legendHeightFactor + padding;
  }
}

/// حسابات أبعاد المخطط — Chart Dimension Calculator
/// Utility class for accurate chart dimension calculations
class GeniusChartDimensionCalculator {
  GeniusChartDimensionCalculator({
    required this.bounds,
    required this.style,
    required this.layoutConfig,
    this.hasTitle = false,
    this.hasLegend = false,
    this.legendPosition = GeniusChartLegendPosition.bottom,
    this.legendIconSize = 12,
  });

  final Rect bounds;
  final GeniusChartStyle style;
  final GeniusChartLayoutConfig layoutConfig;
  final bool hasTitle;
  final bool hasLegend;
  final GeniusChartLegendPosition legendPosition;
  final double legendIconSize;

  /// حساب ارتفاع منطقة العنوان
  double get titleHeight => hasTitle
      ? layoutConfig.calculateTitleHeight(style.titleFontSize, style.padding)
      : 0;

  /// حساب ارتفاع منطقة وسيلة الإيضاح
  double get legendHeight {
    if (!hasLegend) return 0;
    if (legendPosition == GeniusChartLegendPosition.left ||
        legendPosition == GeniusChartLegendPosition.right) {
      return 0;
    }
    return layoutConfig.calculateLegendHeight(legendIconSize, style.padding);
  }

  /// حساب عرض منطقة وسيلة الإيضاح
  double get legendWidth {
    if (!hasLegend) return 0;
    if (legendPosition == GeniusChartLegendPosition.left ||
        legendPosition == GeniusChartLegendPosition.right) {
      return 100; // Fixed width for side legends
    }
    return 0;
  }

  /// حساب عرض تسميات المحور
  double get axisLabelWidth =>
      layoutConfig.calculateAxisLabelWidth(style.labelFontSize);

  /// حساب ارتفاع تسميات المحور
  double get axisLabelHeight =>
      layoutConfig.calculateAxisLabelHeight(style.labelFontSize);

  /// منطقة العنوان
  Rect get titleArea => Rect.fromLTWH(
        bounds.left,
        bounds.top,
        bounds.width,
        titleHeight,
      );

  /// منطقة وسيلة الإيضاح
  Rect get legendArea {
    switch (legendPosition) {
      case GeniusChartLegendPosition.top:
        return Rect.fromLTWH(
          bounds.left,
          bounds.top + titleHeight,
          bounds.width,
          legendHeight,
        );
      case GeniusChartLegendPosition.bottom:
        return Rect.fromLTWH(
          bounds.left,
          bounds.bottom - legendHeight,
          bounds.width,
          legendHeight,
        );
      case GeniusChartLegendPosition.left:
        return Rect.fromLTWH(
          bounds.left,
          bounds.top + titleHeight,
          legendWidth,
          bounds.height - titleHeight,
        );
      case GeniusChartLegendPosition.right:
        return Rect.fromLTWH(
          bounds.right - legendWidth,
          bounds.top + titleHeight,
          legendWidth,
          bounds.height - titleHeight,
        );
    }
  }

  /// منطقة الرسم الرئيسية
  Rect get plotArea {
    double left = bounds.left + axisLabelWidth;
    double top = bounds.top + titleHeight + style.padding;
    double width = bounds.width - axisLabelWidth - style.padding;
    double height = bounds.height -
        titleHeight -
        axisLabelHeight -
        style.padding * 2;

    if (legendPosition == GeniusChartLegendPosition.bottom ||
        legendPosition == GeniusChartLegendPosition.top) {
      height -= legendHeight;
      if (legendPosition == GeniusChartLegendPosition.top) {
        top += legendHeight;
      }
    } else if (legendPosition == GeniusChartLegendPosition.left ||
        legendPosition == GeniusChartLegendPosition.right) {
      width -= legendWidth;
      if (legendPosition == GeniusChartLegendPosition.left) {
        left += legendWidth;
      }
    }

    return Rect.fromLTWH(left, top, width, height);
  }

  /// حساب الارتفاع الفعلي المطلوب للمخطط
  double calculateMinimumHeight({
    double minPlotHeight = 100,
  }) {
    return titleHeight +
        legendHeight +
        axisLabelHeight +
        minPlotHeight +
        style.padding * 2;
  }
}
