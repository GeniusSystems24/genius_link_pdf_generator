
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

GeniusPdfDesignerDocumentState state() {
  final schema = GeniusPdfTemplateSchema(
    templateId: 'designer.test',
    templateVersion: 1,
    name: 'Designer Test',
    state: GeniusPdfTemplateState.published,
    elements: [
      GeniusPdfTemplateElement.section(
        id: 'root',
        children: [
          GeniusPdfTemplateElement.label(
            id: 'number',
            label: 'Document',
            valueExpression: 'document.number',
            valueDirection: GeniusPdfTemplateValueDirection.ltr,
          ),
        ],
      ),
    ],
  );
  return GeniusPdfDesignerDocumentState(
    schema: schema,
    sampleData: const {
      'document': {'number': 'DOC-001'},
      'items': [
        {'name': 'A'},
        {'name': 'B'},
      ],
    },
  );
}

void main() {
  const controller = GeniusPdfDesignerAuthoringController();

  test('designer state sits on Template Engine vNext schema', () {
    final value = state();
    expect(value.schema.templateId, 'designer.test');
    expect(value.schema.elements.single.id, 'root');
  });

  test('drag/drop metadata catalog contains section and group', () {
    expect(
      GeniusPdfDesignerCatalog.components.any(
        (item) =>
            item.type == GeniusPdfTemplateElementType.section &&
            item.acceptsChildren,
      ),
      isTrue,
    );
    expect(GeniusPdfDesignerCatalog.commonProperties, isNotEmpty);
    expect(GeniusPdfDesignerCatalog.styleProperties, isNotEmpty);
  });

  test('authoring adds section and expression condition', () {
    var value = state();
    value = controller.addElement(
      value,
      GeniusPdfTemplateElement.section(id: 'extra'),
    );
    value = controller.updateElement(
      value,
      'extra',
      visibleWhen: 'document.number != null',
    );

    expect(value.schema.elements.last.id, 'extra');
    expect(value.schema.elements.last.visibleWhen, isNotNull);
  });

  test('named components styles and subtemplates remain schema-native', () {
    var value = state();
    value = controller.setNamedComponent(
      value,
      'customer',
      GeniusPdfTemplateElement.label(
        id: 'customer-label',
        label: 'Customer',
        valueExpression: 'customer.name',
      ),
    );
    value = controller.setStyle(
      value,
      'strong',
      const GeniusPdfTemplateStyle(
        values: {'bold': true},
      ),
    );
    value = controller.addSubTemplate(
      value,
      id: 'sub',
      templateId: 'shared.footer',
    );

    expect(value.schema.components, contains('customer'));
    expect(value.schema.styles, contains('strong'));
    expect(
      value.schema.elements.last.type,
      GeniusPdfTemplateElementType.subTemplate,
    );
  });

  test('preview supports sample data and EN/AR direction modes', () {
    var value = state();
    value = controller.setDirectionMode(
      value,
      GeniusPdfDesignerDirectionMode.arRtl,
    );
    value = controller.setPageProfile(value, 'thermal80');

    final registry = GeniusPdfTemplateRegistry();
    final preview = const GeniusPdfDesignerPreviewService().build(
      GeniusPdfDesignerPreviewRequest(state: value),
      registry: registry,
    );

    expect(preview.canPreview, isTrue);
    expect(
      preview.state.previewDirection,
      GeniusPdfDirection.rtl,
    );
    expect(preview.state.pageProfileId, 'thermal80');
  });

  test('validation messages stop preview for invalid schema', () {
    const invalid = GeniusPdfDesignerDocumentState(
      schema: GeniusPdfTemplateSchema(
        templateId: '',
        templateVersion: 1,
        name: '',
        elements: [],
      ),
    );

    final preview = const GeniusPdfDesignerPreviewService().build(
      const GeniusPdfDesignerPreviewRequest(state: invalid),
    );
    expect(preview.canPreview, isFalse);
    expect(preview.validation.messages, isNotEmpty);
  });
}
