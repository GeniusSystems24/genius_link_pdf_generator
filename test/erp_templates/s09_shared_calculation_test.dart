
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

GeniusPdfCompanyInfo company() => const GeniusPdfCompanyInfo(
      name: 'Genius Systems',
      nameAr: 'أنظمة جينيس',
      vatNumber: '310123456700003',
    );

void main() {
  test('Quotation legacy totals match shared S06 result', () {
    final data = QuotationData(
      quotationNumber: 'Q-1',
      quotationDate: DateTime(2026, 9, 4),
      validUntil: DateTime(2026, 10, 4),
      customer: const QuotationCustomer(name: 'Customer'),
      items: const [
        QuotationItem(
          itemNumber: 1,
          description: 'Item',
          quantity: 2,
          unitPrice: 100,
          discount: 10,
          tax: 28.50,
        ),
      ],
    );

    final adapter = QuotationErpAdapter(company: company());
    final context = adapter.adapt(data);
    final result = const ErpCalculationService().calculate(
      adapter.calculationRequest(data, context),
    );

    expect(data.subTotal, result.subtotal.toDouble());
    expect(
      data.totalDiscount,
      result.lineDiscountTotal.toDouble(),
    );
    expect(data.totalTax, result.taxTotal.toDouble());
    expect(data.grandTotal, result.grandTotal.toDouble());
  });

  test('Purchase Order subtotal remains net of legacy line discount', () {
    final data = PurchaseOrderData(
      poNumber: 'PO-1',
      poDate: DateTime(2026, 9, 4),
      items: const [
        PurchaseOrderItem(
          itemNumber: 1,
          description: 'Item',
          quantity: 2,
          unitPrice: 100,
          discount: 20,
        ),
      ],
      taxes: const [
        (name: 'VAT', nameAr: 'الضريبة', rate: 15),
      ],
    );

    final adapter = PurchaseOrderErpAdapter(
      company: company(),
      vendor: const PurchaseOrderVendor(name: 'Vendor'),
    );
    final context = adapter.adapt(data);
    final result = const ErpCalculationService().calculate(
      adapter.calculationRequest(data, context),
    );

    expect(data.subtotal, 180);
    expect(data.totalTax, 27);
    expect(data.grandTotal, 207);
    expect(
      result.subtotal.toDouble() -
          result.lineDiscountTotal.toDouble(),
      data.subtotal,
    );
  });

  test('Tax Invoice keeps net subtotal, VAT and grand total', () {
    final data = InvoiceData(
      invoiceNumber: 'INV-1',
      invoiceDate: DateTime(2026, 9, 4),
      items: const [
        InvoiceLineItem(
          itemNumber: 1,
          description: 'Item',
          quantity: 2,
          unitPrice: 100,
          discount: 20,
        ),
      ],
      taxes: const [
        InvoiceTax(name: 'VAT', nameAr: 'الضريبة', rate: 15),
      ],
    );

    final adapter = TaxInvoiceErpAdapter(
      company: company(),
      customer: const InvoiceCustomer(name: 'Customer'),
    );
    final context = adapter.adapt(data);
    final result = const ErpCalculationService().calculate(
      adapter.calculationRequest(data, context),
    );

    expect(data.subtotal, 180);
    expect(data.totalTax, 27);
    expect(data.grandTotal, 207);
    expect(result.grandTotal.toDouble(), 207);
  });
}
