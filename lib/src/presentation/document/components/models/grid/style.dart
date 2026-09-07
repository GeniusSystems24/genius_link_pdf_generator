part of '../grid_models.dart';

/// Configuration for grid appearance.
///
/// Enhanced grid style with comprehensive theming options for:
/// - Header, cell, and row styling
/// - Border configuration
/// - Spacing and layout
/// - Responsive width management
/// - Print-specific options
///
/// ## Example
/// ```dart
/// GeniusPdfGridStyle.corporate(
///   primaryColor: Color(0xFF1565C0),
///   accentColor: Color(0xFF0D47A1),
/// )
/// ```
class GeniusPdfGridStyle {
  const GeniusPdfGridStyle({
    this.headerStyle = const GeniusPdfCellStyle.header(),
    this.cellStyle = const GeniusPdfCellStyle(),
    this.alternateRowStyle,
    this.totalRowStyle = const GeniusPdfCellStyle.total(),
    this.subtotalRowStyle,
    this.groupHeaderStyle,
    this.selectedRowStyle,
    this.highlightedRowStyle,
    this.borderStyle = const GeniusPdfBorderStyle.all(),
    this.outerBorderStyle,
    this.showHeader = true,
    this.repeatHeaderOnPages = true,
    this.alternateRowColors = true,
    this.alternateStartIndex = 1,
    this.cellSpacing = 0,
    this.rowSpacing = 0,
    this.defaultColumnWidth = 100,
    this.minColumnWidth = 30,
    this.maxColumnWidth = 300,
    this.rowHeight,
    this.minRowHeight = 16,
    this.maxRowHeight,
    this.headerHeight,
    this.groupHeaderHeight,
    this.horizontalPadding = 0,
    this.verticalPadding = 0,
    this.groupIndentPerLevel = 12,
    this.showGridLines = true,
    this.gridLineColor,
    this.gridLineWidth = 0.5,
    this.showVerticalLines = true,
    this.showHorizontalLines = true,
    this.roundedCorners = false,
    this.cornerRadius = 4,
    this.shadowEnabled = false,
    this.shadowColor,
    this.shadowOffset = 2,
    this.shadowBlur = 4,
    this.clipContent = true,
    this.fitToPage = false,
    this.breakRowsAcrossPages = true,
  });

  /// Creates a modern/minimal grid style with customizable primary color.
  factory GeniusPdfGridStyle.modern({
    Color primaryColor = const Color(0xFF1565C0),
  }) {
    return GeniusPdfGridStyle(
      headerStyle: GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        backgroundColor: primaryColor.withValues(alpha: 0.08),
        border: GeniusPdfBorderStyle.bottom(width: 2, color: primaryColor),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
      ),
      cellStyle: const GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle.body(),
        border: GeniusPdfBorderStyle.bottom(color: Color(0xFFE0E0E0)),
        padding: GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 4),
      ),
      alternateRowStyle: const GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle.body(),
        backgroundColor: Color(0xFFFAFAFA),
        border: GeniusPdfBorderStyle.bottom(color: Color(0xFFE0E0E0)),
        padding: GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 4),
      ),
      totalRowStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: primaryColor.withValues(alpha: 0.12),
        border: const GeniusPdfBorderStyle.all(width: 1),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
      ),
      subtotalRowStyle: const GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: Color(0xFFF5F5F5),
        padding: GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 4),
      ),
      groupHeaderStyle: GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        backgroundColor: primaryColor.withValues(alpha: 0.08),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
      ),
      borderStyle: const GeniusPdfBorderStyle.none(),
      alternateRowColors: true,
      minRowHeight: 20,
      showGridLines: false,
      showVerticalLines: false,
      showHorizontalLines: true,
    );
  }

  /// Creates a classic bordered grid style.
  const GeniusPdfGridStyle.classic({
    Color primaryColor = const Color(0xFF333333),
  })  : headerStyle = const GeniusPdfCellStyle.header(),
        cellStyle = const GeniusPdfCellStyle(),
        alternateRowStyle = const GeniusPdfCellStyle.alternateEven(),
        totalRowStyle = const GeniusPdfCellStyle.total(),
        subtotalRowStyle = null,
        groupHeaderStyle = null,
        selectedRowStyle = null,
        highlightedRowStyle = null,
        borderStyle = const GeniusPdfBorderStyle.all(),
        outerBorderStyle = null,
        showHeader = true,
        repeatHeaderOnPages = true,
        alternateRowColors = true,
        alternateStartIndex = 1,
        cellSpacing = 0,
        rowSpacing = 0,
        defaultColumnWidth = 100,
        minColumnWidth = 30,
        maxColumnWidth = 300,
        rowHeight = null,
        minRowHeight = 16,
        maxRowHeight = null,
        headerHeight = null,
        groupHeaderHeight = null,
        horizontalPadding = 0,
        verticalPadding = 0,
        groupIndentPerLevel = 12,
        showGridLines = true,
        gridLineColor = null,
        gridLineWidth = 0.5,
        showVerticalLines = true,
        showHorizontalLines = true,
        roundedCorners = false,
        cornerRadius = 4,
        shadowEnabled = false,
        shadowColor = null,
        shadowOffset = 2,
        shadowBlur = 4,
        clipContent = true,
        fitToPage = false,
        breakRowsAcrossPages = true;

  /// Creates a corporate/professional grid style.
  factory GeniusPdfGridStyle.corporate({
    Color primaryColor = const Color(0xFF1565C0),
    Color headerBackground = const Color(0xFF1565C0),
    Color headerTextColor = const Color(0xFFFFFFFF),
    Color alternateRowColor = const Color(0xFFF5F5F5),
    Color totalRowColor = const Color(0xFFE0E0E0),
    double borderWidth = 1.0,
  }) {
    return GeniusPdfGridStyle(
      headerStyle: GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: headerTextColor,
        ),
        backgroundColor: headerBackground,
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
      ),
      cellStyle: const GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle.body(),
        padding: GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 5),
      ),
      alternateRowStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle.body(),
        backgroundColor: alternateRowColor,
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 5),
      ),
      totalRowStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: totalRowColor,
        border: GeniusPdfBorderStyle.all(width: borderWidth),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
      ),
      subtotalRowStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: totalRowColor.withValues(alpha: 0.5),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 4),
      ),
      groupHeaderStyle: GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        backgroundColor: alternateRowColor,
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
      ),
      borderStyle: GeniusPdfBorderStyle.all(width: borderWidth),
      showGridLines: true,
      gridLineColor: const Color(0xFFE0E0E0),
      gridLineWidth: 0.5,
    );
  }

  /// Creates a minimal/clean grid style with customizable primary color.
  factory GeniusPdfGridStyle.minimal({
    Color primaryColor = const Color(0xFF424242),
    double headerBorderWidth = 2.0,
  }) {
    return GeniusPdfGridStyle(
      headerStyle: GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        border: GeniusPdfBorderStyle.bottom(
          width: headerBorderWidth,
          color: primaryColor,
        ),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 6, vertical: 5),
      ),
      cellStyle: const GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(fontSize: 9),
        padding: GeniusPdfCellPadding.symmetric(horizontal: 6, vertical: 4),
      ),
      alternateRowStyle: null,
      totalRowStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
        border: GeniusPdfBorderStyle.top(
          width: headerBorderWidth,
          color: primaryColor,
        ),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 6, vertical: 5),
      ),
      borderStyle: const GeniusPdfBorderStyle.none(),
      alternateRowColors: false,
      showGridLines: false,
      showVerticalLines: false,
      showHorizontalLines: false,
    );
  }

  /// Creates a Saudi-themed grid style with green colors.
  factory GeniusPdfGridStyle.saudi({
    Color primaryColor = const Color(0xFF006C35),
    Color accentColor = const Color(0xFF004D25),
  }) {
    return GeniusPdfGridStyle(
      headerStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFFFFF),
        ),
        backgroundColor: primaryColor,
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
      ),
      cellStyle: const GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle.body(),
        padding: GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 5),
      ),
      alternateRowStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle.body(),
        backgroundColor: primaryColor.withValues(alpha: 0.05),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 5),
      ),
      totalRowStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: primaryColor.withValues(alpha: 0.15),
        border: GeniusPdfBorderStyle.all(width: 1, color: primaryColor),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
      ),
      groupHeaderStyle: GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: accentColor,
        ),
        backgroundColor: primaryColor.withValues(alpha: 0.1),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
      ),
      borderStyle: GeniusPdfBorderStyle.all(color: primaryColor),
      showGridLines: true,
      gridLineColor: primaryColor.withValues(alpha: 0.3),
    );
  }

  /// Creates an invoice/financial grid style with customizable primary color.
  factory GeniusPdfGridStyle.invoice({
    Color primaryColor = const Color(0xFF555555),
    bool showAlternateRows = true,
  }) {
    return GeniusPdfGridStyle(
      headerStyle: GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        backgroundColor: primaryColor.withValues(alpha: 0.08),
        border: GeniusPdfBorderStyle.all(
            color: primaryColor.withValues(alpha: 0.3)),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 6, vertical: 5),
      ),
      cellStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle(fontSize: 9),
        border: GeniusPdfBorderStyle.horizontal(
            color: primaryColor.withValues(alpha: 0.15)),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 6, vertical: 4),
      ),
      alternateRowStyle: showAlternateRows
          ? GeniusPdfCellStyle(
              textStyle: const GeniusPdfTextStyle(fontSize: 9),
              backgroundColor: primaryColor.withValues(alpha: 0.03),
              border: GeniusPdfBorderStyle.horizontal(
                  color: primaryColor.withValues(alpha: 0.15)),
              padding: const GeniusPdfCellPadding.symmetric(
                  horizontal: 6, vertical: 4),
            )
          : null,
      totalRowStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: primaryColor.withValues(alpha: 0.12),
        border: GeniusPdfBorderStyle.all(
            color: primaryColor.withValues(alpha: 0.3)),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 6, vertical: 6),
      ),
      subtotalRowStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: primaryColor.withValues(alpha: 0.05),
        border: GeniusPdfBorderStyle.top(
            color: primaryColor.withValues(alpha: 0.3)),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 6, vertical: 4),
      ),
      borderStyle:
          GeniusPdfBorderStyle.all(color: primaryColor.withValues(alpha: 0.3)),
      outerBorderStyle: GeniusPdfBorderStyle.all(
          width: 1.5, color: primaryColor.withValues(alpha: 0.5)),
      alternateRowColors: showAlternateRows,
      showGridLines: true,
      gridLineColor: primaryColor.withValues(alpha: 0.15),
    );
  }

  /// Creates a striped/zebra grid style with prominent alternating rows.
  ///
  /// Emphasizes row alternation with a stronger color contrast.
  /// Great for dense tables where readability is key.
  factory GeniusPdfGridStyle.striped({
    Color primaryColor = const Color(0xFF37474F),
  }) {
    return GeniusPdfGridStyle(
      headerStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFFFFF),
        ),
        backgroundColor: primaryColor,
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
      ),
      cellStyle: const GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(fontSize: 9),
        padding: GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 5),
      ),
      alternateRowStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle(fontSize: 9),
        backgroundColor: primaryColor.withValues(alpha: 0.07),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 5),
      ),
      totalRowStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFFFFF),
        ),
        backgroundColor: primaryColor.withValues(alpha: 0.85),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
      ),
      subtotalRowStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: primaryColor.withValues(alpha: 0.15),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 4),
      ),
      groupHeaderStyle: GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        backgroundColor: primaryColor.withValues(alpha: 0.1),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
      ),
      borderStyle: const GeniusPdfBorderStyle.none(),
      alternateRowColors: true,
      showGridLines: false,
      showVerticalLines: false,
      showHorizontalLines: false,
    );
  }

  /// Creates a dark/inverted grid style with a dark header and light content.
  ///
  /// Header uses a solid dark background with white text. Data cells
  /// use a subtle dark tint for alternating rows. Ideal for dashboards.
  factory GeniusPdfGridStyle.dark({
    Color primaryColor = const Color(0xFF263238),
  }) {
    return GeniusPdfGridStyle(
      headerStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFFFFF),
        ),
        backgroundColor: primaryColor,
        border: GeniusPdfBorderStyle.all(color: primaryColor),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 7),
      ),
      cellStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle(fontSize: 9),
        border: GeniusPdfBorderStyle.bottom(
            color: primaryColor.withValues(alpha: 0.15)),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 5),
      ),
      alternateRowStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle(fontSize: 9),
        backgroundColor: primaryColor.withValues(alpha: 0.04),
        border: GeniusPdfBorderStyle.bottom(
            color: primaryColor.withValues(alpha: 0.15)),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 5),
      ),
      totalRowStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFFFFF),
        ),
        backgroundColor: primaryColor,
        border: GeniusPdfBorderStyle.all(color: primaryColor),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
      ),
      subtotalRowStyle: GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
        backgroundColor: primaryColor.withValues(alpha: 0.08),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 4),
      ),
      groupHeaderStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFFFFF),
        ),
        backgroundColor: primaryColor.withValues(alpha: 0.75),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
      ),
      borderStyle:
          GeniusPdfBorderStyle.all(color: primaryColor.withValues(alpha: 0.2)),
      alternateRowColors: true,
      showGridLines: true,
      gridLineColor: primaryColor.withValues(alpha: 0.15),
    );
  }

  /// Creates an elegant grid style with thin borders and refined typography.
  ///
  /// Features a thin colored top/bottom border on the header, no vertical
  /// lines, and subtle horizontal separators. Ideal for formal reports.
  factory GeniusPdfGridStyle.elegant({
    Color primaryColor = const Color(0xFF5D4037),
  }) {
    return GeniusPdfGridStyle(
      headerStyle: GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        border: GeniusPdfBorderStyle.horizontal(width: 2, color: primaryColor),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
      ),
      cellStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle(fontSize: 9),
        border: GeniusPdfBorderStyle.bottom(
            color: primaryColor.withValues(alpha: 0.12)),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 5),
      ),
      alternateRowStyle: null,
      totalRowStyle: GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        border: GeniusPdfBorderStyle.horizontal(width: 2, color: primaryColor),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
      ),
      subtotalRowStyle: GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: primaryColor.withValues(alpha: 0.8),
        ),
        border: GeniusPdfBorderStyle.top(
            color: primaryColor.withValues(alpha: 0.3)),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 5),
      ),
      groupHeaderStyle: GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        border: GeniusPdfBorderStyle.bottom(color: primaryColor),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
      ),
      borderStyle: const GeniusPdfBorderStyle.none(),
      alternateRowColors: false,
      showGridLines: false,
      showVerticalLines: false,
      showHorizontalLines: false,
    );
  }

  /// Creates a pastel grid style with soft, muted colors.
  ///
  /// Uses light pastel tints derived from the primary color for headers
  /// and alternate rows. Great for friendly, non-aggressive reports.
  factory GeniusPdfGridStyle.pastel({
    Color primaryColor = const Color(0xFF7E57C2),
  }) {
    return GeniusPdfGridStyle(
      headerStyle: GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        backgroundColor: primaryColor.withValues(alpha: 0.12),
        border: GeniusPdfBorderStyle.all(
            color: primaryColor.withValues(alpha: 0.25)),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
      ),
      cellStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle(fontSize: 9),
        border: GeniusPdfBorderStyle.all(
            color: primaryColor.withValues(alpha: 0.12)),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 5),
      ),
      alternateRowStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle(fontSize: 9),
        backgroundColor: primaryColor.withValues(alpha: 0.04),
        border: GeniusPdfBorderStyle.all(
            color: primaryColor.withValues(alpha: 0.12)),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 5),
      ),
      totalRowStyle: GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        backgroundColor: primaryColor.withValues(alpha: 0.15),
        border: GeniusPdfBorderStyle.all(
            color: primaryColor.withValues(alpha: 0.3)),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
      ),
      subtotalRowStyle: GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
        backgroundColor: primaryColor.withValues(alpha: 0.06),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 4),
      ),
      groupHeaderStyle: GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        backgroundColor: primaryColor.withValues(alpha: 0.1),
        border: GeniusPdfBorderStyle.all(
            color: primaryColor.withValues(alpha: 0.2)),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
      ),
      borderStyle:
          GeniusPdfBorderStyle.all(color: primaryColor.withValues(alpha: 0.12)),
      alternateRowColors: true,
      showGridLines: true,
      gridLineColor: primaryColor.withValues(alpha: 0.12),
    );
  }

  /// Creates a bordered/outlined grid style with strong visible borders.
  ///
  /// All cells have visible borders using the primary color. Header uses
  /// a filled background. Ideal for formal/legal documents.
  factory GeniusPdfGridStyle.bordered({
    Color primaryColor = const Color(0xFF1B5E20),
    double borderWidth = 1.0,
  }) {
    return GeniusPdfGridStyle(
      headerStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFFFFF),
        ),
        backgroundColor: primaryColor,
        border:
            GeniusPdfBorderStyle.all(width: borderWidth, color: primaryColor),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
      ),
      cellStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle(fontSize: 9),
        border: GeniusPdfBorderStyle.all(
            width: borderWidth, color: primaryColor.withValues(alpha: 0.4)),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 5),
      ),
      alternateRowStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle(fontSize: 9),
        backgroundColor: primaryColor.withValues(alpha: 0.04),
        border: GeniusPdfBorderStyle.all(
            width: borderWidth, color: primaryColor.withValues(alpha: 0.4)),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 5),
      ),
      totalRowStyle: GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        backgroundColor: primaryColor.withValues(alpha: 0.1),
        border:
            GeniusPdfBorderStyle.all(width: borderWidth, color: primaryColor),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
      ),
      subtotalRowStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: primaryColor.withValues(alpha: 0.06),
        border: GeniusPdfBorderStyle.all(
            width: borderWidth, color: primaryColor.withValues(alpha: 0.4)),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 4),
      ),
      groupHeaderStyle: GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        backgroundColor: primaryColor.withValues(alpha: 0.08),
        border:
            GeniusPdfBorderStyle.all(width: borderWidth, color: primaryColor),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
      ),
      borderStyle: GeniusPdfBorderStyle.all(
          width: borderWidth, color: primaryColor.withValues(alpha: 0.4)),
      outerBorderStyle: GeniusPdfBorderStyle.all(
          width: borderWidth * 1.5, color: primaryColor),
      alternateRowColors: true,
      showGridLines: true,
      gridLineColor: primaryColor.withValues(alpha: 0.4),
      gridLineWidth: borderWidth,
    );
  }

  /// Style for header cells.
  final GeniusPdfCellStyle headerStyle;

  /// Default style for data cells.
  final GeniusPdfCellStyle cellStyle;

  /// Style for alternate rows (null to disable).
  final GeniusPdfCellStyle? alternateRowStyle;

  /// Style for total/summary rows.
  final GeniusPdfCellStyle totalRowStyle;

  /// Style for subtotal rows.
  final GeniusPdfCellStyle? subtotalRowStyle;

  /// Style for group header rows.
  final GeniusPdfCellStyle? groupHeaderStyle;

  /// Style for selected rows.
  final GeniusPdfCellStyle? selectedRowStyle;

  /// Style for highlighted rows.
  final GeniusPdfCellStyle? highlightedRowStyle;

  /// Border style for cells.
  final GeniusPdfBorderStyle borderStyle;

  /// Outer border style for the entire grid.
  final GeniusPdfBorderStyle? outerBorderStyle;

  /// Whether to show header row.
  final bool showHeader;

  /// Whether to repeat header on each page.
  final bool repeatHeaderOnPages;

  /// Whether to use alternate row colors.
  final bool alternateRowColors;

  /// Starting index for alternate row colors (0 or 1).
  final int alternateStartIndex;

  /// Horizontal spacing between cells.
  final double cellSpacing;

  /// Vertical spacing between rows.
  final double rowSpacing;

  /// Default width for columns without explicit width.
  final double defaultColumnWidth;

  /// Minimum allowed column width.
  final double minColumnWidth;

  /// Maximum allowed column width.
  final double maxColumnWidth;

  /// Fixed height for all data rows (null for auto).
  final double? rowHeight;

  /// Minimum row height.
  final double minRowHeight;

  /// Maximum row height.
  final double? maxRowHeight;

  /// Height for header row (null for auto).
  final double? headerHeight;

  /// Height for group header rows (null for auto).
  final double? groupHeaderHeight;

  /// Horizontal padding around the grid.
  final double horizontalPadding;

  /// Vertical padding around the grid.
  final double verticalPadding;

  /// Indent increment per group level.
  final double groupIndentPerLevel;

  /// Whether to show grid lines.
  final bool showGridLines;

  /// Color for grid lines (null uses borderStyle color).
  final Color? gridLineColor;

  /// Width of grid lines.
  final double gridLineWidth;

  /// Whether to show vertical grid lines.
  final bool showVerticalLines;

  /// Whether to show horizontal grid lines.
  final bool showHorizontalLines;

  /// Whether to use rounded corners.
  final bool roundedCorners;

  /// Corner radius when roundedCorners is true.
  final double cornerRadius;

  /// Whether to enable shadow.
  final bool shadowEnabled;

  /// Shadow color.
  final Color? shadowColor;

  /// Shadow offset.
  final double shadowOffset;

  /// Shadow blur radius.
  final double shadowBlur;

  /// Whether to clip content that exceeds cell bounds.
  final bool clipContent;

  /// Whether to fit grid width to page.
  final bool fitToPage;

  /// Whether rows can break across pages.
  final bool breakRowsAcrossPages;

  /// Gets the effective style for a row based on its type and index.
  GeniusPdfCellStyle getRowStyle(GeniusPdfGridRow row, int index) {
    if (row.isHeader) return headerStyle;
    if (row.isTotal) return totalRowStyle;
    if (row.isSubtotal) return subtotalRowStyle ?? totalRowStyle;
    if (row.isGroupHeader) return groupHeaderStyle ?? headerStyle;
    if (row.isSelected && selectedRowStyle != null) return selectedRowStyle!;
    if (row.isHighlighted && highlightedRowStyle != null) {
      return highlightedRowStyle!;
    }
    if (row.style != null) return row.style!;
    if (alternateRowColors && alternateRowStyle != null) {
      if ((index + alternateStartIndex) % 2 == 0) {
        return alternateRowStyle!;
      }
    }
    return cellStyle;
  }

  GeniusPdfGridStyle copyWith({
    GeniusPdfCellStyle? headerStyle,
    GeniusPdfCellStyle? cellStyle,
    GeniusPdfCellStyle? alternateRowStyle,
    GeniusPdfCellStyle? totalRowStyle,
    GeniusPdfCellStyle? subtotalRowStyle,
    GeniusPdfCellStyle? groupHeaderStyle,
    GeniusPdfCellStyle? selectedRowStyle,
    GeniusPdfCellStyle? highlightedRowStyle,
    GeniusPdfBorderStyle? borderStyle,
    GeniusPdfBorderStyle? outerBorderStyle,
    bool? showHeader,
    bool? repeatHeaderOnPages,
    bool? alternateRowColors,
    int? alternateStartIndex,
    double? cellSpacing,
    double? rowSpacing,
    double? defaultColumnWidth,
    double? minColumnWidth,
    double? maxColumnWidth,
    double? rowHeight,
    double? minRowHeight,
    double? maxRowHeight,
    double? headerHeight,
    double? groupHeaderHeight,
    double? horizontalPadding,
    double? verticalPadding,
    double? groupIndentPerLevel,
    bool? showGridLines,
    Color? gridLineColor,
    double? gridLineWidth,
    bool? showVerticalLines,
    bool? showHorizontalLines,
    bool? roundedCorners,
    double? cornerRadius,
    bool? shadowEnabled,
    Color? shadowColor,
    double? shadowOffset,
    double? shadowBlur,
    bool? clipContent,
    bool? fitToPage,
    bool? breakRowsAcrossPages,
  }) {
    return GeniusPdfGridStyle(
      headerStyle: headerStyle ?? this.headerStyle,
      cellStyle: cellStyle ?? this.cellStyle,
      alternateRowStyle: alternateRowStyle ?? this.alternateRowStyle,
      totalRowStyle: totalRowStyle ?? this.totalRowStyle,
      subtotalRowStyle: subtotalRowStyle ?? this.subtotalRowStyle,
      groupHeaderStyle: groupHeaderStyle ?? this.groupHeaderStyle,
      selectedRowStyle: selectedRowStyle ?? this.selectedRowStyle,
      highlightedRowStyle: highlightedRowStyle ?? this.highlightedRowStyle,
      borderStyle: borderStyle ?? this.borderStyle,
      outerBorderStyle: outerBorderStyle ?? this.outerBorderStyle,
      showHeader: showHeader ?? this.showHeader,
      repeatHeaderOnPages: repeatHeaderOnPages ?? this.repeatHeaderOnPages,
      alternateRowColors: alternateRowColors ?? this.alternateRowColors,
      alternateStartIndex: alternateStartIndex ?? this.alternateStartIndex,
      cellSpacing: cellSpacing ?? this.cellSpacing,
      rowSpacing: rowSpacing ?? this.rowSpacing,
      defaultColumnWidth: defaultColumnWidth ?? this.defaultColumnWidth,
      minColumnWidth: minColumnWidth ?? this.minColumnWidth,
      maxColumnWidth: maxColumnWidth ?? this.maxColumnWidth,
      rowHeight: rowHeight ?? this.rowHeight,
      minRowHeight: minRowHeight ?? this.minRowHeight,
      maxRowHeight: maxRowHeight ?? this.maxRowHeight,
      headerHeight: headerHeight ?? this.headerHeight,
      groupHeaderHeight: groupHeaderHeight ?? this.groupHeaderHeight,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      verticalPadding: verticalPadding ?? this.verticalPadding,
      groupIndentPerLevel: groupIndentPerLevel ?? this.groupIndentPerLevel,
      showGridLines: showGridLines ?? this.showGridLines,
      gridLineColor: gridLineColor ?? this.gridLineColor,
      gridLineWidth: gridLineWidth ?? this.gridLineWidth,
      showVerticalLines: showVerticalLines ?? this.showVerticalLines,
      showHorizontalLines: showHorizontalLines ?? this.showHorizontalLines,
      roundedCorners: roundedCorners ?? this.roundedCorners,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      shadowEnabled: shadowEnabled ?? this.shadowEnabled,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowOffset: shadowOffset ?? this.shadowOffset,
      shadowBlur: shadowBlur ?? this.shadowBlur,
      clipContent: clipContent ?? this.clipContent,
      fitToPage: fitToPage ?? this.fitToPage,
      breakRowsAcrossPages: breakRowsAcrossPages ?? this.breakRowsAcrossPages,
    );
  }
}
