import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_ar.dart';
import 'l10n_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of PDFGeneratorLocalization
/// returned by `PDFGeneratorLocalization.of(context)`.
///
/// Applications need to include `PDFGeneratorLocalization.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: PDFGeneratorLocalization.localizationsDelegates,
///   supportedLocales: PDFGeneratorLocalization.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the PDFGeneratorLocalization.supportedLocales
/// property.
abstract class PDFGeneratorLocalization {
  PDFGeneratorLocalization(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static PDFGeneratorLocalization of(BuildContext context) {
    return Localizations.of<PDFGeneratorLocalization>(
      context,
      PDFGeneratorLocalization,
    )!;
  }

  static const LocalizationsDelegate<PDFGeneratorLocalization> delegate =
      _PDFGeneratorLocalizationDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @oneRow.
  ///
  /// In en, this message translates to:
  /// **'1 row'**
  String get oneRow;

  /// No description provided for @onePageDocument.
  ///
  /// In en, this message translates to:
  /// **'1-page Document'**
  String get onePageDocument;

  /// No description provided for @tenRows.
  ///
  /// In en, this message translates to:
  /// **'10 rows'**
  String get tenRows;

  /// No description provided for @oneHundredRows.
  ///
  /// In en, this message translates to:
  /// **'100 rows'**
  String get oneHundredRows;

  /// No description provided for @oneThousandRows.
  ///
  /// In en, this message translates to:
  /// **'1000 rows'**
  String get oneThousandRows;

  /// No description provided for @oneDBarcodes.
  ///
  /// In en, this message translates to:
  /// **'1D Barcodes'**
  String get oneDBarcodes;

  /// No description provided for @oneKRowLargeDataMode.
  ///
  /// In en, this message translates to:
  /// **'1k-row Large-data Mode'**
  String get oneKRowLargeDataMode;

  /// No description provided for @fiftyRows.
  ///
  /// In en, this message translates to:
  /// **'50 rows'**
  String get fiftyRows;

  /// No description provided for @fiftyRowsMultiPage.
  ///
  /// In en, this message translates to:
  /// **'50 Rows / Multi-page'**
  String get fiftyRowsMultiPage;

  /// No description provided for @fiveHundredRows.
  ///
  /// In en, this message translates to:
  /// **'500 rows'**
  String get fiveHundredRows;

  /// No description provided for @fiveHundredRowStress.
  ///
  /// In en, this message translates to:
  /// **'500-row Stress'**
  String get fiveHundredRowStress;

  /// No description provided for @fiftyEightMmReceipt.
  ///
  /// In en, this message translates to:
  /// **'58mm Receipt'**
  String get fiftyEightMmReceipt;

  /// No description provided for @fiftyEightMmThermal.
  ///
  /// In en, this message translates to:
  /// **'58mm thermal'**
  String get fiftyEightMmThermal;

  /// No description provided for @eightyMmReceipt.
  ///
  /// In en, this message translates to:
  /// **'80mm Receipt'**
  String get eightyMmReceipt;

  /// No description provided for @eightyMmThermal.
  ///
  /// In en, this message translates to:
  /// **'80mm thermal'**
  String get eightyMmThermal;

  /// No description provided for @professionalCustomerQuotationDesc.
  ///
  /// In en, this message translates to:
  /// **'A professional customer quotation with products, pricing, and validity.'**
  String get professionalCustomerQuotationDesc;

  /// No description provided for @a4Landscape.
  ///
  /// In en, this message translates to:
  /// **'A4 landscape'**
  String get a4Landscape;

  /// No description provided for @a4Portrait.
  ///
  /// In en, this message translates to:
  /// **'A4 Portrait'**
  String get a4Portrait;

  /// No description provided for @a4Portrait2.
  ///
  /// In en, this message translates to:
  /// **'A4 portrait'**
  String get a4Portrait2;

  /// No description provided for @a5.
  ///
  /// In en, this message translates to:
  /// **'A5'**
  String get a5;

  /// No description provided for @accountStatement.
  ///
  /// In en, this message translates to:
  /// **'Account Statement'**
  String get accountStatement;

  /// No description provided for @accountStatement2.
  ///
  /// In en, this message translates to:
  /// **'Account statement'**
  String get accountStatement2;

  /// No description provided for @accountingAndReceipts.
  ///
  /// In en, this message translates to:
  /// **'Accounting & receipts'**
  String get accountingAndReceipts;

  /// No description provided for @accountingEntriesReceiptsPaymentsTaxDesc.
  ///
  /// In en, this message translates to:
  /// **'Accounting entries, receipts, payments, tax vouchers, and check receipts in one batch.'**
  String get accountingEntriesReceiptsPaymentsTaxDesc;

  /// No description provided for @activityReport.
  ///
  /// In en, this message translates to:
  /// **'Activity Report'**
  String get activityReport;

  /// No description provided for @styledLinksFluentRichTextContentDesc.
  ///
  /// In en, this message translates to:
  /// **'Add styled links to fluent rich text content using the builder link API.'**
  String get styledLinksFluentRichTextContentDesc;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @advancedArchitecture.
  ///
  /// In en, this message translates to:
  /// **'Advanced Architecture'**
  String get advancedArchitecture;

  /// No description provided for @advancedFeatures.
  ///
  /// In en, this message translates to:
  /// **'Advanced Features'**
  String get advancedFeatures;

  /// No description provided for @advancedGroupedSummary.
  ///
  /// In en, this message translates to:
  /// **'Advanced Grouped Summary'**
  String get advancedGroupedSummary;

  /// No description provided for @advancedLayout.
  ///
  /// In en, this message translates to:
  /// **'Advanced Layout'**
  String get advancedLayout;

  /// No description provided for @aes256Encryption.
  ///
  /// In en, this message translates to:
  /// **'AES-256 Encryption'**
  String get aes256Encryption;

  /// No description provided for @aiAdvanced.
  ///
  /// In en, this message translates to:
  /// **'AI / Advanced'**
  String get aiAdvanced;

  /// No description provided for @aiFeatures.
  ///
  /// In en, this message translates to:
  /// **'AI Features'**
  String get aiFeatures;

  /// No description provided for @allInOne.
  ///
  /// In en, this message translates to:
  /// **'All-in-One'**
  String get allInOne;

  /// No description provided for @allowancesReport.
  ///
  /// In en, this message translates to:
  /// **'Allowances Report'**
  String get allowancesReport;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @analyticalReport.
  ///
  /// In en, this message translates to:
  /// **'Analytical report'**
  String get analyticalReport;

  /// No description provided for @analyzeFontSizes.
  ///
  /// In en, this message translates to:
  /// **'Analyze Font Sizes'**
  String get analyzeFontSizes;

  /// No description provided for @analyzeSampleInvoice.
  ///
  /// In en, this message translates to:
  /// **'Analyze Sample Invoice'**
  String get analyzeSampleInvoice;

  /// No description provided for @analyzeSampleReport.
  ///
  /// In en, this message translates to:
  /// **'Analyze Sample Report'**
  String get analyzeSampleReport;

  /// No description provided for @apAging.
  ///
  /// In en, this message translates to:
  /// **'AP Aging'**
  String get apAging;

  /// No description provided for @appSharing.
  ///
  /// In en, this message translates to:
  /// **'App Sharing'**
  String get appSharing;

  /// No description provided for @applicationIntegrationAdvancedApisDesc.
  ///
  /// In en, this message translates to:
  /// **'Application integration, advanced APIs, ERP domain calculations, and extension points.'**
  String get applicationIntegrationAdvancedApisDesc;

  /// No description provided for @perLinkColorsMarkdownLinkColorSyntaxDesc.
  ///
  /// In en, this message translates to:
  /// **'Apply per-link colors through the markdown link-color syntax.'**
  String get perLinkColorsMarkdownLinkColorSyntaxDesc;

  /// No description provided for @arAging.
  ///
  /// In en, this message translates to:
  /// **'AR Aging'**
  String get arAging;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @arabicLatinDigits.
  ///
  /// In en, this message translates to:
  /// **'Arabic / Latin Digits'**
  String get arabicLatinDigits;

  /// No description provided for @architecture.
  ///
  /// In en, this message translates to:
  /// **'Architecture'**
  String get architecture;

  /// No description provided for @archiveAuditMetadata.
  ///
  /// In en, this message translates to:
  /// **'Archive / Audit Metadata'**
  String get archiveAuditMetadata;

  /// No description provided for @assetAssignment.
  ///
  /// In en, this message translates to:
  /// **'Asset Assignment'**
  String get assetAssignment;

  /// No description provided for @assetCard.
  ///
  /// In en, this message translates to:
  /// **'Asset Card'**
  String get assetCard;

  /// No description provided for @assetCount.
  ///
  /// In en, this message translates to:
  /// **'Asset Count'**
  String get assetCount;

  /// No description provided for @assetDisposal.
  ///
  /// In en, this message translates to:
  /// **'Asset Disposal'**
  String get assetDisposal;

  /// No description provided for @assetLabel.
  ///
  /// In en, this message translates to:
  /// **'Asset Label'**
  String get assetLabel;

  /// No description provided for @assetMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Asset Maintenance'**
  String get assetMaintenance;

  /// No description provided for @assetMovement.
  ///
  /// In en, this message translates to:
  /// **'Asset Movement'**
  String get assetMovement;

  /// No description provided for @assetRegister.
  ///
  /// In en, this message translates to:
  /// **'Asset Register'**
  String get assetRegister;

  /// No description provided for @assetReturn.
  ///
  /// In en, this message translates to:
  /// **'Asset Return'**
  String get assetReturn;

  /// No description provided for @assetTransfer.
  ///
  /// In en, this message translates to:
  /// **'Asset Transfer'**
  String get assetTransfer;

  /// No description provided for @assets.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get assets;

  /// No description provided for @assetsLiabilitiesEquityCompleteDesc.
  ///
  /// In en, this message translates to:
  /// **'Assets, liabilities, and equity in a complete financial-position statement.'**
  String get assetsLiabilitiesEquityCompleteDesc;

  /// No description provided for @attachmentBrandLogo.
  ///
  /// In en, this message translates to:
  /// **'Attachment: Brand Logo'**
  String get attachmentBrandLogo;

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// No description provided for @attendanceReport.
  ///
  /// In en, this message translates to:
  /// **'Attendance Report'**
  String get attendanceReport;

  /// No description provided for @attendanceReportHtmlExport.
  ///
  /// In en, this message translates to:
  /// **'Attendance Report HTML Export'**
  String get attendanceReportHtmlExport;

  /// No description provided for @attendanceReportImageExport.
  ///
  /// In en, this message translates to:
  /// **'Attendance Report Image Export'**
  String get attendanceReportImageExport;

  /// No description provided for @attendanceSummaryWorkingDaysStatusesDesc.
  ///
  /// In en, this message translates to:
  /// **'Attendance summary with working days, statuses, and working hours.'**
  String get attendanceSummaryWorkingDaysStatusesDesc;

  /// No description provided for @auditForm.
  ///
  /// In en, this message translates to:
  /// **'Audit Form'**
  String get auditForm;

  /// No description provided for @autoGrouping.
  ///
  /// In en, this message translates to:
  /// **'Auto Grouping'**
  String get autoGrouping;

  /// No description provided for @autoInheritance.
  ///
  /// In en, this message translates to:
  /// **'AUTO Inheritance'**
  String get autoInheritance;

  /// No description provided for @autoPageBreaks.
  ///
  /// In en, this message translates to:
  /// **'Auto page breaks'**
  String get autoPageBreaks;

  /// No description provided for @autoCalculatedTotals.
  ///
  /// In en, this message translates to:
  /// **'Auto-Calculated Totals'**
  String get autoCalculatedTotals;

  /// No description provided for @autoDetectedLinks.
  ///
  /// In en, this message translates to:
  /// **'Auto-Detected Links'**
  String get autoDetectedLinks;

  /// No description provided for @automaticallyDetectUrlsEmailDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatically detect URLs and email addresses while parsing rich-text markdown content.'**
  String get automaticallyDetectUrlsEmailDesc;

  /// No description provided for @automotiveDistributionHospitality.
  ///
  /// In en, this message translates to:
  /// **'Automotive / Distribution / Hospitality'**
  String get automotiveDistributionHospitality;

  /// No description provided for @auxiliaryVouchers.
  ///
  /// In en, this message translates to:
  /// **'Auxiliary Vouchers'**
  String get auxiliaryVouchers;

  /// No description provided for @availablePrinters.
  ///
  /// In en, this message translates to:
  /// **'Available Printers'**
  String get availablePrinters;

  /// No description provided for @b5PaymentVoucher.
  ///
  /// In en, this message translates to:
  /// **'B5 Payment Voucher'**
  String get b5PaymentVoucher;

  /// No description provided for @backgroundGeneration.
  ///
  /// In en, this message translates to:
  /// **'Background Generation'**
  String get backgroundGeneration;

  /// No description provided for @backgroundGenerationAndJobQueue.
  ///
  /// In en, this message translates to:
  /// **'Background Generation & Job Queue'**
  String get backgroundGenerationAndJobQueue;

  /// No description provided for @backorder.
  ///
  /// In en, this message translates to:
  /// **'Backorder'**
  String get backorder;

  /// No description provided for @balanceSheet.
  ///
  /// In en, this message translates to:
  /// **'Balance Sheet'**
  String get balanceSheet;

  /// No description provided for @balanceSheetHtmlExport.
  ///
  /// In en, this message translates to:
  /// **'Balance Sheet HTML Export'**
  String get balanceSheetHtmlExport;

  /// No description provided for @balanceSheetImageExport.
  ///
  /// In en, this message translates to:
  /// **'Balance Sheet Image Export'**
  String get balanceSheetImageExport;

  /// No description provided for @balanceSheetReport.
  ///
  /// In en, this message translates to:
  /// **'Balance sheet report'**
  String get balanceSheetReport;

  /// No description provided for @bankBook.
  ///
  /// In en, this message translates to:
  /// **'Bank Book'**
  String get bankBook;

  /// No description provided for @bankDepositsWithdrawalsTransfersBillDesc.
  ///
  /// In en, this message translates to:
  /// **'Bank deposits, withdrawals, transfers, and bill-payment voucher examples.'**
  String get bankDepositsWithdrawalsTransfersBillDesc;

  /// No description provided for @bankLoan.
  ///
  /// In en, this message translates to:
  /// **'Bank loan'**
  String get bankLoan;

  /// No description provided for @bankReconciliation.
  ///
  /// In en, this message translates to:
  /// **'Bank Reconciliation'**
  String get bankReconciliation;

  /// No description provided for @bankingVouchers.
  ///
  /// In en, this message translates to:
  /// **'Banking Vouchers'**
  String get bankingVouchers;

  /// No description provided for @barcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcode;

  /// No description provided for @barcodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Barcode Label'**
  String get barcodeLabel;

  /// No description provided for @barcodesAndImages.
  ///
  /// In en, this message translates to:
  /// **'Barcodes & images'**
  String get barcodesAndImages;

  /// No description provided for @baselineCalculation.
  ///
  /// In en, this message translates to:
  /// **'Baseline Calculation'**
  String get baselineCalculation;

  /// No description provided for @basic.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get basic;

  /// No description provided for @basicInvoiceSummary.
  ///
  /// In en, this message translates to:
  /// **'Basic Invoice Summary'**
  String get basicInvoiceSummary;

  /// No description provided for @batchExport.
  ///
  /// In en, this message translates to:
  /// **'Batch Export'**
  String get batchExport;

  /// No description provided for @batchLabel.
  ///
  /// In en, this message translates to:
  /// **'Batch Label'**
  String get batchLabel;

  /// No description provided for @batchReport.
  ///
  /// In en, this message translates to:
  /// **'Batch Report'**
  String get batchReport;

  /// No description provided for @benchmarkAndPerformance.
  ///
  /// In en, this message translates to:
  /// **'Benchmark & Performance'**
  String get benchmarkAndPerformance;

  /// No description provided for @bilingualRtlStructuredValues.
  ///
  /// In en, this message translates to:
  /// **'Bilingual / RTL structured values'**
  String get bilingualRtlStructuredValues;

  /// No description provided for @bilingualMixedValues.
  ///
  /// In en, this message translates to:
  /// **'Bilingual Mixed Values'**
  String get bilingualMixedValues;

  /// No description provided for @bilingualRtlHeader.
  ///
  /// In en, this message translates to:
  /// **'Bilingual RTL Header'**
  String get bilingualRtlHeader;

  /// No description provided for @bilingualSplitHeader.
  ///
  /// In en, this message translates to:
  /// **'Bilingual Split Header'**
  String get bilingualSplitHeader;

  /// No description provided for @bilingualSplitHeaderFullCompanyDesc.
  ///
  /// In en, this message translates to:
  /// **'Bilingual split header with full company details and Saudi-themed colors under RTL configuration.'**
  String get bilingualSplitHeaderFullCompanyDesc;

  /// No description provided for @billOfMaterials.
  ///
  /// In en, this message translates to:
  /// **'Bill of Materials'**
  String get billOfMaterials;

  /// No description provided for @bluetoothSharing.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth Sharing'**
  String get bluetoothSharing;

  /// No description provided for @borderedStyle.
  ///
  /// In en, this message translates to:
  /// **'Bordered Style'**
  String get borderedStyle;

  /// No description provided for @boundedLargeLoop.
  ///
  /// In en, this message translates to:
  /// **'Bounded Large Loop'**
  String get boundedLargeLoop;

  /// No description provided for @brandingAndAssets.
  ///
  /// In en, this message translates to:
  /// **'Branding & Assets'**
  String get brandingAndAssets;

  /// No description provided for @budgetReport.
  ///
  /// In en, this message translates to:
  /// **'Budget Report'**
  String get budgetReport;

  /// No description provided for @budgetReportHtmlExport.
  ///
  /// In en, this message translates to:
  /// **'Budget Report HTML Export'**
  String get budgetReportHtmlExport;

  /// No description provided for @budgetReportImageExport.
  ///
  /// In en, this message translates to:
  /// **'Budget Report Image Export'**
  String get budgetReportImageExport;

  /// No description provided for @budgetVsActual.
  ///
  /// In en, this message translates to:
  /// **'Budget vs Actual'**
  String get budgetVsActual;

  /// No description provided for @budgetVsActual2.
  ///
  /// In en, this message translates to:
  /// **'Budget vs actual'**
  String get budgetVsActual2;

  /// No description provided for @budgetVersusActualComparisonVarianceDesc.
  ///
  /// In en, this message translates to:
  /// **'Budget-versus-actual comparison with variance analysis.'**
  String get budgetVersusActualComparisonVarianceDesc;

  /// No description provided for @completePdfReportFluentReportDesc.
  ///
  /// In en, this message translates to:
  /// **'Build a complete PDF report through the fluent report-composer API.'**
  String get completePdfReportFluentReportDesc;

  /// No description provided for @pLStyleMultiGroupSummaryCustomColorsDesc.
  ///
  /// In en, this message translates to:
  /// **'Build a P&L-style multi-group summary with custom colors, indented items, calculated sections, and advanced totals.'**
  String get pLStyleMultiGroupSummaryCustomColorsDesc;

  /// No description provided for @eInvoiceCompanyCustomerMetadataItemDesc.
  ///
  /// In en, this message translates to:
  /// **'Build an e-invoice with company/customer metadata, item grid totals, and a ZATCA-compatible QR code.'**
  String get eInvoiceCompanyCustomerMetadataItemDesc;

  /// No description provided for @inventoryGridAutomaticTotalsUrlQrDesc.
  ///
  /// In en, this message translates to:
  /// **'Build an inventory grid with automatic totals and a URL QR code for shipment or stock tracking.'**
  String get inventoryGridAutomaticTotalsUrlQrDesc;

  /// No description provided for @invoiceSummaryRegularNegativeDesc.
  ///
  /// In en, this message translates to:
  /// **'Build an invoice summary with regular, negative, separator, and grand-total summary items.'**
  String get invoiceSummaryRegularNegativeDesc;

  /// No description provided for @invoiceStyleGeniusPdfDataGridMixedDesc.
  ///
  /// In en, this message translates to:
  /// **'Build an invoice-style GeniusPdfDataGrid with mixed column sizing, currency columns, subtotal rows, discount, VAT, and a grand total.'**
  String get invoiceStyleGeniusPdfDataGridMixedDesc;

  /// No description provided for @hierarchicalSummaryRowsIndentationDesc.
  ///
  /// In en, this message translates to:
  /// **'Build hierarchical summary rows using indentation levels, subtotals, separators, and a final total.'**
  String get hierarchicalSummaryRowsIndentationDesc;

  /// No description provided for @buildPdfs.
  ///
  /// In en, this message translates to:
  /// **'Build PDFs'**
  String get buildPdfs;

  /// No description provided for @trialBalanceHtmlExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Build TrialBalanceTemplate from lib/templates/trial_balance.dart and export its generated PDF document to HTML using GeniusPdfExportService. Preview, copy, save, and open the exact HTML output.'**
  String get trialBalanceHtmlExportDesc;

  /// No description provided for @trialBalanceImageExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Build TrialBalanceTemplate from lib/templates/trial_balance.dart, rasterize every generated PDF page, save it as PNG or JPEG, and preview the exact exported image bytes.'**
  String get trialBalanceImageExportDesc;

  /// No description provided for @builderLinks.
  ///
  /// In en, this message translates to:
  /// **'Builder Links'**
  String get builderLinks;

  /// No description provided for @builderWebLinks.
  ///
  /// In en, this message translates to:
  /// **'Builder Web Links'**
  String get builderWebLinks;

  /// No description provided for @builtTemplatesJsonBackedTemplatesVDesc.
  ///
  /// In en, this message translates to:
  /// **'Built-in templates, JSON-backed templates, vNext engine, consolidation, and designer examples.'**
  String get builtTemplatesJsonBackedTemplatesVDesc;

  /// No description provided for @bulletList.
  ///
  /// In en, this message translates to:
  /// **'Bullet List'**
  String get bulletList;

  /// No description provided for @businessTemplates.
  ///
  /// In en, this message translates to:
  /// **'Business Templates'**
  String get businessTemplates;

  /// No description provided for @businessTemplatesAndErpPacks.
  ///
  /// In en, this message translates to:
  /// **'Business Templates & ERP Packs'**
  String get businessTemplatesAndErpPacks;

  /// No description provided for @calibrationServiceHistory.
  ///
  /// In en, this message translates to:
  /// **'Calibration / Service History'**
  String get calibrationServiceHistory;

  /// No description provided for @calibrationPage.
  ///
  /// In en, this message translates to:
  /// **'Calibration page'**
  String get calibrationPage;

  /// No description provided for @calibrationRecord.
  ///
  /// In en, this message translates to:
  /// **'Calibration Record'**
  String get calibrationRecord;

  /// No description provided for @callReport.
  ///
  /// In en, this message translates to:
  /// **'Call Report'**
  String get callReport;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @cancelQueued.
  ///
  /// In en, this message translates to:
  /// **'Cancel queued'**
  String get cancelQueued;

  /// No description provided for @capa.
  ///
  /// In en, this message translates to:
  /// **'CAPA'**
  String get capa;

  /// No description provided for @card.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get card;

  /// No description provided for @cardStyle.
  ///
  /// In en, this message translates to:
  /// **'Card Style'**
  String get cardStyle;

  /// No description provided for @cashBook.
  ///
  /// In en, this message translates to:
  /// **'Cash Book'**
  String get cashBook;

  /// No description provided for @cashDrawer.
  ///
  /// In en, this message translates to:
  /// **'Cash Drawer'**
  String get cashDrawer;

  /// No description provided for @cashFlow.
  ///
  /// In en, this message translates to:
  /// **'Cash Flow'**
  String get cashFlow;

  /// No description provided for @cashFlowHtmlExport.
  ///
  /// In en, this message translates to:
  /// **'Cash Flow HTML Export'**
  String get cashFlowHtmlExport;

  /// No description provided for @cashFlowImageExport.
  ///
  /// In en, this message translates to:
  /// **'Cash Flow Image Export'**
  String get cashFlowImageExport;

  /// No description provided for @cashFlowStatement.
  ///
  /// In en, this message translates to:
  /// **'Cash Flow Statement'**
  String get cashFlowStatement;

  /// No description provided for @cashFlowStatement2.
  ///
  /// In en, this message translates to:
  /// **'Cash flow statement'**
  String get cashFlowStatement2;

  /// No description provided for @cashFromCustomers.
  ///
  /// In en, this message translates to:
  /// **'Cash from customers'**
  String get cashFromCustomers;

  /// No description provided for @certificate.
  ///
  /// In en, this message translates to:
  /// **'Certificate'**
  String get certificate;

  /// No description provided for @certificateOfAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Certificate of Analysis'**
  String get certificateOfAnalysis;

  /// No description provided for @checkPrintingInfo.
  ///
  /// In en, this message translates to:
  /// **'Check Printing Info'**
  String get checkPrintingInfo;

  /// No description provided for @chooseAGenerationExampleFromTheCatalog.
  ///
  /// In en, this message translates to:
  /// **'Choose a generation example from the catalog.'**
  String get chooseAGenerationExampleFromTheCatalog;

  /// No description provided for @classicLetterheadLayoutFormalDesc.
  ///
  /// In en, this message translates to:
  /// **'Classic letterhead layout with formal reference metadata for official correspondence.'**
  String get classicLetterheadLayoutFormalDesc;

  /// No description provided for @cleanOfficialSalesInvoiceDesign.
  ///
  /// In en, this message translates to:
  /// **'Clean, official sales invoice design.'**
  String get cleanOfficialSalesInvoiceDesign;

  /// No description provided for @clearEventLog.
  ///
  /// In en, this message translates to:
  /// **'Clear Event Log'**
  String get clearEventLog;

  /// No description provided for @clearFinished.
  ///
  /// In en, this message translates to:
  /// **'Clear finished'**
  String get clearFinished;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear history'**
  String get clearHistory;

  /// No description provided for @cloudStorage.
  ///
  /// In en, this message translates to:
  /// **'Cloud Storage'**
  String get cloudStorage;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// No description provided for @code128.
  ///
  /// In en, this message translates to:
  /// **'Code 128'**
  String get code128;

  /// No description provided for @codeCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Code copied to clipboard'**
  String get codeCopiedToClipboard;

  /// No description provided for @codeExample.
  ///
  /// In en, this message translates to:
  /// **'Code example'**
  String get codeExample;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @colorMode.
  ///
  /// In en, this message translates to:
  /// **'Color Mode'**
  String get colorMode;

  /// No description provided for @coloredMarkdownLinks.
  ///
  /// In en, this message translates to:
  /// **'Colored Markdown Links'**
  String get coloredMarkdownLinks;

  /// No description provided for @columnSizing.
  ///
  /// In en, this message translates to:
  /// **'Column Sizing'**
  String get columnSizing;

  /// No description provided for @columns.
  ///
  /// In en, this message translates to:
  /// **'Columns'**
  String get columns;

  /// No description provided for @columnsAndHeaders.
  ///
  /// In en, this message translates to:
  /// **'Columns & headers'**
  String get columnsAndHeaders;

  /// No description provided for @expenseGridFormattedRecommendationDesc.
  ///
  /// In en, this message translates to:
  /// **'Combine an expense grid with formatted recommendation blocks and a report summary info box.'**
  String get expenseGridFormattedRecommendationDesc;

  /// No description provided for @boldTextMultipleColoredLinksMailtoDesc.
  ///
  /// In en, this message translates to:
  /// **'Combine bold text, multiple colored links, mailto links, and ordinary formatted text in one rich-text flow.'**
  String get boldTextMultipleColoredLinksMailtoDesc;

  /// No description provided for @customerOrderInfoBoxesGroupedInvoiceDesc.
  ///
  /// In en, this message translates to:
  /// **'Combine customer/order info boxes with a grouped invoice-style data grid and calculated totals.'**
  String get customerOrderInfoBoxesGroupedInvoiceDesc;

  /// No description provided for @introductoryRichTextRevenueAnalysisDesc.
  ///
  /// In en, this message translates to:
  /// **'Combine introductory rich text, a revenue analysis data grid, automatic totals, and formatted commentary.'**
  String get introductoryRichTextRevenueAnalysisDesc;

  /// No description provided for @shippingPaymentInformationBoxesDesc.
  ///
  /// In en, this message translates to:
  /// **'Combine shipping/payment information boxes, delivery tracking rows, and status messages in one focused document.'**
  String get shippingPaymentInformationBoxesDesc;

  /// No description provided for @commissionReport.
  ///
  /// In en, this message translates to:
  /// **'Commission Report'**
  String get commissionReport;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @companyHeaderComponent.
  ///
  /// In en, this message translates to:
  /// **'Company header component'**
  String get companyHeaderComponent;

  /// No description provided for @companyNameArabic.
  ///
  /// In en, this message translates to:
  /// **'Company Name (Arabic)'**
  String get companyNameArabic;

  /// No description provided for @companyNameEnglish.
  ///
  /// In en, this message translates to:
  /// **'Company Name (English)'**
  String get companyNameEnglish;

  /// No description provided for @compareInformationalWarningSemanticDesc.
  ///
  /// In en, this message translates to:
  /// **'Compare informational and warning semantic info-box styles in a dual-box layout.'**
  String get compareInformationalWarningSemanticDesc;

  /// No description provided for @compareModernClassicStripedDarkDesc.
  ///
  /// In en, this message translates to:
  /// **'Compare modern, classic, striped, and dark GeniusPdfGridStyle presets using the same grid data and custom primary colors.'**
  String get compareModernClassicStripedDarkDesc;

  /// No description provided for @compareSuccessErrorSemanticInfoBoxDesc.
  ///
  /// In en, this message translates to:
  /// **'Compare success and error semantic info-box styles using focused status content.'**
  String get compareSuccessErrorSemanticInfoBoxDesc;

  /// No description provided for @completeDemo.
  ///
  /// In en, this message translates to:
  /// **'Complete Demo'**
  String get completeDemo;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @completionCertificate.
  ///
  /// In en, this message translates to:
  /// **'Completion Certificate'**
  String get completionCertificate;

  /// No description provided for @componentCompositions.
  ///
  /// In en, this message translates to:
  /// **'Component Compositions'**
  String get componentCompositions;

  /// No description provided for @componentMatrix.
  ///
  /// In en, this message translates to:
  /// **'Component Matrix'**
  String get componentMatrix;

  /// No description provided for @components.
  ///
  /// In en, this message translates to:
  /// **'Components'**
  String get components;

  /// No description provided for @componentsStyles.
  ///
  /// In en, this message translates to:
  /// **'Components / Styles'**
  String get componentsStyles;

  /// No description provided for @componentsStylesSubTemplate.
  ///
  /// In en, this message translates to:
  /// **'Components / Styles / SubTemplate'**
  String get componentsStylesSubTemplate;

  /// No description provided for @componentsTablesAndSummaries.
  ///
  /// In en, this message translates to:
  /// **'Components, Tables & Summaries'**
  String get componentsTablesAndSummaries;

  /// No description provided for @composeEmail.
  ///
  /// In en, this message translates to:
  /// **'Compose Email'**
  String get composeEmail;

  /// No description provided for @pdfEmailSharesReuseMessageTemplatesDesc.
  ///
  /// In en, this message translates to:
  /// **'Compose PDF email shares and reuse message templates.'**
  String get pdfEmailSharesReuseMessageTemplatesDesc;

  /// No description provided for @comprehensiveDemoGeneratedPasswordDemo.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive demo generated! Password: demo123'**
  String get comprehensiveDemoGeneratedPasswordDemo;

  /// No description provided for @comprehensiveSecurityDemo.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive Security Demo'**
  String get comprehensiveSecurityDemo;

  /// No description provided for @conditionsExpressions.
  ///
  /// In en, this message translates to:
  /// **'Conditions / Expressions'**
  String get conditionsExpressions;

  /// No description provided for @confidentialAudit.
  ///
  /// In en, this message translates to:
  /// **'Confidential Audit'**
  String get confidentialAudit;

  /// No description provided for @confidentialWatermark.
  ///
  /// In en, this message translates to:
  /// **'Confidential Watermark'**
  String get confidentialWatermark;

  /// No description provided for @configuration.
  ///
  /// In en, this message translates to:
  /// **'Configuration'**
  String get configuration;

  /// No description provided for @configurationSummary.
  ///
  /// In en, this message translates to:
  /// **'Configuration summary'**
  String get configurationSummary;

  /// No description provided for @reportCompositionChoosePdfComponentsDesc.
  ///
  /// In en, this message translates to:
  /// **'Configure a report composition, choose its PDF components, then generate the document explicitly.'**
  String get reportCompositionChoosePdfComponentsDesc;

  /// No description provided for @dataGridColumnsWidthPercentNumericDesc.
  ///
  /// In en, this message translates to:
  /// **'Configure DataGrid columns with widthPercent and numeric/currency sizing while combining sum, min, and max automatic totals.'**
  String get dataGridColumnsWidthPercentNumericDesc;

  /// No description provided for @configurePaperSizeQualityCopiesAndMore.
  ///
  /// In en, this message translates to:
  /// **'Configure paper size, quality, copies, and more.'**
  String get configurePaperSizeQualityCopiesAndMore;

  /// No description provided for @constructionRealEstate.
  ///
  /// In en, this message translates to:
  /// **'Construction / Real Estate'**
  String get constructionRealEstate;

  /// No description provided for @contactInformationQr.
  ///
  /// In en, this message translates to:
  /// **'Contact information QR'**
  String get contactInformationQr;

  /// No description provided for @containerList.
  ///
  /// In en, this message translates to:
  /// **'Container List'**
  String get containerList;

  /// No description provided for @contentAnalyzer.
  ///
  /// In en, this message translates to:
  /// **'Content Analyzer'**
  String get contentAnalyzer;

  /// No description provided for @continuousPaper.
  ///
  /// In en, this message translates to:
  /// **'Continuous paper'**
  String get continuousPaper;

  /// No description provided for @contractSummary.
  ///
  /// In en, this message translates to:
  /// **'Contract Summary'**
  String get contractSummary;

  /// No description provided for @ordinaryStringsClickableLinkSpansWebDesc.
  ///
  /// In en, this message translates to:
  /// **'Convert ordinary strings to clickable link spans with toWebLinkSpan().'**
  String get ordinaryStringsClickableLinkSpansWebDesc;

  /// No description provided for @convertingTemplatePdfToHtml.
  ///
  /// In en, this message translates to:
  /// **'Converting template PDF to HTML…'**
  String get convertingTemplatePdfToHtml;

  /// No description provided for @copies.
  ///
  /// In en, this message translates to:
  /// **'Copies'**
  String get copies;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @copyCode.
  ///
  /// In en, this message translates to:
  /// **'Copy code'**
  String get copyCode;

  /// No description provided for @copyHtml.
  ///
  /// In en, this message translates to:
  /// **'Copy HTML'**
  String get copyHtml;

  /// No description provided for @copyWatermark.
  ///
  /// In en, this message translates to:
  /// **'Copy Watermark'**
  String get copyWatermark;

  /// No description provided for @coreBlocks.
  ///
  /// In en, this message translates to:
  /// **'Core Blocks'**
  String get coreBlocks;

  /// No description provided for @corePdfComponents.
  ///
  /// In en, this message translates to:
  /// **'Core PDF Components'**
  String get corePdfComponents;

  /// No description provided for @corporateHeaderAndInfoGroups.
  ///
  /// In en, this message translates to:
  /// **'Corporate Header & Info Groups'**
  String get corporateHeaderAndInfoGroups;

  /// No description provided for @corporateReportHeaderReusableDesc.
  ///
  /// In en, this message translates to:
  /// **'Corporate report header using reusable registration and contact information groups.'**
  String get corporateReportHeaderReusableDesc;

  /// No description provided for @costCenterStatement.
  ///
  /// In en, this message translates to:
  /// **'Cost Center Statement'**
  String get costCenterStatement;

  /// No description provided for @costCenterTrialBalance.
  ///
  /// In en, this message translates to:
  /// **'Cost Center Trial Balance'**
  String get costCenterTrialBalance;

  /// No description provided for @costOfSales.
  ///
  /// In en, this message translates to:
  /// **'Cost of Sales'**
  String get costOfSales;

  /// No description provided for @countReconciliation.
  ///
  /// In en, this message translates to:
  /// **'Count Reconciliation'**
  String get countReconciliation;

  /// No description provided for @countryTenantRegistry.
  ///
  /// In en, this message translates to:
  /// **'Country / Tenant Registry'**
  String get countryTenantRegistry;

  /// No description provided for @coverageIsPreserved.
  ///
  /// In en, this message translates to:
  /// **'Coverage is preserved'**
  String get coverageIsPreserved;

  /// No description provided for @clickableHyperlinkDirectlyGeniusPdfDesc.
  ///
  /// In en, this message translates to:
  /// **'Create a clickable hyperlink directly with GeniusPdfTextSpan.webLink().'**
  String get clickableHyperlinkDirectlyGeniusPdfDesc;

  /// No description provided for @confidentialAuditFindingsGridDesc.
  ///
  /// In en, this message translates to:
  /// **'Create a confidential audit findings grid with severity/status fields and a compact summary box.'**
  String get confidentialAuditFindingsGridDesc;

  /// No description provided for @securityAccessLogGridEventCountingDesc.
  ///
  /// In en, this message translates to:
  /// **'Create a security access-log grid with event counting, watermark guidance, and report verification QR code.'**
  String get securityAccessLogGridEventCountingDesc;

  /// No description provided for @clickableLinksGeniusPdfRichTextDesc.
  ///
  /// In en, this message translates to:
  /// **'Create clickable links through GeniusPdfRichTextBuilder.webLink(), including custom link colors.'**
  String get clickableLinksGeniusPdfRichTextDesc;

  /// No description provided for @groupedDataGridContentNestedDesc.
  ///
  /// In en, this message translates to:
  /// **'Create grouped DataGrid content with nested subgroups, subgroup summaries, group summaries, and a document-level grand total.'**
  String get groupedDataGridContentNestedDesc;

  /// No description provided for @nestedBulletContentGeniusPdfBulletDesc.
  ///
  /// In en, this message translates to:
  /// **'Create nested bullet content with GeniusPdfBulletList and GeniusPdfBulletItem.'**
  String get nestedBulletContentGeniusPdfBulletDesc;

  /// No description provided for @reusablePdfTemplatesProgrammaticallyDesc.
  ///
  /// In en, this message translates to:
  /// **'Create reusable PDF templates programmatically.'**
  String get reusablePdfTemplatesProgrammaticallyDesc;

  /// No description provided for @creditAdjustmentDocumentReturnedDesc.
  ///
  /// In en, this message translates to:
  /// **'Credit adjustment document for returned goods or invoice corrections.'**
  String get creditAdjustmentDocumentReturnedDesc;

  /// No description provided for @creditNote.
  ///
  /// In en, this message translates to:
  /// **'Credit Note'**
  String get creditNote;

  /// No description provided for @creditNoteHtmlExport.
  ///
  /// In en, this message translates to:
  /// **'Credit Note HTML Export'**
  String get creditNoteHtmlExport;

  /// No description provided for @creditNoteImageExport.
  ///
  /// In en, this message translates to:
  /// **'Credit Note Image Export'**
  String get creditNoteImageExport;

  /// No description provided for @currentSettings.
  ///
  /// In en, this message translates to:
  /// **'Current Settings'**
  String get currentSettings;

  /// No description provided for @customColorStyles.
  ///
  /// In en, this message translates to:
  /// **'Custom Color Styles'**
  String get customColorStyles;

  /// No description provided for @customLandscapePage.
  ///
  /// In en, this message translates to:
  /// **'Custom Landscape Page'**
  String get customLandscapePage;

  /// No description provided for @customPosition.
  ///
  /// In en, this message translates to:
  /// **'Custom Position'**
  String get customPosition;

  /// No description provided for @customReport.
  ///
  /// In en, this message translates to:
  /// **'Custom Report'**
  String get customReport;

  /// No description provided for @customReportBuilder.
  ///
  /// In en, this message translates to:
  /// **'Custom Report Builder'**
  String get customReportBuilder;

  /// No description provided for @customWatermark.
  ///
  /// In en, this message translates to:
  /// **'Custom Watermark'**
  String get customWatermark;

  /// No description provided for @customerAndCompanyBoxes.
  ///
  /// In en, this message translates to:
  /// **'Customer & Company Boxes'**
  String get customerAndCompanyBoxes;

  /// No description provided for @customerAccountStatementExampleDesc.
  ///
  /// In en, this message translates to:
  /// **'Customer account statement example with customer information, transaction history, balances, and bilingual output.'**
  String get customerAccountStatementExampleDesc;

  /// No description provided for @customerAging.
  ///
  /// In en, this message translates to:
  /// **'Customer Aging'**
  String get customerAging;

  /// No description provided for @customerBalances.
  ///
  /// In en, this message translates to:
  /// **'Customer Balances'**
  String get customerBalances;

  /// No description provided for @customerDetails.
  ///
  /// In en, this message translates to:
  /// **'Customer Details'**
  String get customerDetails;

  /// No description provided for @customerHistory.
  ///
  /// In en, this message translates to:
  /// **'Customer History'**
  String get customerHistory;

  /// No description provided for @customerProfile.
  ///
  /// In en, this message translates to:
  /// **'Customer Profile'**
  String get customerProfile;

  /// No description provided for @customerReceipt.
  ///
  /// In en, this message translates to:
  /// **'Customer Receipt'**
  String get customerReceipt;

  /// No description provided for @customerStatement.
  ///
  /// In en, this message translates to:
  /// **'Customer Statement'**
  String get customerStatement;

  /// No description provided for @cycleCount.
  ///
  /// In en, this message translates to:
  /// **'Cycle Count'**
  String get cycleCount;

  /// No description provided for @dartUsageCode.
  ///
  /// In en, this message translates to:
  /// **'Dart usage code'**
  String get dartUsageCode;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @dataAndTotals.
  ///
  /// In en, this message translates to:
  /// **'Data & Totals'**
  String get dataAndTotals;

  /// No description provided for @dataGrid.
  ///
  /// In en, this message translates to:
  /// **'Data Grid'**
  String get dataGrid;

  /// No description provided for @dataGridRtl.
  ///
  /// In en, this message translates to:
  /// **'Data Grid RTL'**
  String get dataGridRtl;

  /// No description provided for @dataGridSettings.
  ///
  /// In en, this message translates to:
  /// **'Data Grid Settings'**
  String get dataGridSettings;

  /// No description provided for @dataGridBaseline.
  ///
  /// In en, this message translates to:
  /// **'DataGrid Baseline'**
  String get dataGridBaseline;

  /// No description provided for @debitNote.
  ///
  /// In en, this message translates to:
  /// **'Debit Note'**
  String get debitNote;

  /// No description provided for @decimalPrecision.
  ///
  /// In en, this message translates to:
  /// **'Decimal Precision'**
  String get decimalPrecision;

  /// No description provided for @deductionsReport.
  ///
  /// In en, this message translates to:
  /// **'Deductions Report'**
  String get deductionsReport;

  /// No description provided for @defaultText.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultText;

  /// No description provided for @delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get delivery;

  /// No description provided for @deliveryAndOperations.
  ///
  /// In en, this message translates to:
  /// **'Delivery & Operations'**
  String get deliveryAndOperations;

  /// No description provided for @deliveryNote.
  ///
  /// In en, this message translates to:
  /// **'Delivery Note'**
  String get deliveryNote;

  /// No description provided for @deliveryNote2.
  ///
  /// In en, this message translates to:
  /// **'Delivery note'**
  String get deliveryNote2;

  /// No description provided for @deliveryNoteHtmlExport.
  ///
  /// In en, this message translates to:
  /// **'Delivery Note HTML Export'**
  String get deliveryNoteHtmlExport;

  /// No description provided for @deliveryNoteImageExport.
  ///
  /// In en, this message translates to:
  /// **'Delivery Note Image Export'**
  String get deliveryNoteImageExport;

  /// No description provided for @demoDocument.
  ///
  /// In en, this message translates to:
  /// **'Demo Document'**
  String get demoDocument;

  /// No description provided for @geniusPdfAutoTotalSumAverageCountDesc.
  ///
  /// In en, this message translates to:
  /// **'Demonstrate GeniusPdfAutoTotal sum, average, and count rows calculated directly from DataGrid row values.'**
  String get geniusPdfAutoTotalSumAverageCountDesc;

  /// No description provided for @mixedRichTextFontSizesTogetherDesc.
  ///
  /// In en, this message translates to:
  /// **'Demonstrate mixed rich-text font sizes together with superscript and subscript rendering.'**
  String get mixedRichTextFontSizesTogetherDesc;

  /// No description provided for @dependencyInjection.
  ///
  /// In en, this message translates to:
  /// **'Dependency Injection'**
  String get dependencyInjection;

  /// No description provided for @depositWithdrawalTransfer.
  ///
  /// In en, this message translates to:
  /// **'Deposit, withdrawal, transfer'**
  String get depositWithdrawalTransfer;

  /// No description provided for @depreciationReport.
  ///
  /// In en, this message translates to:
  /// **'Depreciation Report'**
  String get depreciationReport;

  /// No description provided for @designerMetadata.
  ///
  /// In en, this message translates to:
  /// **'Designer Metadata'**
  String get designerMetadata;

  /// No description provided for @detailedSignature.
  ///
  /// In en, this message translates to:
  /// **'Detailed Signature'**
  String get detailedSignature;

  /// No description provided for @detectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Detect Language'**
  String get detectLanguage;

  /// No description provided for @digitalSignature.
  ///
  /// In en, this message translates to:
  /// **'Digital Signature'**
  String get digitalSignature;

  /// No description provided for @digitalSignatures.
  ///
  /// In en, this message translates to:
  /// **'Digital Signatures'**
  String get digitalSignatures;

  /// No description provided for @direction.
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get direction;

  /// No description provided for @directionValueDirection.
  ///
  /// In en, this message translates to:
  /// **'Direction / Value Direction'**
  String get directionValueDirection;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @discountAfterTax.
  ///
  /// In en, this message translates to:
  /// **'Discount After Tax'**
  String get discountAfterTax;

  /// No description provided for @discountBeforeTax.
  ///
  /// In en, this message translates to:
  /// **'Discount Before Tax'**
  String get discountBeforeTax;

  /// No description provided for @discoverDevices.
  ///
  /// In en, this message translates to:
  /// **'Discover Devices'**
  String get discoverDevices;

  /// No description provided for @discoverNearbyDevicesSharePdfDesc.
  ///
  /// In en, this message translates to:
  /// **'Discover nearby devices and share PDF documents directly.'**
  String get discoverNearbyDevicesSharePdfDesc;

  /// No description provided for @discoverPrinters.
  ///
  /// In en, this message translates to:
  /// **'Discover Printers'**
  String get discoverPrinters;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @dispatchNote.
  ///
  /// In en, this message translates to:
  /// **'Dispatch Note'**
  String get dispatchNote;

  /// No description provided for @structuredCustomerCompanyDetailsSideDesc.
  ///
  /// In en, this message translates to:
  /// **'Display structured customer and company details side by side using card-style info boxes.'**
  String get structuredCustomerCompanyDetailsSideDesc;

  /// No description provided for @documentBaseCurrency.
  ///
  /// In en, this message translates to:
  /// **'Document / Base Currency'**
  String get documentBaseCurrency;

  /// No description provided for @documentBuilder.
  ///
  /// In en, this message translates to:
  /// **'Document Builder'**
  String get documentBuilder;

  /// No description provided for @documentCreatedEvent.
  ///
  /// In en, this message translates to:
  /// **'Document Created Event'**
  String get documentCreatedEvent;

  /// No description provided for @documentDirection.
  ///
  /// In en, this message translates to:
  /// **'Document direction'**
  String get documentDirection;

  /// No description provided for @documentExport.
  ///
  /// In en, this message translates to:
  /// **'Document Export'**
  String get documentExport;

  /// No description provided for @documentWatermark.
  ///
  /// In en, this message translates to:
  /// **'Document watermark'**
  String get documentWatermark;

  /// No description provided for @domesticAndInternational.
  ///
  /// In en, this message translates to:
  /// **'Domestic & international'**
  String get domesticAndInternational;

  /// No description provided for @domesticInternationalIncomingDesc.
  ///
  /// In en, this message translates to:
  /// **'Domestic and international incoming and outgoing remittance vouchers.'**
  String get domesticInternationalIncomingDesc;

  /// No description provided for @draft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get draft;

  /// No description provided for @draftWatermark.
  ///
  /// In en, this message translates to:
  /// **'Draft Watermark'**
  String get draftWatermark;

  /// No description provided for @dragDropPlusSections.
  ///
  /// In en, this message translates to:
  /// **'Drag / Drop + Sections'**
  String get dragDropPlusSections;

  /// No description provided for @dropbox.
  ///
  /// In en, this message translates to:
  /// **'Dropbox'**
  String get dropbox;

  /// No description provided for @dynamicQrCodesUrlsZatcaInvoicesWiFiDesc.
  ///
  /// In en, this message translates to:
  /// **'Dynamic QR codes for URLs, ZATCA invoices, WiFi, and contacts.'**
  String get dynamicQrCodesUrlsZatcaInvoicesWiFiDesc;

  /// No description provided for @eGMyOfficeSettings.
  ///
  /// In en, this message translates to:
  /// **'e.g., My Office Settings'**
  String get eGMyOfficeSettings;

  /// No description provided for @ean13.
  ///
  /// In en, this message translates to:
  /// **'EAN-13'**
  String get ean13;

  /// No description provided for @eco.
  ///
  /// In en, this message translates to:
  /// **'Eco'**
  String get eco;

  /// No description provided for @efficiency.
  ///
  /// In en, this message translates to:
  /// **'Efficiency'**
  String get efficiency;

  /// No description provided for @emailPrepared.
  ///
  /// In en, this message translates to:
  /// **'Email prepared!'**
  String get emailPrepared;

  /// No description provided for @emailSharing.
  ///
  /// In en, this message translates to:
  /// **'Email Sharing'**
  String get emailSharing;

  /// No description provided for @emailTemplates.
  ///
  /// In en, this message translates to:
  /// **'Email Templates'**
  String get emailTemplates;

  /// No description provided for @embedImages.
  ///
  /// In en, this message translates to:
  /// **'Embed images'**
  String get embedImages;

  /// No description provided for @employeeActionForm.
  ///
  /// In en, this message translates to:
  /// **'Employee Action Form'**
  String get employeeActionForm;

  /// No description provided for @employeeDirectoryReportDepartmentDesc.
  ///
  /// In en, this message translates to:
  /// **'Employee directory/report with department, role, status, and salary data.'**
  String get employeeDirectoryReportDepartmentDesc;

  /// No description provided for @employeeList.
  ///
  /// In en, this message translates to:
  /// **'Employee List'**
  String get employeeList;

  /// No description provided for @employeePayslip.
  ///
  /// In en, this message translates to:
  /// **'Employee payslip'**
  String get employeePayslip;

  /// No description provided for @employeePayslipEarningsAllowancesDesc.
  ///
  /// In en, this message translates to:
  /// **'Employee payslip with earnings, allowances, deductions, and net pay.'**
  String get employeePayslipEarningsAllowancesDesc;

  /// No description provided for @employeeProfile.
  ///
  /// In en, this message translates to:
  /// **'Employee Profile'**
  String get employeeProfile;

  /// No description provided for @employeeReport.
  ///
  /// In en, this message translates to:
  /// **'Employee Report'**
  String get employeeReport;

  /// No description provided for @employeeReportHtmlExport.
  ///
  /// In en, this message translates to:
  /// **'Employee Report HTML Export'**
  String get employeeReportHtmlExport;

  /// No description provided for @employeeReportImageExport.
  ///
  /// In en, this message translates to:
  /// **'Employee Report Image Export'**
  String get employeeReportImageExport;

  /// No description provided for @employmentCertificate.
  ///
  /// In en, this message translates to:
  /// **'Employment Certificate'**
  String get employmentCertificate;

  /// No description provided for @employmentContractForm.
  ///
  /// In en, this message translates to:
  /// **'Employment Contract/Form'**
  String get employmentContractForm;

  /// No description provided for @encryptionAndPermissions.
  ///
  /// In en, this message translates to:
  /// **'Encryption & Permissions'**
  String get encryptionAndPermissions;

  /// No description provided for @endOfService.
  ///
  /// In en, this message translates to:
  /// **'End-of-Service'**
  String get endOfService;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @englishArabicSplitHeaderCenteredDesc.
  ///
  /// In en, this message translates to:
  /// **'English/Arabic split header with centered identity and stable positioning in both directions.'**
  String get englishArabicSplitHeaderCenteredDesc;

  /// No description provided for @equipmentPurchase.
  ///
  /// In en, this message translates to:
  /// **'Equipment purchase'**
  String get equipmentPurchase;

  /// No description provided for @equity.
  ///
  /// In en, this message translates to:
  /// **'Equity'**
  String get equity;

  /// No description provided for @erpFormattingAccounting.
  ///
  /// In en, this message translates to:
  /// **'ERP Formatting / Accounting'**
  String get erpFormattingAccounting;

  /// No description provided for @erpValueMatrix.
  ///
  /// In en, this message translates to:
  /// **'ERP Value Matrix'**
  String get erpValueMatrix;

  /// No description provided for @eventDrivenArchitecture.
  ///
  /// In en, this message translates to:
  /// **'Event-driven Architecture'**
  String get eventDrivenArchitecture;

  /// No description provided for @exchangeReceipt.
  ///
  /// In en, this message translates to:
  /// **'Exchange Receipt'**
  String get exchangeReceipt;

  /// No description provided for @executionStatus.
  ///
  /// In en, this message translates to:
  /// **'Execution status'**
  String get executionStatus;

  /// No description provided for @exerciseSemanticRegressionCheckerErpDesc.
  ///
  /// In en, this message translates to:
  /// **'Exercise the semantic-regression checker with ERP document fields and verify the expected values remain discoverable in LTR and RTL.'**
  String get exerciseSemanticRegressionCheckerErpDesc;

  /// No description provided for @existingSecurityAdapter.
  ///
  /// In en, this message translates to:
  /// **'Existing Security Adapter'**
  String get existingSecurityAdapter;

  /// No description provided for @expenseRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Expense Recommendations'**
  String get expenseRecommendations;

  /// No description provided for @experienceCertificate.
  ///
  /// In en, this message translates to:
  /// **'Experience Certificate'**
  String get experienceCertificate;

  /// No description provided for @expiryReport.
  ///
  /// In en, this message translates to:
  /// **'Expiry Report'**
  String get expiryReport;

  /// No description provided for @explicitEmptyState.
  ///
  /// In en, this message translates to:
  /// **'Explicit Empty State'**
  String get explicitEmptyState;

  /// No description provided for @documentGenerationReusablePdfDesc.
  ///
  /// In en, this message translates to:
  /// **'Explore document generation, reusable PDF components, RTL/LTR behavior, templates, delivery workflows, job queues, security, and advanced package modules without losing any existing example coverage.'**
  String get documentGenerationReusablePdfDesc;

  /// No description provided for @exportText.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get exportText;

  /// No description provided for @exportCompletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Export completed successfully.'**
  String get exportCompletedSuccessfully;

  /// No description provided for @exportPdfPagesHighQualityPngDesc.
  ///
  /// In en, this message translates to:
  /// **'Export PDF pages as high-quality PNG or compressed JPEG images.'**
  String get exportPdfPagesHighQualityPngDesc;

  /// No description provided for @exportTemplateToJson.
  ///
  /// In en, this message translates to:
  /// **'Export Template to JSON'**
  String get exportTemplateToJson;

  /// No description provided for @exportToAllFormats.
  ///
  /// In en, this message translates to:
  /// **'Export to All Formats'**
  String get exportToAllFormats;

  /// No description provided for @exportHtmlPlainTextPdfArchivalFormatDesc.
  ///
  /// In en, this message translates to:
  /// **'Export to HTML, plain text, or PDF/A archival format.'**
  String get exportHtmlPlainTextPdfArchivalFormatDesc;

  /// No description provided for @exportMultipleFormatsSimultaneouslyDesc.
  ///
  /// In en, this message translates to:
  /// **'Export to multiple formats simultaneously in background.'**
  String get exportMultipleFormatsSimultaneouslyDesc;

  /// No description provided for @exportSaveOpenWorkflowsSharingDesc.
  ///
  /// In en, this message translates to:
  /// **'Export, save/open workflows, sharing, printing profiles, and security/compliance examples.'**
  String get exportSaveOpenWorkflowsSharingDesc;

  /// No description provided for @extractKeywords.
  ///
  /// In en, this message translates to:
  /// **'Extract Keywords'**
  String get extractKeywords;

  /// No description provided for @extractStructuredData.
  ///
  /// In en, this message translates to:
  /// **'Extract Structured Data'**
  String get extractStructuredData;

  /// No description provided for @extractTextDetectDocumentTypesFindDesc.
  ///
  /// In en, this message translates to:
  /// **'Extract text, detect document types, find keywords and structured data from PDF content'**
  String get extractTextDetectDocumentTypesFindDesc;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @familyBenchmark.
  ///
  /// In en, this message translates to:
  /// **'Family Benchmark'**
  String get familyBenchmark;

  /// No description provided for @finalInspection.
  ///
  /// In en, this message translates to:
  /// **'Final Inspection'**
  String get finalInspection;

  /// No description provided for @finalSettlement.
  ///
  /// In en, this message translates to:
  /// **'Final Settlement'**
  String get finalSettlement;

  /// No description provided for @financialAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Financial Analysis'**
  String get financialAnalysis;

  /// No description provided for @financialSemanticBlocks.
  ///
  /// In en, this message translates to:
  /// **'Financial Semantic Blocks'**
  String get financialSemanticBlocks;

  /// No description provided for @financialTemplates.
  ///
  /// In en, this message translates to:
  /// **'Financial Templates'**
  String get financialTemplates;

  /// No description provided for @financialTrialBalanceReportDesc.
  ///
  /// In en, this message translates to:
  /// **'Financial trial-balance report with categorized accounts, debit and credit columns, totals, signatures, and QR support.'**
  String get financialTrialBalanceReportDesc;

  /// No description provided for @findAndViewAvailablePrintersOnYourSystem.
  ///
  /// In en, this message translates to:
  /// **'Find and view available printers on your system.'**
  String get findAndViewAvailablePrintersOnYourSystem;

  /// No description provided for @flowLayoutPaginationPageSetupDesc.
  ///
  /// In en, this message translates to:
  /// **'Flow layout, pagination, page setup, and document construction.'**
  String get flowLayoutPaginationPageSetupDesc;

  /// No description provided for @fluentApi.
  ///
  /// In en, this message translates to:
  /// **'Fluent API'**
  String get fluentApi;

  /// No description provided for @fluentApiDemo.
  ///
  /// In en, this message translates to:
  /// **'Fluent API demo'**
  String get fluentApiDemo;

  /// No description provided for @fluentFormatting.
  ///
  /// In en, this message translates to:
  /// **'Fluent Formatting'**
  String get fluentFormatting;

  /// No description provided for @s01AutoInheritanceVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S01 verification for AUTO Inheritance. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s01AutoInheritanceVerify;

  /// No description provided for @s01ErpValueMatrixVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S01 verification for ERP Value Matrix. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s01ErpValueMatrixVerify;

  /// No description provided for @s01LegacyTemplateJsonVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S01 verification for Legacy Template JSON. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s01LegacyTemplateJsonVerify;

  /// No description provided for @s01LogicalGeometryVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S01 verification for Logical Geometry. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s01LogicalGeometryVerify;

  /// No description provided for @s01LongMultiPageVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S01 verification for Long + Multi-page. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s01LongMultiPageVerify;

  /// No description provided for @s01MediaPreservePolicyVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S01 verification for Media Preserve Policy. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s01MediaPreservePolicyVerify;

  /// No description provided for @s01MixedArabicLatinVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S01 verification for Mixed Arabic / Latin. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s01MixedArabicLatinVerify;

  /// No description provided for @s01NestedOverridesVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S01 verification for Nested Overrides. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s01NestedOverridesVerify;

  /// No description provided for @s01ResolverPrecedenceVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S01 verification for Resolver Precedence. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s01ResolverPrecedenceVerify;

  /// No description provided for @s02ComponentMatrixVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S02 verification for Component Matrix. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s02ComponentMatrixVerify;

  /// No description provided for @s02DataGridRtlVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S02 verification for Data Grid RTL. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s02DataGridRtlVerify;

  /// No description provided for @s02InfoBoxRtlVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S02 verification for Info Box RTL. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s02InfoBoxRtlVerify;

  /// No description provided for @s02LongMultiPageRtlVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S02 verification for Long + Multi-page RTL. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s02LongMultiPageRtlVerify;

  /// No description provided for @s02MediaDirectionPolicyVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S02 verification for Media Direction Policy. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s02MediaDirectionPolicyVerify;

  /// No description provided for @s02NestedDirectionOverrideVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S02 verification for Nested Direction Override. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s02NestedDirectionOverrideVerify;

  /// No description provided for @s02ReportHeaderRtlVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S02 verification for Report Header RTL. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s02ReportHeaderRtlVerify;

  /// No description provided for @s02RichTextRtlVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S02 verification for Rich Text RTL. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s02RichTextRtlVerify;

  /// No description provided for @s02SummaryRtlVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S02 verification for Summary RTL. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s02SummaryRtlVerify;

  /// No description provided for @s031PageDocumentVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S03 verification for 1-page Document. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s031PageDocumentVerify;

  /// No description provided for @s0350RowsMultiPageVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S03 verification for 50 Rows / Multi-page. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s0350RowsMultiPageVerify;

  /// No description provided for @s03500RowStressVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S03 verification for 500-row Stress. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s03500RowStressVerify;

  /// No description provided for @s03CustomLandscapePageVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S03 verification for Custom Landscape Page. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s03CustomLandscapePageVerify;

  /// No description provided for @s03KeepTogetherKeepNextVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S03 verification for Keep Together / Keep With Next. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s03KeepTogetherKeepNextVerify;

  /// No description provided for @s03LegacyCallbackAdapterVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S03 verification for Legacy Callback Adapter. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s03LegacyCallbackAdapterVerify;

  /// No description provided for @s03LongNotesOrphanWidowVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S03 verification for Long Notes + Orphan/Widow. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s03LongNotesOrphanWidowVerify;

  /// No description provided for @s03PageMetadataMarkersVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S03 verification for Page Metadata / Markers. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s03PageMetadataMarkersVerify;

  /// No description provided for @s03RepeatedHeadersFootersVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S03 verification for Repeated Headers / Footers. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s03RepeatedHeadersFootersVerify;

  /// No description provided for @s041KRowLargeDataModeVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S04 verification for 1k-row Large-data Mode. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s041KRowLargeDataModeVerify;

  /// No description provided for @s04ColumnSizingVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S04 verification for Column Sizing. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s04ColumnSizingVerify;

  /// No description provided for @s04ErpFormattingAccountingVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S04 verification for ERP Formatting / Accounting. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s04ErpFormattingAccountingVerify;

  /// No description provided for @s04LongContentOverflowVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S04 verification for Long Content / Overflow. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s04LongContentOverflowVerify;

  /// No description provided for @s04MultiPageRepeatedHeaderVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S04 verification for Multi-page / Repeated Header. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s04MultiPageRepeatedHeaderVerify;

  /// No description provided for @s04NestedGroupsSubtotalsVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S04 verification for Nested Groups / Subtotals. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s04NestedGroupsSubtotalsVerify;

  /// No description provided for @s04NullEmptyStateVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S04 verification for Null / Empty State. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s04NullEmptyStateVerify;

  /// No description provided for @s04RtlPerColumnDirectionVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S04 verification for RTL / Per-column Direction. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s04RtlPerColumnDirectionVerify;

  /// No description provided for @s04SpansBuildersConditionalStyleVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S04 verification for Spans / Builders / Conditional Style. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s04SpansBuildersConditionalStyleVerify;

  /// No description provided for @s05ArabicLatinDigitsVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S05 verification for Arabic / Latin Digits. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s05ArabicLatinDigitsVerify;

  /// No description provided for @s05DecimalPrecisionVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S05 verification for Decimal Precision. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s05DecimalPrecisionVerify;

  /// No description provided for @s05LongMultiPageTableVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S05 verification for Long Multi-page Table. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s05LongMultiPageTableVerify;

  /// No description provided for @s05MultiCurrencyVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S05 verification for Multi-currency. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s05MultiCurrencyVerify;

  /// No description provided for @s05NegativeAccountingVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S05 verification for Negative Accounting. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s05NegativeAccountingVerify;

  /// No description provided for @s05NullUnitsExchangeRateVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S05 verification for Null / Units / Exchange Rate. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s05NullUnitsExchangeRateVerify;

  /// No description provided for @s05SummaryGridInfoConsistencyVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S05 verification for Summary / Grid / Info Consistency. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s05SummaryGridInfoConsistencyVerify;

  /// No description provided for @s05ThemeDesignTokensVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S05 verification for Theme / Design Tokens. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s05ThemeDesignTokensVerify;

  /// No description provided for @s06BaselineCalculationVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S06 verification for Baseline Calculation. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s06BaselineCalculationVerify;

  /// No description provided for @s06DiscountAfterTaxVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S06 verification for Discount After Tax. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s06DiscountAfterTaxVerify;

  /// No description provided for @s06DiscountBeforeTaxVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S06 verification for Discount Before Tax. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s06DiscountBeforeTaxVerify;

  /// No description provided for @s06DocumentBaseCurrencyVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S06 verification for Document / Base Currency. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s06DocumentBaseCurrencyVerify;

  /// No description provided for @s06LongMultiPageDomainVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S06 verification for Long / Multi-page Domain. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s06LongMultiPageDomainVerify;

  /// No description provided for @s06MultiTaxCompoundVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S06 verification for Multi-tax / Compound. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s06MultiTaxCompoundVerify;

  /// No description provided for @s06NullOptionalMetadataVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S06 verification for Null Optional Metadata. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s06NullOptionalMetadataVerify;

  /// No description provided for @s06PaidDueVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S06 verification for Paid / Due. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s06PaidDueVerify;

  /// No description provided for @s06RoundingAdjustmentVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S06 verification for Rounding Adjustment. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s06RoundingAdjustmentVerify;

  /// No description provided for @s06ZeroNegativePolicyVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S06 verification for Zero / Negative Policy. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s06ZeroNegativePolicyVerify;

  /// No description provided for @s07BilingualMixedValuesVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S07 verification for Bilingual Mixed Values. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s07BilingualMixedValuesVerify;

  /// No description provided for @s07ExplicitEmptyStateVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S07 verification for Explicit Empty State. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s07ExplicitEmptyStateVerify;

  /// No description provided for @s07FinancialSemanticBlocksVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S07 verification for Financial Semantic Blocks. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s07FinancialSemanticBlocksVerify;

  /// No description provided for @s07IdentityPartyAddressVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S07 verification for Identity / Party / Address. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s07IdentityPartyAddressVerify;

  /// No description provided for @s07LongMultiPageSemanticsVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S07 verification for Long / Multi-page Semantics. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s07LongMultiPageSemanticsVerify;

  /// No description provided for @s07NullCollapseNoGapVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S07 verification for Null Collapse / No Gap. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s07NullCollapseNoGapVerify;

  /// No description provided for @s07OperationalComponentsVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S07 verification for Operational Components. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s07OperationalComponentsVerify;

  /// No description provided for @s07ReusableCompositionVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S07 verification for Reusable Composition. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.'**
  String get s07ReusableCompositionVerify;

  /// No description provided for @s08AnalyticalReportVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S08 verification for Analytical report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s08AnalyticalReportVerify;

  /// No description provided for @s08CertificateVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S08 verification for Certificate. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s08CertificateVerify;

  /// No description provided for @s08LabelVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S08 verification for Label. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s08LabelVerify;

  /// No description provided for @s08LongMultiPageTransactionVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S08 verification for Long multi-page transaction. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s08LongMultiPageTransactionVerify;

  /// No description provided for @s08OperationalFormVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S08 verification for Operational form. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s08OperationalFormVerify;

  /// No description provided for @s08RegisterVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S08 verification for Register. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s08RegisterVerify;

  /// No description provided for @s08ReplacementCustomSectionVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S08 verification for Replacement / custom section. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s08ReplacementCustomSectionVerify;

  /// No description provided for @s08StatementFamilyVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S08 verification for Statement family. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s08StatementFamilyVerify;

  /// No description provided for @s08ThermalReceiptVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S08 verification for Thermal receipt. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s08ThermalReceiptVerify;

  /// No description provided for @s08TransactionFamilyVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S08 verification for Transaction family. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s08TransactionFamilyVerify;

  /// No description provided for @s08VoucherFamilyVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S08 verification for Voucher family. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s08VoucherFamilyVerify;

  /// No description provided for @s09BilingualRtlStructuredValuesVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S09 verification for Bilingual / RTL structured values. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s09BilingualRtlStructuredValuesVerify;

  /// No description provided for @s09LongPartyNotesTermsVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S09 verification for Long party / notes / terms. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s09LongPartyNotesTermsVerify;

  /// No description provided for @s09NullOptionalSectionsVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S09 verification for Null optional sections. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s09NullOptionalSectionsVerify;

  /// No description provided for @s09PurchaseOrder50LinesVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S09 verification for Purchase Order — 50 lines. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s09PurchaseOrder50LinesVerify;

  /// No description provided for @s09Quotation1LineVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S09 verification for Quotation — 1 line. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s09Quotation1LineVerify;

  /// No description provided for @s09TaxInvoice500LinesVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S09 verification for Tax Invoice — 500 lines. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s09TaxInvoice500LinesVerify;

  /// No description provided for @s10TemplateFamilyAuditVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S10 verification for Template Family Audit. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s10TemplateFamilyAuditVerify;

  /// No description provided for @s1158MmThermalVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S11 verification for 58mm thermal. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s1158MmThermalVerify;

  /// No description provided for @s1180MmThermalVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S11 verification for 80mm thermal. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s1180MmThermalVerify;

  /// No description provided for @s114LandscapeVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S11 verification for A4 landscape. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s114LandscapeVerify;

  /// No description provided for @s114PortraitVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S11 verification for A4 portrait. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s114PortraitVerify;

  /// No description provided for @s115Verify.
  ///
  /// In en, this message translates to:
  /// **'Focused S11 verification for A5. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s115Verify;

  /// No description provided for @s11CalibrationPageVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S11 verification for Calibration page. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s11CalibrationPageVerify;

  /// No description provided for @s11ContinuousPaperVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S11 verification for Continuous paper. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s11ContinuousPaperVerify;

  /// No description provided for @s11LabelSheetVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S11 verification for Label sheet. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s11LabelSheetVerify;

  /// No description provided for @s11LegalVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S11 verification for Legal. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s11LegalVerify;

  /// No description provided for @s11LetterVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S11 verification for Letter. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s11LetterVerify;

  /// No description provided for @s11PrePrintedPhysicalAnchorsVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S11 verification for Pre-printed physical anchors. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s11PrePrintedPhysicalAnchorsVerify;

  /// No description provided for @s11SingleLabelVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S11 verification for Single label. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s11SingleLabelVerify;

  /// No description provided for @s12BackorderVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S12 verification for Backorder. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s12BackorderVerify;

  /// No description provided for @s12CommissionReportVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S12 verification for Commission Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s12CommissionReportVerify;

  /// No description provided for @s12CustomerAgingVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S12 verification for Customer Aging. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s12CustomerAgingVerify;

  /// No description provided for @s12CustomerReceiptVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S12 verification for Customer Receipt. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s12CustomerReceiptVerify;

  /// No description provided for @s12DebitNoteVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S12 verification for Debit Note. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s12DebitNoteVerify;

  /// No description provided for @s12PackingListVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S12 verification for Packing List. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s12PackingListVerify;

  /// No description provided for @s12PickingListVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S12 verification for Picking List. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s12PickingListVerify;

  /// No description provided for @s12PriceListVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S12 verification for Price List. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s12PriceListVerify;

  /// No description provided for @s12ProformaInvoiceVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S12 verification for Proforma Invoice. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s12ProformaInvoiceVerify;

  /// No description provided for @s12SalesCustomerVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S12 verification for Sales by Customer. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s12SalesCustomerVerify;

  /// No description provided for @s12SalesItemVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S12 verification for Sales by Item. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s12SalesItemVerify;

  /// No description provided for @s12SalesSalespersonVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S12 verification for Sales by Salesperson. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s12SalesSalespersonVerify;

  /// No description provided for @s12SalesOrderVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S12 verification for Sales Order. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s12SalesOrderVerify;

  /// No description provided for @s12SalesRegisterVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S12 verification for Sales Register. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s12SalesRegisterVerify;

  /// No description provided for @s12SalesReturnVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S12 verification for Sales Return. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s12SalesReturnVerify;

  /// No description provided for @s12SimplifiedPosInvoiceVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S12 verification for Simplified / POS Invoice. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s12SimplifiedPosInvoiceVerify;

  /// No description provided for @s13GoodsReceiptNoteVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S13 verification for Goods Receipt Note. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s13GoodsReceiptNoteVerify;

  /// No description provided for @s13OutstandingPurchaseOrdersVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S13 verification for Outstanding Purchase Orders. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s13OutstandingPurchaseOrdersVerify;

  /// No description provided for @s13PurchaseAnalysisVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S13 verification for Purchase Analysis. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s13PurchaseAnalysisVerify;

  /// No description provided for @s13PurchaseCreditNoteVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S13 verification for Purchase Credit Note. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s13PurchaseCreditNoteVerify;

  /// No description provided for @s13PurchaseDebitNoteVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S13 verification for Purchase Debit Note. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s13PurchaseDebitNoteVerify;

  /// No description provided for @s13PurchaseInvoiceVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S13 verification for Purchase Invoice. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s13PurchaseInvoiceVerify;

  /// No description provided for @s13PurchaseOrderVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S13 verification for Purchase Order. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s13PurchaseOrderVerify;

  /// No description provided for @s13PurchaseRegisterVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S13 verification for Purchase Register. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s13PurchaseRegisterVerify;

  /// No description provided for @s13PurchaseRequisitionVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S13 verification for Purchase Requisition. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s13PurchaseRequisitionVerify;

  /// No description provided for @s13QuotationComparisonVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S13 verification for Quotation Comparison. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s13QuotationComparisonVerify;

  /// No description provided for @s13RequestQuotationVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S13 verification for Request for Quotation. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s13RequestQuotationVerify;

  /// No description provided for @s13SupplierAgingVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S13 verification for Supplier Aging. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s13SupplierAgingVerify;

  /// No description provided for @s13SupplierQuotationVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S13 verification for Supplier Quotation. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s13SupplierQuotationVerify;

  /// No description provided for @s13SupplierReturnVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S13 verification for Supplier Return. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s13SupplierReturnVerify;

  /// No description provided for @s13SupplierStatementVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S13 verification for Supplier Statement. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s13SupplierStatementVerify;

  /// No description provided for @s14AccountStatementVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S14 verification for Account Statement. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s14AccountStatementVerify;

  /// No description provided for @s14ApAgingVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S14 verification for AP Aging. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s14ApAgingVerify;

  /// No description provided for @s14ArAgingVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S14 verification for AR Aging. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s14ArAgingVerify;

  /// No description provided for @s14BankBookVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S14 verification for Bank Book. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s14BankBookVerify;

  /// No description provided for @s14BankReconciliationVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S14 verification for Bank Reconciliation. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s14BankReconciliationVerify;

  /// No description provided for @s14BudgetVsActualVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S14 verification for Budget vs Actual. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s14BudgetVsActualVerify;

  /// No description provided for @s14CashBookVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S14 verification for Cash Book. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s14CashBookVerify;

  /// No description provided for @s14CostCenterStatementVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S14 verification for Cost Center Statement. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s14CostCenterStatementVerify;

  /// No description provided for @s14CostCenterTrialBalanceVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S14 verification for Cost Center Trial Balance. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s14CostCenterTrialBalanceVerify;

  /// No description provided for @s14CustomerBalancesVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S14 verification for Customer Balances. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s14CustomerBalancesVerify;

  /// No description provided for @s14GeneralLedgerVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S14 verification for General Ledger. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s14GeneralLedgerVerify;

  /// No description provided for @s14JournalEntryVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S14 verification for Journal Entry. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s14JournalEntryVerify;

  /// No description provided for @s14JournalRegisterVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S14 verification for Journal Register. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s14JournalRegisterVerify;

  /// No description provided for @s14MultiPeriodComparisonVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S14 verification for Multi-period Comparison. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s14MultiPeriodComparisonVerify;

  /// No description provided for @s14PaymentRegisterVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S14 verification for Payment Register. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s14PaymentRegisterVerify;

  /// No description provided for @s14PettyCashVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S14 verification for Petty Cash. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s14PettyCashVerify;

  /// No description provided for @s14ProjectFinancialVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S14 verification for Project Financial. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s14ProjectFinancialVerify;

  /// No description provided for @s14ReceiptRegisterVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S14 verification for Receipt Register. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s14ReceiptRegisterVerify;

  /// No description provided for @s14RoundingReconciliationVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S14 verification for Rounding / Reconciliation. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s14RoundingReconciliationVerify;

  /// No description provided for @s14SupplierBalancesVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S14 verification for Supplier Balances. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s14SupplierBalancesVerify;

  /// No description provided for @s14TaxBreakdownVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S14 verification for Tax Breakdown. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s14TaxBreakdownVerify;

  /// No description provided for @s14TaxRegisterVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S14 verification for Tax Register. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s14TaxRegisterVerify;

  /// No description provided for @s14VatTaxSummaryVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S14 verification for VAT / Tax Summary. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s14VatTaxSummaryVerify;

  /// No description provided for @s15BatchLabelVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S15 verification for Batch Label. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s15BatchLabelVerify;

  /// No description provided for @s15BatchReportVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S15 verification for Batch Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s15BatchReportVerify;

  /// No description provided for @s15CountReconciliationVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S15 verification for Count Reconciliation. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s15CountReconciliationVerify;

  /// No description provided for @s15CycleCountVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S15 verification for Cycle Count. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s15CycleCountVerify;

  /// No description provided for @s15ExpiryReportVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S15 verification for Expiry Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s15ExpiryReportVerify;

  /// No description provided for @s15ItemCardVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S15 verification for Item Card. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s15ItemCardVerify;

  /// No description provided for @s15ItemLabelVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S15 verification for Item Label. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s15ItemLabelVerify;

  /// No description provided for @s15LocationLabelVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S15 verification for Location Label. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s15LocationLabelVerify;

  /// No description provided for @s15MinMaxReportVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S15 verification for Min / Max Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s15MinMaxReportVerify;

  /// No description provided for @s15ReorderReportVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S15 verification for Reorder Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s15ReorderReportVerify;

  /// No description provided for @s15SerialLabelVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S15 verification for Serial Label. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s15SerialLabelVerify;

  /// No description provided for @s15SerialReportVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S15 verification for Serial Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s15SerialReportVerify;

  /// No description provided for @s15ShelfLabelVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S15 verification for Shelf Label. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s15ShelfLabelVerify;

  /// No description provided for @s15SlowDeadStockVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S15 verification for Slow / Dead Stock. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s15SlowDeadStockVerify;

  /// No description provided for @s15StockAdjustmentVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S15 verification for Stock Adjustment. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s15StockAdjustmentVerify;

  /// No description provided for @s15StockAvailabilityVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S15 verification for Stock Availability. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s15StockAvailabilityVerify;

  /// No description provided for @s15StockCountVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S15 verification for Stock Count. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s15StockCountVerify;

  /// No description provided for @s15StockIssueVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S15 verification for Stock Issue. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s15StockIssueVerify;

  /// No description provided for @s15StockLedgerVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S15 verification for Stock Ledger. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s15StockLedgerVerify;

  /// No description provided for @s15StockReceiptVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S15 verification for Stock Receipt. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s15StockReceiptVerify;

  /// No description provided for @s15StockTransferVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S15 verification for Stock Transfer. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s15StockTransferVerify;

  /// No description provided for @s15StockValuationVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S15 verification for Stock Valuation. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s15StockValuationVerify;

  /// No description provided for @s15WarehouseTransferVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S15 verification for Warehouse Transfer. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s15WarehouseTransferVerify;

  /// No description provided for @s1658MmReceiptVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S16 verification for 58mm Receipt. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s1658MmReceiptVerify;

  /// No description provided for @s1680MmReceiptVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S16 verification for 80mm Receipt. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s1680MmReceiptVerify;

  /// No description provided for @s16BarcodeLabelVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S16 verification for Barcode Label. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s16BarcodeLabelVerify;

  /// No description provided for @s16CashDrawerVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S16 verification for Cash Drawer. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s16CashDrawerVerify;

  /// No description provided for @s16ExchangeReceiptVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S16 verification for Exchange Receipt. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s16ExchangeReceiptVerify;

  /// No description provided for @s16GiftReceiptVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S16 verification for Gift Receipt. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s16GiftReceiptVerify;

  /// No description provided for @s16KitchenOrderTicketVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S16 verification for Kitchen Order Ticket. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s16KitchenOrderTicketVerify;

  /// No description provided for @s16PaymentMethodSummaryVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S16 verification for Payment Method Summary. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s16PaymentMethodSummaryVerify;

  /// No description provided for @s16PriceLabelVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S16 verification for Price Label. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s16PriceLabelVerify;

  /// No description provided for @s16PromotionLabelVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S16 verification for Promotion Label. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s16PromotionLabelVerify;

  /// No description provided for @s16RefundReceiptVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S16 verification for Refund Receipt. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s16RefundReceiptVerify;

  /// No description provided for @s16ShiftCloseVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S16 verification for Shift Close. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s16ShiftCloseVerify;

  /// No description provided for @s16ShiftOpenVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S16 verification for Shift Open. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s16ShiftOpenVerify;

  /// No description provided for @s16XReportVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S16 verification for X Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s16XReportVerify;

  /// No description provided for @s16ZReportVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S16 verification for Z Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s16ZReportVerify;

  /// No description provided for @s17AllowancesReportVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S17 verification for Allowances Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s17AllowancesReportVerify;

  /// No description provided for @s17AttendanceReportVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S17 verification for Attendance Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s17AttendanceReportVerify;

  /// No description provided for @s17DeductionsReportVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S17 verification for Deductions Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s17DeductionsReportVerify;

  /// No description provided for @s17EmployeeActionFormVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S17 verification for Employee Action Form. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s17EmployeeActionFormVerify;

  /// No description provided for @s17EmployeeListVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S17 verification for Employee List. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s17EmployeeListVerify;

  /// No description provided for @s17EmployeeProfileVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S17 verification for Employee Profile. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s17EmployeeProfileVerify;

  /// No description provided for @s17EmploymentCertificateVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S17 verification for Employment Certificate. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s17EmploymentCertificateVerify;

  /// No description provided for @s17EmploymentContractFormVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S17 verification for Employment Contract/Form. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s17EmploymentContractFormVerify;

  /// No description provided for @s17EndServiceVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S17 verification for End-of-Service. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s17EndServiceVerify;

  /// No description provided for @s17ExperienceCertificateVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S17 verification for Experience Certificate. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s17ExperienceCertificateVerify;

  /// No description provided for @s17FinalSettlementVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S17 verification for Final Settlement. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s17FinalSettlementVerify;

  /// No description provided for @s17LeaveBalanceVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S17 verification for Leave Balance. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s17LeaveBalanceVerify;

  /// No description provided for @s17LeaveRequestVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S17 verification for Leave Request. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s17LeaveRequestVerify;

  /// No description provided for @s17LoanAdvanceVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S17 verification for Loan / Advance. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s17LoanAdvanceVerify;

  /// No description provided for @s17OvertimeReportVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S17 verification for Overtime Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s17OvertimeReportVerify;

  /// No description provided for @s17PayrollSheetVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S17 verification for Payroll Sheet. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s17PayrollSheetVerify;

  /// No description provided for @s17PayrollSummaryVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S17 verification for Payroll Summary. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s17PayrollSummaryVerify;

  /// No description provided for @s17PayslipVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S17 verification for Payslip. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s17PayslipVerify;

  /// No description provided for @s17SalaryCertificateVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S17 verification for Salary Certificate. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s17SalaryCertificateVerify;

  /// No description provided for @s17TimesheetVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S17 verification for Timesheet. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s17TimesheetVerify;

  /// No description provided for @s18AuditFormVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S18 verification for Audit Form. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s18AuditFormVerify;

  /// No description provided for @s18BillMaterialsVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S18 verification for Bill of Materials. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s18BillMaterialsVerify;

  /// No description provided for @s18CalibrationRecordVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S18 verification for Calibration Record. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s18CalibrationRecordVerify;

  /// No description provided for @s18CapaVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S18 verification for CAPA. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s18CapaVerify;

  /// No description provided for @s18CertificateAnalysisVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S18 verification for Certificate of Analysis. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s18CertificateAnalysisVerify;

  /// No description provided for @s18FinalInspectionVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S18 verification for Final Inspection. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s18FinalInspectionVerify;

  /// No description provided for @s18ProcessInspectionVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S18 verification for In-process Inspection. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s18ProcessInspectionVerify;

  /// No description provided for @s18IncomingInspectionVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S18 verification for Incoming Inspection. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s18IncomingInspectionVerify;

  /// No description provided for @s18JobCardVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S18 verification for Job Card. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s18JobCardVerify;

  /// No description provided for @s18LaborReportVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S18 verification for Labor Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s18LaborReportVerify;

  /// No description provided for @s18MachineOperationVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S18 verification for Machine Operation. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s18MachineOperationVerify;

  /// No description provided for @s18MaterialIssueVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S18 verification for Material Issue. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s18MaterialIssueVerify;

  /// No description provided for @s18MaterialRequirementVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S18 verification for Material Requirement. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s18MaterialRequirementVerify;

  /// No description provided for @s18MaterialReturnVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S18 verification for Material Return. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s18MaterialReturnVerify;

  /// No description provided for @s18NcrVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S18 verification for NCR. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s18NcrVerify;

  /// No description provided for @s18NestedOperationMaterialTablesVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S18 verification for Nested Operation / Material Tables. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s18NestedOperationMaterialTablesVerify;

  /// No description provided for @s18ProductionOrderVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S18 verification for Production Order. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s18ProductionOrderVerify;

  /// No description provided for @s18ProductionReceiptVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S18 verification for Production Receipt. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s18ProductionReceiptVerify;

  /// No description provided for @s18ProductionVarianceVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S18 verification for Production Variance. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s18ProductionVarianceVerify;

  /// No description provided for @s18QualityChecklistVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S18 verification for Quality Checklist. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s18QualityChecklistVerify;

  /// No description provided for @s18QualityInspectionVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S18 verification for Quality Inspection. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s18QualityInspectionVerify;

  /// No description provided for @s18RoutingTravelerVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S18 verification for Routing / Traveler. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s18RoutingTravelerVerify;

  /// No description provided for @s18ScrapReportVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S18 verification for Scrap Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s18ScrapReportVerify;

  /// No description provided for @s18WorkProgressVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S18 verification for Work in Progress. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s18WorkProgressVerify;

  /// No description provided for @s18WorkOrderVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S18 verification for Work Order. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s18WorkOrderVerify;

  /// No description provided for @s19AssetAssignmentVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S19 verification for Asset Assignment. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s19AssetAssignmentVerify;

  /// No description provided for @s19AssetCardVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S19 verification for Asset Card. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s19AssetCardVerify;

  /// No description provided for @s19AssetCountVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S19 verification for Asset Count. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s19AssetCountVerify;

  /// No description provided for @s19AssetDisposalVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S19 verification for Asset Disposal. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s19AssetDisposalVerify;

  /// No description provided for @s19AssetLabelVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S19 verification for Asset Label. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s19AssetLabelVerify;

  /// No description provided for @s19AssetMaintenanceVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S19 verification for Asset Maintenance. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s19AssetMaintenanceVerify;

  /// No description provided for @s19AssetMovementVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S19 verification for Asset Movement. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s19AssetMovementVerify;

  /// No description provided for @s19AssetRegisterVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S19 verification for Asset Register. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s19AssetRegisterVerify;

  /// No description provided for @s19AssetReturnVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S19 verification for Asset Return. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s19AssetReturnVerify;

  /// No description provided for @s19AssetTransferVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S19 verification for Asset Transfer. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s19AssetTransferVerify;

  /// No description provided for @s19CompletionCertificateVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S19 verification for Completion Certificate. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s19CompletionCertificateVerify;

  /// No description provided for @s19DepreciationReportVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S19 verification for Depreciation Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s19DepreciationReportVerify;

  /// No description provided for @s19MilestoneReportVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S19 verification for Milestone Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s19MilestoneReportVerify;

  /// No description provided for @s19MultiPeriodFinancialsVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S19 verification for Multi-period Financials. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s19MultiPeriodFinancialsVerify;

  /// No description provided for @s19ProgressReportVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S19 verification for Progress Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s19ProgressReportVerify;

  /// No description provided for @s19ProjectBillingVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S19 verification for Project Billing. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s19ProjectBillingVerify;

  /// No description provided for @s19ProjectBudgetVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S19 verification for Project Budget. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s19ProjectBudgetVerify;

  /// No description provided for @s19ProjectCostVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S19 verification for Project Cost. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s19ProjectCostVerify;

  /// No description provided for @s19ProjectExpenseVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S19 verification for Project Expense. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s19ProjectExpenseVerify;

  /// No description provided for @s19ProjectProfitabilityVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S19 verification for Project Profitability. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s19ProjectProfitabilityVerify;

  /// No description provided for @s19ProjectPurchasingVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S19 verification for Project Purchasing. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s19ProjectPurchasingVerify;

  /// No description provided for @s19ProjectSummaryVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S19 verification for Project Summary. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s19ProjectSummaryVerify;

  /// No description provided for @s19ProjectTimesheetVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S19 verification for Project Timesheet. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s19ProjectTimesheetVerify;

  /// No description provided for @s19ResourceUtilizationVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S19 verification for Resource Utilization. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s19ResourceUtilizationVerify;

  /// No description provided for @s20CalibrationServiceHistoryVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S20 verification for Calibration / Service History. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s20CalibrationServiceHistoryVerify;

  /// No description provided for @s20ContainerListVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S20 verification for Container List. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s20ContainerListVerify;

  /// No description provided for @s20DispatchNoteVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S20 verification for Dispatch Note. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s20DispatchNoteVerify;

  /// No description provided for @s20FreightSummaryVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S20 verification for Freight Summary. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s20FreightSummaryVerify;

  /// No description provided for @s20InspectionReportVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S20 verification for Inspection Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s20InspectionReportVerify;

  /// No description provided for @s20LabelThermalProfileMatrixVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S20 verification for Label / Thermal Profile Matrix. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s20LabelThermalProfileMatrixVerify;

  /// No description provided for @s20MaintenanceChecklistVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S20 verification for Maintenance Checklist. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s20MaintenanceChecklistVerify;

  /// No description provided for @s20MaintenanceWorkOrderVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S20 verification for Maintenance Work Order. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s20MaintenanceWorkOrderVerify;

  /// No description provided for @s20ManifestVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S20 verification for Manifest. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s20ManifestVerify;

  /// No description provided for @s20PackingListVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S20 verification for Packing List. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s20PackingListVerify;

  /// No description provided for @s20PalletLabelVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S20 verification for Pallet Label. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s20PalletLabelVerify;

  /// No description provided for @s20PreventiveScheduleVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S20 verification for Preventive Schedule. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s20PreventiveScheduleVerify;

  /// No description provided for @s20ProofDeliveryVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S20 verification for Proof of Delivery. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s20ProofDeliveryVerify;

  /// No description provided for @s20ServiceCompletionVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S20 verification for Service Completion. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s20ServiceCompletionVerify;

  /// No description provided for @s20ServiceOrderVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S20 verification for Service Order. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s20ServiceOrderVerify;

  /// No description provided for @s20ShipmentDocumentVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S20 verification for Shipment Document. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s20ShipmentDocumentVerify;

  /// No description provided for @s20ShippingLabelVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S20 verification for Shipping Label. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s20ShippingLabelVerify;

  /// No description provided for @s20SparePartsUsageVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S20 verification for Spare Parts Usage. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s20SparePartsUsageVerify;

  /// No description provided for @s20TechnicianReportVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S20 verification for Technician Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s20TechnicianReportVerify;

  /// No description provided for @s20TripReportVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S20 verification for Trip Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s20TripReportVerify;

  /// No description provided for @s20TripSheetVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S20 verification for Trip Sheet. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s20TripSheetVerify;

  /// No description provided for @s20WarrantyReportVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S20 verification for Warranty Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s20WarrantyReportVerify;

  /// No description provided for @s20WaybillVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S20 verification for Waybill. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s20WaybillVerify;

  /// No description provided for @s21ActivityReportVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S21 verification for Activity Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s21ActivityReportVerify;

  /// No description provided for @s21CallReportVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S21 verification for Call Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s21CallReportVerify;

  /// No description provided for @s21ContractSummaryVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S21 verification for Contract Summary. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s21ContractSummaryVerify;

  /// No description provided for @s21CustomerHistoryVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S21 verification for Customer History. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s21CustomerHistoryVerify;

  /// No description provided for @s21CustomerProfileVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S21 verification for Customer Profile. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s21CustomerProfileVerify;

  /// No description provided for @s21LeadReportVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S21 verification for Lead Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s21LeadReportVerify;

  /// No description provided for @s21OpportunityReportVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S21 verification for Opportunity Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s21OpportunityReportVerify;

  /// No description provided for @s21PipelineReportVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S21 verification for Pipeline Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s21PipelineReportVerify;

  /// No description provided for @s21PresentationPrimitivesVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S21 verification for Presentation Primitives. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s21PresentationPrimitivesVerify;

  /// No description provided for @s21ProposalVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S21 verification for Proposal. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s21ProposalVerify;

  /// No description provided for @s21VisitReportVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S21 verification for Visit Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s21VisitReportVerify;

  /// No description provided for @s22BoundedLargeLoopVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S22 verification for Bounded Large Loop. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s22BoundedLargeLoopVerify;

  /// No description provided for @s22ComponentsStylesSubTemplateVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S22 verification for Components / Styles / SubTemplate. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s22ComponentsStylesSubTemplateVerify;

  /// No description provided for @s22DirectionValueDirectionVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S22 verification for Direction / Value Direction. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s22DirectionValueDirectionVerify;

  /// No description provided for @s22InvalidExpressionRejectionVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S22 verification for Invalid Expression Rejection. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s22InvalidExpressionRejectionVerify;

  /// No description provided for @s22LegacyV1V2MigrationVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S22 verification for Legacy v1 → v2 Migration. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s22LegacyV1V2MigrationVerify;

  /// No description provided for @s22RegistryFallbackHistoryVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S22 verification for Registry Fallback / History. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s22RegistryFallbackHistoryVerify;

  /// No description provided for @s22SafeExpressionsAggregatesVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S22 verification for Safe Expressions + Aggregates. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s22SafeExpressionsAggregatesVerify;

  /// No description provided for @s22VersionedSchemaElementsVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S22 verification for Versioned Schema + Elements. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s22VersionedSchemaElementsVerify;

  /// No description provided for @s23ArchiveAuditMetadataVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S23 verification for Archive / Audit Metadata. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s23ArchiveAuditMetadataVerify;

  /// No description provided for @s23CopyVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S23 verification for Copy. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s23CopyVerify;

  /// No description provided for @s23CountryTenantRegistryVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S23 verification for Country / Tenant Registry. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s23CountryTenantRegistryVerify;

  /// No description provided for @s23ExistingSecurityAdapterVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S23 verification for Existing Security Adapter. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s23ExistingSecurityAdapterVerify;

  /// No description provided for @s23OriginalVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S23 verification for Original. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s23OriginalVerify;

  /// No description provided for @s23ReprintVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S23 verification for Reprint. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s23ReprintVerify;

  /// No description provided for @s23RequiredFieldFailureVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S23 verification for Required-field Failure. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s23RequiredFieldFailureVerify;

  /// No description provided for @s25ComponentsStylesVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S25 verification for Components / Styles. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s25ComponentsStylesVerify;

  /// No description provided for @s25ConditionsExpressionsVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S25 verification for Conditions / Expressions. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s25ConditionsExpressionsVerify;

  /// No description provided for @s25DesignerMetadataVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S25 verification for Designer Metadata. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s25DesignerMetadataVerify;

  /// No description provided for @s25DragDropSectionsVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S25 verification for Drag / Drop + Sections. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s25DragDropSectionsVerify;

  /// No description provided for @s25MultiPageSamplePreviewVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S25 verification for Multi-page Sample Preview. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s25MultiPageSamplePreviewVerify;

  /// No description provided for @s25ValidationMessagesVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S25 verification for Validation Messages. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.'**
  String get s25ValidationMessagesVerify;

  /// No description provided for @s26AutomotiveDistributionVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S26 verification for Automotive / Distribution / Hospitality. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s26AutomotiveDistributionVerify;

  /// No description provided for @s26ConstructionRealEstateVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S26 verification for Construction / Real Estate. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s26ConstructionRealEstateVerify;

  /// No description provided for @s26HealthcareEducationShellsVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S26 verification for Healthcare / Education Shells. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s26HealthcareEducationShellsVerify;

  /// No description provided for @s26RestaurantVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S26 verification for Restaurant. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s26RestaurantVerify;

  /// No description provided for @s26RetailVerify.
  ///
  /// In en, this message translates to:
  /// **'Focused S26 verification for Retail. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.'**
  String get s26RetailVerify;

  /// No description provided for @fontSizingAndScripts.
  ///
  /// In en, this message translates to:
  /// **'Font Sizing & Scripts'**
  String get fontSizingAndScripts;

  /// No description provided for @footerEdgeContinuation.
  ///
  /// In en, this message translates to:
  /// **'Footer-Edge Continuation'**
  String get footerEdgeContinuation;

  /// No description provided for @footerEdgeKeepTogether.
  ///
  /// In en, this message translates to:
  /// **'Footer-Edge Keep Together'**
  String get footerEdgeKeepTogether;

  /// No description provided for @format.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get format;

  /// No description provided for @freightSummary.
  ///
  /// In en, this message translates to:
  /// **'Freight Summary'**
  String get freightSummary;

  /// No description provided for @fullCompanyDetails.
  ///
  /// In en, this message translates to:
  /// **'Full Company Details'**
  String get fullCompanyDetails;

  /// No description provided for @fullLayoutOptimization.
  ///
  /// In en, this message translates to:
  /// **'Full Layout Optimization'**
  String get fullLayoutOptimization;

  /// No description provided for @fullProtection.
  ///
  /// In en, this message translates to:
  /// **'Full Protection'**
  String get fullProtection;

  /// No description provided for @fullDetailCompanyHeaderCustomDesc.
  ///
  /// In en, this message translates to:
  /// **'Full-detail company header with custom registration/contact groups and extended identity metadata.'**
  String get fullDetailCompanyHeaderCustomDesc;

  /// No description provided for @generalLedger.
  ///
  /// In en, this message translates to:
  /// **'General Ledger'**
  String get generalLedger;

  /// No description provided for @text1DBarcodesProductsShippingDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate 1D barcodes for products, shipping, and documents.'**
  String get text1DBarcodesProductsShippingDesc;

  /// No description provided for @fullPdfBarcodeQrCodeTypesOnePageDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate a full PDF with all barcode and QR code types on one page.'**
  String get fullPdfBarcodeQrCodeTypesOnePageDesc;

  /// No description provided for @generateAllBarcodesPdf.
  ///
  /// In en, this message translates to:
  /// **'Generate All Barcodes PDF'**
  String get generateAllBarcodesPdf;

  /// No description provided for @generateAllQrCodesPdf.
  ///
  /// In en, this message translates to:
  /// **'Generate All QR Codes PDF'**
  String get generateAllQrCodesPdf;

  /// No description provided for @generateCompleteDemoPdf.
  ///
  /// In en, this message translates to:
  /// **'Generate Complete Demo PDF'**
  String get generateCompleteDemoPdf;

  /// No description provided for @generateContract.
  ///
  /// In en, this message translates to:
  /// **'Generate Contract'**
  String get generateContract;

  /// No description provided for @generateInvoiceTemplate.
  ///
  /// In en, this message translates to:
  /// **'Generate Invoice Template'**
  String get generateInvoiceTemplate;

  /// No description provided for @generatePurchaseOrder.
  ///
  /// In en, this message translates to:
  /// **'Generate Purchase Order'**
  String get generatePurchaseOrder;

  /// No description provided for @generateQuotation.
  ///
  /// In en, this message translates to:
  /// **'Generate Quotation'**
  String get generateQuotation;

  /// No description provided for @generateReceiptTemplate.
  ///
  /// In en, this message translates to:
  /// **'Generate Receipt Template'**
  String get generateReceiptTemplate;

  /// No description provided for @generateReportTemplate.
  ///
  /// In en, this message translates to:
  /// **'Generate Report Template'**
  String get generateReportTemplate;

  /// No description provided for @generateSamplePdf.
  ///
  /// In en, this message translates to:
  /// **'Generate Sample PDF'**
  String get generateSamplePdf;

  /// No description provided for @attendanceReportHtmlExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate the Attendance Report template and export its PDF content to an HTML document using GeniusPdfExportService. Preview the exact HTML source, save it, and open the exported file.'**
  String get attendanceReportHtmlExportDesc;

  /// No description provided for @attendanceReportImageExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate the Attendance Report template, rasterize every PDF page, save it as PNG or JPEG, and preview the exported image bytes.'**
  String get attendanceReportImageExportDesc;

  /// No description provided for @balanceSheetHtmlExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate the Balance Sheet template and export its PDF content to an HTML document using GeniusPdfExportService. Preview the exact HTML source, save it, and open the exported file.'**
  String get balanceSheetHtmlExportDesc;

  /// No description provided for @balanceSheetImageExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate the Balance Sheet template, rasterize every PDF page, save it as PNG or JPEG, and preview the exported image bytes.'**
  String get balanceSheetImageExportDesc;

  /// No description provided for @budgetReportHtmlExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate the Budget Report template and export its PDF content to an HTML document using GeniusPdfExportService. Preview the exact HTML source, save it, and open the exported file.'**
  String get budgetReportHtmlExportDesc;

  /// No description provided for @budgetReportImageExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate the Budget Report template, rasterize every PDF page, save it as PNG or JPEG, and preview the exported image bytes.'**
  String get budgetReportImageExportDesc;

  /// No description provided for @cashFlowHtmlExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate the Cash Flow template and export its PDF content to an HTML document using GeniusPdfExportService. Preview the exact HTML source, save it, and open the exported file.'**
  String get cashFlowHtmlExportDesc;

  /// No description provided for @cashFlowImageExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate the Cash Flow template, rasterize every PDF page, save it as PNG or JPEG, and preview the exported image bytes.'**
  String get cashFlowImageExportDesc;

  /// No description provided for @comprehensiveVoucherShowcaseCoveringDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate the comprehensive voucher showcase covering the complete voucher template set.'**
  String get comprehensiveVoucherShowcaseCoveringDesc;

  /// No description provided for @creditNoteHtmlExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate the Credit Note template and export its PDF content to an HTML document using GeniusPdfExportService. Preview the exact HTML source, save it, and open the exported file.'**
  String get creditNoteHtmlExportDesc;

  /// No description provided for @creditNoteImageExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate the Credit Note template, rasterize every PDF page, save it as PNG or JPEG, and preview the exported image bytes.'**
  String get creditNoteImageExportDesc;

  /// No description provided for @deliveryNoteHtmlExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate the Delivery Note template and export its PDF content to an HTML document using GeniusPdfExportService. Preview the exact HTML source, save it, and open the exported file.'**
  String get deliveryNoteHtmlExportDesc;

  /// No description provided for @deliveryNoteImageExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate the Delivery Note template, rasterize every PDF page, save it as PNG or JPEG, and preview the exported image bytes.'**
  String get deliveryNoteImageExportDesc;

  /// No description provided for @employeeReportHtmlExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate the Employee Report template and export its PDF content to an HTML document using GeniusPdfExportService. Preview the exact HTML source, save it, and open the exported file.'**
  String get employeeReportHtmlExportDesc;

  /// No description provided for @employeeReportImageExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate the Employee Report template, rasterize every PDF page, save it as PNG or JPEG, and preview the exported image bytes.'**
  String get employeeReportImageExportDesc;

  /// No description provided for @incomeStatementHtmlExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate the Income Statement template and export its PDF content to an HTML document using GeniusPdfExportService. Preview the exact HTML source, save it, and open the exported file.'**
  String get incomeStatementHtmlExportDesc;

  /// No description provided for @incomeStatementImageExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate the Income Statement template, rasterize every PDF page, save it as PNG or JPEG, and preview the exported image bytes.'**
  String get incomeStatementImageExportDesc;

  /// No description provided for @leaveReportHtmlExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate the Leave Report template and export its PDF content to an HTML document using GeniusPdfExportService. Preview the exact HTML source, save it, and open the exported file.'**
  String get leaveReportHtmlExportDesc;

  /// No description provided for @leaveReportImageExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate the Leave Report template, rasterize every PDF page, save it as PNG or JPEG, and preview the exported image bytes.'**
  String get leaveReportImageExportDesc;

  /// No description provided for @payslipHtmlExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate the Payslip template and export its PDF content to an HTML document using GeniusPdfExportService. Preview the exact HTML source, save it, and open the exported file.'**
  String get payslipHtmlExportDesc;

  /// No description provided for @payslipImageExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate the Payslip template, rasterize every PDF page, save it as PNG or JPEG, and preview the exported image bytes.'**
  String get payslipImageExportDesc;

  /// No description provided for @purchaseOrderHtmlExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate the Purchase Order template and export its PDF content to an HTML document using GeniusPdfExportService. Preview the exact HTML source, save it, and open the exported file.'**
  String get purchaseOrderHtmlExportDesc;

  /// No description provided for @purchaseOrderImageExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate the Purchase Order template, rasterize every PDF page, save it as PNG or JPEG, and preview the exported image bytes.'**
  String get purchaseOrderImageExportDesc;

  /// No description provided for @quotationHtmlExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate the Quotation template and export its PDF content to an HTML document using GeniusPdfExportService. Preview the exact HTML source, save it, and open the exported file.'**
  String get quotationHtmlExportDesc;

  /// No description provided for @quotationImageExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate the Quotation template, rasterize every PDF page, save it as PNG or JPEG, and preview the exported image bytes.'**
  String get quotationImageExportDesc;

  /// No description provided for @generateTimesheet.
  ///
  /// In en, this message translates to:
  /// **'Generate Timesheet'**
  String get generateTimesheet;

  /// No description provided for @generateTitles.
  ///
  /// In en, this message translates to:
  /// **'Generate Titles'**
  String get generateTitles;

  /// No description provided for @generated.
  ///
  /// In en, this message translates to:
  /// **'Generated'**
  String get generated;

  /// No description provided for @generatingPdfPreview.
  ///
  /// In en, this message translates to:
  /// **'Generating PDF preview…'**
  String get generatingPdfPreview;

  /// No description provided for @generatingPreview.
  ///
  /// In en, this message translates to:
  /// **'Generating preview…'**
  String get generatingPreview;

  /// No description provided for @generationCatalog.
  ///
  /// In en, this message translates to:
  /// **'Generation catalog'**
  String get generationCatalog;

  /// No description provided for @generationFailed.
  ///
  /// In en, this message translates to:
  /// **'Generation failed'**
  String get generationFailed;

  /// No description provided for @geniusLinkPdfGenerator.
  ///
  /// In en, this message translates to:
  /// **'Genius Link PDF Generator'**
  String get geniusLinkPdfGenerator;

  /// No description provided for @geniusLinkPdfGeneratorExamples.
  ///
  /// In en, this message translates to:
  /// **'Genius Link PDF Generator examples'**
  String get geniusLinkPdfGeneratorExamples;

  /// No description provided for @geniusLinkPdfGeneratorShowcase.
  ///
  /// In en, this message translates to:
  /// **'genius_link_pdf_generator showcase'**
  String get geniusLinkPdfGeneratorShowcase;

  /// No description provided for @geniusPdfBarcode.
  ///
  /// In en, this message translates to:
  /// **'GeniusPdfBarcode'**
  String get geniusPdfBarcode;

  /// No description provided for @geniusPdfQrcodeGenerator.
  ///
  /// In en, this message translates to:
  /// **'GeniusPdfQRCodeGenerator'**
  String get geniusPdfQrcodeGenerator;

  /// No description provided for @getIntelligentLayoutSuggestionsFontDesc.
  ///
  /// In en, this message translates to:
  /// **'Get intelligent layout suggestions for font sizes, margins, spacing, and color schemes'**
  String get getIntelligentLayoutSuggestionsFontDesc;

  /// No description provided for @gettingStarted.
  ///
  /// In en, this message translates to:
  /// **'Getting started'**
  String get gettingStarted;

  /// No description provided for @gettingStartedAndLayout.
  ///
  /// In en, this message translates to:
  /// **'Getting Started & Layout'**
  String get gettingStartedAndLayout;

  /// No description provided for @gettingStartedS00Baseline.
  ///
  /// In en, this message translates to:
  /// **'Getting Started / S00 Baseline'**
  String get gettingStartedS00Baseline;

  /// No description provided for @giftReceipt.
  ///
  /// In en, this message translates to:
  /// **'Gift Receipt'**
  String get giftReceipt;

  /// No description provided for @giftGrantSupportingInventoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Gift, grant, and supporting inventory-operation voucher examples.'**
  String get giftGrantSupportingInventoryDesc;

  /// No description provided for @goldenCoverageManifest.
  ///
  /// In en, this message translates to:
  /// **'Golden Coverage Manifest'**
  String get goldenCoverageManifest;

  /// No description provided for @goodsReceiptNote.
  ///
  /// In en, this message translates to:
  /// **'Goods Receipt Note'**
  String get goodsReceiptNote;

  /// No description provided for @googleDrive.
  ///
  /// In en, this message translates to:
  /// **'Google Drive'**
  String get googleDrive;

  /// No description provided for @gosi.
  ///
  /// In en, this message translates to:
  /// **'GOSI'**
  String get gosi;

  /// No description provided for @grandTotal.
  ///
  /// In en, this message translates to:
  /// **'Grand Total'**
  String get grandTotal;

  /// No description provided for @gridPlusInfoBox.
  ///
  /// In en, this message translates to:
  /// **'Grid + Info Box'**
  String get gridPlusInfoBox;

  /// No description provided for @gridPlusQrCode.
  ///
  /// In en, this message translates to:
  /// **'Grid + QR Code'**
  String get gridPlusQrCode;

  /// No description provided for @gridPlusRichText.
  ///
  /// In en, this message translates to:
  /// **'Grid + Rich Text'**
  String get gridPlusRichText;

  /// No description provided for @gridPlusWatermark.
  ///
  /// In en, this message translates to:
  /// **'Grid + Watermark'**
  String get gridPlusWatermark;

  /// No description provided for @gridStyleShowcase.
  ///
  /// In en, this message translates to:
  /// **'Grid Style Showcase'**
  String get gridStyleShowcase;

  /// No description provided for @groupedIncomeAndExpenses.
  ///
  /// In en, this message translates to:
  /// **'Grouped Income & Expenses'**
  String get groupedIncomeAndExpenses;

  /// No description provided for @growth.
  ///
  /// In en, this message translates to:
  /// **'Growth'**
  String get growth;

  /// No description provided for @headerContent.
  ///
  /// In en, this message translates to:
  /// **'Header Content'**
  String get headerContent;

  /// No description provided for @headerFooter.
  ///
  /// In en, this message translates to:
  /// **'Header/Footer'**
  String get headerFooter;

  /// No description provided for @headers.
  ///
  /// In en, this message translates to:
  /// **'Headers'**
  String get headers;

  /// No description provided for @healthcareEducationShells.
  ///
  /// In en, this message translates to:
  /// **'Healthcare / Education Shells'**
  String get healthcareEducationShells;

  /// No description provided for @highQuality.
  ///
  /// In en, this message translates to:
  /// **'High Quality'**
  String get highQuality;

  /// No description provided for @highlighted.
  ///
  /// In en, this message translates to:
  /// **'Highlighted'**
  String get highlighted;

  /// No description provided for @hrReports.
  ///
  /// In en, this message translates to:
  /// **'HR Reports'**
  String get hrReports;

  /// No description provided for @html.
  ///
  /// In en, this message translates to:
  /// **'HTML'**
  String get html;

  /// No description provided for @htmlCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'HTML copied to clipboard'**
  String get htmlCopiedToClipboard;

  /// No description provided for @identityPartyAddress.
  ///
  /// In en, this message translates to:
  /// **'Identity / Party / Address'**
  String get identityPartyAddress;

  /// No description provided for @imageAttachmentsPages.
  ///
  /// In en, this message translates to:
  /// **'Image attachments pages'**
  String get imageAttachmentsPages;

  /// No description provided for @imageExport.
  ///
  /// In en, this message translates to:
  /// **'Image Export'**
  String get imageExport;

  /// No description provided for @images.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get images;

  /// No description provided for @importRenderExportPortableTemplateDesc.
  ///
  /// In en, this message translates to:
  /// **'Import, render, and export portable template definitions.'**
  String get importRenderExportPortableTemplateDesc;

  /// No description provided for @inProcessInspection.
  ///
  /// In en, this message translates to:
  /// **'In-process Inspection'**
  String get inProcessInspection;

  /// No description provided for @includeCssStyles.
  ///
  /// In en, this message translates to:
  /// **'Include CSS styles'**
  String get includeCssStyles;

  /// No description provided for @includeFooter.
  ///
  /// In en, this message translates to:
  /// **'Include Footer'**
  String get includeFooter;

  /// No description provided for @includeHeader.
  ///
  /// In en, this message translates to:
  /// **'Include Header'**
  String get includeHeader;

  /// No description provided for @includeLogoPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Include Logo Placeholder'**
  String get includeLogoPlaceholder;

  /// No description provided for @incomeStatement.
  ///
  /// In en, this message translates to:
  /// **'Income Statement'**
  String get incomeStatement;

  /// No description provided for @incomeStatementHtmlExport.
  ///
  /// In en, this message translates to:
  /// **'Income Statement HTML Export'**
  String get incomeStatementHtmlExport;

  /// No description provided for @incomeStatementImageExport.
  ///
  /// In en, this message translates to:
  /// **'Income Statement Image Export'**
  String get incomeStatementImageExport;

  /// No description provided for @incomingInspection.
  ///
  /// In en, this message translates to:
  /// **'Incoming Inspection'**
  String get incomingInspection;

  /// No description provided for @indentedHierarchy.
  ///
  /// In en, this message translates to:
  /// **'Indented Hierarchy'**
  String get indentedHierarchy;

  /// No description provided for @infoAndWarningStates.
  ///
  /// In en, this message translates to:
  /// **'Info & Warning States'**
  String get infoAndWarningStates;

  /// No description provided for @infoBox.
  ///
  /// In en, this message translates to:
  /// **'Info Box'**
  String get infoBox;

  /// No description provided for @infoBoxContent.
  ///
  /// In en, this message translates to:
  /// **'Info Box Content'**
  String get infoBoxContent;

  /// No description provided for @infoBoxRtl.
  ///
  /// In en, this message translates to:
  /// **'Info Box RTL'**
  String get infoBoxRtl;

  /// No description provided for @infoBoxSettings.
  ///
  /// In en, this message translates to:
  /// **'Info Box Settings'**
  String get infoBoxSettings;

  /// No description provided for @infoBoxStyle.
  ///
  /// In en, this message translates to:
  /// **'Info Box Style'**
  String get infoBoxStyle;

  /// No description provided for @infoBoxTitle.
  ///
  /// In en, this message translates to:
  /// **'Info Box Title'**
  String get infoBoxTitle;

  /// No description provided for @infoBoxBaseline.
  ///
  /// In en, this message translates to:
  /// **'InfoBox Baseline'**
  String get infoBoxBaseline;

  /// No description provided for @informationBoxes.
  ///
  /// In en, this message translates to:
  /// **'Information boxes'**
  String get informationBoxes;

  /// No description provided for @initializeAllPlugins.
  ///
  /// In en, this message translates to:
  /// **'Initialize All Plugins'**
  String get initializeAllPlugins;

  /// No description provided for @recentPdfSharingActivityOutcomesDesc.
  ///
  /// In en, this message translates to:
  /// **'Inspect recent PDF sharing activity and outcomes.'**
  String get recentPdfSharingActivityOutcomesDesc;

  /// No description provided for @publicGoldenRegressionManifestRenderDesc.
  ///
  /// In en, this message translates to:
  /// **'Inspect the public golden-regression manifest and render its case count and supported regression directions in a focused PDF.'**
  String get publicGoldenRegressionManifestRenderDesc;

  /// No description provided for @inspectionReport.
  ///
  /// In en, this message translates to:
  /// **'Inspection Report'**
  String get inspectionReport;

  /// No description provided for @invalidExpressionRejection.
  ///
  /// In en, this message translates to:
  /// **'Invalid Expression Rejection'**
  String get invalidExpressionRejection;

  /// No description provided for @inventoryReport.
  ///
  /// In en, this message translates to:
  /// **'Inventory Report'**
  String get inventoryReport;

  /// No description provided for @inventoryTrackingQr.
  ///
  /// In en, this message translates to:
  /// **'Inventory Tracking QR'**
  String get inventoryTrackingQr;

  /// No description provided for @inventoryValuation.
  ///
  /// In en, this message translates to:
  /// **'Inventory valuation'**
  String get inventoryValuation;

  /// No description provided for @inventoryValuationReportCategoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Inventory valuation report with category grouping, quantities, costs, totals, signatures, and QR support.'**
  String get inventoryValuationReportCategoryDesc;

  /// No description provided for @invoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoice;

  /// No description provided for @invoiceAndFooterRows.
  ///
  /// In en, this message translates to:
  /// **'Invoice & Footer Rows'**
  String get invoiceAndFooterRows;

  /// No description provided for @invoiceHeader.
  ///
  /// In en, this message translates to:
  /// **'Invoice Header'**
  String get invoiceHeader;

  /// No description provided for @invoiceStyle.
  ///
  /// In en, this message translates to:
  /// **'Invoice Style'**
  String get invoiceStyle;

  /// No description provided for @itemA.
  ///
  /// In en, this message translates to:
  /// **'Item A'**
  String get itemA;

  /// No description provided for @itemCard.
  ///
  /// In en, this message translates to:
  /// **'Item Card'**
  String get itemCard;

  /// No description provided for @itemLabel.
  ///
  /// In en, this message translates to:
  /// **'Item Label'**
  String get itemLabel;

  /// No description provided for @jobCard.
  ///
  /// In en, this message translates to:
  /// **'Job Card'**
  String get jobCard;

  /// No description provided for @jobManagerQueue.
  ///
  /// In en, this message translates to:
  /// **'Job Manager / Queue'**
  String get jobManagerQueue;

  /// No description provided for @jobManagerQueuesBatchBackgroundDesc.
  ///
  /// In en, this message translates to:
  /// **'Job manager, queues, batch/background workflows, status, and result handling.'**
  String get jobManagerQueuesBatchBackgroundDesc;

  /// No description provided for @jobQueue.
  ///
  /// In en, this message translates to:
  /// **'Job queue'**
  String get jobQueue;

  /// No description provided for @journalEntry.
  ///
  /// In en, this message translates to:
  /// **'Journal Entry'**
  String get journalEntry;

  /// No description provided for @journalRegister.
  ///
  /// In en, this message translates to:
  /// **'Journal Register'**
  String get journalRegister;

  /// No description provided for @jpeg.
  ///
  /// In en, this message translates to:
  /// **'JPEG'**
  String get jpeg;

  /// No description provided for @jsonTemplates.
  ///
  /// In en, this message translates to:
  /// **'JSON Templates'**
  String get jsonTemplates;

  /// No description provided for @keepTogetherKeepWithNext.
  ///
  /// In en, this message translates to:
  /// **'Keep Together / Keep With Next'**
  String get keepTogetherKeepWithNext;

  /// No description provided for @kitchenOrderTicket.
  ///
  /// In en, this message translates to:
  /// **'Kitchen Order Ticket'**
  String get kitchenOrderTicket;

  /// No description provided for @label.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get label;

  /// No description provided for @labelThermalProfileMatrix.
  ///
  /// In en, this message translates to:
  /// **'Label / Thermal Profile Matrix'**
  String get labelThermalProfileMatrix;

  /// No description provided for @labelSheet.
  ///
  /// In en, this message translates to:
  /// **'Label Sheet'**
  String get labelSheet;

  /// No description provided for @labelSheet2.
  ///
  /// In en, this message translates to:
  /// **'Label sheet'**
  String get labelSheet2;

  /// No description provided for @labeledInformationBlocks.
  ///
  /// In en, this message translates to:
  /// **'Labeled information blocks'**
  String get labeledInformationBlocks;

  /// No description provided for @laborReport.
  ///
  /// In en, this message translates to:
  /// **'Labor Report'**
  String get laborReport;

  /// No description provided for @languageDirection.
  ///
  /// In en, this message translates to:
  /// **'Language Direction'**
  String get languageDirection;

  /// No description provided for @layoutOptions.
  ///
  /// In en, this message translates to:
  /// **'Layout Options'**
  String get layoutOptions;

  /// No description provided for @lazySingleton.
  ///
  /// In en, this message translates to:
  /// **'Lazy Singleton'**
  String get lazySingleton;

  /// No description provided for @leadReport.
  ///
  /// In en, this message translates to:
  /// **'Lead Report'**
  String get leadReport;

  /// No description provided for @leaveBalance.
  ///
  /// In en, this message translates to:
  /// **'Leave Balance'**
  String get leaveBalance;

  /// No description provided for @leaveBalancesRequestsPeriodsTypesDesc.
  ///
  /// In en, this message translates to:
  /// **'Leave balances and requests with periods, types, and approval status.'**
  String get leaveBalancesRequestsPeriodsTypesDesc;

  /// No description provided for @leaveReport.
  ///
  /// In en, this message translates to:
  /// **'Leave Report'**
  String get leaveReport;

  /// No description provided for @leaveReportHtmlExport.
  ///
  /// In en, this message translates to:
  /// **'Leave Report HTML Export'**
  String get leaveReportHtmlExport;

  /// No description provided for @leaveReportImageExport.
  ///
  /// In en, this message translates to:
  /// **'Leave Report Image Export'**
  String get leaveReportImageExport;

  /// No description provided for @leaveRequest.
  ///
  /// In en, this message translates to:
  /// **'Leave Request'**
  String get leaveRequest;

  /// No description provided for @legacyCallbackAdapter.
  ///
  /// In en, this message translates to:
  /// **'Legacy Callback Adapter'**
  String get legacyCallbackAdapter;

  /// No description provided for @legacyTemplateJson.
  ///
  /// In en, this message translates to:
  /// **'Legacy Template JSON'**
  String get legacyTemplateJson;

  /// No description provided for @legacyV1V2Migration.
  ///
  /// In en, this message translates to:
  /// **'Legacy v1 → v2 Migration'**
  String get legacyV1V2Migration;

  /// No description provided for @legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// No description provided for @letter.
  ///
  /// In en, this message translates to:
  /// **'Letter'**
  String get letter;

  /// No description provided for @letterheadHeader.
  ///
  /// In en, this message translates to:
  /// **'Letterhead Header'**
  String get letterheadHeader;

  /// No description provided for @liabilities.
  ///
  /// In en, this message translates to:
  /// **'Liabilities'**
  String get liabilities;

  /// No description provided for @listAllTemplates.
  ///
  /// In en, this message translates to:
  /// **'List All Templates'**
  String get listAllTemplates;

  /// No description provided for @listRegisteredPlugins.
  ///
  /// In en, this message translates to:
  /// **'List Registered Plugins'**
  String get listRegisteredPlugins;

  /// No description provided for @loanAdvance.
  ///
  /// In en, this message translates to:
  /// **'Loan / Advance'**
  String get loanAdvance;

  /// No description provided for @locationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location Label'**
  String get locationLabel;

  /// No description provided for @logicalGeometry.
  ///
  /// In en, this message translates to:
  /// **'Logical Geometry'**
  String get logicalGeometry;

  /// No description provided for @logoAndBranding.
  ///
  /// In en, this message translates to:
  /// **'Logo and branding'**
  String get logoAndBranding;

  /// No description provided for @longPlusMultiPage.
  ///
  /// In en, this message translates to:
  /// **'Long + Multi-page'**
  String get longPlusMultiPage;

  /// No description provided for @longPlusMultiPageRtl.
  ///
  /// In en, this message translates to:
  /// **'Long + Multi-page RTL'**
  String get longPlusMultiPageRtl;

  /// No description provided for @longMultiPageBaseline.
  ///
  /// In en, this message translates to:
  /// **'Long / Multi-page Baseline'**
  String get longMultiPageBaseline;

  /// No description provided for @longMultiPageDomain.
  ///
  /// In en, this message translates to:
  /// **'Long / Multi-page Domain'**
  String get longMultiPageDomain;

  /// No description provided for @longMultiPageSemantics.
  ///
  /// In en, this message translates to:
  /// **'Long / Multi-page Semantics'**
  String get longMultiPageSemantics;

  /// No description provided for @longContentOverflow.
  ///
  /// In en, this message translates to:
  /// **'Long Content / Overflow'**
  String get longContentOverflow;

  /// No description provided for @longMultiPageTable.
  ///
  /// In en, this message translates to:
  /// **'Long Multi-page Table'**
  String get longMultiPageTable;

  /// No description provided for @longMultiPageTransaction.
  ///
  /// In en, this message translates to:
  /// **'Long multi-page transaction'**
  String get longMultiPageTransaction;

  /// No description provided for @longNotesPlusOrphanWidow.
  ///
  /// In en, this message translates to:
  /// **'Long Notes + Orphan/Widow'**
  String get longNotesPlusOrphanWidow;

  /// No description provided for @longPartyNotesTerms.
  ///
  /// In en, this message translates to:
  /// **'Long party / notes / terms'**
  String get longPartyNotesTerms;

  /// No description provided for @ltr.
  ///
  /// In en, this message translates to:
  /// **'LTR'**
  String get ltr;

  /// No description provided for @ltrEnglish.
  ///
  /// In en, this message translates to:
  /// **'LTR (English)'**
  String get ltrEnglish;

  /// No description provided for @ltrPlusRtl.
  ///
  /// In en, this message translates to:
  /// **'LTR + RTL'**
  String get ltrPlusRtl;

  /// No description provided for @machineOperation.
  ///
  /// In en, this message translates to:
  /// **'Machine Operation'**
  String get machineOperation;

  /// No description provided for @maintenanceChecklist.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Checklist'**
  String get maintenanceChecklist;

  /// No description provided for @maintenanceWorkOrder.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Work Order'**
  String get maintenanceWorkOrder;

  /// No description provided for @manifest.
  ///
  /// In en, this message translates to:
  /// **'Manifest'**
  String get manifest;

  /// No description provided for @manualSignatureBlocks.
  ///
  /// In en, this message translates to:
  /// **'Manual signature blocks'**
  String get manualSignatureBlocks;

  /// No description provided for @markdownParsing.
  ///
  /// In en, this message translates to:
  /// **'Markdown Parsing'**
  String get markdownParsing;

  /// No description provided for @materialIssue.
  ///
  /// In en, this message translates to:
  /// **'Material Issue'**
  String get materialIssue;

  /// No description provided for @materialRequirement.
  ///
  /// In en, this message translates to:
  /// **'Material Requirement'**
  String get materialRequirement;

  /// No description provided for @materialReturn.
  ///
  /// In en, this message translates to:
  /// **'Material Return'**
  String get materialReturn;

  /// No description provided for @mediaDirectionPolicy.
  ///
  /// In en, this message translates to:
  /// **'Media Direction Policy'**
  String get mediaDirectionPolicy;

  /// No description provided for @mediaPreservePolicy.
  ///
  /// In en, this message translates to:
  /// **'Media Preserve Policy'**
  String get mediaPreservePolicy;

  /// No description provided for @messagingApps.
  ///
  /// In en, this message translates to:
  /// **'Messaging Apps'**
  String get messagingApps;

  /// No description provided for @milestoneReport.
  ///
  /// In en, this message translates to:
  /// **'Milestone Report'**
  String get milestoneReport;

  /// No description provided for @minMaxReport.
  ///
  /// In en, this message translates to:
  /// **'Min / Max Report'**
  String get minMaxReport;

  /// No description provided for @minimalHeader.
  ///
  /// In en, this message translates to:
  /// **'Minimal Header'**
  String get minimalHeader;

  /// No description provided for @minimalReportHeaderContainingOnlyDesc.
  ///
  /// In en, this message translates to:
  /// **'Minimal report header containing only title, subtitle, and date for lightweight internal reports.'**
  String get minimalReportHeaderContainingOnlyDesc;

  /// No description provided for @minimalStyle.
  ///
  /// In en, this message translates to:
  /// **'Minimal Style'**
  String get minimalStyle;

  /// No description provided for @mixedArabicLatin.
  ///
  /// In en, this message translates to:
  /// **'Mixed Arabic / Latin'**
  String get mixedArabicLatin;

  /// No description provided for @mixedErpBaseline.
  ///
  /// In en, this message translates to:
  /// **'Mixed ERP Baseline'**
  String get mixedErpBaseline;

  /// No description provided for @mixedLinksAndStyles.
  ///
  /// In en, this message translates to:
  /// **'Mixed Links & Styles'**
  String get mixedLinksAndStyles;

  /// No description provided for @modernPurchaseReturn.
  ///
  /// In en, this message translates to:
  /// **'Modern Purchase Return'**
  String get modernPurchaseReturn;

  /// No description provided for @modernPurchaseVoucher.
  ///
  /// In en, this message translates to:
  /// **'Modern Purchase Voucher'**
  String get modernPurchaseVoucher;

  /// No description provided for @modernSalesReturn.
  ///
  /// In en, this message translates to:
  /// **'Modern Sales Return'**
  String get modernSalesReturn;

  /// No description provided for @modernSalesVoucher.
  ///
  /// In en, this message translates to:
  /// **'Modern Sales Voucher'**
  String get modernSalesVoucher;

  /// No description provided for @modernVouchers.
  ///
  /// In en, this message translates to:
  /// **'Modern Vouchers'**
  String get modernVouchers;

  /// No description provided for @multiCurrency.
  ///
  /// In en, this message translates to:
  /// **'Multi-currency'**
  String get multiCurrency;

  /// No description provided for @multiGridSummary.
  ///
  /// In en, this message translates to:
  /// **'Multi-Grid Summary'**
  String get multiGridSummary;

  /// No description provided for @multiPageRepeatedHeader.
  ///
  /// In en, this message translates to:
  /// **'Multi-page / Repeated Header'**
  String get multiPageRepeatedHeader;

  /// No description provided for @multiPageReport.
  ///
  /// In en, this message translates to:
  /// **'Multi-page Report'**
  String get multiPageReport;

  /// No description provided for @multiPageSamplePreview.
  ///
  /// In en, this message translates to:
  /// **'Multi-page Sample Preview'**
  String get multiPageSamplePreview;

  /// No description provided for @multiPeriodComparison.
  ///
  /// In en, this message translates to:
  /// **'Multi-period Comparison'**
  String get multiPeriodComparison;

  /// No description provided for @multiPeriodFinancials.
  ///
  /// In en, this message translates to:
  /// **'Multi-period Financials'**
  String get multiPeriodFinancials;

  /// No description provided for @multiTaxCompound.
  ///
  /// In en, this message translates to:
  /// **'Multi-tax / Compound'**
  String get multiTaxCompound;

  /// No description provided for @multipleGridsAndSummaries.
  ///
  /// In en, this message translates to:
  /// **'Multiple grids & summaries'**
  String get multipleGridsAndSummaries;

  /// No description provided for @multiplePaginatedGridsSectionDesc.
  ///
  /// In en, this message translates to:
  /// **'Multiple paginated grids with section summaries and a final report summary.'**
  String get multiplePaginatedGridsSectionDesc;

  /// No description provided for @multipleSignatures.
  ///
  /// In en, this message translates to:
  /// **'Multiple Signatures'**
  String get multipleSignatures;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @ncr.
  ///
  /// In en, this message translates to:
  /// **'NCR'**
  String get ncr;

  /// No description provided for @nearbyShareAirDrop.
  ///
  /// In en, this message translates to:
  /// **'Nearby Share / AirDrop'**
  String get nearbyShareAirDrop;

  /// No description provided for @negativeAccounting.
  ///
  /// In en, this message translates to:
  /// **'Negative Accounting'**
  String get negativeAccounting;

  /// No description provided for @nestedBulletList.
  ///
  /// In en, this message translates to:
  /// **'Nested Bullet List'**
  String get nestedBulletList;

  /// No description provided for @nestedDirectionOverride.
  ///
  /// In en, this message translates to:
  /// **'Nested Direction Override'**
  String get nestedDirectionOverride;

  /// No description provided for @nestedGroups.
  ///
  /// In en, this message translates to:
  /// **'Nested Groups'**
  String get nestedGroups;

  /// No description provided for @nestedGroupsSubtotals.
  ///
  /// In en, this message translates to:
  /// **'Nested Groups / Subtotals'**
  String get nestedGroupsSubtotals;

  /// No description provided for @nestedOperationMaterialTables.
  ///
  /// In en, this message translates to:
  /// **'Nested Operation / Material Tables'**
  String get nestedOperationMaterialTables;

  /// No description provided for @nestedOverrides.
  ///
  /// In en, this message translates to:
  /// **'Nested Overrides'**
  String get nestedOverrides;

  /// No description provided for @netMargin.
  ///
  /// In en, this message translates to:
  /// **'Net Margin'**
  String get netMargin;

  /// No description provided for @netTotal.
  ///
  /// In en, this message translates to:
  /// **'Net Total'**
  String get netTotal;

  /// No description provided for @newestJobsAppearFirstCompletedJobsDesc.
  ///
  /// In en, this message translates to:
  /// **'Newest jobs appear first. Completed jobs can be opened from disk.'**
  String get newestJobsAppearFirstCompletedJobsDesc;

  /// No description provided for @nextPage.
  ///
  /// In en, this message translates to:
  /// **'Next page'**
  String get nextPage;

  /// No description provided for @noActiveExamplesInThisCategory.
  ///
  /// In en, this message translates to:
  /// **'No active examples in this category.'**
  String get noActiveExamplesInThisCategory;

  /// No description provided for @noCustomProfilesYet.
  ///
  /// In en, this message translates to:
  /// **'No custom profiles yet'**
  String get noCustomProfilesYet;

  /// No description provided for @noEventsEmittedYet.
  ///
  /// In en, this message translates to:
  /// **'No events emitted yet.'**
  String get noEventsEmittedYet;

  /// No description provided for @noExportedImageYet.
  ///
  /// In en, this message translates to:
  /// **'No exported image yet'**
  String get noExportedImageYet;

  /// No description provided for @noHtmlExportYet.
  ///
  /// In en, this message translates to:
  /// **'No HTML export yet'**
  String get noHtmlExportYet;

  /// No description provided for @noJobsQueued.
  ///
  /// In en, this message translates to:
  /// **'No jobs queued'**
  String get noJobsQueued;

  /// No description provided for @noPdfGeneratedYet.
  ///
  /// In en, this message translates to:
  /// **'No PDF generated yet'**
  String get noPdfGeneratedYet;

  /// No description provided for @noSharingHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No sharing history yet'**
  String get noSharingHistoryYet;

  /// No description provided for @nullEmptyState.
  ///
  /// In en, this message translates to:
  /// **'Null / Empty State'**
  String get nullEmptyState;

  /// No description provided for @nullUnitsExchangeRate.
  ///
  /// In en, this message translates to:
  /// **'Null / Units / Exchange Rate'**
  String get nullUnitsExchangeRate;

  /// No description provided for @nullCollapseNoGap.
  ///
  /// In en, this message translates to:
  /// **'Null Collapse / No Gap'**
  String get nullCollapseNoGap;

  /// No description provided for @nullOptionalMetadata.
  ///
  /// In en, this message translates to:
  /// **'Null Optional Metadata'**
  String get nullOptionalMetadata;

  /// No description provided for @nullOptionalSections.
  ///
  /// In en, this message translates to:
  /// **'Null optional sections'**
  String get nullOptionalSections;

  /// No description provided for @officialPurchaseVoucherOrderDesc.
  ///
  /// In en, this message translates to:
  /// **'Official purchase voucher with order reference.'**
  String get officialPurchaseVoucherOrderDesc;

  /// No description provided for @officialSaudiThemedBilingualHeaderDesc.
  ///
  /// In en, this message translates to:
  /// **'Official Saudi-themed bilingual header with Arabic-first title order and green identity styling.'**
  String get officialSaudiThemedBilingualHeaderDesc;

  /// No description provided for @oneDrive.
  ///
  /// In en, this message translates to:
  /// **'OneDrive'**
  String get oneDrive;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @openDedicatedBusinessTemplateExampleDesc.
  ///
  /// In en, this message translates to:
  /// **'Open a dedicated business-template example; choose other financial, sales, and HR templates from the sidebar.'**
  String get openDedicatedBusinessTemplateExampleDesc;

  /// No description provided for @openExportedFile.
  ///
  /// In en, this message translates to:
  /// **'Open exported file'**
  String get openExportedFile;

  /// No description provided for @openGmail.
  ///
  /// In en, this message translates to:
  /// **'Open Gmail'**
  String get openGmail;

  /// No description provided for @openInExternalApp.
  ///
  /// In en, this message translates to:
  /// **'Open in External App'**
  String get openInExternalApp;

  /// No description provided for @openNavigation.
  ///
  /// In en, this message translates to:
  /// **'Open navigation'**
  String get openNavigation;

  /// No description provided for @openOutlook.
  ///
  /// In en, this message translates to:
  /// **'Open Outlook'**
  String get openOutlook;

  /// No description provided for @openPdf.
  ///
  /// In en, this message translates to:
  /// **'Open PDF'**
  String get openPdf;

  /// No description provided for @openShowcase.
  ///
  /// In en, this message translates to:
  /// **'Open showcase'**
  String get openShowcase;

  /// No description provided for @operatingExpenses.
  ///
  /// In en, this message translates to:
  /// **'Operating Expenses'**
  String get operatingExpenses;

  /// No description provided for @operatingIncome.
  ///
  /// In en, this message translates to:
  /// **'Operating Income'**
  String get operatingIncome;

  /// No description provided for @operatingInvestingFinancingCashFlowDesc.
  ///
  /// In en, this message translates to:
  /// **'Operating, investing, and financing cash-flow activities.'**
  String get operatingInvestingFinancingCashFlowDesc;

  /// No description provided for @operationalComponents.
  ///
  /// In en, this message translates to:
  /// **'Operational Components'**
  String get operationalComponents;

  /// No description provided for @operationalForm.
  ///
  /// In en, this message translates to:
  /// **'Operational form'**
  String get operationalForm;

  /// No description provided for @opportunityReport.
  ///
  /// In en, this message translates to:
  /// **'Opportunity Report'**
  String get opportunityReport;

  /// No description provided for @orderDocument.
  ///
  /// In en, this message translates to:
  /// **'Order Document'**
  String get orderDocument;

  /// No description provided for @orientation.
  ///
  /// In en, this message translates to:
  /// **'Orientation'**
  String get orientation;

  /// No description provided for @original.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get original;

  /// No description provided for @outstandingPurchaseOrders.
  ///
  /// In en, this message translates to:
  /// **'Outstanding Purchase Orders'**
  String get outstandingPurchaseOrders;

  /// No description provided for @overtimeReport.
  ///
  /// In en, this message translates to:
  /// **'Overtime Report'**
  String get overtimeReport;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @pAndLStatement.
  ///
  /// In en, this message translates to:
  /// **'P&L statement'**
  String get pAndLStatement;

  /// No description provided for @packingList.
  ///
  /// In en, this message translates to:
  /// **'Packing List'**
  String get packingList;

  /// No description provided for @pageMetadataMarkers.
  ///
  /// In en, this message translates to:
  /// **'Page Metadata / Markers'**
  String get pageMetadataMarkers;

  /// No description provided for @pages.
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get pages;

  /// No description provided for @paidDue.
  ///
  /// In en, this message translates to:
  /// **'Paid / Due'**
  String get paidDue;

  /// No description provided for @palletLabel.
  ///
  /// In en, this message translates to:
  /// **'Pallet Label'**
  String get palletLabel;

  /// No description provided for @paper.
  ///
  /// In en, this message translates to:
  /// **'Paper'**
  String get paper;

  /// No description provided for @paperSize.
  ///
  /// In en, this message translates to:
  /// **'Paper Size'**
  String get paperSize;

  /// No description provided for @parseLightweightMarkdownFormattedDesc.
  ///
  /// In en, this message translates to:
  /// **'Parse lightweight markdown into formatted GeniusPdfTextSpan content.'**
  String get parseLightweightMarkdownFormattedDesc;

  /// No description provided for @passwordProtected.
  ///
  /// In en, this message translates to:
  /// **'Password Protected'**
  String get passwordProtected;

  /// No description provided for @path.
  ///
  /// In en, this message translates to:
  /// **'Path'**
  String get path;

  /// No description provided for @paymentMethodSummary.
  ///
  /// In en, this message translates to:
  /// **'Payment Method Summary'**
  String get paymentMethodSummary;

  /// No description provided for @paymentRegister.
  ///
  /// In en, this message translates to:
  /// **'Payment Register'**
  String get paymentRegister;

  /// No description provided for @payrollSheet.
  ///
  /// In en, this message translates to:
  /// **'Payroll Sheet'**
  String get payrollSheet;

  /// No description provided for @payrollSummary.
  ///
  /// In en, this message translates to:
  /// **'Payroll Summary'**
  String get payrollSummary;

  /// No description provided for @payslip.
  ///
  /// In en, this message translates to:
  /// **'Payslip'**
  String get payslip;

  /// No description provided for @payslipHtmlExport.
  ///
  /// In en, this message translates to:
  /// **'Payslip HTML Export'**
  String get payslipHtmlExport;

  /// No description provided for @payslipImageExport.
  ///
  /// In en, this message translates to:
  /// **'Payslip Image Export'**
  String get payslipImageExport;

  /// No description provided for @pdfGenerationFailed.
  ///
  /// In en, this message translates to:
  /// **'PDF generation failed'**
  String get pdfGenerationFailed;

  /// No description provided for @pdfPreview.
  ///
  /// In en, this message translates to:
  /// **'PDF Preview'**
  String get pdfPreview;

  /// No description provided for @pdfAArchival.
  ///
  /// In en, this message translates to:
  /// **'PDF/A (Archival)'**
  String get pdfAArchival;

  /// No description provided for @percentageColumnWidths.
  ///
  /// In en, this message translates to:
  /// **'Percentage Column Widths'**
  String get percentageColumnWidths;

  /// No description provided for @performance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get performance;

  /// No description provided for @pettyCash.
  ///
  /// In en, this message translates to:
  /// **'Petty Cash'**
  String get pettyCash;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @pickingList.
  ///
  /// In en, this message translates to:
  /// **'Picking List'**
  String get pickingList;

  /// No description provided for @pipelineReport.
  ///
  /// In en, this message translates to:
  /// **'Pipeline Report'**
  String get pipelineReport;

  /// No description provided for @pluginSystem.
  ///
  /// In en, this message translates to:
  /// **'Plugin System'**
  String get pluginSystem;

  /// No description provided for @png.
  ///
  /// In en, this message translates to:
  /// **'PNG'**
  String get png;

  /// No description provided for @positionTracking.
  ///
  /// In en, this message translates to:
  /// **'Position Tracking'**
  String get positionTracking;

  /// No description provided for @prePrintedPhysicalAnchors.
  ///
  /// In en, this message translates to:
  /// **'Pre-printed physical anchors'**
  String get prePrintedPhysicalAnchors;

  /// No description provided for @preciseLayoutControl.
  ///
  /// In en, this message translates to:
  /// **'Precise layout control'**
  String get preciseLayoutControl;

  /// No description provided for @preciseYTrackingFooterAwareRemainingDesc.
  ///
  /// In en, this message translates to:
  /// **'Precise Y tracking, footer-aware remaining space, page breaks, and image alignment.'**
  String get preciseYTrackingFooterAwareRemainingDesc;

  /// No description provided for @preparedBy.
  ///
  /// In en, this message translates to:
  /// **'Prepared By'**
  String get preparedBy;

  /// No description provided for @presentationPrimitives.
  ///
  /// In en, this message translates to:
  /// **'Presentation Primitives'**
  String get presentationPrimitives;

  /// No description provided for @presets.
  ///
  /// In en, this message translates to:
  /// **'Presets'**
  String get presets;

  /// No description provided for @pressRunExampleGenerateDocumentShowDesc.
  ///
  /// In en, this message translates to:
  /// **'Press Run example to generate the document and show its PDF preview here.'**
  String get pressRunExampleGenerateDocumentShowDesc;

  /// No description provided for @pressRunExportGeneratePreviewDesc.
  ///
  /// In en, this message translates to:
  /// **'Press Run export to generate and preview the template.'**
  String get pressRunExportGeneratePreviewDesc;

  /// No description provided for @pressRunExportGenerateTemplateDesc.
  ///
  /// In en, this message translates to:
  /// **'Press Run export to generate the template and inspect the exported HTML.'**
  String get pressRunExportGenerateTemplateDesc;

  /// No description provided for @pressActionButtonGeneratePreviewDesc.
  ///
  /// In en, this message translates to:
  /// **'Press the action button to generate and preview the document.'**
  String get pressActionButtonGeneratePreviewDesc;

  /// No description provided for @pressRunExampleGenerateDocumentShowDesc2.
  ///
  /// In en, this message translates to:
  /// **'Press “Run example” to generate the document and show its PDF preview.'**
  String get pressRunExampleGenerateDocumentShowDesc2;

  /// No description provided for @pressRunExampleGenerateBaselineDesc.
  ///
  /// In en, this message translates to:
  /// **'Press “Run example” to generate this baseline document and display its PDF preview.'**
  String get pressRunExampleGenerateBaselineDesc;

  /// No description provided for @pressRunExampleGenerateDocumentDesc.
  ///
  /// In en, this message translates to:
  /// **'Press “Run example” to generate this document and display its PDF preview.'**
  String get pressRunExampleGenerateDocumentDesc;

  /// No description provided for @preventiveSchedule.
  ///
  /// In en, this message translates to:
  /// **'Preventive Schedule'**
  String get preventiveSchedule;

  /// No description provided for @previousPage.
  ///
  /// In en, this message translates to:
  /// **'Previous page'**
  String get previousPage;

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price Label'**
  String get priceLabel;

  /// No description provided for @priceList.
  ///
  /// In en, this message translates to:
  /// **'Price List'**
  String get priceList;

  /// No description provided for @priceQuotation.
  ///
  /// In en, this message translates to:
  /// **'Price quotation'**
  String get priceQuotation;

  /// No description provided for @printAndPreview.
  ///
  /// In en, this message translates to:
  /// **'Print & Preview'**
  String get printAndPreview;

  /// No description provided for @printDocument.
  ///
  /// In en, this message translates to:
  /// **'Print Document'**
  String get printDocument;

  /// No description provided for @printOnly.
  ///
  /// In en, this message translates to:
  /// **'Print Only'**
  String get printOnly;

  /// No description provided for @printPreview.
  ///
  /// In en, this message translates to:
  /// **'Print Preview'**
  String get printPreview;

  /// No description provided for @printProfiles.
  ///
  /// In en, this message translates to:
  /// **'Print Profiles'**
  String get printProfiles;

  /// No description provided for @printSettings.
  ///
  /// In en, this message translates to:
  /// **'Print Settings'**
  String get printSettings;

  /// No description provided for @printSamplePdfYourConfiguredSettingsDesc.
  ///
  /// In en, this message translates to:
  /// **'Print the sample PDF with your configured settings.'**
  String get printSamplePdfYourConfiguredSettingsDesc;

  /// No description provided for @printWithDialog.
  ///
  /// In en, this message translates to:
  /// **'Print with Dialog'**
  String get printWithDialog;

  /// No description provided for @printerDiscovery.
  ///
  /// In en, this message translates to:
  /// **'Printer Discovery'**
  String get printerDiscovery;

  /// No description provided for @printing.
  ///
  /// In en, this message translates to:
  /// **'Printing'**
  String get printing;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @productA.
  ///
  /// In en, this message translates to:
  /// **'Product A'**
  String get productA;

  /// No description provided for @productCode.
  ///
  /// In en, this message translates to:
  /// **'Product Code'**
  String get productCode;

  /// No description provided for @productionOrder.
  ///
  /// In en, this message translates to:
  /// **'Production Order'**
  String get productionOrder;

  /// No description provided for @productionReceipt.
  ///
  /// In en, this message translates to:
  /// **'Production Receipt'**
  String get productionReceipt;

  /// No description provided for @productionVariance.
  ///
  /// In en, this message translates to:
  /// **'Production Variance'**
  String get productionVariance;

  /// No description provided for @professionalHeaders.
  ///
  /// In en, this message translates to:
  /// **'Professional headers'**
  String get professionalHeaders;

  /// No description provided for @proformaInvoice.
  ///
  /// In en, this message translates to:
  /// **'Proforma Invoice'**
  String get proformaInvoice;

  /// No description provided for @progressReport.
  ///
  /// In en, this message translates to:
  /// **'Progress Report'**
  String get progressReport;

  /// No description provided for @projectBilling.
  ///
  /// In en, this message translates to:
  /// **'Project Billing'**
  String get projectBilling;

  /// No description provided for @projectBudget.
  ///
  /// In en, this message translates to:
  /// **'Project Budget'**
  String get projectBudget;

  /// No description provided for @projectCost.
  ///
  /// In en, this message translates to:
  /// **'Project Cost'**
  String get projectCost;

  /// No description provided for @projectExpense.
  ///
  /// In en, this message translates to:
  /// **'Project Expense'**
  String get projectExpense;

  /// No description provided for @projectFinancial.
  ///
  /// In en, this message translates to:
  /// **'Project Financial'**
  String get projectFinancial;

  /// No description provided for @projectProfitability.
  ///
  /// In en, this message translates to:
  /// **'Project Profitability'**
  String get projectProfitability;

  /// No description provided for @projectPurchasing.
  ///
  /// In en, this message translates to:
  /// **'Project Purchasing'**
  String get projectPurchasing;

  /// No description provided for @projectSummary.
  ///
  /// In en, this message translates to:
  /// **'Project Summary'**
  String get projectSummary;

  /// No description provided for @projectTimesheet.
  ///
  /// In en, this message translates to:
  /// **'Project Timesheet'**
  String get projectTimesheet;

  /// No description provided for @promotionLabel.
  ///
  /// In en, this message translates to:
  /// **'Promotion Label'**
  String get promotionLabel;

  /// No description provided for @proofOfDelivery.
  ///
  /// In en, this message translates to:
  /// **'Proof of Delivery'**
  String get proofOfDelivery;

  /// No description provided for @proposal.
  ///
  /// In en, this message translates to:
  /// **'Proposal'**
  String get proposal;

  /// No description provided for @purchaseAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Purchase Analysis'**
  String get purchaseAnalysis;

  /// No description provided for @purchaseCreditNote.
  ///
  /// In en, this message translates to:
  /// **'Purchase Credit Note'**
  String get purchaseCreditNote;

  /// No description provided for @purchaseDebitNote.
  ///
  /// In en, this message translates to:
  /// **'Purchase Debit Note'**
  String get purchaseDebitNote;

  /// No description provided for @purchaseInvoice.
  ///
  /// In en, this message translates to:
  /// **'Purchase Invoice'**
  String get purchaseInvoice;

  /// No description provided for @purchaseOrder.
  ///
  /// In en, this message translates to:
  /// **'Purchase Order'**
  String get purchaseOrder;

  /// No description provided for @purchaseOrder2.
  ///
  /// In en, this message translates to:
  /// **'Purchase order'**
  String get purchaseOrder2;

  /// No description provided for @purchaseOrderHtmlExport.
  ///
  /// In en, this message translates to:
  /// **'Purchase Order HTML Export'**
  String get purchaseOrderHtmlExport;

  /// No description provided for @purchaseOrderImageExport.
  ///
  /// In en, this message translates to:
  /// **'Purchase Order Image Export'**
  String get purchaseOrderImageExport;

  /// No description provided for @purchaseOrder50Lines.
  ///
  /// In en, this message translates to:
  /// **'Purchase Order — 50 lines'**
  String get purchaseOrder50Lines;

  /// No description provided for @purchaseRegister.
  ///
  /// In en, this message translates to:
  /// **'Purchase Register'**
  String get purchaseRegister;

  /// No description provided for @purchaseRequisition.
  ///
  /// In en, this message translates to:
  /// **'Purchase Requisition'**
  String get purchaseRequisition;

  /// No description provided for @purchaseReturn.
  ///
  /// In en, this message translates to:
  /// **'Purchase Return'**
  String get purchaseReturn;

  /// No description provided for @purchaseReturnVoucherWithPoReference.
  ///
  /// In en, this message translates to:
  /// **'Purchase return voucher with PO reference.'**
  String get purchaseReturnVoucherWithPoReference;

  /// No description provided for @purchaseVoucher.
  ///
  /// In en, this message translates to:
  /// **'Purchase Voucher'**
  String get purchaseVoucher;

  /// No description provided for @purchaseSalesPurchaseReturnSalesDesc.
  ///
  /// In en, this message translates to:
  /// **'Purchase, sales, purchase-return, and sales-return vouchers in one PDF.'**
  String get purchaseSalesPurchaseReturnSalesDesc;

  /// No description provided for @qrAndAttachments.
  ///
  /// In en, this message translates to:
  /// **'QR & Attachments'**
  String get qrAndAttachments;

  /// No description provided for @qrBarcodeBaseline.
  ///
  /// In en, this message translates to:
  /// **'QR / Barcode Baseline'**
  String get qrBarcodeBaseline;

  /// No description provided for @qrCode.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get qrCode;

  /// No description provided for @qrCodes.
  ///
  /// In en, this message translates to:
  /// **'QR Codes'**
  String get qrCodes;

  /// No description provided for @qrCodesAndBarcodes.
  ///
  /// In en, this message translates to:
  /// **'QR Codes & Barcodes'**
  String get qrCodesAndBarcodes;

  /// No description provided for @qrCodesInlineImageAttachmentsImageDesc.
  ///
  /// In en, this message translates to:
  /// **'QR codes, inline image attachments, image pages, and attachment batches.'**
  String get qrCodesInlineImageAttachmentsImageDesc;

  /// No description provided for @quality.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get quality;

  /// No description provided for @qualityChecklist.
  ///
  /// In en, this message translates to:
  /// **'Quality Checklist'**
  String get qualityChecklist;

  /// No description provided for @qualityInspection.
  ///
  /// In en, this message translates to:
  /// **'Quality Inspection'**
  String get qualityInspection;

  /// No description provided for @queueAll.
  ///
  /// In en, this message translates to:
  /// **'Queue all'**
  String get queueAll;

  /// No description provided for @queueGroup.
  ///
  /// In en, this message translates to:
  /// **'Queue group'**
  String get queueGroup;

  /// No description provided for @queueMultiplePdfBuildersObserveDesc.
  ///
  /// In en, this message translates to:
  /// **'Queue multiple PDF builders, observe concurrency and lifecycle state, then retry, cancel, remove, or open completed jobs.'**
  String get queueMultiplePdfBuildersObserveDesc;

  /// No description provided for @queued.
  ///
  /// In en, this message translates to:
  /// **'Queued'**
  String get queued;

  /// No description provided for @quickShare.
  ///
  /// In en, this message translates to:
  /// **'Quick Share'**
  String get quickShare;

  /// No description provided for @quickShareContacts.
  ///
  /// In en, this message translates to:
  /// **'Quick Share Contacts'**
  String get quickShareContacts;

  /// No description provided for @quotation.
  ///
  /// In en, this message translates to:
  /// **'Quotation'**
  String get quotation;

  /// No description provided for @quotationComparison.
  ///
  /// In en, this message translates to:
  /// **'Quotation Comparison'**
  String get quotationComparison;

  /// No description provided for @quotationHtmlExport.
  ///
  /// In en, this message translates to:
  /// **'Quotation HTML Export'**
  String get quotationHtmlExport;

  /// No description provided for @quotationImageExport.
  ///
  /// In en, this message translates to:
  /// **'Quotation Image Export'**
  String get quotationImageExport;

  /// No description provided for @quotation1Line.
  ///
  /// In en, this message translates to:
  /// **'Quotation — 1 line'**
  String get quotation1Line;

  /// No description provided for @rasterizingTemplatePages.
  ///
  /// In en, this message translates to:
  /// **'Rasterizing template pages…'**
  String get rasterizingTemplatePages;

  /// No description provided for @readOnly.
  ///
  /// In en, this message translates to:
  /// **'Read Only'**
  String get readOnly;

  /// No description provided for @readyToRun.
  ///
  /// In en, this message translates to:
  /// **'Ready to run'**
  String get readyToRun;

  /// No description provided for @readyToShare.
  ///
  /// In en, this message translates to:
  /// **'Ready to share!'**
  String get readyToShare;

  /// No description provided for @receiptRegister.
  ///
  /// In en, this message translates to:
  /// **'Receipt Register'**
  String get receiptRegister;

  /// No description provided for @referenceNumber.
  ///
  /// In en, this message translates to:
  /// **'Reference Number'**
  String get referenceNumber;

  /// No description provided for @refundReceipt.
  ///
  /// In en, this message translates to:
  /// **'Refund Receipt'**
  String get refundReceipt;

  /// No description provided for @regenerateSamplePdf.
  ///
  /// In en, this message translates to:
  /// **'Regenerate Sample PDF'**
  String get regenerateSamplePdf;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @registerBuiltInTemplates.
  ///
  /// In en, this message translates to:
  /// **'Register Built-in Templates'**
  String get registerBuiltInTemplates;

  /// No description provided for @registerDemoPlugin.
  ///
  /// In en, this message translates to:
  /// **'Register Demo Plugin'**
  String get registerDemoPlugin;

  /// No description provided for @registerServices.
  ///
  /// In en, this message translates to:
  /// **'Register Services'**
  String get registerServices;

  /// No description provided for @registerDiscoverRenderTemplatesOneDesc.
  ///
  /// In en, this message translates to:
  /// **'Register, discover, and render templates from one registry.'**
  String get registerDiscoverRenderTemplatesOneDesc;

  /// No description provided for @registryFallbackHistory.
  ///
  /// In en, this message translates to:
  /// **'Registry Fallback / History'**
  String get registryFallbackHistory;

  /// No description provided for @regressionVerificationPerformanceDesc.
  ///
  /// In en, this message translates to:
  /// **'Regression verification and performance-oriented examples.'**
  String get regressionVerificationPerformanceDesc;

  /// No description provided for @remittanceVouchers.
  ///
  /// In en, this message translates to:
  /// **'Remittance Vouchers'**
  String get remittanceVouchers;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @renderBuiltInInvoice.
  ///
  /// In en, this message translates to:
  /// **'Render Built-in Invoice'**
  String get renderBuiltInInvoice;

  /// No description provided for @renderBuiltInLetter.
  ///
  /// In en, this message translates to:
  /// **'Render Built-in Letter'**
  String get renderBuiltInLetter;

  /// No description provided for @renderBuiltInReport.
  ///
  /// In en, this message translates to:
  /// **'Render Built-in Report'**
  String get renderBuiltInReport;

  /// No description provided for @renderJsonLetter.
  ///
  /// In en, this message translates to:
  /// **'Render JSON Letter'**
  String get renderJsonLetter;

  /// No description provided for @renderJsonMemo.
  ///
  /// In en, this message translates to:
  /// **'Render JSON Memo'**
  String get renderJsonMemo;

  /// No description provided for @renderProgressEvents.
  ///
  /// In en, this message translates to:
  /// **'Render Progress Events'**
  String get renderProgressEvents;

  /// No description provided for @summaryDataGeniusPdfSummaryStyleDesc.
  ///
  /// In en, this message translates to:
  /// **'Render the same summary data with GeniusPdfSummaryStyle.bordered().'**
  String get summaryDataGeniusPdfSummaryStyleDesc;

  /// No description provided for @summaryDataGeniusPdfSummaryStyleCardDesc.
  ///
  /// In en, this message translates to:
  /// **'Render the same summary data with GeniusPdfSummaryStyle.card().'**
  String get summaryDataGeniusPdfSummaryStyleCardDesc;

  /// No description provided for @summaryDataGeniusPdfSummaryStyleDesc2.
  ///
  /// In en, this message translates to:
  /// **'Render the same summary data with GeniusPdfSummaryStyle.invoice().'**
  String get summaryDataGeniusPdfSummaryStyleDesc2;

  /// No description provided for @summaryDataGeniusPdfSummaryStyleDesc3.
  ///
  /// In en, this message translates to:
  /// **'Render the same summary data with GeniusPdfSummaryStyle.minimal().'**
  String get summaryDataGeniusPdfSummaryStyleDesc3;

  /// No description provided for @reorderReport.
  ///
  /// In en, this message translates to:
  /// **'Reorder Report'**
  String get reorderReport;

  /// No description provided for @repeatedHeadersFooters.
  ///
  /// In en, this message translates to:
  /// **'Repeated Headers / Footers'**
  String get repeatedHeadersFooters;

  /// No description provided for @replacementCustomSection.
  ///
  /// In en, this message translates to:
  /// **'Replacement / custom section'**
  String get replacementCustomSection;

  /// No description provided for @reportComposer.
  ///
  /// In en, this message translates to:
  /// **'Report Composer'**
  String get reportComposer;

  /// No description provided for @reportHeader.
  ///
  /// In en, this message translates to:
  /// **'Report Header'**
  String get reportHeader;

  /// No description provided for @reportHeaderBaseline.
  ///
  /// In en, this message translates to:
  /// **'Report Header Baseline'**
  String get reportHeaderBaseline;

  /// No description provided for @reportHeaderRtl.
  ///
  /// In en, this message translates to:
  /// **'Report Header RTL'**
  String get reportHeaderRtl;

  /// No description provided for @reportId.
  ///
  /// In en, this message translates to:
  /// **'Report ID'**
  String get reportId;

  /// No description provided for @reportInformation.
  ///
  /// In en, this message translates to:
  /// **'Report Information'**
  String get reportInformation;

  /// No description provided for @reportSettings.
  ///
  /// In en, this message translates to:
  /// **'Report Settings'**
  String get reportSettings;

  /// No description provided for @reportTemplates.
  ///
  /// In en, this message translates to:
  /// **'Report Templates'**
  String get reportTemplates;

  /// No description provided for @reportTitleArabic.
  ///
  /// In en, this message translates to:
  /// **'Report Title (Arabic)'**
  String get reportTitleArabic;

  /// No description provided for @reportTitleEnglish.
  ///
  /// In en, this message translates to:
  /// **'Report Title (English)'**
  String get reportTitleEnglish;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @reprint.
  ///
  /// In en, this message translates to:
  /// **'Reprint'**
  String get reprint;

  /// No description provided for @requestForQuotation.
  ///
  /// In en, this message translates to:
  /// **'Request for Quotation'**
  String get requestForQuotation;

  /// No description provided for @requiredFieldFailure.
  ///
  /// In en, this message translates to:
  /// **'Required-field Failure'**
  String get requiredFieldFailure;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @resetContainer.
  ///
  /// In en, this message translates to:
  /// **'Reset Container'**
  String get resetContainer;

  /// No description provided for @resetPluginManager.
  ///
  /// In en, this message translates to:
  /// **'Reset Plugin Manager'**
  String get resetPluginManager;

  /// No description provided for @resolveDependencies.
  ///
  /// In en, this message translates to:
  /// **'Resolve Dependencies'**
  String get resolveDependencies;

  /// No description provided for @resolverPrecedence.
  ///
  /// In en, this message translates to:
  /// **'Resolver Precedence'**
  String get resolverPrecedence;

  /// No description provided for @resourceMeasurementCache.
  ///
  /// In en, this message translates to:
  /// **'Resource / Measurement Cache'**
  String get resourceMeasurementCache;

  /// No description provided for @resourceUtilization.
  ///
  /// In en, this message translates to:
  /// **'Resource Utilization'**
  String get resourceUtilization;

  /// No description provided for @restaurant.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get restaurant;

  /// No description provided for @retail.
  ///
  /// In en, this message translates to:
  /// **'Retail'**
  String get retail;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @reusableComposition.
  ///
  /// In en, this message translates to:
  /// **'Reusable Composition'**
  String get reusableComposition;

  /// No description provided for @revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;

  /// No description provided for @revenueCostSalesOperatingExpensesDesc.
  ///
  /// In en, this message translates to:
  /// **'Revenue, cost of sales, operating expenses, and profitability.'**
  String get revenueCostSalesOperatingExpensesDesc;

  /// No description provided for @richText.
  ///
  /// In en, this message translates to:
  /// **'Rich Text'**
  String get richText;

  /// No description provided for @richTextRtl.
  ///
  /// In en, this message translates to:
  /// **'Rich Text RTL'**
  String get richTextRtl;

  /// No description provided for @richTextInfoBoxesReportHeadersDesc.
  ///
  /// In en, this message translates to:
  /// **'Rich text, info boxes, report headers, flexible columns, and page templates.'**
  String get richTextInfoBoxesReportHeadersDesc;

  /// No description provided for @richTextBaseline.
  ///
  /// In en, this message translates to:
  /// **'RichText Baseline'**
  String get richTextBaseline;

  /// No description provided for @rightToLeftRtl.
  ///
  /// In en, this message translates to:
  /// **'Right-to-Left (RTL)'**
  String get rightToLeftRtl;

  /// No description provided for @risk.
  ///
  /// In en, this message translates to:
  /// **'Risk'**
  String get risk;

  /// No description provided for @roundingReconciliation.
  ///
  /// In en, this message translates to:
  /// **'Rounding / Reconciliation'**
  String get roundingReconciliation;

  /// No description provided for @roundingAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Rounding Adjustment'**
  String get roundingAdjustment;

  /// No description provided for @routingTraveler.
  ///
  /// In en, this message translates to:
  /// **'Routing / Traveler'**
  String get routingTraveler;

  /// No description provided for @rows.
  ///
  /// In en, this message translates to:
  /// **'Rows'**
  String get rows;

  /// No description provided for @rtl.
  ///
  /// In en, this message translates to:
  /// **'RTL'**
  String get rtl;

  /// No description provided for @rtlArabic.
  ///
  /// In en, this message translates to:
  /// **'RTL (Arabic)'**
  String get rtlArabic;

  /// No description provided for @rtlPerColumnDirection.
  ///
  /// In en, this message translates to:
  /// **'RTL / Per-column Direction'**
  String get rtlPerColumnDirection;

  /// No description provided for @sharingActionCompletedEntriesWillDesc.
  ///
  /// In en, this message translates to:
  /// **'Run a sharing action and completed entries will appear here.'**
  String get sharingActionCompletedEntriesWillDesc;

  /// No description provided for @availableActionExplicitlyExecuteDesc.
  ///
  /// In en, this message translates to:
  /// **'Run the available action explicitly to execute this example.'**
  String get availableActionExplicitlyExecuteDesc;

  /// No description provided for @publicPerformanceBenchmarkApiRenderDesc.
  ///
  /// In en, this message translates to:
  /// **'Run the public performance benchmark API and render the measured iteration timing and output-byte diagnostics in a focused PDF.'**
  String get publicPerformanceBenchmarkApiRenderDesc;

  /// No description provided for @s00BaselineAndRegression.
  ///
  /// In en, this message translates to:
  /// **'S00 Baseline & Regression'**
  String get s00BaselineAndRegression;

  /// No description provided for @s00S26Modules.
  ///
  /// In en, this message translates to:
  /// **'S00-S26 modules'**
  String get s00S26Modules;

  /// No description provided for @s01Directionality.
  ///
  /// In en, this message translates to:
  /// **'S01 Directionality'**
  String get s01Directionality;

  /// No description provided for @s02ComponentsRtl.
  ///
  /// In en, this message translates to:
  /// **'S02 Components RTL'**
  String get s02ComponentsRtl;

  /// No description provided for @s03FlowLayout.
  ///
  /// In en, this message translates to:
  /// **'S03 Flow Layout'**
  String get s03FlowLayout;

  /// No description provided for @s04DataGridVNext.
  ///
  /// In en, this message translates to:
  /// **'S04 DataGrid vNext'**
  String get s04DataGridVNext;

  /// No description provided for @s05FormattingAndTheme.
  ///
  /// In en, this message translates to:
  /// **'S05 Formatting & Theme'**
  String get s05FormattingAndTheme;

  /// No description provided for @s06ErpDomainAndCalculations.
  ///
  /// In en, this message translates to:
  /// **'S06 ERP Domain & Calculations'**
  String get s06ErpDomainAndCalculations;

  /// No description provided for @s07ErpSemanticComponents.
  ///
  /// In en, this message translates to:
  /// **'S07 ERP Semantic Components'**
  String get s07ErpSemanticComponents;

  /// No description provided for @s08ErpDocumentFamilies.
  ///
  /// In en, this message translates to:
  /// **'S08 ERP Document Families'**
  String get s08ErpDocumentFamilies;

  /// No description provided for @s09MigratedTransactionTemplates.
  ///
  /// In en, this message translates to:
  /// **'S09 Migrated Transaction Templates'**
  String get s09MigratedTransactionTemplates;

  /// No description provided for @s10TemplateFamilyConsolidation.
  ///
  /// In en, this message translates to:
  /// **'S10 Template Family Consolidation'**
  String get s10TemplateFamilyConsolidation;

  /// No description provided for @s11PrintProfiles.
  ///
  /// In en, this message translates to:
  /// **'S11 Print Profiles'**
  String get s11PrintProfiles;

  /// No description provided for @s12SalesErpPack.
  ///
  /// In en, this message translates to:
  /// **'S12 Sales ERP Pack'**
  String get s12SalesErpPack;

  /// No description provided for @s13PurchasingErpPack.
  ///
  /// In en, this message translates to:
  /// **'S13 Purchasing ERP Pack'**
  String get s13PurchasingErpPack;

  /// No description provided for @s14AccountingAndFinancePack.
  ///
  /// In en, this message translates to:
  /// **'S14 Accounting & Finance Pack'**
  String get s14AccountingAndFinancePack;

  /// No description provided for @s15InventoryAndWmsPack.
  ///
  /// In en, this message translates to:
  /// **'S15 Inventory & WMS Pack'**
  String get s15InventoryAndWmsPack;

  /// No description provided for @s16PosAndRetailPack.
  ///
  /// In en, this message translates to:
  /// **'S16 POS & Retail Pack'**
  String get s16PosAndRetailPack;

  /// No description provided for @s17HrAndPayrollPack.
  ///
  /// In en, this message translates to:
  /// **'S17 HR & Payroll Pack'**
  String get s17HrAndPayrollPack;

  /// No description provided for @s18ManufacturingAndQualityPack.
  ///
  /// In en, this message translates to:
  /// **'S18 Manufacturing & Quality Pack'**
  String get s18ManufacturingAndQualityPack;

  /// No description provided for @s19FixedAssetsAndProjectsPack.
  ///
  /// In en, this message translates to:
  /// **'S19 Fixed Assets & Projects Pack'**
  String get s19FixedAssetsAndProjectsPack;

  /// No description provided for @s20MaintenanceServiceAndLogisticsPack.
  ///
  /// In en, this message translates to:
  /// **'S20 Maintenance, Service & Logistics Pack'**
  String get s20MaintenanceServiceAndLogisticsPack;

  /// No description provided for @s21CrmPack.
  ///
  /// In en, this message translates to:
  /// **'S21 CRM Pack'**
  String get s21CrmPack;

  /// No description provided for @s22TemplateEngineVNext.
  ///
  /// In en, this message translates to:
  /// **'S22 Template Engine vNext'**
  String get s22TemplateEngineVNext;

  /// No description provided for @s23ComplianceSigningAndArchival.
  ///
  /// In en, this message translates to:
  /// **'S23 Compliance, Signing & Archival'**
  String get s23ComplianceSigningAndArchival;

  /// No description provided for @s24PerformanceAndRegression.
  ///
  /// In en, this message translates to:
  /// **'S24 Performance & Regression'**
  String get s24PerformanceAndRegression;

  /// No description provided for @s25TemplateDesigner.
  ///
  /// In en, this message translates to:
  /// **'S25 Template Designer'**
  String get s25TemplateDesigner;

  /// No description provided for @s26IndustryPluginPacks.
  ///
  /// In en, this message translates to:
  /// **'S26 Industry / Plugin Packs'**
  String get s26IndustryPluginPacks;

  /// No description provided for @safeExpressionsPlusAggregates.
  ///
  /// In en, this message translates to:
  /// **'Safe Expressions + Aggregates'**
  String get safeExpressionsPlusAggregates;

  /// No description provided for @salaryCertificate.
  ///
  /// In en, this message translates to:
  /// **'Salary Certificate'**
  String get salaryCertificate;

  /// No description provided for @salesByCustomer.
  ///
  /// In en, this message translates to:
  /// **'Sales by Customer'**
  String get salesByCustomer;

  /// No description provided for @salesByItem.
  ///
  /// In en, this message translates to:
  /// **'Sales by Item'**
  String get salesByItem;

  /// No description provided for @salesBySalesperson.
  ///
  /// In en, this message translates to:
  /// **'Sales by Salesperson'**
  String get salesBySalesperson;

  /// No description provided for @salesDocuments.
  ///
  /// In en, this message translates to:
  /// **'Sales Documents'**
  String get salesDocuments;

  /// No description provided for @salesOrder.
  ///
  /// In en, this message translates to:
  /// **'Sales Order'**
  String get salesOrder;

  /// No description provided for @salesRegister.
  ///
  /// In en, this message translates to:
  /// **'Sales Register'**
  String get salesRegister;

  /// No description provided for @salesReport.
  ///
  /// In en, this message translates to:
  /// **'Sales Report'**
  String get salesReport;

  /// No description provided for @salesReturn.
  ///
  /// In en, this message translates to:
  /// **'Sales Return'**
  String get salesReturn;

  /// No description provided for @salesReturnVoucherWithRefundDetails.
  ///
  /// In en, this message translates to:
  /// **'Sales return voucher with refund details.'**
  String get salesReturnVoucherWithRefundDetails;

  /// No description provided for @salesVoucher.
  ///
  /// In en, this message translates to:
  /// **'Sales Voucher'**
  String get salesVoucher;

  /// No description provided for @saudiEInvoiceQrTlv.
  ///
  /// In en, this message translates to:
  /// **'Saudi e-invoice QR (TLV)'**
  String get saudiEInvoiceQrTlv;

  /// No description provided for @saudiStyleHeader.
  ///
  /// In en, this message translates to:
  /// **'Saudi Style Header'**
  String get saudiStyleHeader;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveAndManageYourFavoritePrintSettings.
  ///
  /// In en, this message translates to:
  /// **'Save and manage your favorite print settings.'**
  String get saveAndManageYourFavoritePrintSettings;

  /// No description provided for @saveCurrentSettings.
  ///
  /// In en, this message translates to:
  /// **'Save Current Settings'**
  String get saveCurrentSettings;

  /// No description provided for @saveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save Profile'**
  String get saveProfile;

  /// No description provided for @saveToDownloads.
  ///
  /// In en, this message translates to:
  /// **'Save to Downloads'**
  String get saveToDownloads;

  /// No description provided for @saveToLocalStorage.
  ///
  /// In en, this message translates to:
  /// **'Save to Local Storage'**
  String get saveToLocalStorage;

  /// No description provided for @savedDevices.
  ///
  /// In en, this message translates to:
  /// **'Saved Devices'**
  String get savedDevices;

  /// No description provided for @savedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully!'**
  String get savedSuccessfully;

  /// No description provided for @scanToOpenWebsite.
  ///
  /// In en, this message translates to:
  /// **'Scan to open website'**
  String get scanToOpenWebsite;

  /// No description provided for @scanToVerify.
  ///
  /// In en, this message translates to:
  /// **'Scan to verify'**
  String get scanToVerify;

  /// No description provided for @scope.
  ///
  /// In en, this message translates to:
  /// **'Scope'**
  String get scope;

  /// No description provided for @scrapReport.
  ///
  /// In en, this message translates to:
  /// **'Scrap Report'**
  String get scrapReport;

  /// No description provided for @searchExamples.
  ///
  /// In en, this message translates to:
  /// **'Search examples'**
  String get searchExamples;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @securityAndCompliance.
  ///
  /// In en, this message translates to:
  /// **'Security & Compliance'**
  String get securityAndCompliance;

  /// No description provided for @securityAccessReport.
  ///
  /// In en, this message translates to:
  /// **'Security Access Report'**
  String get securityAccessReport;

  /// No description provided for @semanticRegression.
  ///
  /// In en, this message translates to:
  /// **'Semantic Regression'**
  String get semanticRegression;

  /// No description provided for @sendPdfDocumentsMessagingCloudDesc.
  ///
  /// In en, this message translates to:
  /// **'Send PDF documents to messaging, cloud, and external applications.'**
  String get sendPdfDocumentsMessagingCloudDesc;

  /// No description provided for @serialLabel.
  ///
  /// In en, this message translates to:
  /// **'Serial Label'**
  String get serialLabel;

  /// No description provided for @serialReport.
  ///
  /// In en, this message translates to:
  /// **'Serial Report'**
  String get serialReport;

  /// No description provided for @serviceCompletion.
  ///
  /// In en, this message translates to:
  /// **'Service Completion'**
  String get serviceCompletion;

  /// No description provided for @serviceOrder.
  ///
  /// In en, this message translates to:
  /// **'Service Order'**
  String get serviceOrder;

  /// No description provided for @serviceVouchers.
  ///
  /// In en, this message translates to:
  /// **'Service Vouchers'**
  String get serviceVouchers;

  /// No description provided for @shareHistory.
  ///
  /// In en, this message translates to:
  /// **'Share History'**
  String get shareHistory;

  /// No description provided for @sharePdfsThroughTheUnifiedSharingService.
  ///
  /// In en, this message translates to:
  /// **'Share PDFs through the unified sharing service.'**
  String get sharePdfsThroughTheUnifiedSharingService;

  /// No description provided for @shareViaBluetooth.
  ///
  /// In en, this message translates to:
  /// **'Share via Bluetooth'**
  String get shareViaBluetooth;

  /// No description provided for @shareViaEmail.
  ///
  /// In en, this message translates to:
  /// **'Share via Email'**
  String get shareViaEmail;

  /// No description provided for @sharedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Shared successfully!'**
  String get sharedSuccessfully;

  /// No description provided for @sharing.
  ///
  /// In en, this message translates to:
  /// **'Sharing'**
  String get sharing;

  /// No description provided for @shelfLabel.
  ///
  /// In en, this message translates to:
  /// **'Shelf Label'**
  String get shelfLabel;

  /// No description provided for @shiftClose.
  ///
  /// In en, this message translates to:
  /// **'Shift Close'**
  String get shiftClose;

  /// No description provided for @shiftOpen.
  ///
  /// In en, this message translates to:
  /// **'Shift Open'**
  String get shiftOpen;

  /// No description provided for @shipmentDeliveryConfirmationDesc.
  ///
  /// In en, this message translates to:
  /// **'Shipment and delivery confirmation with recipient and quantity details.'**
  String get shipmentDeliveryConfirmationDesc;

  /// No description provided for @shipmentDocument.
  ///
  /// In en, this message translates to:
  /// **'Shipment Document'**
  String get shipmentDocument;

  /// No description provided for @shippingAndPayment.
  ///
  /// In en, this message translates to:
  /// **'Shipping & Payment'**
  String get shippingAndPayment;

  /// No description provided for @shippingLabel.
  ///
  /// In en, this message translates to:
  /// **'Shipping Label'**
  String get shippingLabel;

  /// No description provided for @elegantPastelBorderedMinimalSaudiDesc.
  ///
  /// In en, this message translates to:
  /// **'Show elegant, pastel, bordered, minimal, Saudi, and invoice grid styles with their default or customized primary colors.'**
  String get elegantPastelBorderedMinimalSaudiDesc;

  /// No description provided for @showTotalsRow.
  ///
  /// In en, this message translates to:
  /// **'Show Totals Row'**
  String get showTotalsRow;

  /// No description provided for @showcase.
  ///
  /// In en, this message translates to:
  /// **'Showcase'**
  String get showcase;

  /// No description provided for @showcaseComponents.
  ///
  /// In en, this message translates to:
  /// **'Showcase Components'**
  String get showcaseComponents;

  /// No description provided for @sideBySideLayoutBlocks.
  ///
  /// In en, this message translates to:
  /// **'Side-by-side layout blocks'**
  String get sideBySideLayoutBlocks;

  /// No description provided for @signal.
  ///
  /// In en, this message translates to:
  /// **'Signal'**
  String get signal;

  /// No description provided for @signatureAppearance.
  ///
  /// In en, this message translates to:
  /// **'Signature appearance'**
  String get signatureAppearance;

  /// No description provided for @signatureArea.
  ///
  /// In en, this message translates to:
  /// **'Signature Area'**
  String get signatureArea;

  /// No description provided for @signaturePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Signature placeholder'**
  String get signaturePlaceholder;

  /// No description provided for @simpleDocument.
  ///
  /// In en, this message translates to:
  /// **'Simple Document'**
  String get simpleDocument;

  /// No description provided for @simplifiedPosInvoice.
  ///
  /// In en, this message translates to:
  /// **'Simplified / POS Invoice'**
  String get simplifiedPosInvoice;

  /// No description provided for @singleLabel.
  ///
  /// In en, this message translates to:
  /// **'Single label'**
  String get singleLabel;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @slowDeadStock.
  ///
  /// In en, this message translates to:
  /// **'Slow / Dead Stock'**
  String get slowDeadStock;

  /// No description provided for @smartLayout.
  ///
  /// In en, this message translates to:
  /// **'Smart Layout'**
  String get smartLayout;

  /// No description provided for @spansBuildersConditionalStyle.
  ///
  /// In en, this message translates to:
  /// **'Spans / Builders / Conditional Style'**
  String get spansBuildersConditionalStyle;

  /// No description provided for @sparePartsUsage.
  ///
  /// In en, this message translates to:
  /// **'Spare Parts Usage'**
  String get sparePartsUsage;

  /// No description provided for @specialB5SizedPaymentVoucher.
  ///
  /// In en, this message translates to:
  /// **'Special B5-sized payment voucher.'**
  String get specialB5SizedPaymentVoucher;

  /// No description provided for @standardInvoiceReportHeaderCompanyDesc.
  ///
  /// In en, this message translates to:
  /// **'Standard invoice report header with company identity, document number, print date, and invoice styling.'**
  String get standardInvoiceReportHeaderCompanyDesc;

  /// No description provided for @startWithTheWorkflowYouNeed.
  ///
  /// In en, this message translates to:
  /// **'Start with the workflow you need'**
  String get startWithTheWorkflowYouNeed;

  /// No description provided for @statementFamily.
  ///
  /// In en, this message translates to:
  /// **'Statement family'**
  String get statementFamily;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @stockAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Stock Adjustment'**
  String get stockAdjustment;

  /// No description provided for @stockAvailability.
  ///
  /// In en, this message translates to:
  /// **'Stock Availability'**
  String get stockAvailability;

  /// No description provided for @stockCount.
  ///
  /// In en, this message translates to:
  /// **'Stock Count'**
  String get stockCount;

  /// No description provided for @stockIssue.
  ///
  /// In en, this message translates to:
  /// **'Stock Issue'**
  String get stockIssue;

  /// No description provided for @stockLedger.
  ///
  /// In en, this message translates to:
  /// **'Stock Ledger'**
  String get stockLedger;

  /// No description provided for @stockReceipt.
  ///
  /// In en, this message translates to:
  /// **'Stock Receipt'**
  String get stockReceipt;

  /// No description provided for @stockTransfer.
  ///
  /// In en, this message translates to:
  /// **'Stock Transfer'**
  String get stockTransfer;

  /// No description provided for @stockValuation.
  ///
  /// In en, this message translates to:
  /// **'Stock Valuation'**
  String get stockValuation;

  /// No description provided for @stringWebLinkExtension.
  ///
  /// In en, this message translates to:
  /// **'String Web-Link Extension'**
  String get stringWebLinkExtension;

  /// No description provided for @structuredHighlightsList.
  ///
  /// In en, this message translates to:
  /// **'Structured highlights list'**
  String get structuredHighlightsList;

  /// No description provided for @styledTextAndBadges.
  ///
  /// In en, this message translates to:
  /// **'Styled text and badges'**
  String get styledTextAndBadges;

  /// No description provided for @styledTextWithColors.
  ///
  /// In en, this message translates to:
  /// **'Styled text with colors'**
  String get styledTextWithColors;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @successAndErrorStates.
  ///
  /// In en, this message translates to:
  /// **'Success & Error States'**
  String get successAndErrorStates;

  /// No description provided for @suggestColorScheme.
  ///
  /// In en, this message translates to:
  /// **'Suggest Color Scheme'**
  String get suggestColorScheme;

  /// No description provided for @suggestMargins.
  ///
  /// In en, this message translates to:
  /// **'Suggest Margins'**
  String get suggestMargins;

  /// No description provided for @summarizeLongText.
  ///
  /// In en, this message translates to:
  /// **'Summarize Long Text'**
  String get summarizeLongText;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @summaryGridInfoConsistency.
  ///
  /// In en, this message translates to:
  /// **'Summary / Grid / Info Consistency'**
  String get summaryGridInfoConsistency;

  /// No description provided for @summaryBaseline.
  ///
  /// In en, this message translates to:
  /// **'Summary Baseline'**
  String get summaryBaseline;

  /// No description provided for @summaryRtl.
  ///
  /// In en, this message translates to:
  /// **'Summary RTL'**
  String get summaryRtl;

  /// No description provided for @summarySettings.
  ///
  /// In en, this message translates to:
  /// **'Summary Settings'**
  String get summarySettings;

  /// No description provided for @supplierAging.
  ///
  /// In en, this message translates to:
  /// **'Supplier Aging'**
  String get supplierAging;

  /// No description provided for @supplierBalances.
  ///
  /// In en, this message translates to:
  /// **'Supplier Balances'**
  String get supplierBalances;

  /// No description provided for @supplierQuotation.
  ///
  /// In en, this message translates to:
  /// **'Supplier Quotation'**
  String get supplierQuotation;

  /// No description provided for @supplierReturn.
  ///
  /// In en, this message translates to:
  /// **'Supplier Return'**
  String get supplierReturn;

  /// No description provided for @supplierStatement.
  ///
  /// In en, this message translates to:
  /// **'Supplier Statement'**
  String get supplierStatement;

  /// No description provided for @switchGeneratedSampleBetweenRtlLtrDesc.
  ///
  /// In en, this message translates to:
  /// **'Switch the generated sample between RTL and LTR content.'**
  String get switchGeneratedSampleBetweenRtlLtrDesc;

  /// No description provided for @switchToArabic.
  ///
  /// In en, this message translates to:
  /// **'Switch to Arabic'**
  String get switchToArabic;

  /// No description provided for @switchToEnglish.
  ///
  /// In en, this message translates to:
  /// **'Switch to English'**
  String get switchToEnglish;

  /// No description provided for @systemPresets.
  ///
  /// In en, this message translates to:
  /// **'System Presets'**
  String get systemPresets;

  /// No description provided for @systemShareSheet.
  ///
  /// In en, this message translates to:
  /// **'System Share Sheet'**
  String get systemShareSheet;

  /// No description provided for @tablesWithRtlSupport.
  ///
  /// In en, this message translates to:
  /// **'Tables with RTL support'**
  String get tablesWithRtlSupport;

  /// No description provided for @tablesSummariesHeadersRichTextInfoDesc.
  ///
  /// In en, this message translates to:
  /// **'Tables, summaries, headers, rich text, info boxes, QR combinations, and RTL cases.'**
  String get tablesSummariesHeadersRichTextInfoDesc;

  /// No description provided for @tabularDataWithTotals.
  ///
  /// In en, this message translates to:
  /// **'Tabular data with totals'**
  String get tabularDataWithTotals;

  /// No description provided for @tax15Percent.
  ///
  /// In en, this message translates to:
  /// **'Tax (15%)'**
  String get tax15Percent;

  /// No description provided for @taxAmount.
  ///
  /// In en, this message translates to:
  /// **'Tax Amount'**
  String get taxAmount;

  /// No description provided for @taxBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Tax Breakdown'**
  String get taxBreakdown;

  /// No description provided for @taxInvoice.
  ///
  /// In en, this message translates to:
  /// **'Tax Invoice'**
  String get taxInvoice;

  /// No description provided for @taxInvoice500Lines.
  ///
  /// In en, this message translates to:
  /// **'Tax Invoice — 500 lines'**
  String get taxInvoice500Lines;

  /// No description provided for @taxRegister.
  ///
  /// In en, this message translates to:
  /// **'Tax Register'**
  String get taxRegister;

  /// No description provided for @technicianReport.
  ///
  /// In en, this message translates to:
  /// **'Technician Report'**
  String get technicianReport;

  /// No description provided for @telegram.
  ///
  /// In en, this message translates to:
  /// **'Telegram'**
  String get telegram;

  /// No description provided for @templateBuilder.
  ///
  /// In en, this message translates to:
  /// **'Template Builder'**
  String get templateBuilder;

  /// No description provided for @templateEngine.
  ///
  /// In en, this message translates to:
  /// **'Template Engine'**
  String get templateEngine;

  /// No description provided for @templateFamilyAudit.
  ///
  /// In en, this message translates to:
  /// **'Template Family Audit'**
  String get templateFamilyAudit;

  /// No description provided for @templateHtmlExport.
  ///
  /// In en, this message translates to:
  /// **'Template HTML Export'**
  String get templateHtmlExport;

  /// No description provided for @templateImageExport.
  ///
  /// In en, this message translates to:
  /// **'Template Image Export'**
  String get templateImageExport;

  /// No description provided for @templateRegistry.
  ///
  /// In en, this message translates to:
  /// **'Template Registry'**
  String get templateRegistry;

  /// No description provided for @templates.
  ///
  /// In en, this message translates to:
  /// **'Templates'**
  String get templates;

  /// No description provided for @templatesAndReports.
  ///
  /// In en, this message translates to:
  /// **'Templates & Reports'**
  String get templatesAndReports;

  /// No description provided for @templatesAndTemplateEngine.
  ///
  /// In en, this message translates to:
  /// **'Templates & Template Engine'**
  String get templatesAndTemplateEngine;

  /// No description provided for @text.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get text;

  /// No description provided for @textDirection.
  ///
  /// In en, this message translates to:
  /// **'Text direction'**
  String get textDirection;

  /// No description provided for @textServices.
  ///
  /// In en, this message translates to:
  /// **'Text Services'**
  String get textServices;

  /// No description provided for @textSummarizationLanguageDetectionDesc.
  ///
  /// In en, this message translates to:
  /// **'Text summarization, language detection, and smart title generation'**
  String get textSummarizationLanguageDetectionDesc;

  /// No description provided for @textWatermarks.
  ///
  /// In en, this message translates to:
  /// **'Text watermarks'**
  String get textWatermarks;

  /// No description provided for @textTypographyAndDirection.
  ///
  /// In en, this message translates to:
  /// **'Text, Typography & Direction'**
  String get textTypographyAndDirection;

  /// No description provided for @textSpanWebLinkFactory.
  ///
  /// In en, this message translates to:
  /// **'TextSpan Web Link Factory'**
  String get textSpanWebLinkFactory;

  /// No description provided for @exampleApplicationIsOrganizedDesc.
  ///
  /// In en, this message translates to:
  /// **'The example application is organized by responsibility instead of release sequence. Screen codes remain searchable for developers who know the S00-S26 module names.'**
  String get exampleApplicationIsOrganizedDesc;

  /// No description provided for @navigationKeepsOriginalS00S26Desc.
  ///
  /// In en, this message translates to:
  /// **'The navigation keeps the original S00-S26 verification modules and all existing demos as separate destinations. Similar examples are grouped together rather than merged or removed.'**
  String get navigationKeepsOriginalS00S26Desc;

  /// No description provided for @previewExportedBytesSavedExampleDesc.
  ///
  /// In en, this message translates to:
  /// **'The preview uses the same exported bytes saved by this example.'**
  String get previewExportedBytesSavedExampleDesc;

  /// No description provided for @theSelectedExampleIsBeingExecuted.
  ///
  /// In en, this message translates to:
  /// **'The selected example is being executed.'**
  String get theSelectedExampleIsBeingExecuted;

  /// No description provided for @sourceBelowIsDecodedDirectlyExactDesc.
  ///
  /// In en, this message translates to:
  /// **'The source below is decoded directly from the exact HTML bytes returned by GeniusPdfExportService.'**
  String get sourceBelowIsDecodedDirectlyExactDesc;

  /// No description provided for @themeDesignTokens.
  ///
  /// In en, this message translates to:
  /// **'Theme / Design Tokens'**
  String get themeDesignTokens;

  /// No description provided for @thermal80.
  ///
  /// In en, this message translates to:
  /// **'Thermal 80'**
  String get thermal80;

  /// No description provided for @thermalReceipt.
  ///
  /// In en, this message translates to:
  /// **'Thermal receipt'**
  String get thermalReceipt;

  /// No description provided for @tiledPatternWatermark.
  ///
  /// In en, this message translates to:
  /// **'Tiled pattern watermark'**
  String get tiledPatternWatermark;

  /// No description provided for @tiledWatermark.
  ///
  /// In en, this message translates to:
  /// **'Tiled Watermark'**
  String get tiledWatermark;

  /// No description provided for @timesheet.
  ///
  /// In en, this message translates to:
  /// **'Timesheet'**
  String get timesheet;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @totalsAndCalculations.
  ///
  /// In en, this message translates to:
  /// **'Totals & calculations'**
  String get totalsAndCalculations;

  /// No description provided for @totalsAndCalculations2.
  ///
  /// In en, this message translates to:
  /// **'Totals and calculations'**
  String get totalsAndCalculations2;

  /// No description provided for @trackingBarcode.
  ///
  /// In en, this message translates to:
  /// **'Tracking barcode'**
  String get trackingBarcode;

  /// No description provided for @tradeVouchers.
  ///
  /// In en, this message translates to:
  /// **'Trade Vouchers'**
  String get tradeVouchers;

  /// No description provided for @transactionFamily.
  ///
  /// In en, this message translates to:
  /// **'Transaction family'**
  String get transactionFamily;

  /// No description provided for @trialBalance.
  ///
  /// In en, this message translates to:
  /// **'Trial Balance'**
  String get trialBalance;

  /// No description provided for @trialBalanceHtmlExport.
  ///
  /// In en, this message translates to:
  /// **'Trial Balance HTML Export'**
  String get trialBalanceHtmlExport;

  /// No description provided for @trialBalanceImageExport.
  ///
  /// In en, this message translates to:
  /// **'Trial Balance Image Export'**
  String get trialBalanceImageExport;

  /// No description provided for @trialBalanceReport.
  ///
  /// In en, this message translates to:
  /// **'Trial balance report'**
  String get trialBalanceReport;

  /// No description provided for @tripReport.
  ///
  /// In en, this message translates to:
  /// **'Trip Report'**
  String get tripReport;

  /// No description provided for @tripSheet.
  ///
  /// In en, this message translates to:
  /// **'Trip Sheet'**
  String get tripSheet;

  /// No description provided for @twoColumns.
  ///
  /// In en, this message translates to:
  /// **'Two Columns'**
  String get twoColumns;

  /// No description provided for @url.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get url;

  /// No description provided for @urlQrCode.
  ///
  /// In en, this message translates to:
  /// **'URL QR Code'**
  String get urlQrCode;

  /// No description provided for @useArabicAsPrimaryLanguage.
  ///
  /// In en, this message translates to:
  /// **'Use Arabic as primary language'**
  String get useArabicAsPrimaryLanguage;

  /// No description provided for @useDarkTheme.
  ///
  /// In en, this message translates to:
  /// **'Use dark theme'**
  String get useDarkTheme;

  /// No description provided for @geniusDataGridUtilsAutoGroupConvertDesc.
  ///
  /// In en, this message translates to:
  /// **'Use GeniusDataGridUtils.autoGroup to convert ordinary rows into grouped sections with automatically generated summaries.'**
  String get geniusDataGridUtilsAutoGroupConvertDesc;

  /// No description provided for @geniusPdfRichTextBuilderHeadingsDesc.
  ///
  /// In en, this message translates to:
  /// **'Use GeniusPdfRichTextBuilder for headings, labels, currency, badges, highlights, strike-through, and superscript text.'**
  String get geniusPdfRichTextBuilderHeadingsDesc;

  /// No description provided for @geniusPdfSummaryGroupIncomeExpenseDesc.
  ///
  /// In en, this message translates to:
  /// **'Use GeniusPdfSummaryGroup income and expense sections with subtotals and an overall total.'**
  String get geniusPdfSummaryGroupIncomeExpenseDesc;

  /// No description provided for @useLightTheme.
  ///
  /// In en, this message translates to:
  /// **'Use light theme'**
  String get useLightTheme;

  /// No description provided for @validationMessages.
  ///
  /// In en, this message translates to:
  /// **'Validation Messages'**
  String get validationMessages;

  /// No description provided for @vat15Percent.
  ///
  /// In en, this message translates to:
  /// **'VAT (15%)'**
  String get vat15Percent;

  /// No description provided for @vatTaxSummary.
  ///
  /// In en, this message translates to:
  /// **'VAT / Tax Summary'**
  String get vatTaxSummary;

  /// No description provided for @vCardContact.
  ///
  /// In en, this message translates to:
  /// **'vCard Contact'**
  String get vCardContact;

  /// No description provided for @vendorPurchaseOrderItemsDeliveryDateDesc.
  ///
  /// In en, this message translates to:
  /// **'Vendor purchase order with items, delivery date, terms, and tax.'**
  String get vendorPurchaseOrderItemsDeliveryDateDesc;

  /// No description provided for @verification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verification;

  /// No description provided for @verifyHeaderBlocksBilingualTextDesc.
  ///
  /// In en, this message translates to:
  /// **'Verify header blocks, bilingual text, and document metadata using the focused invoice-header builder.'**
  String get verifyHeaderBlocksBilingualTextDesc;

  /// No description provided for @verifyHeadersRowsNumericCellsFooterDesc.
  ///
  /// In en, this message translates to:
  /// **'Verify headers, rows, numeric cells, footer totals, and page flow using the focused invoice/footer-row DataGrid builder.'**
  String get verifyHeadersRowsNumericCellsFooterDesc;

  /// No description provided for @verifyLabelValuePlacementIconDesc.
  ///
  /// In en, this message translates to:
  /// **'Verify label/value placement, icon placement, and mixed numeric/Latin values using the focused InfoBox builder.'**
  String get verifyLabelValuePlacementIconDesc;

  /// No description provided for @verifyLongContentPageFlowTransitionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Verify long-content page flow and transitions across multiple pages in both LTR and RTL modes.'**
  String get verifyLongContentPageFlowTransitionsDesc;

  /// No description provided for @verifyMixedArabicLatinErpLabelsDesc.
  ///
  /// In en, this message translates to:
  /// **'Verify mixed Arabic/Latin ERP labels, document identifiers, amounts, IBAN, phone, email, URL, and empty values against the S00 baseline.'**
  String get verifyMixedArabicLatinErpLabelsDesc;

  /// No description provided for @verifyQrRenderingDocumentDesc.
  ///
  /// In en, this message translates to:
  /// **'Verify QR rendering in document directionality scenarios using the focused ZATCA invoice QR builder.'**
  String get verifyQrRenderingDocumentDesc;

  /// No description provided for @verifyRepeatedMeasurementRequestsDesc.
  ///
  /// In en, this message translates to:
  /// **'Verify repeated measurement requests reuse one cached calculation while the generated PDF records the requested row count.'**
  String get verifyRepeatedMeasurementRequestsDesc;

  /// No description provided for @verifyRichTextSafelyContinuesNewPageDesc.
  ///
  /// In en, this message translates to:
  /// **'Verify rich text safely continues on a new page when the current page is close to the footer boundary.'**
  String get verifyRichTextSafelyContinuesNewPageDesc;

  /// No description provided for @verifyRichTextWrappingInlineDesc.
  ///
  /// In en, this message translates to:
  /// **'Verify rich-text wrapping, inline formatting, and layout stability using the focused fluent-formatting builder.'**
  String get verifyRichTextWrappingInlineDesc;

  /// No description provided for @verifySubtotalVatGrandTotalWrappingDesc.
  ///
  /// In en, this message translates to:
  /// **'Verify subtotal, VAT, grand total, wrapping, highlighting, and summary placement using the focused invoice-summary builder.'**
  String get verifySubtotalVatGrandTotalWrappingDesc;

  /// No description provided for @verifyMultiRowInfoBoxMovesSafelyNewDesc.
  ///
  /// In en, this message translates to:
  /// **'Verify that a multi-row info box moves safely to a new page when insufficient footer space remains.'**
  String get verifyMultiRowInfoBoxMovesSafelyNewDesc;

  /// No description provided for @verifyWatermarkVisibilityOrientationDesc.
  ///
  /// In en, this message translates to:
  /// **'Verify watermark visibility, orientation, and clipping using the focused confidential-audit watermark builder.'**
  String get verifyWatermarkVisibilityOrientationDesc;

  /// No description provided for @versionedSchemaPlusElements.
  ///
  /// In en, this message translates to:
  /// **'Versioned Schema + Elements'**
  String get versionedSchemaPlusElements;

  /// No description provided for @visitReport.
  ///
  /// In en, this message translates to:
  /// **'Visit Report'**
  String get visitReport;

  /// No description provided for @visitWebsite.
  ///
  /// In en, this message translates to:
  /// **'Visit Website'**
  String get visitWebsite;

  /// No description provided for @visualSignature.
  ///
  /// In en, this message translates to:
  /// **'Visual Signature'**
  String get visualSignature;

  /// No description provided for @voucherFamily.
  ///
  /// In en, this message translates to:
  /// **'Voucher family'**
  String get voucherFamily;

  /// No description provided for @warehouseTransfer.
  ///
  /// In en, this message translates to:
  /// **'Warehouse Transfer'**
  String get warehouseTransfer;

  /// No description provided for @warrantyReport.
  ///
  /// In en, this message translates to:
  /// **'Warranty Report'**
  String get warrantyReport;

  /// No description provided for @watermark.
  ///
  /// In en, this message translates to:
  /// **'Watermark'**
  String get watermark;

  /// No description provided for @watermarkBaseline.
  ///
  /// In en, this message translates to:
  /// **'Watermark Baseline'**
  String get watermarkBaseline;

  /// No description provided for @watermarks.
  ///
  /// In en, this message translates to:
  /// **'Watermarks'**
  String get watermarks;

  /// No description provided for @waybill.
  ///
  /// In en, this message translates to:
  /// **'Waybill'**
  String get waybill;

  /// No description provided for @webLinks.
  ///
  /// In en, this message translates to:
  /// **'Web Links'**
  String get webLinks;

  /// No description provided for @whatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsApp;

  /// No description provided for @widget.
  ///
  /// In en, this message translates to:
  /// **'Widget'**
  String get widget;

  /// No description provided for @wiFiConfig.
  ///
  /// In en, this message translates to:
  /// **'WiFi Config'**
  String get wiFiConfig;

  /// No description provided for @wiFiConnectionQr.
  ///
  /// In en, this message translates to:
  /// **'WiFi connection QR'**
  String get wiFiConnectionQr;

  /// No description provided for @workInProgress.
  ///
  /// In en, this message translates to:
  /// **'Work in Progress'**
  String get workInProgress;

  /// No description provided for @workOrder.
  ///
  /// In en, this message translates to:
  /// **'Work Order'**
  String get workOrder;

  /// No description provided for @xReport.
  ///
  /// In en, this message translates to:
  /// **'X Report'**
  String get xReport;

  /// No description provided for @yourProfiles.
  ///
  /// In en, this message translates to:
  /// **'Your Profiles'**
  String get yourProfiles;

  /// No description provided for @zReport.
  ///
  /// In en, this message translates to:
  /// **'Z Report'**
  String get zReport;

  /// No description provided for @zatcaEInvoiceQr.
  ///
  /// In en, this message translates to:
  /// **'ZATCA E-Invoice QR'**
  String get zatcaEInvoiceQr;

  /// No description provided for @zatcaInvoice.
  ///
  /// In en, this message translates to:
  /// **'ZATCA Invoice'**
  String get zatcaInvoice;

  /// No description provided for @zatcaInvoiceTemplate.
  ///
  /// In en, this message translates to:
  /// **'ZATCA invoice template'**
  String get zatcaInvoiceTemplate;

  /// No description provided for @zatcaOrientedTaxInvoiceExampleDesc.
  ///
  /// In en, this message translates to:
  /// **'ZATCA-oriented tax invoice example with company and customer data, line items, totals, and bilingual document direction.'**
  String get zatcaOrientedTaxInvoiceExampleDesc;

  /// No description provided for @zeroNegativePolicy.
  ///
  /// In en, this message translates to:
  /// **'Zero / Negative Policy'**
  String get zeroNegativePolicy;
}

class _PDFGeneratorLocalizationDelegate
    extends LocalizationsDelegate<PDFGeneratorLocalization> {
  const _PDFGeneratorLocalizationDelegate();

  @override
  Future<PDFGeneratorLocalization> load(Locale locale) {
    return SynchronousFuture<PDFGeneratorLocalization>(
      lookupPDFGeneratorLocalization(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_PDFGeneratorLocalizationDelegate old) => false;
}

PDFGeneratorLocalization lookupPDFGeneratorLocalization(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return PDFGeneratorLocalizationAr();
    case 'en':
      return PDFGeneratorLocalizationEn();
  }

  throw FlutterError(
    'PDFGeneratorLocalization.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
