// Generated from the former aggregate verification page.
// The runner contains generation logic only; presentation lives in
// focused example screens.
// ignore_for_file: unused_element

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

/// Scenarios extracted from the former S22TemplateEngineVNextVerificationPage.
enum S22TemplateEngineVnextScenario {
  schema,
  legacyMigration,
  expressions,
  largeLoop,
  composition,
  scopedRegistry,
  directionality,
  invalidExpression,
}

/// Executes one focused S22 verification scenario.
class S22TemplateEngineVnextRunner {
  S22TemplateEngineVnextRunner({
    required GeniusPdfConfig baseConfig,
    required S22TemplateEngineVnextScenario scenario,
  })  : _baseConfig = baseConfig,
        _scenario = scenario;

  final GeniusPdfConfig _baseConfig;
  final S22TemplateEngineVnextScenario _scenario;
bool _rtl = false;
  int _rowCount = 10;
GeniusPdfConfig get _config => _baseConfig.copyWith(
        textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
      );

  String _label(S22TemplateEngineVnextScenario value) => switch (value) {
        S22TemplateEngineVnextScenario.schema => 'Versioned Schema + Elements',
        S22TemplateEngineVnextScenario.legacyMigration => 'Legacy v1 → v2 Migration',
        S22TemplateEngineVnextScenario.expressions => 'Safe Expressions + Aggregates',
        S22TemplateEngineVnextScenario.largeLoop => 'Bounded Large Loop',
        S22TemplateEngineVnextScenario.composition => 'Components / Styles / SubTemplate',
        S22TemplateEngineVnextScenario.scopedRegistry => 'Registry Fallback / History',
        S22TemplateEngineVnextScenario.directionality => 'Direction / Value Direction',
        S22TemplateEngineVnextScenario.invalidExpression => 'Invalid Expression Rejection',
      };

  String get _expected =>
      'Expected Result: ${_label(_scenario)} resolves through the S22 public '
      'API. Serialized schema stays renderer-independent. Unknown functions '
      'are rejected, repeats are bounded, style/component/subtemplate '
      'composition is deterministic, registry fallback is scope-aware, and '
      'value direction remains independent from ${_rtl ? 'RTL' : 'LTR'} '
      'layout direction.';

  GeniusPdfTemplateSchema _baseSchema({
    String id = 'demo.invoice',
    String? extendsTemplateId,
    GeniusPdfTemplateState state = GeniusPdfTemplateState.published,
    String variant = 'default',
    String? country,
    String? organization,
    String? branch,
  }) =>
      GeniusPdfTemplateSchema(
        templateId: id,
        templateVersion: 2,
        name: 'S22 Verification Template',
        state: state,
        variant: variant,
        country: country,
        organization: organization,
        branch: branch,
        family: 'transaction',
        extendsTemplateId: extendsTemplateId,
        direction: _rtl
            ? GeniusPdfDirection.rtl
            : GeniusPdfDirection.ltr,
        styles: const {
          'base': GeniusPdfTemplateStyle(
            values: {
              'fontSize': 10,
              'spacing': 4,
            },
          ),
          'strong': GeniusPdfTemplateStyle(
            parent: 'base',
            values: {'bold': true},
          ),
        },
        components: {
          'documentNumber': GeniusPdfTemplateElement.label(
            id: 'document-number',
            label: 'Document No.',
            valueExpression: 'document.number',
            valueDirection: GeniusPdfTemplateValueDirection.ltr,
          ),
        },
        elements: [
          GeniusPdfTemplateElement.section(
            id: 'header',
            children: [
              GeniusPdfTemplateElement.component(
                id: 'number-instance',
                componentRef: 'documentNumber',
              ),
              GeniusPdfTemplateElement.metric(
                id: 'grand-total',
                label: 'Grand Total',
                valueExpression: 'total',
              ),
              GeniusPdfTemplateElement.barcode(
                id: 'barcode',
                valueExpression: 'document.number',
              ),
              GeniusPdfTemplateElement.qrCode(
                id: 'qr',
                valueExpression: 'document.number',
              ),
            ],
          ),
          GeniusPdfTemplateElement.section(
            id: 'rows',
            repeatPath: 'items',
            children: [
              GeniusPdfTemplateElement.label(
                id: 'item-code',
                label: 'Code',
                valueExpression: r'$item.code',
                valueDirection: GeniusPdfTemplateValueDirection.ltr,
              ),
              GeniusPdfTemplateElement.label(
                id: 'item-description',
                label: 'Description',
                valueExpression: r'$item.description',
              ),
            ],
          ),
          GeniusPdfTemplateElement.pageBreak(id: 'break'),
          GeniusPdfTemplateElement.summary(
            id: 'summary',
            style: 'strong',
            items: const [
              {
                'label': 'Subtotal',
                'valueExpression': 'subtotal',
              },
              {
                'label': 'Tax',
                'valueExpression': 'tax',
              },
            ],
          ),
          GeniusPdfTemplateElement.signature(
            id: 'signature',
            signerExpression: 'approver.name',
          ),
          GeniusPdfTemplateElement.chart(
            id: 'chart',
            chartType: 'bar',
            dataPath: 'items',
            fallbackTableComponent: 'documentNumber',
          ),
          GeniusPdfTemplateElement.attachment(
            id: 'attachment',
            referenceExpression: 'attachment.reference',
          ),
          GeniusPdfTemplateElement.stamp(
            id: 'stamp',
            textExpression: 'status',
          ),
        ],
      );

  Map<String, Object?> _context() => {
        'document': {'number': 'INV-LATIN-2026-001'},
        'subtotal': 1000,
        'tax': 150,
        'total': 1150,
        'status': 'APPROVED',
        'approver': {'name': _rtl ? 'المدير 01' : 'Manager 01'},
        'attachment': {'reference': 'ATT-LATIN-001'},
        'items': List.generate(
          _rowCount,
          (index) => {
            'code': 'SKU-${index + 1}',
            'description': _rtl
                ? 'وصف عربي للصنف ${index + 1}'
                : 'Item description ${index + 1}',
            'group': index.isEven ? 'A' : 'B',
            'amount': index + 1,
          },
        ),
      };

  Future<Uint8List> generate() async {
    final registry = GeniusPdfTemplateRegistry(
      clock: () => DateTime(2026, 9, 4),
    );
    final context = _context();
    late GeniusPdfTemplateSchema schema;
    var diagnostic = '';

    switch (_scenario) {
      case S22TemplateEngineVnextScenario.schema:
        schema = _baseSchema();
        registry.register(schema);
        break;

      case S22TemplateEngineVnextScenario.legacyMigration:
        schema = GeniusPdfTemplateSchema.fromMap({
          'templateId': 'legacy.demo',
          'name': 'Legacy Definition',
          'items': [
            {
              'id': 'legacy-section',
              'type': 'section',
              'children': [
                {
                  'id': 'legacy-label',
                  'type': 'label',
                  'valueDirection': 'ltr',
                  'config': {
                    'label': 'Legacy Document',
                    'valueExpression': 'document.number',
                  },
                },
              ],
            },
          ],
        });
        diagnostic =
            'Migrated schemaVersion=${schema.schemaVersion} from implicit v1';
        break;

      case S22TemplateEngineVnextScenario.expressions:
        schema = _baseSchema();
        registry.register(schema);
        const expressions = GeniusPdfSafeExpressionEngine();
        final sum = expressions.evaluate(
          'sum(items, "amount")',
          context,
        );
        final grouped = expressions.evaluate(
          'groupSum(items, "group", "amount")',
          context,
        );
        final formatted = expressions.evaluate(
          'format(total, "money:SAR")',
          context,
        );
        diagnostic =
            'sum=$sum · groupSum=$grouped · formatted=$formatted';
        break;

      case S22TemplateEngineVnextScenario.largeLoop:
        schema = _baseSchema();
        registry.register(schema);
        diagnostic =
            'repeat count=$_rowCount; runtime maxRepeatItems=10000';
        break;

      case S22TemplateEngineVnextScenario.composition:
        final parent = _baseSchema(id: 'demo.parent');
        registry.register(parent);
        schema = GeniusPdfTemplateSchema(
          templateId: 'demo.child',
          templateVersion: 1,
          name: 'Child Template',
          state: GeniusPdfTemplateState.published,
          extendsTemplateId: 'demo.parent',
          direction: _rtl
              ? GeniusPdfDirection.rtl
              : GeniusPdfDirection.ltr,
          styles: const {
            'child': GeniusPdfTemplateStyle(
              parent: 'strong',
              values: {'fontSize': 12},
            ),
          },
          elements: [
            GeniusPdfTemplateElement.subTemplate(
              id: 'sub',
              templateId: 'demo.parent',
            ),
          ],
        );
        // Avoid circular inclusion in the actual child by demonstrating
        // inheritance and a separate subtemplate registry item.
        final sub = GeniusPdfTemplateSchema(
          templateId: 'demo.sub',
          templateVersion: 1,
          name: 'Sub',
          state: GeniusPdfTemplateState.published,
          elements: [
            GeniusPdfTemplateElement.metric(
              id: 'sub-metric',
              label: 'Sub metric',
              valueExpression: 'total',
            ),
          ],
        );
        registry.register(sub);
        schema = GeniusPdfTemplateSchema(
          templateId: 'demo.child',
          templateVersion: 1,
          name: 'Child Template',
          state: GeniusPdfTemplateState.published,
          extendsTemplateId: 'demo.parent',
          direction: _rtl
              ? GeniusPdfDirection.rtl
              : GeniusPdfDirection.ltr,
          styles: const {
            'child': GeniusPdfTemplateStyle(
              parent: 'strong',
              values: {'fontSize': 12},
            ),
          },
          elements: [
            GeniusPdfTemplateElement.subTemplate(
              id: 'sub',
              templateId: 'demo.sub',
            ),
          ],
        );
        registry.register(schema);
        break;

      case S22TemplateEngineVnextScenario.scopedRegistry:
        final generic = _baseSchema();
        registry.register(generic);
        registry.register(
          _baseSchema(country: 'XX'),
        );
        registry.register(
          _baseSchema(
            country: 'XX',
            organization: 'ORG-1',
            branch: 'BR-1',
          ),
        );
        schema = registry.resolve(
              const TemplateId('demo.invoice'),
              scope: GeniusPdfTemplateScope(
                country: 'XX',
                organization: 'ORG-1',
                branch: 'BR-1',
                at: DateTime(2026, 9, 4),
              ),
            ) ??
            generic;
        final history =
            registry.history(const TemplateId('demo.invoice'));
        diagnostic =
            'resolved branch=${schema.branch}; history=${history.length}; '
            'checksum=${history.last.checksum}';
        break;

      case S22TemplateEngineVnextScenario.directionality:
        schema = _baseSchema();
        registry.register(schema);
        diagnostic =
            'layout=${schema.direction.name}; barcode/valueDirection=ltr';
        break;

      case S22TemplateEngineVnextScenario.invalidExpression:
        schema = _baseSchema();
        registry.register(schema);
        const expressions = GeniusPdfSafeExpressionEngine();
        try {
          expressions.evaluate(
            'system("arbitrary-code")',
            context,
          );
          diagnostic = 'ERROR: invalid expression unexpectedly succeeded';
        } on FormatException catch (error) {
          diagnostic = 'Expected rejection: $error';
        }
        break;
    }

    if (diagnostic.isNotEmpty) {
      schema = GeniusPdfTemplateSchema(
        schemaVersion: schema.schemaVersion,
        templateId: schema.templateId,
        templateVersion: schema.templateVersion,
        name: schema.name,
        pack: schema.pack,
        variant: schema.variant,
        locale: schema.locale,
        country: schema.country,
        organization: schema.organization,
        branch: schema.branch,
        effectiveFrom: schema.effectiveFrom,
        effectiveTo: schema.effectiveTo,
        state: schema.state,
        direction: schema.direction,
        family: schema.family,
        extendsTemplateId: schema.extendsTemplateId,
        components: schema.components,
        styles: schema.styles,
        metadata: {
          ...schema.metadata,
          'diagnostic': diagnostic,
        },
        elements: [
          ...schema.elements,
          GeniusPdfTemplateElement.label(
            id: 'diagnostic',
            label: 'Diagnostic',
            valueExpression: 'diagnostic',
          ),
        ],
      );
      context['diagnostic'] = diagnostic;
    }

    final resolved = GeniusPdfTemplateEngine(
      registry: registry,
      maxRepeatItems: 10000,
    ).resolve(
      schema,
      context: context,
      localization: const {
        'customer': 'العميل',
      },
      scope: GeniusPdfTemplateScope(
        country: schema.country,
        organization: schema.organization,
        branch: schema.branch,
        at: DateTime(2026, 9, 4),
      ),
    );

    final document = GeniusPdfTemplateDiagnosticsDocument(
      _config,
      template: resolved,
    );
    final bytes = Uint8List.fromList(document.generate());
    document.dispose();
    return bytes;
  }
}

Future<Uint8List> buildS22SchemaVerificationPdf(
  GeniusPdfConfig config, {
  int rowCount = 10,
}) {
  final runner = S22TemplateEngineVnextRunner(
    baseConfig: config,
    scenario: S22TemplateEngineVnextScenario.schema,
  );
  runner._rowCount = rowCount;
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS22LegacyMigrationVerificationPdf(
  GeniusPdfConfig config, {
  int rowCount = 10,
}) {
  final runner = S22TemplateEngineVnextRunner(
    baseConfig: config,
    scenario: S22TemplateEngineVnextScenario.legacyMigration,
  );
  runner._rowCount = rowCount;
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS22ExpressionsVerificationPdf(
  GeniusPdfConfig config, {
  int rowCount = 10,
}) {
  final runner = S22TemplateEngineVnextRunner(
    baseConfig: config,
    scenario: S22TemplateEngineVnextScenario.expressions,
  );
  runner._rowCount = rowCount;
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS22LargeLoopVerificationPdf(
  GeniusPdfConfig config, {
  int rowCount = 10,
}) {
  final runner = S22TemplateEngineVnextRunner(
    baseConfig: config,
    scenario: S22TemplateEngineVnextScenario.largeLoop,
  );
  runner._rowCount = rowCount;
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS22CompositionVerificationPdf(
  GeniusPdfConfig config, {
  int rowCount = 10,
}) {
  final runner = S22TemplateEngineVnextRunner(
    baseConfig: config,
    scenario: S22TemplateEngineVnextScenario.composition,
  );
  runner._rowCount = rowCount;
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS22ScopedRegistryVerificationPdf(
  GeniusPdfConfig config, {
  int rowCount = 10,
}) {
  final runner = S22TemplateEngineVnextRunner(
    baseConfig: config,
    scenario: S22TemplateEngineVnextScenario.scopedRegistry,
  );
  runner._rowCount = rowCount;
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS22DirectionalityVerificationPdf(
  GeniusPdfConfig config, {
  int rowCount = 10,
}) {
  final runner = S22TemplateEngineVnextRunner(
    baseConfig: config,
    scenario: S22TemplateEngineVnextScenario.directionality,
  );
  runner._rowCount = rowCount;
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS22InvalidExpressionVerificationPdf(
  GeniusPdfConfig config, {
  int rowCount = 10,
}) {
  final runner = S22TemplateEngineVnextRunner(
    baseConfig: config,
    scenario: S22TemplateEngineVnextScenario.invalidExpression,
  );
  runner._rowCount = rowCount;
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}
