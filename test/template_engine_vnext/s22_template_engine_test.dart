
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

GeniusPdfTemplateSchema schema({
  GeniusPdfTemplateState state = GeniusPdfTemplateState.published,
  String variant = 'default',
  String? locale,
  String? country,
  String? organization,
  String? branch,
}) =>
    GeniusPdfTemplateSchema(
      templateId: 'erp.invoice',
      templateVersion: 2,
      name: 'Invoice vNext',
      state: state,
      variant: variant,
      locale: locale,
      country: country,
      organization: organization,
      branch: branch,
      family: 'transaction',
      direction: GeniusPdfDirection.rtl,
      styles: const {
        'base': GeniusPdfTemplateStyle(
          values: {'fontSize': 10},
        ),
        'strong': GeniusPdfTemplateStyle(
          parent: 'base',
          values: {'bold': true},
        ),
      },
      components: {
        'customer': GeniusPdfTemplateElement.label(
          id: 'customer-label',
          label: 'Customer',
          valueExpression: 'customer.name',
        ),
      },
      elements: [
        GeniusPdfTemplateElement.section(
          id: 'body',
          children: [
            GeniusPdfTemplateElement.component(
              id: 'customer-instance',
              componentRef: 'customer',
            ),
            GeniusPdfTemplateElement.metric(
              id: 'total',
              label: 'Total',
              valueExpression: 'total',
            ),
            GeniusPdfTemplateElement.barcode(
              id: 'barcode',
              valueExpression: 'document.number',
            ),
          ],
        ),
      ],
    );

void main() {
  test('schema migration treats missing schemaVersion as v1', () {
    final migrated =
        const GeniusPdfTemplateSchemaMigrator().migrate({
      'templateId': 'legacy',
      'name': 'Legacy',
      'items': [
        {
          'id': 'section-1',
          'type': 'section',
        }
      ],
    });

    expect(
      migrated['schemaVersion'],
      GeniusPdfTemplateSchema.currentSchemaVersion,
    );
    expect(migrated['elements'], isA<List>());
    expect(migrated.containsKey('items'), isFalse);
  });

  test('unknown element reports a readable schema error', () {
    expect(
      () => GeniusPdfTemplateSchema.fromMap({
        'schemaVersion': 2,
        'templateId': 'bad',
        'templateVersion': 1,
        'name': 'Bad',
        'elements': [
          {'id': 'x', 'type': 'executeCode'}
        ],
      }),
      throwsA(isA<GeniusPdfTemplateSchemaException>()),
    );
  });

  test('safe expressions support nested access arithmetic and null safety', () {
    const engine = GeniusPdfSafeExpressionEngine();
    final context = <String, Object?>{
      'invoice': {
        'subtotal': 100,
        'tax': 15,
        'customer': null,
      },
    };

    expect(
      engine.evaluate(
        'invoice.subtotal + invoice.tax',
        context,
      ),
      115,
    );
    expect(
      engine.evaluate(
        'invoice.customer.name ?? "N/A"',
        context,
      ),
      'N/A',
    );
  });

  test('safe engine rejects arbitrary functions', () {
    const engine = GeniusPdfSafeExpressionEngine();
    expect(
      () => engine.evaluate(
        'system("rm -rf")',
        const {},
      ),
      throwsFormatException,
    );
  });

  test('aggregates group aggregates formatters and localization work', () {
    const engine = GeniusPdfSafeExpressionEngine();
    final context = <String, Object?>{
      'items': [
        {'group': 'A', 'amount': 10},
        {'group': 'A', 'amount': 20},
        {'group': 'B', 'amount': 5},
      ],
    };

    expect(engine.evaluate('sum(items, "amount")', context), 35);
    expect(
      engine.evaluate(
        'groupSum(items, "group", "amount")',
        context,
      ),
      {'A': 30, 'B': 5},
    );
    expect(
      engine.evaluate('format(12.345, "number:2")', context),
      '12.35',
    );
    expect(
      engine.evaluate(
        't("customer")',
        context,
        localization: const {'customer': 'العميل'},
      ),
      'العميل',
    );
  });

  test('large repeat is bounded and does not execute arbitrary code', () {
    final registry = GeniusPdfTemplateRegistry();
    final repeated = GeniusPdfTemplateSchema(
      templateId: 'loop',
      templateVersion: 1,
      name: 'Loop',
      state: GeniusPdfTemplateState.published,
      elements: [
        GeniusPdfTemplateElement.section(
          id: 'row',
          repeatPath: 'items',
        ),
      ],
    );
    registry.register(repeated);
    final engine = GeniusPdfTemplateEngine(
      registry: registry,
      maxRepeatItems: 100,
    );

    expect(
      () => engine.resolve(
        repeated,
        context: {
          'items': List.generate(101, (index) => {'id': index}),
        },
      ),
      throwsStateError,
    );
  });

  test('registry fallback prefers branch then organization then country', () {
    final registry = GeniusPdfTemplateRegistry(
      clock: () => DateTime(2026, 9, 4),
    );

    registry.register(schema());
    registry.register(schema(country: 'XX'));
    registry.register(schema(
      country: 'XX',
      organization: 'ORG-1',
    ));
    registry.register(schema(
      country: 'XX',
      organization: 'ORG-1',
      branch: 'BR-1',
    ));

    final value = registry.resolve(
      const TemplateId('erp.invoice'),
      scope: GeniusPdfTemplateScope(
        country: 'XX',
        organization: 'ORG-1',
        branch: 'BR-1',
        at: DateTime(2026, 9, 4),
      ),
    );

    expect(value!.branch, 'BR-1');
  });

  test('registry records checksum history and supports rollback', () {
    final registry = GeniusPdfTemplateRegistry();
    final original = schema();
    registry.register(original);

    final history =
        registry.history(const TemplateId('erp.invoice'));
    expect(history, isNotEmpty);
    expect(history.single.checksum, hasLength(16));

    final rolledBack = registry.rollback(
      const TemplateId('erp.invoice'),
      checksum: history.single.checksum,
    );
    expect(rolledBack.templateId, 'erp.invoice');
  });

  test('serialized schema contains no renderer-specific objects', () {
    final json = jsonEncode(schema().toMap());
    for (final forbidden in [
      'PdfDocument',
      'PdfPage',
      'PdfBrush',
      'PdfFont',
      'PdfGrid',
    ]) {
      expect(json, isNot(contains(forbidden)));
    }
  });

  test('direction and value direction resolve independently', () {
    final registry = GeniusPdfTemplateRegistry();
    final value = schema();
    registry.register(value);
    final resolved =
        GeniusPdfTemplateEngine(registry: registry).resolve(
      value,
      context: const {
        'customer': {'name': 'عميل'},
        'total': 115,
        'document': {'number': 'INV-LATIN-001'},
      },
    );

    final section = resolved.elements.single;
    final barcode = section.children.last;
    expect(section.direction, GeniusPdfDirection.rtl);
    expect(
      barcode.valueDirection,
      GeniusPdfTemplateValueDirection.ltr,
    );
  });
}
