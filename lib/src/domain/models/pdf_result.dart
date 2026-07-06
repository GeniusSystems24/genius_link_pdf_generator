import 'dart:typed_data';

import '../financial/financial.dart';

/// Result of a PDF generation operation.
///
/// This sealed class represents either a successful PDF generation
/// with the resulting bytes, or a failure with error details.
///
/// ## Example
/// ```dart
/// final result = await pdfService.generate(document);
///
/// switch (result) {
///   case PdfSuccess(:final bytes, :final filePath):
///     print('PDF generated: $filePath');
///     break;
///   case PdfFailure(:final error, :final stackTrace):
///     print('Generation failed: $error');
///     break;
/// }
/// ```
sealed class GeniusPdfResult {
  const GeniusPdfResult();

  /// Whether this result represents a successful generation.
  bool get isSuccess => this is GeniusPdfSuccess;

  /// Whether this result represents a failed generation.
  bool get isFailure => this is GeniusPdfFailure;

  /// Executes [onSuccess] if successful, [onFailure] otherwise.
  T when<T>({
    required T Function(GeniusPdfSuccess success) onSuccess,
    required T Function(GeniusPdfFailure failure) onFailure,
  }) {
    return switch (this) {
      final GeniusPdfSuccess success => onSuccess(success),
      final GeniusPdfFailure failure => onFailure(failure),
    };
  }

  /// Executes [onSuccess] if successful, returns null otherwise.
  T? whenSuccess<T>(T Function(GeniusPdfSuccess success) onSuccess) {
    return isSuccess ? onSuccess(this as GeniusPdfSuccess) : null;
  }

  /// Executes [onFailure] if failed, returns null otherwise.
  T? whenFailure<T>(T Function(GeniusPdfFailure failure) onFailure) {
    return isFailure ? onFailure(this as GeniusPdfFailure) : null;
  }
}

/// Represents a successful PDF generation.
class GeniusPdfSuccess extends GeniusPdfResult {

  /// Creates a successful PDF result.
  const GeniusPdfSuccess({
    required this.bytes,
    required this.fileName,
    this.filePath,
  });
  /// The generated PDF bytes.
  final Uint8List bytes;

  /// The file path where the PDF was saved (if saved).
  final String? filePath;

  /// The file name of the generated PDF.
  final String fileName;

  @override
  String toString() => 'PdfSuccess(fileName: $fileName, filePath: $filePath)';
}

/// Represents a failed PDF generation.
class GeniusPdfFailure extends GeniusPdfResult {

  /// Creates a failed PDF result.
  const GeniusPdfFailure({
    required this.error,
    required this.message,
    this.stackTrace,
  });

  /// Creates a failure from an exception.
  factory GeniusPdfFailure.fromException(Object error, [StackTrace? stackTrace]) {
    return GeniusPdfFailure(
      error: error,
      message: error.toString(),
      stackTrace: stackTrace,
    );
  }

  /// Creates a failure from a [GeniusFinancialValidationResult].
  factory GeniusPdfFailure.fromValidation(GeniusFinancialValidationResult result) {
    return GeniusPdfFailure(
      error: result,
      message: result.errors.isNotEmpty
          ? result.errors.first.message
          : 'Financial validation failed',
    );
  }

  /// The error that caused the failure.
  final Object error;

  /// The stack trace of the error.
  final StackTrace? stackTrace;

  /// A human-readable error message.
  final String message;

  /// Returns the [GeniusFinancialValidationResult] if this failure originated
  /// from financial validation, otherwise null.
  GeniusFinancialValidationResult? get validationResult =>
      error is GeniusFinancialValidationResult
          ? error as GeniusFinancialValidationResult
          : null;

  @override
  String toString() => 'PdfFailure(message: $message)';
}

/// Callback types for PDF generation progress.
typedef PdfGenerationCallback = void Function();
typedef PdfSuccessCallback = void Function(GeniusPdfSuccess result);
typedef PdfErrorCallback = void Function(GeniusPdfFailure failure);
typedef PdfProgressCallback = void Function(double progress);
