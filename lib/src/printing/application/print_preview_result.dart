/// Package-owned result used by print-preview use cases.
class GeniusPrintPreviewResult {
  const GeniusPrintPreviewResult({
    required this.success,
    this.error,
    this.filePath,
  });

  const GeniusPrintPreviewResult.success({String? filePath})
      : this(success: true, filePath: filePath);

  const GeniusPrintPreviewResult.failure(String error)
      : this(success: false, error: error);

  final bool success;
  final String? error;
  final String? filePath;
}
