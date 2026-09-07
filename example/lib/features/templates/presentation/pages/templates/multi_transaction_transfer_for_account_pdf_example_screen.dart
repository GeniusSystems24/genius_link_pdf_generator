import 'dart:typed_data';

import 'package:genius_pdf_example/features/templates/models/documents/export_template_background_generators.dart';
import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/templates/presentation/widgets/template_example_detail_screen.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/export_template_customization_controls.dart';

/// Demonstrates account-scoped transfer export customization for account 2305.
class MultiTransactionTransferForAccountPdfExampleScreen
    extends StatefulWidget {
  const MultiTransactionTransferForAccountPdfExampleScreen({super.key});

  static const String dartUsageCode = r'''final customization = TransactionTransferTemplateCustomization(
  gridStyle: GeniusPdfGridStyle.striped(),
  infoBoxStyle: GeniusPdfInfoBoxStyle.minimal(),
  reportDetailsColumns: 3,
  showFooter: true,
  dateFormatter: (date) => '${date.day}/${date.month}/${date.year}',
);

final report = MultiTransactionTransferForAccountPdf(
  config: config,
  meta: meta,
  rows: rows,
  accountId: 2305,
  account: account,
  services: services,
  accountDirectory: accounts,
  openingBalances: const {'YER': 125000.0},
  customization: customization,
  configuration: const TransactionTransferReportConfiguration(
    selectedCurrency: 'YER',
    includeCommission: true,
  ),
);

// The example app submits generation to its global GeniusPdfGenerationManager.
final result = await generateExamplePdf(
  builder: report,
  fileName: 'multi_transaction_transfer_for_account_pdf_demo',
  metadata: const <String, dynamic>{
    'feature': 'templates',
    'template': 'MultiTransactionTransferForAccountPdf',
    'workflow': 'usage-example',
  },
);
final pdfBytes = result.bytes;''';

  @override
  State<MultiTransactionTransferForAccountPdfExampleScreen> createState() =>
      _MultiTransactionTransferForAccountPdfExampleScreenState();
}

class _MultiTransactionTransferForAccountPdfExampleScreenState
    extends State<MultiTransactionTransferForAccountPdfExampleScreen> {
  ExportTemplateCustomizationSettings _customization =
      const ExportTemplateCustomizationSettings();
  bool _includeCommission = true;
  bool _showTotals = true;
  bool _showQRCode = true;
  bool _showNotes = true;
  double _openingBalance = 125000.0;

  String get _revision => <Object>[
        _customization.revisionKey,
        _includeCommission,
        _showTotals,
        _showQRCode,
        _showNotes,
        _openingBalance,
      ].join('|');

  Future<Uint8List> _generateInBackground({required bool isRtl}) {
    return generateMultiTransactionTransferForAccountPdfInBackground(
      isRtl: isRtl,
      customization: _customization,
      includeCommission: _includeCommission,
      showTotals: _showTotals,
      showQRCode: _showQRCode,
      showNotes: _showNotes,
      openingBalance: _openingBalance,
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
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 190,
              child: DropdownButtonFormField<double>(
                initialValue: _openingBalance,
                decoration: const InputDecoration(
                  labelText: 'Opening balance',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                items: const <DropdownMenuItem<double>>[
                  DropdownMenuItem(value: 125000.0, child: Text('125,000 Debit')),
                  DropdownMenuItem(value: 0.0, child: Text('0')),
                  DropdownMenuItem(value: -50000.0, child: Text('50,000 Credit')),
                ],
                onChanged: disabled
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() => _openingBalance = value);
                        }
                      },
              ),
            ),
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
      title: 'MultiTransactionTransferForAccountPdf',
      titleAr: 'PDF لحركات التحويل لحساب',
      description:
          'Customize presentation, labels, operation descriptions, commission '
          'visibility, opening balance, totals, QR, and notes. The current-balance '
          'column is recalculated from the selected opening balance.',
      icon: Icons.account_balance_wallet_outlined,
      backgroundGenerator: _generateInBackground,
      backgroundFileName:
          'multi_transaction_transfer_for_account_pdf_demo.pdf',
      jobMetadata: const <String, dynamic>{
        'feature': 'templates',
        'template': 'MultiTransactionTransferForAccountPdf',
      },
      showGenerationToast: true,
      usageCode:
          MultiTransactionTransferForAccountPdfExampleScreen.dartUsageCode,
      configurationRevision: _revision,
      settingsBuilder: _buildSettings,
    );
  }
}
