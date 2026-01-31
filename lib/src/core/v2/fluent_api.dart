import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_pdf/pdf.dart' as sf;

import '../pdf_config.dart';
import 'event_system.dart';

/// Enhanced Fluent API for building PDF documents.
///
/// Provides a chainable, expressive API for creating complex PDFs.
///
/// ## Example
/// ```dart
/// final pdf = PdfBuilder()
///   .configure((c) => c
///     .title('My Report')
///     .author('John Doe')
///     .pageFormat(PdfPageFormat.a4)
///     .rtl(true))
///   .addPage((page) => page
///     .header('Monthly Report')
///     .paragraph('This is the content...')
///     .table([
///       ['Name', 'Value'],
///       ['Item 1', '100'],
///     ])
///     .footer('Page 1'))
///   .build();
/// ```
class GeniusPdfBuilder with GeniusEventEmitter {
  GeniusPdfBuilder({
    String? id,
    required GeniusPdfConfig config,
    pw.Font? defaultFont,
  })  : _id = id ?? _generateId(),
        _config = GeniusDocumentConfig.fromPdfConfig(
          config,
          defaultFont: defaultFont,
        );

  final String _id;
  final pw.Document _document = pw.Document();
  final List<pw.Page> _pages = [];
  GeniusDocumentConfig _config;

  static int _idCounter = 0;
  static String _generateId() => 'doc_${++_idCounter}';

  /// Document ID.
  String get id => _id;

  /// Current configuration.
  GeniusDocumentConfig get config => _config;

  /// Applies a [GeniusPdfConfig] to this builder.
  GeniusPdfBuilder applyPdfConfig(
    GeniusPdfConfig config, {
    pw.Font? defaultFont,
  }) {
    _config = GeniusDocumentConfig.fromPdfConfig(
      config,
      defaultFont: defaultFont,
    );
    return this;
  }

  /// Configures the document.
  GeniusPdfBuilder configure(
      GeniusDocumentConfig Function(GeniusDocumentConfigBuilder) builder) {
    _config = builder(GeniusDocumentConfigBuilder(_config));
    return this;
  }

  /// Sets document metadata directly.
  GeniusPdfBuilder metadata({
    String? title,
    String? author,
    String? subject,
    String? keywords,
    String? creator,
  }) {
    _config = _config.copyWith(
      title: title,
      author: author,
      subject: subject,
      keywords: keywords,
      creator: creator,
    );
    return this;
  }

  /// Sets page format.
  GeniusPdfBuilder pageFormat(PdfPageFormat format) {
    _config = _config.copyWith(pageFormat: format);
    return this;
  }

  /// Enables RTL layout.
  GeniusPdfBuilder rtl([bool enable = true]) {
    _config = _config.copyWith(isRtl: enable);
    return this;
  }

  /// Adds a page using the page builder.
  GeniusPdfBuilder addPage(
      GeniusPageContent Function(GeniusPageBuilder) builder) {
    final pageBuilder = GeniusPageBuilder(_config);
    final content = builder(pageBuilder);

    final page = pw.Page(
      pageFormat: _config.pageFormat,
      textDirection:
          _config.isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
      margin: _config.margin,
      build: (context) => content.build(context),
    );

    _pages.add(page);
    emit(GeniusPageAddedEvent(documentId: _id, pageIndex: _pages.length - 1));

    return this;
  }

  /// Adds multiple pages.
  GeniusPdfBuilder addPages(int count,
      GeniusPageContent Function(GeniusPageBuilder, int index) builder) {
    for (var i = 0; i < count; i++) {
      addPage((page) => builder(page, i));
    }
    return this;
  }

  /// Adds a raw widget page.
  GeniusPdfBuilder addWidget(pw.Widget widget) {
    final page = pw.Page(
      pageFormat: _config.pageFormat,
      textDirection:
          _config.isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
      margin: _config.margin,
      build: (context) => widget,
    );
    _pages.add(page);
    return this;
  }

  /// Adds a multi-page document.
  GeniusPdfBuilder addMultiPage(
      GeniusMultiPageContent Function(GeniusMultiPageBuilder) builder) {
    final multiBuilder = GeniusMultiPageBuilder(_config);
    final content = builder(multiBuilder);

    _document.addPage(
      pw.MultiPage(
        pageFormat: _config.pageFormat,
        textDirection:
            _config.isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
        margin: _config.margin,
        header: content.header,
        footer: content.footer,
        build: (context) => content.children,
      ),
    );

    return this;
  }

  /// Builds the PDF document.
  pw.Document build() {
    emit(GeniusRenderStartedEvent(documentId: _id, totalPages: _pages.length));

    for (final page in _pages) {
      _document.addPage(page);
    }

    emit(GeniusRenderCompletedEvent(
      documentId: _id,
      duration: Duration.zero,
    ));

    return _document;
  }

  /// Builds and returns PDF bytes.
  Future<Uint8List> buildBytes() async {
    build();
    return _document.save();
  }
}

/// Document configuration.
class GeniusDocumentConfig {
  const GeniusDocumentConfig({
    this.title,
    this.author,
    this.subject,
    this.keywords,
    this.creator,
    this.pageFormat = PdfPageFormat.a4,
    this.margin = const pw.EdgeInsets.all(40),
    this.isRtl = false,
    this.defaultFont,
  });

  /// Creates a v2 config from [GeniusPdfConfig].
  factory GeniusDocumentConfig.fromPdfConfig(
    GeniusPdfConfig config, {
    pw.Font? defaultFont,
  }) {
    return GeniusDocumentConfig(
      pageFormat: _pageFormatFromConfig(config),
      margin: _edgeInsetsFromMargins(config.margins),
      isRtl: config.isRTL,
      defaultFont: defaultFont,
    );
  }

  final String? title;
  final String? author;
  final String? subject;
  final String? keywords;
  final String? creator;
  final PdfPageFormat pageFormat;
  final pw.EdgeInsets margin;
  final bool isRtl;
  final pw.Font? defaultFont;

  GeniusDocumentConfig copyWith({
    String? title,
    String? author,
    String? subject,
    String? keywords,
    String? creator,
    PdfPageFormat? pageFormat,
    pw.EdgeInsets? margin,
    bool? isRtl,
    pw.Font? defaultFont,
  }) {
    return GeniusDocumentConfig(
      title: title ?? this.title,
      author: author ?? this.author,
      subject: subject ?? this.subject,
      keywords: keywords ?? this.keywords,
      creator: creator ?? this.creator,
      pageFormat: pageFormat ?? this.pageFormat,
      margin: margin ?? this.margin,
      isRtl: isRtl ?? this.isRtl,
      defaultFont: defaultFont ?? this.defaultFont,
    );
  }
}

PdfPageFormat _pageFormatFromConfig(GeniusPdfConfig config) {
  final width = config.pageSize.width;
  final height = config.pageSize.height;
  final isLandscape = config.orientation == sf.PdfPageOrientation.landscape;

  final effectiveWidth = isLandscape ? height : width;
  final effectiveHeight = isLandscape ? width : height;

  return PdfPageFormat(effectiveWidth, effectiveHeight);
}

pw.EdgeInsets _edgeInsetsFromMargins(sf.PdfMargins margins) {
  return pw.EdgeInsets.fromLTRB(
    margins.left,
    margins.top,
    margins.right,
    margins.bottom,
  );
}

/// Builder for document configuration.
class GeniusDocumentConfigBuilder {
  GeniusDocumentConfigBuilder(this._config);

  GeniusDocumentConfig _config;
  GeniusDocumentConfig get config => _config;

  GeniusDocumentConfig title(String title) {
    _config = _config.copyWith(title: title);
    return _config;
  }

  GeniusDocumentConfig author(String author) {
    _config = _config.copyWith(author: author);
    return _config;
  }

  GeniusDocumentConfig subject(String subject) {
    _config = _config.copyWith(subject: subject);
    return _config;
  }

  GeniusDocumentConfig keywords(String keywords) {
    _config = _config.copyWith(keywords: keywords);
    return _config;
  }

  GeniusDocumentConfig pageFormat(PdfPageFormat format) {
    _config = _config.copyWith(pageFormat: format);
    return _config;
  }

  GeniusDocumentConfig margin(pw.EdgeInsets margin) {
    _config = _config.copyWith(margin: margin);
    return _config;
  }

  GeniusDocumentConfig rtl([bool enable = true]) {
    _config = _config.copyWith(isRtl: enable);
    return _config;
  }
}

/// Builder for individual pages.
class GeniusPageBuilder {
  GeniusPageBuilder(this._config);

  final GeniusDocumentConfig _config;
  final List<pw.Widget> _widgets = [];

  pw.TextStyle _textStyle({
    double? fontSize,
    pw.FontWeight? fontWeight,
    PdfColor? color,
  }) {
    return pw.TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      font: _config.defaultFont,
    );
  }

  /// Adds a header.
  GeniusPageBuilder header(
    String text, {
    double fontSize = 24,
    pw.FontWeight fontWeight = pw.FontWeight.bold,
    PdfColor? color,
  }) {
    _widgets.add(
      pw.Header(
        level: 0,
        child: pw.Text(
          text,
          style: _textStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
          ),
        ),
      ),
    );
    return this;
  }

  /// Adds a subheader.
  GeniusPageBuilder subheader(String text, {double fontSize = 18}) {
    _widgets.add(
      pw.Header(
        level: 1,
        child: pw.Text(text, style: _textStyle(fontSize: fontSize)),
      ),
    );
    return this;
  }

  /// Adds a paragraph.
  GeniusPageBuilder paragraph(
    String text, {
    double fontSize = 12,
    pw.TextAlign? textAlign,
  }) {
    _widgets.add(
      pw.Paragraph(
        text: text,
        style: _textStyle(fontSize: fontSize),
        textAlign: textAlign ??
            (_config.isRtl ? pw.TextAlign.right : pw.TextAlign.left),
      ),
    );
    return this;
  }

  /// Adds rich text.
  GeniusPageBuilder richText(List<pw.TextSpan> spans) {
    _widgets.add(
      pw.RichText(
        text: pw.TextSpan(style: _textStyle(), children: spans),
      ),
    );
    return this;
  }

  /// Adds a bullet list.
  GeniusPageBuilder bulletList(List<String> items, {double fontSize = 12}) {
    for (final item in items) {
      _widgets.add(
        pw.Bullet(
          text: item,
          style: _textStyle(fontSize: fontSize),
        ),
      );
    }
    return this;
  }

  /// Adds a numbered list.
  GeniusPageBuilder numberedList(List<String> items, {double fontSize = 12}) {
    for (var i = 0; i < items.length; i++) {
      _widgets.add(
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 4),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(
                width: 20,
                child: pw.Text(
                  '${i + 1}.',
                  style: _textStyle(fontSize: fontSize),
                ),
              ),
              pw.Expanded(
                child: pw.Text(
                  items[i],
                  style: _textStyle(fontSize: fontSize),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return this;
  }

  /// Adds a table.
  GeniusPageBuilder table(
    List<List<dynamic>> data, {
    List<String>? headers,
    pw.TableBorder? border,
    List<pw.FlexColumnWidth>? columnWidths,
  }) {
    final tableData = <List<pw.Widget>>[];

    if (headers != null) {
      tableData.add(
        headers
            .map((h) => pw.Text(
                  h.toString(),
                  style: _textStyle(fontWeight: pw.FontWeight.bold),
                ))
            .toList(),
      );
    }

    for (final row in data) {
      tableData.add(
        row.map((cell) => pw.Text(cell.toString())).toList(),
      );
    }

    _widgets.add(
      pw.TableHelper.fromTextArray(
        data: data.map((row) => row.map((c) => c.toString()).toList()).toList(),
        headers: headers,
        border: border ?? pw.TableBorder.all(),
        headerStyle: _textStyle(fontWeight: pw.FontWeight.bold),
        cellStyle: _textStyle(),
      ),
    );
    return this;
  }

  /// Adds a divider.
  GeniusPageBuilder divider({double height = 1, PdfColor? color}) {
    _widgets.add(
      pw.Divider(
        height: height,
        color: color ?? PdfColors.grey,
      ),
    );
    return this;
  }

  /// Adds vertical spacing.
  GeniusPageBuilder spacer([double height = 20]) {
    _widgets.add(pw.SizedBox(height: height));
    return this;
  }

  /// Adds an image.
  GeniusPageBuilder image(
    pw.ImageProvider imageProvider, {
    double? width,
    double? height,
    pw.BoxFit fit = pw.BoxFit.contain,
  }) {
    _widgets.add(
      pw.Image(
        imageProvider,
        width: width,
        height: height,
        fit: fit,
      ),
    );
    return this;
  }

  /// Adds a container with custom styling.
  GeniusPageBuilder container({
    required pw.Widget child,
    pw.EdgeInsets? padding,
    pw.EdgeInsets? margin,
    pw.BoxDecoration? decoration,
  }) {
    _widgets.add(
      pw.Container(
        padding: padding,
        margin: margin,
        decoration: decoration,
        child: child,
      ),
    );
    return this;
  }

  /// Adds a row of widgets.
  GeniusPageBuilder row(
    List<pw.Widget> children, {
    pw.MainAxisAlignment mainAxisAlignment = pw.MainAxisAlignment.start,
    pw.CrossAxisAlignment crossAxisAlignment = pw.CrossAxisAlignment.center,
  }) {
    _widgets.add(
      pw.Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      ),
    );
    return this;
  }

  /// Adds a column of widgets.
  GeniusPageBuilder column(
    List<pw.Widget> children, {
    pw.MainAxisAlignment mainAxisAlignment = pw.MainAxisAlignment.start,
    pw.CrossAxisAlignment crossAxisAlignment = pw.CrossAxisAlignment.start,
  }) {
    _widgets.add(
      pw.Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      ),
    );
    return this;
  }

  /// Adds a custom widget.
  GeniusPageBuilder widget(pw.Widget widget) {
    _widgets.add(widget);
    return this;
  }

  /// Adds a page footer.
  GeniusPageBuilder footer(
    String text, {
    double fontSize = 10,
    pw.TextAlign textAlign = pw.TextAlign.center,
  }) {
    _widgets.add(
      pw.Align(
        alignment: pw.Alignment.bottomCenter,
        child: pw.Text(
          text,
          style: _textStyle(fontSize: fontSize),
          textAlign: textAlign,
        ),
      ),
    );
    return this;
  }

  /// Builds the page content.
  GeniusPageContent build() {
    return GeniusPageContent(widgets: List.from(_widgets));
  }
}

/// Represents page content.
class GeniusPageContent {
  const GeniusPageContent({required this.widgets});

  final List<pw.Widget> widgets;

  pw.Widget build(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: widgets,
    );
  }
}

/// Builder for multi-page documents.
class GeniusMultiPageBuilder {
  GeniusMultiPageBuilder(this.config);

  final GeniusDocumentConfig config;
  final List<pw.Widget> _children = [];
  pw.Widget Function(pw.Context)? _header;
  pw.Widget Function(pw.Context)? _footer;

  pw.TextStyle _textStyle({
    double? fontSize,
    pw.FontWeight? fontWeight,
    PdfColor? color,
  }) {
    return pw.TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      font: config.defaultFont,
    );
  }

  /// Sets the header builder.
  GeniusMultiPageBuilder header(pw.Widget Function(pw.Context) builder) {
    _header = builder;
    return this;
  }

  /// Sets a simple text header.
  GeniusMultiPageBuilder textHeader(String text, {double fontSize = 14}) {
    _header = (context) => pw.Container(
          alignment: pw.Alignment.centerLeft,
          margin: const pw.EdgeInsets.only(bottom: 10),
          child: pw.Text(
            text,
            style: _textStyle(fontSize: fontSize),
          ),
        );
    return this;
  }

  /// Sets the footer builder.
  GeniusMultiPageBuilder footer(pw.Widget Function(pw.Context) builder) {
    _footer = builder;
    return this;
  }

  /// Sets a page number footer.
  GeniusMultiPageBuilder pageNumberFooter(
      {String format = 'Page {page} of {pages}'}) {
    _footer = (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 10),
          child: pw.Text(
            format
                .replaceAll('{page}', (context.pageNumber).toString())
                .replaceAll('{pages}', (context.pagesCount).toString()),
            style: _textStyle(fontSize: 10),
          ),
        );
    return this;
  }

  /// Adds content.
  GeniusMultiPageBuilder add(pw.Widget widget) {
    _children.add(widget);
    return this;
  }

  /// Adds multiple widgets.
  GeniusMultiPageBuilder addAll(List<pw.Widget> widgets) {
    _children.addAll(widgets);
    return this;
  }

  /// Adds a header.
  GeniusMultiPageBuilder heading(String text,
      {int level = 0, double fontSize = 24}) {
    _children.add(
      pw.Header(
        level: level,
        child: pw.Text(
          text,
          style: _textStyle(
            fontSize: fontSize,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ),
    );
    return this;
  }

  /// Adds a paragraph.
  GeniusMultiPageBuilder paragraph(String text) {
    _children.add(pw.Paragraph(text: text, style: _textStyle()));
    return this;
  }

  /// Builds the multi-page content.
  GeniusMultiPageContent build() {
    return GeniusMultiPageContent(
      children: List.from(_children),
      header: _header,
      footer: _footer,
    );
  }
}

/// Represents multi-page content.
class GeniusMultiPageContent {
  const GeniusMultiPageContent({
    required this.children,
    this.header,
    this.footer,
  });

  final List<pw.Widget> children;
  final pw.Widget Function(pw.Context)? header;
  final pw.Widget Function(pw.Context)? footer;
}

/// Extension for convenient page builder conversion.
extension GeniusPageBuilderExtension on GeniusPageBuilder {
  /// Converts to PageContent.
  GeniusPageContent call() => build();
}
