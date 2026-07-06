import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final root = Directory('lib');

  test('presentation does not import platform plugins directly', () {
    final violations = <String>[];
    for (final file in _dartFiles(root)) {
      final path = file.path.replaceAll('\\', '/');
      if (!path.contains('/presentation/')) continue;
      final text = file.readAsStringSync();
      if (text.contains("package:path_provider/") ||
          text.contains("package:open_file/") ||
          text.contains("import 'dart:io'")) {
        violations.add(path);
      }
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('feature controllers do not import platform plugins directly', () {
    final violations = <String>[];
    for (final file in _dartFiles(Directory('lib/features'))) {
      final path = file.path.replaceAll('\\', '/');
      if (!path.contains('/controllers/')) continue;
      final text = file.readAsStringSync();
      if (text.contains("package:path_provider/") ||
          text.contains("package:open_file/") ||
          text.contains("import 'dart:io'")) {
        violations.add(path);
      }
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('application contracts are framework independent', () {
    final violations = <String>[];
    final directory = Directory('lib/shared/application');
    for (final file in _dartFiles(directory)) {
      final text = file.readAsStringSync();
      if (text.contains('package:flutter/') ||
          text.contains('package:path_provider/') ||
          text.contains('package:open_file/')) {
        violations.add(file.path);
      }
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('dashboard domain model remains framework independent', () {
    final file = File(
      'lib/features/dashboard/domain/models/dashboard_destination.dart',
    );
    final text = file.readAsStringSync();
    expect(text, isNot(contains('package:flutter/')));
    expect(text, isNot(contains('dart:io')));
  });

  test('feature implementations do not import main.dart', () {
    final violations = <String>[];
    for (final directory in [
      Directory('lib/app'),
      Directory('lib/features'),
      Directory('lib/shared'),
    ]) {
      for (final file in _dartFiles(directory)) {
        if (file.readAsStringSync().contains('main.dart')) {
          violations.add(file.path);
        }
      }
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('legacy folders contain compatibility exports only', () {
    final violations = <String>[];
    for (final directory in [
      Directory('lib/screens'),
      Directory('lib/documents'),
      Directory('lib/widgets'),
      Directory('lib/theme'),
      Directory('lib/data'),
    ]) {
      for (final file in _dartFiles(directory)) {
        final lines = file
            .readAsLinesSync()
            .where(
              (line) =>
                  line.trim().isNotEmpty && !line.trim().startsWith('//'),
            )
            .toList();
        if (lines.any((line) => !line.trimLeft().startsWith('export '))) {
          violations.add(file.path);
        }
      }
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });
}

Iterable<File> _dartFiles(Directory directory) sync* {
  if (!directory.existsSync()) return;
  for (final entity in directory.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) yield entity;
  }
}
