/// Printer Service
///
/// Main service for printing PDF documents with advanced features.
///
/// This service provides:
/// - Print with system dialog or direct printing
/// - PDF to image rasterization
/// - PDF sharing functionality
/// - Print job tracking and management
/// - Multiple copies with collation
/// - Page range selection
library;

import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' show Rect;

import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'printer_models.dart';
import 'printer_discovery.dart';

import '../core/pdf_config.dart';
import '../core/pdf_logger.dart';

part 'printer/models.dart';
part 'printer/service.dart';
part 'printer/extensions.dart';
