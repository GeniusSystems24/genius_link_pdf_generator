/// Purchase Return Voucher template (Service IDs: 20400–20403).
///
/// Generates vouchers for:
/// - **20400** Cash Purchase Return — return of cash-purchased goods
/// - **20401** Credit Purchase Return — return of credit-purchased goods
/// - **20402** Advance Purchase Return — cancellation of advance-paid order
/// - **20403** Installment Purchase Return — return of installment-purchased goods
library;

import '../voucher_support.dart';

/// Generates a purchase return voucher PDF page.
///
/// ```dart
/// final voucher = PurchaseReturnVoucher(
///   config: config,
///   company: companyInfo,
///   data: VoucherData(
///     serviceId: VoucherServiceId.cashPurchaseReturn,
///     voucherNumber: 'PR-2026-001',
///     voucherDate: DateTime.now(),
///     amount: 2500,
///     party: VoucherParty(name: 'ABC Supplies', nameAr: 'مؤسسة أبك للتوريدات'),
///     items: [
///       VoucherLineItem(lineNumber: 1, description: 'Defective Printer', quantity: 1, unitPrice: 2500, totalAmount: 2500),
///     ],
///   ),
///   tradeData: VoucherTradeData(
///     originalVoucherNumber: 'PU-2026-045',
///     returnReason: VoucherReturnReason.defective,
///   ),
/// );
/// ```
class PurchaseReturnVoucher extends GeniusPdfVoucherTemplate {
  PurchaseReturnVoucher({
    required super.config,
    required super.company,
    required super.data,
    required this.tradeData,
    super.style,
  });

  /// Trade-specific data.
  final VoucherTradeData tradeData;

  @override
  void buildVoucherContent() {
    // Account allocation
    if (data.accountEntries.isNotEmpty) {
      drawAccountEntriesTable();
    }

    // Amount block
    drawAmountBlock();

    // Supplier info
    drawPartyInfo(labelAr: 'معلومات المورد', labelEn: 'Supplier Information');

    // Original purchase reference
    _drawOriginalReference();

    // Return reason
    _drawReturnReason();

    // Returned items table
    if (data.items.isNotEmpty) {
      _drawItemsTable();
    }

    // Summary
    _drawSummary();

    // Refund / settlement
    _drawRefundSettlement();

    // Warehouse info
    if (tradeData.warehouseName != null) {
      _drawWarehouse();
    }
  }

  void _drawOriginalReference() {
    final items = <GeniusPdfLabeledValue>[
      if (tradeData.originalVoucherNumber != null)
        _lv('رقم سند الشراء الأصلي', 'Original PO No',
            tradeData.originalVoucherNumber!),
      if (tradeData.originalVoucherDate != null)
        _lv('تاريخ السند الأصلي', 'Original Date',
            _fmtDate(tradeData.originalVoucherDate!)),
    ];

    if (items.isEmpty) return;

    addInfoSection(
      labelAr: 'المرجع الأصلي',
      labelEn: 'Original Reference',
      items: items,
      columns: items.length,
    );
  }

  void _drawReturnReason() {
    final items = <GeniusPdfLabeledValue>[];

    if (tradeData.returnReason != null) {
      items.add(_lv('السبب', 'Reason',
          tradeData.returnReason!.displayName(isRTL: isRTL)));
    }

    if (tradeData.returnReasonDescription != null ||
        tradeData.returnReasonDescriptionAr != null) {
      final desc = isRTL
          ? (tradeData.returnReasonDescriptionAr ??
              tradeData.returnReasonDescription ??
              '')
          : (tradeData.returnReasonDescription ?? '');
      items.add(_lv('التفاصيل', 'Details', desc));
    }

    if (items.isEmpty) return;

    addInfoSection(
      labelAr: 'سبب الإرجاع',
      labelEn: 'Return Reason',
      items: items,
      columns: 1,
    );
  }

  void _drawItemsTable() {
    final hasCode = data.items.any((i) => i.itemCode != null);
    final hasTax = data.items.any((i) => i.taxAmount != null);

    final columns = <GeniusPdfGridColumn>[
      const GeniusPdfGridColumn(
        id: 'no',
        title: '#',
        titleAr: '#',
        width: 30,
        alignment: GeniusPdfTextAlign.center,
      ),
      if (hasCode)
        const GeniusPdfGridColumn(
          id: 'code',
          title: 'Code',
          titleAr: 'الرمز',
          width: 55,
          alignment: GeniusPdfTextAlign.center,
        ),
      const GeniusPdfGridColumn(
        id: 'desc',
        title: 'Description',
        titleAr: 'الوصف',
        flexFactor: 3,
      ),
      const GeniusPdfGridColumn(
        id: 'qty',
        title: 'Returned Qty',
        titleAr: 'الكمية المرتجعة',
        width: 60,
        alignment: GeniusPdfTextAlign.center,
      ),
      GeniusPdfGridColumn.currency(
        id: 'price',
        title: 'Unit Price',
        titleAr: 'سعر الوحدة',
        width: 70,
        currencySymbol: '',
      ),
      if (hasTax)
        GeniusPdfGridColumn.currency(
          id: 'tax',
          title: 'Tax Adj',
          titleAr: 'تعديل ضريبي',
          width: 55,
          currencySymbol: '',
        ),
      GeniusPdfGridColumn.currency(
        id: 'total',
        title: 'Total',
        titleAr: 'الإجمالي',
        width: 75,
        currencySymbol: '',
      ),
    ];

    final rows = <GeniusPdfGridRow>[
      for (final item in data.items)
        GeniusPdfGridRow(cells: {
          'no': item.lineNumber,
          if (hasCode) 'code': item.itemCode ?? '',
          'desc': isRTL
              ? (item.descriptionAr ?? item.description)
              : item.description,
          'qty': item.quantity,
          'price': item.unitPrice,
          if (hasTax) 'tax': item.taxAmount ?? 0,
          'total': item.totalAmount,
        }),
    ];

    drawItemsTable(
      columns: columns,
      rows: rows,
      labelAr: 'البنود المرتجعة',
      labelEn: 'Returned Items',
    );
  }

  void _drawSummary() {
    if (tradeData.subtotal == null && tradeData.grandTotal == null) return;

    final items = <GeniusPdfLabeledValue>[
      if (tradeData.subtotal != null)
        _lv('المجموع الفرعي', 'Subtotal',
            '${_fmtNum(tradeData.subtotal!)} ${data.currency}'),
      if (tradeData.vatAmount != null)
        _lv('تعديل ضريبي', 'Tax Adjustment',
            '${_fmtNum(tradeData.vatAmount!)} ${data.currency}'),
      if (tradeData.grandTotal != null)
        _lv('الإجمالي', 'Grand Total',
            '${_fmtNum(tradeData.grandTotal!)} ${data.currency}'),
    ];

    addInfoSection(
      labelAr: 'ملخص المرتجع',
      labelEn: 'Return Summary',
      items: items,
      columns: 1,
    );
  }

  void _drawRefundSettlement() {
    final sid = data.serviceId;
    final items = <GeniusPdfLabeledValue>[];

    if (sid == VoucherServiceId.cashPurchaseReturn) {
      if (tradeData.refundAmount != null) {
        items.add(_lv('مبلغ الاسترداد', 'Refund Amount',
            '${_fmtNum(tradeData.refundAmount!)} ${data.currency}'));
      }
      if (tradeData.refundMethod != null) {
        items.add(_lv(
            'طريقة الاسترداد',
            'Refund Method',
            isRTL
                ? (tradeData.refundMethodAr ?? tradeData.refundMethod!)
                : tradeData.refundMethod!));
      }
    } else if (tradeData.isCredit(sid)) {
      items.add(_lv('تخفيض الالتزام', 'Liability Reduction',
          '${_fmtNum(data.amount)} ${data.currency}'));
    } else if (tradeData.isAdvance(sid)) {
      if (tradeData.refundAmount != null) {
        items.add(_lv('استرداد المقدم', 'Advance Refund',
            '${_fmtNum(tradeData.refundAmount!)} ${data.currency}'));
      }
      if (tradeData.refundMethod != null) {
        items.add(_lv(
            'طريقة الاسترداد',
            'Refund Method',
            isRTL
                ? (tradeData.refundMethodAr ?? tradeData.refundMethod!)
                : tradeData.refundMethod!));
      }
    } else if (tradeData.isInstallment(sid)) {
      items.add(_lv('تعديل الأقساط', 'Installment Adjustment',
          '${_fmtNum(data.amount)} ${data.currency}'));
      if (tradeData.remainingBalance != null) {
        items.add(_lv('الرصيد المتبقي', 'Remaining Balance',
            '${_fmtNum(tradeData.remainingBalance!)} ${data.currency}'));
      }
    }

    if (items.isEmpty) return;

    addInfoSection(
      labelAr: 'التسوية / الاسترداد',
      labelEn: 'Refund / Settlement',
      items: items,
      columns: 2,
    );
  }

  void _drawWarehouse() {
    final items = <GeniusPdfLabeledValue>[
      _lv(
          'المستودع',
          'Warehouse',
          isRTL
              ? (tradeData.warehouseNameAr ?? tradeData.warehouseName!)
              : tradeData.warehouseName!),
      if (tradeData.inspectedBy != null)
        _lv(
            'فحص بواسطة',
            'Inspected By',
            isRTL
                ? (tradeData.inspectedByAr ?? tradeData.inspectedBy!)
                : tradeData.inspectedBy!),
    ];

    addInfoSection(
      labelAr: 'معلومات المستودع',
      labelEn: 'Warehouse Information',
      items: items,
      columns: 2,
    );
  }

  // ── Helpers ──

  GeniusPdfLabeledValue _lv(String labelAr, String labelEn, String value) {
    return GeniusPdfLabeledValue(
      config: config,
      label: labelEn,
      labelAr: labelAr,
      value: value,
    );
  }

  String _fmtNum(double n) {
    if (n == n.truncateToDouble()) {
      return n.truncate().toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    }
    return n
        .toStringAsFixed(2)
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},');
  }

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  List<VoucherSignatory> defaultSignatories() => [
        TradeSignatories.purchasing(),
        TradeSignatories.warehouseKeeper(),
        TradeSignatories.qualityInspector(),
        VoucherSignatory.accountant(),
        VoucherSignatory.manager(),
      ];
}

/// Modern Purchase Return Voucher implementing the "Official" layout.
class ModernPurchaseReturnVoucher extends ModernVoucherTemplate {
  ModernPurchaseReturnVoucher({
    required super.config,
    required super.company,
    required super.data,
    required this.tradeData,
    super.style,
  });

  @override
  final VoucherTradeData tradeData;

  @override
  void buildVoucherContent() {
    // 1. Original Reference
    _drawOriginalReference();

    // 2. Return Reason
    _drawReturnReason();

    // 3. Items Table
    final hasCode = data.items.any((i) => i.itemCode != null);
    final hasTax = data.items.any((i) => i.taxAmount != null);

    final columns = <GeniusPdfGridColumn>[
      const GeniusPdfGridColumn(
        id: 'no',
        title: 'رقم الصنف\nItem No',
        alignment: GeniusPdfTextAlign.center,
        width: 60,
      ),
      if (hasCode)
        const GeniusPdfGridColumn(
          id: 'code',
          title: 'الرمز\nCode',
          alignment: GeniusPdfTextAlign.center,
          width: 55,
        ),
      const GeniusPdfGridColumn(
        id: 'desc',
        title: 'اسم الصنف\nItem Name',
        flexFactor: 3,
      ),
      const GeniusPdfGridColumn(
        id: 'qty',
        title: 'الكمية المرتجعة\nReturned Qty',
        alignment: GeniusPdfTextAlign.center,
        width: 60,
      ),
      GeniusPdfGridColumn.currency(
        id: 'price',
        title: 'السعر\nPrice',
        width: 70,
        currencySymbol: '',
      ),
      if (hasTax)
        GeniusPdfGridColumn.currency(
          id: 'tax',
          title: 'تعديل ضريبي\nTax Adj',
          width: 55,
          currencySymbol: '',
        ),
      GeniusPdfGridColumn.currency(
        id: 'total',
        title: 'الإجمالي\nTotal',
        width: 80,
        currencySymbol: '',
      ),
    ];

    final rows = data.items.map((item) {
      return GeniusPdfGridRow(cells: {
        'no': item.lineNumber,
        if (hasCode) 'code': item.itemCode ?? '',
        'desc':
            isRTL ? (item.descriptionAr ?? item.description) : item.description,
        'qty': item.quantity,
        'price': item.unitPrice,
        if (hasTax) 'tax': item.taxAmount ?? 0,
        'total': item.totalAmount
      });
    }).toList();

    drawItemsTable(
      columns: columns,
      rows: rows,
      labelAr: '',
      labelEn: '',
    );

    // 4. Refund/Settlement
    _drawRefundSettlement();
  }

  void _drawOriginalReference() {
    final items = <GeniusPdfLabeledValue>[
      if (tradeData.originalVoucherNumber != null)
        _lv('رقم سند الشراء الأصلي', 'Original PO No',
            tradeData.originalVoucherNumber!),
      if (tradeData.originalVoucherDate != null)
        _lv('تاريخ السند الأصلي', 'Original Date',
            _fmtDate(tradeData.originalVoucherDate!)),
    ];

    if (items.isEmpty) return;

    addInfoSection(
      labelAr: 'المرجع الأصلي',
      labelEn: 'Original Reference',
      items: items,
      columns: items.length,
    );
  }

  void _drawReturnReason() {
    final items = <GeniusPdfLabeledValue>[];

    if (tradeData.returnReason != null) {
      items.add(_lv('السبب', 'Reason',
          tradeData.returnReason!.displayName(isRTL: isRTL)));
    }

    if (tradeData.returnReasonDescription != null ||
        tradeData.returnReasonDescriptionAr != null) {
      final desc = isRTL
          ? (tradeData.returnReasonDescriptionAr ??
              tradeData.returnReasonDescription ??
              '')
          : (tradeData.returnReasonDescription ?? '');
      items.add(_lv('التفاصيل', 'Details', desc));
    }

    if (items.isEmpty) return;

    addInfoSection(
      labelAr: 'سبب الإرجاع',
      labelEn: 'Return Reason',
      items: items,
      columns: 1,
    );
  }

  void _drawRefundSettlement() {
    final sid = data.serviceId;
    final items = <GeniusPdfLabeledValue>[];

    if (sid == VoucherServiceId.cashPurchaseReturn) {
      if (tradeData.refundAmount != null) {
        items.add(_lv('مبلغ الاسترداد', 'Refund Amount',
            '${_fmtNum(tradeData.refundAmount!)} ${data.currency}'));
      }
      if (tradeData.refundMethod != null) {
        items.add(_lv(
            'طريقة الاسترداد',
            'Refund Method',
            isRTL
                ? (tradeData.refundMethodAr ?? tradeData.refundMethod!)
                : tradeData.refundMethod!));
      }
    } else if (tradeData.isCredit(sid)) {
      items.add(_lv('تخفيض الالتزام', 'Liability Reduction',
          '${_fmtNum(data.amount)} ${data.currency}'));
    } else if (tradeData.isAdvance(sid)) {
      // ...
    } else if (tradeData.isInstallment(sid)) {
      items.add(_lv('تعديل الأقساط', 'Installment Adjustment',
          '${_fmtNum(data.amount)} ${data.currency}'));
    }

    if (items.isEmpty) return;

    addInfoSection(
      labelAr: 'التسوية / الاسترداد',
      labelEn: 'Refund / Settlement',
      items: items,
      columns: 2,
    );
  }

  GeniusPdfLabeledValue _lv(String labelAr, String labelEn, String value) {
    return GeniusPdfLabeledValue(
      config: config,
      label: labelEn,
      labelAr: labelAr,
      value: value,
    );
  }

  String _fmtNum(double n) {
    // Reuse basic number formatter
    if (n == n.truncateToDouble()) {
      return n.truncate().toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    }
    return n
        .toStringAsFixed(2)
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},');
  }

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
