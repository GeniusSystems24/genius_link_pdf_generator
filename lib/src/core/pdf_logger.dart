/// PDF Logger
///
/// Comprehensive logging system for the Genius Link PDF Generator library.
///
/// ## Features
/// - **Source Location Tracking** — automatically captures file path and
///   line number so you can click-to-navigate in IDE/console.
/// - **Enable/Disable** — zero cost when disabled (early return, no StackTrace parsing).
/// - **Multiple Log Levels** — debug, info, warning, error.
/// - **Colored Console Output** — ANSI color codes for terminal clarity.
/// - **History** — keep recent log entries for inspection.
/// - **Stream** — listen to log events in real-time.
/// - **Custom Handlers** — add your own log destinations.
/// - **Stopwatch** — time operations with `startTimer` / `stopTimer`.
///
/// ## Usage
/// ```dart
/// final config = await GeniusPdfConfig.create(
///   baseFont: myFont,
///   loggerConfig: GeniusPdfLoggerConfig(
///     enabled: true,
///     useConsole: true,
///   ),
/// );
///
/// // Logs show: [INFO] [PrinterService] Printing "Invoice.pdf"
/// //            → lib/src/printing/printer_service.dart:154
/// ```
///
/// @see [GeniusPdfConfig] for configuration management.
library;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:genius_link_pdf_generator/src/core/pdf_config.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Configuration
// ─────────────────────────────────────────────────────────────────────────────

/// Configuration for the PDF logger.
///
/// ```dart
/// GeniusPdfLoggerConfig(
///   enabled: true,       // turn on
///   useConsole: true,    // print to console
///   showLocation: true,  // show file:line
///   minLevel: GeniusLogLevel.debug,
/// )
/// ```
class GeniusPdfLoggerConfig {
  const GeniusPdfLoggerConfig({
    this.enabled = false,
    this.minLevel = GeniusLogLevel.debug,
    this.useConsole = false,
    this.coloredConsole = true,
    this.showLocation = true,
    this.showTimestamp = true,
    this.keepHistory = false,
    this.historySize = 100,
  });

  /// Quickly enable full logging.
  const GeniusPdfLoggerConfig.enabled()
      : enabled = true,
        minLevel = GeniusLogLevel.debug,
        useConsole = true,
        coloredConsole = true,
        showLocation = true,
        showTimestamp = true,
        keepHistory = true,
        historySize = 200;

  /// Errors-only configuration.
  const GeniusPdfLoggerConfig.errorsOnly()
      : enabled = true,
        minLevel = GeniusLogLevel.error,
        useConsole = true,
        coloredConsole = true,
        showLocation = true,
        showTimestamp = true,
        keepHistory = false,
        historySize = 100;

  /// Whether logging is enabled.
  final bool enabled;

  /// Minimum log level to output.
  final GeniusLogLevel minLevel;

  /// Whether to use console handler.
  final bool useConsole;

  /// Whether to use ANSI color codes in console.
  final bool coloredConsole;

  /// Whether to show source file:line in output.
  final bool showLocation;

  /// Whether to show timestamp in output.
  final bool showTimestamp;

  /// Whether to keep log history in memory.
  final bool keepHistory;

  /// Maximum history size.
  final int historySize;
}

// ─────────────────────────────────────────────────────────────────────────────
// Log Level
// ─────────────────────────────────────────────────────────────────────────────

/// Log levels for the PDF generator library.
enum GeniusLogLevel {
  /// Detailed information for debugging.
  debug,

  /// General information messages.
  info,

  /// Potential issues worth noting.
  warning,

  /// Errors that occurred.
  error,

  /// Disable all logging.
  none,
}

// ─────────────────────────────────────────────────────────────────────────────
// Source Location
// ─────────────────────────────────────────────────────────────────────────────

/// Represents a source code location (file + line).
class GeniusSourceLocation {
  const GeniusSourceLocation({
    required this.file,
    required this.line,
    this.function_,
  });

  /// The file path (relative to project root).
  final String file;

  /// The line number.
  final int line;

  /// The function/method name (if available).
  final String? function_;

  /// IDE-clickable format: `file_path:line_number`.
  @override
  String toString() => '$file:$line';
}

// ─────────────────────────────────────────────────────────────────────────────
// Log Entry
// ─────────────────────────────────────────────────────────────────────────────

/// A single log entry with all associated information.
class GeniusLogEntry {
  GeniusLogEntry({
    required this.timestamp,
    required this.level,
    required this.message,
    this.tag,
    this.location,
    this.error,
    this.stackTrace,
    this.duration,
    this.data,
  });

  /// When the log was created.
  final DateTime timestamp;

  /// Log severity level.
  final GeniusLogLevel level;

  /// The log message.
  final String message;

  /// Category tag (e.g. "PrinterService", "PdfExport").
  final String? tag;

  /// Source code location where the log was created.
  final GeniusSourceLocation? location;

  /// Optional error object.
  final Object? error;

  /// Optional stack trace.
  final StackTrace? stackTrace;

  /// Optional duration for timed operations.
  final Duration? duration;

  /// Optional structured data attached to the log.
  final Map<String, dynamic>? data;

  /// Level name as short string.
  String get levelName {
    switch (level) {
      case GeniusLogLevel.debug:
        return 'DEBUG';
      case GeniusLogLevel.info:
        return 'INFO';
      case GeniusLogLevel.warning:
        return 'WARN';
      case GeniusLogLevel.error:
        return 'ERROR';
      case GeniusLogLevel.none:
        return '';
    }
  }

  /// Level emoji for quick visual scanning.
  String get levelIcon {
    switch (level) {
      case GeniusLogLevel.debug:
        return '🔍';
      case GeniusLogLevel.info:
        return '📋';
      case GeniusLogLevel.warning:
        return '⚠️';
      case GeniusLogLevel.error:
        return '❌';
      case GeniusLogLevel.none:
        return '';
    }
  }

  /// Formatted timestamp `HH:mm:ss.SSS`.
  String get formattedTimestamp {
    return '${_p(timestamp.hour)}:${_p(timestamp.minute)}:'
        '${_p(timestamp.second)}.${timestamp.millisecond.toString().padLeft(3, '0')}';
  }

  String _p(int v) => v.toString().padLeft(2, '0');

  /// Full formatted string for console output.
  String format({bool showLocation = true, bool showTimestamp = true}) {
    final buf = StringBuffer();
    if (showTimestamp) buf.write('[$formattedTimestamp] ');
    buf.write('[$levelName]');
    if (tag != null) buf.write(' [$tag]');
    buf.write(' $message');
    if (duration != null) buf.write(' (${duration!.inMilliseconds}ms)');
    if (data != null && data!.isNotEmpty) buf.write(' $data');
    if (showLocation && location != null) {
      buf.write('\n    → ${location!}');
    }
    if (error != null) buf.write('\n    Error: $error');
    if (stackTrace != null) buf.write('\n    StackTrace: $stackTrace');
    return buf.toString();
  }

  @override
  String toString() => format();
}

/// Custom log handler function type.
typedef GeniusLogHandler = void Function(GeniusLogEntry entry);

// ─────────────────────────────────────────────────────────────────────────────
// Main Logger
// ─────────────────────────────────────────────────────────────────────────────

/// Global logger for the Genius Link PDF Generator library.
///
/// Access through [GeniusPdfConfig.logger] or call static methods directly.
///
/// ```dart
/// GeniusPdfLogger.enable();
/// GeniusPdfLogger.info('Generating PDF', tag: 'PdfService');
/// // Output:
/// // [14:30:05.123] [INFO] [PdfService] Generating PDF
/// //     → lib/src/services/pdf_service.dart:42
/// ```
class GeniusPdfLogger {
  GeniusPdfLogger._();

  // ─── State ──────────────────────────────────────────────────────────

  static bool _enabled = false;
  static GeniusLogLevel _minLevel = GeniusLogLevel.debug;
  static bool _showLocation = true;
  static bool _showTimestamp = true;
  static bool _keepHistory = false;
  static int _maxHistorySize = 100;

  static final List<GeniusLogHandler> _handlers = [];
  static final List<GeniusLogEntry> _history = [];
  static final Map<String, Stopwatch> _timers = {};
  static final StreamController<GeniusLogEntry> _streamController =
      StreamController<GeniusLogEntry>.broadcast();

  // ─── Configuration ──────────────────────────────────────────────────

  /// Whether logging is enabled.
  static bool get isEnabled => _enabled;

  /// Current minimum log level.
  static GeniusLogLevel get minLevel => _minLevel;

  /// Enable logging.
  static void enable() => _enabled = true;

  /// Disable logging.
  static void disable() => _enabled = false;

  /// Set the minimum log level.
  static void setMinLevel(GeniusLogLevel level) => _minLevel = level;

  /// Configure the logger from a [GeniusPdfLoggerConfig].
  static void configure({
    bool? enabled,
    GeniusLogLevel? minLevel,
    bool useConsole = false,
    bool coloredConsole = true,
    bool showLocation = true,
    bool showTimestamp = true,
    bool keepHistory = false,
    int historySize = 100,
  }) {
    if (enabled != null) _enabled = enabled;
    if (minLevel != null) _minLevel = minLevel;
    _showLocation = showLocation;
    _showTimestamp = showTimestamp;
    if (useConsole) useConsoleHandler(colored: coloredConsole);
    if (keepHistory) enableHistory(maxSize: historySize);
  }

  /// Configure from a [GeniusPdfLoggerConfig] object.
  static void configureFrom(GeniusPdfLoggerConfig config) {
    configure(
      enabled: config.enabled,
      minLevel: config.minLevel,
      useConsole: config.useConsole,
      coloredConsole: config.coloredConsole,
      showLocation: config.showLocation,
      showTimestamp: config.showTimestamp,
      keepHistory: config.keepHistory,
      historySize: config.historySize,
    );
  }

  // ─── Handlers ───────────────────────────────────────────────────────

  /// Add a custom log handler.
  static void addHandler(GeniusLogHandler handler) =>
      _handlers.add(handler);

  /// Remove a custom log handler.
  static void removeHandler(GeniusLogHandler handler) =>
      _handlers.remove(handler);

  /// Clear all custom handlers.
  static void clearHandlers() => _handlers.clear();

  /// Add the built-in console handler.
  static void useConsoleHandler({bool colored = true}) {
    addHandler((entry) {
      final formatted =
          entry.format(showLocation: _showLocation, showTimestamp: _showTimestamp);
      if (colored) {
        final color = _ansi(entry.level);
        const reset = '\x1B[0m';
        // ignore: avoid_print
        print('$color$formatted$reset');
      } else {
        // ignore: avoid_print
        print(formatted);
      }
    });
  }

  static String _ansi(GeniusLogLevel level) {
    switch (level) {
      case GeniusLogLevel.debug:
        return '\x1B[90m'; // Gray
      case GeniusLogLevel.info:
        return '\x1B[36m'; // Cyan
      case GeniusLogLevel.warning:
        return '\x1B[33m'; // Yellow
      case GeniusLogLevel.error:
        return '\x1B[31m'; // Red
      case GeniusLogLevel.none:
        return '';
    }
  }

  // ─── History ────────────────────────────────────────────────────────

  /// Enable log history.
  static void enableHistory({int maxSize = 100}) {
    _keepHistory = true;
    _maxHistorySize = maxSize;
  }

  /// Disable log history and clear it.
  static void disableHistory() {
    _keepHistory = false;
    _history.clear();
  }

  /// Get immutable copy of log history.
  static List<GeniusLogEntry> get history => List.unmodifiable(_history);

  /// Clear log history.
  static void clearHistory() => _history.clear();

  /// Get a stream of log entries.
  static Stream<GeniusLogEntry> get stream => _streamController.stream;

  // ─── Logging Methods ────────────────────────────────────────────────

  /// Log a debug message.
  static void debug(String message, {String? tag, Map<String, dynamic>? data}) {
    if (!_enabled) return;
    _log(GeniusLogLevel.debug, message, tag: tag, data: data);
  }

  /// Log an info message.
  static void info(String message, {String? tag, Map<String, dynamic>? data}) {
    if (!_enabled) return;
    _log(GeniusLogLevel.info, message, tag: tag, data: data);
  }

  /// Log a warning message.
  static void warning(String message, {String? tag, Map<String, dynamic>? data}) {
    if (!_enabled) return;
    _log(GeniusLogLevel.warning, message, tag: tag, data: data);
  }

  /// Log an error message.
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    if (!_enabled) return;
    _log(GeniusLogLevel.error, message,
        tag: tag, error: error, stackTrace: stackTrace, data: data);
  }

  /// Log with explicit level.
  static void log(
    GeniusLogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    if (!_enabled) return;
    _log(level, message,
        tag: tag, error: error, stackTrace: stackTrace, data: data);
  }

  // ─── Timers ─────────────────────────────────────────────────────────

  /// Start a named timer. Call [stopTimer] with the same [name] to log duration.
  static void startTimer(String name) {
    if (!_enabled) return;
    _timers[name] = Stopwatch()..start();
  }

  /// Stop a named timer and log its duration.
  static void stopTimer(String name, {String? tag, GeniusLogLevel level = GeniusLogLevel.info}) {
    if (!_enabled) return;
    final sw = _timers.remove(name);
    if (sw == null) return;
    sw.stop();
    _log(level, '$name completed',
        tag: tag, duration: sw.elapsed);
  }

  // ─── Internal ───────────────────────────────────────────────────────

  static void _log(
    GeniusLogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
    Duration? duration,
  }) {
    if (level.index < _minLevel.index) return;

    // Extract caller location from StackTrace
    GeniusSourceLocation? location;
    if (_showLocation) {
      location = _extractCallerLocation();
    }

    final entry = GeniusLogEntry(
      timestamp: DateTime.now(),
      level: level,
      message: message,
      tag: tag,
      location: location,
      error: error,
      stackTrace: stackTrace,
      duration: duration,
      data: data,
    );

    // History
    if (_keepHistory) {
      _history.add(entry);
      while (_history.length > _maxHistorySize) {
        _history.removeAt(0);
      }
    }

    // Stream
    if (!_streamController.isClosed) {
      _streamController.add(entry);
    }

    // Handlers
    for (final handler in _handlers) {
      try {
        handler(entry);
      } catch (_) {}
    }
  }

  /// Extracts the caller's file:line from [StackTrace.current].
  ///
  /// Walks up the stack to skip internal logger frames and finds
  /// the first frame that belongs to the library (or caller).
  static GeniusSourceLocation? _extractCallerLocation() {
    try {
      final trace = StackTrace.current.toString();
      final lines = trace.split('\n');

      // Skip frames belonging to GeniusPdfLogger itself and GeniusLoggable
      for (final line in lines) {
        // Skip empty lines and logger frames
        if (line.isEmpty) continue;
        if (line.contains('pdf_logger.dart')) continue;
        if (line.contains('GeniusPdfLogger')) continue;
        if (line.contains('GeniusLoggable')) continue;
        if (line.contains('GeniusPdfLoggerAccess')) continue;

        // Try to parse: #N   ClassName.method (package:xxx/path.dart:LINE:COL)
        final match = RegExp(
          r'\(package:genius_link_pdf_generator/(.+?):(\d+):\d+\)',
        ).firstMatch(line);
        if (match != null) {
          return GeniusSourceLocation(
            file: 'lib/${match.group(1)!}',
            line: int.parse(match.group(2)!),
          );
        }

        // Try to parse: #N   function (file:///path/lib/xxx.dart:LINE:COL)
        final fileMatch = RegExp(
          r'\(file://.+?/lib/(.+?):(\d+):\d+\)',
        ).firstMatch(line);
        if (fileMatch != null) {
          return GeniusSourceLocation(
            file: 'lib/${fileMatch.group(1)!}',
            line: int.parse(fileMatch.group(2)!),
          );
        }

        // Try simpler format: package:xxx/path.dart LINE:COL
        final simpleMatch = RegExp(
          r'package:genius_link_pdf_generator/(.+?):(\d+)',
        ).firstMatch(line);
        if (simpleMatch != null) {
          return GeniusSourceLocation(
            file: 'lib/${simpleMatch.group(1)!}',
            line: int.parse(simpleMatch.group(2)!),
          );
        }

        // If we found a non-logger frame but couldn't parse it, stop
        if (line.contains('#')) break;
      }
    } catch (_) {}
    return null;
  }

  // ─── Reset / Dispose ────────────────────────────────────────────────

  /// Reset the logger to default settings.
  static void reset() {
    _enabled = false;
    _minLevel = GeniusLogLevel.debug;
    _showLocation = true;
    _showTimestamp = true;
    _handlers.clear();
    _history.clear();
    _keepHistory = false;
    _maxHistorySize = 100;
    _timers.clear();
  }

  /// Dispose resources.
  static void dispose() {
    reset();
    if (!_streamController.isClosed) {
      _streamController.close();
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Logger Access Wrapper
// ─────────────────────────────────────────────────────────────────────────────

/// Wrapper for convenient access through [GeniusPdfConfig.logger].
class GeniusPdfLoggerAccess {
  @internal
  GeniusPdfLoggerAccess();

  void enable() => GeniusPdfLogger.enable();
  void disable() => GeniusPdfLogger.disable();
  bool get isEnabled => GeniusPdfLogger.isEnabled;
  void setMinLevel(GeniusLogLevel level) => GeniusPdfLogger.setMinLevel(level);
  GeniusLogLevel get minLevel => GeniusPdfLogger.minLevel;

  void debug(String message, {String? tag, Map<String, dynamic>? data}) =>
      GeniusPdfLogger.debug(message, tag: tag, data: data);
  void info(String message, {String? tag, Map<String, dynamic>? data}) =>
      GeniusPdfLogger.info(message, tag: tag, data: data);
  void warning(String message, {String? tag, Map<String, dynamic>? data}) =>
      GeniusPdfLogger.warning(message, tag: tag, data: data);
  void error(String message,
          {String? tag,
          Object? error,
          StackTrace? stackTrace,
          Map<String, dynamic>? data}) =>
      GeniusPdfLogger.error(message,
          tag: tag, error: error, stackTrace: stackTrace, data: data);

  void addHandler(GeniusLogHandler handler) =>
      GeniusPdfLogger.addHandler(handler);
  void removeHandler(GeniusLogHandler handler) =>
      GeniusPdfLogger.removeHandler(handler);
  void clearHandlers() => GeniusPdfLogger.clearHandlers();
  void useConsoleHandler({bool colored = true}) =>
      GeniusPdfLogger.useConsoleHandler(colored: colored);

  void enableHistory({int maxSize = 100}) =>
      GeniusPdfLogger.enableHistory(maxSize: maxSize);
  void disableHistory() => GeniusPdfLogger.disableHistory();
  List<GeniusLogEntry> get history => GeniusPdfLogger.history;
  void clearHistory() => GeniusPdfLogger.clearHistory();
  Stream<GeniusLogEntry> get stream => GeniusPdfLogger.stream;

  void startTimer(String name) => GeniusPdfLogger.startTimer(name);
  void stopTimer(String name, {String? tag}) =>
      GeniusPdfLogger.stopTimer(name, tag: tag);

  void configure({
    bool? enabled,
    GeniusLogLevel? minLevel,
    bool useConsole = false,
    bool coloredConsole = true,
    bool showLocation = true,
    bool showTimestamp = true,
    bool keepHistory = false,
    int historySize = 100,
  }) =>
      GeniusPdfLogger.configure(
        enabled: enabled,
        minLevel: minLevel,
        useConsole: useConsole,
        coloredConsole: coloredConsole,
        showLocation: showLocation,
        showTimestamp: showTimestamp,
        keepHistory: keepHistory,
        historySize: historySize,
      );

  void reset() => GeniusPdfLogger.reset();
}

// ─────────────────────────────────────────────────────────────────────────────
// Loggable Mixin
// ─────────────────────────────────────────────────────────────────────────────

/// Mixin that adds logging convenience methods to any class.
///
/// ```dart
/// class MyService with GeniusLoggable {
///   @override
///   String get logTag => 'MyService';
///
///   void doWork() {
///     logInfo('Starting work');
///     // Output: [INFO] [MyService] Starting work
///     //             → lib/src/services/my_service.dart:12
///   }
/// }
/// ```
mixin GeniusLoggable {
  /// Tag to use for all logs from this class.
  String get logTag => runtimeType.toString();

  void logDebug(String message, {Map<String, dynamic>? data}) =>
      GeniusPdfLogger.debug(message, tag: logTag, data: data);

  void logInfo(String message, {Map<String, dynamic>? data}) =>
      GeniusPdfLogger.info(message, tag: logTag, data: data);

  void logWarning(String message, {Map<String, dynamic>? data}) =>
      GeniusPdfLogger.warning(message, tag: logTag, data: data);

  void logError(String message,
          {Object? error, StackTrace? stackTrace, Map<String, dynamic>? data}) =>
      GeniusPdfLogger.error(message,
          tag: logTag, error: error, stackTrace: stackTrace, data: data);

  void logStartTimer(String name) => GeniusPdfLogger.startTimer(name);

  void logStopTimer(String name) =>
      GeniusPdfLogger.stopTimer(name, tag: logTag);
}
