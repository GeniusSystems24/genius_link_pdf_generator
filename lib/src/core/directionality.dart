
/// Package-owned directionality and logical-layout primitives.
///
/// This API intentionally does not expose Syncfusion direction types. Rendering
/// adapters may convert the resolved package-owned values to renderer-specific
/// types only at the final drawing boundary.
///
/// Sprint S01 establishes the contract; existing PDF components migrate to this
/// contract in Sprint S02.
library;

/// A direction request.
///
/// [auto] means "inherit from the next lower-precedence scope".
enum GeniusPdfDirection {
  auto,
  ltr,
  rtl,
}

/// A fully resolved direction.
enum GeniusPdfResolvedDirection {
  ltr,
  rtl;

  bool get isLtr => this == GeniusPdfResolvedDirection.ltr;
  bool get isRtl => this == GeniusPdfResolvedDirection.rtl;
}

/// Identifies the scope that supplied a resolved direction.
enum GeniusPdfDirectionSource {
  element,
  component,
  template,
  document,
  locale,
  fallback,
}

/// A resolved direction together with the scope that won precedence.
class GeniusPdfDirectionResolution {
  const GeniusPdfDirectionResolution({
    required this.direction,
    required this.source,
  });

  final GeniusPdfResolvedDirection direction;
  final GeniusPdfDirectionSource source;

  bool get isLtr => direction.isLtr;
  bool get isRtl => direction.isRtl;
}

/// Categories of ERP values that need an independent text-run direction.
enum GeniusPdfValueKind {
  plainText,
  number,
  money,
  percentage,
  quantity,
  date,
  time,
  dateTime,
  documentNumber,
  sku,
  serial,
  batch,
  iban,
  swift,
  taxId,
  phone,
  email,
  url,
  customIdentifier,
}

/// Isolation semantics for mixed-direction text runs.
///
/// This is a semantic model. It does not inject Unicode control characters and
/// never mutates or reverses [GeniusPdfDirectedTextRun.text].
enum GeniusPdfTextIsolation {
  none,
  isolate,
}

/// Default value-direction policy for ERP output.
///
/// Numeric, monetary, temporal, identifier, and contact values default to LTR
/// even when the surrounding document is RTL. Plain prose inherits the active
/// layout/text direction.
///
/// Callers can override any category or an individual run.
class GeniusPdfValueDirectionPolicy {
  const GeniusPdfValueDirectionPolicy({
    this.plainText = GeniusPdfDirection.auto,
    this.numeric = GeniusPdfDirection.ltr,
    this.temporal = GeniusPdfDirection.ltr,
    this.identifier = GeniusPdfDirection.ltr,
    this.contact = GeniusPdfDirection.ltr,
  });

  const GeniusPdfValueDirectionPolicy.erp()
      : plainText = GeniusPdfDirection.auto,
        numeric = GeniusPdfDirection.ltr,
        temporal = GeniusPdfDirection.ltr,
        identifier = GeniusPdfDirection.ltr,
        contact = GeniusPdfDirection.ltr;

  final GeniusPdfDirection plainText;
  final GeniusPdfDirection numeric;
  final GeniusPdfDirection temporal;
  final GeniusPdfDirection identifier;
  final GeniusPdfDirection contact;

  GeniusPdfDirection directionFor(GeniusPdfValueKind kind) {
    return switch (kind) {
      GeniusPdfValueKind.plainText => plainText,
      GeniusPdfValueKind.number ||
      GeniusPdfValueKind.money ||
      GeniusPdfValueKind.percentage ||
      GeniusPdfValueKind.quantity => numeric,
      GeniusPdfValueKind.date ||
      GeniusPdfValueKind.time ||
      GeniusPdfValueKind.dateTime => temporal,
      GeniusPdfValueKind.documentNumber ||
      GeniusPdfValueKind.sku ||
      GeniusPdfValueKind.serial ||
      GeniusPdfValueKind.batch ||
      GeniusPdfValueKind.iban ||
      GeniusPdfValueKind.swift ||
      GeniusPdfValueKind.taxId ||
      GeniusPdfValueKind.customIdentifier => identifier,
      GeniusPdfValueKind.phone ||
      GeniusPdfValueKind.email ||
      GeniusPdfValueKind.url => contact,
    };
  }

  GeniusPdfValueDirectionPolicy copyWith({
    GeniusPdfDirection? plainText,
    GeniusPdfDirection? numeric,
    GeniusPdfDirection? temporal,
    GeniusPdfDirection? identifier,
    GeniusPdfDirection? contact,
  }) {
    return GeniusPdfValueDirectionPolicy(
      plainText: plainText ?? this.plainText,
      numeric: numeric ?? this.numeric,
      temporal: temporal ?? this.temporal,
      identifier: identifier ?? this.identifier,
      contact: contact ?? this.contact,
    );
  }
}

/// Directionality context inherited through document/template/component/element.
///
/// Resolution precedence is non-negotiable:
///
/// `element > component > template > document > locale > fallback`.
class GeniusPdfDirectionality {
  const GeniusPdfDirectionality({
    this.localeDirection = GeniusPdfDirection.auto,
    this.documentDirection = GeniusPdfDirection.auto,
    this.templateDirection = GeniusPdfDirection.auto,
    this.componentDirection = GeniusPdfDirection.auto,
    this.elementDirection = GeniusPdfDirection.auto,
    this.valuePolicy = const GeniusPdfValueDirectionPolicy.erp(),
  });

  final GeniusPdfDirection localeDirection;
  final GeniusPdfDirection documentDirection;
  final GeniusPdfDirection templateDirection;
  final GeniusPdfDirection componentDirection;
  final GeniusPdfDirection elementDirection;
  final GeniusPdfValueDirectionPolicy valuePolicy;

  GeniusPdfDirectionResolution resolve({
    GeniusPdfResolvedDirection fallback = GeniusPdfResolvedDirection.ltr,
  }) {
    return GeniusPdfDirectionResolver.resolve(
      this,
      fallback: fallback,
    );
  }

  GeniusPdfResolvedDirection resolveValue(
    GeniusPdfValueKind kind, {
    GeniusPdfDirection override = GeniusPdfDirection.auto,
    GeniusPdfResolvedDirection fallback = GeniusPdfResolvedDirection.ltr,
  }) {
    final requested = override == GeniusPdfDirection.auto
        ? valuePolicy.directionFor(kind)
        : override;
    if (requested != GeniusPdfDirection.auto) {
      return GeniusPdfDirectionResolver.resolveExplicit(requested);
    }
    return resolve(fallback: fallback).direction;
  }

  /// Creates an inherited template scope.
  GeniusPdfDirectionality forTemplate(GeniusPdfDirection direction) =>
      copyWith(templateDirection: direction);

  /// Creates an inherited component scope.
  GeniusPdfDirectionality forComponent(GeniusPdfDirection direction) =>
      copyWith(componentDirection: direction);

  /// Creates an inherited element scope.
  GeniusPdfDirectionality forElement(GeniusPdfDirection direction) =>
      copyWith(elementDirection: direction);

  GeniusPdfDirectionality copyWith({
    GeniusPdfDirection? localeDirection,
    GeniusPdfDirection? documentDirection,
    GeniusPdfDirection? templateDirection,
    GeniusPdfDirection? componentDirection,
    GeniusPdfDirection? elementDirection,
    GeniusPdfValueDirectionPolicy? valuePolicy,
  }) {
    return GeniusPdfDirectionality(
      localeDirection: localeDirection ?? this.localeDirection,
      documentDirection: documentDirection ?? this.documentDirection,
      templateDirection: templateDirection ?? this.templateDirection,
      componentDirection: componentDirection ?? this.componentDirection,
      elementDirection: elementDirection ?? this.elementDirection,
      valuePolicy: valuePolicy ?? this.valuePolicy,
    );
  }
}

/// Resolves direction according to the S01 precedence contract.
abstract final class GeniusPdfDirectionResolver {
  static GeniusPdfDirectionResolution resolve(
    GeniusPdfDirectionality context, {
    GeniusPdfResolvedDirection fallback = GeniusPdfResolvedDirection.ltr,
  }) {
    final candidates = <(GeniusPdfDirection, GeniusPdfDirectionSource)>[
      (context.elementDirection, GeniusPdfDirectionSource.element),
      (context.componentDirection, GeniusPdfDirectionSource.component),
      (context.templateDirection, GeniusPdfDirectionSource.template),
      (context.documentDirection, GeniusPdfDirectionSource.document),
      (context.localeDirection, GeniusPdfDirectionSource.locale),
    ];

    for (final candidate in candidates) {
      if (candidate.$1 == GeniusPdfDirection.auto) continue;
      return GeniusPdfDirectionResolution(
        direction: resolveExplicit(candidate.$1),
        source: candidate.$2,
      );
    }

    return GeniusPdfDirectionResolution(
      direction: fallback,
      source: GeniusPdfDirectionSource.fallback,
    );
  }

  static GeniusPdfResolvedDirection resolveExplicit(
    GeniusPdfDirection direction,
  ) {
    return switch (direction) {
      GeniusPdfDirection.ltr => GeniusPdfResolvedDirection.ltr,
      GeniusPdfDirection.rtl => GeniusPdfResolvedDirection.rtl,
      GeniusPdfDirection.auto => throw ArgumentError.value(
          direction,
          'direction',
          'An explicit direction cannot be auto.',
        ),
    };
  }

  static GeniusPdfDirection parse(
    Object? value, {
    GeniusPdfDirection fallback = GeniusPdfDirection.auto,
  }) {
    if (value is GeniusPdfDirection) return value;
    if (value is String) {
      return switch (value.toLowerCase()) {
        'ltr' => GeniusPdfDirection.ltr,
        'rtl' => GeniusPdfDirection.rtl,
        'auto' => GeniusPdfDirection.auto,
        _ => fallback,
      };
    }
    return fallback;
  }
}

/// A mixed-direction run that preserves the source string exactly.
class GeniusPdfDirectedTextRun {
  const GeniusPdfDirectedTextRun(
    this.text, {
    this.kind = GeniusPdfValueKind.plainText,
    this.direction = GeniusPdfDirection.auto,
    this.isolation = GeniusPdfTextIsolation.isolate,
  });

  final String text;
  final GeniusPdfValueKind kind;
  final GeniusPdfDirection direction;
  final GeniusPdfTextIsolation isolation;

  GeniusPdfResolvedDirection resolveDirection(
    GeniusPdfDirectionality directionality,
  ) {
    return directionality.resolveValue(kind, override: direction);
  }
}

/// Logical horizontal alignment. Never encode physical left/right semantics in
/// a new layout-facing API when the intent is start/end.
enum GeniusPdfLogicalAlignment {
  start,
  center,
  end,
}

/// Logical placement of an accessory or block edge.
enum GeniusPdfLogicalPosition {
  leading,
  trailing,
}

/// Physical alignment returned only after resolving a logical request.
enum GeniusPdfPhysicalHorizontalAlignment {
  left,
  center,
  right,
}

/// Physical side returned only at the renderer/drawing boundary.
enum GeniusPdfPhysicalSide {
  left,
  right,
}

/// Direction-aware insets expressed with logical start/end.
class GeniusPdfDirectionalInsets {
  const GeniusPdfDirectionalInsets({
    this.start = 0,
    this.top = 0,
    this.end = 0,
    this.bottom = 0,
  });

  const GeniusPdfDirectionalInsets.all(double value)
      : start = value,
        top = value,
        end = value,
        bottom = value;

  const GeniusPdfDirectionalInsets.symmetric({
    double horizontal = 0,
    double vertical = 0,
  })  : start = horizontal,
        end = horizontal,
        top = vertical,
        bottom = vertical;

  final double start;
  final double top;
  final double end;
  final double bottom;

  GeniusPdfPhysicalInsets resolve(GeniusPdfResolvedDirection direction) {
    return direction.isRtl
        ? GeniusPdfPhysicalInsets(
            left: end,
            top: top,
            right: start,
            bottom: bottom,
          )
        : GeniusPdfPhysicalInsets(
            left: start,
            top: top,
            right: end,
            bottom: bottom,
          );
  }
}

/// Physical insets for a concrete drawing backend.
class GeniusPdfPhysicalInsets {
  const GeniusPdfPhysicalInsets({
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });

  final double left;
  final double top;
  final double right;
  final double bottom;
}

/// Media mirroring is explicit. The default preserves pixels.
///
/// Images, signatures, QR graphics and barcode graphics must not be mirrored
/// merely because a parent layout is RTL.
enum GeniusPdfMediaMirroringPolicy {
  preserve,
  mirror,
}

/// Converts logical geometry to physical geometry at draw time only.
abstract final class GeniusPdfLogicalGeometry {
  static GeniusPdfPhysicalHorizontalAlignment resolveAlignment(
    GeniusPdfLogicalAlignment alignment,
    GeniusPdfResolvedDirection direction,
  ) {
    return switch (alignment) {
      GeniusPdfLogicalAlignment.center =>
        GeniusPdfPhysicalHorizontalAlignment.center,
      GeniusPdfLogicalAlignment.start => direction.isRtl
          ? GeniusPdfPhysicalHorizontalAlignment.right
          : GeniusPdfPhysicalHorizontalAlignment.left,
      GeniusPdfLogicalAlignment.end => direction.isRtl
          ? GeniusPdfPhysicalHorizontalAlignment.left
          : GeniusPdfPhysicalHorizontalAlignment.right,
    };
  }

  static GeniusPdfPhysicalSide resolvePosition(
    GeniusPdfLogicalPosition position,
    GeniusPdfResolvedDirection direction,
  ) {
    return switch (position) {
      GeniusPdfLogicalPosition.leading => direction.isRtl
          ? GeniusPdfPhysicalSide.right
          : GeniusPdfPhysicalSide.left,
      GeniusPdfLogicalPosition.trailing => direction.isRtl
          ? GeniusPdfPhysicalSide.left
          : GeniusPdfPhysicalSide.right,
    };
  }

  static double resolveX({
    required double containerX,
    required double containerWidth,
    required double itemWidth,
    required GeniusPdfLogicalAlignment alignment,
    required GeniusPdfResolvedDirection direction,
  }) {
    final available = containerWidth - itemWidth;
    return switch (resolveAlignment(alignment, direction)) {
      GeniusPdfPhysicalHorizontalAlignment.left => containerX,
      GeniusPdfPhysicalHorizontalAlignment.center =>
        containerX + (available / 2),
      GeniusPdfPhysicalHorizontalAlignment.right => containerX + available,
    };
  }

  static bool shouldMirrorMedia({
    GeniusPdfMediaMirroringPolicy policy =
        GeniusPdfMediaMirroringPolicy.preserve,
  }) =>
      policy == GeniusPdfMediaMirroringPolicy.mirror;
}
