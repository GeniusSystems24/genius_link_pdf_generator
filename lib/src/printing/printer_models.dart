/// Printer Models
///
/// Data models for printer information and print jobs.
library;

import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart' as sf;

import '../core/pdf_config.dart';

/// Printer connection type
enum GeniusPrinterConnectionType {
  /// USB connected printer
  usb,

  /// Network/WiFi connected printer
  network,

  /// Bluetooth connected printer
  bluetooth,

  /// AirPrint compatible printer (iOS/macOS)
  airPrint,

  /// Cloud printer (Google Cloud Print successor)
  cloud,

  /// Unknown connection type
  unknown,
}

/// Printer status
enum GeniusPrinterStatus {
  /// Printer is ready to print
  ready,

  /// Printer is currently printing
  printing,

  /// Printer is offline or unreachable
  offline,

  /// Printer has an error
  error,

  /// Printer is out of paper
  outOfPaper,

  /// Printer is out of ink/toner
  outOfInk,

  /// Printer is in sleep mode
  sleeping,

  /// Printer status is unknown
  unknown,
}

/// Print job status
enum GeniusPrintJobStatus {
  /// Job is queued and waiting
  queued,

  /// Job is being sent to printer
  sending,

  /// Job is currently printing
  printing,

  /// Job completed successfully
  completed,

  /// Job failed
  failed,

  /// Job was cancelled
  cancelled,

  /// Job is paused
  paused,
}

/// Printer capabilities
class GeniusPrinterCapabilities {

  /// Creates printer capabilities
  const GeniusPrinterCapabilities({
    this.supportsColor = true,
    this.supportsDuplex = false,
    this.supportsCollation = true,
    this.supportsStapling = false,
    this.maxPaperSize,
    this.supportedPaperSizes = const [],
    this.supportedResolutions = const [300, 600],
    this.maxCopies = 999,
    this.supportsBorderless = false,
  });

  /// Default capabilities for unknown printers
  factory GeniusPrinterCapabilities.defaultCapabilities() {
    return const GeniusPrinterCapabilities(
      supportsColor: true,
      supportsDuplex: false,
      supportedPaperSizes: [
        GeniusPaperSize.a4,
        GeniusPaperSize.letter,
        GeniusPaperSize.legal,
      ],
      supportedResolutions: [300, 600],
    );
  }

  /// Full-featured printer capabilities
  factory GeniusPrinterCapabilities.fullFeatured() {
    return const GeniusPrinterCapabilities(
      supportsColor: true,
      supportsDuplex: true,
      supportsCollation: true,
      supportsStapling: true,
      supportsBorderless: true,
      maxPaperSize: GeniusPaperSize.a3,
      supportedPaperSizes: GeniusPaperSize.values,
      supportedResolutions: [300, 600, 1200, 2400],
      maxCopies: 9999,
    );
  }
  /// Whether printer supports color printing
  final bool supportsColor;

  /// Whether printer supports duplex (two-sided) printing
  final bool supportsDuplex;

  /// Whether printer supports collation
  final bool supportsCollation;

  /// Whether printer supports stapling
  final bool supportsStapling;

  /// Maximum paper size supported
  final GeniusPaperSize? maxPaperSize;

  /// Supported paper sizes
  final List<GeniusPaperSize> supportedPaperSizes;

  /// Supported resolutions (DPI)
  final List<int> supportedResolutions;

  /// Maximum copies supported
  final int maxCopies;

  /// Whether printer supports borderless printing
  final bool supportsBorderless;
}

/// Paper size enum
enum GeniusPaperSize {
  /// A3 (297 x 420 mm)
  a3(297, 420, 'A3'),

  /// A4 (210 x 297 mm)
  a4(210, 297, 'A4'),

  /// A5 (148 x 210 mm)
  a5(148, 210, 'A5'),

  /// US Letter (8.5 x 11 in = 216 x 279 mm)
  letter(216, 279, 'Letter'),

  /// US Legal (8.5 x 14 in = 216 x 356 mm)
  legal(216, 356, 'Legal'),

  /// US Tabloid (11 x 17 in = 279 x 432 mm)
  tabloid(279, 432, 'Tabloid'),

  /// Executive (7.25 x 10.5 in = 184 x 267 mm)
  executive(184, 267, 'Executive'),

  /// B4 (250 x 353 mm)
  b4(250, 353, 'B4'),

  /// B5 (176 x 250 mm)
  b5(176, 250, 'B5'),

  /// Envelope DL (110 x 220 mm)
  envelopeDL(110, 220, 'Envelope DL'),

  /// Envelope C5 (162 x 229 mm)
  envelopeC5(162, 229, 'Envelope C5'),

  /// Custom size
  custom(0, 0, 'Custom');

  /// Width in millimeters
  final double widthMm;

  /// Height in millimeters
  final double heightMm;

  /// Display name
  final String displayName;

  const GeniusPaperSize(this.widthMm, this.heightMm, this.displayName);

  /// Width in points (1 point = 1/72 inch)
  double get widthPoints => widthMm * 72 / 25.4;

  /// Height in points
  double get heightPoints => heightMm * 72 / 25.4;

  /// Arabic display name
  String get displayNameAr => switch (this) {
        GeniusPaperSize.a3 => 'A3',
        GeniusPaperSize.a4 => 'A4',
        GeniusPaperSize.a5 => 'A5',
        GeniusPaperSize.letter => 'ليتر',
        GeniusPaperSize.legal => 'ليجال',
        GeniusPaperSize.tabloid => 'تابلويد',
        GeniusPaperSize.executive => 'تنفيذي',
        GeniusPaperSize.b4 => 'B4',
        GeniusPaperSize.b5 => 'B5',
        GeniusPaperSize.envelopeDL => 'ظرف DL',
        GeniusPaperSize.envelopeC5 => 'ظرف C5',
        GeniusPaperSize.custom => 'مخصص',
      };
}

/// Printer information
class GeniusPrinterInfo {

  /// Creates printer information
  const GeniusPrinterInfo({
    required this.id,
    required this.name,
    this.model,
    this.manufacturer,
    this.location,
    this.connectionType = GeniusPrinterConnectionType.unknown,
    this.status = GeniusPrinterStatus.unknown,
    this.statusMessage,
    this.capabilities = const GeniusPrinterCapabilities(),
    this.isDefault = false,
    this.networkAddress,
    this.lastSeen,
  });
  /// Unique identifier for the printer
  final String id;

  /// Printer display name
  final String name;

  /// Printer model (if available)
  final String? model;

  /// Printer manufacturer (if available)
  final String? manufacturer;

  /// Printer location (if available)
  final String? location;

  /// Connection type
  final GeniusPrinterConnectionType connectionType;

  /// Current status
  final GeniusPrinterStatus status;

  /// Status message (if any)
  final String? statusMessage;

  /// Printer capabilities
  final GeniusPrinterCapabilities capabilities;

  /// Whether this is the default printer
  final bool isDefault;

  /// Network address (for network printers)
  final String? networkAddress;

  /// Last seen timestamp
  final DateTime? lastSeen;

  /// Creates a copy with modified values
  GeniusPrinterInfo copyWith({
    String? id,
    String? name,
    String? model,
    String? manufacturer,
    String? location,
    GeniusPrinterConnectionType? connectionType,
    GeniusPrinterStatus? status,
    String? statusMessage,
    GeniusPrinterCapabilities? capabilities,
    bool? isDefault,
    String? networkAddress,
    DateTime? lastSeen,
  }) {
    return GeniusPrinterInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      model: model ?? this.model,
      manufacturer: manufacturer ?? this.manufacturer,
      location: location ?? this.location,
      connectionType: connectionType ?? this.connectionType,
      status: status ?? this.status,
      statusMessage: statusMessage ?? this.statusMessage,
      capabilities: capabilities ?? this.capabilities,
      isDefault: isDefault ?? this.isDefault,
      networkAddress: networkAddress ?? this.networkAddress,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  /// Whether the printer is available for printing
  bool get isAvailable =>
      status == GeniusPrinterStatus.ready ||
      status == GeniusPrinterStatus.sleeping;

  /// Status display text (English)
  String get statusTextEn => switch (status) {
        GeniusPrinterStatus.ready => 'Ready',
        GeniusPrinterStatus.printing => 'Printing',
        GeniusPrinterStatus.offline => 'Offline',
        GeniusPrinterStatus.error => statusMessage ?? 'Error',
        GeniusPrinterStatus.outOfPaper => 'Out of Paper',
        GeniusPrinterStatus.outOfInk => 'Out of Ink',
        GeniusPrinterStatus.sleeping => 'Sleeping',
        GeniusPrinterStatus.unknown => 'Unknown',
      };

  /// Status display text (Arabic)
  String get statusTextAr => switch (status) {
        GeniusPrinterStatus.ready => 'جاهزة',
        GeniusPrinterStatus.printing => 'قيد الطباعة',
        GeniusPrinterStatus.offline => 'غير متصلة',
        GeniusPrinterStatus.error => statusMessage ?? 'خطأ',
        GeniusPrinterStatus.outOfPaper => 'نفد الورق',
        GeniusPrinterStatus.outOfInk => 'نفد الحبر',
        GeniusPrinterStatus.sleeping => 'في وضع السكون',
        GeniusPrinterStatus.unknown => 'غير معروف',
      };

  @override
  String toString() => 'GeniusPrinterInfo($name, $status)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeniusPrinterInfo &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Print job information
class GeniusPrintJob {

  /// Creates a print job
  GeniusPrintJob({
    required this.id,
    required this.documentName,
    required this.printerId,
    required this.settings,
    required this.pdfBytes,
    this.status = GeniusPrintJobStatus.queued,
    this.progress = 0.0,
    this.errorMessage,
    DateTime? createdAt,
    this.startedAt,
    this.completedAt,
    this.pageCount,
    this.currentPage,
  }) : createdAt = createdAt ?? DateTime.now();
  /// Unique job identifier
  final String id;

  /// Document name
  final String documentName;

  /// Printer ID
  final String printerId;

  /// Print settings used
  final GeniusPrintSettings settings;

  /// PDF bytes to print
  final Uint8List pdfBytes;

  /// Current status
  GeniusPrintJobStatus status;

  /// Progress (0.0 to 1.0)
  double progress;

  /// Error message (if failed)
  String? errorMessage;

  /// Job creation time
  final DateTime createdAt;

  /// Job start time
  DateTime? startedAt;

  /// Job completion time
  DateTime? completedAt;

  /// Number of pages
  final int? pageCount;

  /// Current page being printed
  int? currentPage;

  /// Job duration (if completed)
  Duration? get duration {
    if (startedAt == null) return null;
    final end = completedAt ?? DateTime.now();
    return end.difference(startedAt!);
  }

  /// Whether the job is still active
  bool get isActive =>
      status == GeniusPrintJobStatus.queued ||
      status == GeniusPrintJobStatus.sending ||
      status == GeniusPrintJobStatus.printing;

  /// Whether the job completed successfully
  bool get isSuccess => status == GeniusPrintJobStatus.completed;

  /// Status display text (English)
  String get statusTextEn => switch (status) {
        GeniusPrintJobStatus.queued => 'Queued',
        GeniusPrintJobStatus.sending => 'Sending to printer',
        GeniusPrintJobStatus.printing => 'Printing',
        GeniusPrintJobStatus.completed => 'Completed',
        GeniusPrintJobStatus.failed => errorMessage ?? 'Failed',
        GeniusPrintJobStatus.cancelled => 'Cancelled',
        GeniusPrintJobStatus.paused => 'Paused',
      };

  /// Status display text (Arabic)
  String get statusTextAr => switch (status) {
        GeniusPrintJobStatus.queued => 'في الانتظار',
        GeniusPrintJobStatus.sending => 'جاري الإرسال للطابعة',
        GeniusPrintJobStatus.printing => 'جاري الطباعة',
        GeniusPrintJobStatus.completed => 'مكتمل',
        GeniusPrintJobStatus.failed => errorMessage ?? 'فشل',
        GeniusPrintJobStatus.cancelled => 'ملغي',
        GeniusPrintJobStatus.paused => 'متوقف مؤقتاً',
      };

  @override
  String toString() => 'GeniusPrintJob($documentName, $status)';
}

/// Print settings (forward declaration - defined in print_settings.dart)
class GeniusPrintSettings {

  /// Creates print settings
  const GeniusPrintSettings({
    this.copies = 1,
    this.paperSize = GeniusPaperSize.a4,
    this.orientation = GeniusPrintOrientation.portrait,
    this.colorMode = GeniusPrintColorMode.color,
    this.quality = GeniusPrintQuality.normal,
    this.duplexMode = GeniusDuplexMode.simplex,
    this.pageRange,
    this.pagesPerSheet = 1,
    this.collate = true,
    this.reverseOrder = false,
    this.fitToPage = true,
    this.scale = 100,
  });

  /// Default print settings
  factory GeniusPrintSettings.defaults() => const GeniusPrintSettings();

  /// Creates print settings based on [GeniusPdfConfig].
  factory GeniusPrintSettings.fromPdfConfig(
    GeniusPdfConfig config, {
    GeniusPrintSettings? base,
  }) {
    final baseSettings = base ?? const GeniusPrintSettings();
    final paperSize = _mapPaperSize(config.pageSize);
    final orientation = config.orientation == sf.PdfPageOrientation.landscape
        ? GeniusPrintOrientation.landscape
        : GeniusPrintOrientation.portrait;

    return baseSettings.copyWith(
      paperSize: paperSize,
      orientation: orientation,
    );
  }

  /// Draft quality settings (fast, low quality)
  factory GeniusPrintSettings.draft() => const GeniusPrintSettings(
        quality: GeniusPrintQuality.draft,
        colorMode: GeniusPrintColorMode.grayscale,
      );

  /// High quality settings
  factory GeniusPrintSettings.highQuality() => const GeniusPrintSettings(
        quality: GeniusPrintQuality.high,
        colorMode: GeniusPrintColorMode.color,
      );

  /// Eco-friendly settings (duplex, grayscale, draft)
  factory GeniusPrintSettings.eco() => const GeniusPrintSettings(
        quality: GeniusPrintQuality.draft,
        colorMode: GeniusPrintColorMode.grayscale,
        duplexMode: GeniusDuplexMode.longEdge,
        pagesPerSheet: 2,
      );
  /// Number of copies
  final int copies;

  /// Paper size
  final GeniusPaperSize paperSize;

  /// Print orientation
  final GeniusPrintOrientation orientation;

  /// Color mode
  final GeniusPrintColorMode colorMode;

  /// Print quality
  final GeniusPrintQuality quality;

  /// Duplex mode
  final GeniusDuplexMode duplexMode;

  /// Page range (null = all pages)
  final GeniusPrintPageRange? pageRange;

  /// Pages per sheet
  final int pagesPerSheet;

  /// Whether to collate copies
  final bool collate;

  /// Print in reverse order
  final bool reverseOrder;

  /// Fit to page
  final bool fitToPage;

  /// Scale percentage (100 = actual size)
  final int scale;

  /// Creates a copy with modified values
  GeniusPrintSettings copyWith({
    int? copies,
    GeniusPaperSize? paperSize,
    GeniusPrintOrientation? orientation,
    GeniusPrintColorMode? colorMode,
    GeniusPrintQuality? quality,
    GeniusDuplexMode? duplexMode,
    GeniusPrintPageRange? pageRange,
    int? pagesPerSheet,
    bool? collate,
    bool? reverseOrder,
    bool? fitToPage,
    int? scale,
  }) {
    return GeniusPrintSettings(
      copies: copies ?? this.copies,
      paperSize: paperSize ?? this.paperSize,
      orientation: orientation ?? this.orientation,
      colorMode: colorMode ?? this.colorMode,
      quality: quality ?? this.quality,
      duplexMode: duplexMode ?? this.duplexMode,
      pageRange: pageRange ?? this.pageRange,
      pagesPerSheet: pagesPerSheet ?? this.pagesPerSheet,
      collate: collate ?? this.collate,
      reverseOrder: reverseOrder ?? this.reverseOrder,
      fitToPage: fitToPage ?? this.fitToPage,
      scale: scale ?? this.scale,
    );
  }
}

GeniusPaperSize _mapPaperSize(Size pageSize) {
  const tolerance = 1.0;

  final normalized = _normalizeSize(pageSize);
  final candidates = <GeniusPaperSize, Size>{
    GeniusPaperSize.a3:
        Size(GeniusPaperSize.a3.widthPoints, GeniusPaperSize.a3.heightPoints),
    GeniusPaperSize.a4:
        Size(GeniusPaperSize.a4.widthPoints, GeniusPaperSize.a4.heightPoints),
    GeniusPaperSize.a5:
        Size(GeniusPaperSize.a5.widthPoints, GeniusPaperSize.a5.heightPoints),
    GeniusPaperSize.letter: Size(
      GeniusPaperSize.letter.widthPoints,
      GeniusPaperSize.letter.heightPoints,
    ),
    GeniusPaperSize.legal:
        Size(GeniusPaperSize.legal.widthPoints, GeniusPaperSize.legal.heightPoints),
    GeniusPaperSize.tabloid: Size(
      GeniusPaperSize.tabloid.widthPoints,
      GeniusPaperSize.tabloid.heightPoints,
    ),
    GeniusPaperSize.executive: Size(
      GeniusPaperSize.executive.widthPoints,
      GeniusPaperSize.executive.heightPoints,
    ),
    GeniusPaperSize.b4:
        Size(GeniusPaperSize.b4.widthPoints, GeniusPaperSize.b4.heightPoints),
    GeniusPaperSize.b5:
        Size(GeniusPaperSize.b5.widthPoints, GeniusPaperSize.b5.heightPoints),
    GeniusPaperSize.envelopeDL: Size(
      GeniusPaperSize.envelopeDL.widthPoints,
      GeniusPaperSize.envelopeDL.heightPoints,
    ),
    GeniusPaperSize.envelopeC5: Size(
      GeniusPaperSize.envelopeC5.widthPoints,
      GeniusPaperSize.envelopeC5.heightPoints,
    ),
  };

  for (final entry in candidates.entries) {
    final candidate = _normalizeSize(entry.value);
    if (_isCloseSize(normalized, candidate, tolerance)) {
      return entry.key;
    }
  }

  return GeniusPaperSize.custom;
}

Size _normalizeSize(Size size) {
  final width = math.min(size.width, size.height);
  final height = math.max(size.width, size.height);
  return Size(width, height);
}

bool _isCloseSize(Size a, Size b, double tolerance) {
  return (a.width - b.width).abs() <= tolerance &&
      (a.height - b.height).abs() <= tolerance;
}

/// Print orientation
enum GeniusPrintOrientation {
  /// Portrait (vertical)
  portrait,

  /// Landscape (horizontal)
  landscape,

  /// Auto-detect based on content
  auto,
}

/// Print color mode
enum GeniusPrintColorMode {
  /// Full color
  color,

  /// Grayscale
  grayscale,

  /// Black and white only
  blackAndWhite,
}

/// Print quality
enum GeniusPrintQuality {
  /// Draft quality (fast, low quality)
  draft,

  /// Normal quality
  normal,

  /// High quality
  high,

  /// Photo quality (highest)
  photo,
}

/// Duplex (two-sided) printing mode
enum GeniusDuplexMode {
  /// Single-sided printing
  simplex,

  /// Two-sided, flip on long edge (like a book)
  longEdge,

  /// Two-sided, flip on short edge (like a notepad)
  shortEdge,
}

/// Page range for printing
class GeniusPrintPageRange {

  /// Creates a page range
  const GeniusPrintPageRange({
    this.start,
    this.end,
    this.pages,
  });

  /// All pages
  factory GeniusPrintPageRange.all() => const GeniusPrintPageRange();

  /// Single page
  factory GeniusPrintPageRange.single(int page) => GeniusPrintPageRange(pages: [page]);

  /// Range of pages (inclusive)
  factory GeniusPrintPageRange.range(int start, int end) =>
      GeniusPrintPageRange(start: start, end: end);

  /// First N pages
  factory GeniusPrintPageRange.first(int count) =>
      GeniusPrintPageRange(start: 1, end: count);

  /// Custom pages (e.g., [1, 3, 5, 7])
  factory GeniusPrintPageRange.custom(List<int> pages) =>
      GeniusPrintPageRange(pages: pages);
  /// Start page (1-indexed)
  final int? start;

  /// End page (1-indexed, inclusive)
  final int? end;

  /// Specific pages to print
  final List<int>? pages;

  /// Whether this includes all pages
  bool get isAll => start == null && end == null && pages == null;

  /// Display text (English)
  String get displayTextEn {
    if (isAll) return 'All pages';
    if (pages != null) return 'Pages: ${pages!.join(", ")}';
    if (start != null && end != null) return 'Pages $start-$end';
    if (start != null) return 'From page $start';
    if (end != null) return 'Up to page $end';
    return 'All pages';
  }

  /// Display text (Arabic)
  String get displayTextAr {
    if (isAll) return 'جميع الصفحات';
    if (pages != null) return 'الصفحات: ${pages!.join("، ")}';
    if (start != null && end != null) return 'الصفحات $start-$end';
    if (start != null) return 'من الصفحة $start';
    if (end != null) return 'حتى الصفحة $end';
    return 'جميع الصفحات';
  }
}
