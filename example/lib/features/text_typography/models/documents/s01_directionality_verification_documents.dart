import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

/// Focused scenarios extracted from the former S01DirectionalityVerificationPage.
enum S01DirectionalityScenario {
  precedence,
  logicalGeometry,
  valueMatrix,
  mixedText,
  nestedOverrides,
  longMultiPage,
  autoInheritance,
  legacyTemplateJson,
  mediaPolicy,
}

class S01DirectionalityDocument extends GeniusPdfDocumentBuilder {
  S01DirectionalityDocument({
    required GeniusPdfConfig config,
    required GeniusPdfDirectionality directionality,
    required this.scenario,
    required this.valueKind,
  }) : super(config, directionality: directionality);

  final S01DirectionalityScenario scenario;
  final GeniusPdfValueKind valueKind;

  GeniusPdfResolvedDirection get _resolved => directionality.resolve().direction;

  PdfTextDirection _pdfDirection(GeniusPdfResolvedDirection direction) =>
      direction.isRtl
          ? PdfTextDirection.rightToLeft
          : PdfTextDirection.leftToRight;

  @override
  void build() {
    switch (scenario) {
      case S01DirectionalityScenario.precedence:
        _precedence();
      case S01DirectionalityScenario.logicalGeometry:
        _geometry();
      case S01DirectionalityScenario.valueMatrix:
        _values();
      case S01DirectionalityScenario.mixedText:
        _mixed();
      case S01DirectionalityScenario.nestedOverrides:
        _nested();
      case S01DirectionalityScenario.longMultiPage:
        _longPages();
      case S01DirectionalityScenario.autoInheritance:
        _auto();
      case S01DirectionalityScenario.legacyTemplateJson:
        _legacyJson();
      case S01DirectionalityScenario.mediaPolicy:
        _media();
    }
  }

  void _title(String value) {
    addLine(value, font: config.boldFont, topMargin: 0);
    addSpace(12);
  }

  void _precedence() {
    newPage();
    final result = directionality.resolve();
    _title('S01 — Resolver precedence');
    addLine('Resolved: ${result.direction.name} from ${result.source.name}');
    for (final entry in <(String, GeniusPdfDirection)>[
      ('element', directionality.elementDirection),
      ('component', directionality.componentDirection),
      ('template', directionality.templateDirection),
      ('document', directionality.documentDirection),
      ('locale', directionality.localeDirection),
    ]) {
      addLine('${entry.$1}: ${entry.$2.name}', topMargin: 5);
    }
    addSpace(12);
    _logicalBoxes(_resolved);
  }

  void _geometry() {
    newPage();
    _title('S01 — Logical geometry');
    _logicalBoxes(_resolved);
    addSpace(70);
    final insets = const GeniusPdfDirectionalInsets(
      start: 12,
      top: 4,
      end: 28,
      bottom: 6,
    ).resolve(_resolved);
    addLine('Insets => left=${insets.left}, right=${insets.right}, '
        'top=${insets.top}, bottom=${insets.bottom}');
  }

  void _logicalBoxes(GeniusPdfResolvedDirection direction) {
    const width = 130.0;
    final y = currentY;
    for (final item in <(GeniusPdfLogicalAlignment, String)>[
      (GeniusPdfLogicalAlignment.start, 'START'),
      (GeniusPdfLogicalAlignment.center, 'CENTER'),
      (GeniusPdfLogicalAlignment.end, 'END'),
    ]) {
      final x = GeniusPdfLogicalGeometry.resolveX(
        containerX: 0,
        containerWidth: pageWidth,
        itemWidth: width,
        alignment: item.$1,
        direction: direction,
      );
      currentPage.graphics.drawRectangle(
        pen: PdfPen(PdfColor(90, 90, 90)),
        bounds: Rect.fromLTWH(x, y, width, 48),
      );
      currentPage.graphics.drawString(
        item.$2,
        config.boldFont,
        bounds: Rect.fromLTWH(x + 6, y + 12, width - 12, 22),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          textDirection: _pdfDirection(direction),
        ),
      );
    }
  }

  void _values() {
    newPage();
    _title('S01 — ERP value matrix');
    const values = <(String, String, GeniusPdfValueKind)>[
      ('Money', '15,697.50 SAR', GeniusPdfValueKind.money),
      ('Percentage', '15.00%', GeniusPdfValueKind.percentage),
      ('Quantity', '1,250.500 KG', GeniusPdfValueKind.quantity),
      ('Date', '2026-09-03', GeniusPdfValueKind.date),
      ('Time', '09:45:20', GeniusPdfValueKind.time),
      ('Document', 'INV-2026-000123', GeniusPdfValueKind.documentNumber),
      ('SKU', 'SKU-AR-ENG-001', GeniusPdfValueKind.sku),
      ('Serial', 'SN-AZ09-998877', GeniusPdfValueKind.serial),
      ('Batch', 'BATCH-2026-09-A', GeniusPdfValueKind.batch),
      ('IBAN', 'SA0380000000608010167519', GeniusPdfValueKind.iban),
      ('SWIFT', 'RJHISARIXXX', GeniusPdfValueKind.swift),
      ('Tax ID', '310123456700003', GeniusPdfValueKind.taxId),
      ('Phone', '+966 55 123 4567', GeniusPdfValueKind.phone),
      ('Email', 'accounts@example.test', GeniusPdfValueKind.email),
      ('URL', 'https://erp.example.test/INV-2026-000123',
          GeniusPdfValueKind.url),
    ];
    for (final item in values) {
      final run = GeniusPdfDirectedTextRun(item.$2, kind: item.$3);
      final runDirection = run.resolveDirection(directionality);
      addLine('${item.$1}: ${run.text}', topMargin: 6);
      addLine('runDirection=${runDirection.name}', topMargin: 2);
    }
  }

  void _mixed() {
    newPage();
    _title('S01 — Mixed Arabic / Latin');
    const source =
        'رقم المستند INV-2026-000123 — الإجمالي 15,697.50 SAR — '
        'accounts@example.test';
    final run = GeniusPdfDirectedTextRun(source, kind: valueKind);
    final runDirection = run.resolveDirection(directionality);
    currentPage.graphics.drawString(
      run.text,
      config.baseFont,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 90),
      format: PdfStringFormat(
        alignment: runDirection.isRtl
            ? PdfTextAlignment.right
            : PdfTextAlignment.left,
        textDirection: _pdfDirection(runDirection),
      ),
    );
    addSpace(95);
    addLine('Resolved run: ${runDirection.name}');
  }

  void _nested() {
    newPage();
    _title('S01 — Nested overrides');
    final parent = directionality;
    final component = parent.forComponent(GeniusPdfDirection.ltr);
    final inherited = component.forElement(GeniusPdfDirection.auto);
    final rtlChild = component.forElement(GeniusPdfDirection.rtl);
    for (final item in <(String, GeniusPdfDirectionality)>[
      ('Parent', parent),
      ('Component LTR', component),
      ('Element AUTO', inherited),
      ('Element RTL', rtlChild),
    ]) {
      final result = item.$2.resolve();
      addLine('${item.$1}: ${result.direction.name} / ${result.source.name}',
          topMargin: 8);
    }
  }

  void _longPages() {
    const ar =
        'هذا نص عربي طويل لاختبار الاتجاه عبر صفحات متعددة مع '
        'INV-2026-000123 و 15,697.50 SAR و accounts@example.test. ';
    const en =
        'Long directionality content across multiple pages with '
        'INV-2026-000123, 15,697.50 SAR and accounts@example.test. ';
    for (var page = 0; page < 3; page++) {
      newPage();
      _title('S01 — Long / multi-page ${page + 1}/3');
      for (var row = 0; row < 8; row++) {
        addLine(_resolved.isRtl ? '$ar$ar' : '$en$en', topMargin: 7);
      }
    }
  }

  void _auto() {
    newPage();
    _title('S01 — AUTO inheritance');
    const context = GeniusPdfDirectionality(
      localeDirection: GeniusPdfDirection.rtl,
      documentDirection: GeniusPdfDirection.auto,
      templateDirection: GeniusPdfDirection.auto,
      componentDirection: GeniusPdfDirection.auto,
      elementDirection: GeniusPdfDirection.auto,
    );
    final result = context.resolve();
    addLine('Resolved: ${result.direction.name} from ${result.source.name}');
    addSpace(12);
    _logicalBoxes(result.direction);
  }

  void _legacyJson() {
    newPage();
    _title('S01 — Legacy Template JSON');
    final definition = TemplateDefinition.fromJson(<String, dynamic>{
      'id': 'legacy',
      'name': 'Legacy',
      'content': <dynamic>[],
      'pageSettings': <String, dynamic>{
        'pageSize': 'a4',
        'orientation': 'portrait',
      },
    });
    addLine('Template direction: ${definition.direction.name}');
    addLine('Page direction: ${definition.pageSettings!.direction.name}',
        topMargin: 8);
  }

  void _media() {
    newPage();
    _title('S01 — Media mirroring policy');
    final defaultValue = GeniusPdfLogicalGeometry.shouldMirrorMedia();
    final preserve = GeniusPdfLogicalGeometry.shouldMirrorMedia(
      policy: GeniusPdfMediaMirroringPolicy.preserve,
    );
    final mirror = GeniusPdfLogicalGeometry.shouldMirrorMedia(
      policy: GeniusPdfMediaMirroringPolicy.mirror,
    );
    addLine('Document: ${_resolved.name}');
    addLine('Default mirrored: $defaultValue', topMargin: 8);
    addLine('Preserve mirrored: $preserve', topMargin: 8);
    addLine('Explicit mirror: $mirror', topMargin: 8);
  }
}

Future<Uint8List> buildS01PrecedenceVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    localeDirection: direction,
    documentDirection: direction,
    templateDirection: GeniusPdfDirection.auto,
    componentDirection: GeniusPdfDirection.auto,
    elementDirection: GeniusPdfDirection.auto,
  );
  final builder = S01DirectionalityDocument(
    config: config,
    directionality: directionality,
    scenario: S01DirectionalityScenario.precedence,
    valueKind: GeniusPdfValueKind.money,
  );
  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}

Future<Uint8List> buildS01LogicalGeometryVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    localeDirection: direction,
    documentDirection: direction,
    templateDirection: GeniusPdfDirection.auto,
    componentDirection: GeniusPdfDirection.auto,
    elementDirection: GeniusPdfDirection.auto,
  );
  final builder = S01DirectionalityDocument(
    config: config,
    directionality: directionality,
    scenario: S01DirectionalityScenario.logicalGeometry,
    valueKind: GeniusPdfValueKind.money,
  );
  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}

Future<Uint8List> buildS01ValueMatrixVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    localeDirection: direction,
    documentDirection: direction,
    templateDirection: GeniusPdfDirection.auto,
    componentDirection: GeniusPdfDirection.auto,
    elementDirection: GeniusPdfDirection.auto,
  );
  final builder = S01DirectionalityDocument(
    config: config,
    directionality: directionality,
    scenario: S01DirectionalityScenario.valueMatrix,
    valueKind: GeniusPdfValueKind.money,
  );
  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}

Future<Uint8List> buildS01MixedTextVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    localeDirection: direction,
    documentDirection: direction,
    templateDirection: GeniusPdfDirection.auto,
    componentDirection: GeniusPdfDirection.auto,
    elementDirection: GeniusPdfDirection.auto,
  );
  final builder = S01DirectionalityDocument(
    config: config,
    directionality: directionality,
    scenario: S01DirectionalityScenario.mixedText,
    valueKind: GeniusPdfValueKind.money,
  );
  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}

Future<Uint8List> buildS01NestedOverridesVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    localeDirection: direction,
    documentDirection: direction,
    templateDirection: GeniusPdfDirection.auto,
    componentDirection: GeniusPdfDirection.auto,
    elementDirection: GeniusPdfDirection.auto,
  );
  final builder = S01DirectionalityDocument(
    config: config,
    directionality: directionality,
    scenario: S01DirectionalityScenario.nestedOverrides,
    valueKind: GeniusPdfValueKind.money,
  );
  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}

Future<Uint8List> buildS01LongMultiPageVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    localeDirection: direction,
    documentDirection: direction,
    templateDirection: GeniusPdfDirection.auto,
    componentDirection: GeniusPdfDirection.auto,
    elementDirection: GeniusPdfDirection.auto,
  );
  final builder = S01DirectionalityDocument(
    config: config,
    directionality: directionality,
    scenario: S01DirectionalityScenario.longMultiPage,
    valueKind: GeniusPdfValueKind.money,
  );
  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}

Future<Uint8List> buildS01AutoInheritanceVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    localeDirection: direction,
    documentDirection: direction,
    templateDirection: GeniusPdfDirection.auto,
    componentDirection: GeniusPdfDirection.auto,
    elementDirection: GeniusPdfDirection.auto,
  );
  final builder = S01DirectionalityDocument(
    config: config,
    directionality: directionality,
    scenario: S01DirectionalityScenario.autoInheritance,
    valueKind: GeniusPdfValueKind.money,
  );
  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}

Future<Uint8List> buildS01LegacyTemplateJsonVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    localeDirection: direction,
    documentDirection: direction,
    templateDirection: GeniusPdfDirection.auto,
    componentDirection: GeniusPdfDirection.auto,
    elementDirection: GeniusPdfDirection.auto,
  );
  final builder = S01DirectionalityDocument(
    config: config,
    directionality: directionality,
    scenario: S01DirectionalityScenario.legacyTemplateJson,
    valueKind: GeniusPdfValueKind.money,
  );
  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}

Future<Uint8List> buildS01MediaPolicyVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    localeDirection: direction,
    documentDirection: direction,
    templateDirection: GeniusPdfDirection.auto,
    componentDirection: GeniusPdfDirection.auto,
    elementDirection: GeniusPdfDirection.auto,
  );
  final builder = S01DirectionalityDocument(
    config: config,
    directionality: directionality,
    scenario: S01DirectionalityScenario.mediaPolicy,
    valueKind: GeniusPdfValueKind.money,
  );
  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}
