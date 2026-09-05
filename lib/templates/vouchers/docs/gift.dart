/// Gift/Grant Voucher template (Service IDs: 20500–20501).
///
/// Generates vouchers for:
/// - **20500** Received Gift/Grant — items/assets received as gift or grant
/// - **20501** Given Gift — items/services given as gift to customer/partner
library;

import '../support.dart';

/// Generates a gift/grant voucher PDF page.
///
/// ```dart
/// final voucher = GiftVoucher(
///   config: config,
///   company: companyInfo,
///   data: VoucherData(
///     serviceId: VoucherServiceId.receivedGift,
///     voucherNumber: 'GF-2026-001',
///     voucherDate: DateTime.now(),
///     amount: 5000,
///     items: [
///       VoucherLineItem(lineNumber: 1, description: 'Office Equipment', quantity: 1, unitPrice: 5000, totalAmount: 5000),
///     ],
///   ),
///   giftData: VoucherGiftData(
///     direction: GiftDirection.received,
///     donorName: 'ABC Corporation',
///     occasion: 'Partnership Agreement',
///   ),
/// );
/// ```
class GiftVoucher extends GeniusPdfVoucherTemplate {
  GiftVoucher({
    required super.config,
    required super.company,
    required super.data,
    required this.giftData,
    super.style,
  });

  /// Gift-specific data.
  final VoucherGiftData giftData;

  @override
  void buildVoucherContent() {
    // Items table
    if (data.items.isNotEmpty) {
      _drawItemsTable();
    }

    // Total value
    _drawValueSummary();

    // Amount block
    drawAmountBlock();

    // Accounting treatment
    if (data.accountEntries.isNotEmpty) {
      drawAccountEntriesTable();
    }

    // Tax implications
    if (giftData.taxTreatment != null || giftData.taxTreatmentAr != null) {
      _drawTaxTreatment();
    }

    // Authorization
    if (giftData.authorizationReference != null) {
      _drawAuthorization();
    }

    // Combined Gift & Party Info (Moved to bottom)
    _drawCombinedInfo();

    // Gift details
    _drawGiftDetails();
  }

  void _drawCombinedInfo() {
    final items = <GeniusPdfLabeledValue>[];

    // Direction
    final directionText = giftData.direction.displayName(isRTL: isRTL);
    final directionLabel = isRTL ? 'اتجاه الهدية' : 'Gift Direction';
    items.add(_lv(directionLabel, directionLabel, directionText));

    // Party (Donor/Recipient)
    final isReceived = giftData.direction == GiftDirection.received;
    if (isReceived) {
      if (giftData.donorName != null || giftData.donorNameAr != null) {
        items.add(_lv(
            'اسم المانح',
            'Donor Name',
            isRTL
                ? (giftData.donorNameAr ?? giftData.donorName!)
                : giftData.donorName!));
      }
    } else {
      if (giftData.recipientName != null || giftData.recipientNameAr != null) {
        items.add(_lv(
            'اسم المستلم',
            'Recipient Name',
            isRTL
                ? (giftData.recipientNameAr ?? giftData.recipientName!)
                : giftData.recipientName!));
      }
    }

    if (items.isEmpty) return;

    addInfoSection(
      labelAr: 'معلومات الهدية',
      labelEn: 'Gift Information',
      items: items,
      columns: 2,
    );
  }

  void _drawGiftDetails() {
    final items = <GeniusPdfLabeledValue>[];

    if (giftData.occasion != null || giftData.occasionAr != null) {
      items.add(_lv(
          'المناسبة',
          'Occasion',
          isRTL
              ? (giftData.occasionAr ?? giftData.occasion!)
              : giftData.occasion!));
    }

    if (giftData.giftReason != null || giftData.giftReasonAr != null) {
      items.add(_lv(
          'سبب الهدية',
          'Gift Reason',
          isRTL
              ? (giftData.giftReasonAr ?? giftData.giftReason!)
              : giftData.giftReason!));
    }

    if (items.isEmpty) return;

    addInfoSection(
      labelAr: 'تفاصيل الهدية',
      labelEn: 'Gift Details',
      items: items,
      columns: items.length > 1 ? 2 : 1,
    );
  }

  void _drawItemsTable() {
    final hasCode = data.items.any((i) => i.itemCode != null);

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
          width: 60,
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
        width: 50,
        alignment: GeniusPdfTextAlign.center,
      ),
      GeniusPdfGridColumn.currency(
        id: 'value',
        title: 'Fair Value',
        titleAr: 'القيمة العادلة',
        width: 90,
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
          'value': item.totalAmount,
        }),
    ];

    drawItemsTable(
      columns: columns,
      rows: rows,
      labelAr: 'البنود',
      labelEn: 'Items',
    );
  }

  void _drawValueSummary() {
    final items = <GeniusPdfLabeledValue>[
      _lv('إجمالي القيمة العادلة', 'Total Fair Value',
          '${_fmtNum(data.amount)} ${data.currency}'),
    ];

    if (giftData.fairMarketValue != null &&
        giftData.fairMarketValue != data.amount) {
      items.add(_lv('القيمة السوقية المقدرة', 'Estimated Market Value',
          '${_fmtNum(giftData.fairMarketValue!)} ${data.currency}'));
    }

    addInfoSection(
      labelAr: 'ملخص القيمة',
      labelEn: 'Value Summary',
      items: items,
      columns: items.length,
    );
  }

  void _drawTaxTreatment() {
    final taxText = isRTL
        ? (giftData.taxTreatmentAr ?? giftData.taxTreatment ?? '')
        : (giftData.taxTreatment ?? '');

    final items = <GeniusPdfLabeledValue>[
      _lv('المعالجة الضريبية', 'Tax Treatment', taxText),
    ];

    addInfoSection(
      labelAr: 'المعاملة الضريبية',
      labelEn: 'Tax Implications',
      items: items,
      columns: 1,
    );
  }

  void _drawAuthorization() {
    final items = <GeniusPdfLabeledValue>[
      _lv('مرجع الاعتماد', 'Authorization Ref',
          giftData.authorizationReference!),
    ];

    addInfoSection(
      labelAr: 'الاعتماد',
      labelEn: 'Authorization',
      items: items,
      columns: 1,
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

  @override
  List<VoucherSignatory> defaultSignatories() {
    final isReceived = giftData.direction == GiftDirection.received;
    if (isReceived) {
      return [
        GiftSignatories.donor(),
        TradeSignatories.warehouseKeeper(),
        VoucherSignatory.accountant(),
        VoucherSignatory.manager(),
      ];
    } else {
      return [
        GiftSignatories.marketing(),
        TradeSignatories.warehouseKeeper(),
        VoucherSignatory.accountant(),
        GiftSignatories.recipient(),
      ];
    }
  }
}
