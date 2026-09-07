import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    show AccountExportFieldVisibility, MultiAccountImage;

import 'package:genius_pdf_example/features/export/presentation/widgets/template_image_export_detail_screen.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/export_template_customization_controls.dart';
import 'package:genius_pdf_example/features/templates/models/documents/account_export_demo_documents.dart';
import 'package:genius_pdf_example/features/templates/models/documents/template_example_build.dart';

/// Demonstrates [MultiAccountImage] splitting and customization together.
class MultiAccountImageExampleScreen extends StatefulWidget {
  const MultiAccountImageExampleScreen({super.key});

  static const String dartUsageCode = r'''final customization = AccountExportCustomization(
  headerLayout: GeniusPdfReportHeaderLayout.compact,
  infoBoxStyle: const GeniusPdfInfoBoxStyle.highlighted(),
  gridStyle: GeniusPdfGridStyle.striped(),
  reportDetailsColumns: 2,
);

final images = MultiAccountImage.split(
  config: config,
  meta: meta,
  accounts: accounts,
  company: company,
  customization: customization,
  maxAccountsPerImage: 8,
  showLastTransactionDate: true,
  configuration: const AccountExportConfiguration(
    fields: AccountExportFieldVisibility.multiImage,
    selectedCurrency: 'YER',
    showBalances: true,
    showActivity: true,
    activityMode: AccountExportActivityMode.summary,
  ),
);''';

  @override
  State<MultiAccountImageExampleScreen> createState() =>
      _MultiAccountImageExampleScreenState();
}

class _MultiAccountImageExampleScreenState
    extends State<MultiAccountImageExampleScreen> {
  ExportTemplateCustomizationSettings _customization =
      const ExportTemplateCustomizationSettings();
  int _accountsPerImage = 8;
  bool _showBalances = true;
  bool _showActivity = true;
  bool _showParent = true;
  bool _showGroup = true;
  bool _showLastTransactionDate = true;
  bool _showQRCode = true;
  bool _showNotes = true;

  String get _revision => <Object>[
        _customization.revisionKey,
        _accountsPerImage,
        _showBalances,
        _showActivity,
        _showParent,
        _showGroup,
        _showLastTransactionDate,
        _showQRCode,
        _showNotes,
      ].join('|');

  List<TemplateExampleBuild> _buildPdfSources({required bool isRtl}) {
    final builders = buildMultiAccountImageDemos(
      isRtl: isRtl,
      customization: _customization.toAccountCustomization(),
      fields: AccountExportFieldVisibility(
        parentAccountName: _showParent,
        group: _showGroup,
        accountNature: false,
      ),
      maxAccountsPerImage: _accountsPerImage,
      showBalances: _showBalances,
      showActivity: _showActivity,
      showLastTransactionDate: _showLastTransactionDate,
      showQRCode: _showQRCode,
      showNotes: _showNotes,
    );

    return <TemplateExampleBuild>[
      for (final builder in builders)
        TemplateExampleBuild(
          builder: builder,
          fileName: 'multi_account_image_${builder.imageIndex + 1}',
        ),
    ];
  }

  Widget _settings(BuildContext context, bool disabled) {
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
              width: 180,
              child: DropdownButtonFormField<int>(
                initialValue: _accountsPerImage,
                decoration: const InputDecoration(
                  labelText: 'Accounts / image',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                items: const <DropdownMenuItem<int>>[
                  DropdownMenuItem(value: 6, child: Text('6')),
                  DropdownMenuItem(value: 8, child: Text('8')),
                  DropdownMenuItem(value: 12, child: Text('12')),
                ],
                onChanged: disabled
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() => _accountsPerImage = value);
                        }
                      },
              ),
            ),
            _chip('Balances', _showBalances, disabled,
                (value) => setState(() => _showBalances = value)),
            _chip('Activity', _showActivity, disabled,
                (value) => setState(() => _showActivity = value)),
            _chip('Parent', _showParent, disabled,
                (value) => setState(() => _showParent = value)),
            _chip('Group', _showGroup, disabled,
                (value) => setState(() => _showGroup = value)),
            _chip(
              'Last transaction',
              _showLastTransactionDate,
              disabled,
              (value) => setState(() => _showLastTransactionDate = value),
            ),
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
    return TemplateImageExportDetailScreen(
      category: 'Account Export Templates',
      title: 'MultiAccountImage',
      description:
          'Customize the compact split export, including presentation styles, '
          'footer/formatting, accounts per image, visible account fields, last '
          'transaction date, balances/activity, QR, and notes.',
      icon: Icons.collections_outlined,
      pdfBuildsBuilder: _buildPdfSources,
      usageCode: MultiAccountImageExampleScreen.dartUsageCode,
      configurationRevision: _revision,
      additionalSettingsBuilder: _settings,
    );
  }
}
