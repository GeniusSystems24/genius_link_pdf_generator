import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    show AccountExportFieldVisibility, SingleAccountImage;

import 'package:genius_pdf_example/features/export/presentation/widgets/template_image_export_detail_screen.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/export_template_customization_controls.dart';
import 'package:genius_pdf_example/features/templates/models/documents/account_export_demo_documents.dart';
import 'package:genius_pdf_example/features/templates/models/documents/template_example_build.dart';

/// Demonstrates [SingleAccountImage] with interactive customization.
class SingleAccountImageExampleScreen extends StatefulWidget {
  const SingleAccountImageExampleScreen({super.key});

  static const String dartUsageCode = r'''final customization = AccountExportCustomization(
  headerLayout: GeniusPdfReportHeaderLayout.compact,
  infoBoxStyle: const GeniusPdfInfoBoxStyle.card(),
  gridStyle: GeniusPdfGridStyle.minimal(),
  accountDetailsColumns: 2,
  showFooter: false,
);

final compact = SingleAccountImage(
  config: config,
  meta: meta,
  account: account,
  company: company,
  customization: customization,
  configuration: const AccountExportConfiguration(
    fields: AccountExportFieldVisibility(
      parentAccountName: true,
      group: true,
      accountNature: false,
    ),
    selectedCurrency: 'YER',
    showBalances: true,
    showActivity: true,
    activityMode: AccountExportActivityMode.summary,
  ),
);''';

  @override
  State<SingleAccountImageExampleScreen> createState() =>
      _SingleAccountImageExampleScreenState();
}

class _SingleAccountImageExampleScreenState
    extends State<SingleAccountImageExampleScreen> {
  ExportTemplateCustomizationSettings _customization =
      const ExportTemplateCustomizationSettings();
  bool _showBalances = true;
  bool _showActivity = true;
  bool _showParent = true;
  bool _showGroup = true;
  bool _showNature = true;
  bool _showQRCode = true;
  bool _showNotes = true;

  String get _revision => <Object>[
        _customization.revisionKey,
        _showBalances,
        _showActivity,
        _showParent,
        _showGroup,
        _showNature,
        _showQRCode,
        _showNotes,
      ].join('|');

  List<TemplateExampleBuild> _buildPdfSources({required bool isRtl}) {
    return <TemplateExampleBuild>[
      TemplateExampleBuild(
        builder: buildSingleAccountImageDemo(
          isRtl: isRtl,
          customization: _customization.toAccountCustomization(),
          fields: AccountExportFieldVisibility(
            parentAccountName: _showParent,
            group: _showGroup,
            accountNature: _showNature,
          ),
          showBalances: _showBalances,
          showActivity: _showActivity,
          showQRCode: _showQRCode,
          showNotes: _showNotes,
        ),
        fileName: 'single_account_image',
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
          children: <Widget>[
            _chip('Balances', _showBalances, disabled,
                (value) => setState(() => _showBalances = value)),
            _chip('Activity', _showActivity, disabled,
                (value) => setState(() => _showActivity = value)),
            _chip('Parent', _showParent, disabled,
                (value) => setState(() => _showParent = value)),
            _chip('Group', _showGroup, disabled,
                (value) => setState(() => _showGroup = value)),
            _chip('Nature', _showNature, disabled,
                (value) => setState(() => _showNature = value)),
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
      title: 'SingleAccountImage',
      description:
          'Customize the compact image source before rasterization: header, '
          'info/grid styles, footer, formatting, optional account fields, '
          'balances, activity, QR, and notes.',
      icon: Icons.image_outlined,
      pdfBuildsBuilder: _buildPdfSources,
      usageCode: SingleAccountImageExampleScreen.dartUsageCode,
      configurationRevision: _revision,
      additionalSettingsBuilder: _settings,
    );
  }
}
