import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'package:genius_pdf_example/app/theme/app_theme.dart';
import 'package:genius_pdf_example/features/showcase/models/documents/advanced_layout_demo_document.dart';
import 'package:genius_pdf_example/features/showcase/models/documents/multi_grid_summary_demo_document.dart';
import 'package:genius_pdf_example/features/showcase/models/documents/position_tracking_demo_document.dart';
import 'package:genius_pdf_example/features/showcase/models/documents/qr_attachments_demo_document.dart';
import 'package:genius_pdf_example/shared/data/sample_data.dart';

final class JobFeatureCatalog {
  JobFeatureCatalog({
    required GeniusPdfConfig config,
    required PdfFont font,
    required Uint8List fontBytes,
  })  : _config = config,
        _fontBytes = fontBytes;

  final GeniusPdfConfig _config;

  final Uint8List _fontBytes;

  List<JobFeatureCategory> build() {
    final categories = <JobFeatureCategory>[];

    categories.addAll([
      JobFeatureCategory(
        name: 'Components',
        icon: Icons.widgets_rounded,
        gradient: AppColors.primaryGradient,
        features: [
          JobFeature(
            name: 'DataGrid',
            description: 'Tables with RTL support',
            builder: _buildDataGridTest,
          ),
          JobFeature(
            name: 'RichText',
            description: 'Styled text with colors',
            builder: _buildRichTextTest,
          ),
          JobFeature(
            name: 'InfoBox',
            description: 'Information boxes',
            builder: _buildInfoBoxTest,
          ),
          JobFeature(
            name: 'ReportHeader',
            description: 'Professional headers',
            builder: _buildReportHeaderTest,
          ),
          JobFeature(
            name: 'SummarySection',
            description: 'Totals & calculations',
            builder: _buildSummarySectionTest,
          ),
        ],
      ),
      JobFeatureCategory(
        name: 'Templates',
        icon: Icons.description_rounded,
        gradient: AppColors.purpleGradient,
        features: [
          JobFeature(
            name: 'TaxInvoice',
            description: 'ZATCA invoice template',
            builder: _buildTaxInvoiceTest,
          ),
          JobFeature(
            name: 'TrialBalance',
            description: 'Trial balance report',
            builder: _buildTrialBalanceTest,
          ),
          JobFeature(
            name: 'CustomerStatement',
            description: 'Account statement',
            builder: _buildCustomerStatementTest,
          ),
          JobFeature(
            name: 'InventoryReport',
            description: 'Inventory valuation',
            builder: _buildInventoryReportTest,
          ),
        ],
      ),
      JobFeatureCategory(
        name: 'Financial',
        icon: Icons.account_balance_wallet_rounded,
        gradient: AppColors.orangeGradient,
        features: [
          JobFeature(
            name: 'BalanceSheet',
            description: 'Balance sheet report',
            builder: _buildBalanceSheetTest,
          ),
          JobFeature(
            name: 'IncomeStatement',
            description: 'P&L statement',
            builder: _buildIncomeStatementTest,
          ),
          JobFeature(
            name: 'CashFlow',
            description: 'Cash flow statement',
            builder: _buildCashFlowTest,
          ),
          JobFeature(
            name: 'BudgetReport',
            description: 'Budget vs actual',
            builder: _buildBudgetReportTest,
          ),
        ],
      ),
      JobFeatureCategory(
        name: 'Sales & HR',
        icon: Icons.business_center_rounded,
        gradient: AppColors.cyanGradient,
        features: [
          JobFeature(
            name: 'Quotation',
            description: 'Price quotation',
            builder: _buildQuotationTest,
          ),
          JobFeature(
            name: 'PurchaseOrder',
            description: 'Purchase order',
            builder: _buildPurchaseOrderTest,
          ),
          JobFeature(
            name: 'DeliveryNote',
            description: 'Delivery note',
            builder: _buildDeliveryNoteTest,
          ),
          JobFeature(
            name: 'Payslip',
            description: 'Employee payslip',
            builder: _buildPayslipTest,
          ),
        ],
      ),
      JobFeatureCategory(
        name: 'Security',
        icon: Icons.security_rounded,
        gradient: AppColors.errorGradient,
        features: [
          JobFeature(
            name: 'Watermark',
            description: 'Text watermarks',
            builder: _buildWatermarkTest,
          ),
          JobFeature(
            name: 'TiledWatermark',
            description: 'Tiled pattern watermark',
            builder: _buildTiledWatermarkTest,
          ),
          JobFeature(
            name: 'DigitalSignature',
            description: 'Signature appearance',
            builder: _buildDigitalSignatureTest,
          ),
        ],
      ),
    ]);
    categories.addAll([
      JobFeatureCategory(
        name: 'Vouchers',
        icon: Icons.receipt_rounded,
        gradient: AppColors.successGradient,
        features: [
          // JobFeature(
          //   name: 'Service Vouchers',
          //   description: 'Accounting & receipts',
          //   builder: _buildServiceVouchersTest,
          // ),
          // JobFeature(
          //   name: 'Banking Vouchers',
          //   description: 'Deposit, withdrawal, transfer',
          //   builder: _buildBankingVouchersTest,
          // ),
          // JobFeature(
          //   name: 'Remittance Vouchers',
          //   description: 'Domestic & international',
          //   builder: _buildRemittanceVouchersTest,
          // ),
        ],
      ),
      JobFeatureCategory(
        name: 'Advanced Features',
        icon: Icons.auto_awesome_rounded,
        gradient: AppColors.pinkGradient,
        features: [
          JobFeature(
            name: 'Advanced Layout',
            description: 'Columns & headers',
            builder: _buildAdvancedLayoutTest,
          ),
          JobFeature(
            name: 'Position Tracking',
            description: 'Precise layout control',
            builder: _buildPositionTrackingTest,
          ),
          // JobFeature(
          //   name: 'Smart Space',
          //   description: 'Auto page breaks',
          //   builder: _buildSmartSpaceTest,
          // ),
          // JobFeature(
          //   name: 'Report Composer',
          //   description: 'Fluent API demo',
          //   builder: _buildReportComposerTest,
          // ),
        ],
      ),
    ]);
    // Add new component features to existing Components category if possible, or just append helpers
    // Since we can't easily modify the existing list in-place with this tool, I'll add a separate category for "More Components"
    categories.add(
      JobFeatureCategory(
        name: 'More Components',
        icon: Icons.extension_rounded,
        gradient: AppColors.infoGradient,
        features: [
          JobFeature(
            name: 'Multi-Grid',
            description: 'Multiple grids & summaries',
            builder: _buildMultiGridSummaryTest,
          ),
          JobFeature(
            name: 'QR & Attachments',
            description: 'Barcodes & images',
            builder: _buildQRAttachmentsTest,
          ),
        ],
      ),
    );

    return List.unmodifiable(categories);
  }

  // === Builder Methods ===

  GeniusPdfDocumentBuilder? _buildDataGridTest() {
    return _ComponentTestBuilder(
      config: _config,
      testName: 'DataGrid Test',
      buildContent: (builder) {
        final grid = GeniusPdfDataGrid(
          config: _config,
          columns: [
            GeniusPdfGridColumn(
                id: 'code', title: 'Code', titleAr: 'الرمز', width: 60),
            GeniusPdfGridColumn(
                id: 'name', title: 'Name', titleAr: 'الاسم', flexFactor: 2),
            GeniusPdfGridColumn.currency(
                id: 'amount', title: 'Amount', titleAr: 'المبلغ'),
          ],
          rows: [
            GeniusPdfGridRow(cells: {
              'code': 'P001',
              'name': 'Product 1',
              'amount': 1500.00
            }),
            GeniusPdfGridRow(cells: {
              'code': 'P002',
              'name': 'Product 2',
              'amount': 2500.00
            }),
            GeniusPdfGridRow.total(
                {'code': '', 'name': 'Total', 'amount': 4000.00}),
          ],
          style: GeniusPdfGridStyle.classic(),
        );
        grid.drawAt(
            page: builder.currentPage,
            x: 0,
            y: builder.currentY,
            width: builder.pageWidth);
      },
    );
  }

  GeniusPdfDocumentBuilder? _buildRichTextTest() {
    final localConfig = GeniusPdfConfig(baseFontBytes: _fontBytes);
    return _ComponentTestBuilder(
      config: localConfig,
      testName: 'RichText Test',
      buildContent: (builder) {
        final w = builder.pageWidth;
        var y = builder.currentY;

        // 1. Builder with heading, badge, currency, strikethrough
        final heading = GeniusPdfRichTextBuilder(
          config: localConfig,
        )
            .heading('Invoice Summary')
            .space()
            .badge('PAID', backgroundColor: const Color(0xFF4CAF50))
            .newLine()
            .label('Invoice No')
            .separator(': ')
            .bold('#INV-2024-001', color: const Color(0xFF1565C0))
            .newLine()
            .text('Total: ')
            .currency('34,615.00', symbol: 'SAR')
            .newLine()
            .text('Previous: ')
            .strikethrough('28,500.00')
            .space()
            .positive('34,615.00')
            .superscript('*')
            .build();
        heading.draw(
          page: builder.currentPage,
          bounds: Rect.fromLTWH(0, y, w, 100),
        );
        y += 100;

        // 2. Bullet list
        final bulletList = GeniusPdfBulletList(
          items: [
            GeniusPdfBulletItem.simple('Consulting services'),
            GeniusPdfBulletItem.simple('Software development'),
            GeniusPdfBulletItem(text: 'Maintenance', subItems: [
              GeniusPdfBulletItem.simple('Monthly support'),
            ]),
          ],
          config: localConfig,
          style: GeniusPdfBulletStyle.disc,
        );
        bulletList.draw(
          page: builder.currentPage,
          bounds: Rect.fromLTWH(0, y, w, 80),
        );
        y += 80;

        // 3. Markdown parsed text
        final mdSpans = GeniusPdfSimpleMarkdownParser.parse(
          'This is **bold** and *italic* with `code` and ~~deleted~~',
        );
        final mdRichText = GeniusPdfRichText(
          spans: mdSpans,
          config: localConfig,
        );
        mdRichText.draw(
          page: builder.currentPage,
          bounds: Rect.fromLTWH(0, y, w, 25),
        );
      },
    );
  }

  GeniusPdfDocumentBuilder? _buildInfoBoxTest() {
    final localConfig = GeniusPdfConfig(baseFontBytes: _fontBytes);
    return _ComponentTestBuilder(
      config: localConfig,
      testName: 'InfoBox Test',
      buildContent: (builder) {
        final box = GeniusPdfInfoBox(
          config: localConfig,
          title: 'Customer Details',
          titleAr: 'تفاصيل العميل',
          items: [
            GeniusPdfLabeledValue(
                config: localConfig,
                label: 'Name',
                labelAr: 'الاسم',
                value: 'Ahmed Mohammed'),
            GeniusPdfLabeledValue(
                config: localConfig,
                label: 'Phone',
                labelAr: 'الهاتف',
                value: '+966 12 345 6789'),
          ],
          style: const GeniusPdfInfoBoxStyle.headerContent(),
        );
        box.draw(
          page: builder.currentPage,
          bounds:
              Rect.fromLTWH(0, builder.currentY, builder.pageWidth / 2, 100),
        );
      },
    );
  }

  GeniusPdfDocumentBuilder? _buildReportHeaderTest() {
    return _ComponentTestBuilder(
      config: GeniusPdfConfig(baseFontBytes: _fontBytes),
      testName: 'ReportHeader Test',
      buildContent: (builder) {
        final header = GeniusPdfReportHeader(
          config: _config,
          title: 'Sales Report',
          titleAr: 'تقرير المبيعات',
          subtitle: 'January 2025',
          subtitleAr: 'يناير 2025',
          company: GeniusPdfCompanyInfo(
            name: 'Test Company',
            nameAr: 'شركة تجريبية',
            vatNumber: '300012345678903',
          ),
          printDate: DateTime.now(),
          style: GeniusPdfReportHeaderStyle.modern(),
        );
        header.draw(
          page: builder.currentPage,
          bounds: Rect.fromLTWH(0, 0, builder.pageWidth, 120),
        );
      },
    );
  }

  GeniusPdfDocumentBuilder? _buildSummarySectionTest() {
    return _ComponentTestBuilder(
      config: GeniusPdfConfig(baseFontBytes: _fontBytes),
      testName: 'SummarySection Test',
      buildContent: (builder) {
        final summary = GeniusPdfSummarySection(
          config: builder.config,
          items: [
            GeniusPdfSummaryItem(
                label: 'Subtotal',
                labelAr: 'المجموع الفرعي',
                value: '10,000.00 SAR'),
            GeniusPdfSummaryItem(
                label: 'VAT (15%)',
                labelAr: 'ضريبة (15%)',
                value: '1,500.00 SAR'),
            GeniusPdfSummaryItem.total(
                label: 'Grand Total',
                labelAr: 'الإجمالي',
                value: '11,500.00 SAR'),
          ],
          style: GeniusPdfSummaryStyle.bordered(),
          alignment: GeniusPdfSummaryAlignment.right,
          width: builder.pageWidth * 0.45,
        );
        summary.draw(
          page: builder.currentPage,
          bounds: Rect.fromLTWH(0, builder.currentY, builder.pageWidth, 150),
        );
      },
    );
  }

  GeniusPdfDocumentBuilder? _buildTaxInvoiceTest() {
    return TaxInvoiceTemplate(
      config: GeniusPdfConfig(
          baseFontBytes: _fontBytes, textDirection: TextDirection.rtl),
      company: SampleData.companyInfo,
      customer: SampleData.invoiceCustomer,
      invoice: SampleData.invoiceData,
      showQRCode: false,
    );
  }

  GeniusPdfDocumentBuilder? _buildTrialBalanceTest() {
    return TrialBalanceTemplate(
      config: GeniusPdfConfig(
          baseFontBytes: _fontBytes, textDirection: TextDirection.rtl),
      company: SampleData.companyInfo,
      data: SampleData.trialBalanceData,
    );
  }

  GeniusPdfDocumentBuilder? _buildCustomerStatementTest() {
    return CustomerStatementTemplate(
      config: GeniusPdfConfig(
          baseFontBytes: _fontBytes, textDirection: TextDirection.rtl),
      company: SampleData.companyInfo,
      customer: SampleData.statementCustomer,
      data: SampleData.statementData,
    );
  }

  GeniusPdfDocumentBuilder? _buildInventoryReportTest() {
    return InventoryReportTemplate(
      config: GeniusPdfConfig(
          baseFontBytes: _fontBytes, textDirection: TextDirection.rtl),
      company: SampleData.companyInfo,
      data: SampleData.inventoryData,
    );
  }

  GeniusPdfDocumentBuilder? _buildBalanceSheetTest() {
    final data = BalanceSheetData(
      reportDate: DateTime.now(),
      assets: BalanceSheetSection(
        title: 'Assets',
        titleAr: 'الأصول',
        items: [
          const BalanceSheetItem(
              accountCode: '1100',
              accountName: 'Cash',
              accountNameAr: 'النقد',
              amount: 150000),
        ],
      ),
      liabilities: BalanceSheetSection(
        title: 'Liabilities',
        titleAr: 'الالتزامات',
        items: [
          const BalanceSheetItem(
              accountCode: '2100',
              accountName: 'Payables',
              accountNameAr: 'الدائنون',
              amount: 50000),
        ],
      ),
      equity: BalanceSheetSection(
        title: 'Equity',
        titleAr: 'حقوق الملكية',
        items: [
          const BalanceSheetItem(
              accountCode: '3100',
              accountName: 'Capital',
              accountNameAr: 'رأس المال',
              amount: 100000),
        ],
      ),
    );
    return BalanceSheetTemplate(
      config: GeniusPdfConfig(
          baseFontBytes: _fontBytes, textDirection: TextDirection.rtl),
      company: SampleData.companyInfo,
      data: data,
    );
  }

  GeniusPdfDocumentBuilder? _buildIncomeStatementTest() {
    final data = IncomeStatementData(
      periodStart: DateTime(2026, 1, 1),
      periodEnd: DateTime(2026, 1, 31),
      revenue: IncomeStatementSection(
        title: 'Revenue',
        titleAr: 'الإيرادات',
        items: [
          const IncomeStatementItem(
              accountCode: '4100',
              accountName: 'Sales',
              accountNameAr: 'المبيعات',
              amount: 500000)
        ],
      ),
      costOfSales: IncomeStatementSection(
        title: 'Cost of Sales',
        titleAr: 'تكلفة المبيعات',
        items: [
          const IncomeStatementItem(
              accountCode: '5100',
              accountName: 'COGS',
              accountNameAr: 'تكلفة البضاعة',
              amount: 280000)
        ],
      ),
      operatingExpenses: IncomeStatementSection(
        title: 'Operating Expenses',
        titleAr: 'المصروفات التشغيلية',
        items: [
          const IncomeStatementItem(
              accountCode: '6100',
              accountName: 'Salaries',
              accountNameAr: 'الرواتب',
              amount: 120000)
        ],
      ),
      taxExpense: 15000,
    );
    return IncomeStatementTemplate(
      config: GeniusPdfConfig(
          baseFontBytes: _fontBytes, textDirection: TextDirection.rtl),
      company: SampleData.companyInfo,
      data: data,
    );
  }

  GeniusPdfDocumentBuilder? _buildCashFlowTest() {
    final data = CashFlowData(
      periodStart: DateTime(2026, 1, 1),
      periodEnd: DateTime(2026, 1, 31),
      operatingActivities: CashFlowSection(
          type: CashFlowActivityType.operating,
          title: '',
          items: [
            const CashFlowItem(
                description: 'Cash from customers',
                descriptionAr: 'النقد من العملاء',
                amount: 480000),
          ]),
      investingActivities: CashFlowSection(
          type: CashFlowActivityType.investing,
          title: '',
          items: [
            const CashFlowItem(
                description: 'Equipment purchase',
                descriptionAr: 'شراء معدات',
                amount: -50000),
          ]),
      financingActivities: CashFlowSection(
          type: CashFlowActivityType.financing,
          title: '',
          items: [
            const CashFlowItem(
                description: 'Bank loan',
                descriptionAr: 'قرض بنكي',
                amount: 100000),
          ]),
      beginningCashBalance: 100000,
    );
    return CashFlowTemplate(
      config: GeniusPdfConfig(
          baseFontBytes: _fontBytes, textDirection: TextDirection.rtl),
      company: SampleData.companyInfo,
      data: data,
    );
  }

  GeniusPdfDocumentBuilder? _buildBudgetReportTest() {
    final data = BudgetReportData(
      reportTitle: 'Budget Report',
      reportTitleAr: 'تقرير الميزانية',
      periodStart: DateTime(2026, 1, 1),
      periodEnd: DateTime(2026, 1, 31),
      sections: [
        BudgetSection(title: 'Revenue', titleAr: 'الإيرادات', items: [
          const BudgetItem(
              category: 'Sales',
              categoryAr: 'المبيعات',
              budgetedAmount: 400000,
              actualAmount: 420000),
        ]),
      ],
    );
    return BudgetReportTemplate(
      config: GeniusPdfConfig(
          baseFontBytes: _fontBytes, textDirection: TextDirection.rtl),
      company: SampleData.companyInfo,
      data: data,
    );
  }

  GeniusPdfDocumentBuilder? _buildQuotationTest() {
    final customer = const QuotationCustomer(
      name: 'Test Customer',
      nameAr: 'عميل تجريبي',
      // company removed
      address: 'Riyadh',
      phone: '+966 12 345 6789',
    );
    final quotation = QuotationData(
      customer: customer,
      quotationNumber: 'QT-2026-001',
      quotationDate: DateTime.now(),
      validUntil: DateTime.now().add(const Duration(days: 30)),
      items: [
        const QuotationItem(
            itemNumber: 1,
            description: 'Product A',
            descriptionAr: 'منتج أ',
            quantity: 5,
            unitPrice: 1000),
      ],
      // taxes removed
    );
    return QuotationTemplate(
      config: GeniusPdfConfig(
          baseFontBytes: _fontBytes, textDirection: TextDirection.rtl),
      company: SampleData.companyInfo,
      // customer removed
      quotation: quotation,
    );
  }

  GeniusPdfDocumentBuilder? _buildPurchaseOrderTest() {
    final vendor = const PurchaseOrderVendor(
      name: 'Test Vendor',
      nameAr: 'مورد تجريبي',
      vendorCode: 'V001',
      address: 'Jeddah',
      vatNumber: '300098765400001',
    );
    final po = PurchaseOrderData(
      poNumber: 'PO-2026-001',
      poDate: DateTime.now(),
      expectedDeliveryDate: DateTime.now().add(const Duration(days: 14)),
      items: [
        const PurchaseOrderItem(
            itemNumber: 1,
            productCode: 'P001',
            description: 'Item A',
            descriptionAr: 'مادة أ',
            quantity: 10,
            unitPrice: 500),
      ],
      taxes: [(name: 'VAT', nameAr: 'ضريبة', rate: 15.0)],
    );
    return PurchaseOrderTemplate(
      config: GeniusPdfConfig(
          baseFontBytes: _fontBytes, textDirection: TextDirection.rtl),
      company: SampleData.companyInfo,
      vendor: vendor,
      purchaseOrder: po,
    );
  }

  GeniusPdfDocumentBuilder? _buildDeliveryNoteTest() {
    final recipient = const DeliveryRecipient(
      name: 'Test Recipient',
      nameAr: 'مستلم تجريبي',
      company: 'Test Co.',
      companyAr: 'شركة تجريبية',
      address: 'Riyadh',
      phone: '+966 55 123 4567',
    );
    final delivery = DeliveryNoteData(
      deliveryNumber: 'DN-2026-001',
      deliveryDate: DateTime.now(),
      items: [
        const DeliveryItem(
            itemNumber: 1,
            productCode: 'P001',
            description: 'Widget',
            descriptionAr: 'منتج',
            orderedQty: 100,
            deliveredQty: 100,
            unit: 'pcs'),
      ],
    );
    return DeliveryNoteTemplate(
      config: GeniusPdfConfig(
          baseFontBytes: _fontBytes, textDirection: TextDirection.rtl),
      company: SampleData.companyInfo,
      recipient: recipient,
      delivery: delivery,
    );
  }

  GeniusPdfDocumentBuilder? _buildPayslipTest() {
    final employee = PayslipEmployee(
      employeeId: 'EMP-001',
      name: 'Mohammed Ahmed',
      nameAr: 'محمد أحمد',
      department: 'IT',
      departmentAr: 'تقنية المعلومات',
      designation: 'Developer',
      designationAr: 'مطور',
      joiningDate: DateTime(2022, 3, 15),
      bankName: 'Al Rajhi',
      bankAccount: 'SA123456789',
    );
    final payslip = PayslipData(
      payPeriod: 'January 2026',
      payDate: DateTime(2026, 1, 28),
      workingDays: 22,
      paidDays: 22,
      earnings: [
        const EarningsItem(
            description: 'Basic', descriptionAr: 'الراتب', amount: 15000)
      ],
      deductions: [
        const DeductionsItem(
            description: 'GOSI', descriptionAr: 'التأمينات', amount: 1462.50)
      ],
    );
    return PayslipTemplate(
      config: GeniusPdfConfig(
          baseFontBytes: _fontBytes, textDirection: TextDirection.rtl),
      company: SampleData.companyInfo,
      employee: employee,
      payslip: payslip,
    );
  }

  GeniusPdfDocumentBuilder? _buildWatermarkTest() {
    return _SecurityTestBuilder(
      config: GeniusPdfConfig(baseFontBytes: _fontBytes),
      testName: 'Watermark Test',
      applySecurityFeature: (document) {
        document.addWatermark(GeniusPdfWatermark.confidential(
          config: _config,
        ));
      },
    );
  }

  GeniusPdfDocumentBuilder? _buildTiledWatermarkTest() {
    return _SecurityTestBuilder(
      config: GeniusPdfConfig(baseFontBytes: _fontBytes),
      testName: 'TiledWatermark Test',
      applySecurityFeature: (document) {
        GeniusPdfWatermark.tiled(
          config: _config,
          GeniusTiledWatermarkSettings(
            text: 'SAMPLE',
            fontSize: 20,
            color: const Color(0xFF808080),
            opacity: 0.1,
          ),
        ).applyToDocument(document);
      },
    );
  }

  GeniusPdfDocumentBuilder? _buildDigitalSignatureTest() {
    return _SignatureTestBuilder(
      config: GeniusPdfConfig(baseFontBytes: _fontBytes),
      testName: 'DigitalSignature Test',
    );
  }
  // ──────────────────────────────────────────────────────────
  // New Test Builders (Added for Completeness)
  // ──────────────────────────────────────────────────────────

  GeniusPdfDocumentBuilder? _buildAdvancedLayoutTest() {
    return AdvancedLayoutDemoBuilder(config: _config);
  }

  GeniusPdfDocumentBuilder? _buildPositionTrackingTest() {
    return PositionTrackingDemoBuilder(config: _config);
  }

  GeniusPdfDocumentBuilder? _buildMultiGridSummaryTest() {
    return MultiGridSummaryDemoBuilder(config: _config);
  }

  GeniusPdfDocumentBuilder? _buildQRAttachmentsTest() {
    return QRAttachmentsDemoBuilder(config: _config);
  }
}

final class JobFeatureCategory {
  const JobFeatureCategory({
    required this.name,
    required this.icon,
    required this.gradient,
    required this.features,
  });

  final String name;
  final IconData icon;
  final List<Color> gradient;
  final List<JobFeature> features;
}

final class JobFeature {
  const JobFeature({
    required this.name,
    required this.description,
    required this.builder,
  });

  final String name;
  final String description;
  final GeniusPdfDocumentBuilder? Function() builder;
}

class _ComponentTestBuilder extends GeniusPdfDocumentBuilder {
  _ComponentTestBuilder({
    required GeniusPdfConfig config,
    required this.testName,
    required this.buildContent,
    this.titleFont,
  }) : super(config);

  final String testName;
  final void Function(_ComponentTestBuilder builder) buildContent;
  final PdfFont? titleFont;

  @override
  void build() {
    newPage();
    addLine(testName, font: titleFont ?? baseFont, topMargin: 20);
    addSpace(30);
    buildContent(this);
  }
}

class _SecurityTestBuilder extends GeniusPdfDocumentBuilder {
  _SecurityTestBuilder({
    required GeniusPdfConfig config,
    required this.testName,
    required this.applySecurityFeature,
    this.titleFont,
  }) : super(config);

  final String testName;
  final void Function(PdfDocument document) applySecurityFeature;
  final PdfFont? titleFont;

  @override
  void build() {
    newPage();
    addLine(testName, font: titleFont ?? baseFont, topMargin: 20);
    addSpace(30);
    addLine('This document tests the security feature: $testName',
        topMargin: 10);
    addLine('Generated at: ${DateTime.now()}', topMargin: 10);

    for (int i = 0; i < 10; i++) {
      addLine('Sample content line ${i + 1}', topMargin: 8);
    }

    // Apply security feature to the document
    applySecurityFeature(document);
  }
}

class _SignatureTestBuilder extends GeniusPdfDocumentBuilder {
  _SignatureTestBuilder({
    required GeniusPdfConfig config,
    required this.testName,
    this.titleFont,
  }) : super(config);

  final String testName;
  final PdfFont? titleFont;

  @override
  void build() {
    newPage();
    addLine(testName, font: titleFont ?? baseFont, topMargin: 20);
    addSpace(30);
    addLine('This document tests digital signature appearance.', topMargin: 10);
    addLine('Generated at: ${DateTime.now()}', topMargin: 10);
    addSpace(50);

    final signature = GeniusPdfDigitalSignature(
      config: config,
      settings: GeniusDigitalSignatureSettings(
        signerName: 'Test Signer',
        reason: 'Testing signature feature',
        location: 'Test Location',
        appearance: const GeniusSignatureAppearance(
          showName: true,
          showDate: true,
          showReason: true,
          showLocation: true,
        ),
        pageNumber: 0,
      ),
    );
    signature.drawOnPage(currentPage);
  }
}
