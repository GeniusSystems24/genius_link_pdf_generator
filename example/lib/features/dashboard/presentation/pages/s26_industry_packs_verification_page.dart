
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/create_save_open_pdf_button.dart';
enum _S26Scenario {
  retail,
  restaurant,
  construction,
  healthcareEducation,
  mobilityDistributionHospitality,
}

class S26IndustryPacksVerificationPage extends StatefulWidget {
  const S26IndustryPacksVerificationPage({super.key});

  @override
  State<S26IndustryPacksVerificationPage> createState() =>
      _S26IndustryPacksVerificationPageState();
}

class _S26IndustryPacksVerificationPageState
    extends State<S26IndustryPacksVerificationPage> {
  _S26Scenario _scenario = _S26Scenario.retail;
  bool _rtl = false;
  int _rows = 10;
  late Future<Uint8List> _pdf;

  @override
  void initState() {
    super.initState();
    _pdf = _generate();
  }

  GeniusPdfConfig get _config => geniusPdfConfig.copyWith(
        textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
      );

  String _label(_S26Scenario value) => switch (value) {
        _S26Scenario.retail => 'Retail',
        _S26Scenario.restaurant => 'Restaurant',
        _S26Scenario.construction => 'Construction / Real Estate',
        _S26Scenario.healthcareEducation =>
          'Healthcare / Education Shells',
        _S26Scenario.mobilityDistributionHospitality =>
          'Automotive / Distribution / Hospitality',
      };

  String _packId() => switch (_scenario) {
        _S26Scenario.retail => 'industry.retail',
        _S26Scenario.restaurant => 'industry.restaurant',
        _S26Scenario.construction =>
          'industry.construction_real_estate',
        _S26Scenario.healthcareEducation =>
          'industry.healthcare_education_shells',
        _S26Scenario.mobilityDistributionHospitality =>
          'industry.mobility_distribution_hospitality',
      };

  Map<String, Object?> _sampleData() => {
        'item': {
          'sku': 'SKU-LATIN-001',
          'name': _rtl ? 'صنف تجريبي' : 'Demo Item',
          'price': 99.95,
          'barcode': '123456789012',
        },
        'promotion': {
          'enabled': true,
          'code': 'PROMO-001',
          'description': _rtl ? 'عرض خاص' : 'Special offer',
        },
        'order': {
          'number': 'ORD-LATIN-001',
          'table': 'T-12',
          'server': _rtl ? 'النادل 01' : 'Server 01',
          'items': List.generate(
            _rows,
            (index) => {
              'quantity': index % 3 + 1,
              'name': _rtl ? 'طبق ${index + 1}' : 'Dish ${index + 1}',
              'notes': _rtl ? 'بدون سكر' : 'No sugar',
            },
          ),
        },
        'kitchen': {
          'section': _rtl ? 'المطبخ الساخن' : 'Hot Kitchen',
          'items': List.generate(
            _rows,
            (index) => {
              'name': _rtl ? 'طبق ${index + 1}' : 'Dish ${index + 1}',
              'notes': _rtl ? 'ملاحظة ${index + 1}' : 'Note ${index + 1}',
            },
          ),
        },
        'customer': {'name': _rtl ? 'عميل عربي' : 'Customer'},
        'delivery': {
          'address': _rtl ? 'الرياض' : 'Riyadh',
          'driver': _rtl ? 'السائق 01' : 'Driver 01',
        },
        'project': {'name': _rtl ? 'مشروع تجريبي' : 'Demo Project'},
        'certificate': {'number': 'CERT-LATIN-001', 'period': '2026-09'},
        'progress': {'previous': 1000, 'current': 250, 'cumulative': 1250},
        'boq': {
          'lines': List.generate(
            _rows,
            (index) => {
              'code': 'BOQ-${index + 1}',
              'description':
                  _rtl ? 'بند قياس ${index + 1}' : 'BOQ item ${index + 1}',
              'quantity': index + 1,
              'rate': 10,
              'amount': (index + 1) * 10,
            },
          ),
        },
        'property': {'name': _rtl ? 'العقار أ' : 'Property A'},
        'unit': {'code': 'UNIT-101', 'status': 'available'},
        'billing': {
          'reference': 'BILL-LATIN-001',
          'certifiedAmount': 1200,
          'retention': 120,
        },
        'reportHeader': {'title': _rtl ? 'تقرير عام' : 'Generic Report'},
        'reportRows': List.generate(
          _rows,
          (index) => {
            'label': _rtl ? 'البيان ${index + 1}' : 'Label ${index + 1}',
            'value': 'VALUE-${index + 1}',
          },
        ),
        'reportFooter': {'text': _rtl ? 'نهاية التقرير' : 'End of report'},
        'vehicle': {
          'registration': 'ABC-1234',
          'vin': 'VIN-LATIN-001',
          'odometer': 45000,
        },
        'service': {'number': 'SRV-LATIN-001'},
        'route': {
          'code': 'ROUTE-01',
          'stops': List.generate(
            _rows,
            (index) => {
              'sequence': index + 1,
              'customer':
                  _rtl ? 'عميل ${index + 1}' : 'Customer ${index + 1}',
              'address': _rtl ? 'عنوان ${index + 1}' : 'Address ${index + 1}',
            },
          ),
        },
        'folio': {
          'number': 'FOLIO-LATIN-001',
          'charges': List.generate(
            _rows,
            (index) => {
              'date': '2026-09-${(index % 28 + 1).toString().padLeft(2, '0')}',
              'description':
                  _rtl ? 'رسوم ${index + 1}' : 'Charge ${index + 1}',
              'amount': (index + 1) * 20,
            },
          ),
        },
        'guest': {'name': _rtl ? 'ضيف تجريبي' : 'Demo Guest'},
        'stay': {'room': 'ROOM-301'},
      };

  Future<Uint8List> _generate() async {
    final packs = GeniusPdfBuiltInIndustryPacks.registry();
    final pack = packs.find(_packId());
    if (pack == null) {
      throw StateError('Pack ${_packId()} was not registered.');
    }

    final templates = pack.templates();
    if (templates.isEmpty) {
      throw StateError('Pack ${_packId()} has no templates.');
    }

    // Select the first concrete template for visual manual verification.
    final schema = templates.first;
    final registry = GeniusPdfTemplateRegistry();
    for (final template in templates) {
      registry.register(template);
    }

    // Industry templates can reference core subtemplates that are provided by
    // host packs. For the manual page, avoid resolving that host dependency by
    // selecting the first template without SubTemplate when available.
    final safeSchema = templates.firstWhere(
      (template) => !template.elements.any(
        (element) =>
            element.type == GeniusPdfTemplateElementType.subTemplate,
      ),
      orElse: () => schema,
    );

    final resolved = GeniusPdfTemplateEngine(
      registry: registry,
      maxRepeatItems: 10000,
    ).resolve(
      safeSchema,
      context: _sampleData(),
      scope: const GeniusPdfTemplateScope(),
    );

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
      'Expected Result: ${_label(_scenario)} resolves through the S26 pack '
      'contract and S22 template engine. Core POS/service/logistics/transaction '
      'behavior is referenced rather than duplicated. Healthcare/Education '
      'remains a generic shell with plugin-owned regulated models. Preview is '
      '${_rtl ? 'RTL' : 'LTR'} with $_rows sample rows.';

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
                    'Sprint S26 — Industry / Plugin Packs',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      SizedBox(
                        width: 330,
                        child: DropdownButtonFormField<_S26Scenario>(
                          initialValue: _scenario,
                          decoration: const InputDecoration(
                            labelText: 'Industry Pack',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            for (final value in _S26Scenario.values)
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
                      SegmentedButton<int>(
                        segments: const [
                          ButtonSegment(value: 1, label: Text('1')),
                          ButtonSegment(value: 10, label: Text('10')),
                          ButtonSegment(value: 100, label: Text('100')),
                        ],
                        selected: {_rows},
                        onSelectionChanged: (value) {
                          _rows = value.first;
                          _refresh();
                        },
                      ),
                      FilterChip(
                        label: const Text('RTL'),
                        selected: _rtl,
                        onSelected: (value) {
                          _rtl = value;
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
                        fileName: 's26_industry_packs.pdf',
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
