import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

void main() {
  group('S05 theme tokens', () {
    test('logical spacing resolves start/end', () {
      const spacing = GeniusPdfLogicalSpacing(start: 12, end: 4, top: 2, bottom: 3);
      final ltr = spacing.resolve(GeniusPdfResolvedDirection.ltr);
      final rtl = spacing.resolve(GeniusPdfResolvedDirection.rtl);
      expect(ltr.left, 12);
      expect(ltr.right, 4);
      expect(rtl.left, 4);
      expect(rtl.right, 12);
      expect(ltr.top, rtl.top);
      expect(ltr.bottom, rtl.bottom);
    });

    test('leading border moves without changing style', () {
      const logical = GeniusPdfLogicalBorder(
        base: GeniusPdfBorderStyle.all(width: 2),
        leading: true,
      );
      final ltr = logical.resolve(GeniusPdfResolvedDirection.ltr);
      final rtl = logical.resolve(GeniusPdfResolvedDirection.rtl);
      expect(ltr.left, isTrue);
      expect(ltr.right, isFalse);
      expect(rtl.left, isFalse);
      expect(rtl.right, isTrue);
      expect(ltr.width, rtl.width);
      expect(ltr.color, rtl.color);
    });

    test('semantic colors do not depend on direction', () {
      final theme = GeniusPdfTheme.defaults();
      expect(theme.semanticColors.positive, theme.colors.positiveAmount);
      expect(theme.semanticColors.negative, theme.colors.negativeAmount);
      expect(theme.typographyAlignment.body, GeniusPdfTextAlign.start);
      expect(theme.typographyAlignment.value, GeniusPdfTextAlign.end);
    });
  });
}
