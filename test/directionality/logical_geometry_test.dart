
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator_api.dart';

void main() {
  group('logical alignment', () {
    test('start/end resolve for LTR', () {
      expect(
        GeniusPdfLogicalGeometry.resolveAlignment(
          GeniusPdfLogicalAlignment.start,
          GeniusPdfResolvedDirection.ltr,
        ),
        GeniusPdfPhysicalHorizontalAlignment.left,
      );
      expect(
        GeniusPdfLogicalGeometry.resolveAlignment(
          GeniusPdfLogicalAlignment.end,
          GeniusPdfResolvedDirection.ltr,
        ),
        GeniusPdfPhysicalHorizontalAlignment.right,
      );
    });

    test('start/end resolve for RTL', () {
      expect(
        GeniusPdfLogicalGeometry.resolveAlignment(
          GeniusPdfLogicalAlignment.start,
          GeniusPdfResolvedDirection.rtl,
        ),
        GeniusPdfPhysicalHorizontalAlignment.right,
      );
      expect(
        GeniusPdfLogicalGeometry.resolveAlignment(
          GeniusPdfLogicalAlignment.end,
          GeniusPdfResolvedDirection.rtl,
        ),
        GeniusPdfPhysicalHorizontalAlignment.left,
      );
    });

    test('leading/trailing resolve for both directions', () {
      expect(
        GeniusPdfLogicalGeometry.resolvePosition(
          GeniusPdfLogicalPosition.leading,
          GeniusPdfResolvedDirection.ltr,
        ),
        GeniusPdfPhysicalSide.left,
      );
      expect(
        GeniusPdfLogicalGeometry.resolvePosition(
          GeniusPdfLogicalPosition.leading,
          GeniusPdfResolvedDirection.rtl,
        ),
        GeniusPdfPhysicalSide.right,
      );
      expect(
        GeniusPdfLogicalGeometry.resolvePosition(
          GeniusPdfLogicalPosition.trailing,
          GeniusPdfResolvedDirection.rtl,
        ),
        GeniusPdfPhysicalSide.left,
      );
    });

    test('directional insets swap start/end only', () {
      const insets = GeniusPdfDirectionalInsets(
        start: 10,
        top: 2,
        end: 30,
        bottom: 4,
      );
      final ltr = insets.resolve(GeniusPdfResolvedDirection.ltr);
      final rtl = insets.resolve(GeniusPdfResolvedDirection.rtl);
      expect((ltr.left, ltr.right, ltr.top, ltr.bottom), (10, 30, 2, 4));
      expect((rtl.left, rtl.right, rtl.top, rtl.bottom), (30, 10, 2, 4));
    });

    test('resolveX uses logical alignment', () {
      expect(
        GeniusPdfLogicalGeometry.resolveX(
          containerX: 10,
          containerWidth: 100,
          itemWidth: 20,
          alignment: GeniusPdfLogicalAlignment.start,
          direction: GeniusPdfResolvedDirection.ltr,
        ),
        10,
      );
      expect(
        GeniusPdfLogicalGeometry.resolveX(
          containerX: 10,
          containerWidth: 100,
          itemWidth: 20,
          alignment: GeniusPdfLogicalAlignment.start,
          direction: GeniusPdfResolvedDirection.rtl,
        ),
        90,
      );
    });
  });
}
