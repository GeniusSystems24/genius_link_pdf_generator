import 'dart:typed_data';
import 'dart:ui' show Rect;

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:genius_pdf_example/features/components/models/documents/components/data_grid_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/data_grid_invoice_footer_rows_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/data_grid_auto_totals_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/data_grid_nested_groups_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/data_grid_auto_grouping_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/data_grid_percentage_widths_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/data_grid_style_showcase_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/data_grid_custom_styles_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/grid_infobox_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/grid_infobox_order_document_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/grid_infobox_shipping_payment_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/grid_qrcode_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/grid_qrcode_zatca_invoice_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/grid_qrcode_inventory_tracking_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/grid_richtext_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/grid_richtext_financial_analysis_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/grid_richtext_expense_recommendations_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/grid_watermark_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/grid_watermark_confidential_audit_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/grid_watermark_security_access_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/headers_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/headers_invoice_header_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/headers_bilingual_split_header_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/headers_bilingual_rtl_header_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/headers_corporate_groups_header_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/headers_saudi_style_header_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/headers_letterhead_header_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/headers_minimal_header_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/headers_full_details_header_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/info_box_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/info_box_customer_company_info_boxes_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/info_box_info_warning_boxes_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/info_box_success_error_boxes_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/info_box_keep_together_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/rich_text_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/rich_text_fluent_formatting_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/rich_text_bullet_list_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/rich_text_markdown_text_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/rich_text_builder_links_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/rich_text_auto_detected_links_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/rich_text_colored_links_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/rich_text_keep_together_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/summary_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/summary_basic_invoice_summary_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/summary_grouped_summary_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/summary_indented_summary_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/summary_invoice_style_summary_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/summary_card_style_summary_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/summary_bordered_style_summary_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/summary_minimal_style_summary_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/summary_advanced_grouped_summary_demo_builder.dart';

import 'package:genius_pdf_example/features/components/models/documents/components/web_link_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/web_link_builder_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/web_link_factory_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/web_link_string_extension_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/web_link_font_sizing_demo_builder.dart';
import 'package:genius_pdf_example/features/components/models/documents/components/web_link_mixed_styles_demo_builder.dart';
Future<Uint8List> buildComponentDemoBytes({
  required String component,
  required GeniusPdfConfig config,
}) async {
  final GeniusPdfDocumentBuilder builder;
  switch (component) {
    case 'data_grid_invoice_footer_rows':
      builder = DataGridInvoiceFooterRowsDemoBuilder(config);
      break;
    case 'data_grid_auto_totals':
      builder = DataGridAutoTotalsDemoBuilder(config);
      break;
    case 'data_grid_nested_groups':
      builder = DataGridNestedGroupsDemoBuilder(config);
      break;
    case 'data_grid_auto_grouping':
      builder = DataGridAutoGroupingDemoBuilder(config);
      break;
    case 'data_grid_percentage_widths':
      builder = DataGridPercentageWidthsDemoBuilder(config);
      break;
    case 'data_grid_style_showcase':
      builder = DataGridStyleShowcaseDemoBuilder(config);
      break;
    case 'data_grid_custom_styles':
      builder = DataGridCustomStylesDemoBuilder(config);
      break;
    case 'data_grid':
      builder = DataGridDemoBuilder(config);
      break;
    case 'rich_text_fluent_formatting':
      builder = RichTextFluentFormattingDemoBuilder(config);
      break;
    case 'rich_text_bullet_list':
      builder = RichTextBulletListDemoBuilder(config);
      break;
    case 'rich_text_markdown':
      builder = RichTextMarkdownDemoBuilder(config);
      break;
    case 'rich_text_links':
      builder = RichTextBuilderLinksDemoBuilder(config);
      break;
    case 'rich_text_auto_links':
      builder = RichTextAutoDetectedLinksDemoBuilder(config);
      break;
    case 'rich_text_colored_links':
      builder = RichTextColoredLinksDemoBuilder(config);
      break;
    case 'rich_text_keep_together':
      builder = RichTextKeepTogetherDemoBuilder(config);
      break;
    case 'rich_text':
      builder = RichTextDemoBuilder(config);
      break;
    case 'info_box_customer_company':
      builder = CustomerCompanyInfoBoxesDemoBuilder(config);
      break;
    case 'info_box_info_warning':
      builder = InfoWarningBoxesDemoBuilder(config);
      break;
    case 'info_box_success_error':
      builder = SuccessErrorBoxesDemoBuilder(config);
      break;
    case 'info_box_keep_together':
      builder = InfoBoxKeepTogetherDemoBuilder(config);
      break;
    case 'info_box':
      builder = InfoBoxDemoBuilder(config);
      break;
    case 'headers_invoice':
      builder = InvoiceHeaderDemoBuilder(config);
      break;
    case 'headers_bilingual_split':
      builder = BilingualSplitHeaderDemoBuilder(config);
      break;
    case 'headers_bilingual_rtl':
      builder = BilingualRtlHeaderDemoBuilder(config);
      break;
    case 'headers_corporate_groups':
      builder = CorporateGroupsHeaderDemoBuilder(config);
      break;
    case 'headers_saudi_style':
      builder = SaudiStyleHeaderDemoBuilder(config);
      break;
    case 'headers_letterhead':
      builder = LetterheadHeaderDemoBuilder(config);
      break;
    case 'headers_minimal':
      builder = MinimalHeaderDemoBuilder(config);
      break;
    case 'headers_full_details':
      builder = FullDetailsHeaderDemoBuilder(config);
      break;
    case 'headers':
      builder = HeadersDemoBuilder(config);
      break;
    case 'summary_basic_invoice':
      builder = BasicInvoiceSummaryDemoBuilder(config);
      break;
    case 'summary_grouped':
      builder = GroupedSummaryDemoBuilder(config);
      break;
    case 'summary_indented':
      builder = IndentedSummaryDemoBuilder(config);
      break;
    case 'summary_style_invoice':
      builder = InvoiceStyleSummaryDemoBuilder(config);
      break;
    case 'summary_style_card':
      builder = CardStyleSummaryDemoBuilder(config);
      break;
    case 'summary_style_bordered':
      builder = BorderedStyleSummaryDemoBuilder(config);
      break;
    case 'summary_style_minimal':
      builder = MinimalStyleSummaryDemoBuilder(config);
      break;
    case 'summary_advanced_groups':
      builder = AdvancedGroupedSummaryDemoBuilder(config);
      break;
    case 'summary':
      builder = SummaryDemoBuilder(config);
      break;
    case 'grid_qrcode_zatca_invoice':
      builder = GridQrcodeZatcaInvoiceDemoBuilder(config);
      break;
    case 'grid_qrcode_inventory_tracking':
      builder = GridQrcodeInventoryTrackingDemoBuilder(config);
      break;
    case 'grid_qrcode':
      builder = GridQrcodeDemoBuilder(config);
      break;
    case 'grid_infobox_order_document':
      builder = GridInfoboxOrderDocumentDemoBuilder(config);
      break;
    case 'grid_infobox_shipping_payment':
      builder = GridInfoboxShippingPaymentDemoBuilder(config);
      break;
    case 'grid_infobox':
      builder = GridInfoboxDemoBuilder(config);
      break;
    case 'grid_watermark_confidential_audit':
      builder = GridWatermarkConfidentialAuditDemoBuilder(config);
      break;
    case 'grid_watermark_security_access':
      builder = GridWatermarkSecurityAccessDemoBuilder(config);
      break;
    case 'grid_watermark':
      builder = GridWatermarkDemoBuilder(config);
      break;
    case 'grid_richtext_financial_analysis':
      builder = GridRichtextFinancialAnalysisDemoBuilder(config);
      break;
    case 'grid_richtext_expense_recommendations':
      builder = GridRichtextExpenseRecommendationsDemoBuilder(config);
      break;
    case 'grid_richtext':
      builder = GridRichtextDemoBuilder(config);
      break;
    case 'web_link_builder':
      builder = WebLinkBuilderDemoBuilder(config);
      break;
    case 'web_link_factory':
      builder = WebLinkFactoryDemoBuilder(config);
      break;
    case 'web_link_string_extension':
      builder = WebLinkStringExtensionDemoBuilder(config);
      break;
    case 'web_link_font_sizing':
      builder = WebLinkFontSizingDemoBuilder(config);
      break;
    case 'web_link_mixed_styles':
      builder = WebLinkMixedStylesDemoBuilder(config);
      break;
    case 'web_link':
      builder = WebLinkDemoBuilder(config);
      break;
    default:
      throw ArgumentError('Unsupported component: $component');
  }

  final bytes = builder.generate();
  builder.dispose();
  return Uint8List.fromList(bytes);
}

void drawTitle(
  PdfPage page,
  PdfFont titleFont,
  String text, {
  GeniusPdfConfig? config,
}) {
  final textDirection = config?.pdfTextDirection ?? PdfTextDirection.leftToRight;
  page.graphics.drawString(
    text,
    titleFont,
    bounds: Rect.fromLTWH(20, 20, page.getClientSize().width - 40, 30),
    format: PdfStringFormat(
      alignment: PdfTextAlignment.center,
      textDirection: textDirection,
    ),
  );
}
