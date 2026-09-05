
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/create_save_open_pdf_button.dart';
enum _S25Scenario {
  metadata,
  authoring,
  expressions,
  componentsStyles,
  validation,
  multiPage,
}

class S25TemplateDesignerVerificationPage extends StatefulWidget {
  const S25TemplateDesignerVerificationPage({super.key});

  @override
  State<S25TemplateDesignerVerificationPage> createState() =>
      _S25TemplateDesignerVerificationPageState();
}

class _S25TemplateDesignerVerificationPageState
    extends State<S25TemplateDesignerVerificationPage> {
  _S25Scenario _scenario = _S25Scenario.authoring;
  GeniusPdfDesignerDirectionMode _direction =
      GeniusPdfDesignerDirectionMode.enLtr;
  String _profile = 'a4-portrait';
  int _rows = 10;
  late Future<Uint8List> _pdf;

  @override
  void initState() {
    super.initState();
    _pdf = _generate();
  }

  GeniusPdfConfig get _config => geniusPdfConfig.copyWith(
        textDirection: _direction == GeniusPdfDesignerDirectionMode.arRtl
            ? TextDirection.rtl
            : TextDirection.ltr,
      );

  String _label(_S25Scenario value) => switch (value) {
        _S25Scenario.metadata => 'Designer Metadata',
        _S25Scenario.authoring => 'Drag / Drop + Sections',
        _S25Scenario.expressions => 'Conditions / Expressions',
        _S25Scenario.componentsStyles => 'Components / Styles',
        _S25Scenario.validation => 'Validation Messages',
        _S25Scenario.multiPage => 'Multi-page Sample Preview',
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
      case _S25Scenario.metadata:
        return value;
      case _S25Scenario.authoring:
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
      case _S25Scenario.expressions:
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
      case _S25Scenario.componentsStyles:
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
      case _S25Scenario.validation:
        return authoring.withValidation(value);
      case _S25Scenario.multiPage:
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

  Future<Uint8List> _generate() async {
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

  void _refresh() {
    setState(() => _pdf = _generate());
  }

  String get _expected =>
      'Expected Result: ${_label(_scenario)} uses the real S25 state and S22 '
      'template engine. Direction=${_direction.name}, profile=$_profile, '
      'sample rows=$_rows. Structured document numbers remain LTR while '
      'AR/RTL content follows the selected preview mode.';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Sprint S25 — Template Designer',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      SizedBox(
                        width: 270,
                        child: DropdownButtonFormField<_S25Scenario>(
                          initialValue: _scenario,
                          decoration: const InputDecoration(
                            labelText: 'Scenario',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            for (final value in _S25Scenario.values)
                              DropdownMenuItem(
                                value: value,
                                child: Text(_label(value)),
                              ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            _scenario = value;
                            _refresh();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 190,
                        child: DropdownButtonFormField<GeniusPdfDesignerDirectionMode>(
                          initialValue: _direction,
                          decoration: const InputDecoration(
                            labelText: 'Direction',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            for (final value
                                in GeniusPdfDesignerDirectionMode.values)
                              DropdownMenuItem(
                                value: value,
                                child: Text(value.name),
                              ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            _direction = value;
                            _refresh();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 170,
                        child: DropdownButtonFormField<String>(
                          initialValue: _profile,
                          decoration: const InputDecoration(
                            labelText: 'Page Profile',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'a4-portrait',
                              child: Text('A4 Portrait'),
                            ),
                            DropdownMenuItem(
                              value: 'thermal80',
                              child: Text('Thermal 80'),
                            ),
                            DropdownMenuItem(
                              value: 'labelSheet',
                              child: Text('Label Sheet'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            _profile = value;
                            _refresh();
                          },
                        ),
                      ),
                      SegmentedButton<int>(
                        segments: const [
                          ButtonSegment(value: 10, label: Text('10')),
                          ButtonSegment(value: 100, label: Text('100')),
                          ButtonSegment(value: 500, label: Text('500')),
                        ],
                        selected: {_rows},
                        onSelectionChanged: (value) {
                          _rows = value.first;
                          _refresh();
                        },
                      ),
                      FilledButton.icon(
                        onPressed: _refresh,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Regenerate PDF'),
                      ),
                      CreateSaveOpenPdfButton(
                        onCreate: _generate,
                        fileName: 's25_template_designer.pdf',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(_expected),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: FutureBuilder<Uint8List>(
                future: _pdf,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: SelectableText(
                        'Generation failed:\n${snapshot.error}',
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return GeniusPdfPreviewWidget(
                    pdfData: snapshot.data!,
                    canChangeOrientation: false,
                    canChangePageFormat: false,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
