
enum GeniusPdfRegressionDirection {
  enLtr,
  arRtl,
  bilingual,
  thermal,
  label,
}

enum GeniusPdfRegressionSubjectKind {
  component,
  family,
  erpPack,
}

class GeniusPdfGoldenCase {
  const GeniusPdfGoldenCase({
    required this.id,
    required this.subject,
    required this.kind,
    required this.direction,
    this.profile,
    this.notes,
  });

  final String id;
  final String subject;
  final GeniusPdfRegressionSubjectKind kind;
  final GeniusPdfRegressionDirection direction;
  final String? profile;
  final String? notes;
}

/// S24-T08..T15 golden coverage manifest.
///
/// The manifest is renderer-neutral. Test environments decide whether to
/// compare raster output, PDF bytes after normalization, or approved snapshots.
class GeniusPdfGoldenManifest {
  const GeniusPdfGoldenManifest(this.cases);

  final List<GeniusPdfGoldenCase> cases;

  static const core = GeniusPdfGoldenManifest([
    GeniusPdfGoldenCase(
      id: 'component-identity-en',
      subject: 'GeniusPdfDocumentIdentity',
      kind: GeniusPdfRegressionSubjectKind.component,
      direction: GeniusPdfRegressionDirection.enLtr,
    ),
    GeniusPdfGoldenCase(
      id: 'component-party-ar',
      subject: 'GeniusPdfPartyBlock',
      kind: GeniusPdfRegressionSubjectKind.component,
      direction: GeniusPdfRegressionDirection.arRtl,
    ),
    GeniusPdfGoldenCase(
      id: 'component-tax-bilingual',
      subject: 'GeniusPdfTaxSummary',
      kind: GeniusPdfRegressionSubjectKind.component,
      direction: GeniusPdfRegressionDirection.bilingual,
    ),
    GeniusPdfGoldenCase(
      id: 'family-transaction-en',
      subject: 'transaction',
      kind: GeniusPdfRegressionSubjectKind.family,
      direction: GeniusPdfRegressionDirection.enLtr,
    ),
    GeniusPdfGoldenCase(
      id: 'family-statement-ar',
      subject: 'statement',
      kind: GeniusPdfRegressionSubjectKind.family,
      direction: GeniusPdfRegressionDirection.arRtl,
    ),
    GeniusPdfGoldenCase(
      id: 'pack-sales-bilingual',
      subject: 'sales',
      kind: GeniusPdfRegressionSubjectKind.erpPack,
      direction: GeniusPdfRegressionDirection.bilingual,
    ),
    GeniusPdfGoldenCase(
      id: 'pack-pos-thermal',
      subject: 'pos',
      kind: GeniusPdfRegressionSubjectKind.erpPack,
      direction: GeniusPdfRegressionDirection.thermal,
      profile: 'thermal80',
    ),
    GeniusPdfGoldenCase(
      id: 'pack-inventory-labels',
      subject: 'inventory',
      kind: GeniusPdfRegressionSubjectKind.erpPack,
      direction: GeniusPdfRegressionDirection.label,
      profile: 'labelSheet',
    ),
  ]);
}

class GeniusPdfSemanticExpectation {
  const GeniusPdfSemanticExpectation({
    required this.id,
    required this.requiredText,
    this.requiredAny = const [],
    this.forbiddenText = const [],
  });

  final String id;
  final List<String> requiredText;
  final List<List<String>> requiredAny;
  final List<String> forbiddenText;
}

class GeniusPdfSemanticCheckResult {
  const GeniusPdfSemanticCheckResult({
    required this.expectation,
    required this.missing,
    required this.forbiddenFound,
  });

  final GeniusPdfSemanticExpectation expectation;
  final List<String> missing;
  final List<String> forbiddenFound;

  bool get passed => missing.isEmpty && forbiddenFound.isEmpty;
}

/// S24-T16..T23 text-extraction semantic regression engine.
class GeniusPdfSemanticRegression {
  const GeniusPdfSemanticRegression();

  GeniusPdfSemanticCheckResult checkExtractedText(
    String extractedText,
    GeniusPdfSemanticExpectation expectation,
  ) {
    final missing = <String>[];
    for (final value in expectation.requiredText) {
      if (!extractedText.contains(value)) {
        missing.add(value);
      }
    }
    for (final group in expectation.requiredAny) {
      if (!group.any(extractedText.contains)) {
        missing.add('oneOf(${group.join('|')})');
      }
    }
    final forbidden = <String>[
      for (final value in expectation.forbiddenText)
        if (extractedText.contains(value)) value,
    ];
    return GeniusPdfSemanticCheckResult(
      expectation: expectation,
      missing: List.unmodifiable(missing),
      forbiddenFound: List.unmodifiable(forbidden),
    );
  }

  static GeniusPdfSemanticExpectation erpDocument({
    required String documentNumber,
    required String party,
    required String total,
    required String currency,
    String? tax,
    String? pageNumber,
    Iterable<String> complianceMetadata = const [],
  }) {
    return GeniusPdfSemanticExpectation(
      id: 'erp-document-semantic',
      requiredText: [
        documentNumber,
        party,
        total,
        currency,
        if (tax != null) tax,
        if (pageNumber != null) pageNumber,
        ...complianceMetadata,
      ],
    );
  }
}
