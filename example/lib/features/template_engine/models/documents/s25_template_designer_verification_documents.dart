// Generated from the former aggregate verification page.
// The runner contains generation logic only; presentation lives in
// focused example screens.
// ignore_for_file: unused_element

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

/// Scenarios extracted from the former S25TemplateDesignerVerificationPage.
enum S25TemplateDesignerScenario {
  metadata,
  authoring,
  expressions,
  componentsStyles,
  validation,
  multiPage,
}

/// Executes one focused S25 verification scenario.
class S25TemplateDesignerRunner {
  S25TemplateDesignerRunner({
    required GeniusPdfConfig baseConfig,
    required S25TemplateDesignerScenario scenario,
  })  : _baseConfig = baseConfig,
        _scenario = scenario;

  final GeniusPdfConfig _baseConfig;
  final S25TemplateDesignerScenario _scenario;
GeniusPdfDesignerDirectionMode _direction =
      GeniusPdfDesignerDirectionMode.enLtr;
  String _profile = 'a4-portrait';
  int _rows = 10;
GeniusPdfConfig get _config => _baseConfig.copyWith(
        textDirection: _direction == GeniusPdfDesignerDirectionMode.arRtl
            ? TextDirection.rtl
            : TextDirection.ltr,
      );

  String _label(S25TemplateDesignerScenario value) => switch (value) {
        S25TemplateDesignerScenario.metadata => 'Designer Metadata',
        S25TemplateDesignerScenario.authoring => 'Drag / Drop + Sections',
        S25TemplateDesignerScenario.expressions => 'Conditions / Expressions',
        S25TemplateDesignerScenario.componentsStyles => 'Components / Styles',
        S25TemplateDesignerScenario.validation => 'Validation Messages',
        S25TemplateDesignerScenario.multiPage => 'Multi-page Sample Preview',
      };

  GeniusPdfDesignerDocumentState _state() {
    final schema = GeniusPdfTemplateSchema(
      templateId: 'designer.manual',
      templateVersion: 1,
      name: 'S25 Manual Designer Template',
      state: GeniusPdfTemplateState.published,
      direction: _direction == GeniusPdfDesignerDirectionMode.arRtl
          ? GeniusPdfDirection.rtl
          : GeniusPdfDirection.ltr,
      elements: [
        GeniusPdfTemplateElement.section(
          id: 'header',
          children: [
            GeniusPdfTemplateElement.label(
              id: 'document-number',
              label: 'Document No.',
              valueExpression: 'document.number',
              valueDirection: GeniusPdfTemplateValueDirection.ltr,
            ),
          ],
        ),
      ],
    );

    var value = GeniusPdfDesignerDocumentState(
      schema: schema,
      directionMode: _direction,
      pageProfileId: _profile,
      sampleData: {
        'document': {'number': 'DESIGN-LATIN-001'},
        'customer': {
          'name': _direction == GeniusPdfDesignerDirectionMode.arRtl
              ? 'عميل المصمم'
              : 'Designer Customer',
        },
        'items': List.generate(
          _rows,
          (index) => {
            'code': 'ITEM-${index + 1}',
            'name': _direction == GeniusPdfDesignerDirectionMode.arRtl
                ? 'صنف ${index + 1}'
                : 'Item ${index + 1}',
            'amount': (index + 1) * 10,
          },
        ),
      },
      localization: const {
        'customer': 'العميل',
      },
    );

    const authoring = GeniusPdfDesignerAuthoringController();

    switch (_scenario) {
      case S25TemplateDesignerScenario.metadata:
        return value;
      case S25TemplateDesignerScenario.authoring:
        value = authoring.addElement(
          value,
          GeniusPdfTemplateElement.section(
            id: 'items-section',
            repeatPath: 'items',
            children: [
              GeniusPdfTemplateElement.label(
                id: 'item-code',
                label: 'Code',
                valueExpression: r'$item.code',
                valueDirection: GeniusPdfTemplateValueDirection.ltr,
              ),
              GeniusPdfTemplateElement.label(
                id: 'item-name',
                label: 'Item',
                valueExpression: r'$item.name',
              ),
            ],
          ),
        );
        return value;
      case S25TemplateDesignerScenario.expressions:
        value = authoring.addElement(
          value,
          GeniusPdfTemplateElement.label(
            id: 'customer',
            label: 'Customer',
            valueExpression: 'customer.name',
          ),
        );
        value = authoring.updateElement(
          value,
          'customer',
          visibleWhen: 'customer.name != null',
        );
        return value;
      case S25TemplateDesignerScenario.componentsStyles:
        value = authoring.setNamedComponent(
          value,
          'customer-component',
          GeniusPdfTemplateElement.label(
            id: 'customer-component-label',
            label: 'Customer',
            valueExpression: 'customer.name',
          ),
        );
        value = authoring.setStyle(
          value,
          'strong',
          const GeniusPdfTemplateStyle(
            values: {'bold': true, 'fontSize': 12},
          ),
        );
        value = authoring.addElement(
          value,
          GeniusPdfTemplateElement.component(
            id: 'customer-instance',
            componentRef: 'customer-component',
          ),
        );
        return value;
      case S25TemplateDesignerScenario.validation:
        return authoring.withValidation(value);
      case S25TemplateDesignerScenario.multiPage:
        value = authoring.addElement(
          value,
          GeniusPdfTemplateElement.section(
            id: 'long-items',
            repeatPath: 'items',
            children: [
              GeniusPdfTemplateElement.label(
                id: 'long-item-code',
                label: 'Code',
                valueExpression: r'$item.code',
                valueDirection: GeniusPdfTemplateValueDirection.ltr,
              ),
              GeniusPdfTemplateElement.label(
                id: 'long-item-name',
                label: 'Description',
                valueExpression: r'$item.name',
              ),
              GeniusPdfTemplateElement.label(
                id: 'long-item-amount',
                label: 'Amount',
                valueExpression: r'$item.amount',
              ),
            ],
          ),
        );
        return value;
    }
  }

  Future<Uint8List> generate() async {
    final state = _state();
    final registry = GeniusPdfTemplateRegistry();
    final result = const GeniusPdfDesignerPreviewService().build(
      GeniusPdfDesignerPreviewRequest(
        state: state,
        maxRepeatItems: 10000,
      ),
      registry: registry,
    );

    final resolved = result.resolvedTemplate;
    if (resolved == null) {
      throw StateError(
        'Designer validation failed: ${result.validation.messages.join('; ')}',
      );
    }

    final document = GeniusPdfTemplateDiagnosticsDocument(
      _config,
      template: resolved,
    );
    final bytes = Uint8List.fromList(document.generate());
    document.dispose();
    return bytes;
  }


  String get _expected =>
      'Expected Result: ${_label(_scenario)} uses the real S25 state and S22 '
      'template engine. Direction=${_direction.name}, profile=$_profile, '
      'sample rows=$_rows. Structured document numbers remain LTR while '
      'AR/RTL content follows the selected preview mode.';
}

Future<Uint8List> buildS25MetadataVerificationPdf(
  GeniusPdfConfig config, {
  String profile = 'a4-portrait',
  int rows = 10,
}) {
  final runner = S25TemplateDesignerRunner(
    baseConfig: config,
    scenario: S25TemplateDesignerScenario.metadata,
  );
  runner._profile = profile;
  runner._rows = rows;
  runner._direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDesignerDirectionMode.arRtl
      : GeniusPdfDesignerDirectionMode.enLtr;
  return runner.generate();
}

Future<Uint8List> buildS25AuthoringVerificationPdf(
  GeniusPdfConfig config, {
  String profile = 'a4-portrait',
  int rows = 10,
}) {
  final runner = S25TemplateDesignerRunner(
    baseConfig: config,
    scenario: S25TemplateDesignerScenario.authoring,
  );
  runner._profile = profile;
  runner._rows = rows;
  runner._direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDesignerDirectionMode.arRtl
      : GeniusPdfDesignerDirectionMode.enLtr;
  return runner.generate();
}

Future<Uint8List> buildS25ExpressionsVerificationPdf(
  GeniusPdfConfig config, {
  String profile = 'a4-portrait',
  int rows = 10,
}) {
  final runner = S25TemplateDesignerRunner(
    baseConfig: config,
    scenario: S25TemplateDesignerScenario.expressions,
  );
  runner._profile = profile;
  runner._rows = rows;
  runner._direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDesignerDirectionMode.arRtl
      : GeniusPdfDesignerDirectionMode.enLtr;
  return runner.generate();
}

Future<Uint8List> buildS25ComponentsStylesVerificationPdf(
  GeniusPdfConfig config, {
  String profile = 'a4-portrait',
  int rows = 10,
}) {
  final runner = S25TemplateDesignerRunner(
    baseConfig: config,
    scenario: S25TemplateDesignerScenario.componentsStyles,
  );
  runner._profile = profile;
  runner._rows = rows;
  runner._direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDesignerDirectionMode.arRtl
      : GeniusPdfDesignerDirectionMode.enLtr;
  return runner.generate();
}

Future<Uint8List> buildS25ValidationVerificationPdf(
  GeniusPdfConfig config, {
  String profile = 'a4-portrait',
  int rows = 10,
}) {
  final runner = S25TemplateDesignerRunner(
    baseConfig: config,
    scenario: S25TemplateDesignerScenario.validation,
  );
  runner._profile = profile;
  runner._rows = rows;
  runner._direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDesignerDirectionMode.arRtl
      : GeniusPdfDesignerDirectionMode.enLtr;
  return runner.generate();
}

Future<Uint8List> buildS25MultiPageVerificationPdf(
  GeniusPdfConfig config, {
  String profile = 'a4-portrait',
  int rows = 10,
}) {
  final runner = S25TemplateDesignerRunner(
    baseConfig: config,
    scenario: S25TemplateDesignerScenario.multiPage,
  );
  runner._profile = profile;
  runner._rows = rows;
  runner._direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDesignerDirectionMode.arRtl
      : GeniusPdfDesignerDirectionMode.enLtr;
  return runner.generate();
}
