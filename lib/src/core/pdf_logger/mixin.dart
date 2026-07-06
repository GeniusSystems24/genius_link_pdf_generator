part of '../pdf_logger.dart';

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
          {Object? error,
          StackTrace? stackTrace,
          Map<String, dynamic>? data}) =>
      GeniusPdfLogger.error(message,
          tag: logTag, error: error, stackTrace: stackTrace, data: data);

  void logStartTimer(String name) => GeniusPdfLogger.startTimer(name);

  void logStopTimer(String name) =>
      GeniusPdfLogger.stopTimer(name, tag: logTag);
}
