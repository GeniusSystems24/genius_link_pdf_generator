import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('legacy entrypoint keeps every baseline public type', () {
    final expected = File(
      'test/architecture/public_api_baseline.txt',
    ).readAsLinesSync().where((line) => line.trim().isNotEmpty).toSet();
    final actual = _collectExportedTypes(
      File('lib/genius_link_pdf_generator.dart'),
      Directory('lib'),
    );
    final missing = expected.difference(actual).toList()..sort();
    expect(missing, isEmpty, reason: 'Missing public types:\n${missing.join('\n')}');
  });
}

Set<String> _collectExportedTypes(File entrypoint, Directory libDirectory) {
  final symbols = <String>{};
  final visited = <String>{};
  final declaration = RegExp(
    r'^(?:(?:abstract|base|final|sealed|interface)\s+)*'
    r'(?:class|enum|mixin|extension(?:\s+type)?|typedef)\s+'
    r'([A-Za-z_]\w*)',
    multiLine: true,
  );
  final directive = RegExp(
    r'''^(export|part)\s+['"]([^'"]+)['"]''',
    multiLine: true,
  );

  void visit(File file) {
    final canonical = file.absolute.path;
    if (!file.existsSync() || !visited.add(canonical)) return;
    final source = file.readAsStringSync();
    for (final match in declaration.allMatches(source)) {
      final name = match.group(1)!;
      if (!name.startsWith('_')) symbols.add(name);
    }
    for (final match in directive.allMatches(source)) {
      final uri = match.group(2)!;
      File? target;
      if (uri.startsWith('package:genius_link_pdf_generator/')) {
        target = File(
          '${libDirectory.path}/${uri.split('/').skip(1).join('/')}',
        );
      } else if (!uri.startsWith('package:') && !uri.startsWith('dart:')) {
        target = File('${file.parent.path}/$uri');
      }
      if (target != null) visit(target);
    }
  }

  visit(entrypoint);
  return symbols;
}
