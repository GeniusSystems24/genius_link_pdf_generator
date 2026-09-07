import 'dart:typed_data';

import 'package:genius_pdf_example/features/templates/models/documents/export_template_background_generators.dart';
import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    show MultiTransactionTransferPdf;

import 'package:genius_pdf_example/features/templates/presentation/widgets/template_example_detail_screen.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/export_template_customization_controls.dart';

/// Demonstrates [MultiTransactionTransferPdf] with interactive customization.
class MultiTransactionTransferPdfExampleScreen extends StatefulWidget {
  const MultiTransactionTransferPdfExampleScreen({super.key});

  static const String dartUsageCode = r'''final customization = TransactionTransferTemplateCustomization(
  headerLayout: GeniusPdfReportHeaderLayout.compact,
  infoBoxStyle: const GeniusPdfInfoBoxStyle.card(),
  gridStyle: GeniusPdfGridStyle.modern(),
  reportDetailsColumns: 2,
  accountLabelBuilder: (id, account, isRtl) =>
      '${account?.displayName(isRtl: isRtl) ?? 'Account'} [$id]',
  descriptionBuilder: (row, isRtl) {
    final type = row.description.isCommission ? 'Commission' : 'Transfer';
    return '[$type] ${row.description.note ?? ''}'.trim();
  },
);

final report = MultiTransactionTransferPdf(
  config: config,
  meta: meta,
  rows: rows,
  services: services,
  accountDirectory: accounts,
  customization: customization,
  configuration: const TransactionTransferReportConfiguration(
    selectedCurrency: 'YER',
    includeCommission: true,
    showTotals: true,
  ),
);

// The example app submits generation to its global GeniusPdfGenerationManager.
final result = await generateExamplePdf(
  builder: report,
  fileName: 'multi_transaction_transfer_pdf_demo',
  metadata: const <String, dynamic>{
    'feature': 'templates',
    'template': 'MultiTransactionTransferPdf',
    'workflow': 'usage-example',
  },
);
final pdfBytes = result.bytes;''';

  @override
  State<MultiTransactionTransferPdfExampleScreen> createState() =>
      _MultiTransactionTransferPdfExampleScreenState();
}

class _MultiTransactionTransferPdfExampleScreenState
    extends State<MultiTransactionTransferPdfExampleScreen> {
  ExportTemplateCustomizationSettings _customization =
      const ExportTemplateCustomizationSettings();
  bool _includeCommission = true;
  bool _showTotals = true;
  bool _showQRCode = true;
  bool _showNotes = true;

  String get _revision => <Object>[
        _customization.revisionKey,
        _includeCommission,
        _showTotals,
        _showQRCode,
        _showNotes,
      ].join('|');

  Future<Uint8List> _generateInBackground({required bool isRtl}) {
    return generateMultiTransactionTransferPdfInBackground(
      isRtl: isRtl,
      customization: _customization,
      includeCommission: _includeCommission,
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
          showTransactionOptions: true,
          onChanged: (value) => setState(() => _customization = value),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: <Widget>[
            _chip('Commission rows', _includeCommission, disabled,
                (value) => setState(() => _includeCommission = value)),
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
  ) => FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: disabled ? null : onChanged,
      );

  @override
  Widget build(BuildContext context) {
    return TemplateExampleDetailScreen(
      category: 'Transaction Transfer Export Templates',
      title: 'MultiTransactionTransferPdf',
      titleAr: 'PDF لحركات التحويلات',
      description:
          'Customize the reusable report presentation and transaction-specific '
          'directory labels/description hooks, then toggle commissions, totals, '
          'QR, and notes before generating the report.',
      icon: Icons.compare_arrows,
      backgroundGenerator: _generateInBackground,
      backgroundFileName: 'multi_transaction_transfer_pdf_demo.pdf',
      jobMetadata: const <String, dynamic>{
        'feature': 'templates',
        'template': 'MultiTransactionTransferPdf',
      },
      showGenerationToast: true,
      usageCode: MultiTransactionTransferPdfExampleScreen.dartUsageCode,
      configurationRevision: _revision,
      settingsBuilder: _buildSettings,
    );
  }
}
