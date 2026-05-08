import 'dart:typed_data';
import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../src/core/pdf_config.dart';
import 'template_definition.dart';
import 'template_elements.dart';
import 'template_models.dart';

/// Engine for rendering PDF documents from template definitions.
///
/// The template engine processes a [TemplateDefinition] with data to produce
/// a PDF document. It handles variable substitution, conditional rendering,
/// loops, and multi-page layouts.
///
/// ## Example
/// ```dart
/// final engine = PdfTemplateEngine(
///   config: pdfConfig,
/// );
///
/// // Render a template with data
/// final bytes = await engine.render(
///   template: invoiceTemplate,
///   data: {
///     'invoiceNumber': 'INV-001',
///     'customerName': 'John Doe',
///     'items': [
///       {'name': 'Product A', 'price': 100},
///       {'name': 'Product B', 'price': 200},
///     ],
///   },
///   isRtl: false,
/// );
/// ```
class PdfTemplateEngine {
  /// Creates a template engine.
  PdfTemplateEngine({
    required this.config,
    TemplateMargins? defaultMargins,
  }) : defaultMargins = defaultMargins ??
            TemplateMargins(
              left: config.margins.left,
              top: config.margins.top,
              right: config.margins.right,
              bottom: config.margins.bottom,
            );

  /// Configuration for the document.
  final GeniusPdfConfig config;

  /// The base font for the document.
  PdfFont get baseFont => config.baseFont;

  /// Default margins if not specified in template.
  final TemplateMargins defaultMargins;

  /// Renders a template with data to produce PDF bytes.
  Future<Uint8List> render({
    required TemplateDefinition template,
    required Map<String, dynamic> data,
    bool? isRtl,
    void Function(RenderProgress)? onProgress,
  }) async {
    final resolvedRtl = isRtl ?? config.textDirection == TextDirection.rtl;
    // Validate data
    final validationErrors = template.validate(data);
    if (validationErrors.any((e) => !e.isValid)) {
      final errors = validationErrors
          .where((e) => !e.isValid)
          .map((e) => e.getError(resolvedRtl))
          .join(', ');
      throw TemplateRenderException('Validation failed: $errors');
    }

    // Merge default values with provided data
    final mergedData = {...template.getDefaultValues(), ...data};

    // Create context
    final context = TemplateContext(
      data: mergedData,
      isRtl: resolvedRtl,
    );

    // Create document
    final document = PdfDocument();
    _applyPageSettings(document, template.pageSettings);

    // Calculate content area
    final margins = template.pageSettings?.margins ?? defaultMargins;
    final pageSize = document.pages.add().size;
    final contentWidth = pageSize.width - margins.left - margins.right;

    // Render content
    var currentPage = document.pages[0];
    var currentY = margins.top;

    // Render header on first page
    if (template.header != null) {
      currentY = _renderElements(
        template.header!,
        currentPage,
        Rect.fromLTWH(margins.left, currentY, contentWidth, 100),
        context,
      );
      currentY += 10; // Space after header
    }

    // Report progress
    onProgress?.call(RenderProgress(
      phase: RenderPhase.rendering,
      currentElement: 0,
      totalElements: template.content.length,
      currentPage: 1,
    ));

    // Render main content
    for (var i = 0; i < template.content.length; i++) {
      final element = template.content[i];

      // Check if we need a new page
      final elementHeight = element.calculateHeight(
        Rect.fromLTWH(margins.left, currentY, contentWidth,
            pageSize.height - currentY - margins.bottom),
        context,
        baseFont,
      );

      final availableHeight = pageSize.height - currentY - margins.bottom;
      if (template.footer != null) {
        // Reserve space for footer
        final footerHeight = _calculateElementsHeight(
          template.footer!,
          Rect.fromLTWH(0, 0, contentWidth, 100),
          context,
        );
        if (elementHeight > availableHeight - footerHeight - 20) {
          // Render footer before new page
          _renderElements(
            template.footer!,
            currentPage,
            Rect.fromLTWH(
              margins.left,
              pageSize.height - margins.bottom - footerHeight,
              contentWidth,
              footerHeight,
            ),
            context,
          );

          // Add new page
          currentPage = document.pages.add();
          currentY = margins.top;

          // Render header on new page
          if (template.header != null) {
            currentY = _renderElements(
              template.header!,
              currentPage,
              Rect.fromLTWH(margins.left, currentY, contentWidth, 100),
              context,
            );
            currentY += 10;
          }
        }
      }

      // Render element
      final bounds = Rect.fromLTWH(
        margins.left,
        currentY,
        contentWidth,
        pageSize.height - currentY - margins.bottom,
      );

      final height = element.render(currentPage, bounds, context, baseFont);
      currentY += height;

      // Report progress
      onProgress?.call(RenderProgress(
        phase: RenderPhase.rendering,
        currentElement: i + 1,
        totalElements: template.content.length,
        currentPage: document.pages.count,
      ));
    }

    // Render footer on last page
    if (template.footer != null) {
      final footerHeight = _calculateElementsHeight(
        template.footer!,
        Rect.fromLTWH(0, 0, contentWidth, 100),
        context,
      );
      _renderElements(
        template.footer!,
        currentPage,
        Rect.fromLTWH(
          margins.left,
          pageSize.height - margins.bottom - footerHeight,
          contentWidth,
          footerHeight,
        ),
        context,
      );
    }

    // Report completion
    onProgress?.call(RenderProgress(
      phase: RenderPhase.complete,
      currentElement: template.content.length,
      totalElements: template.content.length,
      currentPage: document.pages.count,
    ));

    // Save and return bytes
    final bytes = Uint8List.fromList(await document.save());
    document.dispose();

    return bytes;
  }

  /// Renders a template and returns the PdfDocument (for further processing).
  Future<PdfDocument> renderToDocument({
    required TemplateDefinition template,
    required Map<String, dynamic> data,
    bool? isRtl,
  }) async {
    final bytes = await render(
      template: template,
      data: data,
      isRtl: isRtl,
    );
    return PdfDocument(inputBytes: bytes);
  }

  /// Previews a template with sample data.
  Future<Uint8List> preview({
    required TemplateDefinition template,
    bool? isRtl,
  }) {
    // Generate sample data from variable definitions
    final sampleData = _generateSampleData(template);
    return render(template: template, data: sampleData, isRtl: isRtl);
  }

  void _applyPageSettings(PdfDocument document, TemplatePageSettings? settings) {
    document.pageSettings.size = settings?.pageSize ?? config.pageSize;
    document.pageSettings.orientation =
        settings?.orientation ?? config.orientation;

    final margins = settings?.margins ?? defaultMargins;
    document.pageSettings.margins.left = margins.left;
    document.pageSettings.margins.top = margins.top;
    document.pageSettings.margins.right = margins.right;
    document.pageSettings.margins.bottom = margins.bottom;
  }

  double _renderElements(
    List<TemplateElement> elements,
    PdfPage page,
    Rect bounds,
    TemplateContext context,
  ) {
    var currentY = bounds.top;

    for (final element in elements) {
      final elementBounds = Rect.fromLTWH(
        bounds.left,
        currentY,
        bounds.width,
        bounds.bottom - currentY,
      );

      final height = element.render(page, elementBounds, context, baseFont);
      currentY += height;
    }

    return currentY;
  }

  double _calculateElementsHeight(
    List<TemplateElement> elements,
    Rect bounds,
    TemplateContext context,
  ) {
    var totalHeight = 0.0;

    for (final element in elements) {
      totalHeight += element.calculateHeight(bounds, context, baseFont);
    }

    return totalHeight;
  }

  Map<String, dynamic> _generateSampleData(TemplateDefinition template) {
    final data = <String, dynamic>{};

    for (final variable in template.variables) {
      data[variable.name] = _getSampleValue(variable);
    }

    return data;
  }

  dynamic _getSampleValue(TemplateVariable variable) {
    if (variable.defaultValue != null) {
      return variable.defaultValue;
    }

    switch (variable.type) {
      case VariableType.string:
        return variable.label ?? variable.name;
      case VariableType.number:
        return 100;
      case VariableType.currency:
        return 1000.00;
      case VariableType.date:
        return DateTime.now().toIso8601String();
      case VariableType.boolean:
        return true;
      case VariableType.list:
        return [
          {'name': 'Item 1', 'value': 100},
          {'name': 'Item 2', 'value': 200},
        ];
      case VariableType.object:
        return {'key': 'value'};
      case VariableType.image:
        return null;
    }
  }
}

/// Progress information during template rendering.
class RenderProgress {
  const RenderProgress({
    required this.phase,
    required this.currentElement,
    required this.totalElements,
    required this.currentPage,
  });

  final RenderPhase phase;
  final int currentElement;
  final int totalElements;
  final int currentPage;

  double get progress => totalElements > 0 ? currentElement / totalElements : 0;
  int get percentage => (progress * 100).round();
}

/// Phases of template rendering.
enum RenderPhase {
  preparing,
  rendering,
  complete,
}

/// Exception thrown during template rendering.
class TemplateRenderException implements Exception {
  const TemplateRenderException(this.message);

  final String message;

  @override
  String toString() => 'TemplateRenderException: $message';
}

/// Builder for creating templates programmatically.
class TemplateBuilder {
  TemplateBuilder({
    required this.id,
    required this.name,
    this.nameAr,
  });

  final String id;
  final String name;
  final String? nameAr;

  String? description;
  String? descriptionAr;
  String version = '1.0.0';
  String? author;
  String? category;
  final List<String> tags = [];
  final List<TemplateVariable> variables = [];
  final List<TemplateElement> content = [];
  TemplatePageSettings? pageSettings;
  List<TemplateElement>? header;
  List<TemplateElement>? footer;
  final Map<String, ElementStyle> styles = {};
  final Map<String, dynamic> metadata = {};

  /// Adds a variable to the template.
  TemplateBuilder addVariable(TemplateVariable variable) {
    variables.add(variable);
    return this;
  }

  /// Adds a text element.
  TemplateBuilder addText(String text, {String? textAr, double? fontSize}) {
    content.add(TextElement(text: text, textAr: textAr, fontSize: fontSize));
    return this;
  }

  /// Adds a variable element.
  TemplateBuilder addVariableElement(
    String variableName, {
    String? prefix,
    String? suffix,
  }) {
    content.add(VariableElement(
      variableName: variableName,
      prefix: prefix,
      suffix: suffix,
    ));
    return this;
  }

  /// Adds a spacer.
  TemplateBuilder addSpacer(double height) {
    content.add(SpacerElement(height: height));
    return this;
  }

  /// Adds a divider.
  TemplateBuilder addDivider({double thickness = 1}) {
    content.add(DividerElement(thickness: thickness));
    return this;
  }

  /// Adds a row of elements.
  TemplateBuilder addRow(
    List<TemplateElement> children, {
    double spacing = 10,
    List<int>? flexValues,
  }) {
    content.add(RowElement(
      children: children,
      spacing: spacing,
      flexValues: flexValues,
    ));
    return this;
  }

  /// Adds a loop element.
  TemplateBuilder addLoop({
    required String variable,
    required List<TemplateElement> children,
    String itemName = 'item',
  }) {
    content.add(LoopElement(
      loop: TemplateLoop(variable: variable, itemName: itemName),
      children: children,
    ));
    return this;
  }

  /// Adds a conditional element.
  TemplateBuilder addConditional({
    required TemplateCondition condition,
    required List<TemplateElement> thenElements,
    List<TemplateElement>? elseElements,
  }) {
    content.add(ConditionalElement(
      condition: condition,
      thenElements: thenElements,
      elseElements: elseElements,
    ));
    return this;
  }

  /// Adds a table element.
  TemplateBuilder addTable({
    required List<TableColumn> columns,
    required String dataVariable,
    bool showHeader = true,
  }) {
    content.add(TableElement(
      columns: columns,
      dataVariable: dataVariable,
      showHeader: showHeader,
    ));
    return this;
  }

  /// Adds any element.
  TemplateBuilder addElement(TemplateElement element) {
    content.add(element);
    return this;
  }

  /// Sets page settings.
  TemplateBuilder setPageSettings({
    Size pageSize = PdfPageSize.a4,
    PdfPageOrientation orientation = PdfPageOrientation.portrait,
    TemplateMargins? margins,
  }) {
    pageSettings = TemplatePageSettings(
      pageSize: pageSize,
      orientation: orientation,
      margins: margins,
    );
    return this;
  }

  /// Sets header elements.
  TemplateBuilder setHeader(List<TemplateElement> elements) {
    header = elements;
    return this;
  }

  /// Sets footer elements.
  TemplateBuilder setFooter(List<TemplateElement> elements) {
    footer = elements;
    return this;
  }

  /// Builds the template definition.
  TemplateDefinition build() {
    return TemplateDefinition(
      id: id,
      name: name,
      nameAr: nameAr,
      description: description,
      descriptionAr: descriptionAr,
      version: version,
      author: author,
      category: category,
      tags: tags,
      variables: variables,
      content: content,
      pageSettings: pageSettings,
      header: header,
      footer: footer,
      styles: styles,
      metadata: metadata,
    );
  }
}
