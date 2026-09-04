import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final formatter = File('lib/src/core/pdf_formatter.dart').readAsStringSync();
  final theme = File('lib/src/core/pdf_theme.dart').readAsStringSync();
  final column = File('lib/src/components/models/grid_models/column.dart').readAsStringSync();
  final vnext = File('lib/src/components/widgets/pdf_data_grid/vnext.dart').readAsStringSync();

  test('S05 formatting API exists', () {
    for (final token in <String>[
      'abstract class GeniusPdfFormatter', 'formatMoney(', 'formatNumber(',
      'formatQuantity(', 'formatPercentage(', 'formatDate(', 'formatTime(',
      'formatIdentifier(', 'GeniusPdfNullPlaceholderPolicy',
      'GeniusPdfDigitPolicy', 'formatExchangeRate(', 'formatUnit(',
    ]) {
      expect(formatter, contains(token), reason: token);
    }
  });

  test('S05 theme/token API exists', () {
    for (final token in <String>[
      'class GeniusPdfTheme', 'GeniusPdfSemanticColors',
      'GeniusPdfLogicalSpacingTokens', 'GeniusPdfLogicalBorderTokens',
      'GeniusPdfTypographyAlignmentTokens', 'GeniusPdfTableThemeTokens',
      'GeniusPdfDocumentThemeTokens', 'GeniusPdfSummaryHighlightTokens',
    ]) {
      expect(theme, contains(token), reason: token);
    }
  });

  test('duplicate grid format helpers are removed', () {
    expect(column, isNot(contains('_formatWithThousandSeparator')));
    expect(column, isNot(contains('static String _formatDate')));
    expect(vnext, isNot(contains('  String _formatMoney(')));
    expect(vnext, contains('config.formatter.formatMoney('));
    expect(vnext, contains('config.formatter.formatIdentifier('));
  });
}
