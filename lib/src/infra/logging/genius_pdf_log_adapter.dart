import '../../app/contracts/pdf_generation_ports.dart';
import '../../core/pdf_logger.dart';

class GeniusPdfLogAdapter implements GeniusPdfLogPort {
  const GeniusPdfLogAdapter();

  @override
  void info(String message, {String? tag}) =>
      GeniusPdfLogger.info(message, tag: tag);

  @override
  void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      GeniusPdfLogger.error(
        message,
        tag: tag,
        error: error,
        stackTrace: stackTrace,
      );
}
