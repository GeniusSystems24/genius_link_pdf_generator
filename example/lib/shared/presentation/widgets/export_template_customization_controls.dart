import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    show
        AccountExportCustomization,
        GeniusPdfGridStyle,
        GeniusPdfInfoBoxStyle,
        GeniusPdfReportHeaderLayout,
        TransactionTransferTemplateCustomization;

/// Header presets exposed by the export-template customization examples.
enum ExportExampleHeaderPreset {
  bilingualSplit,
  compact,
  centered,
}

/// Information-box presets exposed by the export-template examples.
enum ExportExampleInfoBoxPreset {
  minimal,
  card,
  highlighted,
}

/// Grid presets exposed by the export-template examples.
enum ExportExampleGridPreset {
  classic,
  modern,
  minimal,
  striped,
}

/// Reusable state used by account and transaction-transfer customization demos.
@immutable
class ExportTemplateCustomizationSettings {
  const ExportTemplateCustomizationSettings({
    this.headerPreset = ExportExampleHeaderPreset.bilingualSplit,
    this.infoBoxPreset = ExportExampleInfoBoxPreset.minimal,
    this.gridPreset = ExportExampleGridPreset.classic,
    this.detailsColumns = 3,
    this.showFooter = true,
    this.compactDates = false,
    this.wholeAmounts = false,
    this.appendIdsToDirectoryLabels = false,
    this.bracketOperationType = false,
  });

  final ExportExampleHeaderPreset headerPreset;
  final ExportExampleInfoBoxPreset infoBoxPreset;
  final ExportExampleGridPreset gridPreset;
  final int detailsColumns;
  final bool showFooter;
  final bool compactDates;
  final bool wholeAmounts;

  /// Transaction-transfer-only label customization.
  final bool appendIdsToDirectoryLabels;

  /// Transaction-transfer-only description customization.
  final bool bracketOperationType;

  ExportTemplateCustomizationSettings copyWith({
    ExportExampleHeaderPreset? headerPreset,
    ExportExampleInfoBoxPreset? infoBoxPreset,
    ExportExampleGridPreset? gridPreset,
    int? detailsColumns,
    bool? showFooter,
    bool? compactDates,
    bool? wholeAmounts,
    bool? appendIdsToDirectoryLabels,
    bool? bracketOperationType,
  }) {
    return ExportTemplateCustomizationSettings(
      headerPreset: headerPreset ?? this.headerPreset,
      infoBoxPreset: infoBoxPreset ?? this.infoBoxPreset,
      gridPreset: gridPreset ?? this.gridPreset,
      detailsColumns: detailsColumns ?? this.detailsColumns,
      showFooter: showFooter ?? this.showFooter,
      compactDates: compactDates ?? this.compactDates,
      wholeAmounts: wholeAmounts ?? this.wholeAmounts,
      appendIdsToDirectoryLabels:
          appendIdsToDirectoryLabels ?? this.appendIdsToDirectoryLabels,
      bracketOperationType: bracketOperationType ?? this.bracketOperationType,
    );
  }

  /// Stable value used by example hosts to invalidate an old preview.
  String get revisionKey => <Object>[
        headerPreset,
        infoBoxPreset,
        gridPreset,
        detailsColumns,
        showFooter,
        compactDates,
        wholeAmounts,
        appendIdsToDirectoryLabels,
        bracketOperationType,
      ].join('|');

  GeniusPdfReportHeaderLayout get _headerLayout => switch (headerPreset) {
        ExportExampleHeaderPreset.bilingualSplit =>
          GeniusPdfReportHeaderLayout.bilingualSplit,
        ExportExampleHeaderPreset.compact => GeniusPdfReportHeaderLayout.compact,
        ExportExampleHeaderPreset.centered =>
          GeniusPdfReportHeaderLayout.centered,
      };

  GeniusPdfInfoBoxStyle get _infoBoxStyle => switch (infoBoxPreset) {
        ExportExampleInfoBoxPreset.minimal => GeniusPdfInfoBoxStyle.minimal(),
        ExportExampleInfoBoxPreset.card => const GeniusPdfInfoBoxStyle.card(),
        ExportExampleInfoBoxPreset.highlighted =>
          const GeniusPdfInfoBoxStyle.highlighted(),
      };

  GeniusPdfGridStyle get _gridStyle => switch (gridPreset) {
        ExportExampleGridPreset.classic => const GeniusPdfGridStyle.classic(),
        ExportExampleGridPreset.modern => GeniusPdfGridStyle.modern(),
        ExportExampleGridPreset.minimal => GeniusPdfGridStyle.minimal(),
        ExportExampleGridPreset.striped => GeniusPdfGridStyle.striped(),
      };

  String _formatDate(DateTime value) => compactDates
      ? '${value.day.toString().padLeft(2, '0')}/'
          '${value.month.toString().padLeft(2, '0')}/'
          '${value.year}'
      : '${value.year.toString().padLeft(4, '0')}-'
          '${value.month.toString().padLeft(2, '0')}-'
          '${value.day.toString().padLeft(2, '0')}';

  String _formatAmount(double value, String? currency) {
    final amount = value.toStringAsFixed(wholeAmounts ? 0 : 2);
    final code = currency?.trim();
    return code == null || code.isEmpty ? amount : '$amount $code';
  }

  /// Builds [AccountExportCustomization] from the interactive controls.
  AccountExportCustomization toAccountCustomization() {
    return AccountExportCustomization(
      headerLayout: _headerLayout,
      infoBoxStyle: _infoBoxStyle,
      gridStyle: _gridStyle,
      reportDetailsColumns: detailsColumns,
      accountDetailsColumns: detailsColumns,
      showFooter: showFooter,
      dateFormatter: compactDates ? _formatDate : null,
      amountFormatter: wholeAmounts ? _formatAmount : null,
    );
  }

  /// Builds [TransactionTransferTemplateCustomization] from the controls.
  TransactionTransferTemplateCustomization toTransactionCustomization() {
    return TransactionTransferTemplateCustomization(
      headerLayout: _headerLayout,
      infoBoxStyle: _infoBoxStyle,
      gridStyle: _gridStyle,
      reportDetailsColumns: detailsColumns,
      showFooter: showFooter,
      dateFormatter: compactDates ? _formatDate : null,
      amountFormatter: wholeAmounts ? _formatAmount : null,
      accountLabelBuilder: appendIdsToDirectoryLabels
          ? (accountId, account, isRtl) {
              final name = account?.displayName(isRtl: isRtl) ??
                  (isRtl ? 'حساب' : 'Account');
              return '$name [$accountId]';
            }
          : null,
      serviceLabelBuilder: appendIdsToDirectoryLabels
          ? (serviceId, service, isRtl) {
              final name = service?.displayName(isRtl: isRtl) ??
                  (isRtl ? 'خدمة' : 'Service');
              return '$name [$serviceId]';
            }
          : null,
      descriptionBuilder: bracketOperationType
          ? (row, isRtl) {
              final type = row.description.isCommission
                  ? (isRtl ? 'عمولة' : 'Commission')
                  : (isRtl ? 'تحويل' : 'Transfer');
              final note = row.description.note?.trim();
              if (note == null || note.isEmpty) return '[$type]';
              return '[$type] $note';
            }
          : null,
    );
  }
}

/// Shared controls for the reusable account/transaction export APIs.
class ExportTemplateCustomizationControls extends StatelessWidget {
  const ExportTemplateCustomizationControls({
    super.key,
    required this.value,
    required this.onChanged,
    this.disabled = false,
    this.showTransactionOptions = false,
  });

  final ExportTemplateCustomizationSettings value;
  final ValueChanged<ExportTemplateCustomizationSettings> onChanged;
  final bool disabled;
  final bool showTransactionOptions;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        _dropdown<ExportExampleHeaderPreset>(
          label: 'Header',
          value: value.headerPreset,
          items: const <ExportExampleHeaderPreset, String>{
            ExportExampleHeaderPreset.bilingualSplit: 'Bilingual split',
            ExportExampleHeaderPreset.compact: 'Compact',
            ExportExampleHeaderPreset.centered: 'Centered',
          },
          onChanged: (next) => onChanged(value.copyWith(headerPreset: next)),
        ),
        _dropdown<ExportExampleInfoBoxPreset>(
          label: 'Info box',
          value: value.infoBoxPreset,
          items: const <ExportExampleInfoBoxPreset, String>{
            ExportExampleInfoBoxPreset.minimal: 'Minimal',
            ExportExampleInfoBoxPreset.card: 'Card',
            ExportExampleInfoBoxPreset.highlighted: 'Highlighted',
          },
          onChanged: (next) => onChanged(value.copyWith(infoBoxPreset: next)),
        ),
        _dropdown<ExportExampleGridPreset>(
          label: 'Grid',
          value: value.gridPreset,
          items: const <ExportExampleGridPreset, String>{
            ExportExampleGridPreset.classic: 'Classic',
            ExportExampleGridPreset.modern: 'Modern',
            ExportExampleGridPreset.minimal: 'Minimal',
            ExportExampleGridPreset.striped: 'Striped',
          },
          onChanged: (next) => onChanged(value.copyWith(gridPreset: next)),
        ),
        _dropdown<int>(
          label: 'Detail columns',
          value: value.detailsColumns,
          items: const <int, String>{2: '2', 3: '3', 4: '4'},
          onChanged: (next) => onChanged(value.copyWith(detailsColumns: next)),
          width: 150,
        ),
        FilterChip(
          label: const Text('Footer'),
          selected: value.showFooter,
          onSelected: disabled
              ? null
              : (selected) => onChanged(value.copyWith(showFooter: selected)),
        ),
        FilterChip(
          label: const Text('DD/MM dates'),
          selected: value.compactDates,
          onSelected: disabled
              ? null
              : (selected) => onChanged(value.copyWith(compactDates: selected)),
        ),
        FilterChip(
          label: const Text('Whole amounts'),
          selected: value.wholeAmounts,
          onSelected: disabled
              ? null
              : (selected) => onChanged(value.copyWith(wholeAmounts: selected)),
        ),
        if (showTransactionOptions) ...<Widget>[
          FilterChip(
            label: const Text('Names + IDs'),
            selected: value.appendIdsToDirectoryLabels,
            onSelected: disabled
                ? null
                : (selected) => onChanged(
                      value.copyWith(appendIdsToDirectoryLabels: selected),
                    ),
          ),
          FilterChip(
            label: const Text('[Type] description'),
            selected: value.bracketOperationType,
            onSelected: disabled
                ? null
                : (selected) => onChanged(
                      value.copyWith(bracketOperationType: selected),
                    ),
          ),
        ],
      ],
    );
  }

  Widget _dropdown<T>({
    required String label,
    required T value,
    required Map<T, String> items,
    required ValueChanged<T> onChanged,
    double width = 190,
  }) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<T>(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          border: const OutlineInputBorder(),
        ),
        items: items.entries
            .map(
              (entry) => DropdownMenuItem<T>(
                value: entry.key,
                child: Text(entry.value),
              ),
            )
            .toList(growable: false),
        onChanged: disabled
            ? null
            : (next) {
                if (next != null) onChanged(next);
              },
      ),
    );
  }
}
