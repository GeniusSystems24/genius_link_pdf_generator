import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart'
    show geniusPdfConfig;
import 'package:genius_pdf_example/shared/data/sample_data.dart';

/// Exact transaction-transfer sample rows used by the two report examples.
///
/// The sample intentionally preserves the source schema, including numeric
/// status values and the composite `(serviceId, transactionId)` identity.
const String _transactionTransferDemoJson = r'''[
  {"rowNo":1,"tenantId":1,"serviceId":200,"transactionId":1,"id":1,"accountId":2305,"currencyId":"YER","amount":5000.0,"description":{"note":"","creditAccounts":[{"accountId":11010001,"currencyId":"YER","amount":5000.0}],"creatorDeviceId":"72311F09-9252-B912-8B41-D22ECF7F0525"},"status":20,"creatorUserId":1,"createdAt":"2026-09-01T00:00:00","updatorUserId":1,"updatedAt":"2026-09-01T03:42:46.24"},
  {"rowNo":2,"tenantId":1,"serviceId":200,"transactionId":1,"id":2,"accountId":11010001,"currencyId":"YER","amount":-5000.0,"description":{"note":"","debitAccounts":[{"accountId":2305,"currencyId":"YER","amount":5000.0}],"creatorDeviceId":"72311F09-9252-B912-8B41-D22ECF7F0525"},"status":20,"creatorUserId":1,"createdAt":"2026-09-01T00:00:00","updatorUserId":1,"updatedAt":"2026-09-01T03:42:46.24"},
  {"rowNo":3,"tenantId":1,"serviceId":10100,"transactionId":1,"id":2,"accountId":11010001,"currencyId":"YER","amount":-5000.0,"description":{"note":"","debitAccounts":[{"accountId":2305,"currencyId":"YER","amount":5000.0}],"creatorDeviceId":"72311F09-9252-B912-8B41-D22ECF7F0525"},"status":20,"creatorUserId":1,"createdAt":"2026-09-01T00:00:00","updatorUserId":1,"updatedAt":"2026-09-01T03:30:34.783"},
  {"rowNo":4,"tenantId":1,"serviceId":10100,"transactionId":1,"id":1,"accountId":2305,"currencyId":"YER","amount":5000.0,"description":{"note":"","creditAccounts":[{"accountId":11010001,"currencyId":"YER","amount":5000.0}],"creatorDeviceId":"72311F09-9252-B912-8B41-D22ECF7F0525"},"status":20,"creatorUserId":1,"createdAt":"2026-09-01T00:00:00","updatorUserId":1,"updatedAt":"2026-09-01T03:30:34.773"},
  {"rowNo":5,"tenantId":1,"serviceId":100,"transactionId":5,"id":1,"accountId":11010001,"currencyId":"YER","amount":50000.0,"description":{"note":"","creditAccounts":[{"accountId":2305,"currencyId":"YER","amount":50000.0}],"creatorDeviceId":"72311F09-9252-B912-8B41-D22ECF7F0525"},"status":20,"creatorUserId":1,"createdAt":"2026-08-29T00:00:00","updatorUserId":1,"updatedAt":"2026-08-29T07:08:25.88"},
  {"rowNo":6,"tenantId":1,"serviceId":100,"transactionId":5,"id":2,"accountId":2305,"currencyId":"YER","amount":-50000.0,"description":{"note":"","debitAccounts":[{"accountId":11010001,"currencyId":"YER","amount":50000.0}],"creatorDeviceId":"72311F09-9252-B912-8B41-D22ECF7F0525"},"status":20,"creatorUserId":1,"createdAt":"2026-08-29T00:00:00","updatorUserId":1,"updatedAt":"2026-08-29T07:08:25.88"},
  {"rowNo":7,"tenantId":1,"serviceId":100,"transactionId":4,"id":1,"accountId":11010001,"currencyId":"YER","amount":50000.0,"description":{"note":"تحصيل مستحقات فواتير سابقة","creditAccounts":[{"accountId":2305,"currencyId":"YER","amount":50000.0}],"creatorDeviceId":"C9503087-CE7A-5811-B9B6-79D924224F54"},"status":20,"creatorUserId":1,"createdAt":"2026-08-29T01:26:31.87","updatorUserId":1,"updatedAt":"2026-08-29T01:26:32.01"},
  {"rowNo":8,"tenantId":1,"serviceId":100,"transactionId":4,"id":2,"accountId":2305,"currencyId":"YER","amount":-50000.0,"description":{"note":"تحصيل مستحقات فواتير سابقة","debitAccounts":[{"accountId":11010001,"currencyId":"YER","amount":50000.0}],"creatorDeviceId":"C9503087-CE7A-5811-B9B6-79D924224F54"},"status":20,"creatorUserId":1,"createdAt":"2026-08-29T01:26:31.87","updatorUserId":1,"updatedAt":"2026-08-29T01:26:32.01"},
  {"rowNo":9,"tenantId":1,"serviceId":10400,"transactionId":9,"id":1,"accountId":2305,"currencyId":"YER","amount":15000.0,"description":{"note":"حوالة محلية عادية - مثال بدء","creatorDeviceId":"C9503087-CE7A-5811-B9B6-79D924224F54","creditAccounts":[{"accountId":11080002,"currencyId":"YER","amount":15000.0}]},"status":10,"creatorUserId":1,"createdAt":"2026-08-28T05:42:27.89","updatorUserId":1,"updatedAt":"2026-08-28T05:42:27.89"},
  {"rowNo":10,"tenantId":1,"serviceId":10400,"transactionId":9,"id":2,"accountId":2305,"currencyId":"YER","amount":400.0,"description":{"note":"حوالة محلية عادية - مثال بدء","creatorDeviceId":"C9503087-CE7A-5811-B9B6-79D924224F54","type":"commission","creditAccounts":[{"accountId":11080002,"currencyId":"YER","amount":400.0}]},"status":10,"creatorUserId":1,"createdAt":"2026-08-28T05:42:27.89","updatorUserId":1,"updatedAt":"2026-08-28T05:42:27.89"},
  {"rowNo":11,"tenantId":1,"serviceId":10400,"transactionId":9,"id":3,"accountId":11080002,"currencyId":"YER","amount":-15000.0,"description":{"note":"حوالة محلية عادية - مثال بدء","creatorDeviceId":"C9503087-CE7A-5811-B9B6-79D924224F54","debitAccounts":[{"accountId":2305,"currencyId":"YER","amount":15000.0}]},"status":10,"creatorUserId":1,"createdAt":"2026-08-28T05:42:27.89","updatorUserId":1,"updatedAt":"2026-08-28T05:42:27.89"},
  {"rowNo":12,"tenantId":1,"serviceId":10400,"transactionId":9,"id":4,"accountId":11080002,"currencyId":"YER","amount":-400.0,"description":{"note":"حوالة محلية عادية - مثال بدء","creatorDeviceId":"C9503087-CE7A-5811-B9B6-79D924224F54","type":"commission","debitAccounts":[{"accountId":2305,"currencyId":"YER","amount":400.0}]},"status":10,"creatorUserId":1,"createdAt":"2026-08-28T05:42:27.89","updatorUserId":1,"updatedAt":"2026-08-28T05:42:27.89"},
  {"rowNo":13,"tenantId":1,"serviceId":10400,"transactionId":8,"id":1,"accountId":2305,"currencyId":"YER","amount":15000.0,"description":{"note":"حوالة محلية عادية - مثال بدء","creatorDeviceId":"C9503087-CE7A-5811-B9B6-79D924224F54","creditAccounts":[{"accountId":11080002,"currencyId":"YER","amount":15000.0}]},"status":10,"creatorUserId":1,"createdAt":"2026-08-28T05:41:26.117","updatorUserId":1,"updatedAt":"2026-08-28T05:41:26.117"},
  {"rowNo":14,"tenantId":1,"serviceId":10400,"transactionId":8,"id":2,"accountId":2305,"currencyId":"YER","amount":400.0,"description":{"note":"حوالة محلية عادية - مثال بدء","creatorDeviceId":"C9503087-CE7A-5811-B9B6-79D924224F54","type":"commission","creditAccounts":[{"accountId":11080002,"currencyId":"YER","amount":400.0}]},"status":10,"creatorUserId":1,"createdAt":"2026-08-28T05:41:26.117","updatorUserId":1,"updatedAt":"2026-08-28T05:41:26.117"},
  {"rowNo":15,"tenantId":1,"serviceId":10400,"transactionId":8,"id":3,"accountId":11080002,"currencyId":"YER","amount":-15000.0,"description":{"note":"حوالة محلية عادية - مثال بدء","creatorDeviceId":"C9503087-CE7A-5811-B9B6-79D924224F54","debitAccounts":[{"accountId":2305,"currencyId":"YER","amount":15000.0}]},"status":10,"creatorUserId":1,"createdAt":"2026-08-28T05:41:26.117","updatorUserId":1,"updatedAt":"2026-08-28T05:41:26.117"},
  {"rowNo":16,"tenantId":1,"serviceId":10400,"transactionId":8,"id":4,"accountId":11080002,"currencyId":"YER","amount":-400.0,"description":{"note":"حوالة محلية عادية - مثال بدء","creatorDeviceId":"C9503087-CE7A-5811-B9B6-79D924224F54","type":"commission","debitAccounts":[{"accountId":2305,"currencyId":"YER","amount":400.0}]},"status":10,"creatorUserId":1,"createdAt":"2026-08-28T05:41:26.117","updatorUserId":1,"updatedAt":"2026-08-28T05:41:26.117"},
  {"rowNo":17,"tenantId":1,"serviceId":10400,"transactionId":10,"id":1,"accountId":2305,"currencyId":"YER","amount":10000.0,"description":{"note":"حوالة محلية عادية - مثال بدء","creatorDeviceId":"D5496ABC-C3CA-E2F9-B050-86DD5F83BCC7","creditAccounts":[{"accountId":11080002,"currencyId":"YER","amount":10000.0}]},"status":10,"creatorUserId":1,"createdAt":"2026-08-28T04:05:29.337","updatorUserId":1,"updatedAt":"2026-08-28T04:05:29.337"},
  {"rowNo":18,"tenantId":1,"serviceId":10400,"transactionId":10,"id":2,"accountId":2305,"currencyId":"YER","amount":200.0,"description":{"note":"حوالة محلية عادية - مثال بدء","creatorDeviceId":"D5496ABC-C3CA-E2F9-B050-86DD5F83BCC7","type":"commission","creditAccounts":[{"accountId":11080002,"currencyId":"YER","amount":200.0}]},"status":10,"creatorUserId":1,"createdAt":"2026-08-28T04:05:29.337","updatorUserId":1,"updatedAt":"2026-08-28T04:05:29.337"},
  {"rowNo":19,"tenantId":1,"serviceId":10400,"transactionId":10,"id":3,"accountId":11080002,"currencyId":"YER","amount":-10000.0,"description":{"note":"حوالة محلية عادية - مثال بدء","creatorDeviceId":"D5496ABC-C3CA-E2F9-B050-86DD5F83BCC7","debitAccounts":[{"accountId":2305,"currencyId":"YER","amount":10000.0}]},"status":10,"creatorUserId":1,"createdAt":"2026-08-28T04:05:29.337","updatorUserId":1,"updatedAt":"2026-08-28T04:05:29.337"},
  {"rowNo":20,"tenantId":1,"serviceId":10400,"transactionId":10,"id":4,"accountId":11080002,"currencyId":"YER","amount":-200.0,"description":{"note":"حوالة محلية عادية - مثال بدء","creatorDeviceId":"D5496ABC-C3CA-E2F9-B050-86DD5F83BCC7","type":"commission","debitAccounts":[{"accountId":2305,"currencyId":"YER","amount":200.0}]},"status":10,"creatorUserId":1,"createdAt":"2026-08-28T04:05:29.337","updatorUserId":1,"updatedAt":"2026-08-28T04:05:29.337"},
  {"rowNo":21,"tenantId":1,"serviceId":10400,"transactionId":6,"id":1,"accountId":2305,"currencyId":"YER","amount":-15000.0,"description":{"note":"حوالة محلية عادية - مثال بدء","creatorDeviceId":"C9503087-CE7A-5811-B9B6-79D924224F54","creditAccounts":[{"accountId":11080002,"currencyId":"YER","amount":15000.0}]},"status":10,"creatorUserId":1,"createdAt":"2026-08-28T03:29:33.19","updatorUserId":1,"updatedAt":"2026-08-28T03:29:33.19"},
  {"rowNo":22,"tenantId":1,"serviceId":10400,"transactionId":6,"id":2,"accountId":2305,"currencyId":"YER","amount":-400.0,"description":{"note":"حوالة محلية عادية - مثال بدء","creatorDeviceId":"C9503087-CE7A-5811-B9B6-79D924224F54","type":"commission","creditAccounts":[{"accountId":11080002,"currencyId":"YER","amount":400.0}]},"status":10,"creatorUserId":1,"createdAt":"2026-08-28T03:29:33.19","updatorUserId":1,"updatedAt":"2026-08-28T03:29:33.19"},
  {"rowNo":23,"tenantId":1,"serviceId":10400,"transactionId":6,"id":3,"accountId":11080002,"currencyId":"YER","amount":15000.0,"description":{"note":"حوالة محلية عادية - مثال بدء","creatorDeviceId":"C9503087-CE7A-5811-B9B6-79D924224F54","debitAccounts":[{"accountId":2305,"currencyId":"YER","amount":15000.0}]},"status":10,"creatorUserId":1,"createdAt":"2026-08-28T03:29:33.19","updatorUserId":1,"updatedAt":"2026-08-28T03:29:33.19"},
  {"rowNo":24,"tenantId":1,"serviceId":10400,"transactionId":6,"id":4,"accountId":11080002,"currencyId":"YER","amount":400.0,"description":{"note":"حوالة محلية عادية - مثال بدء","creatorDeviceId":"C9503087-CE7A-5811-B9B6-79D924224F54","type":"commission","debitAccounts":[{"accountId":2305,"currencyId":"YER","amount":400.0}]},"status":10,"creatorUserId":1,"createdAt":"2026-08-28T03:29:33.19","updatorUserId":1,"updatedAt":"2026-08-28T03:29:33.19"},
  {"rowNo":25,"tenantId":1,"serviceId":10400,"transactionId":7,"id":1,"accountId":2305,"currencyId":"YER","amount":-10000.0,"description":{"creatorDeviceId":"72311F09-9252-B912-8B41-D22ECF7F0525","creditAccounts":[{"accountId":11080002,"currencyId":"YER","amount":10000.0}]},"status":10,"creatorUserId":1,"createdAt":"2026-08-28T01:24:35.997","updatorUserId":1,"updatedAt":"2026-08-28T01:24:35.997"}
]''';

/// Service rows referenced by [_transactionTransferDemoJson].
const String _transactionTransferServicesDemoJson = r'''[
  {"id":100,"description":{"names":{"ar":"سند قبض نقدي","en":"Cash Receipt"},"extensionSymbol":"Cash-RCV"}},
  {"id":200,"description":{"names":{"ar":"سند صرف نقدي","en":"Cash Payment"},"extensionSymbol":"Cash-Pay"}},
  {"id":10100,"description":{"names":{"ar":"سحب نقدي","en":"Cash Withdrawal"},"extensionSymbol":"Cash-WDR"}},
  {"id":10400,"description":{"names":{"ar":"إرسال حوالة محلية عادية","en":"Send Regular Local Transfer"},"extensionSymbol":"SND-LCL"}}
]''';

/// Transaction-transfer rows parsed from the supplied JSON sample.
final List<TransactionTransferRow> transactionTransferDemoRows =
    TransactionTransferJsonData.rowsFromJson(
      jsonDecode(_transactionTransferDemoJson),
    );

/// Service lookup for the services present in the supplied transfer sample.
final Map<int, TransactionTransferServiceInfo> transactionTransferDemoServices =
    TransactionTransferJsonData.servicesFromJson(
      jsonDecode(_transactionTransferServicesDemoJson),
    );

/// Minimal account directory for the IDs present in the source sample.
///
/// The uploaded transfer JSON contains IDs but no account names, so these
/// labels intentionally identify the account by number rather than inventing
/// business semantics that are not present in the source.
const Map<int, TransactionTransferAccountInfo>
transactionTransferDemoAccountDirectory = <int, TransactionTransferAccountInfo>{
  2305: TransactionTransferAccountInfo(
    accountId: 2305,
    name: 'Account 2305',
    nameAr: 'الحساب 2305',
  ),
  11010001: TransactionTransferAccountInfo(
    accountId: 11010001,
    name: 'Account 11010001',
    nameAr: 'الحساب 11010001',
  ),
  11080002: TransactionTransferAccountInfo(
    accountId: 11080002,
    name: 'Account 11080002',
    nameAr: 'الحساب 11080002',
  ),
};

GeniusPdfConfig _transactionTransferDemoConfig({required bool isRtl}) =>
    geniusPdfConfig.copyWith(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
    );

TransactionTransferDocumentMeta _transactionTransferDemoMeta({
  required bool isRtl,
  required String title,
  required String titleAr,
}) => TransactionTransferDocumentMeta(
  title: title,
  titleAr: titleAr,
  issueDate: DateTime(2026, 9, 6),
  exportingUserName: isRtl ? 'أحمد الحكيمي' : 'Ahmed Al-Hakimi',
  exportingUserNumber: 'USR-0074',
);

/// Builds the example for [MultiTransactionTransferPdf].
MultiTransactionTransferPdf buildMultiTransactionTransferPdfDemo({
  required bool isRtl,
  TransactionTransferTemplateCustomization customization =
      const TransactionTransferTemplateCustomization(),
  bool includeCommission = true,
  bool showTotals = true,
  bool showQRCode = true,
  bool showNotes = true,
}) {
  return MultiTransactionTransferPdf(
    config: _transactionTransferDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    meta: _transactionTransferDemoMeta(
      isRtl: isRtl,
      title: 'Transaction Transfer Register',
      titleAr: 'سجل حركات التحويلات',
    ),
    rows: transactionTransferDemoRows,
    services: transactionTransferDemoServices,
    accountDirectory: transactionTransferDemoAccountDirectory,
    customization: customization,
    configuration: TransactionTransferReportConfiguration(
      periodStart: DateTime(2026, 8, 28),
      periodEnd: DateTime(2026, 9, 1),
      selectedCurrency: 'YER',
      includeCommission: includeCommission,
      showTotals: showTotals,
    ),
    reportId: 'TRF-REG-20260906-001',
    qrCodeUrl: 'https://example.com/reports/TRF-REG-20260906-001',
    showQRCode: showQRCode,
    showNotes: showNotes,
    notes:
        'Each grid row represents one accounting leg and names one affected account. The transaction reference remains serviceId + transactionId.',
    notesAr:
        'يمثل كل صف في الجدول طرفاً محاسبياً واحداً ويعرض حساباً واحداً فقط، مع بقاء مرجع العملية serviceId + transactionId.',
  );
}

/// Builds the account-scoped example for
/// [MultiTransactionTransferForAccountPdf].
MultiTransactionTransferForAccountPdf
buildMultiTransactionTransferForAccountPdfDemo({
  required bool isRtl,
  TransactionTransferTemplateCustomization customization =
      const TransactionTransferTemplateCustomization(),
  bool includeCommission = true,
  bool showTotals = true,
  bool showQRCode = true,
  bool showNotes = true,
  double openingBalance = 125000,
}) {
  final account = transactionTransferDemoAccountDirectory[2305]!;
  return MultiTransactionTransferForAccountPdf(
    config: _transactionTransferDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    meta: _transactionTransferDemoMeta(
      isRtl: isRtl,
      title: 'Transaction Transfers for Account 2305',
      titleAr: 'حركات التحويل للحساب 2305',
    ),
    rows: transactionTransferDemoRows,
    accountId: 2305,
    account: account,
    services: transactionTransferDemoServices,
    accountDirectory: transactionTransferDemoAccountDirectory,
    customization: customization,
    configuration: TransactionTransferReportConfiguration(
      periodStart: DateTime(2026, 8, 28),
      periodEnd: DateTime(2026, 9, 1),
      selectedCurrency: 'YER',
      includeCommission: includeCommission,
      showTotals: showTotals,
    ),
    openingBalances: <String, double>{'YER': openingBalance},
    reportId: 'TRF-ACC-2305-20260906',
    qrCodeUrl: 'https://example.com/reports/TRF-ACC-2305-20260906',
    showQRCode: showQRCode,
    showNotes: showNotes,
    notes:
        'This view filters the same source rows to account 2305, adds the caller-supplied opening balance row, and keeps commission legs visible. Counter-account labels remain number-based where names are unavailable.',
    notesAr:
        'يعرض هذا التقرير بيانات المصدر بعد تصفيتها للحساب 2305 مع صف رصيد افتتاحي يمرره المستهلك وإبقاء صفوف العمولة. تستخدم أرقام الحسابات عندما لا تتوفر الأسماء.',
  );
}
