
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

GeniusPosReceiptRequest request({
  GeniusPosReceiptKind kind = GeniusPosReceiptKind.sale,
  bool reprint = false,
  int count = 1,
}) =>
    GeniusPosReceiptRequest(
      merchantName: 'Genius Retail',
      merchantNameAr: 'جينيس للتجزئة',
      receiptNumber: 'POS-2026-001',
      date: DateTime(2026, 9, 4),
      kind: kind,
      lines: List.generate(
        count,
        (index) => GeniusPosReceiptLine(
          description:
              'Very long product name for thermal width stress $index',
          descriptionAr:
              'اسم منتج عربي طويل جداً لاختبار عرض الطباعة الحرارية $index',
          sku: 'SKU-${index + 1}',
          quantity: 2,
          unitPrice: 10,
          discount: 1,
          tax: 2.85,
          promotion: 'PROMO-5',
          promotionAr: 'عرض-5',
          note: 'No sugar',
          noteAr: 'بدون سكر',
        ),
      ),
      documentDiscount: 2,
      payments: const [
        GeniusPosPayment(
          method: GeniusPosPaymentMethod.cash,
          amount: 10,
        ),
        GeniusPosPayment(
          method: GeniusPosPaymentMethod.card,
          amount: 10,
        ),
      ],
      taxSummary: const [
        GeniusPosTaxSummaryLine(
          code: 'VAT',
          ratePercent: 15,
          taxableAmount: 19,
          taxAmount: 2.85,
        ),
      ],
      cashReceived: 25,
      change: 5,
      qrData: 'https://example.com/receipt/POS-2026-001',
      barcodeData: 'POS2026001',
      reprint: reprint,
    );

void main() {
  const service = GeniusPosService();

  test('58mm and 80mm profiles are explicit', () {
    expect(service.profile58().isThermal, isTrue);
    expect(service.profile80().isThermal, isTrue);
    expect(
      service.profile58().pageSize.width,
      lessThan(service.profile80().pageSize.width),
    );
  });

  test('tax promotions and multiple payment methods are preserved', () {
    final data = service.thermalData(request());

    expect(data.tax, closeTo(2.85, 0.001));
    expect(data.discount, 2);
    expect(data.payments.length, 4);
    expect(data.footer, contains('Tax Summary'));
    expect(data.items.single.description, contains('Promo: PROMO-5'));
    expect(data.items.single.descriptionAr, contains('بدون سكر'));
  });

  test('reprint marker is part of thermal data', () {
    final data = service.thermalData(request(reprint: true));
    expect(data.footer, contains('REPRINT'));
    expect(data.footerAr, contains('إعادة طباعة'));
  });

  test('refund values remain negative instead of being absolute-valued', () {
    final data = service.thermalData(
      request(kind: GeniusPosReceiptKind.refund),
    );

    expect(data.total!, lessThan(0));
    expect(data.items.single.quantity, lessThan(0));
  });

  test('gift receipt suppresses amount sections', () {
    final data = service.thermalData(
      request(kind: GeniusPosReceiptKind.gift),
    );

    expect(data.showAmounts, isFalse);
    expect(data.title, 'Gift Receipt');
  });

  test('thermal title can be overridden for KOT-style outputs', () {
    final base = request(kind: GeniusPosReceiptKind.gift);
    final data = service.thermalData(
      GeniusPosReceiptRequest(
        merchantName: base.merchantName,
        merchantNameAr: base.merchantNameAr,
        receiptNumber: base.receiptNumber,
        date: base.date,
        kind: GeniusPosReceiptKind.gift,
        title: 'Kitchen Order Ticket',
        titleAr: 'تذكرة طلب المطبخ',
        lines: base.lines,
      ),
    );

    expect(data.showAmounts, isFalse);
    expect(data.title, 'Kitchen Order Ticket');
    expect(data.titleAr, 'تذكرة طلب المطبخ');
  });

  test('high item count is supported by thermal preparation', () {
    final data = service.thermalData(request(count: 250));
    expect(data.items, hasLength(250));
  });
}
