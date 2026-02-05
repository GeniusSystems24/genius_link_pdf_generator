/// Tax Voucher template (Service IDs: 00300–00304).
///
/// Generates vouchers for:
/// - **00300** Income Tax — corporate income tax payment/accrual
/// - **00301** VAT — value added tax on sales/purchases
/// - **00302** Government Fees — licenses, permits, services
/// - **00303** Customs Duty — import/export duties
/// - **00304** Tax Settlement — audit/correction differences
library;

import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../components/components.dart';
import '../../../core/pdf_config.dart';
import '../models/voucher_enums.dart';
import '../models/voucher_models.dart';
import '../models/voucher_style.dart';
import 'voucher_base_template.dart';

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
    // Tax period info
    _drawTaxPeriod();

    // Tax authority info
    if (taxData.taxAuthorityName != null) {
      _drawTaxAuthority();
    }

    // Tax-specific calculation table
    _drawTaxCalculation();

    // Amount block
    drawAmountBlock();

    // Payment details
    drawPaymentDetails();

    // Account allocation
    if (data.accountEntries.isNotEmpty) {
      drawAccountEntriesTable();
    }
  }

  void _drawTaxPeriod() {
    final y = currentY;
    final infoPairs = <_TaxInfoPair>[
      _TaxInfoPair('نوع الضريبة', 'Tax Type', taxData.taxType.displayName(isRTL: isRTL)),
      if (taxData.taxPeriodStart != null)
        _TaxInfoPair('من تاريخ', 'From', _formatDate(taxData.taxPeriodStart!)),
      if (taxData.taxPeriodEnd != null)
        _TaxInfoPair('إلى تاريخ', 'To', _formatDate(taxData.taxPeriodEnd!)),
      if (taxData.filingDeadline != null)
        _TaxInfoPair('الموعد النهائي', 'Deadline', _formatDate(taxData.filingDeadline!)),
    ];

    _drawInfoRowLocal(y, infoPairs);
    resetY(y + 28 + style.sectionSpacing);
  }

  void _drawTaxAuthority() {
    final g = currentPage.graphics;
    final y = currentY;

    _drawLabel(y, 'الجهة الضريبية', 'Tax Authority');

    final authorityName = isRTL
        ? (taxData.taxAuthorityNameAr ?? taxData.taxAuthorityName ?? '')
        : (taxData.taxAuthorityName ?? '');

    g.drawString(
      authorityName,
      bodyFont,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(8, y + 16, contentWidth * 0.6, 12),
      format: PdfStringFormat(alignment: startAlign, textDirection: textDir),
    );

    if (taxData.taxAuthorityRef != null) {
      final refLabel = isRTL ? 'الرقم المرجعي' : 'Ref No';
      g.drawString(
        '$refLabel: ${taxData.taxAuthorityRef}',
        bodyFont,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(contentWidth * 0.6, y + 16, contentWidth * 0.4 - 4, 12),
        format: PdfStringFormat(alignment: endAlign),
      );
    }

    resetY(y + 30 + style.sectionSpacing);
  }

  void _drawTaxCalculation() {
    final y = currentY;
    _drawLabel(y, 'احتساب الضريبة', 'Tax Calculation');

    switch (taxData.taxType) {
      case VoucherTaxType.incomeTax:
        _drawIncomeTaxCalc(y + 18);
        break;
      case VoucherTaxType.vat:
        _drawVatCalc(y + 18);
        break;
      case VoucherTaxType.governmentFee:
        _drawFeeCalc(y + 18);
        break;
      case VoucherTaxType.customsDuty:
        _drawCustomsCalc(y + 18);
        break;
      case VoucherTaxType.taxSettlement:
        _drawSettlementCalc(y + 18);
        break;
    }
  }

  void _drawIncomeTaxCalc(double startY) {
    final rows = <_CalcRow>[
      if (taxData.taxableAmount != null)
        _CalcRow('الدخل الخاضع للضريبة', 'Taxable Income', taxData.taxableAmount!),
      if (taxData.taxRate != null)
        _CalcRow('نسبة الضريبة', 'Tax Rate', taxData.taxRate!, isPercent: true),
      if (taxData.taxAmount != null)
        _CalcRow('مبلغ الضريبة', 'Tax Amount', taxData.taxAmount!),
      if (taxData.previousPayments != null)
        _CalcRow('مدفوعات سابقة', 'Previous Payments', taxData.previousPayments!, isDeduction: true),
      if (taxData.balanceDue != null)
        _CalcRow('الرصيد المستحق', 'Balance Due', taxData.balanceDue!, isTotal: true),
    ];
    _drawCalcTable(startY, rows);
  }

  void _drawVatCalc(double startY) {
    final rows = <_CalcRow>[
      if (taxData.outputVat != null)
        _CalcRow('ضريبة المخرجات', 'Output VAT', taxData.outputVat!),
      if (taxData.inputVat != null)
        _CalcRow('ضريبة المدخلات', 'Input VAT', taxData.inputVat!, isDeduction: true),
      if (taxData.adjustments != null && taxData.adjustments != 0)
        _CalcRow('تسويات', 'Adjustments', taxData.adjustments!),
      if (taxData.netVat != null)
        _CalcRow('صافي الضريبة المستحقة', 'Net VAT Due', taxData.netVat!, isTotal: true),
    ];
    _drawCalcTable(startY, rows);
  }

  void _drawFeeCalc(double startY) {
    final rows = <_CalcRow>[
      _CalcRow('المبلغ المستحق', 'Amount Due', data.amount, isTotal: true),
    ];
    _drawCalcTable(startY, rows);
  }

  void _drawCustomsCalc(double startY) {
    final g = currentPage.graphics;
    var rowY = startY;

    // Goods info
    if (taxData.hsCode != null) {
      _drawCalcField(rowY, 'رمز التعرفة', 'HS Code', taxData.hsCode!);
      rowY += 14;
    }
    if (taxData.goodsDescription != null) {
      final desc = isRTL ? (taxData.goodsDescriptionAr ?? taxData.goodsDescription!) : taxData.goodsDescription!;
      _drawCalcField(rowY, 'وصف البضاعة', 'Goods Description', desc);
      rowY += 14;
    }

    g.drawLine(
      PdfPen(_pdfColor(style.borderColor), width: 0.3),
      Offset(0, rowY + 2),
      Offset(contentWidth, rowY + 2),
    );
    rowY += 6;

    final rows = <_CalcRow>[
      if (taxData.customsValue != null)
        _CalcRow('القيمة الجمركية', 'Customs Value', taxData.customsValue!),
      if (taxData.dutyRate != null)
        _CalcRow('نسبة الرسم', 'Duty Rate', taxData.dutyRate!, isPercent: true),
      _CalcRow('مبلغ الرسوم', 'Duty Amount', data.amount, isTotal: true),
    ];
    _drawCalcTable(rowY, rows);
  }

  void _drawSettlementCalc(double startY) {
    final rows = <_CalcRow>[
      if (taxData.originalAssessment != null)
        _CalcRow('التقييم الأصلي', 'Original Assessment', taxData.originalAssessment!),
      if (taxData.revisedAmount != null)
        _CalcRow('المبلغ المعدل', 'Revised Amount', taxData.revisedAmount!),
      if (taxData.penaltyAmount != null && taxData.penaltyAmount! > 0)
        _CalcRow('غرامات', 'Penalties', taxData.penaltyAmount!),
      if (taxData.interestAmount != null && taxData.interestAmount! > 0)
        _CalcRow('فوائد', 'Interest', taxData.interestAmount!),
      _CalcRow('المبلغ الإجمالي', 'Total Amount', data.amount, isTotal: true),
    ];
    _drawCalcTable(startY, rows);
  }

  void _drawCalcTable(double startY, List<_CalcRow> rows) {
    final g = currentPage.graphics;
    var rowY = startY;

    for (final row in rows) {
      final label = isRTL ? row.labelAr : row.labelEn;
      final font = row.isTotal ? boldBodyFont : bodyFont;
      final valueColor = row.isDeduction
          ? _pdfColor(style.debitColor)
          : row.isTotal
              ? _pdfColor(style.primaryColor)
              : PdfColor(0, 0, 0);

      if (row.isTotal) {
        g.drawLine(
          PdfPen(_pdfColor(style.borderColor), width: 0.5),
          Offset(contentWidth * 0.5, rowY - 1),
          Offset(contentWidth, rowY - 1),
        );
        rowY += 3;
      }

      g.drawString(
        label,
        font,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(8, rowY, contentWidth * 0.6, 13),
        format: PdfStringFormat(alignment: startAlign, textDirection: textDir),
      );

      String valueStr;
      if (row.isPercent) {
        valueStr = '${row.value.toStringAsFixed(1)}%';
      } else {
        valueStr = '${_formatNumber(row.value)} ${data.currency}';
        if (row.isDeduction) valueStr = '($valueStr)';
      }

      g.drawString(
        valueStr,
        font,
        brush: PdfSolidBrush(valueColor),
        bounds: Rect.fromLTWH(contentWidth * 0.6, rowY, contentWidth * 0.4 - 8, 13),
        format: PdfStringFormat(alignment: endAlign),
      );

      rowY += 16;
    }

    resetY(rowY + style.sectionSpacing);
  }

  void _drawCalcField(double y, String labelAr, String labelEn, String value) {
    final g = currentPage.graphics;
    final label = isRTL ? labelAr : labelEn;

    g.drawString(
      '$label: $value',
      bodyFont,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(8, y, contentWidth - 16, 12),
      format: PdfStringFormat(alignment: startAlign, textDirection: textDir),
    );
  }

  void _drawLabel(double y, String labelAr, String labelEn) {
    final g = currentPage.graphics;
    g.drawRectangle(
      brush: PdfSolidBrush(_pdfColor(style.primaryColor)),
      bounds: Rect.fromLTWH(0, y, 3, 13),
    );
    g.drawString(
      '$labelAr  |  $labelEn',
      boldBodyFont,
      brush: PdfSolidBrush(_pdfColor(style.primaryColor)),
      bounds: Rect.fromLTWH(8, y, contentWidth - 8, 13),
      format: PdfStringFormat(alignment: startAlign, textDirection: textDir),
    );
  }

  void _drawInfoRowLocal(double y, List<_TaxInfoPair> pairs) {
    final g = currentPage.graphics;
    final colWidth = contentWidth / pairs.length;

    g.drawRectangle(
      brush: PdfSolidBrush(_pdfColor(style.tableHeaderColor)),
      pen: PdfPen(_pdfColor(style.borderColor), width: 0.5),
      bounds: Rect.fromLTWH(0, y, contentWidth, 26),
    );

    for (var i = 0; i < pairs.length; i++) {
      final pair = pairs[i];
      final x = i * colWidth;

      final label = isRTL ? pair.labelAr : pair.labelEn;
      g.drawString(label, smallFont,
          brush: PdfSolidBrush(_pdfColor(style.accentColor)),
          bounds: Rect.fromLTWH(x + 4, y + 2, colWidth - 8, 10),
          format: PdfStringFormat(alignment: PdfTextAlignment.center));

      g.drawString(pair.value, boldBodyFont,
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(x + 4, y + 13, colWidth - 8, 12),
          format: PdfStringFormat(alignment: PdfTextAlignment.center));

      if (i < pairs.length - 1) {
        g.drawLine(
          PdfPen(_pdfColor(style.borderColor), width: 0.3),
          Offset(x + colWidth, y + 3),
          Offset(x + colWidth, y + 23),
        );
      }
    }
  }

  @override
  List<VoucherSignatory> _defaultSignatories() => [
        VoucherSignatory(role: 'Tax Accountant', roleAr: 'محاسب الضرائب'),
        VoucherSignatory.manager(),
        VoucherSignatory(role: 'Authorized Signatory', roleAr: 'المفوض بالتوقيع'),
      ];
}

class _TaxInfoPair {
  const _TaxInfoPair(this.labelAr, this.labelEn, this.value);
  final String labelAr;
  final String labelEn;
  final String value;
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
