import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final packageRoot = Directory.current;

  test('domain is framework-free and depends on no outer layer', () {
    final violations = _findForbiddenDirectives(
      Directory('${packageRoot.path}/lib/src/domain'),
      const <String>[
        'package:flutter/',
        'package:syncfusion_flutter_pdf/',
        'package:printing/',
        'package:share_plus/',
        'package:path_provider/',
        'package:open_file/',
        '/application/',
        '/infrastructure/',
        '/presentation/',
        '/composition/',
        '/public/',
      ],
    );
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('application depends only on domain and its own contracts', () {
    final violations = _findForbiddenDirectives(
      Directory('${packageRoot.path}/lib/src/application'),
      const <String>[
        '/infrastructure/',
        '/presentation/',
        '/composition/',
        '/public/',
        'package:flutter/',
        'package:path_provider/',
        'package:open_file/',
        'package:printing/',
        'package:share_plus/',
        'package:syncfusion_flutter_pdf/',
      ],
    );
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('MVC controllers do not construct infrastructure adapters', () {
    final controllers = Directory(
      '${packageRoot.path}/lib/src/presentation/controllers',
    );
    final violations = _findForbiddenDirectives(
      controllers,
      const <String>[
        '/infrastructure/',
        '/composition/',
        'package:path_provider/',
        'package:open_file/',
        'package:printing/',
        'package:share_plus/',
        'package:syncfusion_flutter_pdf/',
      ],
      ignoreCompatibilityShims: true,
    );
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('only composition/public boundaries wire infrastructure to controllers', () {
    final violations = <String>[];
    final src = Directory('${packageRoot.path}/lib/src');
    for (final entity in src.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final normalized = entity.path.replaceAll('\\', '/');
      final allowed = normalized.contains('/composition/') ||
          normalized.contains('/infrastructure/') ||
          normalized.contains('/public/');
      if (allowed) continue;
      for (final record in _directives(entity)) {
        if (record.text.contains('/infrastructure/')) {
          violations.add('${entity.path}:${record.line}: ${record.text}');
        }
      }
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('print preview views delegate platform actions to a controller', () {
    final previewDirectory = Directory(
      '${packageRoot.path}/lib/src/printing/print_preview',
    );
    final violations = <String>[];
    for (final entity in previewDirectory.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final source = entity.readAsStringSync();
      if (source.contains('GeniusPrinterService.instance') ||
          source.contains('Printing.layoutPdf') ||
          source.contains('SharePlus.instance')) {
        violations.add(entity.path);
      }
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('export-only legacy source directories are not reintroduced', () {
    final legacyDirectories = [
      Directory('${packageRoot.path}/lib/src/core/financial'),
      Directory('${packageRoot.path}/lib/src/widgets'),
    ];

    final existing = legacyDirectories
        .where((directory) => directory.existsSync())
        .map((directory) => directory.path)
        .toList();

    expect(existing, isEmpty, reason: existing.join('\n'));
  });

  test('stable public facade does not depend on the legacy service facade', () {
    final client = File(
      '${packageRoot.path}/lib/src/public/genius_pdf_client.dart',
    ).readAsStringSync();
    expect(client, isNot(contains("../services/pdf_service.dart")));
    expect(client, isNot(contains('package:share_plus/')));
  });

  test('printing application and presentation do not import infrastructure', () {
    final violations = <String>[
      ..._findForbiddenDirectives(
        Directory('${packageRoot.path}/lib/src/printing/application'),
        const <String>[
          '/infrastructure/',
          '/composition/',
          'package:printing/',
          'package:share_plus/',
          'package:path_provider/',
        ],
      ),
      ..._findForbiddenDirectives(
        Directory('${packageRoot.path}/lib/src/printing/presentation'),
        const <String>[
          '/infrastructure/',
          'package:printing/',
          'package:share_plus/',
          'package:path_provider/',
        ],
      ),
    ];
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('part files contain no import or export directives', () {
    final violations = <String>[];
    final lib = Directory('${packageRoot.path}/lib');
    for (final entity in lib.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final source = entity.readAsStringSync();
      if (!source.contains('part of ')) continue;
      for (final record in _directives(entity)) {
        if (record.text.startsWith('import ') ||
            record.text.startsWith('export ')) {
          violations.add('${entity.path}:${record.line}: ${record.text}');
        }
      }
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('stable API does not re-export third-party libraries', () {
    final api = File(
      '${packageRoot.path}/lib/genius_link_pdf_generator_api.dart',
    ).readAsStringSync();
    expect(api, isNot(contains("export 'package:")));
    expect(api, isNot(contains('syncfusion_flutter_pdf')));
    expect(api, isNot(contains('share_plus')));
  });

  test('all part directives resolve to existing files', () {
    final violations = <String>[];
    final lib = Directory('${packageRoot.path}/lib');
    for (final entity in lib.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      for (final record in _directives(entity)) {
        if (!record.text.startsWith('part ')) continue;
        final uri = _quotedUri(record.text);
        if (uri == null || uri.startsWith('of ')) continue;
        final target = File('${entity.parent.path}/$uri');
        if (!target.existsSync()) {
          violations.add('${entity.path}:${record.line}: missing $uri');
        }
      }
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });
}

List<String> _findForbiddenDirectives(
  Directory directory,
  List<String> forbidden, {
  bool ignoreCompatibilityShims = false,
}) {
  if (!directory.existsSync()) return <String>[];
  final violations = <String>[];
  for (final entity in directory.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    final source = entity.readAsStringSync();
    if (ignoreCompatibilityShims &&
        source.contains('Backward-compatible import path')) {
      continue;
    }
    for (final record in _directives(entity)) {
      for (final token in forbidden) {
        if (record.text.contains(token)) {
          violations.add('${entity.path}:${record.line}: ${record.text}');
        }
      }
    }
  }
  return violations;
}

List<({int line, String text})> _directives(File file) {
  final result = <({int line, String text})>[];
  final lines = file.readAsLinesSync();
  for (var index = 0; index < lines.length; index++) {
    final line = lines[index].trim();
    if (line.startsWith('import ') ||
        line.startsWith('export ') ||
        (line.startsWith('part ') && !line.startsWith('part of '))) {
      result.add((line: index + 1, text: line));
    }
  }
  return result;
}

String? _quotedUri(String directive) {
  final single = RegExp("'([^']+)'").firstMatch(directive);
  if (single != null) return single.group(1);
  final doubleQuoted = RegExp(r'"([^"]+)"').firstMatch(directive);
  return doubleQuoted?.group(1);
}
