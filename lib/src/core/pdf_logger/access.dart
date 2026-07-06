part of '../pdf_logger.dart';

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
