/// Payment Voucher template (Service IDs: 00200–00203).
///
/// Generates vouchers for:
/// - **00200** Cash Payment — cash paid to supplier/employee
/// - **00201** Bank Transfer Payment — paid via bank transfer
/// - **00202** Check Payment — check issued for payment
/// - **00203** Electronic Payment — paid via electronic method
library;

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';
import 'package:flutter/material.dart' as m;

/// Generates a payment voucher PDF page using the Modern B5 template.
class PaymentVoucher extends ModernVoucherTemplate {
  PaymentVoucher({
    required super.config,
    required super.company,
    required super.data,
    this.deductions = const [],
    super.style,
  });

  /// Optional deductions (tax withholding, discounts, penalties).
  final List<PaymentDeduction> deductions;

  // We don't strictly need tradeData for PaymentVoucher unless we want to use shared mixins
  // But ModernVoucherTemplate doesn't enforce it anymore.
  @override
  VoucherTradeData get tradeData => const VoucherTradeData(); // Dummy if needed

  @override
  void buildVoucherContent() {
    // The "Official" table structure from the image:
    // -----------------------------------------------------------------------------------------
    // |  Amount  |  Currency  |                 Particulars                 |  Account No     |
    // |----------|------------|---------------------------------------------|-----------------|
    // |  500.00  |    SAR     |  Payment for invoice #123                   |    1200001      |
    // -----------------------------------------------------------------------------------------

    // We will build this Main Table.
    drawMainTable();

    // Deductions below if any
    if (deductions.isNotEmpty) {
      _drawDeductions();
    }
  }

  void drawMainTable() {
    // Columns
    // 1. Amount (Prominent)
    // 2. Currency (Small)
    // 3. Particulars (Description) - Flexible width
    // 4. Account No / Code
    // 5. Cost Center (Optional)

    final columns = [
      const GeniusPdfGridColumn(
          id: 'amount',
          title: 'المبلغ',
          titleAr: 'المبلغ',
          flexFactor: 2,
          alignment: GeniusPdfTextAlign.center),
      const GeniusPdfGridColumn(
          id: 'curr',
          title: 'العملة',
          titleAr: 'العملة',
          width: 50,
          alignment: GeniusPdfTextAlign.center),
      const GeniusPdfGridColumn(
          id: 'desc',
          title: 'البيان',
          titleAr: 'البيان',
          flexFactor: 5,
          alignment: GeniusPdfTextAlign.end // Arabic text
          ),
      const GeniusPdfGridColumn(
          id: 'acc',
          title: 'رقم الحساب',
          titleAr: 'رقم الحساب',
          flexFactor: 2,
          alignment: GeniusPdfTextAlign.center),
    ];

    // Rows

    // Combine account entries and main description
    // If we have account entries, list them. If not, use main voucher description.

    final rows = <GeniusPdfGridRow>[];

    if (data.accountEntries.isNotEmpty) {
      for (final entry in data.accountEntries) {
        rows.add(GeniusPdfGridRow(cells: {
          'amount': _fmtNum(
              entry.debitAmount > 0 ? entry.debitAmount : entry.creditAmount),
          'curr': data.currencyAr, // or Symbol
          'desc': isRTL
              ? (entry.accountNameAr ?? entry.accountName)
              : entry.accountName,
          // Append description to account name if exists?
          'acc': entry.accountCode,
        }));
      }
    } else {
      // Simple mode without explicit account entries
      rows.add(GeniusPdfGridRow(cells: {
        'amount': _fmtNum(data.amount),
        'curr': data.currency,
        'desc': isRTL
            ? (data.descriptionAr ?? data.description ?? '')
            : (data.description ?? ''),
        'acc': ''
      }));
    }

    // Fill up empty rows to make the table look substantial?
    // Image shows a fixed height box.
    // Let's ensure minimum height by adding empty rows if items are few.
    while (rows.length < 5) {
      rows.add(const GeniusPdfGridRow(
          cells: {'amount': '', 'curr': '', 'desc': '', 'acc': ''}));
    }

    final grid = GeniusPdfDataGrid(
        config: config,
        columns: columns,
        rows: rows,
        style: const GeniusPdfGridStyle(
            borderStyle: GeniusPdfBorderStyle.all(width: 0.5),
            showGridLines: true,
            headerStyle: GeniusPdfCellStyle(
                textStyle: GeniusPdfTextStyle(
                    fontWeight: m.FontWeight.bold, fontSize: 10),
                backgroundColor: m.Color(0xFFE0E0E0)), // Light grey header
            cellStyle: GeniusPdfCellStyle(
                padding: GeniusPdfCellPadding.symmetric(
                    vertical: 5, horizontal: 2))));

    addGrid(grid, spacing: 10);
  }

  void _drawDeductions() {
    double totalDeductions = 0;
    final rows = <GeniusPdfGridRow>[
      for (final ded in deductions)
        GeniusPdfGridRow(cells: {
          'name': isRTL ? (ded.nameAr ?? ded.name) : ded.name,
          'amount': _fmtNum(ded.amount),
        }),
    ];

    for (final ded in deductions) {
      totalDeductions += ded.amount;
    }

    // Modern template typically puts Net Amount in the summary area?
    // Or we can add it here.
    final netAmount = data.amount - totalDeductions;
    rows.add(GeniusPdfGridRow(
        cells: {
          'name': isRTL ? 'صافي المبلغ' : 'Net Amount',
          'amount': _fmtNum(netAmount),
        },
        style: const GeniusPdfCellStyle(
            textStyle: GeniusPdfTextStyle(fontWeight: m.FontWeight.bold),
            backgroundColor: m.Color(0xFFEEEEEE))));

    // Section Header
    final header = GeniusPdfInfoBox(
        config: config,
        items: [
          GeniusPdfLabeledValue(
              config: config,
              label: '',
              value: isRTL ? 'الاستقطاعات' : 'Deductions',
              valueStyle:
                  const GeniusPdfTextStyle(fontWeight: m.FontWeight.bold))
        ],
        style: const GeniusPdfInfoBoxStyle(
            borderStyle: GeniusPdfBorderStyle.none(),
            padding: GeniusPdfCellPadding.all(2)),
        columns: 1);
    addInfoBox(header, spacing: 2);

    final grid = GeniusPdfDataGrid(
      config: config,
      columns: [
        const GeniusPdfGridColumn(
            id: 'name',
            title: 'Deduction',
            titleAr: 'الاستقطاع',
            flexFactor: 3,
            alignment: GeniusPdfTextAlign.end),
        const GeniusPdfGridColumn(
            id: 'amount',
            title: 'Amount',
            titleAr: 'المبلغ',
            flexFactor: 1,
            alignment: GeniusPdfTextAlign.center),
      ],
      rows: rows,
      style: const GeniusPdfGridStyle(
          borderStyle: GeniusPdfBorderStyle.all(width: 0.5),
          cellStyle: GeniusPdfCellStyle(
              padding:
                  GeniusPdfCellPadding.symmetric(vertical: 4, horizontal: 2))),
    );

    addGrid(grid, spacing: 10);
  }

  // Helper to format numbers
  String _fmtNum(double n) {
    if (n == 0) return ''; // Don't show zero
    if (n == n.truncateToDouble()) {
      return n.truncate().toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    }
    return n
        .toStringAsFixed(2)
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},');
  }
}

/// A deduction applied to a payment.
class PaymentDeduction {
  const PaymentDeduction({
    required this.name,
    this.nameAr,
    required this.amount,
  });

  final String name;
  final String? nameAr;
  final double amount;
}
