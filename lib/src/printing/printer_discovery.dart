/// Printer Discovery Service
///
/// Discovers available printers on the network and system.
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

  GeniusPrinterDiscovery._();

  /// Creates a new instance (for testing)
  factory GeniusPrinterDiscovery() => instance;
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
}
