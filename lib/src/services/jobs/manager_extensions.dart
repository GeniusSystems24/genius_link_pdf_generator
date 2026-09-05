part of '../pdf_generation_manager.dart';

/// Extension for easy access to singleton manager.
extension PdfGenerationManagerExtension on GeniusPdfGenerationManager {
  /// Creates a quick job and returns the result.
  ///
  /// This is a convenience method for simple use cases.
  static Future<GeniusPdfResult> quickGenerate({
    required GeniusPdfDocumentBuilder builder,
    required String fileName,
    bool openAfterGenerate = false,
    bool shareAfterGenerate = false,
  }) async {
    final manager = GeniusPdfGenerationManager();

    try {
      return await manager.addJobAndWait(
        builder: builder,
        fileName: fileName,
        autoOpen: openAfterGenerate,
        autoShare: shareAfterGenerate,
      );
    } finally {
      manager.dispose();
    }
  }
}

// ============================================================================
// Job Scheduling Support
// ============================================================================

/// A scheduled PDF job that will be processed at a specific time.
