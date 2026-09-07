import 'package:flutter/material.dart';

import '../src/core/pdf_config.dart';
import '../src/domain/models/pdf_image.dart';
import '../src/presentation/document/builders/pdf_document_builder.dart';
import '../src/core/extensions/datetime_extensions.dart';

/// Example invoice document builder.
///
/// Demonstrates how to create a complete invoice PDF with
/// headers, footers, and content.
///
/// ## Example
/// ```dart
/// final invoice = InvoiceDocumentBuilder(
///   config: PdfConfig(
///     baseFont: PdfTrueTypeFont(fontData, 12),
///   ),
///   invoiceNumber: 'INV-001',
///   customerName: 'John Doe',
///   items: [
///     InvoiceItem(name: 'Product A', quantity: 2, price: 50.00),
///     InvoiceItem(name: 'Product B', quantity: 1, price: 75.00),
///   ],
/// );
///
/// final bytes = invoice.generate();
/// ```
class InvoiceDocumentBuilder extends GeniusPdfDocumentBuilder {
  /// Creates a new [InvoiceDocumentBuilder].
  InvoiceDocumentBuilder({
    required GeniusPdfConfig config,
    required this.invoiceNumber,
    required this.customerName,
    required this.items,
    DateTime? invoiceDate,
    this.companyName,
    this.companyAddress,
    this.taxRate = 0.0,
    this.currencySymbol = '\$',
  })  : invoiceDate = invoiceDate ?? DateTime.now(),
        super(config);

  /// The invoice number.
  final String invoiceNumber;

  /// The customer name.
  final String customerName;

  /// The invoice date.
  final DateTime invoiceDate;

  /// The list of invoice items.
  final List<InvoiceItem> items;

  /// Optional company name for the header.
  final String? companyName;

  /// Optional company address.
  final String? companyAddress;

  /// Tax rate as a decimal (e.g., 0.15 for 15%).
  final double taxRate;

  /// Currency symbol.
  final String currencySymbol;

  double get _subtotal => items.fold(0, (sum, item) => sum + item.total);
  double get _tax => _subtotal * taxRate;
  double get _total => _subtotal + _tax;

  @override
  void build() {
    _buildHeader();
    _buildInvoiceDetails();
    _buildItemsTable();
    _buildTotals();
    _buildFooter();
  }

  void _buildHeader() {
    if (config.assets.headerImage != null) {
      addHeader(
        image: GeniusPdfImage(
          data: config.assets.headerImage!,
          width: 800,
          height: 100,
        ),
        title: 'INVOICE',
        backgroundColor: Colors.grey[100],
      );
    } else {
      addHeader(title: 'INVOICE');
    }

    if (companyName != null) {
      addLine(companyName!);
      if (companyAddress != null) {
        addLine(companyAddress!, topMargin: 5);
      }
    }

    addSpace(20);
  }

  void _buildInvoiceDetails() {
    addLine('Invoice Details', font: config.baseFont);
    addSpace(10);
    addLine('Invoice #: $invoiceNumber');
    addLine('Date: ${invoiceDate.formatDate()}', topMargin: 5);
    addLine('Customer: $customerName', topMargin: 5);
    addSpace(20);
    addHorizontalLine();
    addSpace(20);
  }

  void _buildItemsTable() {
    addLine('Items:', font: config.boldFont);
    addSpace(10);

    addLine('Item'.padRight(30) +
        'Qty'.padLeft(10) +
        'Price'.padLeft(15) +
        'Total'.padLeft(15));
    addHorizontalLine(padding: 5);
    addSpace(5);

    for (final item in items) {
      final line = item.name.padRight(30) +
          item.quantity.toString().padLeft(10) +
          '$currencySymbol${item.price.toStringAsFixed(2)}'.padLeft(15) +
          '$currencySymbol${item.total.toStringAsFixed(2)}'.padLeft(15);
      addLine(line, topMargin: 5);
    }

    addSpace(10);
    addHorizontalLine(padding: 5);
  }

  void _buildTotals() {
    final font = config.baseFont;

    addSpace(10);
    addLine('Subtotal: $currencySymbol${_subtotal.toStringAsFixed(2)}',
        font: font);

    if (taxRate > 0) {
      addLine(
          'Tax (${(taxRate * 100).toStringAsFixed(0)}%): $currencySymbol${_tax.toStringAsFixed(2)}',
          font: font,
          topMargin: 5);
    }

    addSpace(10);
    final totalFont = config.baseFont;
    addLine('TOTAL: $currencySymbol${_total.toStringAsFixed(2)}',
        font: totalFont);
  }

  void _buildFooter() {
    addSpace(40);
    addLine('Thank you for your business!');
    addFooter(
      showPageNumber: true,
      printTime: DateTime.now().formatPrintTime('Generated'),
    );
  }
}

/// Represents an item on an invoice.
class InvoiceItem {
  /// Creates a new [InvoiceItem].
  const InvoiceItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  /// The item name or description.
  final String name;

  /// The quantity ordered.
  final int quantity;

  /// The unit price.
  final double price;

  /// The total price for this item (quantity × price).
  double get total => quantity * price;
}

/// Example report document builder.
///
/// Demonstrates a simple report layout with sections.
class SimpleReportBuilder extends GeniusPdfDocumentBuilder {
  /// Creates a new [SimpleReportBuilder].
  SimpleReportBuilder({
    required GeniusPdfConfig config,
    required this.title,
    required this.sections,
    this.authorName,
  }) : super(config);

  /// The report title.
  final String title;

  /// The report sections.
  final List<ReportSection> sections;

  /// Optional author name.
  final String? authorName;

  @override
  void build() {
    addHeader(title: title);

    addLine('Generated: ${DateTime.now().formatDateTime()}');
    if (authorName != null) {
      addLine('Author: $authorName', topMargin: 5);
    }
    addSpace(20);

    for (final section in sections) {
      _buildSection(section);
    }

    addFooter(
      showPageNumber: true,
      printTime: DateTime.now().formatPrintTime(),
    );
  }

  void _buildSection(ReportSection section) {
    addLine(section.title, font: config.boldFont);
    addSpace(10);
    addLine(section.content);
    addSpace(20);

    if (section.subsections != null) {
      for (final sub in section.subsections!) {
        addLine('• ${sub.title}', space: 20);
        addLine(sub.content, space: 30, topMargin: 5);
        addSpace(10);
      }
    }

    addHorizontalLine();
    addSpace(20);
  }
}

/// Represents a section in a report.
class ReportSection {
  /// Creates a new [ReportSection].
  const ReportSection({
    required this.title,
    required this.content,
    this.subsections,
  });

  /// The section title.
  final String title;

  /// The section content.
  final String content;

  /// Optional subsections.
  final List<ReportSection>? subsections;
}
