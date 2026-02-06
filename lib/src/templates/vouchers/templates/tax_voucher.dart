/// Tax Voucher template (Service IDs: 00300–00304).
///
/// Generates vouchers for:
/// - **00300** Income Tax — corporate income tax payment/accrual
/// - **00301** VAT — value added tax on sales/purchases
/// - **00302** Government Fees — licenses, permits, services
/// - **00303** Customs Duty — import/export duties
/// - **00304** Tax Settlement — audit/correction differences
library;

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Generates a tax voucher PDF page.
///
/// ```dart
/// final voucher = TaxVoucher(
///   config: config,
///   company: companyInfo,
///   data: VoucherData(
///     serviceId: VoucherServiceId.vatVoucher,
///     voucherNumber: 'TV-2026-001',
///     voucherDate: DateTime.now(),
///     amount: 7500,
///   ),
///   taxData: VoucherTaxData(
///     taxType: VoucherTaxType.vat,
///     taxPeriodStart: DateTime(2026, 1, 1),
///     taxPeriodEnd: DateTime(2026, 3, 31),
///     outputVat: 22500,
///     inputVat: 15000,
///     netVat: 7500,
///   ),
/// );
/// ```
class TaxVoucher extends GeniusPdfVoucherTemplate {
  TaxVoucher({
    required GeniusPdfConfig config,
    required GeniusPdfCompanyInfo company,
    required VoucherData data,
    required this.taxData,
    GeniusPdfVoucherStyle style = const GeniusPdfVoucherStyle(),
  }) : super(config: config, company: company, data: data, style: style);

  final VoucherTaxData taxData;

  @override
  void buildVoucherContent() {
    // Account allocation
    drawAccountEntriesTable();

    // Amount block
    drawAmountBlock();

    // Tax-specific calculation table
    _drawTaxCalculation();

    // Tax period info
    _drawTaxPeriod();

    // Tax authority info
    if (taxData.taxAuthorityName != null) {
      _drawTaxAuthority();
    }

    // Payment details
    drawPaymentDetails();
  }

  void _drawTaxPeriod() {
    final items = <GeniusPdfLabeledValue>[
      GeniusPdfLabeledValue(
        config: config,
        label: 'Tax Type',
        labelAr: 'نوع الضريبة',
        value: taxData.taxType.displayName(isRTL: isRTL),
      ),
      if (taxData.taxPeriodStart != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'From',
          labelAr: 'من تاريخ',
          value: _formatDate(taxData.taxPeriodStart!),
        ),
      if (taxData.taxPeriodEnd != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'To',
          labelAr: 'إلى تاريخ',
          value: _formatDate(taxData.taxPeriodEnd!),
        ),
      if (taxData.filingDeadline != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Deadline',
          labelAr: 'الموعد النهائي',
          value: _formatDate(taxData.filingDeadline!),
        ),
    ];

    addInfoSection(
      labelAr: 'فترة الضريبة',
      labelEn: 'Tax Period',
      items: items,
      columns: 2,
    );
  }

  void _drawTaxAuthority() {
    final authorityName = isRTL
        ? (taxData.taxAuthorityNameAr ?? taxData.taxAuthorityName ?? '')
        : (taxData.taxAuthorityName ?? '');

    final items = <GeniusPdfLabeledValue>[
      GeniusPdfLabeledValue(
        config: config,
        label: 'Authority',
        labelAr: 'الجهة الضريبية',
        value: authorityName,
      ),
      if (taxData.taxAuthorityRef != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Ref No',
          labelAr: 'الرقم المرجعي',
          value: taxData.taxAuthorityRef!,
        ),
    ];

    addInfoSection(
      labelAr: 'الجهة الضريبية',
      labelEn: 'Tax Authority',
      items: items,
      columns: 2,
    );
  }

  void _drawTaxCalculation() {
    addSectionHeading('احتساب الضريبة', 'Tax Calculation');
    addSpace(4);

    switch (taxData.taxType) {
      case VoucherTaxType.incomeTax:
        _drawIncomeTaxCalc();
        break;
      case VoucherTaxType.vat:
        _drawVatCalc();
        break;
      case VoucherTaxType.governmentFee:
        _drawFeeCalc();
        break;
      case VoucherTaxType.customsDuty:
        _drawCustomsCalc();
        break;
      case VoucherTaxType.taxSettlement:
        _drawSettlementCalc();
        break;
    }
  }

  void _drawIncomeTaxCalc() {
    final rows = <_CalcRow>[
      if (taxData.taxableAmount != null)
        _CalcRow(
            'الدخل الخاضع للضريبة', 'Taxable Income', taxData.taxableAmount!),
      if (taxData.taxRate != null)
        _CalcRow('نسبة الضريبة', 'Tax Rate', taxData.taxRate!, isPercent: true),
      if (taxData.taxAmount != null)
        _CalcRow('مبلغ الضريبة', 'Tax Amount', taxData.taxAmount!),
      if (taxData.previousPayments != null)
        _CalcRow(
            'مدفوعات سابقة', 'Previous Payments', taxData.previousPayments!,
            isDeduction: true),
      if (taxData.balanceDue != null)
        _CalcRow('الرصيد المستحق', 'Balance Due', taxData.balanceDue!,
            isTotal: true),
    ];
    _drawCalcTable(rows);
  }

  void _drawVatCalc() {
    final rows = <_CalcRow>[
      if (taxData.outputVat != null)
        _CalcRow('ضريبة المخرجات', 'Output VAT', taxData.outputVat!),
      if (taxData.inputVat != null)
        _CalcRow('ضريبة المدخلات', 'Input VAT', taxData.inputVat!,
            isDeduction: true),
      if (taxData.adjustments != null && taxData.adjustments != 0)
        _CalcRow('تسويات', 'Adjustments', taxData.adjustments!),
      if (taxData.netVat != null)
        _CalcRow('صافي الضريبة المستحقة', 'Net VAT Due', taxData.netVat!,
            isTotal: true),
    ];
    _drawCalcTable(rows);
  }

  void _drawFeeCalc() {
    final rows = <_CalcRow>[
      _CalcRow('المبلغ المستحق', 'Amount Due', data.amount, isTotal: true),
    ];
    _drawCalcTable(rows);
  }

  void _drawCustomsCalc() {
    final items = <GeniusPdfLabeledValue>[];
    if (taxData.hsCode != null) {
      items.add(GeniusPdfLabeledValue(
        config: config,
        label: 'HS Code',
        labelAr: 'رمز التعرفة',
        value: taxData.hsCode!,
      ));
    }
    if (taxData.goodsDescription != null) {
      final desc = isRTL
          ? (taxData.goodsDescriptionAr ?? taxData.goodsDescription!)
          : taxData.goodsDescription!;
      items.add(GeniusPdfLabeledValue(
        config: config,
        label: 'Goods Description',
        labelAr: 'وصف البضاعة',
        value: desc,
      ));
    }

    if (items.isNotEmpty) {
      addInfoSection(
        labelAr: 'بيانات البضاعة',
        labelEn: 'Goods Info',
        items: items,
        columns: 1,
      );
    }

    final rows = <_CalcRow>[
      if (taxData.customsValue != null)
        _CalcRow('القيمة الجمركية', 'Customs Value', taxData.customsValue!),
      if (taxData.dutyRate != null)
        _CalcRow('نسبة الرسم', 'Duty Rate', taxData.dutyRate!, isPercent: true),
      _CalcRow('مبلغ الرسوم', 'Duty Amount', data.amount, isTotal: true),
    ];
    _drawCalcTable(rows);
  }

  void _drawSettlementCalc() {
    final rows = <_CalcRow>[
      if (taxData.originalAssessment != null)
        _CalcRow('التقييم الأصلي', 'Original Assessment',
            taxData.originalAssessment!),
      if (taxData.revisedAmount != null)
        _CalcRow('المبلغ المعدل', 'Revised Amount', taxData.revisedAmount!),
      if (taxData.penaltyAmount != null && taxData.penaltyAmount! > 0)
        _CalcRow('غرامات', 'Penalties', taxData.penaltyAmount!),
      if (taxData.interestAmount != null && taxData.interestAmount! > 0)
        _CalcRow('فوائد', 'Interest', taxData.interestAmount!),
      _CalcRow('المبلغ الإجمالي', 'Total Amount', data.amount, isTotal: true),
    ];
    _drawCalcTable(rows);
  }

  void _drawCalcTable(List<_CalcRow> rows) {
    if (rows.isEmpty) {
      addSpace(style.sectionSpacing);
      return;
    }

    final gridRows = <GeniusPdfGridRow>[];
    for (final row in rows) {
      final label = isRTL ? row.labelAr : row.labelEn;
      String valueStr;
      if (row.isPercent) {
        valueStr = '${row.value.toStringAsFixed(1)}%';
      } else {
        valueStr = '${_formatNumber(row.value)} ${data.currency}';
        if (row.isDeduction) valueStr = '($valueStr)';
      }

      if (row.isTotal) {
        gridRows.add(GeniusPdfGridRow.total({
          'label': label,
          'value': valueStr,
        }));
      } else {
        gridRows.add(GeniusPdfGridRow(cells: {
          'label': label,
          'value': valueStr,
        }));
      }
    }

    final grid = GeniusPdfDataGrid(
      config: config,
      columns: const [
        GeniusPdfGridColumn(
          id: 'label',
          title: 'Item',
          titleAr: 'البند',
          flexFactor: 3,
        ),
        GeniusPdfGridColumn(
          id: 'value',
          title: 'Amount',
          titleAr: 'المبلغ',
          width: 120,
          alignment: GeniusPdfTextAlign.end,
        ),
      ],
      rows: gridRows,
      style: GeniusPdfGridStyle.classic().copyWith(
        showHeader: false,
        alternateRowColors: false,
      ),
    );

    final result = addGrid(grid, spacing: 0);
    if (result != null) {
      updateFromLayoutResult(result, spacing: style.sectionSpacing);
    } else {
      addSpace(style.sectionSpacing);
    }
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _formatNumber(double n) {
    if (n == n.truncateToDouble()) {
      return n.truncate().toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    }
    return n
        .toStringAsFixed(2)
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},');
  }

  @override
  List<VoucherSignatory> defaultSignatories() => [
        VoucherSignatory(role: 'Tax Accountant', roleAr: 'محاسب الضرائب'),
        VoucherSignatory.manager(),
        VoucherSignatory(
            role: 'Authorized Signatory', roleAr: 'المفوض بالتوقيع'),
      ];
}

class _CalcRow {
  const _CalcRow(this.labelAr, this.labelEn, this.value,
      {this.isTotal = false, this.isDeduction = false, this.isPercent = false});
  final String labelAr;
  final String labelEn;
  final double value;
  final bool isTotal;
  final bool isDeduction;
  final bool isPercent;
}
