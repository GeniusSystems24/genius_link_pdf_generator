/// Package-owned result for delivery operations such as advanced sharing.
class GeniusPdfDeliveryResult {
  const GeniusPdfDeliveryResult._({
    required this.success,
    this.message,
    this.error,
  });

  const GeniusPdfDeliveryResult.success([String? message])
      : this._(success: true, message: message);

  const GeniusPdfDeliveryResult.failure(Object error, [String? message])
      : this._(success: false, error: error, message: message);

  final bool success;
  final String? message;
  final Object? error;
}
