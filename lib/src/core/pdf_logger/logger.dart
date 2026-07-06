part of '../pdf_logger.dart';

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
  static void addHandler(GeniusLogHandler handler) => _handlers.add(handler);

  /// Remove a custom log handler.
  static void removeHandler(GeniusLogHandler handler) =>
      _handlers.remove(handler);

  /// Clear all custom handlers.
  static void clearHandlers() => _handlers.clear();

  /// Add the built-in console handler.
  static void useConsoleHandler({bool colored = true}) {
    addHandler((entry) {
      final formatted = entry.format(
          showLocation: _showLocation, showTimestamp: _showTimestamp);
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
  static void warning(String message,
      {String? tag, Map<String, dynamic>? data}) {
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
  static void stopTimer(String name,
      {String? tag, GeniusLogLevel level = GeniusLogLevel.info}) {
    if (!_enabled) return;
    final sw = _timers.remove(name);
    if (sw == null) return;
    sw.stop();
    _log(level, '$name completed', tag: tag, duration: sw.elapsed);
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
