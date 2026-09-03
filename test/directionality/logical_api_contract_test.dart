import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final source = File('lib/src/core/directionality.dart').readAsStringSync();

  test('logical alignment uses start/end/center only', () {
    final match = RegExp(
      r'enum GeniusPdfLogicalAlignment\s*\{(?<body>[\s\S]*?)\}',
    ).firstMatch(source);
    expect(match, isNotNull);
    final body = match!.namedGroup('body')!;
    expect(body, contains('start'));
    expect(body, contains('center'));
    expect(body, contains('end'));
    expect(body, isNot(contains(RegExp(r'\bleft\b'))));
    expect(body, isNot(contains(RegExp(r'\bright\b'))));
  });

  test('logical position uses leading/trailing only', () {
    final match = RegExp(
      r'enum GeniusPdfLogicalPosition\s*\{(?<body>[\s\S]*?)\}',
    ).firstMatch(source);
    expect(match, isNotNull);
    final body = match!.namedGroup('body')!;
    expect(body, contains('leading'));
    expect(body, contains('trailing'));
    expect(body, isNot(contains(RegExp(r'\bleft\b'))));
    expect(body, isNot(contains(RegExp(r'\bright\b'))));
  });

  test('directional insets expose start/end, not left/right inputs', () {
    final start = source.indexOf('class GeniusPdfDirectionalInsets');
    final end = source.indexOf('class GeniusPdfPhysicalInsets');
    expect(start, greaterThanOrEqualTo(0));
    expect(end, greaterThan(start));
    final block = source.substring(start, end);
    expect(block, contains('this.start'));
    expect(block, contains('this.end'));
    expect(block, isNot(contains('this.left')));
    expect(block, isNot(contains('this.right')));
  });
}
