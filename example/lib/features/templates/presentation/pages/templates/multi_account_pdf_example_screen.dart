import 'dart:typed_data';

import 'package:genius_pdf_example/features/templates/models/documents/export_template_background_generators.dart';
import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    show AccountExportGrouping, MultiAccountPdf;

import 'package:genius_pdf_example/features/templates/presentation/widgets/template_example_detail_screen.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/export_template_customization_controls.dart';

/// Demonstrates [MultiAccountPdf] with interactive reusable customization.
class MultiAccountPdfExampleScreen extends StatefulWidget {
  const MultiAccountPdfExampleScreen({super.key});

  static const String dartUsageCode = r'''final customization = AccountExportCustomization(
  headerLayout: GeniusPdfReportHeaderLayout.compact,
  infoBoxStyle: const GeniusPdfInfoBoxStyle.card(),
  gridStyle: GeniusPdfGridStyle.striped(),
  reportDetailsColumns: 2,
  showFooter: true,
  dateFormatter: (date) => '${date.day}/${date.month}/${date.year}',
);

final report = MultiAccountPdf(
  config: config,
  meta: meta,
  company: company,
  accounts: accounts,
  customization: customization,
  showQRCode: true,
  showNotes: true,
  configuration: AccountExportConfiguration(
    fields: AccountExportFieldVisibility.multiPdf,
    selectedCurrency: 'YER',
    showBalances: true,
    showActivity: true,
    grouping: AccountExportGrouping.accountGroup,
    showTotals: true,
  ),
);

// The example app submits generation to its global GeniusPdfGenerationManager.
final result = await generateExamplePdf(
  builder: report,
  fileName: 'multi_account_pdf_demo',
  metadata: const <String, dynamic>{
    'feature': 'templates',
    'template': 'MultiAccountPdf',
    'workflow': 'usage-example',
  },
);
final pdfBytes = result.bytes;''';

  @override
  State<MultiAccountPdfExampleScreen> createState() =>
      _MultiAccountPdfExampleScreenState();
}

class _MultiAccountPdfExampleScreenState
    extends State<MultiAccountPdfExampleScreen> {
  ExportTemplateCustomizationSettings _customization =
      const ExportTemplateCustomizationSettings();
  AccountExportGrouping _grouping = AccountExportGrouping.accountGroup;
  bool _showBalances = true;
  bool _showActivity = true;
  bool _showTotals = true;
  bool _showQRCode = true;
  bool _showNotes = true;

  String get _revision => <Object>[
        _customization.revisionKey,
        _grouping,
        _showBalances,
        _showActivity,
        _showTotals,
        _showQRCode,
        _showNotes,
      ].join('|');

  Future<Uint8List> _generateInBackground({required bool isRtl}) {
    return generateMultiAccountPdfInBackground(
      isRtl: isRtl,
      customization: _customization,
      grouping: _grouping,
      showBalances: _showBalances,
      showActivity: _showActivity,
      showTotals: _showTotals,
      showQRCode: _showQRCode,
      showNotes: _showNotes,
    );
  }

  Widget _buildSettings(BuildContext context, bool disabled) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ExportTemplateCustomizationControls(
          value: _customization,
          disabled: disabled,
          onChanged: (value) => setState(() => _customization = value),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 190,
              child: DropdownButtonFormField<AccountExportGrouping>(
                initialValue: _grouping,
                decoration: const InputDecoration(
                  labelText: 'Grouping',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                items: const <DropdownMenuItem<AccountExportGrouping>>[
                  DropdownMenuItem(
                    value: AccountExportGrouping.none,
                    child: Text('None'),
                  ),
                  DropdownMenuItem(
                    value: AccountExportGrouping.accountGroup,
                    child: Text('Account group'),
                  ),
                  DropdownMenuItem(
                    value: AccountExportGrouping.parentAccount,
                    child: Text('Parent account'),
                  ),
                ],
                onChanged: disabled
                    ? null
                    : (value) {
                        if (value != null) setState(() => _grouping = value);
                      },
              ),
            ),
            _chip('Balances', _showBalances, disabled,
                (value) => setState(() => _showBalances = value)),
            _chip('Activity', _showActivity, disabled,
                (value) => setState(() => _showActivity = value)),
            _chip('Totals', _showTotals, disabled,
                (value) => setState(() => _showTotals = value)),
            _chip('QR', _showQRCode, disabled,
                (value) => setState(() => _showQRCode = value)),
            _chip('Notes', _showNotes, disabled,
                (value) => setState(() => _showNotes = value)),
          ],
        ),
      ],
    );
  }

  Widget _chip(
    String label,
    bool selected,
    bool disabled,
    ValueChanged<bool> onChanged,
  ) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: disabled ? null : onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TemplateExampleDetailScreen(
      category: 'Account Export Templates',
      title: 'MultiAccountPdf',
      titleAr: 'PDF لعدة حسابات',
      description:
          'Customize the reusable header, info box, grid, footer, formatting, '
          'grouping, totals, balances, activity, QR, and notes before generating '
          'the 200-account landscape report.',
      icon: Icons.account_tree_outlined,
      backgroundGenerator: _generateInBackground,
      backgroundFileName: 'multi_account_pdf_demo.pdf',
      jobMetadata: const <String, dynamic>{
        'feature': 'templates',
        'template': 'MultiAccountPdf',
      },
      showGenerationToast: true,
      usageCode: MultiAccountPdfExampleScreen.dartUsageCode,
      configurationRevision: _revision,
      settingsBuilder: _buildSettings,
    );
  }
}
