import 'package:intl/intl.dart';

/// Extension on DateTime for PDF-friendly formatting.
///
/// Provides various date and time formatting methods commonly used
/// in PDF documents like invoices, reports, and receipts.
///
/// ## Example
/// ```dart
/// final now = DateTime.now();
/// print(now.formatDate()); // "2024-01-15"
/// print(now.formatTime()); // "14:30"
/// print(now.formatDateTime()); // "2024-01-15 14:30"
/// ```
extension PdfDateTimeExtension on DateTime {
  /// Formats as date only (yyyy-MM-dd).
  String formatDate([String pattern = 'yyyy-MM-dd']) {
    return DateFormat(pattern).format(this);
  }

  /// Formats as time only (HH:mm).
  String formatTime([String pattern = 'HH:mm']) {
    return DateFormat(pattern).format(this);
  }

  /// Formats as date and time (yyyy-MM-dd HH:mm).
  String formatDateTime([String pattern = 'yyyy-MM-dd HH:mm']) {
    return DateFormat(pattern).format(this);
  }

  /// Formats date in Arabic style (dd/MM/yyyy).
  String formatArabicDate() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  /// Formats date with full month name.
  String formatLongDate([String locale = 'en']) {
    return DateFormat.yMMMMd(locale).format(this);
  }

  /// Formats for PDF document timestamp.
  String formatPdfTimestamp() {
    return DateFormat("yyyy-MM-dd 'at' HH:mm:ss").format(this);
  }

  /// Formats as print timestamp string.
  ///
  /// Returns a string like "Print time: 2024-01-15 14:30" in Arabic.
  String formatPrintTime([String label = 'وقت الطباعة']) {
    return '$label ${formatDate()} ${formatTime()}';
  }
}
