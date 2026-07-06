part of '../grid_models.dart';

// ============================================================================
// Built-in Grid Style Presets (v2.12.10)
// ============================================================================

/// Sealed hierarchy of built-in [GeniusPdfDataGrid] style presets.
///
/// Every concrete subclass wraps one of [GeniusPdfGridStyle]'s factory
/// constructors with its own customization parameters. Use [build] to
/// materialize a [GeniusPdfGridStyle] suitable for [GeniusPdfDataGrid.style].
///
/// Sealed-class semantics give callers exhaustive `switch` on presets and
/// keep each preset's parameter surface explicit.
///
/// ## Example
/// ```dart
/// const preset = ModernGridStylePreset(primaryColor: Color(0xFF00897B));
/// final grid = GeniusPdfDataGrid(
///   columns: columns,
///   rows: rows,
///   style: preset.build(),
///   config: config,
/// );
/// ```
sealed class GeniusPdfGridStylePreset {
  const GeniusPdfGridStylePreset();

  /// Stable preset identifier (e.g. `"modern"`, `"classic"`). Suitable for
  /// configuration files, telemetry, or persisted user preferences.
  String get name;

  /// Materializes the preset into a concrete [GeniusPdfGridStyle].
  GeniusPdfGridStyle build();

  /// Canonical defaults for every built-in preset. Useful for previews,
  /// catalog UIs, or selecting a preset by [name].
  static const List<GeniusPdfGridStylePreset> all = [
    ClassicGridStylePreset(),
    ModernGridStylePreset(),
    CorporateGridStylePreset(),
    MinimalGridStylePreset(),
    SaudiGridStylePreset(),
    InvoiceGridStylePreset(),
    StripedGridStylePreset(),
    DarkGridStylePreset(),
    ElegantGridStylePreset(),
    PastelGridStylePreset(),
    BorderedGridStylePreset(),
  ];

  /// Looks up a preset by [name] (case-insensitive). Returns `null` for
  /// unknown names.
  static GeniusPdfGridStylePreset? byName(String name) {
    final lower = name.toLowerCase();
    for (final preset in all) {
      if (preset.name == lower) return preset;
    }
    return null;
  }
}

/// Classic bordered grid style preset — wraps [GeniusPdfGridStyle.classic].
class ClassicGridStylePreset extends GeniusPdfGridStylePreset {
  const ClassicGridStylePreset({
    this.primaryColor = const Color(0xFF333333),
  });

  final Color primaryColor;

  @override
  String get name => 'classic';

  @override
  GeniusPdfGridStyle build() =>
      GeniusPdfGridStyle.classic(primaryColor: primaryColor);
}

/// Modern minimal grid style preset — wraps [GeniusPdfGridStyle.modern].
class ModernGridStylePreset extends GeniusPdfGridStylePreset {
  const ModernGridStylePreset({
    this.primaryColor = const Color(0xFF1565C0),
  });

  final Color primaryColor;

  @override
  String get name => 'modern';

  @override
  GeniusPdfGridStyle build() =>
      GeniusPdfGridStyle.modern(primaryColor: primaryColor);
}

/// Corporate professional grid style preset — wraps
/// [GeniusPdfGridStyle.corporate]. Exposes the full set of corporate-specific
/// colors and border width.
class CorporateGridStylePreset extends GeniusPdfGridStylePreset {
  const CorporateGridStylePreset({
    this.primaryColor = const Color(0xFF1565C0),
    this.headerBackground = const Color(0xFF1565C0),
    this.headerTextColor = const Color(0xFFFFFFFF),
    this.alternateRowColor = const Color(0xFFF5F5F5),
    this.totalRowColor = const Color(0xFFE0E0E0),
    this.borderWidth = 1.0,
  });

  final Color primaryColor;
  final Color headerBackground;
  final Color headerTextColor;
  final Color alternateRowColor;
  final Color totalRowColor;
  final double borderWidth;

  @override
  String get name => 'corporate';

  @override
  GeniusPdfGridStyle build() => GeniusPdfGridStyle.corporate(
        primaryColor: primaryColor,
        headerBackground: headerBackground,
        headerTextColor: headerTextColor,
        alternateRowColor: alternateRowColor,
        totalRowColor: totalRowColor,
        borderWidth: borderWidth,
      );
}

/// Minimal/clean grid style preset — wraps [GeniusPdfGridStyle.minimal].
class MinimalGridStylePreset extends GeniusPdfGridStylePreset {
  const MinimalGridStylePreset({
    this.primaryColor = const Color(0xFF424242),
    this.headerBorderWidth = 2.0,
  });

  final Color primaryColor;
  final double headerBorderWidth;

  @override
  String get name => 'minimal';

  @override
  GeniusPdfGridStyle build() => GeniusPdfGridStyle.minimal(
        primaryColor: primaryColor,
        headerBorderWidth: headerBorderWidth,
      );
}

/// Saudi-themed (green) grid style preset — wraps [GeniusPdfGridStyle.saudi].
class SaudiGridStylePreset extends GeniusPdfGridStylePreset {
  const SaudiGridStylePreset({
    this.primaryColor = const Color(0xFF006C35),
    this.accentColor = const Color(0xFF004D25),
  });

  final Color primaryColor;
  final Color accentColor;

  @override
  String get name => 'saudi';

  @override
  GeniusPdfGridStyle build() => GeniusPdfGridStyle.saudi(
        primaryColor: primaryColor,
        accentColor: accentColor,
      );
}

/// Invoice-optimized grid style preset — wraps [GeniusPdfGridStyle.invoice].
class InvoiceGridStylePreset extends GeniusPdfGridStylePreset {
  const InvoiceGridStylePreset({
    this.primaryColor = const Color(0xFF555555),
    this.showAlternateRows = true,
  });

  final Color primaryColor;
  final bool showAlternateRows;

  @override
  String get name => 'invoice';

  @override
  GeniusPdfGridStyle build() => GeniusPdfGridStyle.invoice(
        primaryColor: primaryColor,
        showAlternateRows: showAlternateRows,
      );
}

/// Striped/zebra grid style preset — wraps [GeniusPdfGridStyle.striped].
class StripedGridStylePreset extends GeniusPdfGridStylePreset {
  const StripedGridStylePreset({
    this.primaryColor = const Color(0xFF37474F),
  });

  final Color primaryColor;

  @override
  String get name => 'striped';

  @override
  GeniusPdfGridStyle build() =>
      GeniusPdfGridStyle.striped(primaryColor: primaryColor);
}

/// Dark grid style preset — wraps [GeniusPdfGridStyle.dark].
class DarkGridStylePreset extends GeniusPdfGridStylePreset {
  const DarkGridStylePreset({
    this.primaryColor = const Color(0xFF263238),
  });

  final Color primaryColor;

  @override
  String get name => 'dark';

  @override
  GeniusPdfGridStyle build() =>
      GeniusPdfGridStyle.dark(primaryColor: primaryColor);
}

/// Elegant grid style preset (refined horizontal rules) — wraps
/// [GeniusPdfGridStyle.elegant].
class ElegantGridStylePreset extends GeniusPdfGridStylePreset {
  const ElegantGridStylePreset({
    this.primaryColor = const Color(0xFF5D4037),
  });

  final Color primaryColor;

  @override
  String get name => 'elegant';

  @override
  GeniusPdfGridStyle build() =>
      GeniusPdfGridStyle.elegant(primaryColor: primaryColor);
}

/// Pastel grid style preset (soft tints) — wraps [GeniusPdfGridStyle.pastel].
class PastelGridStylePreset extends GeniusPdfGridStylePreset {
  const PastelGridStylePreset({
    this.primaryColor = const Color(0xFF7E57C2),
  });

  final Color primaryColor;

  @override
  String get name => 'pastel';

  @override
  GeniusPdfGridStyle build() =>
      GeniusPdfGridStyle.pastel(primaryColor: primaryColor);
}

/// Bordered grid style preset (strong visible borders) — wraps
/// [GeniusPdfGridStyle.bordered].
class BorderedGridStylePreset extends GeniusPdfGridStylePreset {
  const BorderedGridStylePreset({
    this.primaryColor = const Color(0xFF1B5E20),
    this.borderWidth = 1.0,
  });

  final Color primaryColor;
  final double borderWidth;

  @override
  String get name => 'bordered';

  @override
  GeniusPdfGridStyle build() => GeniusPdfGridStyle.bordered(
        primaryColor: primaryColor,
        borderWidth: borderWidth,
      );
}
