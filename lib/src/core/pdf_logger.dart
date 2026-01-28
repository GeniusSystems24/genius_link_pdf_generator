/// PDF Logger
///
/// Use [GeniusPdfConfig.logger] for logging access:
/// ```dart
/// // Create config with logger settings
/// final config = await GeniusPdfConfig.create(
///   baseFont: myFont,
///   loggerConfig: GeniusPdfLoggerConfig(
///     enabled: true,
///     useConsole: true,
///   ),
/// );
///
/// // Access logger (static global service)
/// GeniusPdfConfig.logger.debug('Starting PDF generation');
/// GeniusPdfConfig.logger.info('PDF generated successfully');
/// GeniusPdfConfig.logger.error('Failed', error: e);
/// ```
///
/// @see [GeniusPdfConfig] for configuration management.
library;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:genius_link_pdf_generator/src/core/pdf_config.dart';

// ==================== Logger Configuration Classes ====================

/// Configuration for the PDF logger.
class GeniusPdfLoggerConfig {
  /// Creates a logger configuration.
  const GeniusPdfLoggerConfig({
    this.enabled = false,
    this.minLevel = GeniusLogLevel.debug,
    this.useConsole = false,
    this.coloredConsole = true,
    this.keepHistory = false,
    this.historySize = 100,
  });

  /// Whether logging is enabled.
  final bool enabled;

  /// Minimum log level to output.
  final GeniusLogLevel minLevel;

  /// Whether to use console handler.
  final bool useConsole;

  /// Whether to use colored console output.
  final bool coloredConsole;

  /// Whether to keep log history.
  final bool keepHistory;

  /// Maximum history size.
  final int historySize;
}

/// Logger access wrapper for convenient method access through GeniusPdfConfig.
class GeniusPdfLoggerAccess {
  @internal
  GeniusPdfLoggerAccess();

  /// Enable logging.
  void enable() => GeniusPdfLogger.enable();

  /// Disable logging.
  void disable() => GeniusPdfLogger.disable();

  /// Check if logging is enabled.
  bool get isEnabled => GeniusPdfLogger.isEnabled;

  /// Set the minimum log level.
  void setMinLevel(GeniusLogLevel level) => GeniusPdfLogger.setMinLevel(level);

  /// Get the current minimum log level.
  GeniusLogLevel get minLevel => GeniusPdfLogger.minLevel;

  /// Log a debug message.
  void debug(String message, {String? tag}) =>
      GeniusPdfLogger.debug(message, tag: tag);

  /// Log an info message.
  void info(String message, {String? tag}) =>
      GeniusPdfLogger.info(message, tag: tag);

  /// Log a warning message.
  void warning(String message, {String? tag}) =>
      GeniusPdfLogger.warning(message, tag: tag);

  /// Log an error message.
  void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      GeniusPdfLogger.error(message,
          tag: tag, error: error, stackTrace: stackTrace);

  /// Add a custom log handler.
  void addHandler(GeniusLogHandler handler) =>
      GeniusPdfLogger.addHandler(handler);

  /// Remove a custom log handler.
  void removeHandler(GeniusLogHandler handler) =>
      GeniusPdfLogger.removeHandler(handler);

  /// Clear all custom handlers.
  void clearHandlers() => GeniusPdfLogger.clearHandlers();

  /// Use the console handler.
  void useConsoleHandler({bool colored = true}) =>
      GeniusPdfLogger.useConsoleHandler(colored: colored);

  /// Enable log history.
  void enableHistory({int maxSize = 100}) =>
      GeniusPdfLogger.enableHistory(maxSize: maxSize);

  /// Disable log history.
  void disableHistory() => GeniusPdfLogger.disableHistory();

  /// Get log history.
  List<GeniusLogEntry> get history => GeniusPdfLogger.history;

  /// Clear log history.
  void clearHistory() => GeniusPdfLogger.clearHistory();

  /// Get a stream of log entries.
  Stream<GeniusLogEntry> get stream => GeniusPdfLogger.stream;

  /// Configure the logger.
  void configure({
    bool? enabled,
    GeniusLogLevel? minLevel,
    bool useConsole = false,
    bool coloredConsole = true,
    bool keepHistory = false,
    int historySize = 100,
  }) =>
      GeniusPdfLogger.configure(
        enabled: enabled,
        minLevel: minLevel,
        useConsole: useConsole,
        coloredConsole: coloredConsole,
        keepHistory: keepHistory,
        historySize: historySize,
      );

  /// Reset the logger to default settings.
  void reset() => GeniusPdfLogger.reset();
}

// ==================== Logger Classes ====================

/// Log levels for the PDF generator library
enum GeniusLogLevel {
  /// Debug level - detailed information for debugging
  debug,

  /// Info level - general information messages
  info,

  /// Warning level - potential issues
  warning,

  /// Error level - errors that occurred
  error,

  /// None - disable all logging
  none,
}

/// Log entry containing all log information
class GeniusLogEntry {
  /// Creates a new log entry
  GeniusLogEntry({
    required this.timestamp,
    required this.level,
    required this.message,
    this.tag,
    this.error,
    this.stackTrace,
  });

  /// Timestamp when the log was created
  final DateTime timestamp;

  /// Log level
  final GeniusLogLevel level;

  /// Log message
  final String message;

  /// Optional tag for categorizing logs
  final String? tag;

  /// Optional error object
  final Object? error;

  /// Optional stack trace
  final StackTrace? stackTrace;

  /// String representation of the log level
  String get levelName {
    switch (level) {
      case GeniusLogLevel.debug:
        return 'DEBUG';
      case GeniusLogLevel.info:
        return 'INFO';
      case GeniusLogLevel.warning:
        return 'WARNING';
      case GeniusLogLevel.error:
        return 'ERROR';
      case GeniusLogLevel.none:
        return 'NONE';
    }
  }

  /// Formatted timestamp string
  String get formattedTimestamp {
    return '${timestamp.year}-${_pad(timestamp.month)}-${_pad(timestamp.day)} '
        '${_pad(timestamp.hour)}:${_pad(timestamp.minute)}:${_pad(timestamp.second)}';
  }

  String _pad(int value) => value.toString().padLeft(2, '0');

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('[$formattedTimestamp] ');
    buffer.write('[$levelName] ');
    if (tag != null) {
      buffer.write('[$tag] ');
    }
    buffer.write(message);
    if (error != null) {
      buffer.write('\nError: $error');
    }
    if (stackTrace != null) {
      buffer.write('\nStackTrace: $stackTrace');
    }
    return buffer.toString();
  }
}

/// Custom log handler function type
typedef GeniusLogHandler = void Function(GeniusLogEntry entry);

/// Logger for the Genius PDF Generator library
///
/// **Note**: Access this through [GeniusPdfConfig.logger] for centralized configuration.
///
/// ## Basic Usage
///
/// ```dart
/// // Enable logging through config
/// GeniusPdfConfig.logger.enable();
///
/// // Log messages
/// GeniusPdfConfig.logger.debug('Starting PDF generation');
/// GeniusPdfConfig.logger.info('Page 1 created');
/// GeniusPdfConfig.logger.warning('Large image detected');
/// GeniusPdfConfig.logger.error('Failed to load font', error: e);
///
/// // Disable logging
/// GeniusPdfConfig.logger.disable();
/// ```
class GeniusPdfLogger {
  GeniusPdfLogger._();

  /// Whether logging is enabled
  static bool _enabled = false;

  /// Minimum log level to output
  static GeniusLogLevel _minLevel = GeniusLogLevel.debug;

  /// Custom log handlers
  static final List<GeniusLogHandler> _handlers = [];

  /// Log history (if enabled)
  static final List<GeniusLogEntry> _history = [];

  /// Maximum history size
  static int _maxHistorySize = 100;

  /// Whether to keep log history
  static bool _keepHistory = false;

  /// Stream controller for log events
  static final StreamController<GeniusLogEntry> _streamController =
      StreamController<GeniusLogEntry>.broadcast();

  // ==================== Configuration ====================

  /// Enable logging
  static void enable() {
    _enabled = true;
  }

  /// Disable logging
  static void disable() {
    _enabled = false;
  }

  /// Check if logging is enabled
  static bool get isEnabled => _enabled;

  /// Set the minimum log level
  static void setMinLevel(GeniusLogLevel level) {
    _minLevel = level;
  }

  /// Get the current minimum log level
  static GeniusLogLevel get minLevel => _minLevel;

  /// Enable log history
  static void enableHistory({int maxSize = 100}) {
    _keepHistory = true;
    _maxHistorySize = maxSize;
  }

  /// Disable log history
  static void disableHistory() {
    _keepHistory = false;
    _history.clear();
  }

  /// Get log history
  static List<GeniusLogEntry> get history => List.unmodifiable(_history);

  /// Clear log history
  static void clearHistory() {
    _history.clear();
  }

  /// Get a stream of log entries
  static Stream<GeniusLogEntry> get stream => _streamController.stream;

  // ==================== Handlers ====================

  /// Add a custom log handler
  static void addHandler(GeniusLogHandler handler) {
    _handlers.add(handler);
  }

  /// Remove a custom log handler
  static void removeHandler(GeniusLogHandler handler) {
    _handlers.remove(handler);
  }

  /// Clear all custom handlers
  static void clearHandlers() {
    _handlers.clear();
  }

  /// Set the default console handler
  static void useConsoleHandler({bool colored = true}) {
    addHandler((entry) {
      if (colored) {
        final color = _getColorCode(entry.level);
        const reset = '\x1B[0m';
        // ignore: avoid_print
        print('$color${entry.toString()}$reset');
      } else {
        // ignore: avoid_print
        print(entry.toString());
      }
    });
  }

  static String _getColorCode(GeniusLogLevel level) {
    switch (level) {
      case GeniusLogLevel.debug:
        return '\x1B[37m'; // White
      case GeniusLogLevel.info:
        return '\x1B[34m'; // Blue
      case GeniusLogLevel.warning:
        return '\x1B[33m'; // Yellow
      case GeniusLogLevel.error:
        return '\x1B[31m'; // Red
      case GeniusLogLevel.none:
        return '';
    }
  }

  // ==================== Logging Methods ====================

  /// Log a debug message
  static void debug(String message, {String? tag}) {
    _log(GeniusLogLevel.debug, message, tag: tag);
  }

  /// Log an info message
  static void info(String message, {String? tag}) {
    _log(GeniusLogLevel.info, message, tag: tag);
  }

  /// Log a warning message
  static void warning(String message, {String? tag}) {
    _log(GeniusLogLevel.warning, message, tag: tag);
  }

  /// Log an error message
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      GeniusLogLevel.error,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log a message with a specific level
  static void log(
    GeniusLogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(level, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  static void _log(
    GeniusLogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Check if logging is enabled
    if (!_enabled) return;

    // Check if level is high enough
    if (level.index < _minLevel.index) return;

    // Create log entry
    final entry = GeniusLogEntry(
      timestamp: DateTime.now(),
      level: level,
      message: message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );

    // Add to history if enabled
    if (_keepHistory) {
      _history.add(entry);
      // Trim history if needed
      while (_history.length > _maxHistorySize) {
        _history.removeAt(0);
      }
    }

    // Notify stream listeners
    if (!_streamController.isClosed) {
      _streamController.add(entry);
    }

    // Call handlers
    for (final handler in _handlers) {
      try {
        handler(entry);
      } catch (_) {
        // Ignore handler errors
      }
    }
  }

  // ==================== Convenience ====================

  /// Configure the logger with common settings
  static void configure({
    bool? enabled,
    GeniusLogLevel? minLevel,
    bool useConsole = false,
    bool coloredConsole = true,
    bool keepHistory = false,
    int historySize = 100,
  }) {
    if (enabled != null) {
      _enabled = enabled;
    }
    if (minLevel != null) {
      _minLevel = minLevel;
    }
    if (useConsole) {
      useConsoleHandler(colored: coloredConsole);
    }
    if (keepHistory) {
      enableHistory(maxSize: historySize);
    }
  }

  /// Reset the logger to default settings
  static void reset() {
    _enabled = false;
    _minLevel = GeniusLogLevel.debug;
    _handlers.clear();
    _history.clear();
    _keepHistory = false;
    _maxHistorySize = 100;
  }

  /// Dispose resources
  static void dispose() {
    reset();
    if (!_streamController.isClosed) {
      _streamController.close();
    }
  }
}

/// Mixin to add logging capabilities to any class
///
/// Example:
/// ```dart
/// class MyPdfBuilder with GeniusLoggable {
///   @override
///   String get logTag => 'MyPdfBuilder';
///
///   void build() {
///     logDebug('Starting build');
///     // ...
///     logInfo('Build completed');
///   }
/// }
/// ```
mixin GeniusLoggable {
  /// Tag to use for logs from this class
  String get logTag => runtimeType.toString();

  /// Log a debug message
  void logDebug(String message) {
    GeniusPdfLogger.debug(message, tag: logTag);
  }

  /// Log an info message
  void logInfo(String message) {
    GeniusPdfLogger.info(message, tag: logTag);
  }

  /// Log a warning message
  void logWarning(String message) {
    GeniusPdfLogger.warning(message, tag: logTag);
  }

  /// Log an error message
  void logError(String message, {Object? error, StackTrace? stackTrace}) {
    GeniusPdfLogger.error(message,
        tag: logTag, error: error, stackTrace: stackTrace);
  }
}
