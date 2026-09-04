
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

GeniusPdfConfig config(bool rtl) => GeniusPdfConfig(
      baseFontBytes: Uint8List(0),
      baseFont: PdfStandardFont(PdfFontFamily.helvetica, 10),
      boldFont: PdfStandardFont(
        PdfFontFamily.helvetica,
        10,
        style: PdfFontStyle.bold,
      ),
      textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
    );

void main() {
  for (final rtl in <bool>[false, true]) {
    test('S07 core component render smoke ${rtl ? 'RTL' : 'LTR'}', () {
      final c = config(rtl);
      final document = PdfDocument();
      final page = document.pages.add();
      final directionality = GeniusPdfDirectionality(
        documentDirection:
            rtl ? GeniusPdfDirection.rtl : GeniusPdfDirection.ltr,
      );

      final identity = GeniusPdfDocumentIdentity(
        config: c,
        data: ErpDocumentIdentity(
          kind: ErpDocumentKind.invoice,
          number: 'INV-2026-000123',
          issueDate: DateTime(2026, 9, 4),
          status: ErpDocumentStatus.issued,
        ),
        directionality: directionality,
      );

      final party = GeniusPdfPartyBlock(
        config: c,
        party: const ErpParty(
          name: 'Acme شركة',
          taxIdentity: ErpTaxIdentity(
            taxNumber: '310123456700003',
          ),
          contacts: [
            ErpContactMetadata(
              phone: '+966 50 123 4567',
              email: 'finance@example.com',
            ),
          ],
        ),
        directionality: directionality,
      );

      final address = GeniusPdfAddressBlock(
        config: c,
        address: const ErpAddress(
          role: ErpAddressRole.billing,
          line1: 'King Fahd Road طريق الملك فهد',
          city: 'Riyadh الرياض',
          postalCode: '12211',
          countryCode: 'SA',
        ),
        directionality: directionality,
      );

      final group = GeniusPdfErpComponentGroup(
        components: [identity, party, address],
        spacing: 8,
      );

      final result = group.draw(
        page: page,
        bounds: Rect.fromLTWH(
          0,
          0,
          page.getClientSize().width,
          page.getClientSize().height,
        ),
      );

      expect(result, isNotNull);
      expect(result!.height, greaterThan(0));

      document.dispose();
    });
  }
}
