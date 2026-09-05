import 'package:genius_pdf_example/app/localization/showcase_localizations.dart';
import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';
import 'package:super_core/super_core.dart';
import '../../app/navigation/showcase_catalog.dart';
import '../../shared/presentation/widgets/pdf_workbench.dart';
import '../../shared/presentation/widgets/showcase_page.dart';
import '../showcase/models/documents/new_templates_demo_documents.dart';
import 'models/documents/templates_demo_documents.dart';

class TemplateGalleryPage extends StatefulWidget {
  const TemplateGalleryPage({super.key, required this.destination});
  final ShowcaseDestination destination;

  @override
  State<TemplateGalleryPage> createState() => _TemplateGalleryPageState();
}

class _TemplateGalleryPageState extends State<TemplateGalleryPage> {
  String _selected = 'tax-invoice';
  bool _rtl = false;

  @override
  Widget build(BuildContext context) {
    final l10n = ShowcaseL10n.of(context);
    final entries = widget.destination.id == 'business-documents'
        ? _businessEntries()
        : _templateEntries();
    final current = entries.firstWhere((e) => e.id == _selected, orElse: () => entries.first);
    if (!entries.any((e) => e.id == _selected)) _selected = entries.first.id;

    return ShowcasePage(
      title: l10n.destinationTitle(widget.destination.id, widget.destination.title),
      description: l10n.destinationDescription(widget.destination.id, widget.destination.description),
      icon: widget.destination.icon,
      children: [
        ShowcaseSection(
          title: l10n.tr('Document gallery'),
          child: Wrap(
            spacing: context.superTheme.spacing.space2,
            runSpacing: context.superTheme.spacing.space2,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final entry in entries)
                ChoiceChip(
                  label: Text(l10n.tr(entry.label)),
                  selected: _selected == entry.id,
                  onSelected: (_) => setState(() => _selected = entry.id),
                ),
              FilterChip(
                label: const Text('RTL'),
                selected: _rtl,
                onSelected: (value) => setState(() => _rtl = value),
              ),
            ],
          ),
        ),
        ShowcaseSection(
          key: ValueKey('${current.id}:$_rtl'),
          title: l10n.tr(current.label),
          subtitle: l10n.isArabic ? 'مثال فعلي من المستودع • ${_rtl ? 'RTL' : 'LTR'}' : 'Working repository example • ${_rtl ? 'RTL' : 'LTR'}',
          child: PdfWorkbench(
            builderFactory: () => current.builder(_rtl),
            fileName: current.fileName,
          ),
        ),
      ],
    );
  }

  List<_GalleryEntry> _templateEntries() => [
    _GalleryEntry('tax-invoice', 'Tax invoice', 'tax_invoice_showcase', (rtl) => buildTaxInvoiceTemplate(isRtl: rtl)),
    _GalleryEntry('trial-balance', 'Trial balance', 'trial_balance_showcase', (rtl) => buildTrialBalanceTemplate(isRtl: rtl)),
    _GalleryEntry('customer-statement', 'Customer statement', 'customer_statement_showcase', (rtl) => buildCustomerStatementTemplate(isRtl: rtl)),
    _GalleryEntry('inventory-report', 'Inventory report', 'inventory_report_showcase', (rtl) => buildInventoryReportTemplate(isRtl: rtl)),
  ];

  List<_GalleryEntry> _businessEntries() => [
    _GalleryEntry('quotation', 'Quotation', 'quotation_showcase', (rtl) => buildQuotationDemo(isRtl: rtl).builder),
    _GalleryEntry('purchase-order', 'Purchase order', 'purchase_order_showcase', (rtl) => buildPurchaseOrderDemo(isRtl: rtl).builder),
    _GalleryEntry('delivery-note', 'Delivery note', 'delivery_note_showcase', (rtl) => buildDeliveryNoteDemo(isRtl: rtl).builder),
    _GalleryEntry('balance-sheet', 'Balance sheet', 'balance_sheet_showcase', (rtl) => buildBalanceSheetDemo(isRtl: rtl).builder),
    _GalleryEntry('income-statement', 'Income statement', 'income_statement_showcase', (rtl) => buildIncomeStatementDemo(isRtl: rtl).builder),
    _GalleryEntry('payslip', 'Payslip', 'payslip_showcase', (rtl) => buildPayslipDemo(isRtl: rtl).builder),
  ];
}

class _GalleryEntry {
  const _GalleryEntry(this.id, this.label, this.fileName, this.builder);
  final String id;
  final String label;
  final String fileName;
  final GeniusPdfDocumentBuilder Function(bool rtl) builder;
}
