
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

class _FixedComponent extends GeniusPdfErpComponent {
  _FixedComponent({
    required super.config,
    required this.visible,
    required this.height,
  });

  final bool visible;
  final double height;

  @override
  bool get isVisible => visible;

  @override
  Rect? draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    if (!visible) return null;
    return Rect.fromLTWH(
      bounds.left,
      bounds.top,
      bounds.width,
      height,
    );
  }
}

void main() {
  test('hidden component leaves no residual group spacing', () {
    final config = GeniusPdfConfig(
      baseFontBytes: Uint8List(0),
      baseFont: PdfStandardFont(PdfFontFamily.helvetica, 10),
      textDirection: TextDirection.ltr,
    );

    final document = PdfDocument();
    final page = document.pages.add();

    final group = GeniusPdfErpComponentGroup(
      spacing: 5,
      components: [
        _FixedComponent(
          config: config,
          visible: true,
          height: 10,
        ),
        _FixedComponent(
          config: config,
          visible: false,
          height: 999,
        ),
        _FixedComponent(
          config: config,
          visible: true,
          height: 20,
        ),
      ],
    );

    final result = group.draw(
      page: page,
      bounds: const Rect.fromLTWH(0, 0, 200, 200),
    );

    expect(result, isNotNull);
    expect(result!.top, 0);
    expect(result.bottom, 35);
    expect(result.height, 35);

    document.dispose();
  });
}
