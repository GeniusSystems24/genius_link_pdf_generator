
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator_api.dart';

void main() {
  group('GeniusPdfDirectionResolver precedence', () {
    test('element wins over every lower scope', () {
      const context = GeniusPdfDirectionality(
        localeDirection: GeniusPdfDirection.rtl,
        documentDirection: GeniusPdfDirection.rtl,
        templateDirection: GeniusPdfDirection.rtl,
        componentDirection: GeniusPdfDirection.rtl,
        elementDirection: GeniusPdfDirection.ltr,
      );
      final result = context.resolve();
      expect(result.direction, GeniusPdfResolvedDirection.ltr);
      expect(result.source, GeniusPdfDirectionSource.element);
    });

    test('component wins when element is auto', () {
      const context = GeniusPdfDirectionality(
        localeDirection: GeniusPdfDirection.ltr,
        documentDirection: GeniusPdfDirection.ltr,
        templateDirection: GeniusPdfDirection.ltr,
        componentDirection: GeniusPdfDirection.rtl,
      );
      expect(context.resolve().source, GeniusPdfDirectionSource.component);
      expect(context.resolve().direction, GeniusPdfResolvedDirection.rtl);
    });

    test('template wins over document and locale', () {
      const context = GeniusPdfDirectionality(
        localeDirection: GeniusPdfDirection.rtl,
        documentDirection: GeniusPdfDirection.rtl,
        templateDirection: GeniusPdfDirection.ltr,
      );
      expect(context.resolve().source, GeniusPdfDirectionSource.template);
      expect(context.resolve().direction, GeniusPdfResolvedDirection.ltr);
    });

    test('document wins over locale', () {
      const context = GeniusPdfDirectionality(
        localeDirection: GeniusPdfDirection.rtl,
        documentDirection: GeniusPdfDirection.ltr,
      );
      expect(context.resolve().source, GeniusPdfDirectionSource.document);
      expect(context.resolve().direction, GeniusPdfResolvedDirection.ltr);
    });

    test('locale is used when all upper scopes are auto', () {
      const context = GeniusPdfDirectionality(
        localeDirection: GeniusPdfDirection.rtl,
      );
      expect(context.resolve().source, GeniusPdfDirectionSource.locale);
      expect(context.resolve().direction, GeniusPdfResolvedDirection.rtl);
    });

    test('fallback is deterministic when everything is auto', () {
      const context = GeniusPdfDirectionality();
      expect(context.resolve().source, GeniusPdfDirectionSource.fallback);
      expect(context.resolve().direction, GeniusPdfResolvedDirection.ltr);
    });
  });
}
