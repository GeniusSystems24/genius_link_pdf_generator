# Genius Link PDF Generator

A comprehensive PDF generation and preview library for Flutter applications with clean architecture design, RTL/LTR support, reusable components, and pre-built report templates.

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## Features

✨ **Clean Architecture** - Well-organized code with separation of concerns
🔤 **RTL/LTR Support** - Full support for Arabic, Hebrew, and other RTL languages
🔄 **Background Processing** - Generate PDFs without blocking the UI
📄 **Preview Widgets** - Built-in widgets for PDF display and interaction
🎨 **Asset Management** - Centralized font and image management
📤 **Export Options** - Save, share, and print PDFs easily
⚡ **Fluent API** - Easy-to-use builder pattern for document creation
📊 **Reusable Components** - Data grids, rich text, info boxes, headers, summaries
📈 **Charts & Graphs** - Bar, line, pie, and area charts with RTL support
💧 **Watermarks** - Text, image, diagonal, and tiled watermarks
🔒 **Security** - Password protection, encryption, and permissions
✍️ **Digital Signatures** - Certificate-based digital signatures
📑 **Report Templates** - Tax invoices, trial balance, customer statements, inventory reports
📋 **Financial Templates** - Balance sheet, income statement, cash flow, budget reports
🛒 **Sales Templates** - Quotations, purchase orders, delivery notes, credit/debit notes
👥 **HR Templates** - Payslips, employee reports, attendance reports, leave reports
📊 **Barcodes & QR Codes** - EAN-13, Code128, QR Code, DataMatrix, PDF417, ZATCA QR
📤 **Multi-Format Export** - Export to PNG, JPEG, HTML, Text, and PDF/A
🔄 **Batch Export** - Export multiple documents with progress tracking
🔧 **Template Engine** - Dynamic templates with variables, conditions, and loops
📦 **Template Registry** - Manage and share template definitions
🌐 **Bilingual Support** - Arabic/English text throughout all components
🔌 **Plugin System** (v2.0) - Extend functionality with custom plugins
💉 **Dependency Injection** (v2.0) - Clean dependency management
📡 **Event-Driven** (v2.0) - React to document lifecycle events
⚡ **Fluent API v2** (v2.0) - Enhanced chainable API for document creation
🧠 **Smart Caching** (v2.0) - Intelligent caching with multiple strategies
🖥️ **Platform Support** (v2.0) - Consistent API across Web, Mobile, and Desktop
📋 **Logging System** (v2.0.2) - Built-in logger with enable/disable control
🤖 **AI Features** (v2.1.0) - Content analysis, smart layout, text summarization
📊 **Content Analyzer** (v2.1.0) - Extract text, detect document types, find keywords
🎨 **Smart Layout** (v2.1.0) - Automatic font size and margin optimization
📝 **Text Services** (v2.1.0) - Summarization, language detection, title generation
🖼️ **Image Optimizer** (v2.1.0) - Smart image analysis and optimization
🖨️ **Advanced Printing** (v2.2.0) - Printer discovery, print settings, job tracking
📋 **Print Settings** (v2.2.0) - Paper size, orientation, quality, duplex, copies
🔍 **Printer Discovery** (v2.2.0) - Find and manage available printers
👁️ **Print Preview** (v2.2.1) - Visual preview with settings adjustment
💾 **Print Profiles** (v2.2.1) - Save and manage custom print settings
📤 **Unified Sharing** (v2.3.0) - Single API for all sharing methods
📧 **Email Sharing** (v2.3.1) - Direct email with attachments and templates
📶 **Bluetooth Sharing** (v2.3.2) - Nearby device sharing, Nearby Share/AirDrop
📱 **App Sharing** (v2.3.3) - WhatsApp, Telegram, cloud apps, local storage
🖨️ **PDF Rasterization** (v2.3.3+4) - Convert PDF pages to images (PNG/JPEG)
📄 **Enhanced Sharing** (v2.3.3+4) - Share PDF via system share sheet with share_plus
💾 **Save to File** (v2.3.3+4) - Save PDF to documents or custom directory
🔍 **Barcode Validation** (v2.3.3+4) - Validate barcode data before generation
📊 **Barcode Groups** (v2.3.3+4) - Arrange multiple barcodes in rows, columns, or grids
🏷️ **Batch Barcodes** (v2.3.3+4) - Generate sequences of barcodes with auto-incrementing data
👁️ **Enhanced Preview** (v2.3.3+4) - Print preview with share, save, and settings options
🔀 **PDF Merge/Split** (v2.3.3+5) - Combine or split PDF documents
📄 **Page Extraction** (v2.3.3+5) - Extract specific pages from PDFs
💧 **Watermark Pages** (v2.3.3+5) - Add text watermarks with custom position and opacity
🔄 **Page Rotation** (v2.3.3+5) - Rotate pages by 90, 180, or 270 degrees
📊 **PDF Info** (v2.3.3+5) - Get document metadata and page information
⏰ **Job Scheduling** (v2.3.3+5) - Schedule PDF generation for later execution
📈 **Job Statistics** (v2.3.3+5) - Track generation metrics and success rates
🔗 **Job Chains** (v2.3.3+5) - Chain jobs with dependencies
✅ **Export Validation** (v2.3.3+5) - Validate export configuration before processing
📦 **Export Presets** (v2.3.3+5) - Pre-configured export settings for common use cases
🎨 **Conditional Formatting** (v2.3.3+5) - Excel-like conditional formatting for data grids
🔢 **Grid Calculations** (v2.3.3+5) - Calculate totals, averages, sort and filter grid data
✏️ **Rich Text Engine** (v2.3.3+6) - Complete rewrite with background, strikethrough, superscript/subscript rendering
📝 **Italic Font Support** (v2.3.3+6) - Italic and bold-italic font resolution for rich text
📑 **Bullet Lists** (v2.3.3+6) - Bulleted, numbered (Arabic/Arabic-Indic/alphabetic), and nested lists
📐 **Text Measurer** (v2.3.3+6) - Pre-measure text dimensions before drawing
📋 **Markdown Parser** (v2.3.3+6) - Convert simple markdown to styled text spans
🏷️ **Text Span Factories** (v2.3.3+6) - Currency, badge, label, heading, small span constructors
🔤 **String Extensions** (v2.3.3+6) - Quick span conversion methods on String
📄 **Multi-Paragraph** (v2.3.3+6) - Multi-paragraph component with spacing and indent
✂️ **Text Overflow** (v2.3.3+6) - Max lines with ellipsis or clip overflow
📋 **Enhanced Logger** (v2.3.3+7) - Source location tracking with clickable file:line paths
🔍 **Automatic Source Location** (v2.3.3+7) - StackTrace-based caller detection for precise navigation
⏱️ **Performance Timers** (v2.3.3+7) - Built-in timer support to measure operation durations
🎯 **Library-Wide Logging** (v2.3.3+7) - Logger integrated across all modules (printing, services, components)
⚙️ **Logger Configuration** (v2.3.3+7) - Enable/disable logging, filter by level, toggle timestamps and locations
📦 **InfoBox Overhaul** (v2.3.3+8) - Complete rewrite with bug fixes, icon rendering, RTL alignment, actual bounds
🎨 **Status Presets** (v2.3.3+8) - Info, warning, success, error style presets for info boxes
🏢 **Company/Contact Factories** (v2.3.3+8) - Pre-configured info box factories for common use cases
⚖️ **Equal Height** (v2.3.3+8) - DualInfoBox equalHeight synchronization between paired boxes
📐 **Section Styles** (v2.3.3+8) - New GeniusPdfSectionStyle class with corporate, minimal, card, saudi presets
📍 **Position Engine** (v2.4.0) - Precise Y-position tracking with independent `_currentY` tracker
📄 **Auto Page-Break** (v2.4.0) - Automatic page creation when content exceeds available space
🖼️ **Image Alignment** (v2.4.0) - Direction-aware image alignment (start/center/end) with position advancement
📏 **Builder Utilities** (v2.4.0) - `remainingHeight`, `canFit()`, `contentBounds`, `resetY()`, `pageCount`
🔧 **Enhanced Footer** (v2.4.0) - Configurable `userLabel`, `pageNumberFormat`, dynamic positioning
📊 **Grid Integration** (v2.5.0) - `addGrid()` draws data grids at current position with auto Y-advancement
📋 **Summary Integration** (v2.5.0) - `addSummary()` draws summary sections with auto Y-advancement
🔗 **Grid+Summary Combo** (v2.5.0) - `addGridWithSummary()` combines grid and summary in one call
📈 **Report Summary** (v2.5.0) - `addReportSummary()` for overall report totals aggregating multiple grids
➖ **Section Divider** (v2.5.0) - `addSectionDivider()` visual divider with optional centered title
📊 **Builder Bar Chart** (v2.6.0) - `addBarChart()` draws bar charts at current position with auto page-break
📈 **Builder Line Chart** (v2.6.0) - `addLineChart()` draws line charts with auto Y-advancement
🥧 **Builder Pie Chart** (v2.6.0) - `addPieChart()` draws pie charts at current position
📉 **Builder Area Chart** (v2.6.0) - `addAreaChart()` draws area charts with auto page-break
📱 **Builder QR Code** (v2.7.0) - `addQRCode()` draws QR codes with alignment at current position
🖼️ **Image Attachment** (v2.7.0) - `addImageAttachment()` labeled inline image with auto-scaling
📄 **Image Page** (v2.7.0) - `addImagePage()` full-page image attachment for scanned documents
📎 **Batch Attachments** (v2.7.0) - `addAttachments()` batch-add multiple images each on its own page
📝 **Builder Rich Text** (v2.8.0) - `addRichText()` draws styled text (bold, links, colors) with auto Y-advancement
📦 **Builder Info Box** (v2.8.0) - `addInfoBox()` draws info boxes with labeled values at current position
🏢 **Builder Report Header** (v2.8.0) - `addReportHeader()` professional headers with company info
📐 **Two-Column Layout** (v2.8.0) - `addTwoColumns()` flexible two-column layout with callbacks
🎭 **Page Templates** (v2.8.0) - `setPageTemplate()` stamps, watermarks, and template elements
🔗 **Report Composer** (v2.9.0) - `GeniusPdfReportComposer` fluent API for chainable report building without subclassing

---

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  genius_link_pdf_generator:
    path: ../packages/genius_link_pdf_generator
```

Then import:

```dart
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';
```

---

## Quick Start

### 1. Create Configuration (v2.3.3+1 - Instance Pattern)

Each document builder requires its own `GeniusPdfConfig` instance. There is no global singleton.

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load font data first
  final fontData = await rootBundle.load('assets/fonts/din/din.ttf');
  final fontBytes = fontData.buffer.asUint8List();

  // Create config instance with assets and logger
  final config = await GeniusPdfConfig.create(
    // PDF Configuration
    baseFontBytes: fontBytes,
    baseFontSize: 12,
    textDirection: TextDirection.rtl,
    pageSize: GeniusPdfPageSize.a4,
    orientation: PdfPageOrientation.portrait,

    // Assets Configuration (fonts and branding images)
    assetPaths: GeniusPdfAssetPaths(
      fontPaths: GeniusPdfFontPaths(
        primaryFont: 'assets/fonts/din/din.ttf',
        secondaryFont: 'assets/fonts/hacen/hacenTunisia.ttf',
      ),
      brandingPaths: GeniusPdfBrandingPaths(
        headerImage: 'assets/images/header.png',
        logo: 'assets/images/logo.png',
      ),
    ),

    // Logger Configuration (global service)
    loggerConfig: GeniusPdfLoggerConfig(
      enabled: true,
      useConsole: true,
      minLevel: GeniusLogLevel.info,
    ),
  );

  // Pass config to your app or store in a provider
  runApp(MyApp(pdfConfig: config));
}

// Use the config instance
class MyApp extends StatelessWidget {
  final GeniusPdfConfig pdfConfig;
  const MyApp({required this.pdfConfig});

  // Access assets through config instance
  void generatePdf() {
    final primaryFont = pdfConfig.assets.primaryFont;
    final builder = MyDocumentBuilder(pdfConfig);
    final pdfBytes = builder.generate();

    // Logger is a global static service
    GeniusPdfConfig.logger.info('PDF generation completed');
  }
}
```

### Alternative: Synchronous Creation

```dart
// When assets are already loaded
final config = GeniusPdfConfig.createSync(
  baseFontBytes: myFontBytes,
  baseFontSize: 12,
  textDirection: TextDirection.rtl,
  assetData: GeniusPdfAssetsData(
    primaryFont: myFontBytes,
  ),
);
```

### Alternative: Direct Constructor

```dart
// For simple cases without asset loading
final config = GeniusPdfConfig(
  baseFontBytes: fontBytes,
  baseFontSize: 12,
  textDirection: TextDirection.rtl,
  configAssets: myPreloadedAssets,
);
```

### 2. Create a Document Builder

```dart
class InvoiceDocument extends GeniusPdfDocumentBuilder {
  final String invoiceNumber;
  final double total;

  InvoiceDocument({
    required GeniusPdfConfig config,
    required this.invoiceNumber,
    required this.total,
  }) : super(config);

  @override
  void build() {
    addHeader(title: 'Invoice #$invoiceNumber');
    addLine('Total: \$${total.toStringAsFixed(2)}');
    addFooter(showPageNumber: true);
  }
}
```

### Position Tracking & Auto Page-Break (v2.4.0)

The builder now tracks the vertical position (`currentY`) automatically. Every draw method advances the position, and content that exceeds the page triggers an automatic page-break.

```dart
class MyReport extends GeniusPdfDocumentBuilder {
  MyReport({required GeniusPdfConfig config}) : super(config);

  @override
  void build() {
    addHeader(title: 'Position Demo');
    addLine('Position after header: ${currentY.toStringAsFixed(1)}');

    // Check remaining space before drawing
    if (canFit(200)) {
      addLine('Enough room for a large block');
    }

    // Auto page-break: if 50 lines overflow, new pages are created
    for (var i = 0; i < 50; i++) {
      addLine('Line $i', topMargin: 4);
    }

    // Image with alignment (direction-aware: start/center/end)
    addImage(myImage, alignment: GeniusPdfImageAlignment.center, spacing: 10);

    // Horizontal line now advances position
    addHorizontalLine(spacing: 8);

    // Enhanced footer with configurable label
    addFooter(
      userName: 'Admin',
      userLabel: 'Printed by: ',
      showPageNumber: true,
      pageNumberFormat: 'Page {0} of {1}',
    );
  }
}
```

**Key APIs:**

| API | Description |
|-----|-------------|
| `currentY` | Current vertical position on the page |
| `remainingHeight` | Space left before page bottom |
| `canFit(height)` | Check if content fits on current page |
| `contentBounds` | Rect from current position to page bottom |
| `pageCount` | Total pages created so far |
| `resetY([y])` | Reset position (e.g., after absolute drawing) |
| `isRTL` / `isLTR` | Text direction convenience getters |

### Grid & Summary Integration (v2.5.0)

The builder now provides methods to draw data grids and summaries directly, with automatic position tracking. You can also combine multiple grids with per-grid summaries and an overall report summary.

```dart
class SalesReport extends GeniusPdfDocumentBuilder {
  SalesReport({required GeniusPdfConfig config}) : super(config);

  @override
  void build() {
    addHeader(title: 'Sales Report');

    // Section divider with centered title
    addSectionDivider(title: 'Q1 Sales', spacing: 10);

    // Draw grid + summary in one call
    addGridWithSummary(
      grid: salesGrid,
      summary: salesSummary,
      gridSpacing: 5,
      summarySpacing: 10,
    );

    // Another section
    addSectionDivider(title: 'Q2 Sales', spacing: 15);
    addGrid(q2Grid, spacing: 5);
    addSummary(q2Summary, spacing: 10);

    // Overall report summary
    addReportSummary(
      summary: overallSummary,
      title: 'Annual Summary',
      titleAr: 'الملخص السنوي',
      spacing: 20,
    );

    addFooter(showPageNumber: true);
  }
}
```

**Grid & Summary APIs:**

| API | Description |
|-----|-------------|
| `addGrid(grid, {spacing})` | Draw data grid at current position |
| `addSummary(summary, {spacing})` | Draw summary section at current position |
| `addGridWithSummary(grid, summary)` | Combined grid + summary in one call |
| `addReportSummary(summary, {title})` | Overall report summary with heading |
| `addSectionDivider({title, spacing})` | Visual divider with optional title |

### Report Composer — Fluent API (v2.9.0)

The `GeniusPdfReportComposer` lets you build PDF reports without subclassing, using a chainable fluent API:

```dart
final composer = GeniusPdfReportComposer(config: myConfig);
final bytes = composer
    .withHeader(title: 'Sales Report')
    .withFooter(userName: 'Admin', showPageNumber: true)
    .section('Q1 Sales')
    .text('Revenue summary for Q1 2026.')
    .gridWithSummary(dataGrid: grid, summarySection: summary)
    .section('Charts')
    .barChart(salesChart, height: 200)
    .page()
    .section('Attachments')
    .qrCode(invoiceQR, alignment: GeniusPdfImageAlignment.center)
    .imagePage(scannedInvoice, title: 'Supplier Invoice')
    .buildPdf();
composer.dispose();
```

### 3. Generate and Display

```dart
final service = GeniusPdfService();

await service.generateAndOpen(
  builder: InvoiceDocument(
    config: GeniusPdfConfig(
      baseFontBytes: fontBytes, // load once and reuse
      baseFontSize: 12,
      textDirection: TextDirection.rtl,
    ),
    invoiceNumber: 'INV-001',
    total: 150.00,
  ),
  fileName: 'invoice_001',
);
```

---

## Configuration Model

There is **no global singleton** for `GeniusPdfConfig`. Each document builder receives its own config instance.

### Font Properties (Bytes-Based)

| Property | Description | Fallback |
|----------|-------------|----------|
| `baseFontBytes` | Primary font bytes for all text (must support Arabic) | Required |
| `boldFontBytes` | Bold font bytes for headers/emphasis | Falls back to `baseFontBytes` |
| `headerFontBytes` | Font bytes for large titles | Falls back to `boldFontBytes` or `baseFontBytes` |
| `smallFontBytes` | Smaller font bytes for captions/footnotes | Falls back to `baseFontBytes` |
| `baseFontSize` | Base font size | Theme body size |
| `boldFontSize` | Bold font size | Theme body size |
| `headerFontSize` | Header font size | Theme heading size |
| `smallFontSize` | Small font size | Theme small size |

### Component Configuration

All components (charts, barcodes, info boxes, headers, summaries, watermarks, etc.) **use the config’s fonts and RTL settings**. Per-component overrides for `baseFont`, `boldFont`, and `isRTL` were removed.

---

## Print Theme System

The library includes a comprehensive theming system that allows you to style all PDF components consistently.

### Using Preset Themes

```dart
// Available preset themes
final defaultTheme = GeniusPdfPrintTheme.defaults();   // Professional default
final corporateTheme = GeniusPdfPrintTheme.corporate(); // Blue corporate
final minimalTheme = GeniusPdfPrintTheme.minimal();     // Clean minimal
final saudiTheme = GeniusPdfPrintTheme.saudi();         // Saudi green
final invoiceTheme = GeniusPdfPrintTheme.invoice();     // Invoice optimized

// Apply theme to config
final config = GeniusPdfConfig(
  baseFontBytes: myFontBytes,
  baseFontSize: 12,
  printTheme: corporateTheme,
);
```

### Custom Theme

```dart
final customTheme = GeniusPdfPrintTheme(
  colors: GeniusPdfColorSchemeTheme(
    primary: PdfColor(0, 100, 180),
    secondary: PdfColor(100, 100, 100),
    accent: PdfColor(255, 152, 0),
    text: PdfColor(33, 33, 33),
    background: PdfColor(255, 255, 255),
    border: PdfColor(200, 200, 200),
    success: PdfColor(76, 175, 80),
    warning: PdfColor(255, 193, 7),
    error: PdfColor(244, 67, 54),
  ),
  typography: GeniusPdfTypographyTheme(
    titleSize: 18,
    subtitleSize: 14,
    headerSize: 12,
    bodySize: 10,
    captionSize: 8,
    smallSize: 7,
  ),
  spacing: GeniusPdfSpacingTheme(
    xs: 2, sm: 4, md: 8, lg: 16, xl: 24, xxl: 32,
  ),
  borders: GeniusPdfBorderTheme(
    width: 0.5,
    color: PdfColor(200, 200, 200),
    radius: 4,
  ),
  // Component-specific themes
  grid: GeniusPdfGridTheme(...),
  summary: GeniusPdfSummaryTheme(...),
  infoBox: GeniusPdfInfoBoxTheme(...),
  header: GeniusPdfHeaderTheme(...),
  section: GeniusPdfSectionTheme(...),
);
```

---

## Components

### GeniusPdfDataGrid

Create professional data tables with RTL support:

```dart
final grid = GeniusPdfDataGrid(
  columns: [
    GeniusPdfGridColumn(id: 'name', title: 'Name', titleAr: 'الاسم'),
    GeniusPdfGridColumn.currency(id: 'amount', title: 'Amount', titleAr: 'المبلغ'),
  ],
  rows: [
    GeniusPdfGridRow(cells: {'name': 'Item 1', 'amount': 100.00}),
    GeniusPdfGridRow(cells: {'name': 'Item 2', 'amount': 200.00}),
    GeniusPdfGridRow.total({'name': 'Total', 'amount': 300.00}),
  ],
  style: GeniusPdfGridStyle.classic(),
);

grid.draw(page: page, bounds: bounds);
```

**Column Types:**

- `GeniusPdfGridColumn()` - Standard column
- `GeniusPdfGridColumn.numeric()` - Right-aligned numeric
- `GeniusPdfGridColumn.currency()` - Currency with formatting
- `GeniusPdfGridColumn.index()` - Row number/index column
- `GeniusPdfGridColumn.date()` - Date formatted column
- `GeniusPdfGridColumn.percentage()` - Percentage column
- `GeniusPdfGridColumn.quantity()` - Quantity column
- `GeniusPdfGridColumn.description()` - Wide column with text wrap
- `GeniusPdfGridColumn.action()` - Action/status column

**Row Types:**

- `GeniusPdfGridRow()` - Standard row
- `GeniusPdfGridRow.total()` - Total row with bold styling
- `GeniusPdfGridRow.subtotal()` - Subtotal row
- `GeniusPdfGridRow.separator()` - Visual separator
- `GeniusPdfGridRow.spacer()` - Empty spacer row

**Grid Styles:**

- `GeniusPdfGridStyle.classic()` - Traditional bordered
- `GeniusPdfGridStyle.modern()` - Minimal with accent borders
- `GeniusPdfGridStyle.corporate()` - Corporate blue style
- `GeniusPdfGridStyle.minimal()` - Minimal borders
- `GeniusPdfGridStyle.saudi()` - Saudi green theme
- `GeniusPdfGridStyle.invoice()` - Optimized for invoices

**Advanced Column Features:**

```dart
GeniusPdfGridColumn(
  id: 'price',
  title: 'Price',
  titleAr: 'السعر',
  subtitle: 'per unit',      // Column subtitle
  subtitleAr: 'للوحدة',
  wrapText: true,            // Enable text wrapping
  maxLines: 2,               // Max lines when wrapping
  prefix: '\$',              // Value prefix
  suffix: ' USD',            // Value suffix
  valueFormatter: (val) => formatCurrency(val), // Custom formatter
)
```

### GeniusPdfRichText

Create styled text with multiple colors and links:

```dart
final richText = GeniusPdfRichTextBuilder()
  .text('Invoice ')
  .bold('#INV-2024-001', color: Colors.blue)
  .text(' - Total: ')
  .positive('34,615.00 SAR')
  .build();

richText.draw(page: page, bounds: bounds);
```

**Available Methods:**

- `.text()` - Plain text
- `.bold()` - Bold text with optional color
- `.colored()` - Colored text
- `.link()` - Clickable link
- `.positive()` - Green (positive amount)
- `.negative()` - Red (negative amount)

**Enhanced Text Spans:**

```dart
// Currency formatting
GeniusPdfTextSpan.currency(
  amount: 1500.50,
  currency: 'SAR',
  color: Colors.green,
)

// Percentage formatting
GeniusPdfTextSpan.percentage(
  value: 15.5,
  decimals: 1,
)

// Date formatting
GeniusPdfTextSpan.date(
  date: DateTime.now(),
  format: 'yyyy-MM-dd',
)

// Highlighted text
GeniusPdfTextSpan.highlight(
  text: 'Important',
  backgroundColor: Colors.yellow,
)

// Code/monospace text
GeniusPdfTextSpan.code(
  text: 'console.log()',
)

// Superscript and subscript
GeniusPdfTextSpan.superscript(text: '2')  // x²
GeniusPdfTextSpan.subscript(text: '2')    // H₂O
```

**Text Decorations:**

```dart
GeniusPdfTextSpan(
  text: 'Strikethrough',
  decoration: GeniusPdfTextDecoration.strikethrough,
  decorationColor: Colors.red,
  decorationStyle: GeniusPdfTextDecorationStyle.solid,
)
```

### GeniusPdfInfoBox

Create information boxes for grouped content:

```dart
final box = GeniusPdfInfoBox(
  title: 'Customer Details',
  titleAr: 'تفاصيل العميل',
  items: [
    GeniusPdfLabeledValue(label: 'Name', labelAr: 'الاسم', value: 'John Doe'),
    GeniusPdfLabeledValue(label: 'Phone', labelAr: 'الهاتف', value: '+966 12 345 6789'),
  ],
  style: GeniusPdfInfoBoxStyle.headerContent(),
);

box.draw(page: page, bounds: bounds);
```

**Box Styles:**

- `GeniusPdfInfoBoxStyle()` - Default style
- `GeniusPdfInfoBoxStyle.card()` - Card with border
- `GeniusPdfInfoBoxStyle.highlighted()` - Left border accent
- `GeniusPdfInfoBoxStyle.headerContent()` - Header with divider
- `GeniusPdfInfoBoxStyle.corporate()` - Corporate blue style
- `GeniusPdfInfoBoxStyle.minimal()` - Clean minimal style
- `GeniusPdfInfoBoxStyle.saudi()` - Saudi green style
- `GeniusPdfInfoBoxStyle.invoice()` - Invoice optimized
- `GeniusPdfInfoBoxStyle.compact()` - Compact spacing
- `GeniusPdfInfoBoxStyle.modern()` - Modern with shadows

**Address Box Factory:**

```dart
final addressBox = GeniusPdfInfoBox.address(
  title: 'Billing Address',
  titleAr: 'عنوان الفواتير',
  items: [
    GeniusPdfLabeledValue(label: 'Street', value: '123 Main St'),
    GeniusPdfLabeledValue(label: 'City', value: 'Riyadh'),
    GeniusPdfLabeledValue(label: 'Country', value: 'Saudi Arabia'),
  ],
  style: GeniusPdfInfoBoxStyle.modern(),
);
```

**Multi-Column Layout:**

```dart
final box = GeniusPdfInfoBox(
  title: 'Details',
  items: myItems,
  columns: 2,              // 2-column layout
  maxItemsPerColumn: 5,    // Max items per column
  alignment: GeniusPdfInfoBoxAlignment.stretch,
);
```

**Dual Info Box Layouts:**

```dart
// Horizontal layout (side by side)
GeniusPdfDualInfoBox(
  leftBox: leftInfo,
  rightBox: rightInfo,
  layout: GeniusPdfDualInfoBoxLayout.horizontal,
  spacing: 20,
);

// Vertical layout (stacked)
GeniusPdfDualInfoBox(
  leftBox: topInfo,
  rightBox: bottomInfo,
  layout: GeniusPdfDualInfoBoxLayout.vertical,
);
```

### GeniusPdfReportHeader

Create professional bilingual report headers:

```dart
final header = GeniusPdfReportHeader(
  title: 'Trial Balance',
  titleAr: 'ميزان المراجعة',
  subtitle: 'As of December 31, 2025',
  subtitleAr: 'كما في 31 ديسمبر 2025',
  company: GeniusPdfCompanyInfo(
    name: 'Integrated Solutions Co.',
    nameAr: 'شركة الحلول المتكاملة',
    logo: logoImage,
    vatNumber: '300012345678903',
  ),
  style: GeniusPdfReportHeaderStyle.modern(),
  layout: GeniusPdfReportHeaderLayout.standard,
);

header.draw(page: page, bounds: bounds);
```

**Header Layouts:**

- `GeniusPdfReportHeaderLayout.standard` - Logo + company + centered title
- `GeniusPdfReportHeaderLayout.compact` - Side-by-side layout
- `GeniusPdfReportHeaderLayout.centered` - Everything centered
- `GeniusPdfReportHeaderLayout.invoice` - Invoice style

**Header Styles:**

- `GeniusPdfReportHeaderStyle.classic()` - Classic professional
- `GeniusPdfReportHeaderStyle.modern()` - Modern with accent line
- `GeniusPdfReportHeaderStyle.corporate()` - Corporate blue
- `GeniusPdfReportHeaderStyle.minimal()` - Clean minimal
- `GeniusPdfReportHeaderStyle.saudi()` - Saudi green
- `GeniusPdfReportHeaderStyle.invoice()` - Invoice optimized
- `GeniusPdfReportHeaderStyle.compact()` - Space-saving
- `GeniusPdfReportHeaderStyle.centered()` - Center-aligned

**Enhanced Company Info:**

```dart
GeniusPdfCompanyInfo(
  name: 'Integrated Solutions Co.',
  nameAr: 'شركة الحلول المتكاملة',
  logo: logoImage,
  vatNumber: '300012345678903',
  // New fields
  address: '123 King Fahd Road',
  addressAr: '123 طريق الملك فهد',
  city: 'Riyadh',
  cityAr: 'الرياض',
  country: 'Saudi Arabia',
  countryAr: 'المملكة العربية السعودية',
  postalCode: '12345',
  phone: '+966 11 123 4567',
  fax: '+966 11 123 4568',
  email: 'info@company.com',
  website: 'www.company.com',
  commercialRegistration: '1010123456',
  additionalInfo: {'License': '12345'},
)
```

**Invoice Header Factory:**

```dart
final header = GeniusPdfReportHeader.invoice(
  invoiceNumber: 'INV-2025-001',
  invoiceDate: DateTime.now(),
  company: companyInfo,
  style: GeniusPdfReportHeaderStyle.invoice(),
  bilingualOrder: GeniusPdfBilingualOrder.arabicFirst,
);
```

**Simple Header Factory:**

```dart
final header = GeniusPdfReportHeader.simple(
  title: 'Monthly Report',
  titleAr: 'التقرير الشهري',
  subtitle: 'January 2026',
  subtitleAr: 'يناير 2026',
);
```

**Bilingual Order Control:**

```dart
// Arabic text appears first
GeniusPdfReportHeader(
  title: 'Report',
  titleAr: 'تقرير',
  bilingualOrder: GeniusPdfBilingualOrder.arabicFirst,
);

// English text appears first
GeniusPdfReportHeader(
  title: 'Report',
  titleAr: 'تقرير',
  bilingualOrder: GeniusPdfBilingualOrder.englishFirst,
);
```

### GeniusPdfSummarySection

Create totals and calculations display:

```dart
final summary = GeniusPdfSummarySection(
  items: [
    GeniusPdfSummaryItem.subtotal(
      label: 'Subtotal',
      labelAr: 'الإجمالي قبل الضريبة',
      value: '30,100.00 SAR',
    ),
    GeniusPdfSummaryItem(
      label: 'VAT (15%)',
      labelAr: 'ضريبة القيمة المضافة (15%)',
      value: '4,515.00 SAR',
    ),
    GeniusPdfSummaryItem.total(
      label: 'Total Amount',
      labelAr: 'الإجمالي الكلي',
      value: '34,615.00 SAR',
    ),
  ],
  alignment: GeniusPdfSummaryAlignment.right,
);

summary.draw(page: page, bounds: bounds);
```

**Summary Styles:**

- `GeniusPdfSummaryStyle()` - Default style
- `GeniusPdfSummaryStyle.card()` - Card with background
- `GeniusPdfSummaryStyle.minimal()` - Clean minimal
- `GeniusPdfSummaryStyle.invoice()` - Invoice optimized

**Enhanced Summary Items:**

```dart
GeniusPdfSummaryItem(
  label: 'Subtotal',
  labelAr: 'الإجمالي الفرعي',
  value: '1,000.00',
  prefix: 'SAR ',       // Value prefix
  indent: 1,            // Indentation level
  showLine: true,       // Show separator line
  showBackground: true, // Show background color
)
```

### GeniusPdfSection

Create bordered sections with titles:

```dart
final section = GeniusPdfSection(
  title: 'Payment Details',
  titleAr: 'تفاصيل الدفع',
  children: [...],
  style: GeniusPdfSectionStyle.card(),
);
```

**Section Styles:**

- `GeniusPdfSectionStyle()` - Default style
- `GeniusPdfSectionStyle.card()` - Card with shadow
- `GeniusPdfSectionStyle.panel()` - Panel with header
- `GeniusPdfSectionStyle.outlined()` - Outlined border
- `GeniusPdfSectionStyle.filled()` - Filled background

**Title Position Options:**

```dart
GeniusPdfSectionStyle(
  titlePosition: GeniusPdfSectionTitlePosition.top,     // Above content
  titlePosition: GeniusPdfSectionTitlePosition.left,    // Left side
  titlePosition: GeniusPdfSectionTitlePosition.inside,  // Inside border
  titlePosition: GeniusPdfSectionTitlePosition.floating, // Floating label
)
```

### Additional Components

- **GeniusPdfDualInfoBox** - Two info boxes with flexible layouts
- **GeniusPdfTotalBar** - Highlighted total bar
- **GeniusPdfSignatureArea** - Signature line with date
- **GeniusPdfQRCode** - QR code display for invoices

---

## Charts & Graphs

### GeniusPdfBarChart

Create bar charts with multiple types and styles:

```dart
final barChart = GeniusPdfBarChart(
  title: 'Monthly Sales',
  titleAr: 'المبيعات الشهرية',
  series: [
    GeniusChartSeries(
      name: 'Sales',
      nameAr: 'المبيعات',
      color: Colors.blue,
      dataPoints: [
        GeniusChartDataPoint(label: 'Jan', labelAr: 'يناير', value: 12000),
        GeniusChartDataPoint(label: 'Feb', labelAr: 'فبراير', value: 15000),
        GeniusChartDataPoint(label: 'Mar', labelAr: 'مارس', value: 18000),
        GeniusChartDataPoint(label: 'Apr', labelAr: 'أبريل', value: 14000),
      ],
    ),
  ],
  settings: GeniusBarChartSettings(
    type: GeniusBarChartType.vertical,
    barWidth: 30,
    showValues: true,
    cornerRadius: 4,
  ),
  style: GeniusChartStyle.modern(),
  height: 250,
);

barChart.draw(page, bounds);
```

**Bar Chart Types:**

- `GeniusBarChartType.vertical` - Standard vertical bars
- `GeniusBarChartType.horizontal` - Horizontal bars
- `GeniusBarChartType.stacked` - Stacked bars
- `GeniusBarChartType.grouped` - Grouped bars for multiple series

### GeniusPdfLineChart

Create line charts with different line styles:

```dart
final lineChart = GeniusPdfLineChart(
  title: 'Revenue Trend',
  titleAr: 'اتجاه الإيرادات',
  series: [
    GeniusChartSeries(
      name: '2024',
      nameAr: '2024',
      color: Colors.blue,
      dataPoints: [
        GeniusChartDataPoint(label: 'Q1', value: 50000),
        GeniusChartDataPoint(label: 'Q2', value: 65000),
        GeniusChartDataPoint(label: 'Q3', value: 72000),
        GeniusChartDataPoint(label: 'Q4', value: 85000),
      ],
    ),
    GeniusChartSeries(
      name: '2025',
      nameAr: '2025',
      color: Colors.green,
      dataPoints: [
        GeniusChartDataPoint(label: 'Q1', value: 60000),
        GeniusChartDataPoint(label: 'Q2', value: 78000),
        GeniusChartDataPoint(label: 'Q3', value: 90000),
        GeniusChartDataPoint(label: 'Q4', value: 105000),
      ],
    ),
  ],
  settings: GeniusLineChartSettings(
    type: GeniusLineChartType.curved,
    showPoints: true,
    fillArea: true,
    fillOpacity: 0.2,
  ),
  height: 250,
);

lineChart.draw(page, bounds);
```

**Line Chart Types:**

- `GeniusLineChartType.straight` - Straight line segments
- `GeniusLineChartType.curved` - Smooth curved lines
- `GeniusLineChartType.stepped` - Stepped/staircase lines

### GeniusPdfPieChart

Create pie and donut charts:

```dart
final pieChart = GeniusPdfPieChart(
  title: 'Expense Distribution',
  titleAr: 'توزيع المصروفات',
  dataPoints: [
    GeniusChartDataPoint(label: 'Salaries', labelAr: 'الرواتب', value: 45000),
    GeniusChartDataPoint(label: 'Rent', labelAr: 'الإيجار', value: 15000),
    GeniusChartDataPoint(label: 'Utilities', labelAr: 'المرافق', value: 5000),
    GeniusChartDataPoint(label: 'Marketing', labelAr: 'التسويق', value: 12000),
    GeniusChartDataPoint(label: 'Other', labelAr: 'أخرى', value: 8000),
  ],
  settings: GeniusPieChartSettings(
    showLabels: true,
    showPercentages: true,
    labelPosition: GeniusPieLabelPosition.outside,
  ),
  colors: GeniusChartColors.defaultPalette,
  legend: GeniusChartLegend(
    show: true,
    position: GeniusChartLegendPosition.right,
  ),
  height: 250,
);

pieChart.draw(page, bounds);
```

**Donut Chart:**

```dart
final donutChart = GeniusPdfPieChart(
  // ... same as above
  settings: GeniusPieChartSettings.donut(), // Creates a donut chart
);
```

### GeniusPdfAreaChart

Create area charts (overlapping or stacked):

```dart
final areaChart = GeniusPdfAreaChart(
  title: 'Website Traffic',
  titleAr: 'حركة الموقع',
  series: [
    GeniusChartSeries(
      name: 'Desktop',
      nameAr: 'سطح المكتب',
      color: Colors.blue,
      dataPoints: [
        GeniusChartDataPoint(label: 'Mon', value: 1200),
        GeniusChartDataPoint(label: 'Tue', value: 1400),
        GeniusChartDataPoint(label: 'Wed', value: 1100),
        GeniusChartDataPoint(label: 'Thu', value: 1600),
        GeniusChartDataPoint(label: 'Fri', value: 1800),
      ],
    ),
    GeniusChartSeries(
      name: 'Mobile',
      nameAr: 'الجوال',
      color: Colors.green,
      dataPoints: [
        GeniusChartDataPoint(label: 'Mon', value: 800),
        GeniusChartDataPoint(label: 'Tue', value: 950),
        GeniusChartDataPoint(label: 'Wed', value: 700),
        GeniusChartDataPoint(label: 'Thu', value: 1100),
        GeniusChartDataPoint(label: 'Fri', value: 1300),
      ],
    ),
  ],
  settings: GeniusAreaChartSettings(
    stacked: false,
    fillOpacity: 0.4,
    showPoints: true,
  ),
  height: 250,
);

areaChart.draw(page, bounds);
```

### Chart Styling

**Pre-defined Styles:**

```dart
GeniusChartStyle.classic()  // White background, standard colors
GeniusChartStyle.modern()   // Light gray background, modern look
GeniusChartStyle.dark()     // Dark background for contrast
```

**Color Palettes:**

```dart
GeniusChartColors.defaultPalette  // Standard colorful palette
GeniusChartColors.bluePalette     // Shades of blue
GeniusChartColors.greenPalette    // Shades of green
GeniusChartColors.warmPalette     // Warm colors (red, orange, yellow)
```

**Axis Configuration:**

```dart
GeniusChartAxis(
  title: 'Revenue (SAR)',
  titleAr: 'الإيرادات (ريال)',
  min: 0,
  max: 100000,
  divisions: 5,
  showGridLines: true,
  valueFormatter: (value) => '${(value / 1000).toStringAsFixed(0)}K',
)
```

---

## Watermarks

### Text Watermark

Add text watermarks to your documents:

```dart
// Using pre-built templates
document.addWatermark(GeniusPdfWatermark.confidential());
document.addWatermark(GeniusPdfWatermark.draft());
document.addWatermark(GeniusPdfWatermark.copy());

// Custom text watermark
final watermark = GeniusPdfWatermark.text(GeniusTextWatermarkSettings(
  text: 'SAMPLE',
  fontSize: 60,
  color: Colors.red,
  opacity: 0.2,
  rotation: -45,
  position: GeniusWatermarkPosition.center,
));
watermark.applyToDocument(document);
```

### Diagonal Watermark

Add diagonal watermarks across pages:

```dart
final watermark = GeniusPdfWatermark.diagonal(GeniusDiagonalWatermarkSettings(
  text: 'CONFIDENTIAL',
  fontSize: 48,
  color: Colors.red,
  opacity: 0.15,
  isBold: true,
));
watermark.applyToDocument(document);
```

### Tiled Watermark

Create repeating watermark patterns:

```dart
final watermark = GeniusPdfWatermark.tiled(GeniusTiledWatermarkSettings(
  text: 'DRAFT',
  fontSize: 24,
  opacity: 0.1,
  horizontalSpacing: 100,
  verticalSpacing: 80,
  rotation: -30,
));
watermark.applyToDocument(document);

// Pre-built patterns
final denseWatermark = GeniusPdfWatermark.tiled(
  GeniusTiledWatermarkSettings.dense(text: 'COPY'),
);
final sparseWatermark = GeniusPdfWatermark.tiled(
  GeniusTiledWatermarkSettings.sparse(text: 'SAMPLE'),
);
```

### Image Watermark

Add image-based watermarks:

```dart
final watermark = GeniusPdfWatermark.image(GeniusImageWatermarkSettings(
  imageBytes: logoBytes,
  width: 150,
  opacity: 0.2,
  position: GeniusWatermarkPosition.center,
));
watermark.applyToDocument(document);
```

---

## Security & Encryption

### Password Protection

Protect documents with passwords:

```dart
// Simple password protection
document.protectWithPassword(password: 'secret123');

// With custom permissions
document.protectWithPassword(
  password: 'secret123',
  permissions: GeniusPdfPermissions.printOnly(),
);

// Using security settings
GeniusPdfSecurityService.applySecurity(
  document,
  GeniusPdfSecuritySettings(
    userPassword: 'user123',
    ownerPassword: 'owner456',
    encryptionLevel: GeniusPdfEncryptionLevel.aes256,
    permissions: GeniusPdfPermissions.readOnly(),
  ),
);
```

### Pre-built Security Configurations

```dart
// Password protected with all permissions
GeniusPdfSecuritySettings.passwordProtected(password: 'secret');

// Read-only (no copying, no modifying)
GeniusPdfSecuritySettings.readOnly(ownerPassword: 'admin');

// Full protection (no permissions)
GeniusPdfSecuritySettings.fullProtection(
  userPassword: 'user',
  ownerPassword: 'admin',
);

// Print only
GeniusPdfSecuritySettings.printOnly(ownerPassword: 'admin');
```

### Permission Controls

```dart
// All permissions
GeniusPdfPermissions.all()

// No permissions
GeniusPdfPermissions.none()

// Custom permissions
GeniusPdfPermissions(
  allowPrinting: true,
  allowHighQualityPrinting: true,
  allowCopying: false,
  allowModifying: false,
  allowAnnotations: true,
  allowFormFilling: true,
  allowAssembling: false,
  allowAccessibility: true,
)
```

### Encryption Levels

```dart
GeniusPdfEncryptionLevel.bit40    // RC4 40-bit (legacy)
GeniusPdfEncryptionLevel.bit128   // RC4 128-bit
GeniusPdfEncryptionLevel.aes256   // AES 256-bit (recommended)
```

---

## Digital Signatures

### Visual Signature

Add visual signature boxes:

```dart
final signature = GeniusPdfDigitalSignature(
  settings: GeniusDigitalSignatureSettings(
    signerName: 'John Doe',
    reason: 'Document approval',
    location: 'Riyadh, Saudi Arabia',
    appearance: GeniusSignatureAppearance(
      showName: true,
      showDate: true,
      showReason: true,
      showLocation: true,
    ),
  ),
);
signature.addToDocument(document);
```

### Certificate-Based Signature

Add cryptographic signatures with certificates:

```dart
final signature = GeniusPdfDigitalSignature(
  settings: GeniusDigitalSignatureSettings(
    signerName: 'John Doe',
    reason: 'Contract signing',
    location: 'Riyadh',
    certificateBytes: pkcs12Bytes,
    certificatePassword: 'cert_password',
    type: GeniusSignatureType.approval,
    addTimestamp: true,
    timestampServerUrl: 'http://timestamp.server.com',
  ),
);
signature.addToDocument(document);
```

### Verify Signatures

```dart
final result = await document.verifySignatures();

if (result.hasSignature) {
  print('Document is signed');
  print('Valid: ${result.isValid}');
  for (final sig in result.signatures) {
    print('Signed by: ${sig.signerName}');
    print('Date: ${sig.signedDate}');
    print('Reason: ${sig.reason}');
  }
}
```

---

## Report Templates

### Tax Invoice

ZATCA-compliant tax invoice with QR code:

```dart
final invoice = TaxInvoiceTemplate(
  config: pdfConfig,
  company: GeniusPdfCompanyInfo(
    name: 'Integrated Solutions Co.',
    nameAr: 'شركة الحلول المتكاملة',
    vatNumber: '300012345678903',
    address: 'Riyadh, KSA',
  ),
  customer: InvoiceCustomer(
    name: 'Modern Retailers Co.',
    nameAr: 'شركة التجزئة الحديثة',
    vatNumber: '311122334455',
  ),
  invoice: InvoiceData(
    invoiceNumber: 'SINV-2025-1001',
    invoiceDate: DateTime.now(),
    items: [
      InvoiceLineItem(
        itemNumber: 1,
        description: 'Smartphone Model Z',
        descriptionAr: 'هاتف ذكي موديل Z',
        quantity: 5,
        unitPrice: 3200,
      ),
    ],
    taxes: [
      InvoiceTax(name: 'VAT', nameAr: 'ضريبة القيمة المضافة', rate: 15),
    ],
  ),
  qrCode: qrCodeImage,
);

final bytes = invoice.generate();
```

### Trial Balance

```dart
final report = TrialBalanceTemplate(
  config: pdfConfig,
  company: companyInfo,
  data: TrialBalanceData(
    asOfDate: DateTime(2025, 12, 31),
    categories: [
      TrialBalanceCategory(
        name: 'Assets',
        nameAr: 'الأصول',
        entries: [
          TrialBalanceEntry(
            accountName: 'Cash & Cash Equivalents',
            accountNameAr: 'النقد وما في حكمه',
            debit: 2500000,
          ),
          TrialBalanceEntry(
            accountName: 'Accounts Receivable',
            accountNameAr: 'الذمم المدينة',
            debit: 1800000,
          ),
        ],
      ),
      TrialBalanceCategory(
        name: 'Liabilities',
        nameAr: 'الخصوم',
        entries: [...],
      ),
    ],
  ),
);
```

### Customer Statement

```dart
final statement = CustomerStatementTemplate(
  config: pdfConfig,
  company: companyInfo,
  customer: StatementCustomer(
    name: 'Modern Retailers Co.',
    nameAr: 'شركة التجزئة الحديثة',
    accountNumber: 'CUST-1001',
  ),
  data: CustomerStatementData(
    periodFrom: DateTime(2025, 1, 1),
    periodTo: DateTime(2025, 12, 31),
    transactions: [
      StatementTransaction(
        date: DateTime(2025, 1, 15),
        description: 'Sales Invoice',
        descriptionAr: 'فاتورة مبيعات',
        referenceNo: 'SINV-1001',
        debit: 16000,
        balance: 16000,
      ),
    ],
    aging: AgingAnalysis(
      days1to30: 5000,
      days31to60: 10000,
      days61to90: 5000,
    ),
  ),
);
```

### Inventory Report

```dart
final report = InventoryReportTemplate(
  config: pdfConfig,
  company: companyInfo,
  data: InventoryReportData(
    asOfDate: DateTime.now(),
    categories: [
      InventoryCategory(
        name: 'Electronics',
        nameAr: 'الإلكترونيات',
        items: [
          InventoryItem(
            itemCode: 'ITM-101',
            itemName: 'Smartphone Model Z',
            itemNameAr: 'هاتف ذكي موديل Z',
            warehouse: 'Riyadh Main',
            warehouseAr: 'الرياض الرئيسي',
            quantityOnHand: 150,
            averageCost: 2500,
          ),
        ],
      ),
    ],
  ),
);
```

---

## Financial Templates (v1.3.0)

### Balance Sheet

```dart
final balanceSheet = BalanceSheetTemplate(
  config: pdfConfig,
  company: companyInfo,
  data: BalanceSheetData(
    reportDate: DateTime.now(),
    assets: BalanceSheetSection(
      title: 'Assets',
      titleAr: 'الأصول',
      items: [
        BalanceSheetItem(
          accountCode: '1100',
          accountName: 'Cash and Bank',
          accountNameAr: 'النقد والبنوك',
          amount: 150000,
        ),
        BalanceSheetItem(
          accountCode: '1200',
          accountName: 'Accounts Receivable',
          accountNameAr: 'المدينون',
          amount: 85000,
        ),
      ],
    ),
    liabilities: BalanceSheetSection(
      title: 'Liabilities',
      titleAr: 'الالتزامات',
      items: [...],
    ),
    equity: BalanceSheetSection(
      title: 'Equity',
      titleAr: 'حقوق الملكية',
      items: [...],
    ),
  ),
);
```

### Income Statement

```dart
final incomeStatement = IncomeStatementTemplate(
  config: pdfConfig,
  company: companyInfo,
  data: IncomeStatementData(
    periodStart: DateTime(2026, 1, 1),
    periodEnd: DateTime(2026, 12, 31),
    revenue: IncomeStatementSection(
      title: 'Revenue',
      titleAr: 'الإيرادات',
      items: [
        IncomeStatementItem(
          accountCode: '4100',
          accountName: 'Sales Revenue',
          accountNameAr: 'إيرادات المبيعات',
          amount: 500000,
        ),
      ],
    ),
    costOfSales: IncomeStatementSection(...),
    operatingExpenses: IncomeStatementSection(...),
    taxExpense: 25000,
  ),
  showPercentages: true,
);
```

### Cash Flow Statement

```dart
final cashFlow = CashFlowTemplate(
  config: pdfConfig,
  company: companyInfo,
  data: CashFlowData(
    periodStart: DateTime(2026, 1, 1),
    periodEnd: DateTime(2026, 12, 31),
    operatingActivities: CashFlowSection(
      type: CashFlowActivityType.operating,
      title: '',
      items: [
        CashFlowItem(description: 'Cash from customers', amount: 480000),
        CashFlowItem(description: 'Cash paid to suppliers', amount: -250000),
      ],
    ),
    investingActivities: CashFlowSection(...),
    financingActivities: CashFlowSection(...),
    beginningCashBalance: 100000,
  ),
);
```

### Budget Report

```dart
final budgetReport = BudgetReportTemplate(
  config: pdfConfig,
  company: companyInfo,
  data: BudgetReportData(
    reportTitle: 'Monthly Budget Report',
    reportTitleAr: 'تقرير الميزانية الشهرية',
    periodStart: DateTime(2026, 1, 1),
    periodEnd: DateTime(2026, 1, 31),
    sections: [
      BudgetSection(
        title: 'Revenue',
        titleAr: 'الإيرادات',
        items: [
          BudgetItem(
            category: 'Product Sales',
            categoryAr: 'مبيعات المنتجات',
            budgetedAmount: 400000,
            actualAmount: 420000,
          ),
        ],
      ),
    ],
  ),
  showVariancePercent: true,
  highlightVariances: true,
);
```

---

## Sales Templates (v1.3.0)

### Quotation

```dart
final quotation = QuotationTemplate(
  config: pdfConfig,
  company: companyInfo,
  customer: QuotationCustomer(
    name: 'ABC Trading',
    nameAr: 'شركة ABC للتجارة',
    company: 'ABC Trading Co.',
    address: 'Jeddah, KSA',
  ),
  quotation: QuotationData(
    quotationNumber: 'QT-2026-0001',
    quotationDate: DateTime.now(),
    validUntil: DateTime.now().add(Duration(days: 30)),
    items: [
      QuotationItem(
        itemNumber: 1,
        description: 'Office Desk',
        descriptionAr: 'مكتب',
        quantity: 5,
        unitPrice: 2500,
      ),
    ],
    taxes: [(name: 'VAT', nameAr: 'ضريبة', rate: 15.0)],
  ),
);
```

### Purchase Order

```dart
final purchaseOrder = PurchaseOrderTemplate(
  config: pdfConfig,
  company: companyInfo,
  vendor: PurchaseOrderVendor(
    name: 'Tech Supplies',
    nameAr: 'مستلزمات التقنية',
    vendorCode: 'VND-001',
    vatNumber: '300098765400001',
  ),
  purchaseOrder: PurchaseOrderData(
    poNumber: 'PO-2026-0042',
    poDate: DateTime.now(),
    status: 'Approved',
    items: [
      PurchaseOrderItem(
        itemNumber: 1,
        productCode: 'LAP-001',
        description: 'Laptop',
        quantity: 10,
        unitPrice: 4500,
      ),
    ],
  ),
);
```

### Delivery Note

```dart
final deliveryNote = DeliveryNoteTemplate(
  config: pdfConfig,
  company: companyInfo,
  recipient: DeliveryRecipient(
    name: 'Ahmed',
    nameAr: 'أحمد',
    company: 'XYZ Corp',
    address: 'Riyadh, KSA',
  ),
  delivery: DeliveryNoteData(
    deliveryNumber: 'DN-2026-0089',
    deliveryDate: DateTime.now(),
    salesOrderRef: 'SO-2026-0156',
    items: [
      DeliveryItem(
        itemNumber: 1,
        description: 'Product A',
        orderedQty: 100,
        deliveredQty: 95,
      ),
    ],
  ),
  showQuantityComparison: true,
);
```

### Credit Note / Debit Note

```dart
final creditNote = CreditNoteTemplate(
  config: pdfConfig,
  company: companyInfo,
  party: NoteParty(
    name: 'Customer ABC',
    nameAr: 'العميل ABC',
    vatNumber: '300011112200001',
  ),
  note: CreditDebitNoteData(
    noteNumber: 'CN-2026-0015',
    noteDate: DateTime.now(),
    noteType: NoteType.credit, // or NoteType.debit
    originalInvoiceNumber: 'INV-2026-0189',
    reason: 'Goods returned',
    reasonAr: 'إرجاع بضاعة',
    items: [
      NoteLineItem(
        itemNumber: 1,
        description: 'Defective Product',
        quantity: 5,
        unitPrice: 500,
        reason: 'Quality issue',
      ),
    ],
  ),
);
```

---

## HR Templates (v1.3.0)

### Payslip

```dart
final payslip = PayslipTemplate(
  config: pdfConfig,
  company: companyInfo,
  employee: PayslipEmployee(
    employeeId: 'EMP-001',
    name: 'Mohammed Al-Ahmed',
    nameAr: 'محمد الأحمد',
    department: 'Engineering',
    designation: 'Senior Developer',
    joiningDate: DateTime(2022, 3, 15),
    bankName: 'Al Rajhi Bank',
    bankAccount: 'SA12345678901234567890',
  ),
  payslip: PayslipData(
    payPeriod: 'January 2026',
    payDate: DateTime(2026, 1, 28),
    workingDays: 22,
    paidDays: 22,
    earnings: [
      EarningsItem(description: 'Basic Salary', descriptionAr: 'الراتب الأساسي', amount: 15000),
      EarningsItem(description: 'Housing', descriptionAr: 'بدل السكن', amount: 3750),
    ],
    deductions: [
      DeductionsItem(description: 'GOSI', descriptionAr: 'التأمينات', amount: 1462.50),
    ],
  ),
);
```

### Employee Report

```dart
final employeeReport = EmployeeReportTemplate(
  config: pdfConfig,
  company: companyInfo,
  data: EmployeeReportData(
    reportTitle: 'Employee Report',
    reportTitleAr: 'تقرير الموظفين',
    reportDate: DateTime.now(),
    showSalary: true,
    employees: [
      EmployeeRecord(
        employeeId: 'EMP-001',
        name: 'Mohammed',
        nameAr: 'محمد',
        department: 'Engineering',
        designation: 'Developer',
        joiningDate: DateTime(2022, 3, 15),
        status: EmployeeStatus.active,
        salary: 21450,
      ),
    ],
  ),
  showDepartmentSummary: true,
);
```

### Attendance Report

```dart
final attendanceReport = AttendanceReportTemplate(
  config: pdfConfig,
  company: companyInfo,
  data: AttendanceReportData(
    reportTitle: 'Attendance Report',
    reportTitleAr: 'تقرير الحضور',
    periodStart: DateTime(2026, 1, 1),
    periodEnd: DateTime(2026, 1, 31),
    employees: [
      AttendanceEmployeeSummary(
        employeeId: 'EMP-001',
        employeeName: 'Mohammed',
        attendance: [
          DailyAttendance(
            date: DateTime(2026, 1, 1),
            status: AttendanceStatus.present,
            checkIn: DateTime(2026, 1, 1, 8, 0),
            checkOut: DateTime(2026, 1, 1, 17, 0),
            workingHours: 8,
          ),
        ],
      ),
    ],
    showDailyDetails: true,
    showOvertime: true,
  ),
);
```

### Leave Report

```dart
final leaveReport = LeaveReportTemplate(
  config: pdfConfig,
  company: companyInfo,
  data: LeaveReportData(
    reportTitle: 'Leave Report',
    reportTitleAr: 'تقرير الإجازات',
    periodStart: DateTime(2026, 1, 1),
    periodEnd: DateTime(2026, 12, 31),
    leaveBalances: [
      LeaveBalance(
        employeeId: 'EMP-001',
        employeeName: 'Mohammed',
        annualEntitlement: 21,
        annualUsed: 5,
        sickUsed: 2,
        carryForward: 3,
      ),
    ],
    leaveRequests: [
      LeaveRecord(
        leaveId: 'LV-001',
        employeeId: 'EMP-001',
        employeeName: 'Mohammed',
        leaveType: LeaveType.annual,
        startDate: DateTime(2026, 2, 15),
        endDate: DateTime(2026, 2, 19),
        status: LeaveStatus.approved,
      ),
    ],
  ),
);
```

---

## Barcodes & QR Codes (v2.3.3+1)

Generate 1D barcodes and 2D QR codes directly in PDF documents with full styling support.

### 1D Barcodes

```dart
// EAN-13 barcode
final barcode = GeniusPdfBarcode.ean13(
  config: pdfConfig,
  data: '5901234123457',
  caption: 'Product EAN-13',
  captionAr: 'رمز المنتج',
);

barcode.draw(page: page, bounds: Rect.fromLTWH(0, 0, 200, 100));

// Code128 barcode
final code128 = GeniusPdfBarcode.code128(
  config: pdfConfig,
  data: 'INV-2026-001',
  caption: 'Invoice Barcode',
  captionAr: 'رمز الفاتورة',
);

// Shipping barcode with preset style
final shipping = GeniusPdfBarcode.shipping(
  config: pdfConfig,
  data: 'SHIP-2026-0089',
  caption: 'Shipping Label',
  captionAr: 'بطاقة الشحن',
);
```

**Supported Barcode Types:**

- `GeniusBarcodeType.ean13` - EAN-13 (retail products)
- `GeniusBarcodeType.ean8` - EAN-8 (small items)
- `GeniusBarcodeType.upcA` - UPC-A (North America)
- `GeniusBarcodeType.code128` - Code 128 (general purpose)
- `GeniusBarcodeType.code39` - Code 39 (alphanumeric)
- `GeniusBarcodeType.itf` - ITF / Interleaved 2 of 5
- `GeniusBarcodeType.qrCode` - QR Code
- `GeniusBarcodeType.dataMatrix` - Data Matrix
- `GeniusBarcodeType.pdf417` - PDF417

**Barcode Styles:**

```dart
GeniusPdfBarcodeStyle.retail()    // Standard retail barcode
GeniusPdfBarcodeStyle.shipping()  // Large shipping label
GeniusPdfBarcodeStyle.compact()   // Small compact barcode
GeniusPdfBarcodeStyle.document()  // Document reference barcode
```

### QR Codes

```dart
// URL QR Code
final urlQR = GeniusPdfQRCodeGenerator.url(
  config: pdfConfig,
  url: 'https://example.com/invoice/123',
  caption: 'Scan for details',
  captionAr: 'امسح للتفاصيل',
);

urlQR.draw(page: page, bounds: Rect.fromLTWH(0, 0, 150, 150));

// ZATCA E-Invoice QR Code (Saudi Arabia)
final zatcaQR = GeniusPdfQRCodeGenerator.zatca(
  config: pdfConfig,
  sellerName: 'Integrated Solutions Co.',
  vatNumber: '300012345678903',
  timestamp: DateTime.now(),
  totalAmount: 1150.00,
  vatAmount: 150.00,
  caption: 'ZATCA QR',
  captionAr: 'رمز هيئة الزكاة',
);

// WiFi QR Code
final wifiQR = GeniusPdfQRCodeGenerator.wifi(
  config: pdfConfig,
  ssid: 'OfficeNetwork',
  password: 'password123',
  encryption: 'WPA',
  caption: 'WiFi Access',
  captionAr: 'شبكة الواي فاي',
);

// vCard QR Code
final vCardQR = GeniusPdfQRCodeGenerator.vCard(
  config: pdfConfig,
  name: 'Mohammed Al-Ahmed',
  phone: '+966 55 123 4567',
  email: 'mohammed@example.com',
  organization: 'Tech Solutions',
  caption: 'Contact Card',
  captionAr: 'بطاقة الاتصال',
);
```

**QR Code Styles:**

```dart
GeniusPdfQRCodeStyle.invoice()   // Invoice-sized QR
GeniusPdfQRCodeStyle.payment()   // Payment QR (large)
GeniusPdfQRCodeStyle.compact()   // Small compact QR
GeniusPdfQRCodeStyle.branded()   // Branded with caption
```

**Error Correction Levels:**

```dart
GeniusQRErrorCorrection.low       // ~7% recovery
GeniusQRErrorCorrection.medium    // ~15% recovery
GeniusQRErrorCorrection.quartile  // ~25% recovery
GeniusQRErrorCorrection.high      // ~30% recovery
```

---

## Multi-Format Export (v1.4.0)

The library supports exporting PDF documents to multiple formats for various use cases.

### Supported Formats

| Format | Extension | Use Case |
|--------|-----------|----------|
| PDF/A | .pdf | Long-term archival |
| PNG | .png | High-quality images |
| JPEG | .jpg | Compressed images |
| HTML | .html | Web viewing |
| Text | .txt | Plain text extraction |

### Export to Image

```dart
final service = GeniusPdfExportService();

// Export to PNG with high quality
final result = await service.export(
  document,
  GeniusExportConfiguration.image(
    format: GeniusExportFormat.png,
    quality: GeniusImageQuality.high, // 300 DPI
  ),
);

if (result is GeniusExportSuccess) {
  print('Exported ${result.pageCount} pages');
  print('Size: ${result.fileSizeFormatted}');

  // Access the image bytes
  final imageBytes = result.data;
}

// Export specific pages
final result = await service.export(
  document,
  GeniusExportConfiguration.image(
    format: GeniusExportFormat.jpeg,
    quality: GeniusImageQuality.medium,
    pageRange: GeniusPageRange(start: 1, end: 5),
    jpegQuality: 85,
  ),
);
```

### Export to HTML

```dart
// Export to HTML with embedded styles
final result = await service.export(
  document,
  GeniusExportConfiguration.html(
    embedImages: true,
    includeStyles: true,
  ),
);

if (result is GeniusExportSuccess) {
  final htmlContent = String.fromCharCodes(result.data);
  // Use the HTML content
}
```

### Export to Text

```dart
// Extract text from PDF
final result = await service.export(
  document,
  GeniusExportConfiguration.text(
    pageRange: GeniusPageRange.single(1), // First page only
  ),
);

// Or use the extension method
final textResult = await document.exportToText();
```

### Export to PDF/A (Archival)

```dart
// Convert to PDF/A for long-term storage
final result = await service.export(
  document,
  GeniusExportConfiguration.pdfA(
    compress: true,
    includeAnnotations: true,
    includeBookmarks: true,
  ),
);
```

### Save to File

```dart
// Export and save directly to file
final result = await service.exportAndSave(
  document,
  GeniusExportConfiguration.image(format: GeniusExportFormat.png),
  '/path/to/output.png',
);

if (result is GeniusExportSuccess) {
  print('Saved to: ${result.filePath}');
}

// Or save to documents directory
final result = await service.exportToDocuments(
  document,
  GeniusExportConfiguration.html(),
  fileName: 'my_report',
);
```

### Batch Export

Export multiple documents efficiently:

```dart
final exporter = GeniusBatchExporter(maxConcurrent: 3);

// Export multiple documents to the same format
final result = await exporter.exportAllToFormat(
  [doc1, doc2, doc3],
  GeniusExportConfiguration.image(format: GeniusExportFormat.png),
  outputDirectory: '/path/to/output',
  baseFileName: 'report',
  onProgress: (progress) {
    print('${progress.percentage}% complete');
    print(progress.status);
  },
);

print('Exported: ${result.successCount}/${result.totalCount}');
print('Duration: ${result.duration.inSeconds}s');
```

### Export One Document to Multiple Formats

```dart
final result = await exporter.exportToMultipleFormats(
  document,
  [GeniusExportFormat.png, GeniusExportFormat.html, GeniusExportFormat.text],
  outputDirectory: '/path/to/output',
  baseFileName: 'my_document',
);
```

### Progress Tracking

```dart
final result = await service.export(
  document,
  config,
  onProgress: (progress) {
    print('Page ${progress.currentPage}/${progress.totalPages}');
    print('${progress.percentage}%');
    print(progress.status); // English
    print(progress.statusAr); // Arabic
  },
);
```

### Extension Methods

```dart
// Quick export using extension methods
final pngResult = await document.exportTo(GeniusExportFormat.png);
final htmlResult = await document.exportToHtml();
final textResult = await document.exportToText();

// Batch export using list extension
final documents = [doc1, doc2, doc3];
final batchResult = await documents.exportAllTo(
  GeniusExportFormat.png,
  quality: GeniusImageQuality.high,
);
```

---

## Template Engine (v1.5.0)

The Template Engine allows you to create dynamic PDF documents from template definitions with variable substitution, conditional rendering, and loops.

### Creating a Template

```dart
// Using TemplateBuilder
final template = TemplateBuilder(
  id: 'invoice-template',
  name: 'Invoice',
  nameAr: 'فاتورة',
)
  .addVariable(TemplateVariable.string('invoiceNumber', required: true))
  .addVariable(TemplateVariable.string('customerName', required: true))
  .addVariable(TemplateVariable.list('items'))
  .addVariable(TemplateVariable.currency('total'))
  .addText('INVOICE', textAr: 'فاتورة', fontSize: 24)
  .addSpacer(20)
  .addVariableElement('invoiceNumber', prefix: 'Invoice #: ')
  .addVariableElement('customerName', prefix: 'Customer: ')
  .addDivider()
  .addTable(
    columns: [
      TableColumn(field: 'name', title: 'Item', titleAr: 'البند'),
      TableColumn(field: 'price', title: 'Price', titleAr: 'السعر'),
    ],
    dataVariable: 'items',
  )
  .addVariableElement('total', prefix: 'Total: ', suffix: ' SAR')
  .build();
```

### Template Definition (JSON)

Templates can be defined in JSON for portability:

```dart
final template = TemplateDefinition.fromJsonString('''
{
  "id": "report-template",
  "name": "Monthly Report",
  "nameAr": "التقرير الشهري",
  "variables": [
    {"name": "title", "type": "string", "required": true},
    {"name": "date", "type": "date"},
    {"name": "data", "type": "list"}
  ],
  "content": [
    {"type": "variable", "variableName": "title", "fontSize": 20, "isBold": true},
    {"type": "spacer", "height": 10},
    {"type": "variable", "variableName": "date", "prefix": "Date: "},
    {"type": "divider"},
    {
      "type": "loop",
      "loop": {"variable": "data", "itemName": "item"},
      "children": [
        {"type": "variable", "variableName": "item.name"}
      ]
    }
  ]
}
''');

// Export to JSON
final json = template.toJsonString(pretty: true);
```

### Rendering Templates

```dart
final engine = PdfTemplateEngine(config: pdfConfig);

// Render with data
final bytes = await engine.render(
  template: template,
  data: {
    'invoiceNumber': 'INV-2026-001',
    'customerName': 'Ahmed Mohamed',
    'items': [
      {'name': 'Product A', 'price': 100},
      {'name': 'Product B', 'price': 200},
    ],
    'total': 300,
  },
  isRtl: true,
  onProgress: (progress) {
    print('Rendering: ${progress.percentage}%');
  },
);
```

### Variable Types

```dart
// String
TemplateVariable.string('name', required: true)

// Number
TemplateVariable.number('quantity', defaultValue: 1)

// Currency
TemplateVariable.currency('amount', currencySymbol: 'SAR')

// Date
TemplateVariable.date('date', format: 'yyyy-MM-dd')

// Boolean
TemplateVariable.boolean('showDetails', defaultValue: true)

// List
TemplateVariable.list('items')
```

### Conditional Rendering

```dart
// Show element only if condition is met
ConditionalElement(
  condition: TemplateCondition.greaterThan('total', 1000),
  thenElements: [
    TextElement(text: 'Large Order Discount Applied!'),
  ],
  elseElements: [
    TextElement(text: 'Standard Order'),
  ],
)

// Condition operators
TemplateCondition.equals('status', 'active')
TemplateCondition.notEquals('type', 'draft')
TemplateCondition.greaterThan('amount', 100)
TemplateCondition.lessThan('quantity', 10)
TemplateCondition.isEmpty('notes')
TemplateCondition.isNotEmpty('items')
TemplateCondition.contains('tags', 'urgent')
```

### Loop Elements

```dart
LoopElement(
  loop: TemplateLoop(
    variable: 'items',
    itemName: 'item',
    indexName: 'idx',
    sortBy: 'name',
    limit: 10,
  ),
  children: [
    RowElement(
      children: [
        VariableElement(variableName: 'idx', suffix: '. '),
        VariableElement(variableName: 'item.name'),
        VariableElement(variableName: 'item.price'),
      ],
      flexValues: [1, 3, 2],
    ),
  ],
  separator: DividerElement(thickness: 0.5),
)
```

### Template Registry

```dart
// Get the singleton registry
final registry = TemplateRegistry.instance;

// Register templates
registry.register(invoiceTemplate);
registry.register(reportTemplate);

// Get template by ID
final template = registry.get('invoice-template');

// Search templates
final results = registry.search('invoice');

// Get by category
final financialTemplates = registry.getByCategory('financial');

// Get by tag
final salesTemplates = registry.getByTag('sales');

// Export/Import
final json = registry.exportToJson();
registry.importFromJson(json);

// Register built-in templates
TemplateLibrary.registerBuiltInTemplates(registry);
```

### Layout Elements

```dart
// Row (horizontal layout)
RowElement(
  children: [child1, child2, child3],
  spacing: 10,
  flexValues: [1, 2, 1], // Proportional widths
)

// Column (vertical layout)
ColumnElement(
  children: [child1, child2],
  spacing: 5,
)

// Container (with styling)
ContainerElement(
  children: [child1, child2],
  style: ElementStyle(
    padding: EdgeInsets.all(10),
    backgroundColor: PdfColor(245, 245, 245),
    borderColor: PdfColor(200, 200, 200),
    borderWidth: 1,
  ),
)
```

---

## V2 Architecture (v2.0.0)

Version 2.0 introduces a new plugin-based architecture with dependency injection, event-driven design, and enhanced APIs.

### Plugin System

Create custom plugins to extend the library:

```dart
// Create a custom plugin
class MyChartPlugin extends GeniusPdfPlugin {
  @override
  String get id => 'my-chart-plugin';

  @override
  String get name => 'Custom Charts';

  @override
  String get version => '1.0.0';

  @override
  List<String> get dependencies => []; // Plugin dependencies

  @override
  int get priority => 10; // Higher = loaded first

  @override
  Future<void> initialize() async {
    // Register custom components, templates, etc.
    print('MyChartPlugin initialized');
  }

  @override
  Future<void> dispose() async {
    // Cleanup resources
  }
}

// Register and use plugins
final manager = GeniusPluginManager.instance;
await manager.register(MyChartPlugin());
await manager.initializeAll();

// Get plugin
final plugin = manager.get<MyChartPlugin>('my-chart-plugin');

// Listen to plugin events
manager.events.listen((event) {
  print('Plugin event: ${event.type} - ${event.pluginId}');
});
```

### Dependency Injection

Manage dependencies with the lightweight DI container:

```dart
final container = GeniusPdfContainer.instance;

// Register singleton
container.registerSingleton<GeniusPdfConfig>(myConfig);

// Register factory (new instance each time)
container.registerFactory<GeniusPdfService>(() => GeniusPdfService());

// Register lazy singleton (created on first access)
container.registerLazySingleton<PdfTemplateEngine>(() => PdfTemplateEngine());

// Register async factory
container.registerAsyncFactory<MyService>(() async => await MyService.create());

// Resolve dependencies
final config = container.get<GeniusPdfConfig>();
final service = container.get<GeniusPdfService>();
final asyncService = await container.getAsync<MyService>();

// Named registrations
container.registerSingleton<GeniusPdfConfig>(configA, name: 'configA');
container.registerSingleton<GeniusPdfConfig>(configB, name: 'configB');
final config = container.get<GeniusPdfConfig>(name: 'configA');

// Use inject shorthand
final config = inject<GeniusPdfConfig>();
final service = await injectAsync<MyService>();

// Use GeniusServiceLocator mixin
class MyClass with GeniusServiceLocator {
  void doSomething() {
    final config = resolve<GeniusPdfConfig>();
  }
}
```

### Event-Driven Architecture

React to document lifecycle events:

```dart
final eventBus = GeniusPdfEventBus.instance;

// Subscribe to specific events
eventBus.on<GeniusDocumentCreatedEvent>().listen((event) {
  print('Document created: ${event.documentId}');
});

eventBus.on<GeniusRenderProgressEvent>().listen((event) {
  print('Rendering: ${event.progress * 100}%');
});

// Register handlers
eventBus.handle<GeniusDocumentSavedEvent>((event) {
  print('Saved to: ${event.filePath}');
});

// Emit events
eventBus.emit(GeniusDocumentCreatedEvent(documentId: 'doc-123', title: 'My Report'));

// Wait for specific event
final savedEvent = await eventBus.waitFor<GeniusDocumentSavedEvent>(
  timeout: Duration(seconds: 30),
);

// Use EventEmitter mixin
class MyDocumentBuilder with GeniusEventEmitter {
  void createDocument() {
    emit(GeniusDocumentCreatedEvent(documentId: 'doc-123'));
  }
}
```

### Enhanced Fluent API

Build PDFs with the new chainable API:

```dart
// Build a PDF with fluent API
final pdf = GeniusPdfBuilder(id: 'my-document')
  .configure((c) => c
    .title('Monthly Report')
    .author('John Doe')
    .pageFormat(PdfPageFormat.a4)
    .rtl(true))
  .addPage((page) => page
    .header('Monthly Sales Report', fontSize: 24)
    .subheader('January 2026')
    .spacer(20)
    .paragraph('This report summarizes the sales performance for January 2026.')
    .divider()
    .table([
      ['Product', 'Quantity', 'Revenue'],
      ['Product A', '150', '15,000 SAR'],
      ['Product B', '200', '20,000 SAR'],
      ['Product C', '75', '7,500 SAR'],
    ])
    .spacer(10)
    .bulletList([
      'Total units sold: 425',
      'Total revenue: 42,500 SAR',
      'Growth vs last month: +15%',
    ])
    .footer('Page 1'))
  .build();

// Build and get bytes directly
final bytes = await GeniusPdfBuilder()
  .metadata(title: 'Invoice', author: 'System')
  .pageFormat(PdfPageFormat.a4)
  .addPage((page) => page
    .header('Invoice #INV-001')
    .paragraph('Thank you for your business.'))
  .buildBytes();

// Multi-page documents
final pdf = GeniusPdfBuilder()
  .addMultiPage((mp) => mp
    .textHeader('Company Report')
    .pageNumberFooter(format: 'Page {page} of {pages}')
    .heading('Executive Summary', level: 0)
    .paragraph('This is the executive summary...')
    .heading('Financial Overview', level: 1)
    .paragraph('Revenue increased by 15%...')
    .build())
  .build();
```

### Smart Caching

Optimize performance with intelligent caching:

```dart
final cache = GeniusPdfCache.instance;

// Set max cache size and strategy
cache.setMaxSize(200);
cache.setStrategy(GeniusCacheStrategy.lru); // LRU, LFU, FIFO, or Priority

// Cache with TTL
cache.set('template_123', compiledTemplate, ttl: Duration(minutes: 5));

// Get cached value
final template = cache.get<CompiledTemplate>('template_123');

// Compute if absent (sync)
final result = cache.getOrSet('expensive_key', () => computeExpensiveValue());

// Compute if absent (async)
final result = await cache.getOrCompute(
  'async_key',
  () async => await fetchFromDatabase(),
  ttl: Duration(hours: 1),
  priority: GeniusCachePriority.high,
);

// Check and remove
if (cache.has('key')) {
  cache.remove('key');
}

// Remove by prefix
cache.removeByPrefix('template_');

// Get statistics
final stats = cache.stats;
print('Active: ${stats.activeEntries}, Fill: ${stats.fillRatio * 100}%');

// Auto cleanup
cache.startAutoCleanup(interval: Duration(minutes: 5));

// Specialized caches
GeniusFontCache.instance.cache('din', fontData);
GeniusImageCache.instance.cache('logo', imageBytes);
GeniusTemplateCache.instance.cache('invoice', compiled, version: 2);

// Object pooling for performance
final pool = GeniusObjectPool<StringBuilder>(
  factory: () => StringBuilder(),
  reset: (sb) => sb.clear(),
  maxSize: 50,
);

final builder = pool.acquire();
// Use builder...
pool.release(builder);
```

### Platform Compatibility

Write platform-aware code:

```dart
// Check platform
if (GeniusPdfPlatform.isWeb) {
  // Web-specific logic
} else if (GeniusPdfPlatform.isMobile) {
  // Mobile-specific logic
} else if (GeniusPdfPlatform.isDesktop) {
  // Desktop-specific logic
}

// Platform capabilities
if (GeniusPdfPlatform.hasFileSystem) {
  // Save to file system
}

if (GeniusPdfPlatform.hasNativePrinting) {
  // Use native printing
}

if (GeniusPdfPlatform.hasSharing) {
  // Share document
}

// Get platform config
final config = GeniusPdfPlatform.getConfig();
print('Platform: ${config.platform}');
print('Save path: ${config.defaultSavePath}');
print('Supported formats: ${config.supportedExportFormats}');

// Use GeniusPlatformAware mixin
class MyService with GeniusPlatformAware {
  void save() {
    if (isWeb) {
      // Download via browser
    } else if (isMobile) {
      // Save to documents
    } else if (isDesktop) {
      // Use file picker
    }
  }
}

// Override platform for testing
GeniusPdfPlatform.override(GeniusPlatformType.web);
// ... run tests ...
GeniusPdfPlatform.resetOverride();
```

### Logging System

The library includes a built-in logging system that can be enabled or disabled:

```dart
// Enable logging with console output
GeniusPdfLogger.configure(
  enabled: true,
  minLevel: GeniusLogLevel.debug,
  useConsole: true,
  coloredConsole: true,
);

// Or enable manually
GeniusPdfLogger.enable();
GeniusPdfLogger.useConsoleHandler();

// Log messages
GeniusPdfLogger.debug('Initializing PDF config', tag: 'Config');
GeniusPdfLogger.info('PDF generated successfully', tag: 'Service');
GeniusPdfLogger.warning('Large image detected', tag: 'Image');
GeniusPdfLogger.error('Failed to load font', error: e, stackTrace: stack);

// Disable logging in production
GeniusPdfLogger.disable();
```

**Filter by Level:**

```dart
// Only show warnings and errors
GeniusPdfLogger.setMinLevel(GeniusLogLevel.warning);
```

**Custom Handlers:**

```dart
// Add custom log handler
GeniusPdfLogger.addHandler((entry) {
  // Send to analytics, file, external service, etc.
  myAnalytics.track('pdf_log', {
    'level': entry.levelName,
    'message': entry.message,
    'tag': entry.tag,
  });
});
```

**Log History:**

```dart
// Enable history for debugging
GeniusPdfLogger.enableHistory(maxSize: 200);

// Get recent logs
final logs = GeniusPdfLogger.history;
for (final log in logs) {
  print(log.toString());
}

// Clear history
GeniusPdfLogger.clearHistory();
```

**Stream-based Logging:**

```dart
// Listen to logs in real-time
GeniusPdfLogger.stream.listen((entry) {
  if (entry.level == GeniusLogLevel.error) {
    showErrorDialog(entry.message);
  }
});
```

**Use Mixin in Classes:**

```dart
class MyPdfBuilder with GeniusLoggable {
  @override
  String get logTag => 'MyPdfBuilder';

  void build() {
    logDebug('Starting build');
    // ... build logic ...
    logInfo('Build completed');
  }
}
```

### Reactive Streams

Monitor operations in real-time:

```dart
final streams = GeniusPdfReactiveStreams.instance;

// Listen to progress
streams.progress.listen((progress) {
  print('${progress.operationType}: ${progress.percentage}%');
  if (progress.isComplete) {
    print('Complete!');
  }
});

// Listen to state changes
streams.state.listen((state) {
  print('Document ${state.documentId}: ${state.status}');
});

// Update from your code
streams.updateProgress(GeniusOperationProgress(
  operationId: 'render-1',
  operationType: 'render',
  current: 5,
  total: 10,
  message: 'Rendering page 5...',
));

streams.updateState(GeniusDocumentState(
  documentId: 'doc-123',
  status: GeniusDocumentStatus.rendering,
  pageCount: 10,
));
```

---

## Styling

### Color Schemes

```dart
// Built-in schemes
GeniusPdfColorScheme.defaultScheme  // Blue-based
GeniusPdfColorScheme.professional   // Gray-based
GeniusPdfColorScheme.saudi          // Green-based (Saudi Arabia)
```

### Text Styles

```dart
GeniusPdfTextStyle.title()    // Large, bold, centered
GeniusPdfTextStyle.header()   // Medium, bold
GeniusPdfTextStyle.subtitle() // Medium, muted
GeniusPdfTextStyle.body()     // Normal text
GeniusPdfTextStyle.caption()  // Small, muted
```

### Border Styles

```dart
GeniusPdfBorderStyle.all()        // All sides
GeniusPdfBorderStyle.none()       // No border
GeniusPdfBorderStyle.horizontal() // Top & bottom
GeniusPdfBorderStyle.vertical()   // Left & right
GeniusPdfBorderStyle.bottom()     // Bottom only
```

---

## Architecture

```
lib/
├── genius_link_pdf_generator.dart  # Main library export
└── src/
    ├── core/
    │   ├── pdf_config.dart
    │   ├── pdf_assets.dart
    │   └── v2/                     # V2 Architecture
    │       ├── v2.dart             # V2 barrel export
    │       ├── plugin_system.dart  # Plugin architecture
    │       ├── dependency_injection.dart # DI container
    │       ├── event_system.dart   # Event bus & reactive streams
    │       ├── fluent_api.dart     # Enhanced fluent API
    │       ├── cache_system.dart   # Smart caching
    │       └── platform_utils.dart # Platform compatibility
    ├── models/
    │   ├── pdf_image.dart
    │   └── pdf_result.dart
    ├── builders/
    │   └── pdf_document_builder.dart
    ├── services/
    │   ├── pdf_service.dart
    │   ├── pdf_generation_manager.dart
    │   └── pdf_security_service.dart
    ├── widgets/
    │   └── pdf_preview.dart
    ├── extensions/
    │   ├── color_extensions.dart
    │   └── datetime_extensions.dart
    ├── components/
    │   ├── models/
    │   │   ├── pdf_styles.dart
    │   │   ├── grid_models.dart
    │   │   ├── chart_models.dart
    │   │   └── security_models.dart
    │   └── widgets/
    │       ├── pdf_data_grid.dart
    │       ├── pdf_rich_text.dart
    │       ├── pdf_info_box.dart
    │       ├── pdf_report_header.dart
    │       ├── pdf_summary.dart
    │       ├── pdf_bar_chart.dart
    │       ├── pdf_line_chart.dart
    │       ├── pdf_pie_chart.dart
    │       ├── pdf_area_chart.dart
    │       ├── pdf_watermark.dart
    │       └── pdf_digital_signature.dart
    └── templates/
        ├── tax_invoice_template.dart
        ├── trial_balance_template.dart
        ├── customer_statement_template.dart
        ├── inventory_report_template.dart
        ├── balance_sheet_template.dart
        ├── income_statement_template.dart
        ├── cash_flow_template.dart
        ├── budget_report_template.dart
        ├── quotation_template.dart
        ├── purchase_order_template.dart
        ├── delivery_note_template.dart
        ├── credit_note_template.dart
        ├── payslip_template.dart
        ├── employee_report_template.dart
        ├── attendance_report_template.dart
        └── leave_report_template.dart
```

---

## AI Features (v2.1.0)

### Content Analyzer

Analyze PDF documents to extract text, detect document types, and find structured data:

```dart
final analyzer = GeniusPdfContentAnalyzer();
final result = await analyzer.analyzeBytes(pdfBytes);

// Document classification
print('Type: ${result.documentType}'); // invoice, report, letter, etc.

// Language detection
print('Languages: ${result.detectedLanguages}'); // ['en', 'ar']

// Keywords
print('Keywords: ${result.keywords}');

// Structured data
print('Emails: ${result.structuredData.emails}');
print('Amounts: ${result.structuredData.amounts}');
print('Dates: ${result.structuredData.dates}');
print('Phone numbers: ${result.structuredData.phoneNumbers}');
```

### Smart Layout Engine

Get intelligent layout suggestions for optimal PDF formatting:

```dart
final layoutEngine = GeniusSmartLayoutEngine(
  isRtl: true,
  optimizeForPrint: true,
);

// Font size suggestions
final fontSuggestions = layoutEngine.analyzeFontSizes(
  contentLength: 5000,
  pageSize: PdfPageSize.a4,
);

// Margin suggestions
final marginSuggestion = layoutEngine.suggestMargins(
  elements: myElements,
  pageSize: PdfPageSize.a4,
);

// Color scheme suggestions
final colorSuggestion = layoutEngine.suggestColorScheme(
  documentType: 'invoice',
);

// Full layout optimization
final optimized = layoutEngine.optimizeLayout(
  elements: myElements,
  pageSize: PdfPageSize.a4,
);
print('Estimated pages: ${optimized.estimatedPages}');
```

### Smart Text Services

Summarize documents, detect languages, and generate titles:

```dart
final textServices = GeniusSmartTextServices();

// Summarize long text
final summary = textServices.summarize(longText, maxLength: 500);
print('Summary: ${summary.summary}');
print('Key points: ${summary.keyPoints}');
print('Compression: ${summary.compressionRatio * 100}%');

// Detect language
final language = textServices.detectLanguage(text);
print('Language: ${language.primaryLanguage}'); // 'ar' or 'en'
print('Is RTL: ${language.isRtl}');

// Generate titles
final titles = textServices.generateTitles(text);
for (final title in titles) {
  print('${title.title} (confidence: ${title.confidence})');
}

// Extract keywords
final keywords = textServices.extractKeywords(text);
```

### Smart Image Optimizer

Analyze and optimize images for PDF inclusion:

```dart
final imageOptimizer = GeniusSmartImageOptimizer();

// Analyze image
final analysis = await imageOptimizer.analyze(imageBytes);
print('Dimensions: ${analysis.width}x${analysis.height}');
print('Recommendations:');
for (final rec in analysis.recommendations) {
  print('  - ${rec.description}');
}

// Optimize image
final optimized = await imageOptimizer.optimize(
  imageBytes,
  settings: GeniusImageOptimizationSettings.forScreen,
);
print('Saved: ${optimized.savingsPercentage}%');

// Calculate optimal size for PDF
final size = imageOptimizer.calculateOptimalSize(
  imageWidth: 2000,
  imageHeight: 1500,
  maxPdfWidth: 500,
  maxPdfHeight: 400,
);
```

---

## Advanced Printing (v2.2.0)

### Printer Service

Print PDFs with advanced options and job tracking:

```dart
// Print with system dialog
final result = await GeniusPrinterService.instance.printWithDialog(
  pdfBytes: pdfBytes,
  documentName: 'Invoice_001',
  settings: GeniusPrintSettings(
    copies: 2,
    paperSize: GeniusPaperSize.a4,
    orientation: GeniusPrintOrientation.portrait,
    colorMode: GeniusPrintColorMode.grayscale,
    quality: GeniusPrintQuality.normal,
    duplexMode: GeniusDuplexMode.longEdge,
  ),
  onProgress: (job) => print('Progress: ${job.progress * 100}%'),
  onComplete: (job) => print('Completed!'),
);

if (result.success) {
  print('Print job completed: ${result.job!.id}');
}
```

### Print Settings Presets

Use built-in presets for common scenarios:

```dart
// Eco-friendly: duplex, grayscale, draft quality
final ecoSettings = GeniusPrintSettings.eco();

// High quality: color, high quality
final highQuality = GeniusPrintSettings.highQuality();

// Draft: fast printing, low quality
final draft = GeniusPrintSettings.draft();

// Custom settings
final custom = GeniusPrintSettings(
  copies: 3,
  paperSize: GeniusPaperSize.letter,
  pageRange: GeniusPrintPageRange.range(1, 5),
  pagesPerSheet: 2,
  collate: true,
);
```

### Printer Discovery

Discover available printers:

```dart
// Get all printers
final printers = await GeniusPrinterDiscovery.instance.discoverPrinters();

for (final printer in printers) {
  print('${printer.name}');
  print('  Status: ${printer.statusTextEn}'); // or statusTextAr
  print('  Default: ${printer.isDefault}');
  print('  Color: ${printer.capabilities.supportsColor}');
  print('  Duplex: ${printer.capabilities.supportsDuplex}');
}

// Get default printer
final defaultPrinter = await GeniusPrinterDiscovery.instance.getDefaultPrinter();

// Check printer availability
final isAvailable = await GeniusPrinterDiscovery.instance
    .isPrinterAvailable('printer_id');
```

### Direct Printing

Print directly without dialog (when supported):

```dart
final result = await GeniusPrinterService.instance.printDirect(
  pdfBytes: pdfBytes,
  documentName: 'Report',
  printerId: 'system_default',
  settings: GeniusPrintSettings.defaults(),
);
```

### Print Job Management

Track and manage print jobs:

```dart
final service = GeniusPrinterService.instance;

// Listen to job updates
service.jobStream.listen((job) {
  print('Job ${job.id}: ${job.statusTextEn}');
  print('Progress: ${(job.progress * 100).toStringAsFixed(0)}%');
});

// Get active jobs
final activeJobs = service.activeJobs;

// Get job history
final history = service.jobHistory;

// Cancel a job
await service.cancelJob(jobId);

// Clear history
service.clearHistory();
```

### Page Range Options

Specify which pages to print:

```dart
// All pages
final all = GeniusPrintPageRange.all();

// Single page
final single = GeniusPrintPageRange.single(3);

// Page range (inclusive)
final range = GeniusPrintPageRange.range(1, 10);

// First N pages
final first = GeniusPrintPageRange.first(5);

// Custom pages
final custom = GeniusPrintPageRange.custom([1, 3, 5, 7, 9]);
```

### Extension Method

Print bytes directly:

```dart
// Using extension
final result = await pdfBytes.print(
  documentName: 'My Document',
  settings: GeniusPrintSettings.defaults(),
);
```

### Print Preview (v2.2.1)

Show a preview dialog before printing:

```dart
// Show print preview dialog
final printed = await GeniusPrintPreviewDialog.show(
  context: context,
  pdfBytes: pdfBytes,
  documentName: 'Invoice_001',
  initialSettings: GeniusPrintSettings.defaults(),
  showSettings: true,
);

if (printed == true) {
  print('Document was printed!');
}

// Or use the widget directly
GeniusPrintPreview(
  pdfBytes: pdfBytes,
  documentName: 'Report',
  showSettings: true,
  showThumbnails: true,
  onPrint: (settings) => print('Print with: $settings'),
  onCancel: () => Navigator.pop(context),
)
```

### Print Profiles (v2.2.1)

Save and manage print settings profiles:

```dart
final manager = GeniusPrintSettingsManager.instance;

// Get system presets
final presets = manager.systemPresets; // Default, Eco, High Quality, Draft, Booklet, Presentation

// Create custom profile
final profile = GeniusPrintSettings(
  copies: 2,
  colorMode: GeniusPrintColorMode.grayscale,
  duplexMode: GeniusDuplexMode.longEdge,
).saveAsProfile(
  name: 'My Office Settings',
  nameAr: 'إعدادات المكتب',
);

// Get recent and most used profiles
final recentProfiles = manager.recentProfiles;
final mostUsedProfiles = manager.mostUsedProfiles;

// Set default profile
manager.setDefaultProfile(profile.id);

// Use default profile for printing
final defaultProfile = manager.defaultProfile;
if (defaultProfile != null) {
  await GeniusPrinterService.instance.printWithDialog(
    pdfBytes: pdfBytes,
    documentName: 'Document',
    settings: defaultProfile.settings,
  );
  manager.recordUsage(defaultProfile.id); // Track usage
}

// Export/Import profiles
final json = manager.exportProfiles();
manager.importProfiles(json, replace: false);
```

---

## Sharing Features (v2.3.x)

### Unified Sharing Service (v2.3.0)

Share PDFs through multiple channels with a single API:

```dart
final shareService = GeniusShareService.instance;
await shareService.initialize();

// Share via system share sheet
final result = await shareService.share(
  pdfBytes: pdfBytes,
  fileName: 'document.pdf',
  target: GeniusShareTarget.system(),
);

// Share via email
await shareService.share(
  pdfBytes: pdfBytes,
  fileName: 'invoice.pdf',
  target: GeniusShareTarget.email(
    toAddress: 'client@example.com',
    subject: 'Your Invoice',
  ),
);

// Quick share to saved contact
await shareService.quickShare(
  pdfBytes: pdfBytes,
  fileName: 'report.pdf',
  contact: favoriteContact,
);

// Share with template
await shareService.shareWithTemplate(
  pdfBytes: pdfBytes,
  fileName: 'invoice.pdf',
  target: GeniusShareTarget.email(),
  template: GeniusShareMessageTemplate.invoice(),
  variables: {
    'invoiceNumber': '12345',
    'customerName': 'Ahmed',
    'amount': '1,000 SAR',
  },
);

// View share history
final history = shareService.history;
final successfulShares = shareService.successfulShares;
```

### Email Sharing (v2.3.1)

Send PDFs directly via email:

```dart
final emailService = GeniusEmailShareService.instance;

// Compose email with pre-filled data
await emailService.composeEmail(
  email: GeniusEmailData(
    to: ['client@example.com'],
    cc: ['manager@company.com'],
    subject: 'Invoice #12345',
    body: 'Please find attached your invoice.',
  ),
);

// Open Gmail directly
await emailService.openGmail(
  email: GeniusEmailData(
    to: ['sales@company.com'],
    subject: 'Monthly Report',
  ),
);

// Open Outlook directly
await emailService.openOutlook(
  email: GeniusEmailData(
    to: ['team@company.com'],
    subject: 'Project Update',
  ),
);

// Create email from template
final email = emailService.createFromTemplate(
  template: GeniusShareMessageTemplate.invoice(),
  variables: {
    'invoiceNumber': '12345',
    'customerName': 'Ahmed',
    'amount': '1,500 SAR',
    'dueDate': '2026-02-01',
  },
  recipients: ['client@example.com'],
  useArabic: true, // Use Arabic template
);
```

### Bluetooth Sharing (v2.3.2)

Share PDFs with nearby devices:

```dart
final btService = GeniusBluetoothShareService.instance;

// Discover nearby devices
final devices = await btService.discoverDevices(
  timeout: Duration(seconds: 10),
  includePaired: true,
);

// Send to a device
final result = await btService.sendFile(
  pdfBytes: pdfBytes,
  fileName: 'document.pdf',
  device: devices.first,
  onProgress: (progress) => print('Progress: ${progress * 100}%'),
);

// Use Nearby Share (Android) or AirDrop (iOS)
await btService.shareViaNearby(
  pdfBytes: pdfBytes,
  fileName: 'report.pdf',
);

// Save favorite devices
await btService.saveDevice(device);
await btService.toggleFavorite(device.id);
```

### App Sharing (v2.3.3)

Share directly to specific apps:

```dart
final appService = GeniusAppShareService.instance;

// Share to WhatsApp
await appService.shareToWhatsApp(
  pdfBytes: pdfBytes,
  fileName: 'invoice.pdf',
  phoneNumber: '+966123456789',
  message: 'Here is your invoice',
);

// Share to Telegram
await appService.shareToTelegram(
  pdfBytes: pdfBytes,
  fileName: 'report.pdf',
);

// Share to any known app
await appService.shareToApp(
  pdfBytes: pdfBytes,
  fileName: 'document.pdf',
  app: GeniusSharableApp.googleDrive(),
);

// Save to local storage
await appService.saveToLocal(
  pdfBytes: pdfBytes,
  fileName: 'report.pdf',
  location: GeniusStorageLocation.downloads, // or documents, appDocuments
);

// Open in external PDF viewer
await appService.openInExternalApp(
  pdfBytes: pdfBytes,
  fileName: 'document.pdf',
);

// Get available apps
final messagingApps = appService.messagingApps;
final storageApps = appService.storageApps;
final emailApps = appService.emailApps;
```

### Share Targets

Available share targets:

```dart
// System share sheet
GeniusShareTarget.system()

// Email with optional data
GeniusShareTarget.email(
  toAddress: 'user@example.com',
  subject: 'Subject',
  body: 'Body text',
)

// Bluetooth
GeniusShareTarget.bluetooth(deviceId: 'optional-id')

// Specific apps
GeniusShareTarget.whatsApp()
GeniusShareTarget.telegram()
GeniusShareTarget.app(packageName: 'com.example.app')

// Cloud storage
GeniusShareTarget.cloud(provider: 'gdrive', folderPath: '/documents')

// Local storage
GeniusShareTarget.local(path: '/custom/path')
```

---

## License

MIT License - see [LICENSE](LICENSE) file.
