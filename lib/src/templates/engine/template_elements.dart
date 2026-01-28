import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'template_models.dart';

/// Base class for all template elements.
///
/// Template elements are the building blocks of a template definition.
/// Each element knows how to render itself to a PDF page.
abstract class TemplateElement {
  const TemplateElement({
    this.id,
    this.condition,
    this.style,
  });

  /// Unique identifier for this element.
  final String? id;

  /// Optional condition for rendering this element.
  final TemplateCondition? condition;

  /// Style properties for this element.
  final ElementStyle? style;

  /// Renders this element to the PDF page.
  ///
  /// Returns the height used by this element.
  double render(
    PdfPage page,
    Rect bounds,
    TemplateContext context,
    PdfFont font,
  );

  /// Calculates the height this element will use.
  double calculateHeight(
    Rect bounds,
    TemplateContext context,
    PdfFont font,
  );

  /// Whether this element should be rendered based on its condition.
  bool shouldRender(TemplateContext context) {
    if (condition == null) return true;
    return condition!.evaluate(context.mergedData);
  }

  /// Converts this element to JSON.
  Map<String, dynamic> toJson();

  /// Creates an element from JSON.
  static TemplateElement fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;

    switch (type) {
      case 'text':
        return TextElement.fromJson(json);
      case 'variable':
        return VariableElement.fromJson(json);
      case 'spacer':
        return SpacerElement.fromJson(json);
      case 'divider':
        return DividerElement.fromJson(json);
      case 'container':
        return ContainerElement.fromJson(json);
      case 'row':
        return RowElement.fromJson(json);
      case 'column':
        return ColumnElement.fromJson(json);
      case 'loop':
        return LoopElement.fromJson(json);
      case 'conditional':
        return ConditionalElement.fromJson(json);
      case 'table':
        return TableElement.fromJson(json);
      case 'image':
        return ImageElement.fromJson(json);
      default:
        throw ArgumentError('Unknown element type: $type');
    }
  }
}

/// Style properties for template elements.
class ElementStyle {

  factory ElementStyle.fromJson(Map<String, dynamic> json) {
    return ElementStyle(
      padding: json['padding'] != null
          ? EdgeInsets.only(
              left: (json['padding']['left'] as num?)?.toDouble() ?? 0,
              top: (json['padding']['top'] as num?)?.toDouble() ?? 0,
              right: (json['padding']['right'] as num?)?.toDouble() ?? 0,
              bottom: (json['padding']['bottom'] as num?)?.toDouble() ?? 0,
            )
          : null,
      margin: json['margin'] != null
          ? EdgeInsets.only(
              left: (json['margin']['left'] as num?)?.toDouble() ?? 0,
              top: (json['margin']['top'] as num?)?.toDouble() ?? 0,
              right: (json['margin']['right'] as num?)?.toDouble() ?? 0,
              bottom: (json['margin']['bottom'] as num?)?.toDouble() ?? 0,
            )
          : null,
      backgroundColor: json['backgroundColor'] != null
          ? _hexToColor(json['backgroundColor'] as String)
          : null,
      borderColor: json['borderColor'] != null
          ? _hexToColor(json['borderColor'] as String)
          : null,
      borderWidth: (json['borderWidth'] as num?)?.toDouble(),
      alignment: json['alignment'] != null
          ? PdfTextAlignment.values.firstWhere(
              (e) => e.name == json['alignment'],
              orElse: () => PdfTextAlignment.left,
            )
          : null,
    );
  }
  const ElementStyle({
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.alignment,
  });

  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final PdfColor? backgroundColor;
  final PdfColor? borderColor;
  final double? borderWidth;
  final PdfTextAlignment? alignment;

  Map<String, dynamic> toJson() => {
        if (padding != null)
          'padding': {
            'left': padding!.left,
            'top': padding!.top,
            'right': padding!.right,
            'bottom': padding!.bottom,
          },
        if (margin != null)
          'margin': {
            'left': margin!.left,
            'top': margin!.top,
            'right': margin!.right,
            'bottom': margin!.bottom,
          },
        if (backgroundColor != null)
          'backgroundColor': _colorToHex(backgroundColor!),
        if (borderColor != null) 'borderColor': _colorToHex(borderColor!),
        if (borderWidth != null) 'borderWidth': borderWidth,
        if (alignment != null) 'alignment': alignment!.name,
      };

  static String _colorToHex(PdfColor color) {
    return '#${color.r.toRadixString(16).padLeft(2, '0')}'
        '${color.g.toRadixString(16).padLeft(2, '0')}'
        '${color.b.toRadixString(16).padLeft(2, '0')}';
  }

  static PdfColor _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      return PdfColor(
        int.parse(hex.substring(0, 2), radix: 16),
        int.parse(hex.substring(2, 4), radix: 16),
        int.parse(hex.substring(4, 6), radix: 16),
      );
    }
    return PdfColor(0, 0, 0);
  }
}

/// Edge insets for padding/margin.
class EdgeInsets {
  const EdgeInsets.all(double value)
      : left = value,
        top = value,
        right = value,
        bottom = value;

  const EdgeInsets.symmetric({double horizontal = 0, double vertical = 0})
      : left = horizontal,
        top = vertical,
        right = horizontal,
        bottom = vertical;

  const EdgeInsets.only({
    this.left = 0,
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
  });

  final double left;
  final double top;
  final double right;
  final double bottom;

  double get horizontal => left + right;
  double get vertical => top + bottom;
}

/// A static text element.
class TextElement extends TemplateElement {

  factory TextElement.fromJson(Map<String, dynamic> json) {
    return TextElement(
      text: json['text'] as String,
      textAr: json['textAr'] as String?,
      fontSize: (json['fontSize'] as num?)?.toDouble(),
      fontColor: json['fontColor'] != null
          ? ElementStyle._hexToColor(json['fontColor'] as String)
          : null,
      isBold: json['isBold'] as bool? ?? false,
      isItalic: json['isItalic'] as bool? ?? false,
      id: json['id'] as String?,
      condition: json['condition'] != null
          ? TemplateCondition.fromJson(
              json['condition'] as Map<String, dynamic>)
          : null,
      style: json['style'] != null
          ? ElementStyle.fromJson(json['style'] as Map<String, dynamic>)
          : null,
    );
  }
  const TextElement({
    required this.text,
    this.textAr,
    this.fontSize,
    this.fontColor,
    this.isBold = false,
    this.isItalic = false,
    super.id,
    super.condition,
    super.style,
  });

  final String text;
  final String? textAr;
  final double? fontSize;
  final PdfColor? fontColor;
  final bool isBold;
  final bool isItalic;

  String getText(bool isRtl) => (isRtl && textAr != null) ? textAr! : text;

  @override
  double render(
    PdfPage page,
    Rect bounds,
    TemplateContext context,
    PdfFont font,
  ) {
    if (!shouldRender(context)) return 0;

    final displayText = getText(context.isRtl);
    final effectiveFontSize = fontSize ?? 12;

    final brush = PdfSolidBrush(fontColor ?? PdfColor(0, 0, 0));
    final alignment =
        context.isRtl ? PdfTextAlignment.right : PdfTextAlignment.left;

    final format = PdfStringFormat(
      alignment: style?.alignment ?? alignment,
      lineAlignment: PdfVerticalAlignment.top,
    );

    final size = font.measureString(
      displayText,
      format: format,
      layoutArea: Size(bounds.width, bounds.height),
    );

    page.graphics.drawString(
      displayText,
      font,
      brush: brush,
      bounds: bounds,
      format: format,
    );

    return size.height;
  }

  @override
  double calculateHeight(Rect bounds, TemplateContext context, PdfFont font) {
    if (!shouldRender(context)) return 0;

    final displayText = getText(context.isRtl);
    final format = PdfStringFormat(
      alignment: PdfTextAlignment.left,
      lineAlignment: PdfVerticalAlignment.top,
    );

    return font
        .measureString(displayText,
            format: format, layoutArea: Size(bounds.width, bounds.height))
        .height;
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': 'text',
        'text': text,
        if (textAr != null) 'textAr': textAr,
        if (fontSize != null) 'fontSize': fontSize,
        if (fontColor != null)
          'fontColor': ElementStyle._colorToHex(fontColor!),
        'isBold': isBold,
        'isItalic': isItalic,
        if (id != null) 'id': id,
        if (condition != null) 'condition': condition!.toJson(),
        if (style != null) 'style': style!.toJson(),
      };
}

/// A variable placeholder element.
class VariableElement extends TemplateElement {

  factory VariableElement.fromJson(Map<String, dynamic> json) {
    return VariableElement(
      variableName: json['variableName'] as String,
      prefix: json['prefix'] as String?,
      prefixAr: json['prefixAr'] as String?,
      suffix: json['suffix'] as String?,
      suffixAr: json['suffixAr'] as String?,
      defaultValue: json['defaultValue'] as String?,
      fontSize: (json['fontSize'] as num?)?.toDouble(),
      fontColor: json['fontColor'] != null
          ? ElementStyle._hexToColor(json['fontColor'] as String)
          : null,
      isBold: json['isBold'] as bool? ?? false,
      id: json['id'] as String?,
      condition: json['condition'] != null
          ? TemplateCondition.fromJson(
              json['condition'] as Map<String, dynamic>)
          : null,
      style: json['style'] != null
          ? ElementStyle.fromJson(json['style'] as Map<String, dynamic>)
          : null,
    );
  }
  const VariableElement({
    required this.variableName,
    this.prefix,
    this.prefixAr,
    this.suffix,
    this.suffixAr,
    this.defaultValue,
    this.fontSize,
    this.fontColor,
    this.isBold = false,
    super.id,
    super.condition,
    super.style,
  });

  final String variableName;
  final String? prefix;
  final String? prefixAr;
  final String? suffix;
  final String? suffixAr;
  final String? defaultValue;
  final double? fontSize;
  final PdfColor? fontColor;
  final bool isBold;

  String _formatValue(dynamic value, bool isRtl) {
    final pre = isRtl ? (prefixAr ?? prefix ?? '') : (prefix ?? '');
    final suf = isRtl ? (suffixAr ?? suffix ?? '') : (suffix ?? '');
    final val = value?.toString() ?? defaultValue ?? '';
    return '$pre$val$suf';
  }

  @override
  double render(
    PdfPage page,
    Rect bounds,
    TemplateContext context,
    PdfFont font,
  ) {
    if (!shouldRender(context)) return 0;

    final value = context.getValue(variableName);
    final displayText = _formatValue(value, context.isRtl);

    final brush = PdfSolidBrush(fontColor ?? PdfColor(0, 0, 0));
    final alignment =
        context.isRtl ? PdfTextAlignment.right : PdfTextAlignment.left;

    final format = PdfStringFormat(
      alignment: style?.alignment ?? alignment,
      lineAlignment: PdfVerticalAlignment.top,
    );

    final size = font.measureString(
      displayText,
      format: format,
      layoutArea: Size(bounds.width, bounds.height),
    );

    page.graphics.drawString(
      displayText,
      font,
      brush: brush,
      bounds: bounds,
      format: format,
    );

    return size.height;
  }

  @override
  double calculateHeight(Rect bounds, TemplateContext context, PdfFont font) {
    if (!shouldRender(context)) return 0;

    final value = context.getValue(variableName);
    final displayText = _formatValue(value, context.isRtl);

    final format = PdfStringFormat(
      alignment: PdfTextAlignment.left,
      lineAlignment: PdfVerticalAlignment.top,
    );

    return font
        .measureString(displayText,
            format: format, layoutArea: Size(bounds.width, bounds.height))
        .height;
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': 'variable',
        'variableName': variableName,
        if (prefix != null) 'prefix': prefix,
        if (prefixAr != null) 'prefixAr': prefixAr,
        if (suffix != null) 'suffix': suffix,
        if (suffixAr != null) 'suffixAr': suffixAr,
        if (defaultValue != null) 'defaultValue': defaultValue,
        if (fontSize != null) 'fontSize': fontSize,
        if (fontColor != null)
          'fontColor': ElementStyle._colorToHex(fontColor!),
        'isBold': isBold,
        if (id != null) 'id': id,
        if (condition != null) 'condition': condition!.toJson(),
        if (style != null) 'style': style!.toJson(),
      };
}

/// A spacer element for adding vertical space.
class SpacerElement extends TemplateElement {

  factory SpacerElement.fromJson(Map<String, dynamic> json) {
    return SpacerElement(
      height: (json['height'] as num).toDouble(),
      id: json['id'] as String?,
      condition: json['condition'] != null
          ? TemplateCondition.fromJson(
              json['condition'] as Map<String, dynamic>)
          : null,
    );
  }
  const SpacerElement({
    required this.height,
    super.id,
    super.condition,
  });

  final double height;

  @override
  double render(
    PdfPage page,
    Rect bounds,
    TemplateContext context,
    PdfFont font,
  ) {
    if (!shouldRender(context)) return 0;
    return height;
  }

  @override
  double calculateHeight(Rect bounds, TemplateContext context, PdfFont font) {
    if (!shouldRender(context)) return 0;
    return height;
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': 'spacer',
        'height': height,
        if (id != null) 'id': id,
        if (condition != null) 'condition': condition!.toJson(),
      };
}

/// A divider/line element.
class DividerElement extends TemplateElement {

  factory DividerElement.fromJson(Map<String, dynamic> json) {
    return DividerElement(
      thickness: (json['thickness'] as num?)?.toDouble() ?? 1,
      color: json['color'] != null
          ? ElementStyle._hexToColor(json['color'] as String)
          : null,
      dashPattern: (json['dashPattern'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      id: json['id'] as String?,
      condition: json['condition'] != null
          ? TemplateCondition.fromJson(
              json['condition'] as Map<String, dynamic>)
          : null,
    );
  }
  const DividerElement({
    this.thickness = 1,
    this.color,
    this.dashPattern,
    super.id,
    super.condition,
  });

  final double thickness;
  final PdfColor? color;
  final List<double>? dashPattern;

  @override
  double render(
    PdfPage page,
    Rect bounds,
    TemplateContext context,
    PdfFont font,
  ) {
    if (!shouldRender(context)) return 0;

    final pen = PdfPen(
      color ?? PdfColor(200, 200, 200),
      width: thickness,
    );

    if (dashPattern != null && dashPattern!.isNotEmpty) {
      pen.dashStyle = PdfDashStyle.custom;
      pen.dashPattern = dashPattern!;
    }

    page.graphics.drawLine(
      pen,
      Offset(bounds.left, bounds.top + thickness / 2),
      Offset(bounds.right, bounds.top + thickness / 2),
    );

    return thickness + 4; // Add some spacing
  }

  @override
  double calculateHeight(Rect bounds, TemplateContext context, PdfFont font) {
    if (!shouldRender(context)) return 0;
    return thickness + 4;
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': 'divider',
        'thickness': thickness,
        if (color != null) 'color': ElementStyle._colorToHex(color!),
        if (dashPattern != null) 'dashPattern': dashPattern,
        if (id != null) 'id': id,
        if (condition != null) 'condition': condition!.toJson(),
      };
}

/// A container element that wraps other elements.
class ContainerElement extends TemplateElement {

  factory ContainerElement.fromJson(Map<String, dynamic> json) {
    return ContainerElement(
      children: (json['children'] as List<dynamic>)
          .map((e) => TemplateElement.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as String?,
      condition: json['condition'] != null
          ? TemplateCondition.fromJson(
              json['condition'] as Map<String, dynamic>)
          : null,
      style: json['style'] != null
          ? ElementStyle.fromJson(json['style'] as Map<String, dynamic>)
          : null,
    );
  }
  const ContainerElement({
    required this.children,
    super.id,
    super.condition,
    super.style,
  });

  final List<TemplateElement> children;

  @override
  double render(
    PdfPage page,
    Rect bounds,
    TemplateContext context,
    PdfFont font,
  ) {
    if (!shouldRender(context)) return 0;

    var currentY = bounds.top;
    final padding = style?.padding ?? const EdgeInsets.all(0);
    final contentBounds = Rect.fromLTWH(
      bounds.left + padding.left,
      bounds.top + padding.top,
      bounds.width - padding.horizontal,
      bounds.height - padding.vertical,
    );

    // Draw background if set
    if (style?.backgroundColor != null) {
      page.graphics.drawRectangle(
        brush: PdfSolidBrush(style!.backgroundColor!),
        bounds: bounds,
      );
    }

    // Draw border if set
    if (style?.borderColor != null && style?.borderWidth != null) {
      page.graphics.drawRectangle(
        pen: PdfPen(style!.borderColor!, width: style!.borderWidth!),
        bounds: bounds,
      );
    }

    currentY = contentBounds.top;

    for (final child in children) {
      final childBounds = Rect.fromLTWH(
        contentBounds.left,
        currentY,
        contentBounds.width,
        contentBounds.bottom - currentY,
      );

      final height = child.render(page, childBounds, context, font);
      currentY += height;
    }

    return currentY - bounds.top + padding.bottom;
  }

  @override
  double calculateHeight(Rect bounds, TemplateContext context, PdfFont font) {
    if (!shouldRender(context)) return 0;

    final padding = style?.padding ?? const EdgeInsets.all(0);
    final contentWidth = bounds.width - padding.horizontal;

    var totalHeight = padding.vertical;

    for (final child in children) {
      final childBounds = Rect.fromLTWH(0, 0, contentWidth, bounds.height);
      totalHeight += child.calculateHeight(childBounds, context, font);
    }

    return totalHeight;
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': 'container',
        'children': children.map((c) => c.toJson()).toList(),
        if (id != null) 'id': id,
        if (condition != null) 'condition': condition!.toJson(),
        if (style != null) 'style': style!.toJson(),
      };
}

/// A row element that arranges children horizontally.
class RowElement extends TemplateElement {

  factory RowElement.fromJson(Map<String, dynamic> json) {
    return RowElement(
      children: (json['children'] as List<dynamic>)
          .map((e) => TemplateElement.fromJson(e as Map<String, dynamic>))
          .toList(),
      spacing: (json['spacing'] as num?)?.toDouble() ?? 10,
      flexValues:
          (json['flexValues'] as List<dynamic>?)?.map((e) => e as int).toList(),
      id: json['id'] as String?,
      condition: json['condition'] != null
          ? TemplateCondition.fromJson(
              json['condition'] as Map<String, dynamic>)
          : null,
      style: json['style'] != null
          ? ElementStyle.fromJson(json['style'] as Map<String, dynamic>)
          : null,
    );
  }
  const RowElement({
    required this.children,
    this.spacing = 10,
    this.flexValues,
    super.id,
    super.condition,
    super.style,
  });

  final List<TemplateElement> children;
  final double spacing;
  final List<int>? flexValues;

  @override
  double render(
    PdfPage page,
    Rect bounds,
    TemplateContext context,
    PdfFont font,
  ) {
    if (!shouldRender(context)) return 0;
    if (children.isEmpty) return 0;

    final totalSpacing = spacing * (children.length - 1);
    final availableWidth = bounds.width - totalSpacing;

    // Calculate widths
    List<double> widths;
    if (flexValues != null && flexValues!.length == children.length) {
      final totalFlex = flexValues!.reduce((a, b) => a + b);
      widths = flexValues!.map((f) => availableWidth * f / totalFlex).toList();
    } else {
      final equalWidth = availableWidth / children.length;
      widths = List.filled(children.length, equalWidth);
    }

    var maxHeight = 0.0;
    var currentX = bounds.left;

    for (var i = 0; i < children.length; i++) {
      final childBounds = Rect.fromLTWH(
        currentX,
        bounds.top,
        widths[i],
        bounds.height,
      );

      final height = children[i].render(page, childBounds, context, font);
      maxHeight = height > maxHeight ? height : maxHeight;
      currentX += widths[i] + spacing;
    }

    return maxHeight;
  }

  @override
  double calculateHeight(Rect bounds, TemplateContext context, PdfFont font) {
    if (!shouldRender(context)) return 0;
    if (children.isEmpty) return 0;

    final totalSpacing = spacing * (children.length - 1);
    final availableWidth = bounds.width - totalSpacing;

    List<double> widths;
    if (flexValues != null && flexValues!.length == children.length) {
      final totalFlex = flexValues!.reduce((a, b) => a + b);
      widths = flexValues!.map((f) => availableWidth * f / totalFlex).toList();
    } else {
      final equalWidth = availableWidth / children.length;
      widths = List.filled(children.length, equalWidth);
    }

    var maxHeight = 0.0;
    for (var i = 0; i < children.length; i++) {
      final childBounds = Rect.fromLTWH(0, 0, widths[i], bounds.height);
      final height = children[i].calculateHeight(childBounds, context, font);
      maxHeight = height > maxHeight ? height : maxHeight;
    }

    return maxHeight;
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': 'row',
        'children': children.map((c) => c.toJson()).toList(),
        'spacing': spacing,
        if (flexValues != null) 'flexValues': flexValues,
        if (id != null) 'id': id,
        if (condition != null) 'condition': condition!.toJson(),
        if (style != null) 'style': style!.toJson(),
      };
}

/// A column element that arranges children vertically.
class ColumnElement extends TemplateElement {

  factory ColumnElement.fromJson(Map<String, dynamic> json) {
    return ColumnElement(
      children: (json['children'] as List<dynamic>)
          .map((e) => TemplateElement.fromJson(e as Map<String, dynamic>))
          .toList(),
      spacing: (json['spacing'] as num?)?.toDouble() ?? 5,
      id: json['id'] as String?,
      condition: json['condition'] != null
          ? TemplateCondition.fromJson(
              json['condition'] as Map<String, dynamic>)
          : null,
      style: json['style'] != null
          ? ElementStyle.fromJson(json['style'] as Map<String, dynamic>)
          : null,
    );
  }
  const ColumnElement({
    required this.children,
    this.spacing = 5,
    super.id,
    super.condition,
    super.style,
  });

  final List<TemplateElement> children;
  final double spacing;

  @override
  double render(
    PdfPage page,
    Rect bounds,
    TemplateContext context,
    PdfFont font,
  ) {
    if (!shouldRender(context)) return 0;

    var currentY = bounds.top;

    for (var i = 0; i < children.length; i++) {
      final childBounds = Rect.fromLTWH(
        bounds.left,
        currentY,
        bounds.width,
        bounds.bottom - currentY,
      );

      final height = children[i].render(page, childBounds, context, font);
      currentY += height;

      if (i < children.length - 1) {
        currentY += spacing;
      }
    }

    return currentY - bounds.top;
  }

  @override
  double calculateHeight(Rect bounds, TemplateContext context, PdfFont font) {
    if (!shouldRender(context)) return 0;

    var totalHeight = 0.0;

    for (var i = 0; i < children.length; i++) {
      totalHeight += children[i].calculateHeight(bounds, context, font);
      if (i < children.length - 1) {
        totalHeight += spacing;
      }
    }

    return totalHeight;
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': 'column',
        'children': children.map((c) => c.toJson()).toList(),
        'spacing': spacing,
        if (id != null) 'id': id,
        if (condition != null) 'condition': condition!.toJson(),
        if (style != null) 'style': style!.toJson(),
      };
}

/// A loop element that repeats children for each item in a list.
class LoopElement extends TemplateElement {

  factory LoopElement.fromJson(Map<String, dynamic> json) {
    return LoopElement(
      loop: TemplateLoop.fromJson(json['loop'] as Map<String, dynamic>),
      children: (json['children'] as List<dynamic>)
          .map((e) => TemplateElement.fromJson(e as Map<String, dynamic>))
          .toList(),
      separator: json['separator'] != null
          ? TemplateElement.fromJson(json['separator'] as Map<String, dynamic>)
          : null,
      id: json['id'] as String?,
      condition: json['condition'] != null
          ? TemplateCondition.fromJson(
              json['condition'] as Map<String, dynamic>)
          : null,
      style: json['style'] != null
          ? ElementStyle.fromJson(json['style'] as Map<String, dynamic>)
          : null,
    );
  }
  const LoopElement({
    required this.loop,
    required this.children,
    this.separator,
    super.id,
    super.condition,
    super.style,
  });

  final TemplateLoop loop;
  final List<TemplateElement> children;
  final TemplateElement? separator;

  @override
  double render(
    PdfPage page,
    Rect bounds,
    TemplateContext context,
    PdfFont font,
  ) {
    if (!shouldRender(context)) return 0;

    final items = loop.getItems(context.mergedData);
    var currentY = bounds.top;

    for (var i = 0; i < items.length; i++) {
      final itemContext = context.forLoopIteration(loop, items[i], i);

      for (final child in children) {
        final childBounds = Rect.fromLTWH(
          bounds.left,
          currentY,
          bounds.width,
          bounds.bottom - currentY,
        );

        final height = child.render(page, childBounds, itemContext, font);
        currentY += height;
      }

      // Add separator between items
      if (separator != null && i < items.length - 1) {
        final sepBounds = Rect.fromLTWH(
          bounds.left,
          currentY,
          bounds.width,
          bounds.bottom - currentY,
        );
        currentY += separator!.render(page, sepBounds, itemContext, font);
      }
    }

    return currentY - bounds.top;
  }

  @override
  double calculateHeight(Rect bounds, TemplateContext context, PdfFont font) {
    if (!shouldRender(context)) return 0;

    final items = loop.getItems(context.mergedData);
    var totalHeight = 0.0;

    for (var i = 0; i < items.length; i++) {
      final itemContext = context.forLoopIteration(loop, items[i], i);

      for (final child in children) {
        totalHeight += child.calculateHeight(bounds, itemContext, font);
      }

      if (separator != null && i < items.length - 1) {
        totalHeight += separator!.calculateHeight(bounds, itemContext, font);
      }
    }

    return totalHeight;
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': 'loop',
        'loop': loop.toJson(),
        'children': children.map((c) => c.toJson()).toList(),
        if (separator != null) 'separator': separator!.toJson(),
        if (id != null) 'id': id,
        if (condition != null) 'condition': condition!.toJson(),
        if (style != null) 'style': style!.toJson(),
      };
}

/// A conditional element that renders different content based on a condition.
class ConditionalElement extends TemplateElement {

  factory ConditionalElement.fromJson(Map<String, dynamic> json) {
    return ConditionalElement(
      condition: json['condition'] != null
          ? TemplateCondition.fromJson(json['condition'] as Map<String, dynamic>)
          : TemplateCondition.equals('_always', true),
      thenElements: (json['thenElements'] as List<dynamic>)
          .map((e) => TemplateElement.fromJson(e as Map<String, dynamic>))
          .toList(),
      elseElements: (json['elseElements'] as List<dynamic>?)
          ?.map((e) => TemplateElement.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as String?,
      style: json['style'] != null
          ? ElementStyle.fromJson(json['style'] as Map<String, dynamic>)
          : null,
    );
  }
  const ConditionalElement({
    required super.condition,
    required this.thenElements,
    this.elseElements,
    super.id,
    super.style,
  });

  final List<TemplateElement> thenElements;
  final List<TemplateElement>? elseElements;

  @override
  double render(
    PdfPage page,
    Rect bounds,
    TemplateContext context,
    PdfFont font,
  ) {
    // Safe null check - if condition is null, render thenElements by default
    final conditionMet = condition?.evaluate(context.mergedData) ?? true;
    final elements = conditionMet ? thenElements : (elseElements ?? []);

    var currentY = bounds.top;

    for (final element in elements) {
      final childBounds = Rect.fromLTWH(
        bounds.left,
        currentY,
        bounds.width,
        bounds.bottom - currentY,
      );

      final height = element.render(page, childBounds, context, font);
      currentY += height;
    }

    return currentY - bounds.top;
  }

  @override
  double calculateHeight(Rect bounds, TemplateContext context, PdfFont font) {
    // Safe null check - if condition is null, use thenElements by default
    final conditionMet = condition?.evaluate(context.mergedData) ?? true;
    final elements = conditionMet ? thenElements : (elseElements ?? []);

    var totalHeight = 0.0;
    for (final element in elements) {
      totalHeight += element.calculateHeight(bounds, context, font);
    }

    return totalHeight;
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': 'conditional',
        if (condition != null) 'condition': condition!.toJson(),
        'thenElements': thenElements.map((e) => e.toJson()).toList(),
        if (elseElements != null)
          'elseElements': elseElements!.map((e) => e.toJson()).toList(),
        if (id != null) 'id': id,
        if (style != null) 'style': style!.toJson(),
      };
}

/// A simple table element.
class TableElement extends TemplateElement {

  factory TableElement.fromJson(Map<String, dynamic> json) {
    return TableElement(
      columns: (json['columns'] as List<dynamic>)
          .map((e) => TableColumn.fromJson(e as Map<String, dynamic>))
          .toList(),
      dataVariable: json['dataVariable'] as String,
      headerStyle: json['headerStyle'] != null
          ? ElementStyle.fromJson(json['headerStyle'] as Map<String, dynamic>)
          : null,
      cellStyle: json['cellStyle'] != null
          ? ElementStyle.fromJson(json['cellStyle'] as Map<String, dynamic>)
          : null,
      showHeader: json['showHeader'] as bool? ?? true,
      rowSpacing: (json['rowSpacing'] as num?)?.toDouble() ?? 5,
      id: json['id'] as String?,
      condition: json['condition'] != null
          ? TemplateCondition.fromJson(
              json['condition'] as Map<String, dynamic>)
          : null,
      style: json['style'] != null
          ? ElementStyle.fromJson(json['style'] as Map<String, dynamic>)
          : null,
    );
  }
  const TableElement({
    required this.columns,
    required this.dataVariable,
    this.headerStyle,
    this.cellStyle,
    this.showHeader = true,
    this.rowSpacing = 5,
    super.id,
    super.condition,
    super.style,
  });

  final List<TableColumn> columns;
  final String dataVariable;
  final ElementStyle? headerStyle;
  final ElementStyle? cellStyle;
  final bool showHeader;
  final double rowSpacing;

  @override
  double render(
    PdfPage page,
    Rect bounds,
    TemplateContext context,
    PdfFont font,
  ) {
    if (!shouldRender(context)) return 0;

    var currentY = bounds.top;

    // Calculate column widths
    final totalFlex = columns.fold<int>(0, (sum, col) => sum + (col.flex ?? 1));
    final columnWidths = columns
        .map((col) => bounds.width * (col.flex ?? 1) / totalFlex)
        .toList();

    // Draw header
    if (showHeader) {
      var headerX = bounds.left;
      for (var i = 0; i < columns.length; i++) {
        final col = columns[i];
        final headerText =
            context.isRtl ? (col.titleAr ?? col.title) : col.title;

        page.graphics.drawString(
          headerText,
          font,
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds: Rect.fromLTWH(headerX, currentY, columnWidths[i], 20),
          format: PdfStringFormat(
            alignment:
                context.isRtl ? PdfTextAlignment.right : PdfTextAlignment.left,
          ),
        );
        headerX += columnWidths[i];
      }
      currentY += 20 + rowSpacing;

      // Draw header line
      page.graphics.drawLine(
        PdfPen(PdfColor(100, 100, 100)),
        Offset(bounds.left, currentY - rowSpacing / 2),
        Offset(bounds.right, currentY - rowSpacing / 2),
      );
    }

    // Draw data rows
    final data = context.getValue(dataVariable);
    if (data is List) {
      for (final row in data) {
        var cellX = bounds.left;
        for (var i = 0; i < columns.length; i++) {
          final col = columns[i];
          dynamic cellValue;

          if (row is Map) {
            cellValue = row[col.field];
          }

          page.graphics.drawString(
            cellValue?.toString() ?? '',
            font,
            brush: PdfSolidBrush(PdfColor(0, 0, 0)),
            bounds: Rect.fromLTWH(cellX, currentY, columnWidths[i], 18),
            format: PdfStringFormat(
              alignment: context.isRtl
                  ? PdfTextAlignment.right
                  : PdfTextAlignment.left,
            ),
          );
          cellX += columnWidths[i];
        }
        currentY += 18 + rowSpacing;
      }
    }

    return currentY - bounds.top;
  }

  @override
  double calculateHeight(Rect bounds, TemplateContext context, PdfFont font) {
    if (!shouldRender(context)) return 0;

    var totalHeight = 0.0;

    if (showHeader) {
      totalHeight += 20 + rowSpacing;
    }

    final data = context.getValue(dataVariable);
    if (data is List) {
      totalHeight += data.length * (18 + rowSpacing);
    }

    return totalHeight;
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': 'table',
        'columns': columns.map((c) => c.toJson()).toList(),
        'dataVariable': dataVariable,
        if (headerStyle != null) 'headerStyle': headerStyle!.toJson(),
        if (cellStyle != null) 'cellStyle': cellStyle!.toJson(),
        'showHeader': showHeader,
        'rowSpacing': rowSpacing,
        if (id != null) 'id': id,
        if (condition != null) 'condition': condition!.toJson(),
        if (style != null) 'style': style!.toJson(),
      };
}

/// Column definition for TableElement.
class TableColumn {

  factory TableColumn.fromJson(Map<String, dynamic> json) {
    return TableColumn(
      field: json['field'] as String,
      title: json['title'] as String,
      titleAr: json['titleAr'] as String?,
      flex: json['flex'] as int?,
      format: json['format'] as String?,
    );
  }
  const TableColumn({
    required this.field,
    required this.title,
    this.titleAr,
    this.flex,
    this.format,
  });

  final String field;
  final String title;
  final String? titleAr;
  final int? flex;
  final String? format;

  Map<String, dynamic> toJson() => {
        'field': field,
        'title': title,
        if (titleAr != null) 'titleAr': titleAr,
        if (flex != null) 'flex': flex,
        if (format != null) 'format': format,
      };
}

/// An image element.
class ImageElement extends TemplateElement {

  factory ImageElement.fromJson(Map<String, dynamic> json) {
    return ImageElement(
      imageVariable: json['imageVariable'] as String?,
      width: (json['width'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      alignment: json['alignment'] != null
          ? PdfTextAlignment.values.firstWhere(
              (e) => e.name == json['alignment'],
              orElse: () => PdfTextAlignment.center,
            )
          : PdfTextAlignment.center,
      id: json['id'] as String?,
      condition: json['condition'] != null
          ? TemplateCondition.fromJson(
              json['condition'] as Map<String, dynamic>)
          : null,
      style: json['style'] != null
          ? ElementStyle.fromJson(json['style'] as Map<String, dynamic>)
          : null,
    );
  }
  const ImageElement({
    this.imageVariable,
    this.width,
    this.height,
    this.alignment = PdfTextAlignment.center,
    super.id,
    super.condition,
    super.style,
  });

  final String? imageVariable;
  final double? width;
  final double? height;
  final PdfTextAlignment alignment;

  @override
  double render(
    PdfPage page,
    Rect bounds,
    TemplateContext context,
    PdfFont font,
  ) {
    if (!shouldRender(context)) return 0;

    // For now, return placeholder height
    // Actual image rendering would require image data handling
    return height ?? 100;
  }

  @override
  double calculateHeight(Rect bounds, TemplateContext context, PdfFont font) {
    if (!shouldRender(context)) return 0;
    return height ?? 100;
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': 'image',
        if (imageVariable != null) 'imageVariable': imageVariable,
        if (width != null) 'width': width,
        if (height != null) 'height': height,
        'alignment': alignment.name,
        if (id != null) 'id': id,
        if (condition != null) 'condition': condition!.toJson(),
        if (style != null) 'style': style!.toJson(),
      };
}
