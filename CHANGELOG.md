# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.3.3+3] - 2026-01-27

### Added

#### Barcodes & QR Codes
- `GeniusPdfBarcode` - 1D/2D barcode generation component for PDF documents
  - Factory constructors: `.ean13()`, `.code128()`, `.shipping()`
  - Supports EAN-13, EAN-8, UPC-A, Code 128, Code 39, ITF, QR Code, DataMatrix, PDF417
  - `GeniusPdfBarcodeStyle` with presets: `.retail()`, `.shipping()`, `.compact()`, `.document()`
- `GeniusPdfQRCodeGenerator` - Dynamic QR code generation component
  - Factory constructors: `.url()`, `.zatca()`, `.wifi()`, `.vCard()`
  - ZATCA TLV (Tag-Length-Value) encoding for Saudi e-invoice QR codes
  - WiFi network sharing QR codes
  - vCard contact sharing QR codes
  - `GeniusPdfQRCodeStyle` with presets: `.invoice()`, `.payment()`, `.compact()`, `.branded()`
  - `GeniusQRErrorCorrection` levels: low, medium, quartile, high
- `GeniusBarcodeType` enum for all supported barcode formats
- `GeniusPdfCaptionPosition` enum (above/below)
- Barcode demo screen with 3 tabs: 1D Barcodes, QR Codes, All-in-One
- Dashboard navigation updated with Barcodes & QR section

### Fixed

#### Template Bug Fixes
- **customer_statement_template.dart** - Fixed duplicate info box: right panel was showing identical customer data instead of statement details (period, opening balance, currency)
- **purchase_order_template.dart** - Fixed status badge text position drawn at (0,0) instead of correct badge rectangle bounds
- **payslip_template.dart** - Added missing newline between notes label and text content

#### Template Improvements
- **tax_invoice_template.dart** - Implemented proper number-to-words conversion for English and Arabic (supports values up to billions, with currency/sub-currency names: SAR/Halalas, USD/Cents, etc.)
- **attendance_report_template.dart** - Fixed inconsistent bold font fallback to use `PdfFontStyle.bold` from config assets
- **balance_sheet_template.dart** - Enhanced unbalanced warning with colored background box (green/red), left accent border, and difference amount display
- Added thousands separators to currency formatting across 9 templates: balance_sheet, budget_report, cash_flow, credit_note, income_statement, payslip, purchase_order, quotation, tax_invoice

---

## [2.3.3+2] - 2026-01-26

### Added

#### Comprehensive Print Theme System (`GeniusPdfPrintTheme`)

A centralized theming system for all PDF components with preset themes and full customization.

##### Core Theme Components
- `GeniusPdfPrintTheme` - Main theme class with colors, typography, spacing, and borders
- `GeniusPdfColorSchemeTheme` - Color definitions (primary, secondary, accent, text, background, border, success, warning, error)
- `GeniusPdfTypographyTheme` - Font sizes (title, subtitle, header, body, caption, small)
- `GeniusPdfSpacingTheme` - Spacing values (none, xs, sm, md, lg, xl, xxl)
- `GeniusPdfBorderTheme` - Border settings (width, color, radius)

##### Component-Specific Themes
- `GeniusPdfGridTheme` - Grid styling (header, row, alternate row colors, borders)
- `GeniusPdfSummaryTheme` - Summary section styling (label, total, spacing)
- `GeniusPdfInfoBoxTheme` - Info box styling (background, border, title, content)
- `GeniusPdfHeaderTheme` - Report header styling (title, subtitle, company name)
- `GeniusPdfSectionTheme` - Section styling (title background, content padding)

##### Preset Themes
- `GeniusPdfPrintTheme.defaults()` - Default professional theme
- `GeniusPdfPrintTheme.corporate()` - Blue corporate theme
- `GeniusPdfPrintTheme.minimal()` - Clean minimal theme
- `GeniusPdfPrintTheme.saudi()` - Saudi-inspired green theme
- `GeniusPdfPrintTheme.invoice()` - Optimized for invoices

##### GeniusPdfConfig Integration
- Added `printTheme` parameter to `GeniusPdfConfig` for centralized theme configuration
- All components can now inherit theme settings from config

#### Enhanced Grid Components

##### GeniusPdfGridColumn Improvements
- `subtitle` - Optional subtitle text for column headers
- `subtitleAr` - Arabic subtitle text
- `sortable` - Mark column as sortable
- `sortOrder` - Sort direction (ascending/descending)
- `wrapText` - Enable text wrapping in cells
- `maxLines` - Maximum lines when wrapping
- `prefix` / `suffix` - Text prefix and suffix for values
- `valueFormatter` - Custom value formatting function
- New factory constructors:
  - `GeniusPdfGridColumn.index()` - Index/row number column
  - `GeniusPdfGridColumn.date()` - Date formatted column
  - `GeniusPdfGridColumn.percentage()` - Percentage formatted column
  - `GeniusPdfGridColumn.quantity()` - Quantity column
  - `GeniusPdfGridColumn.description()` - Description column (wider, wrap text)
  - `GeniusPdfGridColumn.action()` - Action status column

##### GeniusPdfGridRow Improvements
- `subtitle` - Row subtitle text
- `isHighlighted` - Highlight row
- `highlightColor` - Custom highlight color
- `indent` - Row indentation level
- `height` - Custom row height
- `minHeight` / `maxHeight` - Height constraints
- New factory constructors:
  - `GeniusPdfGridRow.subtotal()` - Subtotal row with styling
  - `GeniusPdfGridRow.separator()` - Visual separator row
  - `GeniusPdfGridRow.spacer()` - Empty spacer row

##### GeniusPdfGridStyle Factory Constructors
- `GeniusPdfGridStyle.corporate()` - Corporate blue style
- `GeniusPdfGridStyle.minimal()` - Minimal borders style
- `GeniusPdfGridStyle.saudi()` - Saudi green style
- `GeniusPdfGridStyle.invoice()` - Invoice optimized style

##### GeniusPdfGridGroup Improvements
- `level` - Hierarchical group level (for nested groups)
- `isExpanded` - Expansion state
- `showSummary` - Show group summary row
- `summaryLabel` / `summaryLabelAr` - Summary row labels
- `summaryColumns` - Columns to summarize
- `autoCalculateSummary` - Auto-calculate summary values
- `indent` - Group indentation
- `backgroundColor` - Group background color

#### Enhanced Info Box Components

##### GeniusPdfInfoBoxStyle Improvements
- `titleFontSize` / `titleColor` / `titleIsBold` - Title styling
- `contentFontSize` / `contentColor` - Content styling
- `labelColor` / `valueColor` - Label/value colors
- `labelValueLayout` - Layout options (horizontal, vertical, inline)
- `itemSpacing` - Spacing between items
- `borderRadius` - Rounded corners support
- `shadowColor` / `shadowOffset` / `shadowBlur` - Shadow effects
- New factory constructors:
  - `GeniusPdfInfoBoxStyle.corporate()` - Corporate style
  - `GeniusPdfInfoBoxStyle.minimal()` - Minimal style
  - `GeniusPdfInfoBoxStyle.saudi()` - Saudi green style
  - `GeniusPdfInfoBoxStyle.invoice()` - Invoice style
  - `GeniusPdfInfoBoxStyle.compact()` - Compact spacing
  - `GeniusPdfInfoBoxStyle.modern()` - Modern with shadows

##### GeniusPdfInfoBox Improvements
- `footer` / `footerAr` - Footer text
- `columns` - Multi-column layout
- `maxItemsPerColumn` - Items per column limit
- `alignment` - Box alignment (left, center, right, stretch)
- New factory constructor:
  - `GeniusPdfInfoBox.address()` - Pre-configured address box

##### GeniusPdfDualInfoBox Improvements
- `layout` - Layout options (horizontal, vertical, diagonal)
- `spacing` - Spacing between boxes
- `alignment` - Dual box alignment

##### GeniusPdfSection Improvements
- New `GeniusPdfSectionStyle` class with:
  - Title position (top, left, inside, floating)
  - Title alignment and styling
  - Content padding and background
  - Border and shadow settings
  - Factory constructors: `.card()`, `.panel()`, `.outlined()`, `.filled()`

#### Enhanced Report Header Components

##### GeniusPdfCompanyInfo Improvements
- `address` / `addressAr` - Company address
- `city` / `cityAr` - City
- `country` / `countryAr` - Country
- `postalCode` - Postal code
- `phone` / `fax` / `email` / `website` - Contact information
- `commercialRegistration` - CR number
- `additionalInfo` - Map of additional info

##### GeniusPdfReportHeaderStyle Improvements
- `logoPosition` - Logo placement (left, right, center, background)
- `showAccentLine` - Accent line under header
- `accentLineColor` / `accentLineHeight` - Accent styling
- `titleAlignment` - Title alignment options
- `companyInfoPosition` - Company info placement
- `showBorder` / `borderColor` / `borderWidth` - Border settings
- New factory constructors:
  - `GeniusPdfReportHeaderStyle.corporate()` - Corporate style
  - `GeniusPdfReportHeaderStyle.minimal()` - Minimal style
  - `GeniusPdfReportHeaderStyle.saudi()` - Saudi green style
  - `GeniusPdfReportHeaderStyle.invoice()` - Invoice style
  - `GeniusPdfReportHeaderStyle.compact()` - Compact style
  - `GeniusPdfReportHeaderStyle.centered()` - Centered style

##### GeniusPdfReportHeader Improvements
- `bilingualOrder` - Control Arabic/English order
- `showDate` / `dateLabel` / `dateLabelAr` - Date display
- `dateFormat` - Custom date format
- `customDate` - Override current date
- `metadata` - Additional metadata map
- New factory constructors:
  - `GeniusPdfReportHeader.invoice()` - Invoice header preset
  - `GeniusPdfReportHeader.simple()` - Simple header without company
  - `GeniusPdfReportHeader.withCompany()` - Full company header

#### Enhanced Summary Components

##### GeniusPdfSummaryItem Improvements
- `prefix` / `suffix` - Value prefix and suffix
- `indent` - Item indentation
- `showLine` - Show separator line
- `lineColor` - Line color
- `valueAlignment` - Value text alignment
- `showColon` - Show colon after label
- `showBackground` - Show item background

##### GeniusPdfSummaryStyle Improvements
- `itemSpacing` - Spacing between items
- `showBorder` / `borderColor` - Border settings
- `borderRadius` - Rounded corners
- `showBackground` / `backgroundColor` - Background
- `dividerColor` / `dividerThickness` - Divider styling
- `alignment` - Section alignment
- `maxWidth` - Maximum section width
- New factory constructors:
  - `GeniusPdfSummaryStyle.card()` - Card style
  - `GeniusPdfSummaryStyle.minimal()` - Minimal style
  - `GeniusPdfSummaryStyle.invoice()` - Invoice style

#### Enhanced Rich Text Components

##### GeniusPdfTextSpan Improvements
- `backgroundColor` - Text background color
- `letterSpacing` - Character spacing
- `wordSpacing` - Word spacing
- `decoration` - Text decoration (underline, strikethrough)
- `decorationColor` - Decoration color
- `decorationStyle` - Decoration style (solid, dotted, dashed)
- `superscript` / `subscript` - Super/subscript text
- `isRtl` - RTL text direction override
- New factory constructors:
  - `GeniusPdfTextSpan.currency()` - Currency formatting
  - `GeniusPdfTextSpan.percentage()` - Percentage formatting
  - `GeniusPdfTextSpan.date()` - Date formatting
  - `GeniusPdfTextSpan.highlight()` - Highlighted text
  - `GeniusPdfTextSpan.code()` - Code/monospace text
  - `GeniusPdfTextSpan.superscript()` - Superscript text
  - `GeniusPdfTextSpan.subscript()` - Subscript text

#### New Enums

- `GeniusPdfBilingualOrder` - Arabic first or English first
- `GeniusPdfLogoPosition` - left, right, center, background
- `GeniusPdfTitleAlignment` - left, center, right
- `GeniusPdfLabelValueLayout` - horizontal, vertical, inline
- `GeniusPdfInfoBoxAlignment` - left, center, right, stretch
- `GeniusPdfDualInfoBoxLayout` - horizontal, vertical, diagonal
- `GeniusPdfSectionTitlePosition` - top, left, inside, floating
- `GeniusPdfTextDecoration` - none, underline, strikethrough, overline
- `GeniusPdfTextDecorationStyle` - solid, dotted, dashed, wavy

### Example

```dart
// Use preset theme
final theme = GeniusPdfPrintTheme.corporate();

// Create config with theme
final config = GeniusPdfConfig(
  baseFont: myFont,
  printTheme: theme,
);

// Use new grid features
final grid = GeniusPdfDataGrid(
  columns: [
    GeniusPdfGridColumn.index(),
    GeniusPdfGridColumn.description(id: 'desc', title: 'Description'),
    GeniusPdfGridColumn.quantity(id: 'qty', title: 'Qty'),
    GeniusPdfGridColumn.currency(id: 'price', title: 'Price'),
  ],
  rows: [
    GeniusPdfGridRow(cells: {...}),
    GeniusPdfGridRow.subtotal({'desc': 'Subtotal', 'price': 1000}),
  ],
  style: GeniusPdfGridStyle.invoice(),
);

// Use new info box features
final box = GeniusPdfInfoBox.address(
  title: 'Billing Address',
  titleAr: 'عنوان الفواتير',
  items: [...],
  style: GeniusPdfInfoBoxStyle.modern(),
);

// Use new header features
final header = GeniusPdfReportHeader.invoice(
  invoiceNumber: 'INV-001',
  company: GeniusPdfCompanyInfo(
    name: 'Company',
    nameAr: 'الشركة',
    address: '123 Main St',
    city: 'Riyadh',
    phone: '+966123456789',
  ),
  bilingualOrder: GeniusPdfBilingualOrder.arabicFirst,
);
```

---

## [2.3.3+1] - 2026-01-25

### Changed

#### Architecture: Config Instance Pattern (Breaking Change)
- **No Global Singleton** - Removed `GeniusPdfConfig.instance` and `GeniusPdfConfig.instanceOrNull`
- **Per-Builder Config** - Each `GeniusPdfDocumentBuilder` must have its own `GeniusPdfConfig` instance
- **Assets via Config** - `GeniusPdfAssets` is now only accessible through `GeniusPdfConfig.assets`
- **Factory Methods** - Use `GeniusPdfConfig.create()` or `GeniusPdfConfig.createSync()` to create instances
- **Required Fonts** - `GeniusPdfRichText` now requires `baseFont` and `boldFont` parameters

### Migration Guide

#### Before (v2.3.3)
```dart
// Global initialization
await GeniusPdfConfig.initialize(
  baseFont: myFont,
  assetPaths: GeniusPdfAssetPaths(...),
);

// Access anywhere via singleton
final config = GeniusPdfConfig.instance;
final assets = GeniusPdfConfig.assets;
final font = GeniusPdfAssets.instance.primaryFont;
```

#### After (v2.3.3+1)
```dart
// Create config instance
final config = await GeniusPdfConfig.create(
  baseFont: myFont,
  assetPaths: GeniusPdfAssetPaths(...),
);

// Pass config to document builders
final builder = MyDocumentBuilder(config);

// Access assets via config instance
final assets = config.assets;
final font = config.assets.primaryFont;
```

### Why This Change?
- **Thread Safety** - Each document generation can have independent configuration
- **Testing** - Easier to test with isolated config instances
- **Flexibility** - Different documents can use different settings simultaneously
- **Explicit Dependencies** - No hidden global state, clearer code flow

---

## [2.3.3] - 2026-01-24

### Added

#### App Sharing Service (`GeniusAppShareService`)
- **Known Apps** - Pre-configured support for popular apps:
  - Messaging: WhatsApp, WhatsApp Business, Telegram, Signal, Viber, Line, WeChat, Messenger
  - Email: Gmail, Outlook
  - Storage: Google Drive, Dropbox, OneDrive
  - Work: Slack, Microsoft Teams
- **App Categories** - Organize apps by type (messaging, email, storage, work)
- **Direct App Sharing** - Share to specific apps
- **Local Storage** - Save to Downloads, Documents, or custom location
- **External Viewer** - Open PDF in device's default viewer

### Example

```dart
final appService = GeniusAppShareService.instance;

// Share to WhatsApp
await appService.shareToWhatsApp(
  pdfBytes: pdfBytes,
  fileName: 'invoice.pdf',
  phoneNumber: '+966123456789',
  message: 'Here is your invoice',
);

// Save to Downloads
await appService.saveToLocal(
  pdfBytes: pdfBytes,
  fileName: 'report.pdf',
  location: GeniusStorageLocation.downloads,
);

// Open in external PDF viewer
await appService.openInExternalApp(
  pdfBytes: pdfBytes,
  fileName: 'document.pdf',
);
```

---

## [2.3.2] - 2026-01-24

### Added

#### Bluetooth Sharing Service (`GeniusBluetoothShareService`)
- **Device Discovery** - Find nearby Bluetooth devices
- **Device Types** - Support for computers, phones, tablets, printers
- **Saved Devices** - Save and manage favorite devices
- **File Transfer** - Send PDFs to Bluetooth devices
- **Transfer Tracking** - Monitor progress, speed, and estimated time
- **Nearby Share** - Support for Android Nearby Share / iOS AirDrop

#### Bluetooth Models
- `GeniusBluetoothDevice` - Device info with type, status, and signal strength
- `GeniusBluetoothTransfer` - Transfer tracking with progress and speed
- `GeniusBluetoothResult` - Operation result with detailed status

### Example

```dart
final btService = GeniusBluetoothShareService.instance;

// Discover devices
final devices = await btService.discoverDevices();

// Send to a device
final result = await btService.sendFile(
  pdfBytes: pdfBytes,
  fileName: 'document.pdf',
  device: devices.first,
  onProgress: (progress) => print('Progress: ${progress * 100}%'),
);

// Use Nearby Share
await btService.shareViaNearby(
  pdfBytes: pdfBytes,
  fileName: 'report.pdf',
);
```

---

## [2.3.1] - 2026-01-24

### Added

#### Email Sharing Service (`GeniusEmailShareService`)
- **Compose Email** - Open email client with pre-filled data
- **Gmail Integration** - Open Gmail app or web directly
- **Outlook Integration** - Open Outlook app or web directly
- **Email Validation** - Validate email addresses
- **Attachment Support** - Attach PDFs with size validation
- **SMTP Placeholder** - API for future direct SMTP sending

#### Email Models
- `GeniusEmailData` - Email composition data (to, cc, bcc, subject, body)
- `GeniusEmailAttachment` - Attachment with size and MIME type
- `GeniusSmtpConfig` - SMTP server configuration
- `GeniusEmailResult` - Operation result

### Example

```dart
final emailService = GeniusEmailShareService.instance;

// Compose email
await emailService.composeEmail(
  email: GeniusEmailData(
    to: ['client@example.com'],
    subject: 'Invoice #12345',
    body: 'Please find attached your invoice.',
  ),
);

// Open Gmail with email
await emailService.openGmail(
  email: GeniusEmailData(
    to: ['sales@company.com'],
    subject: 'Monthly Report',
  ),
);

// Create email from template
final email = emailService.createFromTemplate(
  template: GeniusShareMessageTemplate.invoice(),
  variables: {
    'invoiceNumber': '12345',
    'customerName': 'Ahmed',
    'amount': '1,500 SAR',
  },
  recipients: ['client@example.com'],
);
```

---

## [2.3.0] - 2026-01-24

### Added

#### Unified Sharing Service (`GeniusShareService`)
- **Single API** - One service for all sharing methods
- **Multiple Targets** - System share sheet, email, Bluetooth, apps, cloud, local
- **Quick Share** - Share to saved contacts with one call
- **Share History** - Track all sharing activity
- **Share Events** - Stream of sharing updates

#### Share Models
- `GeniusShareTarget` - Define share destination (system, email, bluetooth, app, cloud, local)
- `GeniusShareResult` - Detailed operation result with status
- `GeniusShareHistoryItem` - History entry with timestamp and metadata
- `GeniusShareConfig` - Configuration for size limits, compression, timestamps

#### Quick Share Contacts
- `GeniusQuickShareContact` - Save favorite share recipients
- **Favorite Contacts** - Mark contacts as favorites
- **Usage Tracking** - Track share frequency and recent activity
- **Contact Management** - Add, remove, toggle favorites

#### Message Templates
- `GeniusShareMessageTemplate` - Reusable email templates
- **Built-in Templates** - Invoice, Report, Document templates
- **Variable Substitution** - Replace placeholders with values
- **Bilingual Support** - Arabic and English templates

### Example

```dart
// Initialize service
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

// Quick share to contact
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
  variables: {'invoiceNumber': '12345', 'amount': '1,000 SAR'},
);

// View history
final history = shareService.history;
final successfulShares = shareService.successfulShares;
```

---

## [2.2.1] - 2026-01-24

### Added

#### Print Preview Widget (`GeniusPrintPreview`)
- **Visual Preview** - See document before printing with full page rendering
- **Settings Panel** - Adjust all print settings from the preview screen
- **Settings Summary** - Quick overview of current settings (paper, orientation, color, copies)
- **Quick Presets** - Apply default, eco, high quality, or draft settings instantly
- **Full Dialog Support** - Use `GeniusPrintPreviewDialog.show()` for modal preview

#### Print Settings Manager (`GeniusPrintSettingsManager`)
- **Save Profiles** - Save custom print settings as reusable profiles
- **System Presets** - Built-in presets (Default, Eco, High Quality, Draft, Booklet, Presentation)
- **Profile Management** - Create, update, delete, and organize print profiles
- **Usage Tracking** - Track recently used and most used profiles
- **Import/Export** - Export and import profiles as JSON
- **Default Profile** - Set a default profile for quick printing
- **Persistence Support** - Callbacks for saving profiles to storage

#### Print Profile Model (`GeniusPrintProfile`)
- **Profile Data** - Name, Arabic name, icon, settings, and metadata
- **Usage Statistics** - Track usage count and last used date
- **JSON Serialization** - Full serialization support for persistence

### Example

```dart
// Show print preview dialog
final printed = await GeniusPrintPreviewDialog.show(
  context: context,
  pdfBytes: pdfBytes,
  documentName: 'Invoice_001',
  initialSettings: GeniusPrintSettings.defaults(),
);

// Save settings as profile
final profile = mySettings.saveAsProfile(
  name: 'My Invoice Settings',
  nameAr: 'إعدادات فواتيري',
);

// Get and use saved profiles
final manager = GeniusPrintSettingsManager.instance;
final recentProfiles = manager.recentProfiles;
final defaultProfile = manager.defaultProfile;

// Apply profile settings
if (defaultProfile != null) {
  await printer.printWithDialog(
    pdfBytes: pdfBytes,
    documentName: 'Document',
    settings: defaultProfile.settings,
  );
}
```

---

## [2.2.0] - 2026-01-24

### Added

#### Advanced Printing Service

This release introduces a comprehensive printing module with advanced features.

##### Printer Service (`GeniusPrinterService`)
- **Print with Dialog** - Show native print dialog for user-controlled printing
- **Direct Printing** - Print directly to a specific printer (when supported)
- **Print Copies** - Print multiple copies with collation support
- **Job Tracking** - Track print job status, progress, and history
- **Job Management** - Cancel jobs, view history, clear completed jobs

##### Printer Discovery (`GeniusPrinterDiscovery`)
- **Discover Printers** - Find available printers on the system/network
- **Printer Info** - Get detailed printer information (name, status, capabilities)
- **Printer Status** - Check if a printer is available and ready
- **Caching** - Efficient caching to reduce discovery overhead

##### Print Settings (`GeniusPrintSettings`)
- **Paper Size** - Support for A3, A4, A5, Letter, Legal, and more
- **Orientation** - Portrait, Landscape, or Auto-detect
- **Color Mode** - Color, Grayscale, or Black & White
- **Quality** - Draft, Normal, High, or Photo quality
- **Duplex** - Single-sided, Long Edge, or Short Edge
- **Page Range** - Print all, specific range, or custom pages
- **Copies** - Multiple copies with collation
- **Scale** - Fit to page or custom scale percentage

##### Printer Models
- `GeniusPrinterInfo` - Printer information with status and capabilities
- `GeniusPrinterCapabilities` - Printer feature detection
- `GeniusPrintJob` - Print job with status tracking
- `GeniusPrintResult` - Print operation result
- `GeniusPaperSize` - Paper size enum with dimensions
- `GeniusPageRange` - Flexible page range specification

### Example

```dart
// Print with dialog
final result = await GeniusPrinterService.instance.printWithDialog(
  pdfBytes: pdfBytes,
  documentName: 'Invoice_001',
  settings: GeniusPrintSettings(
    copies: 2,
    colorMode: GeniusPrintColorMode.grayscale,
    duplexMode: GeniusDuplexMode.longEdge,
  ),
);

// Discover printers
final printers = await GeniusPrinterDiscovery.instance.discoverPrinters();
for (final printer in printers) {
  print('${printer.name}: ${printer.statusTextEn}');
}

// Print directly (if supported)
final directResult = await GeniusPrinterService.instance.printDirect(
  pdfBytes: pdfBytes,
  documentName: 'Report',
  printerId: printers.first.id,
);

// Use preset settings
final ecoSettings = GeniusPrintSettings.eco(); // Duplex, grayscale, draft
final highQuality = GeniusPrintSettings.highQuality(); // Color, high quality
```

---

## [2.1.2] - 2026-01-24

### Added

- **`GeniusPdfConfig.fontBuild()`** - Helper method to build fonts from config assets:
  ```dart
  // Build font from config assets with custom size
  final titleFont = GeniusPdfConfig.fontBuild(fontSize: 18);
  
  // Or with specific config
  final font = GeniusPdfConfig.fontBuild(config: myConfig, fontSize: 14);
  ```

### Changed

- **Simplified GeniusPdfAssets.instance** - Fixed backward compatibility getter to properly delegate to `GeniusPdfConfig.assetsOrNull`
- **GeniusPdfRichText** - Now defaults to `GeniusPdfConfig.instance` fonts when `baseFont`/`boldFont` not provided

### Removed

- Removed unused reset/dispose methods from `GeniusPdfConfig`:
  - `reset()`, `resetConfig()`, `resetAssets()`, `resetLogger()`, `dispose()`
  - These methods were rarely used and added unnecessary complexity

---

## [2.1.1] - 2026-01-24

### Added

#### Centralized Configuration System

A unified configuration center that merges all PDF settings into a single entry point.

##### `GeniusPdfConfig` Enhancements
- **Assets as Instance Field** - `configAssets` is now an instance field, allowing each config to have its own assets:
  - Each `GeniusPdfConfig` instance can have its own set of fonts and images
  - Access via `config.configAssets` for local instances
  - Static `GeniusPdfConfig.assets` delegates to singleton's `configAssets`
- **Unified Initialization** - Initialize config, assets, and logger in one call:
  - `GeniusPdfConfig.initialize()` now accepts `assetPaths`, `assetData`, and `loggerConfig`
  - `GeniusPdfConfig.initializeSync()` for synchronous initialization without asset loading
- **Logger Access** - Access logger through `GeniusPdfConfig.logger`
  - `GeniusPdfConfig.logger.enable()` / `.disable()` - Control logging
  - `GeniusPdfConfig.logger.debug()`, `.info()`, `.warning()`, `.error()` - Log messages

##### New Configuration Classes
- `GeniusPdfAssetPaths` - Combined paths configuration for fonts and branding
- `GeniusPdfAssetsData` - Pre-loaded asset data configuration
- `GeniusPdfLoggerConfig` - Logger configuration (enabled, minLevel, useConsole, etc.)
- `GeniusPdfLoggerAccess` - Logger access wrapper for convenient method access

### Changed

- **Deprecated Direct Access** - `GeniusPdfAssets.initialize()` and `GeniusPdfLogger.configure()` are now deprecated. Use `GeniusPdfConfig.initialize()` instead for centralized configuration.
- **Backward Compatibility** - Old code using `GeniusPdfAssets` and `GeniusPdfLogger` directly will continue to work.

### Example

```dart
// Before (v2.1.0 - Multiple initialization calls)
await GeniusPdfAssets.initialize(
  fontPaths: GeniusPdfFontPaths(primaryFont: 'assets/fonts/din.ttf'),
);
GeniusPdfLogger.enable();
GeniusPdfConfig.initialize(
  baseFont: PdfTrueTypeFont(GeniusPdfAssets.instance.primaryFont, 12),
);

// After (v2.1.1 - Single centralized initialization)
await GeniusPdfConfig.initialize(
  baseFont: PdfTrueTypeFont(fontData, 12),
  assetPaths: GeniusPdfAssetPaths(
    fontPaths: GeniusPdfFontPaths(primaryFont: 'assets/fonts/din.ttf'),
    brandingPaths: GeniusPdfBrandingPaths(logo: 'assets/images/logo.png'),
  ),
  loggerConfig: GeniusPdfLoggerConfig(
    enabled: true,
    useConsole: true,
    minLevel: GeniusLogLevel.info,
  ),
);

// Access assets and logger through config
final font = GeniusPdfConfig.assets.primaryFont;
GeniusPdfConfig.logger.info('PDF generation started');
```

---

## [2.1.0] - 2026-01-24

### Added

#### AI-Powered Features
This release introduces intelligent features for PDF creation and analysis.

##### Content Analysis (`GeniusPdfContentAnalyzer`)
- **Text Extraction** - Extract text content from PDF documents
- **Document Classification** - Automatically detect document types (invoice, report, letter, contract, etc.)
- **Language Detection** - Detect languages used in the document with RTL support
- **Keyword Extraction** - Extract important keywords from content
- **Structured Data Extraction**:
  - Dates (multiple formats, Arabic and English)
  - Monetary amounts (SAR, USD, EUR, GBP)
  - Email addresses
  - Phone numbers
  - Reference numbers (invoice, order, etc.)
- **Metadata Extraction** - Extract document metadata

##### Smart Layout Engine (`GeniusSmartLayoutEngine`)
- **Font Size Analysis** - Suggests optimal font sizes based on content density
- **Margin Optimization** - Smart margin suggestions for print or screen
- **Spacing Analysis** - Optimal spacing between elements
- **Column Layout** - Suggests single or multi-column layouts
- **Color Scheme Suggestions** - Document-type-based color schemes
- **Print Optimization** - Settings for professional print output
- **RTL Support** - Full RTL layout support

##### Smart Text Services (`GeniusSmartTextServices`)
- **Text Summarization** - Summarize long documents with key points extraction
- **Language Detection** - Detect primary language with confidence scores
- **Smart Title Generation** - Generate document titles based on content
- **Keyword Extraction** - Extract relevant keywords from text
- **RTL Detection** - Automatically detect RTL text

##### Smart Image Optimizer (`GeniusSmartImageOptimizer`)
- **Image Analysis** - Analyze image dimensions and quality
- **Optimization Recommendations** - Smart suggestions for image optimization
- **Size Calculation** - Calculate optimal image sizes for PDF
- **Format Suggestions** - Recommend best image format for use case
- **Print vs Screen** - Different optimization for print and screen

### Example
```dart
// Analyze PDF content
final analyzer = GeniusPdfContentAnalyzer();
final result = await analyzer.analyzeBytes(pdfBytes);
print('Document type: ${result.documentType}');
print('Keywords: ${result.keywords}');

// Smart layout suggestions
final layoutEngine = GeniusSmartLayoutEngine();
final suggestions = layoutEngine.analyzeFontSizes(
  contentLength: 5000,
  pageSize: PdfPageSize.a4,
);

// Text summarization
final textServices = GeniusSmartTextServices();
final summary = textServices.summarize(longText);
final titles = textServices.generateTitles(text);

// Image optimization
final imageOptimizer = GeniusSmartImageOptimizer();
final analysis = await imageOptimizer.analyze(imageBytes);
```

---

## [2.0.9] - 2026-01-24

### Fixed

#### Custom Report Screen
- **custom_report_screen** - Fixed app hanging when generating PDF
  - Changed from PdfStandardFont (Helvetica) to PdfTrueTypeFont for LTR mode
  - Now uses DIN font for LTR and Hacen Tunisia font for RTL
  - Fixed null font being passed to components (v2.0.5+ compatibility)
  - All components now receive proper TrueType fonts
  - Fixed missing const keyword

### Changed
- Custom report generation now works reliably in both LTR and RTL modes

---

## [2.0.8] - 2026-01-24

### Fixed

#### V2 Architecture Demo Screen
- **v2_architecture_demo_screen** - Fixed missing const keyword
- Added comprehensive documentation explaining the screen's purpose:
  - Fluent API for building PDFs
  - Plugin System for extensibility
  - Dependency Injection container
  - Event-driven architecture

### Changed
- Improved code documentation for better developer experience

---

## [2.0.7] - 2026-01-24

### Fixed

#### Template Engine Stability
- **ConditionalElement** - Fixed null check error when condition is null
  - Added safe null handling in `render()` and `calculateHeight()` methods
  - Fixed `toJson()` to handle null condition gracefully
  - Fixed `fromJson()` to provide default condition when missing
- **template_engine_demo_screen** - Fixed missing const keyword causing potential issues

### Changed
- Improved template engine robustness with better null safety handling

---

## [2.0.6] - 2026-01-24

### Added

#### Default Output Path
- **GeniusPdfConfig** - Added `defaultOutputPath` property for setting a default directory for generated PDF files

#### File Opening in Demo Screens
- **job_manager_demo_screen** - Added ability to open generated PDF files directly from the app
  - Files are saved to documents directory
  - Open button appears for completed jobs
- **export_demo_screen** - Added ability to open exported PDF files
  - Files are saved with format-specific names
  - Quick open button after successful export

### Changed
- Updated example app to demonstrate file opening functionality
- Improved user experience with direct file access after generation

---

## [2.0.5] - 2026-01-24

### Changed

#### Font System Improvement

- **GeniusPdfConfig** - Added new font properties for unified font management:
  - `boldFont` - Bold version of the base font
  - `headerFont` - Font for headers and titles
  - `smallFont` - Smaller font for captions and footnotes
- **All Components** - Updated to use fonts from Config exclusively:
  - `GeniusPdfDataGrid` - Now requires `baseFont`/`boldFont`
  - `GeniusPdfInfoBox` - Now requires `baseFont`/`boldFont`
  - `GeniusPdfSummarySection` - Now requires `baseFont`/`boldFont`
  - `GeniusPdfReportHeader` - Now requires `baseFont`/`boldFont`
  - `GeniusPdfRichText` - Now requires `baseFont`/`boldFont`
  - `GeniusPdfBarChart` - Now requires `baseFont`/`boldFont`
  - `GeniusPdfLineChart` - Now requires `baseFont`/`boldFont`
  - `GeniusPdfPieChart` - Now requires `baseFont`/`boldFont`
  - `GeniusPdfAreaChart` - Now requires `baseFont`/`boldFont`
  - `GeniusPdfDigitalSignature` - Now requires `baseFont`/`boldFont`
  - `GeniusPdfWatermark` - Now requires `baseFont`
  - `GeniusPdfTotalBar` - Now requires `baseFont`/`boldFont`
  - `GeniusPdfSignatureArea` - Now requires `baseFont`
  - `GeniusPdfQRCode` - Now requires `baseFont`
  - `GeniusPdfSection` - Now requires `baseFont`/`boldFont`

### Breaking Changes

- **Font Requirement** - All components now require fonts to be provided explicitly. No fallback to Helvetica (which doesn't support Arabic). This ensures proper Arabic text rendering in all PDF components.

### Migration Guide

Before (v2.0.2):
```dart
// Fonts were optional, Helvetica was used as fallback
final grid = GeniusPdfDataGrid(
  columns: [...],
  rows: [...],
);
```

After (v2.0.5):
```dart
// Fonts must be provided
final grid = GeniusPdfDataGrid(
  columns: [...],
  rows: [...],
  baseFont: config.baseFont,  // Required
  boldFont: config.boldFont,  // Optional, falls back to baseFont
);
```

Or use Config:
```dart
GeniusPdfConfig.initialize(
  baseFont: PdfTrueTypeFont(arabicFontData, 10),
  boldFont: PdfTrueTypeFont(arabicBoldFontData, 10),
);

// Then use config fonts in components
final config = GeniusPdfConfig.instance;
final grid = GeniusPdfDataGrid(
  columns: [...],
  rows: [...],
  baseFont: config.baseFont,
  boldFont: config.boldFont,
);
```

---

## [2.0.2] - 2026-01-24

### Added

#### Logging System

- `GeniusPdfLogger` - Centralized logging system for the library
  - Enable/disable logging with `enable()` and `disable()`
  - Multiple log levels: `debug`, `info`, `warning`, `error`, `none`
  - Set minimum log level with `setMinLevel()`
  - Custom log handlers with `addHandler()`
  - Built-in console handler with colored output
  - Log history with configurable size
  - Stream-based logging for reactive listening
  - Quick configuration with `configure()`
- `GeniusLogLevel` - Log level enum (debug, info, warning, error, none)
- `GeniusLogEntry` - Log entry with timestamp, level, message, tag, error, and stack trace
- `GeniusLoggable` mixin - Add logging capabilities to any class

### Features

- **Logging Control** - Enable/disable logging at runtime
- **Level Filtering** - Show only warnings and errors in production
- **Custom Handlers** - Send logs to analytics, files, or external services
- **Log History** - Keep recent logs in memory for debugging
- **Stream Support** - Listen to logs in real-time
- **Colored Console** - Easy-to-read colored console output
- **Class Mixin** - Add logging to your classes with `GeniusLoggable`

---

## [2.0.1] - 2026-01-24

### Fixed

- **Custom Report / Print**: "Invalid argument (The character is not supported by the font.): 1561" when generating or printing with RTL or Arabic content. Helvetica does not support Arabic; the example now loads an Arabic-capable font (Hacen Tunisia) when RTL is enabled and passes `baseFont`/`boldFont` to InfoBox, DataGrid, and Summary. Header draw uses `PdfTextDirection.rightToLeft` for RTL.

## [2.0.0] - 2026-01-23

### Added

#### Plugin System Architecture

- `GeniusPdfPlugin` - Base abstract class for creating plugins
  - Unique ID and versioning support
  - Dependencies management between plugins
  - Priority-based loading order
  - Enable/disable functionality
  - Lifecycle methods (initialize, dispose, onEnable, onDisable)
- `GeniusPluginManager` - Singleton manager for plugins
  - Register and unregister plugins
  - Initialize plugins with dependency resolution
  - Plugin events stream for monitoring
  - Get plugins by ID or type
- `GeniusComponentPlugin` - Base class for component plugins
- `GeniusTemplatePlugin` - Base class for template plugins
- `GeniusExporterPlugin` - Base class for exporter plugins
- `GeniusPluginEvent` - Plugin lifecycle events

#### Dependency Injection

- `GeniusPdfContainer` - Lightweight DI container
  - Singleton registration with `registerSingleton()`
  - Factory registration with `registerFactory()`
  - Lazy singleton registration with `registerLazySingleton()`
  - Async factory registration with `registerAsyncFactory()`
  - Named registrations support
  - Type-safe dependency resolution
- `GeniusServiceLocator` mixin - Easy access to dependencies in classes
- `inject<T>()` - Global function for quick dependency resolution
- `injectAsync<T>()` - Async dependency resolution
- `GeniusDependencyException` - Clear error messages for DI issues

#### Event-Driven Architecture

- `GeniusPdfEventBus` - Centralized event bus
  - Emit events with `emit()` and `emitAsync()`
  - Listen to specific event types with `on<T>()`
  - Register handlers with `handle<T>()`
  - Wait for specific events with `waitFor<T>()`
  - Filter events with `where<T>()`
- `GeniusPdfEvent` - Base class for all events
- Document events: `GeniusDocumentCreatedEvent`, `GeniusDocumentModifiedEvent`, `GeniusDocumentSavedEvent`
- Page events: `GeniusPageAddedEvent`, `GeniusPageRemovedEvent`
- Render events: `GeniusRenderStartedEvent`, `GeniusRenderProgressEvent`, `GeniusRenderCompletedEvent`, `GeniusRenderFailedEvent`
- Export events: `GeniusExportStartedEvent`, `GeniusExportCompletedEvent`
- Template events: `GeniusTemplateLoadedEvent`, `GeniusTemplateAppliedEvent`
- Error events: `GeniusErrorEvent`, `GeniusWarningEvent`
- `GeniusEventEmitter` mixin - Add event capabilities to any class

#### Reactive Streams

- `GeniusPdfReactiveStreams` - Reactive streams for operations
  - Operation progress stream
  - Document state stream
- `GeniusOperationProgress` - Progress tracking with percentage
- `GeniusDocumentState` - Document state tracking
- `GeniusDocumentStatus` - Status enum (creating, editing, rendering, saving, saved, error)

#### Enhanced Fluent API

- `GeniusPdfBuilder` - Chainable PDF document builder
  - Configure with `configure()` and `metadata()`
  - Set page format with `pageFormat()`
  - Enable RTL with `rtl()`
  - Add pages with `addPage()` and `addPages()`
  - Add multi-page content with `addMultiPage()`
  - Build document or bytes with `build()` and `buildBytes()`
- `GeniusDocumentConfig` - Document configuration
- `GeniusPageBuilder` - Fluent page content builder
  - Header, subheader, paragraph
  - Bullet and numbered lists
  - Tables with automatic formatting
  - Dividers and spacers
  - Images and custom widgets
  - Rows and columns
- `GeniusMultiPageBuilder` - Multi-page document builder
  - Custom headers and footers
  - Page number footers
  - Headings and paragraphs
- `GeniusPageContent` - Page content container
- `GeniusMultiPageContent` - Multi-page content container

#### Smart Caching System

- `GeniusPdfCache` - Main caching system
  - Set and get cached values
  - Time-to-live (TTL) support
  - `getOrSet()` - Compute if absent (sync)
  - `getOrCompute()` - Compute if absent (async)
  - Multiple eviction strategies (LRU, LFU, FIFO, Priority)
  - Automatic cleanup with `startAutoCleanup()`
  - Cache statistics with `stats`
- `GeniusCacheStrategy` - Eviction strategies enum
- `GeniusCachePriority` - Priority levels (low, normal, high, critical)
- `GeniusCacheStats` - Cache statistics
- `GeniusFontCache` - Specialized cache for fonts
- `GeniusImageCache` - Specialized cache for images
- `GeniusTemplateCache` - Cache for compiled templates with versioning
- `GeniusObjectPool<T>` - Generic object pool for memory optimization
- `Cacheable` mixin - Add caching support to any class

#### Platform Compatibility

- `GeniusPdfPlatform` - Platform detection utility
  - Platform type detection (Android, iOS, Windows, macOS, Linux, Web)
  - Platform capability checks (`isWeb`, `isMobile`, `isDesktop`)
  - Feature availability checks (`hasFileSystem`, `hasNativePrinting`, `hasSharing`)
  - Platform override for testing
  - Platform-specific configuration
- `GeniusPlatformType` - Platform type enum
- `GeniusPlatformConfig` - Platform configuration
- `GeniusPlatformFileAdapter` - Abstract file operations adapter
- `GeniusMobileFileAdapter` - Mobile platform adapter
- `GeniusDesktopFileAdapter` - Desktop platform adapter
- `GeniusWebFileAdapter` - Web platform adapter
- `GeniusFeatureDetector` - Feature availability detection
- `GeniusPlatformAware` mixin - Add platform awareness to classes

### Features

- **Plugin Architecture** - Extend the library with custom plugins
- **Dependency Injection** - Clean dependency management
- **Event-Driven** - React to document lifecycle events
- **Reactive Streams** - Real-time progress and state updates
- **Fluent API** - Expressive, chainable API for document creation
- **Smart Caching** - Intelligent caching with multiple strategies
- **Platform Support** - Consistent API across Web, Mobile, and Desktop
- **Performance** - Object pooling and lazy loading for efficiency

### Changed

- **Genius branding** - Core classes and components now use the `Genius` prefix (e.g. `GeniusPdfConfig`, `GeniusPdfService`, `GeniusPdfDataGrid`) for consistent branding across the library.

### Breaking Changes

- This is a major version with new architecture. The v1.x API remains available.
- New imports available: `import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'` now includes v2.

---

## [1.5.0] - 2026-01-23

### Added

#### Template Engine

- `PdfTemplateEngine` - Main engine for rendering templates
  - Render templates with variable substitution
  - Support for conditional rendering
  - Loop/iteration support for lists
  - Multi-page layout handling
  - Progress tracking during render
- `TemplateBuilder` - Fluent API for building templates programmatically

#### Template Definition

- `TemplateDefinition` - Complete template structure
  - Template metadata (id, name, version, author)
  - Variable definitions with validation
  - Content elements with header/footer support
  - JSON serialization/deserialization
- `TemplatePageSettings` - Page configuration
- `TemplateMargins` - Margin settings
- `TemplateCategory` - Built-in category constants

#### Template Variables

- `TemplateVariable` - Variable definition with types
  - String, number, currency, date, boolean, list, object, image
  - Factory constructors for each type
  - Default values and validation rules
- `VariableValidation` - Validation rules (min/max, pattern, allowed values)

#### Template Conditions

- `TemplateCondition` - Conditional logic
  - Comparison operators (equals, not equals, greater/less than)
  - String operators (contains, startsWith, endsWith)
  - AND/OR combination support
- `ConditionOperator` - Enum of operators

#### Template Loops

- `TemplateLoop` - List iteration with filtering and sorting
- `TemplateContext` - Rendering context with nested data access

#### Template Elements

- `TextElement` - Static text with RTL support
- `VariableElement` - Variable placeholder with prefix/suffix
- `SpacerElement` - Vertical spacing
- `DividerElement` - Horizontal line/divider
- `ContainerElement` - Element container with styling
- `RowElement` - Horizontal layout with flex support
- `ColumnElement` - Vertical layout
- `LoopElement` - Repeating content for lists
- `ConditionalElement` - If/else rendering
- `TableElement` - Simple table with columns
- `ImageElement` - Image placeholder
- `ElementStyle` - Styling (padding, margin, background, border)

#### Template Registry

- `TemplateRegistry` - Central template management
  - Singleton instance support
  - Search by name, tags, category
  - JSON import/export
- `TemplateLibrary` - Pre-built templates (Invoice, Report, Letter)

### Features

- JSON-based template definition for portability
- Full RTL/LTR support with bilingual labels
- Nested variable access (dot notation)
- Validation before rendering
- Progress callbacks during rendering

---

## [1.4.0] - 2026-01-23

### Added

#### Multi-Format Export

- `GeniusExportFormat` - Supported export formats (PDF/A, PNG, JPEG, HTML, Text)
- `GeniusExportConfiguration` - Configuration for export operations
  - Image quality settings (72-600 DPI)
  - Page range selection
  - Compression options
  - Format-specific settings
- `GeniusExportResult` - Sealed class for export results
  - `GeniusExportSuccess` - Successful export with data and metadata
  - `GeniusExportFailure` - Failed export with error details
- `GeniusExportProgress` - Progress tracking for export operations

#### Export Services

- `GeniusPdfExportService` - Unified export service
  - Export to multiple formats
  - Save to file or return bytes
  - Export to documents directory
  - Export individual pages to images
- `GeniusPdfToImageExporter` - Export PDF pages to PNG/JPEG
  - Configurable image quality (DPI)
  - Page range selection
  - Progress callbacks
- `GeniusPdfToHtmlExporter` - Export PDF to HTML
  - RTL/LTR text detection
  - Responsive CSS styling
  - Optional embedded styles
  - Clean semantic HTML output
- `GeniusPdfToTextExporter` - Export PDF to plain text
  - Text extraction with cleanup
  - Page number markers
  - Layout preservation option

#### Batch Export

- `GeniusBatchExporter` - Export multiple documents
  - Concurrent processing (configurable limit)
  - Progress tracking
  - Stop on error option
- `GeniusBatchExportItem` - Individual batch item configuration
- `GeniusBatchExportResult` - Batch operation results
  - Success/failure counts
  - Duration tracking
  - Success rate calculation

#### Data Models

- `GeniusImageQuality` - Quality presets (low, medium, high, maximum)
- `GeniusPageRange` - Page range specification
  - Single page, from start, to page, custom range

#### Extension Methods

- `PdfDocument.exportTo()` - Quick export to any format
- `PdfDocument.exportToFile()` - Export and save to file
- `PdfDocument.exportToImages()` - Export pages as images
- `PdfDocument.exportToHtml()` - Export to HTML
- `PdfDocument.exportToText()` - Export to plain text
- `List<PdfDocument>.exportAllTo()` - Batch export helper

### Features

- Support for PDF/A long-term archival format
- Image export with quality control (72-600 DPI)
- HTML export with responsive styling
- Plain text extraction with layout options
- Batch processing with concurrency control
- Progress tracking for all export operations
- Bilingual status messages (Arabic/English)
- File size formatting helpers

---

## [1.3.1] - 2026-01-23

### Added

#### GeniusPdfConfig Singleton Pattern

- `GeniusPdfConfig.instance` - Global singleton access to PDF configuration
- `GeniusPdfConfig.instanceOrNull` - Safe access (returns null if not initialized)
- `GeniusPdfConfig.isInitialized` - Check if singleton is initialized
- `GeniusPdfConfig.initialize()` - Initialize the global configuration
- `GeniusPdfConfig.update()` - Update the global configuration
- `GeniusPdfConfig.reset()` - Reset the singleton (useful for testing)

### Features

- Global PDF configuration accessible from anywhere in the app
- Safe initialization with clear error messages
- Ability to update configuration at runtime
- Both singleton and local instance patterns supported

---

## [1.3.0] - 2026-01-23

### Added

#### Financial Report Templates

- `BalanceSheetTemplate` - Balance sheet reports
  - Assets, liabilities, and equity sections
  - Account hierarchy with levels
  - Section totals and grand total
  - Balance verification indicator
  - RTL/LTR support with Arabic/English labels
- `IncomeStatementTemplate` - Income statement (P&L) reports
  - Revenue and expenses sections
  - Gross profit and operating income calculations
  - Tax expense support
  - Profitability ratios (gross margin, net margin)
  - Color-coded profit/loss indicators
- `CashFlowTemplate` - Cash flow statements
  - Operating, investing, and financing activities
  - Net change in cash calculation
  - Cash reconciliation section
  - Color-coded positive/negative cash flows
- `BudgetReportTemplate` - Budget vs actual reports
  - Multiple budget sections
  - Variance calculation (amount and percentage)
  - Color-coded over/under budget indicators
  - Variance summary section
  - Highlighted variance rows

#### Sales Document Templates

- `QuotationTemplate` - Price quotations
  - Customer information
  - Itemized pricing with quantities
  - Tax calculations
  - Validity period
  - Terms and conditions
  - Signature areas (company and customer)
- `PurchaseOrderTemplate` - Purchase orders
  - Vendor information with vendor code
  - Product codes and descriptions
  - Expected delivery date
  - Shipping information section
  - Status badge (Draft, Approved, Sent, etc.)
  - Three signature areas (prepared, approved, received)
- `DeliveryNoteTemplate` - Delivery notes
  - Recipient information
  - Ordered vs delivered quantity comparison
  - Remaining quantity tracking
  - Partial/full delivery status indicator
  - Batch number support
  - Driver and vehicle information
  - Delivery summary section
- `CreditNoteTemplate` - Credit notes
  - Original invoice reference
  - Reason for credit
  - Line items with individual reasons
  - Tax recalculation
  - Credit amount summary
- `DebitNoteTemplate` - Debit notes (alias for CreditNoteTemplate)
  - Same features as credit note with debit styling

#### HR Report Templates

- `PayslipTemplate` - Employee payslips
  - Employee information section
  - Pay period details
  - Earnings breakdown (salary, allowances, overtime)
  - Deductions breakdown (GOSI, tax, etc.)
  - Net pay calculation with color coding
  - Bank account details
  - Computer-generated notice
- `EmployeeReportTemplate` - Employee reports
  - Summary statistics boxes
  - Department summary with counts
  - Employee listing with status
  - Optional salary display
  - Contact information
  - Status indicators (active, on leave, probation)
- `AttendanceReportTemplate` - Attendance reports
  - Overall summary statistics
  - Employee attendance summary table
  - Present/absent/late/leave counts
  - Working hours and overtime tracking
  - Attendance rate percentage
  - Optional daily details view
- `LeaveReportTemplate` - Leave reports
  - Overview statistics (total, pending, approved)
  - Leave balance table
  - Leave requests table
  - Leave type breakdown with visual bars
  - Entitlement and carry forward tracking

#### Data Models

- Balance sheet models: `BalanceSheetItem`, `BalanceSheetSection`, `BalanceSheetData`
- Income statement models: `IncomeStatementItem`, `IncomeStatementSection`, `IncomeStatementData`
- Cash flow models: `CashFlowItem`, `CashFlowSection`, `CashFlowData`, `CashFlowActivityType`
- Budget models: `BudgetItem`, `BudgetSection`, `BudgetReportData`
- Quotation models: `QuotationItem`, `QuotationCustomer`, `QuotationData`
- Purchase order models: `PurchaseOrderItem`, `PurchaseOrderVendor`, `ShippingInfo`, `PurchaseOrderData`
- Delivery note models: `DeliveryItem`, `DeliveryRecipient`, `DeliveryNoteData`
- Credit/debit note models: `NoteLineItem`, `NoteParty`, `CreditDebitNoteData`, `NoteType`
- Payslip models: `PayslipEmployee`, `EarningsItem`, `DeductionsItem`, `PayslipData`
- Employee models: `EmployeeRecord`, `DepartmentSummary`, `EmployeeReportData`, `EmployeeStatus`
- Attendance models: `DailyAttendance`, `AttendanceEmployeeSummary`, `AttendanceReportData`, `AttendanceStatus`
- Leave models: `LeaveRecord`, `LeaveBalance`, `LeaveReportData`, `LeaveType`, `LeaveStatus`

### Features

- 13 new report templates covering financial, sales, and HR domains
- Consistent RTL/LTR support across all templates
- Bilingual labels (Arabic/English) for all templates
- Color-coded indicators for positive/negative values
- Status badges and indicators
- Automatic calculations (totals, variances, rates)
- Professional styling with section headers
- Pre-built data models for each template

### Examples

- New templates demo screen with three tabs (Financial, Sales, HR)
- Sample data generation for all new templates
- Home screen updated with new templates section

---

## [1.2.0] - 2026-01-23

### Added

#### Watermarks

- `GeniusPdfWatermark` - Watermark component for PDF documents
  - Text watermarks with customizable font, size, color, and opacity
  - Image watermarks with scaling and positioning
  - Diagonal watermarks across the page
  - Tiled/repeated watermarks for full page coverage
  - Pre-built templates: confidential, draft, copy, cancelled
- `GeniusTextWatermarkSettings` - Text watermark configuration
- `GeniusImageWatermarkSettings` - Image watermark configuration
- `GeniusDiagonalWatermarkSettings` - Diagonal watermark configuration
- `GeniusTiledWatermarkSettings` - Tiled/repeated watermark configuration
- `GeniusWatermarkPosition` - Position options (center, corners, edges, fill)
- `GeniusWatermarkLayer` - Layer options (background, foreground)

#### Security & Encryption

- `GeniusPdfSecuritySettings` - Comprehensive security configuration
  - Password protection (user and owner passwords)
  - Encryption levels: 40-bit RC4, 128-bit RC4, 256-bit AES
  - Document permissions control
  - Metadata encryption
- `GeniusPdfPermissions` - Granular permission controls
  - Print permission (standard and high quality)
  - Copy content permission
  - Modify content permission
  - Add annotations permission
  - Fill forms permission
  - Assemble document permission
  - Accessibility permission
- `GeniusPdfSecurityService` - Security operations service
  - Apply security settings
  - Password protection helpers
  - Remove protection (with owner password)
  - Check if document is protected
  - Change password
- Pre-built security configurations:
  - `GeniusPdfSecuritySettings.passwordProtected()`
  - `GeniusPdfSecuritySettings.readOnly()`
  - `GeniusPdfSecuritySettings.fullProtection()`
  - `GeniusPdfSecuritySettings.printOnly()`
- Pre-built permission sets:
  - `GeniusPdfPermissions.all()`
  - `GeniusPdfPermissions.none()`
  - `GeniusPdfPermissions.readOnly()`
  - `GeniusPdfPermissions.printOnly()`
  - `GeniusPdfPermissions.fillFormsOnly()`
  - `GeniusPdfPermissions.annotateOnly()`

#### Digital Signatures

- `GeniusPdfDigitalSignature` - Digital signature component
  - Visual signature appearance
  - Certificate-based signatures (PKCS#12)
  - Approval and certification signatures
  - Timestamp server support
  - Customizable appearance (name, date, reason, location)
- `GeniusDigitalSignatureSettings` - Signature configuration
- `GeniusSignatureAppearance` - Visual appearance settings
- `GeniusSignatureType` - Approval or certified signature
- `GeniusDigitalSignatureService` - Signature operations
  - Verify signatures
  - Remove signatures
  - Get signature count
- `GeniusSignatureVerificationResult` - Verification results
- `GeniusSignatureInfo` - Signature metadata

### Features

- Document extensions for easy watermark and security application
- Page-level watermark application
- Selective page watermarking (specific pages)
- Multiple watermark support per document
- RTL/LTR text support in watermarks
- Opacity and rotation controls for watermarks
- Pre-built watermark templates for common use cases

### Examples

- Watermark demonstrations (text, diagonal, tiled)
- Password protection examples
- Permission configuration examples
- Digital signature examples
- Security demo screen in example app

---

## [1.1.0] - 2026-01-23

### Added

#### Charts and Graphs

- `GeniusPdfBarChart` - Bar chart component for PDF documents
  - Vertical bar charts
  - Horizontal bar charts
  - Stacked bar charts
  - Grouped bar charts
  - Customizable bar width, spacing, and corner radius
  - Value labels on bars
  - Gradient support
- `GeniusPdfLineChart` - Line chart component for PDF documents
  - Straight line charts
  - Curved (smooth) line charts
  - Stepped line charts
  - Data point markers
  - Area fill under lines
  - Multiple series support
- `GeniusPdfPieChart` - Pie chart component for PDF documents
  - Standard pie charts
  - Donut charts (with inner radius)
  - Percentage labels
  - Value labels
  - Exploded slices
  - Customizable start angle
- `GeniusPdfAreaChart` - Area chart component for PDF documents
  - Overlapping area charts
  - Stacked area charts
  - Curved and straight line options
  - Customizable fill opacity
  - Multiple series support

#### Chart Data Models

- `GeniusChartDataPoint` - Individual data point with label and value
- `GeniusChartSeries` - Data series with multiple points
- `GeniusChartAxis` - Axis configuration (title, min, max, divisions, grid lines)
- `GeniusChartLegend` - Legend configuration (position, orientation, icon size)
- `GeniusChartStyle` - Chart styling (colors, fonts, padding, borders)
- `GeniusChartColors` - Pre-defined color palettes (default, blue, green, warm)

#### Chart Settings

- `GeniusBarChartSettings` - Bar chart specific settings
- `GeniusLineChartSettings` - Line chart specific settings
- `GeniusPieChartSettings` - Pie chart specific settings
- `GeniusAreaChartSettings` - Area chart specific settings

#### Enums

- `GeniusBarChartType` - vertical, horizontal, stacked, grouped
- `GeniusLineChartType` - straight, curved, stepped
- `GeniusPieLabelPosition` - inside, outside, none
- `GeniusChartLegendPosition` - top, bottom, left, right
- `GeniusChartLegendOrientation` - horizontal, vertical

### Features

- Full RTL/LTR support for chart labels and legends
- Bilingual labels (Arabic/English) for all chart elements
- Automatic axis scaling with nice round numbers
- Grid lines with customizable colors
- Multiple color palettes for data visualization
- Classic, modern, and dark chart styles

### Examples

- Bar chart demonstrations (all types)
- Line chart demonstrations (all types)
- Pie and donut chart examples
- Area chart examples (overlapping and stacked)
- Combined charts in reports

---

## [1.0.0] - 2026-01-22

### Added

#### Core

- `GeniusPdfDocumentBuilder` - Abstract base class for building PDF documents
- `GeniusPdfConfig` - Configuration class for PDF settings with RTL/LTR support
- `GeniusPdfAssets` - Centralized asset management for fonts and images
- `GeniusPdfService` - Service for PDF generation, saving, sharing, and printing
- `GeniusPdfResult` - Sealed class for type-safe result handling (Success/Failure)
- `GeniusPdfImage` - Image model with scaling capabilities
- `GeniusPdfPageSize` - Pre-defined page sizes (A4, A3, Letter, Legal)

#### PDF Generation Manager

- `GeniusPdfGenerationManager` - Job queue management for PDF generation
- `GeniusPdfJob` - Represents a PDF generation job with status tracking
- `GeniusPdfJobStatus` - Job states (queued, processing, completed, failed, cancelled)
- `GeniusPdfJobPriority` - Priority levels (low, normal, high, urgent)
- Background/foreground execution support
- Concurrent job processing with configurable limits
- Progress tracking and callbacks
- Batch job processing
- Automatic cleanup of completed jobs

#### Components

- `GeniusPdfDataGrid` - Professional data tables with RTL support
  - Custom column definitions (text, numeric, currency)
  - Header rows with bilingual support
  - Alternating row colors
  - Group headers and totals
  - Automatic pagination
- `GeniusPdfRichText` - Styled text with multiple formats
  - Multiple colors and fonts
  - Clickable links
  - Bold/italic/underline support
  - Positive (green) and negative (red) amounts
- `GeniusPdfRichTextBuilder` - Fluent API for building rich text
- `GeniusPdfInfoBox` - Information boxes for grouped content
  - Multiple style options (card, highlighted, headerContent)
  - Bilingual title support
- `GeniusPdfDualInfoBox` - Two info boxes side by side
- `GeniusPdfReportHeader` - Professional report headers
  - Company logo and information
  - Bilingual titles (Arabic/English)
  - Multiple layout options (standard, compact, centered, invoice)
  - Print date display
- `GeniusPdfSummarySection` - Totals and calculations display
  - Subtotals and grand totals
  - Tax calculations
  - Customizable alignment
- `GeniusPdfTotalBar` - Highlighted total display bar
- `GeniusPdfSignatureArea` - Signature areas with date fields
- `GeniusPdfQRCode` - QR code display for invoices
- `GeniusPdfLabeledValue` - Key-value pair display
- `GeniusPdfKeyValueList` - Multiple key-value pairs
- `GeniusPdfSection` - Bordered sections for grouping

#### Styling System

- `GeniusPdfTextStyle` - Text styling (title, header, subtitle, body, caption)
- `GeniusPdfCellStyle` - Cell styling for grids
- `GeniusPdfBorderStyle` - Border configuration (all, none, horizontal, vertical)
- `GeniusPdfCellPadding` - Padding configuration
- `GeniusPdfGridStyle` - Grid appearance (classic, modern)
- `GeniusPdfInfoBoxStyle` - Info box styling
- `GeniusPdfReportHeaderStyle` - Header styling (classic, modern)
- `GeniusPdfSummaryStyle` - Summary section styling
- `GeniusPdfColorScheme` - Pre-defined color schemes (default, professional, saudi)

#### Report Templates

- `TaxInvoiceTemplate` - ZATCA-compliant tax invoices
  - Customer and company information boxes
  - Line items table with totals
  - VAT calculations and breakdown
  - Amount in words (Arabic/English)
  - QR code and signature areas
- `TrialBalanceTemplate` - Trial balance financial reports
  - Categorized account listings
  - Debit and credit columns
  - Category subtotals
  - Grand total row
- `CustomerStatementTemplate` - Customer account statements
  - Transaction history with running balance
  - Opening and closing balances
  - Aging analysis table
  - Signature area
- `InventoryReportTemplate` - Inventory valuation reports
  - Items grouped by category
  - Quantity, cost, and total value
  - Category subtotals
  - Grand total

#### Preview Widgets

- `GeniusPdfPreviewPage` - Full-screen preview with actions
- `GeniusPdfPreviewWidget` - Embeddable preview widget
- `GeniusPdfFilePreviewPage` - Load and preview from file path
- `GeniusPdfPreviewDialog` - Modal dialog preview

#### Extensions

- `ColorToPdfExtension` - Convert Flutter colors to PDF colors
- `PdfColorUtilities` - Lighter/darker color variants
- `PdfDateTimeExtension` - Date/time formatting for PDFs

### Features

- Full RTL/LTR text direction support
- Bilingual support throughout (Arabic/English)
- Background processing with isolates
- Fluent API for document construction
- Header and footer templates
- Automatic page management
- Job queue with priority management
- Progress tracking and callbacks
- Comprehensive documentation

### Examples

- Complete example project with all use cases
- Tax invoice generation
- Trial balance reports
- Customer statements
- Inventory reports
- Data grid demonstrations
- Rich text examples
- Component showcase
