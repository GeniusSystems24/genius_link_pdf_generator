import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final source = File(
    'lib/src/components/widgets/pdf_data_grid/vnext.dart',
  ).readAsStringSync();

  test('S04-T01..T07 sizing/overflow APIs exist', () {
    for (final token in <String>[
      'GeniusPdfGridWidthMode',
      'fixed',
      'flex',
      'autoFit',
      'minWidth',
      'maxWidth',
      'GeniusPdfGridTextOverflow',
      'decimalPlaces',
    ]) {
      expect(source, contains(token), reason: token);
    }
  });

  test('S04-T08..T20 pagination/grouping/summary APIs exist', () {
    for (final token in <String>[
      'repeatHeaderOnPages',
      'GeniusPdfGridRowSplitPolicy',
      'repeatGroupHeaders',
      'GeniusPdfGridGroupDefinition',
      'GeniusPdfGridSummaryExpression',
      '_buildGroups',
      '_summaryRow',
      'groupIndentPerLevel',
    ]) {
      expect(source, contains(token), reason: token);
    }
  });

  test('S04-T21..T27 cell structure APIs exist', () {
    for (final token in <String>[
      'GeniusPdfGridCellSpan',
      'rowSpan',
      'columnSpan',
      'GeniusPdfGridRowBuilder',
      'GeniusPdfGridCellBuilder',
      'GeniusPdfGridRowStyleBuilder',
      'GeniusPdfGridCellStyleBuilder',
      'GeniusPdfGridEmptyState',
    ]) {
      expect(source, contains(token), reason: token);
    }
  });

  test('S04-T28..T39 formatter and direction APIs exist', () {
    for (final token in <String>[
      'GeniusPdfGridFormatterHooks',
      'GeniusPdfGridValueKind.money',
      'GeniusPdfGridValueKind.percentage',
      'GeniusPdfGridValueKind.quantity',
      'GeniusPdfGridValueKind.dateTime',
      'GeniusPdfGridAccountingStyle',
      'accountingNegative',
      'currencyResolver',
      'followDirection',
      'preserveDefinitionOrder',
      'headerDirection',
      'contentDirection',
      'GeniusPdfGridDirectionalPadding',
    ]) {
      expect(source, contains(token), reason: token);
    }
  });

  test('S04-T40..T44 performance APIs exist', () {
    for (final token in <String>[
      'GeniusPdfGridRowSource',
      'GeniusPdfGridLazyRowSource',
      'veryLargeDataMode',
      '_widthCache',
      '_styleCache',
      'GeniusPdfGridBenchmarkResult',
      'benchmark({',
    ]) {
      expect(source, contains(token), reason: token);
    }
  });

  test('vNext composes the established renderer', () {
    expect(source, contains('GeniusPdfDataGrid('));
    expect(source, contains('legacy._buildGrid('));
  });

  test('S05 formatter engine is not implemented prematurely', () {
    expect(source, isNot(contains('class GeniusPdfFormatter')));
  });
}
