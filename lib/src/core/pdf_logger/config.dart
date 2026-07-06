part of '../pdf_logger.dart';

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
