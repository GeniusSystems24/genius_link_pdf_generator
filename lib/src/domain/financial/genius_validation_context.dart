import 'genius_rounding_policy.dart';

/// Carries rounding configuration into a template's generateResult call.
///
/// If not supplied, the template uses [GeniusRoundingPolicy.defaults()].
class GeniusFinancialValidationContext {
  GeniusFinancialValidationContext({
    GeniusRoundingPolicy? roundingPolicy,
    this.sourceCurrencyPolicy,
    this.documentCurrency = 'SAR',
  }) : roundingPolicy = roundingPolicy ?? GeniusRoundingPolicy.defaults();

  /// Document-currency rounding policy (primary).
  final GeniusRoundingPolicy roundingPolicy;

  /// Source-currency policy for multi-currency documents.
  final GeniusRoundingPolicy? sourceCurrencyPolicy;

  /// ISO 4217 document currency code.
  final String documentCurrency;
}
