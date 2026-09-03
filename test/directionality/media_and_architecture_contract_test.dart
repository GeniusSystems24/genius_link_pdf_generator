import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator_api.dart';

void main() {
  test('media preserve is default; mirroring is explicit', () {
    expect(GeniusPdfLogicalGeometry.shouldMirrorMedia(), isFalse);
    expect(
      GeniusPdfLogicalGeometry.shouldMirrorMedia(
        policy: GeniusPdfMediaMirroringPolicy.preserve,
      ),
      isFalse,
    );
    expect(
      GeniusPdfLogicalGeometry.shouldMirrorMedia(
        policy: GeniusPdfMediaMirroringPolicy.mirror,
      ),
      isTrue,
    );
  });

  test('RTL alone cannot opt media into mirroring', () {
    const rtl = GeniusPdfDirectionality(
      documentDirection: GeniusPdfDirection.rtl,
    );
    expect(rtl.resolve().direction, GeniusPdfResolvedDirection.rtl);
    expect(GeniusPdfLogicalGeometry.shouldMirrorMedia(), isFalse);
  });

  test('stable direction core does not leak Syncfusion direction types', () {
    final source = File('lib/src/core/directionality.dart').readAsStringSync();
    expect(source, isNot(contains('syncfusion_flutter_pdf')));
    expect(source, isNot(contains('PdfTextDirection')));
  });

  test('direction core never reverses strings to fake RTL', () {
    final source = File('lib/src/core/directionality.dart').readAsStringSync();
    expect(source, isNot(contains('.reversed')));
    expect(source, isNot(contains('reverseString')));
  });
}
