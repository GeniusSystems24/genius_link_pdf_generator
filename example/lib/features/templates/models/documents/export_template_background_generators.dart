// Background-isolate export example generation.
//
// This file contains only example-app infrastructure. It intentionally keeps
// package template APIs unchanged. The expensive GeniusPdfDocumentBuilder
// generation step runs in Isolate.run, while UI/platform operations stay on
// the root isolate.

import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter/material.dart' show Size, TextDirection;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'package:genius_pdf_example/features/templates/models/documents/templates_demo_documents.dart';
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';
import 'package:genius_pdf_example/features/templates/models/documents/account_export_demo_documents.dart';
import 'package:genius_pdf_example/features/templates/models/documents/transaction_transfer_demo_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/export_template_customization_controls.dart';

/// Generated PDF documents returned from a background isolate.
///
/// Image examples can contain more than one PDF document because
/// [MultiAccountImage] splits a large data set into multiple compact images.
final class TemplateBackgroundPdfBatch {
  const TemplateBackgroundPdfBatch({
    required this.pdfDocuments,
    required this.fileNames,
  }) : assert(pdfDocuments.length == fileNames.length);

  final List<Uint8List> pdfDocuments;
  final List<String> fileNames;
}

Map<String, Object?> _configMessage() {
  final config = geniusPdfConfig;
  final assets = config.assetsOrNull;

  TransferableTypedData transfer(Uint8List bytes) =>
      TransferableTypedData.fromList(<Uint8List>[bytes]);

  return <String, Object?>{
    'baseFont': transfer(config.baseFontBytes),
    'boldFont':
        config.boldFontBytes == null ? null : transfer(config.boldFontBytes!),
    'headerFont': config.headerFontBytes == null
        ? null
        : transfer(config.headerFontBytes!),
    'smallFont':
        config.smallFontBytes == null ? null : transfer(config.smallFontBytes!),
    'baseFontSize': config.baseFontSize,
    'boldFontSize': config.boldFontSize,
    'headerFontSize': config.headerFontSize,
    'smallFontSize': config.smallFontSize,
    'pageWidth': config.pageSize.width,
    'pageHeight': config.pageSize.height,
    'marginLeft': config.margins.left,
    'marginTop': config.margins.top,
    'marginRight': config.margins.right,
    'marginBottom': config.margins.bottom,
    if (assets != null) ...<String, Object?>{
      'assetPrimaryFont': transfer(assets.primaryFont),
      'assetSecondaryFont': assets.secondaryFont == null
          ? null
          : transfer(assets.secondaryFont!),
      'assetHeaderImage':
          assets.headerImage == null ? null : transfer(assets.headerImage!),
      'assetLogo': assets.logo == null ? null : transfer(assets.logo!),
      'assetSquareLogo':
          assets.squareLogo == null ? null : transfer(assets.squareLogo!),
      'assetBackgroundImage': assets.backgroundImage == null
          ? null
          : transfer(assets.backgroundImage!),
      'assetLabelImage':
          assets.labelImage == null ? null : transfer(assets.labelImage!),
    },
  };
}

Uint8List? _materializeBytes(Object? value) {
  if (value == null) return null;
  return (value as TransferableTypedData).materialize().asUint8List();
}

GeniusPdfConfig _configFromMessage(Map<String, Object?> message) {
  final primaryAsset = _materializeBytes(message['assetPrimaryFont']);
  final margins = PdfMargins()
    ..left = (message['marginLeft']! as num).toDouble()
    ..top = (message['marginTop']! as num).toDouble()
    ..right = (message['marginRight']! as num).toDouble()
    ..bottom = (message['marginBottom']! as num).toDouble();

  return GeniusPdfConfig.createSync(
    baseFontBytes: _materializeBytes(message['baseFont'])!,
    boldFontBytes: _materializeBytes(message['boldFont']),
    headerFontBytes: _materializeBytes(message['headerFont']),
    smallFontBytes: _materializeBytes(message['smallFont']),
    baseFontSize: (message['baseFontSize']! as num).toDouble(),
    boldFontSize: (message['boldFontSize']! as num).toDouble(),
    headerFontSize: (message['headerFontSize']! as num).toDouble(),
    smallFontSize: (message['smallFontSize']! as num).toDouble(),
    pageSize: Size(
      (message['pageWidth']! as num).toDouble(),
      (message['pageHeight']! as num).toDouble(),
    ),
    textDirection: TextDirection.rtl,
    margins: margins,
    assetData: primaryAsset == null
        ? null
        : GeniusPdfAssetsData(
            primaryFont: primaryAsset,
            secondaryFont: _materializeBytes(message['assetSecondaryFont']),
            headerImage: _materializeBytes(message['assetHeaderImage']),
            logo: _materializeBytes(message['assetLogo']),
            squareLogo: _materializeBytes(message['assetSquareLogo']),
            backgroundImage:
                _materializeBytes(message['assetBackgroundImage']),
            labelImage: _materializeBytes(message['assetLabelImage']),
          ),
  );
}

Map<String, Object?> _settingsMessage(
  ExportTemplateCustomizationSettings settings,
) =>
    <String, Object?>{
      'headerPreset': settings.headerPreset.name,
      'infoBoxPreset': settings.infoBoxPreset.name,
      'gridPreset': settings.gridPreset.name,
      'detailsColumns': settings.detailsColumns,
      'showFooter': settings.showFooter,
      'compactDates': settings.compactDates,
      'wholeAmounts': settings.wholeAmounts,
      'appendIdsToDirectoryLabels': settings.appendIdsToDirectoryLabels,
      'bracketOperationType': settings.bracketOperationType,
    };

ExportTemplateCustomizationSettings _settingsFromMessage(
  Map<String, Object?> message,
) {
  return ExportTemplateCustomizationSettings(
    headerPreset: ExportExampleHeaderPreset.values.byName(
      message['headerPreset']! as String,
    ),
    infoBoxPreset: ExportExampleInfoBoxPreset.values.byName(
      message['infoBoxPreset']! as String,
    ),
    gridPreset: ExportExampleGridPreset.values.byName(
      message['gridPreset']! as String,
    ),
    detailsColumns: message['detailsColumns']! as int,
    showFooter: message['showFooter']! as bool,
    compactDates: message['compactDates']! as bool,
    wholeAmounts: message['wholeAmounts']! as bool,
    appendIdsToDirectoryLabels:
        message['appendIdsToDirectoryLabels']! as bool,
    bracketOperationType: message['bracketOperationType']! as bool,
  );
}

void _configureWorker(Map<String, Object?> message) {
  ExampleDependencies.configure(pdfConfig: _configFromMessage(message));
}


TransferableTypedData _generateSingleAccountPdfWorker(
  Map<String, Object?> message,
) {
  _configureWorker(message['config']! as Map<String, Object?>);
  final builder = buildSingleAccountPdfDemo(
    isRtl: message['isRtl']! as bool,
  );
  try {
    return TransferableTypedData.fromList(
      <Uint8List>[Uint8List.fromList(builder.generate())],
    );
  } finally {
    builder.dispose();
  }
}

TransferableTypedData _generateTaxInvoiceTemplateWorker(
  Map<String, Object?> message,
) {
  _configureWorker(message['config']! as Map<String, Object?>);
  final builder = buildTaxInvoiceTemplate(
    isRtl: message['isRtl']! as bool,
  );
  try {
    return TransferableTypedData.fromList(
      <Uint8List>[Uint8List.fromList(builder.generate())],
    );
  } finally {
    builder.dispose();
  }
}

TransferableTypedData _generateTrialBalanceTemplateWorker(
  Map<String, Object?> message,
) {
  _configureWorker(message['config']! as Map<String, Object?>);
  final builder = buildTrialBalanceTemplate(
    isRtl: message['isRtl']! as bool,
  );
  try {
    return TransferableTypedData.fromList(
      <Uint8List>[Uint8List.fromList(builder.generate())],
    );
  } finally {
    builder.dispose();
  }
}

TransferableTypedData _generateCustomerStatementTemplateWorker(
  Map<String, Object?> message,
) {
  _configureWorker(message['config']! as Map<String, Object?>);
  final builder = buildCustomerStatementTemplate(
    isRtl: message['isRtl']! as bool,
  );
  try {
    return TransferableTypedData.fromList(
      <Uint8List>[Uint8List.fromList(builder.generate())],
    );
  } finally {
    builder.dispose();
  }
}

TransferableTypedData _generateInventoryReportTemplateWorker(
  Map<String, Object?> message,
) {
  _configureWorker(message['config']! as Map<String, Object?>);
  final builder = buildInventoryReportTemplate(
    isRtl: message['isRtl']! as bool,
  );
  try {
    return TransferableTypedData.fromList(
      <Uint8List>[Uint8List.fromList(builder.generate())],
    );
  } finally {
    builder.dispose();
  }
}

TransferableTypedData _generateMultiAccountPdfWorker(
  Map<String, Object?> message,
) {
  _configureWorker(message['config']! as Map<String, Object?>);
  final settings = _settingsFromMessage(
    message['customization']! as Map<String, Object?>,
  );
  final builder = buildMultiAccountPdfDemo(
    isRtl: message['isRtl']! as bool,
    customization: settings.toAccountCustomization(),
    grouping:
        AccountExportGrouping.values.byName(message['grouping']! as String),
    showBalances: message['showBalances']! as bool,
    showActivity: message['showActivity']! as bool,
    showTotals: message['showTotals']! as bool,
    showQRCode: message['showQRCode']! as bool,
    showNotes: message['showNotes']! as bool,
  );
  try {
    return TransferableTypedData.fromList(
      <Uint8List>[Uint8List.fromList(builder.generate())],
    );
  } finally {
    builder.dispose();
  }
}

TransferableTypedData _generateMultiTransactionTransferPdfWorker(
  Map<String, Object?> message,
) {
  _configureWorker(message['config']! as Map<String, Object?>);
  final settings = _settingsFromMessage(
    message['customization']! as Map<String, Object?>,
  );
  final builder = buildMultiTransactionTransferPdfDemo(
    isRtl: message['isRtl']! as bool,
    customization: settings.toTransactionCustomization(),
    includeCommission: message['includeCommission']! as bool,
    showTotals: message['showTotals']! as bool,
    showQRCode: message['showQRCode']! as bool,
    showNotes: message['showNotes']! as bool,
  );
  try {
    return TransferableTypedData.fromList(
      <Uint8List>[Uint8List.fromList(builder.generate())],
    );
  } finally {
    builder.dispose();
  }
}

TransferableTypedData _generateMultiTransactionTransferForAccountPdfWorker(
  Map<String, Object?> message,
) {
  _configureWorker(message['config']! as Map<String, Object?>);
  final settings = _settingsFromMessage(
    message['customization']! as Map<String, Object?>,
  );
  final builder = buildMultiTransactionTransferForAccountPdfDemo(
    isRtl: message['isRtl']! as bool,
    customization: settings.toTransactionCustomization(),
    includeCommission: message['includeCommission']! as bool,
    showTotals: message['showTotals']! as bool,
    showQRCode: message['showQRCode']! as bool,
    showNotes: message['showNotes']! as bool,
    openingBalance: (message['openingBalance']! as num).toDouble(),
  );
  try {
    return TransferableTypedData.fromList(
      <Uint8List>[Uint8List.fromList(builder.generate())],
    );
  } finally {
    builder.dispose();
  }
}

Map<String, Object?> _generateSingleAccountImageWorker(
  Map<String, Object?> message,
) {
  _configureWorker(message['config']! as Map<String, Object?>);
  final settings = _settingsFromMessage(
    message['customization']! as Map<String, Object?>,
  );
  final builder = buildSingleAccountImageDemo(
    isRtl: message['isRtl']! as bool,
    customization: settings.toAccountCustomization(),
    fields: AccountExportFieldVisibility(
      parentAccountName: message['showParent']! as bool,
      group: message['showGroup']! as bool,
      accountNature: message['showNature']! as bool,
    ),
    showBalances: message['showBalances']! as bool,
    showActivity: message['showActivity']! as bool,
    showQRCode: message['showQRCode']! as bool,
    showNotes: message['showNotes']! as bool,
  );
  try {
    return <String, Object?>{
      'pdfs': <TransferableTypedData>[
        TransferableTypedData.fromList(
          <Uint8List>[Uint8List.fromList(builder.generate())],
        ),
      ],
      'fileNames': <String>['single_account_image'],
    };
  } finally {
    builder.dispose();
  }
}

Map<String, Object?> _generateMultiAccountImageWorker(
  Map<String, Object?> message,
) {
  _configureWorker(message['config']! as Map<String, Object?>);
  final settings = _settingsFromMessage(
    message['customization']! as Map<String, Object?>,
  );
  final builders = buildMultiAccountImageDemos(
    isRtl: message['isRtl']! as bool,
    customization: settings.toAccountCustomization(),
    fields: AccountExportFieldVisibility(
      parentAccountName: message['showParent']! as bool,
      group: message['showGroup']! as bool,
      accountNature: false,
    ),
    maxAccountsPerImage: message['accountsPerImage']! as int,
    showBalances: message['showBalances']! as bool,
    showActivity: message['showActivity']! as bool,
    showLastTransactionDate: message['showLastTransactionDate']! as bool,
    showQRCode: message['showQRCode']! as bool,
    showNotes: message['showNotes']! as bool,
  );

  final pdfs = <TransferableTypedData>[];
  final names = <String>[];
  for (final builder in builders) {
    try {
      pdfs.add(
        TransferableTypedData.fromList(
          <Uint8List>[Uint8List.fromList(builder.generate())],
        ),
      );
      names.add('multi_account_image_${builder.imageIndex + 1}');
    } finally {
      builder.dispose();
    }
  }
  return <String, Object?>{'pdfs': pdfs, 'fileNames': names};
}

Uint8List _materializePdf(TransferableTypedData data) =>
    data.materialize().asUint8List();

TemplateBackgroundPdfBatch _materializeBatch(Map<String, Object?> result) {
  final transferred =
      (result['pdfs']! as List<Object?>).cast<TransferableTypedData>();
  return TemplateBackgroundPdfBatch(
    pdfDocuments: transferred
        .map((item) => item.materialize().asUint8List())
        .toList(growable: false),
    fileNames: (result['fileNames']! as List<Object?>).cast<String>(),
  );
}

Map<String, Object?> _baseMessage({
  required bool isRtl,
  required ExportTemplateCustomizationSettings customization,
}) =>
    <String, Object?>{
      'config': _configMessage(),
      'isRtl': isRtl,
      'customization': _settingsMessage(customization),
    };


Map<String, Object?> _simpleTemplateMessage({
  required bool isRtl,
}) =>
    <String, Object?>{
      'config': _configMessage(),
      'isRtl': isRtl,
    };

/// Generates SingleAccountPdf entirely on a background isolate.
Future<Uint8List> generateSingleAccountPdfInBackground({
  required bool isRtl,
}) {
  final message = _simpleTemplateMessage(isRtl: isRtl);
  return Isolate.run<TransferableTypedData>(
    () => _generateSingleAccountPdfWorker(message),
    debugName: 'single-account-pdf-generator',
  ).then(_materializePdf);
}

/// Generates TaxInvoiceTemplate entirely on a background isolate.
Future<Uint8List> generateTaxInvoiceTemplateInBackground({
  required bool isRtl,
}) {
  final message = _simpleTemplateMessage(isRtl: isRtl);
  return Isolate.run<TransferableTypedData>(
    () => _generateTaxInvoiceTemplateWorker(message),
    debugName: 'tax-invoice-template-generator',
  ).then(_materializePdf);
}

/// Generates TrialBalanceTemplate entirely on a background isolate.
Future<Uint8List> generateTrialBalanceTemplateInBackground({
  required bool isRtl,
}) {
  final message = _simpleTemplateMessage(isRtl: isRtl);
  return Isolate.run<TransferableTypedData>(
    () => _generateTrialBalanceTemplateWorker(message),
    debugName: 'trial-balance-template-generator',
  ).then(_materializePdf);
}

/// Generates CustomerStatementTemplate entirely on a background isolate.
Future<Uint8List> generateCustomerStatementTemplateInBackground({
  required bool isRtl,
}) {
  final message = _simpleTemplateMessage(isRtl: isRtl);
  return Isolate.run<TransferableTypedData>(
    () => _generateCustomerStatementTemplateWorker(message),
    debugName: 'customer-statement-template-generator',
  ).then(_materializePdf);
}

/// Generates InventoryReportTemplate entirely on a background isolate.
Future<Uint8List> generateInventoryReportTemplateInBackground({
  required bool isRtl,
}) {
  final message = _simpleTemplateMessage(isRtl: isRtl);
  return Isolate.run<TransferableTypedData>(
    () => _generateInventoryReportTemplateWorker(message),
    debugName: 'inventory-report-template-generator',
  ).then(_materializePdf);
}

/// Generates the 200-account PDF entirely on a background isolate.
Future<Uint8List> generateMultiAccountPdfInBackground({
  required bool isRtl,
  required ExportTemplateCustomizationSettings customization,
  required AccountExportGrouping grouping,
  required bool showBalances,
  required bool showActivity,
  required bool showTotals,
  required bool showQRCode,
  required bool showNotes,
}) {
  final message = <String, Object?>{
    ..._baseMessage(isRtl: isRtl, customization: customization),
    'grouping': grouping.name,
    'showBalances': showBalances,
    'showActivity': showActivity,
    'showTotals': showTotals,
    'showQRCode': showQRCode,
    'showNotes': showNotes,
  };
  return Isolate.run<TransferableTypedData>(
    () => _generateMultiAccountPdfWorker(message),
    debugName: 'multi-account-pdf-generator',
  ).then(_materializePdf);
}

/// Generates the multi-transfer register on a background isolate.
Future<Uint8List> generateMultiTransactionTransferPdfInBackground({
  required bool isRtl,
  required ExportTemplateCustomizationSettings customization,
  required bool includeCommission,
  required bool showTotals,
  required bool showQRCode,
  required bool showNotes,
}) {
  final message = <String, Object?>{
    ..._baseMessage(isRtl: isRtl, customization: customization),
    'includeCommission': includeCommission,
    'showTotals': showTotals,
    'showQRCode': showQRCode,
    'showNotes': showNotes,
  };
  return Isolate.run<TransferableTypedData>(
    () => _generateMultiTransactionTransferPdfWorker(message),
    debugName: 'multi-transaction-transfer-pdf-generator',
  ).then(_materializePdf);
}

/// Generates the account-scoped transfer report on a background isolate.
Future<Uint8List> generateMultiTransactionTransferForAccountPdfInBackground({
  required bool isRtl,
  required ExportTemplateCustomizationSettings customization,
  required bool includeCommission,
  required bool showTotals,
  required bool showQRCode,
  required bool showNotes,
  required double openingBalance,
}) {
  final message = <String, Object?>{
    ..._baseMessage(isRtl: isRtl, customization: customization),
    'includeCommission': includeCommission,
    'showTotals': showTotals,
    'showQRCode': showQRCode,
    'showNotes': showNotes,
    'openingBalance': openingBalance,
  };
  return Isolate.run<TransferableTypedData>(
    () => _generateMultiTransactionTransferForAccountPdfWorker(message),
    debugName: 'account-transaction-transfer-pdf-generator',
  ).then(_materializePdf);
}

/// Generates the compact single-account PDF source on a background isolate.
Future<TemplateBackgroundPdfBatch> generateSingleAccountImagePdfsInBackground({
  required bool isRtl,
  required ExportTemplateCustomizationSettings customization,
  required bool showBalances,
  required bool showActivity,
  required bool showParent,
  required bool showGroup,
  required bool showNature,
  required bool showQRCode,
  required bool showNotes,
}) {
  final message = <String, Object?>{
    ..._baseMessage(isRtl: isRtl, customization: customization),
    'showBalances': showBalances,
    'showActivity': showActivity,
    'showParent': showParent,
    'showGroup': showGroup,
    'showNature': showNature,
    'showQRCode': showQRCode,
    'showNotes': showNotes,
  };
  return Isolate.run<Map<String, Object?>>(
    () => _generateSingleAccountImageWorker(message),
    debugName: 'single-account-image-generator',
  ).then(_materializeBatch);
}

/// Generates all compact multi-account PDF sources on a background isolate.
Future<TemplateBackgroundPdfBatch> generateMultiAccountImagePdfsInBackground({
  required bool isRtl,
  required ExportTemplateCustomizationSettings customization,
  required int accountsPerImage,
  required bool showBalances,
  required bool showActivity,
  required bool showParent,
  required bool showGroup,
  required bool showLastTransactionDate,
  required bool showQRCode,
  required bool showNotes,
}) {
  final message = <String, Object?>{
    ..._baseMessage(isRtl: isRtl, customization: customization),
    'accountsPerImage': accountsPerImage,
    'showBalances': showBalances,
    'showActivity': showActivity,
    'showParent': showParent,
    'showGroup': showGroup,
    'showLastTransactionDate': showLastTransactionDate,
    'showQRCode': showQRCode,
    'showNotes': showNotes,
  };
  return Isolate.run<Map<String, Object?>>(
    () => _generateMultiAccountImageWorker(message),
    debugName: 'multi-account-image-generator',
  ).then(_materializeBatch);
}
