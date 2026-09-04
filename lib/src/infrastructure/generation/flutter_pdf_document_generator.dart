import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../application/contracts/pdf_generation_ports.dart';

/// Flutter implementation of PDF generation execution.
///
/// Builders that implement [GeniusPdfBackgroundBuildSource] own their
/// isolate-safe strategy. Legacy builders are attempted with [compute]; when
/// their object graph cannot cross an isolate boundary, generation safely
/// falls back to the current isolate instead of failing the public API.
class FlutterPdfDocumentGenerator implements GeniusPdfDocumentGenerator {
  const FlutterPdfDocumentGenerator();

  @override
  Future<Uint8List> generate(
    GeniusPdfBuildSource builder, {
    required bool runInBackground,
  }) async {
    if (!runInBackground) {
      return Uint8List.fromList(await Future<List<int>>.sync(builder.generate));
    }

    if (builder is GeniusPdfBackgroundBuildSource) {
      return builder.generateInBackground();
    }

    try {
      final bytes = await compute(_generatePdfBytes, builder);
      return Uint8List.fromList(bytes);
    } on Object catch (error) {
      if (!_isIsolateTransferError(error)) rethrow;
      final bytes = await Future<List<int>>.sync(builder.generate);
      return Uint8List.fromList(bytes);
    }
  }
}

List<int> _generatePdfBytes(GeniusPdfBuildSource builder) => builder.generate();

bool _isIsolateTransferError(Object error) {
  final message = error.toString().toLowerCase();
  return message.contains('isolate') &&
      (message.contains('unsendable') ||
          message.contains('illegal argument') ||
          message.contains('sendport') ||
          message.contains('sendable'));
}
