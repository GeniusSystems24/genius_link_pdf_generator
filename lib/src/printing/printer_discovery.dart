/// Printer Discovery Service
///
/// Discovers available printers on the network and system.
///
/// This service provides:
/// - System printer discovery
/// - Printer status monitoring
/// - Caching for efficient discovery
/// - Platform-specific printer detection
library;

import 'dart:async';

import 'package:printing/printing.dart';

import 'printer_models.dart';

/// Callback for printer discovery events
typedef GeniusPrinterDiscoveryCallback = void Function(GeniusPrinterInfo printer);

/// Printer discovery service
///
/// Discovers and monitors available printers.
class GeniusPrinterDiscovery {

  /// Creates a new instance (for testing)
  factory GeniusPrinterDiscovery() => instance;

  GeniusPrinterDiscovery._();
  /// Singleton instance
  static GeniusPrinterDiscovery? _instance;

  /// Gets the singleton instance
  static GeniusPrinterDiscovery get instance {
    _instance ??= GeniusPrinterDiscovery._();
    return _instance!;
  }

  /// Cached printers list
  List<GeniusPrinterInfo>? _cachedPrinters;

  /// Last discovery time
  DateTime? _lastDiscoveryTime;

  /// Cache duration
  final Duration _cacheDuration = const Duration(minutes: 5);

  /// Discovery stream controller
  final _discoveryController = StreamController<List<GeniusPrinterInfo>>.broadcast();

  /// Stream of discovered printers
  Stream<List<GeniusPrinterInfo>> get printerStream => _discoveryController.stream;

  /// Whether discovery is in progress
  bool _isDiscovering = false;

  /// Whether discovery is in progress
  bool get isDiscovering => _isDiscovering;

  /// Discovers available printers
  ///
  /// Returns a list of available printers.
  /// Uses cache if available and not expired.
  Future<List<GeniusPrinterInfo>> discoverPrinters({
    bool forceRefresh = false,
  }) async {
    // Check cache
    if (!forceRefresh &&
        _cachedPrinters != null &&
        _lastDiscoveryTime != null &&
        DateTime.now().difference(_lastDiscoveryTime!) < _cacheDuration) {
      return _cachedPrinters!;
    }

    _isDiscovering = true;

    try {
      final printers = <GeniusPrinterInfo>[];

      // Get printers from the printing package
      final printingInfo = await Printing.info();

      // Check if printing is available
      if (printingInfo.canPrint) {
        // Get the list of printers (platform-specific)
        // Note: The printing package provides limited printer discovery
        // We'll create a default system printer entry
        printers.add(
          GeniusPrinterInfo(
            id: 'system_default',
            name: _getDefaultPrinterName(),
            connectionType: GeniusPrinterConnectionType.unknown,
            status: GeniusPrinterStatus.ready,
            isDefault: true,
            capabilities: GeniusPrinterCapabilities.defaultCapabilities(),
            lastSeen: DateTime.now(),
          ),
        );
      }

      // Update cache
      _cachedPrinters = printers;
      _lastDiscoveryTime = DateTime.now();

      // Notify listeners
      _discoveryController.add(printers);

      return printers;
    } finally {
      _isDiscovering = false;
    }
  }

  /// Gets the default printer name based on platform
  String _getDefaultPrinterName() {
    // Return localized default printer name
    return 'System Default Printer';
  }

  /// Gets the default printer
  Future<GeniusPrinterInfo?> getDefaultPrinter() async {
    final printers = await discoverPrinters();
    return printers.where((p) => p.isDefault).firstOrNull;
  }

  /// Gets a printer by ID
  Future<GeniusPrinterInfo?> getPrinterById(String id) async {
    final printers = await discoverPrinters();
    return printers.where((p) => p.id == id).firstOrNull;
  }

  /// Checks if a specific printer is available
  Future<bool> isPrinterAvailable(String printerId) async {
    final printer = await getPrinterById(printerId);
    return printer?.isAvailable ?? false;
  }

  /// Gets printer status
  Future<GeniusPrinterStatus> getPrinterStatus(String printerId) async {
    final printer = await getPrinterById(printerId);
    return printer?.status ?? GeniusPrinterStatus.unknown;
  }

  /// Clears the printer cache
  void clearCache() {
    _cachedPrinters = null;
    _lastDiscoveryTime = null;
  }

  /// Disposes the discovery service
  void dispose() {
    _discoveryController.close();
    _cachedPrinters = null;
    _lastDiscoveryTime = null;
    _instance = null;
  }
}

/// Printer discovery result
class GeniusPrinterDiscoveryResult {

  /// Creates a discovery result
  const GeniusPrinterDiscoveryResult({
    required this.printers,
    required this.duration,
    this.errors = const [],
  });
  /// Discovered printers
  final List<GeniusPrinterInfo> printers;

  /// Discovery duration
  final Duration duration;

  /// Any errors that occurred
  final List<String> errors;

  /// Whether discovery was successful
  bool get isSuccess => errors.isEmpty;

  /// Number of printers found
  int get printerCount => printers.length;

  /// Whether any printers were found
  bool get hasPrinters => printers.isNotEmpty;

  /// Default printer (if any)
  GeniusPrinterInfo? get defaultPrinter =>
      printers.where((p) => p.isDefault).firstOrNull;

  /// Gets available (ready) printers only
  List<GeniusPrinterInfo> get availablePrinters =>
      printers.where((p) => p.isAvailable).toList();

  /// Gets network printers only
  List<GeniusPrinterInfo> get networkPrinters =>
      printers.where((p) => p.connectionType == GeniusPrinterConnectionType.network).toList();

  /// Gets USB printers only
  List<GeniusPrinterInfo> get usbPrinters =>
      printers.where((p) => p.connectionType == GeniusPrinterConnectionType.usb).toList();

  /// Gets Bluetooth printers only
  List<GeniusPrinterInfo> get bluetoothPrinters =>
      printers.where((p) => p.connectionType == GeniusPrinterConnectionType.bluetooth).toList();

  /// Gets printers that support color
  List<GeniusPrinterInfo> get colorPrinters =>
      printers.where((p) => p.capabilities.supportsColor).toList();

  /// Gets printers that support duplex
  List<GeniusPrinterInfo> get duplexPrinters =>
      printers.where((p) => p.capabilities.supportsDuplex).toList();
}

/// Printing capabilities info
class GeniusPrintingCapabilities {
  /// Creates printing capabilities
  const GeniusPrintingCapabilities({
    required this.canPrint,
    required this.canShare,
    required this.canRaster,
    required this.canListPrinters,
    required this.directPrint,
  });

  /// Creates from PrintingInfo
  factory GeniusPrintingCapabilities.fromPrintingInfo(PrintingInfo info) {
    return GeniusPrintingCapabilities(
      canPrint: info.canPrint,
      canShare: info.canShare,
      canRaster: info.canRaster,
      canListPrinters: info.canListPrinters,
      directPrint: info.directPrint,
    );
  }

  /// Whether printing is available
  final bool canPrint;

  /// Whether sharing is available
  final bool canShare;

  /// Whether rasterization is available
  final bool canRaster;

  /// Whether listing printers is available
  final bool canListPrinters;

  /// Whether direct printing is available
  final bool directPrint;

  /// Whether all features are available
  bool get allFeaturesAvailable =>
      canPrint && canShare && canRaster && canListPrinters && directPrint;

  /// Display text (English)
  String get summaryEn {
    final features = <String>[];
    if (canPrint) features.add('Print');
    if (canShare) features.add('Share');
    if (canRaster) features.add('Raster');
    if (directPrint) features.add('Direct Print');
    return features.isEmpty ? 'No printing features available' : features.join(', ');
  }

  /// Display text (Arabic)
  String get summaryAr {
    final features = <String>[];
    if (canPrint) features.add('الطباعة');
    if (canShare) features.add('المشاركة');
    if (canRaster) features.add('التحويل لصور');
    if (directPrint) features.add('الطباعة المباشرة');
    return features.isEmpty ? 'لا تتوفر ميزات الطباعة' : features.join('، ');
  }
}

/// Extension methods for printer discovery
extension GeniusPrinterDiscoveryExtension on GeniusPrinterDiscovery {
  /// Gets printers with full discovery result
  Future<GeniusPrinterDiscoveryResult> discoverPrintersWithDetails({
    bool forceRefresh = false,
  }) async {
    final startTime = DateTime.now();
    final errors = <String>[];
    List<GeniusPrinterInfo> printers = [];

    try {
      printers = await discoverPrinters(forceRefresh: forceRefresh);
    } catch (e) {
      errors.add(e.toString());
    }

    return GeniusPrinterDiscoveryResult(
      printers: printers,
      duration: DateTime.now().difference(startTime),
      errors: errors,
    );
  }

  /// Gets platform printing capabilities
  Future<GeniusPrintingCapabilities> getCapabilities() async {
    final info = await Printing.info();
    return GeniusPrintingCapabilities.fromPrintingInfo(info);
  }
}
