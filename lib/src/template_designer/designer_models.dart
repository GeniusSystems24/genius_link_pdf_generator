
import '../core/directionality.dart';
import '../template_engine_vnext/template_engine_vnext.dart';

enum GeniusPdfDesignerDirectionMode {
  enLtr,
  arRtl,
  bilingual,
}

enum GeniusPdfDesignerPropertyType {
  text,
  multilineText,
  number,
  boolean,
  select,
  expression,
  binding,
  color,
  spacing,
  direction,
}

enum GeniusPdfDesignerDropPosition {
  before,
  inside,
  after,
}

class GeniusPdfDesignerComponentMetadata {
  const GeniusPdfDesignerComponentMetadata({
    required this.type,
    required this.label,
    required this.category,
    this.labelAr,
    this.iconKey,
    this.acceptsChildren = false,
    this.allowedParents = const [],
    this.defaultConfig = const {},
  });

  final GeniusPdfTemplateElementType type;
  final String label;
  final String? labelAr;
  final String category;
  final String? iconKey;
  final bool acceptsChildren;
  final List<GeniusPdfTemplateElementType> allowedParents;
  final Map<String, Object?> defaultConfig;
}

class GeniusPdfDesignerPropertyOption {
  const GeniusPdfDesignerPropertyOption({
    required this.value,
    required this.label,
    this.labelAr,
  });

  final Object? value;
  final String label;
  final String? labelAr;
}

class GeniusPdfDesignerPropertySchema {
  const GeniusPdfDesignerPropertySchema({
    required this.key,
    required this.label,
    required this.type,
    this.labelAr,
    this.required = false,
    this.defaultValue,
    this.options = const [],
    this.helpText,
    this.helpTextAr,
  });

  final String key;
  final String label;
  final String? labelAr;
  final GeniusPdfDesignerPropertyType type;
  final bool required;
  final Object? defaultValue;
  final List<GeniusPdfDesignerPropertyOption> options;
  final String? helpText;
  final String? helpTextAr;
}

class GeniusPdfDesignerStyleProperty {
  const GeniusPdfDesignerStyleProperty({
    required this.key,
    required this.label,
    required this.type,
    this.labelAr,
    this.defaultValue,
    this.inheritable = true,
  });

  final String key;
  final String label;
  final String? labelAr;
  final GeniusPdfDesignerPropertyType type;
  final Object? defaultValue;
  final bool inheritable;
}

class GeniusPdfDesignerBinding {
  const GeniusPdfDesignerBinding({
    required this.property,
    required this.expression,
    this.fallback,
  });

  final String property;
  final String expression;
  final Object? fallback;

  Map<String, Object?> toMap() => {
        'property': property,
        'expression': expression,
        if (fallback != null) 'fallback': fallback,
      };
}

class GeniusPdfDesignerNode {
  const GeniusPdfDesignerNode({
    required this.element,
    this.bindings = const [],
    this.locked = false,
    this.hiddenInDesigner = false,
  });

  final GeniusPdfTemplateElement element;
  final List<GeniusPdfDesignerBinding> bindings;
  final bool locked;
  final bool hiddenInDesigner;

  GeniusPdfDesignerNode copyWith({
    GeniusPdfTemplateElement? element,
    List<GeniusPdfDesignerBinding>? bindings,
    bool? locked,
    bool? hiddenInDesigner,
  }) =>
      GeniusPdfDesignerNode(
        element: element ?? this.element,
        bindings: bindings ?? this.bindings,
        locked: locked ?? this.locked,
        hiddenInDesigner:
            hiddenInDesigner ?? this.hiddenInDesigner,
      );
}

class GeniusPdfDesignerDocumentState {
  const GeniusPdfDesignerDocumentState({
    required this.schema,
    this.selectedElementId,
    this.directionMode = GeniusPdfDesignerDirectionMode.enLtr,
    this.sampleData = const {},
    this.localization = const {},
    this.validationMessages = const [],
    this.pageProfileId = 'a4-portrait',
    this.revision = 0,
  });

  final GeniusPdfTemplateSchema schema;
  final String? selectedElementId;
  final GeniusPdfDesignerDirectionMode directionMode;
  final Map<String, Object?> sampleData;
  final Map<String, String> localization;
  final List<String> validationMessages;
  final String pageProfileId;
  final int revision;

  GeniusPdfDirection get previewDirection => switch (directionMode) {
        GeniusPdfDesignerDirectionMode.enLtr =>
          GeniusPdfDirection.ltr,
        GeniusPdfDesignerDirectionMode.arRtl =>
          GeniusPdfDirection.rtl,
        GeniusPdfDesignerDirectionMode.bilingual =>
          GeniusPdfDirection.auto,
      };

  GeniusPdfDesignerDocumentState copyWith({
    GeniusPdfTemplateSchema? schema,
    String? selectedElementId,
    bool clearSelection = false,
    GeniusPdfDesignerDirectionMode? directionMode,
    Map<String, Object?>? sampleData,
    Map<String, String>? localization,
    List<String>? validationMessages,
    String? pageProfileId,
    int? revision,
  }) =>
      GeniusPdfDesignerDocumentState(
        schema: schema ?? this.schema,
        selectedElementId:
            clearSelection ? null : selectedElementId ?? this.selectedElementId,
        directionMode: directionMode ?? this.directionMode,
        sampleData: sampleData ?? this.sampleData,
        localization: localization ?? this.localization,
        validationMessages:
            validationMessages ?? this.validationMessages,
        pageProfileId: pageProfileId ?? this.pageProfileId,
        revision: revision ?? this.revision,
      );
}

/// S25-T02/T03 component and property metadata catalog.
class GeniusPdfDesignerCatalog {
  const GeniusPdfDesignerCatalog._();

  static const components = <GeniusPdfDesignerComponentMetadata>[
    GeniusPdfDesignerComponentMetadata(
      type: GeniusPdfTemplateElementType.section,
      label: 'Section',
      labelAr: 'قسم',
      category: 'Layout',
      iconKey: 'section',
      acceptsChildren: true,
    ),
    GeniusPdfDesignerComponentMetadata(
      type: GeniusPdfTemplateElementType.group,
      label: 'Group',
      labelAr: 'مجموعة',
      category: 'Layout',
      iconKey: 'group',
      acceptsChildren: true,
    ),
    GeniusPdfDesignerComponentMetadata(
      type: GeniusPdfTemplateElementType.label,
      label: 'Label',
      labelAr: 'بيان',
      category: 'Content',
      iconKey: 'label',
    ),
    GeniusPdfDesignerComponentMetadata(
      type: GeniusPdfTemplateElementType.summary,
      label: 'Summary',
      labelAr: 'ملخص',
      category: 'ERP',
      iconKey: 'summary',
    ),
    GeniusPdfDesignerComponentMetadata(
      type: GeniusPdfTemplateElementType.metric,
      label: 'Metric',
      labelAr: 'مؤشر',
      category: 'ERP',
      iconKey: 'metric',
    ),
    GeniusPdfDesignerComponentMetadata(
      type: GeniusPdfTemplateElementType.barcode,
      label: 'Barcode',
      labelAr: 'باركود',
      category: 'Codes',
      iconKey: 'barcode',
    ),
    GeniusPdfDesignerComponentMetadata(
      type: GeniusPdfTemplateElementType.qrCode,
      label: 'QR Code',
      labelAr: 'رمز QR',
      category: 'Codes',
      iconKey: 'qr',
    ),
    GeniusPdfDesignerComponentMetadata(
      type: GeniusPdfTemplateElementType.signature,
      label: 'Signature',
      labelAr: 'توقيع',
      category: 'ERP',
      iconKey: 'signature',
    ),
    GeniusPdfDesignerComponentMetadata(
      type: GeniusPdfTemplateElementType.chart,
      label: 'Chart',
      labelAr: 'مخطط',
      category: 'Visualization',
      iconKey: 'chart',
    ),
    GeniusPdfDesignerComponentMetadata(
      type: GeniusPdfTemplateElementType.attachment,
      label: 'Attachment',
      labelAr: 'مرفق',
      category: 'Content',
      iconKey: 'attachment',
    ),
    GeniusPdfDesignerComponentMetadata(
      type: GeniusPdfTemplateElementType.stamp,
      label: 'Stamp',
      labelAr: 'ختم',
      category: 'ERP',
      iconKey: 'stamp',
    ),
    GeniusPdfDesignerComponentMetadata(
      type: GeniusPdfTemplateElementType.pageBreak,
      label: 'Page Break',
      labelAr: 'فاصل صفحة',
      category: 'Layout',
      iconKey: 'page-break',
    ),
    GeniusPdfDesignerComponentMetadata(
      type: GeniusPdfTemplateElementType.subTemplate,
      label: 'SubTemplate',
      labelAr: 'قالب فرعي',
      category: 'Composition',
      iconKey: 'subtemplate',
    ),
  ];

  static const commonProperties = <GeniusPdfDesignerPropertySchema>[
    GeniusPdfDesignerPropertySchema(
      key: 'id',
      label: 'Element ID',
      labelAr: 'معرف العنصر',
      type: GeniusPdfDesignerPropertyType.text,
      required: true,
    ),
    GeniusPdfDesignerPropertySchema(
      key: 'visibleWhen',
      label: 'Visible When',
      labelAr: 'شرط الظهور',
      type: GeniusPdfDesignerPropertyType.expression,
    ),
    GeniusPdfDesignerPropertySchema(
      key: 'repeatPath',
      label: 'Repeat Path',
      labelAr: 'مسار التكرار',
      type: GeniusPdfDesignerPropertyType.binding,
    ),
    GeniusPdfDesignerPropertySchema(
      key: 'direction',
      label: 'Direction',
      labelAr: 'الاتجاه',
      type: GeniusPdfDesignerPropertyType.direction,
    ),
    GeniusPdfDesignerPropertySchema(
      key: 'style',
      label: 'Style',
      labelAr: 'النمط',
      type: GeniusPdfDesignerPropertyType.select,
    ),
  ];

  static const styleProperties = <GeniusPdfDesignerStyleProperty>[
    GeniusPdfDesignerStyleProperty(
      key: 'fontSize',
      label: 'Font Size',
      labelAr: 'حجم الخط',
      type: GeniusPdfDesignerPropertyType.number,
      defaultValue: 10,
    ),
    GeniusPdfDesignerStyleProperty(
      key: 'bold',
      label: 'Bold',
      labelAr: 'عريض',
      type: GeniusPdfDesignerPropertyType.boolean,
      defaultValue: false,
    ),
    GeniusPdfDesignerStyleProperty(
      key: 'foreground',
      label: 'Foreground',
      labelAr: 'لون النص',
      type: GeniusPdfDesignerPropertyType.color,
    ),
    GeniusPdfDesignerStyleProperty(
      key: 'background',
      label: 'Background',
      labelAr: 'الخلفية',
      type: GeniusPdfDesignerPropertyType.color,
    ),
    GeniusPdfDesignerStyleProperty(
      key: 'padding',
      label: 'Padding',
      labelAr: 'الحشو',
      type: GeniusPdfDesignerPropertyType.spacing,
    ),
    GeniusPdfDesignerStyleProperty(
      key: 'spacing',
      label: 'Spacing',
      labelAr: 'المسافة',
      type: GeniusPdfDesignerPropertyType.spacing,
      defaultValue: 4,
    ),
  ];
}
