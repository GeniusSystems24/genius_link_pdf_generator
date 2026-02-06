/// Purchase Voucher template (Service IDs: 20000–20003).
///
/// Generates vouchers for:
/// - **20000** Cash Purchase — immediate cash payment to supplier
/// - **20001** Credit Purchase — deferred payment terms
/// - **20002** Advance Purchase — advance payment before delivery
/// - **20003** Installment Purchase — payment in scheduled installments
library;

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Generates a purchase voucher PDF page.
///
/// ```dart
/// final voucher = PurchaseVoucher(
///   config: config,
///   company: companyInfo,
///   data: VoucherData(
///     serviceId: VoucherServiceId.cashPurchase,
///     voucherNumber: 'PU-2026-001',
///     voucherDate: DateTime.now(),
///     amount: 12500,
///     party: VoucherParty(name: 'ABC Supplies', nameAr: 'مؤسسة أبك للتوريدات'),
///     items: [
///       VoucherLineItem(lineNumber: 1, description: 'Office Paper A4', quantity: 50, unitPrice: 25, totalAmount: 1250),
///     ],
///   ),
///   tradeData: VoucherTradeData(orderNumber: 'PO-2026-045'),
/// );
/// ```
class PurchaseVoucher extends GeniusPdfVoucherTemplate {
  PurchaseVoucher({
    required GeniusPdfConfig config,
    required GeniusPdfCompanyInfo company,
    required VoucherData data,
    required this.tradeData,
    GeniusPdfVoucherStyle style = const GeniusPdfVoucherStyle(),
  }) : super(config: config, company: company, data: data, style: style);

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

    // PO reference
    if (tradeData.orderNumber != null) {
      _drawOrderReference();
    }

    // Items table
    if (data.items.isNotEmpty) {
      _drawItemsTable();
    }

    // Summary block
    _drawSummary();

    // Payment terms (varies by subtype)
    _drawPaymentTerms();

    // Warehouse info
    if (tradeData.warehouseName != null) {
      _drawWarehouse();
    }
  }

  void _drawOrderReference() {
    final items = <GeniusPdfLabeledValue>[
      _lv('رقم أمر الشراء', 'PO Number', tradeData.orderNumber!),
      if (tradeData.orderDate != null)
        _lv('تاريخ الأمر', 'PO Date', _fmtDate(tradeData.orderDate!)),
    ];

    addInfoSection(
      labelAr: 'مرجع أمر الشراء',
      labelEn: 'Purchase Order Reference',
      items: items,
      columns: items.length,
    );
  }

  void _drawItemsTable() {
    final hasCode = data.items.any((i) => i.itemCode != null);
    final hasUnit = data.items.any((i) => i.unit != null);
    final hasDiscount = data.items
        .any((i) => i.discountAmount != null || i.discountPercent != null);
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
        title: 'Qty',
        titleAr: 'الكمية',
        width: 40,
        alignment: GeniusPdfTextAlign.center,
      ),
      if (hasUnit)
        const GeniusPdfGridColumn(
          id: 'unit',
          title: 'Unit',
          titleAr: 'الوحدة',
          width: 45,
          alignment: GeniusPdfTextAlign.center,
        ),
      GeniusPdfGridColumn.currency(
        id: 'price',
        title: 'Unit Price',
        titleAr: 'سعر الوحدة',
        width: 70,
        currencySymbol: '',
      ),
      if (hasDiscount)
        GeniusPdfGridColumn.currency(
          id: 'disc',
          title: 'Discount',
          titleAr: 'الخصم',
          width: 55,
          currencySymbol: '',
        ),
      if (hasTax)
        GeniusPdfGridColumn.currency(
          id: 'tax',
          title: 'Tax',
          titleAr: 'الضريبة',
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
          if (hasUnit)
            'unit':
                isRTL ? (item.unitAr ?? item.unit ?? '') : (item.unit ?? ''),
          'price': item.unitPrice,
          if (hasDiscount) 'disc': item.discountAmount ?? 0,
          if (hasTax) 'tax': item.taxAmount ?? 0,
          'total': item.totalAmount,
        }),
    ];

    drawItemsTable(
      columns: columns,
      rows: rows,
      labelAr: 'بنود المشتريات',
      labelEn: 'Purchase Items',
    );
  }

  void _drawSummary() {
    if (tradeData.subtotal == null && tradeData.grandTotal == null) return;

    final items = <GeniusPdfLabeledValue>[
      if (tradeData.subtotal != null)
        _lv('المجموع الفرعي', 'Subtotal',
            '${_fmtNum(tradeData.subtotal!)} ${data.currency}'),
      if (tradeData.totalDiscount != null && tradeData.totalDiscount! > 0)
        _lv('إجمالي الخصم', 'Total Discount',
            '(${_fmtNum(tradeData.totalDiscount!)}) ${data.currency}'),
      if (tradeData.taxableAmount != null)
        _lv('المبلغ الخاضع للضريبة', 'Taxable Amount',
            '${_fmtNum(tradeData.taxableAmount!)} ${data.currency}'),
      if (tradeData.vatAmount != null)
        _lv(
            'ضريبة القيمة المضافة (${tradeData.vatRate}%)',
            'VAT (${tradeData.vatRate}%)',
            '${_fmtNum(tradeData.vatAmount!)} ${data.currency}'),
      if (tradeData.grandTotal != null)
        _lv('الإجمالي الكلي', 'Grand Total',
            '${_fmtNum(tradeData.grandTotal!)} ${data.currency}'),
    ];

    addInfoSection(
      labelAr: 'ملخص الفاتورة',
      labelEn: 'Invoice Summary',
      items: items,
      columns: 1,
    );
  }

  void _drawPaymentTerms() {
    final sid = data.serviceId;
    if (sid == VoucherServiceId.cashPurchase) return;

    final items = <GeniusPdfLabeledValue>[];

    if (tradeData.isCredit(sid)) {
      if (tradeData.dueDate != null) {
        items.add(
            _lv('تاريخ الاستحقاق', 'Due Date', _fmtDate(tradeData.dueDate!)));
      }
      if (tradeData.creditPeriodDays != null) {
        items.add(_lv('فترة الائتمان', 'Credit Period',
            '${tradeData.creditPeriodDays} ${isRTL ? "يوم" : "days"}'));
      }
    } else if (tradeData.isAdvance(sid)) {
      if (tradeData.advanceAmount != null) {
        items.add(_lv('المبلغ المقدم', 'Advance Amount',
            '${_fmtNum(tradeData.advanceAmount!)} ${data.currency}'));
      }
      if (tradeData.remainingBalance != null) {
        items.add(_lv('الرصيد المتبقي', 'Remaining Balance',
            '${_fmtNum(tradeData.remainingBalance!)} ${data.currency}'));
      }
      if (tradeData.deliveryDate != null) {
        items.add(_lv('تاريخ التسليم', 'Delivery Date',
            _fmtDate(tradeData.deliveryDate!)));
      }
    } else if (tradeData.isInstallment(sid)) {
      if (tradeData.numberOfInstallments != null) {
        items.add(_lv('عدد الأقساط', 'Installments',
            '${tradeData.numberOfInstallments}'));
      }
      if (tradeData.installmentAmount != null) {
        items.add(_lv('قيمة القسط', 'Installment Amount',
            '${_fmtNum(tradeData.installmentAmount!)} ${data.currency}'));
      }
    }

    if (items.isEmpty) return;

    addInfoSection(
      labelAr: 'شروط الدفع',
      labelEn: 'Payment Terms',
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
      if (tradeData.receivedBy != null)
        _lv(
            'استلم بواسطة',
            'Received By',
            isRTL
                ? (tradeData.receivedByAr ?? tradeData.receivedBy!)
                : tradeData.receivedBy!),
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
        VoucherSignatory.accountant(),
        VoucherSignatory.manager(),
      ];
}
