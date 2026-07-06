part of '../pdf_logger.dart';

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
