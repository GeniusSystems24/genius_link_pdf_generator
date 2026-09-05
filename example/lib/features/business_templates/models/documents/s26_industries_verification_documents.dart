// Generated from the former aggregate verification page.
// ignore_for_file: unused_element

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

/// Scenarios extracted from the former S26IndustryPacksVerificationPage.
enum S26IndustryPacksScenario {
  retail,
  restaurant,
  construction,
  healthcareEducation,
  mobilityDistributionHospitality,
}

/// Executes one focused S26 verification scenario.
class S26IndustryPacksRunner {
  S26IndustryPacksRunner({
    required GeniusPdfConfig baseConfig,
    required S26IndustryPacksScenario scenario,
  })  : _baseConfig = baseConfig,
        _scenario = scenario;

  final GeniusPdfConfig _baseConfig;
  final S26IndustryPacksScenario _scenario;
bool _rtl = false;
  final int _rows = 10;
GeniusPdfConfig get _config => _baseConfig.copyWith(
        textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
      );

  String _label(S26IndustryPacksScenario value) => switch (value) {
        S26IndustryPacksScenario.retail => 'Retail',
        S26IndustryPacksScenario.restaurant => 'Restaurant',
        S26IndustryPacksScenario.construction => 'Construction / Real Estate',
        S26IndustryPacksScenario.healthcareEducation =>
          'Healthcare / Education Shells',
        S26IndustryPacksScenario.mobilityDistributionHospitality =>
          'Automotive / Distribution / Hospitality',
      };

  String _packId() => switch (_scenario) {
        S26IndustryPacksScenario.retail => 'industry.retail',
        S26IndustryPacksScenario.restaurant => 'industry.restaurant',
        S26IndustryPacksScenario.construction =>
          'industry.construction_real_estate',
        S26IndustryPacksScenario.healthcareEducation =>
          'industry.healthcare_education_shells',
        S26IndustryPacksScenario.mobilityDistributionHospitality =>
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

  Future<Uint8List> generate() async {
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


  String get _expected =>
      'Expected Result: ${_label(_scenario)} resolves through the S26 pack '
      'contract and S22 template engine. Core POS/service/logistics/transaction '
      'behavior is referenced rather than duplicated. Healthcare/Education '
      'remains a generic shell with plugin-owned regulated models. Preview is '
      '${_rtl ? 'RTL' : 'LTR'} with $_rows sample rows.';
}


Future<Uint8List> buildS26RetailVerificationPdf(GeniusPdfConfig config) {
  final runner = S26IndustryPacksRunner(
    baseConfig: config,
    scenario: S26IndustryPacksScenario.retail,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS26RestaurantVerificationPdf(GeniusPdfConfig config) {
  final runner = S26IndustryPacksRunner(
    baseConfig: config,
    scenario: S26IndustryPacksScenario.restaurant,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS26ConstructionVerificationPdf(GeniusPdfConfig config) {
  final runner = S26IndustryPacksRunner(
    baseConfig: config,
    scenario: S26IndustryPacksScenario.construction,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS26HealthcareEducationVerificationPdf(GeniusPdfConfig config) {
  final runner = S26IndustryPacksRunner(
    baseConfig: config,
    scenario: S26IndustryPacksScenario.healthcareEducation,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS26MobilityDistributionHospitalityVerificationPdf(GeniusPdfConfig config) {
  final runner = S26IndustryPacksRunner(
    baseConfig: config,
    scenario: S26IndustryPacksScenario.mobilityDistributionHospitality,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}
