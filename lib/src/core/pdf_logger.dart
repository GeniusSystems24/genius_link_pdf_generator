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

part 'pdf_logger/config.dart';
part 'pdf_logger/models.dart';
part 'pdf_logger/logger.dart';
part 'pdf_logger/access.dart';
part 'pdf_logger/mixin.dart';
