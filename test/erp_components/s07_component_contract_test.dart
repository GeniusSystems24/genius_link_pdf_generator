
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

GeniusPdfConfig config({bool rtl = false}) => GeniusPdfConfig(
      baseFontBytes: Uint8List(0),
      baseFont: PdfStandardFont(PdfFontFamily.helvetica, 10),
      textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
    );

void main() {
  group('S07 semantic component contracts', () {
    test('identity/party/address/reference null sections collapse', () {
      final c = config();

      expect(
        GeniusPdfDocumentIdentity(config: c, data: null).isVisible,
        isFalse,
      );
      expect(
        GeniusPdfPartyBlock(config: c, party: null).isVisible,
        isFalse,
      );
      expect(
        GeniusPdfAddressBlock(config: c, address: null).isVisible,
        isFalse,
      );
      expect(
        GeniusPdfReferenceBlock(config: c).isVisible,
        isFalse,
      );
    });

    test('empty-state policy is explicit for empty lists/data', () {
      final c = config();

      expect(
        GeniusPdfPartyBlock(
          config: c,
          party: null,
          emptyPolicy: GeniusPdfEmptySectionPolicy.emptyState,
        ).isVisible,
        isTrue,
      );
      expect(
        GeniusPdfReferenceBlock(
          config: c,
          references: const [],
          emptyPolicy: GeniusPdfEmptySectionPolicy.emptyState,
        ).isVisible,
        isTrue,
      );
      expect(
        GeniusPdfMetricCards(
          config: c,
          cards: const [],
          emptyPolicy: GeniusPdfEmptySectionPolicy.emptyState,
        ).isVisible,
        isTrue,
      );
    });

    test('terms and amount-in-words do not invent missing prose', () {
      final c = config();

      expect(
        GeniusPdfTermsSection(config: c).isVisible,
        isFalse,
      );
      expect(
        GeniusPdfAmountInWords(
          config: c,
          amount: ErpMoney.fromAmount(
            100,
            currency: ErpCurrency.sar,
          ),
        ).isVisible,
        isFalse,
      );

      expect(
        GeniusPdfAmountInWords(
          config: c,
          amount: ErpMoney.fromAmount(
            100,
            currency: ErpCurrency.sar,
          ),
          text: 'One hundred Saudi riyals only',
          textAr: 'مائة ريال سعودي فقط',
        ).isVisible,
        isTrue,
      );
    });

    test('money/balance/tax/adjustment components accept S06 result', () {
      final c = config();
      final line = ErpLineItem(
        id: '1',
        description: 'Item',
        quantity: const ErpQuantity(
          value: 1,
          unit: ErpUnit.each,
        ),
        unitPrice: ErpMoney.fromAmount(
          100,
          currency: ErpCurrency.sar,
        ),
        discounts: [
          ErpDiscount.percentage(percentage: 10),
        ],
        charges: [
          ErpCharge.fixed(
            amount: ErpMoney.fromAmount(
              5,
              currency: ErpCurrency.sar,
            ),
          ),
        ],
        taxes: const [
          ErpTaxLine(code: 'VAT', ratePercent: 15),
        ],
      );

      final result = const ErpCalculationService().calculate(
        ErpCalculationRequest(
          currency: ErpCurrency.sar,
          lineItems: [line],
        ),
      );

      expect(
        GeniusPdfMoney(
          config: c,
          amount: result.grandTotal,
        ).isVisible,
        isTrue,
      );
      expect(
        GeniusPdfTaxSummary(
          config: c,
          result: result,
        ).isVisible,
        isTrue,
      );
      expect(
        GeniusPdfAdjustmentSummary(
          config: c,
          result: result,
        ).isVisible,
        isTrue,
      );
      expect(
        GeniusPdfBalanceDueBlock(
          config: c,
          result: result,
        ).isVisible,
        isTrue,
      );
    });

    test('operational components collapse empty data', () {
      final c = config();

      expect(
        GeniusPdfApprovalTrail(config: c).isVisible,
        isFalse,
      );
      expect(
        GeniusPdfStamp(config: c, text: null).isVisible,
        isFalse,
      );
      expect(
        GeniusPdfMetricCards(config: c).isVisible,
        isFalse,
      );
      expect(
        GeniusPdfLabel(config: c, text: null).isVisible,
        isFalse,
      );
    });
  });
}
