/// Sales Voucher template (Service IDs: 20200–20203).
///
/// Generates vouchers for:
/// - **20200** Cash Sale — immediate cash payment from customer
/// - **20201** Credit Sale — deferred payment terms
/// - **20202** Advance Sale — advance payment received before delivery
/// - **20203** Installment Sale — payment received in scheduled installments
library;

import '../support.dart';

/// Generates a sales voucher PDF page.
///
/// ```dart
/// final voucher = SalesVoucher(
///   config: config,
///   company: companyInfo,
///   data: VoucherData(
///     serviceId: VoucherServiceId.cashSale,
///     voucherNumber: 'SL-2026-001',
///     voucherDate: DateTime.now(),
///     amount: 8625,
///     party: VoucherParty(name: 'Tech Corp', nameAr: 'شركة التقنية'),
///     items: [
///       VoucherLineItem(lineNumber: 1, description: 'Laptop', quantity: 1, unitPrice: 7500, totalAmount: 7500),
///     ],
///   ),
///   tradeData: VoucherTradeData(orderNumber: 'SO-2026-078'),
/// );
/// ```
class SalesVoucher extends GeniusPdfVoucherTemplate {
  SalesVoucher({
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

    // Customer info
    drawPartyInfo(labelAr: 'معلومات العميل', labelEn: 'Customer Information');

    // SO reference + salesperson
    if (tradeData.orderNumber != null || tradeData.salesperson != null) {
      _drawOrderReference();
    }

    // Items table
    if (data.items.isNotEmpty) {
      _drawItemsTable();
    }

    // Summary block
    _drawSummary();

    // Payment terms
    _drawPaymentTerms();

    // Delivery info
    if (tradeData.deliveryMethod != null || tradeData.shippingAddress != null) {
      _drawDelivery();
    }
  }

  void _drawOrderReference() {
    final items = <GeniusPdfLabeledValue>[
      if (tradeData.orderNumber != null)
        _lv('رقم أمر البيع', 'SO Number', tradeData.orderNumber!),
      if (tradeData.orderDate != null)
        _lv('تاريخ الأمر', 'SO Date', _fmtDate(tradeData.orderDate!)),
      if (tradeData.salesperson != null)
        _lv(
            'مندوب المبيعات',
            'Salesperson',
            isRTL
                ? (tradeData.salespersonAr ?? tradeData.salesperson!)
                : tradeData.salesperson!),
    ];

    if (items.isEmpty) return;

    addInfoSection(
      labelAr: 'مرجع أمر البيع',
      labelEn: 'Sales Order Reference',
      items: items,
      columns: items.length.clamp(1, 3).toInt(),
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
      labelAr: 'بنود المبيعات',
      labelEn: 'Sales Items',
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
    if (sid == VoucherServiceId.cashSale) return;

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
        items.add(_lv('تاريخ التسليم المتوقع', 'Expected Delivery',
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

  void _drawDelivery() {
    final items = <GeniusPdfLabeledValue>[
      if (tradeData.deliveryMethod != null)
        _lv(
            'طريقة التسليم',
            'Delivery Method',
            isRTL
                ? (tradeData.deliveryMethodAr ?? tradeData.deliveryMethod!)
                : tradeData.deliveryMethod!),
      if (tradeData.shippingAddress != null)
        _lv(
            'عنوان الشحن',
            'Shipping Address',
            isRTL
                ? (tradeData.shippingAddressAr ?? tradeData.shippingAddress!)
                : tradeData.shippingAddress!),
      if (tradeData.deliveryDate != null)
        _lv('تاريخ التسليم', 'Delivery Date',
            _fmtDate(tradeData.deliveryDate!)),
    ];

    if (items.isEmpty) return;

    addInfoSection(
      labelAr: 'معلومات التسليم',
      labelEn: 'Delivery Information',
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
        TradeSignatories.salesDept(),
        TradeSignatories.warehouseKeeper(),
        VoucherSignatory.accountant(),
        TradeSignatories.customer(),
      ];
}

/// Modern Sales Voucher implementing the "Official" layout.
class ModernSalesVoucher extends ModernVoucherTemplate {
  ModernSalesVoucher({
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
    final columns = [
      const GeniusPdfGridColumn(
          id: 'no',
          title: 'رقم الصنف\nItem No',
          alignment: GeniusPdfTextAlign.center,
          width: 60),
      const GeniusPdfGridColumn(
          id: 'desc', title: 'اسم الصنف\nItem Name', flexFactor: 3),
      const GeniusPdfGridColumn(
          id: 'unit',
          title: 'الوحدة\nUnit',
          alignment: GeniusPdfTextAlign.center,
          width: 50),
      const GeniusPdfGridColumn(
          id: 'qty',
          title: 'الكمية\nQty',
          alignment: GeniusPdfTextAlign.center,
          width: 40),
      const GeniusPdfGridColumn(
          id: 'bonus',
          title: 'لـ.المجانية\nFree Qty',
          alignment: GeniusPdfTextAlign.center,
          width: 40),
      GeniusPdfGridColumn.currency(
          id: 'price', title: 'السعر\nPrice', width: 70),
      GeniusPdfGridColumn.currency(
          id: 'total', title: 'الإجمالي\nTotal', width: 80),
    ];

    final rows = data.items.map((item) {
      return GeniusPdfGridRow(cells: {
        'no': item.itemCode ?? '',
        'desc':
            isRTL ? (item.descriptionAr ?? item.description) : item.description,
        'unit': isRTL ? (item.unitAr ?? item.unit ?? '') : (item.unit ?? ''),
        'qty': item.quantity,
        'bonus':
            '', // Field not in standard model? Assuming empty custom field or calculated.
        'price': item.unitPrice,
        'total': item.totalAmount
      });
    }).toList();

    // Fill empty rows if needed to fill space?
    // For now just standard grid

    drawItemsTable(columns: columns, rows: rows, labelAr: '', labelEn: '');
  }
}
