
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator_api.dart';

void main() {
  test('nested scopes inherit lower-level directions', () {
    const document = GeniusPdfDirectionality(
      localeDirection: GeniusPdfDirection.rtl,
      documentDirection: GeniusPdfDirection.rtl,
    );
    final template = document.forTemplate(GeniusPdfDirection.auto);
    final component = template.forComponent(GeniusPdfDirection.ltr);
    final inheritedElement = component.forElement(GeniusPdfDirection.auto);
    final rtlElement = component.forElement(GeniusPdfDirection.rtl);

    expect(
      inheritedElement.resolve().direction,
      GeniusPdfResolvedDirection.ltr,
    );
    expect(
      inheritedElement.resolve().source,
      GeniusPdfDirectionSource.component,
    );
    expect(rtlElement.resolve().direction, GeniusPdfResolvedDirection.rtl);
    expect(rtlElement.resolve().source, GeniusPdfDirectionSource.element);
  });

  test('component override does not mutate parent context', () {
    const parent = GeniusPdfDirectionality(
      documentDirection: GeniusPdfDirection.rtl,
    );
    final child = parent.forComponent(GeniusPdfDirection.ltr);
    expect(parent.resolve().direction, GeniusPdfResolvedDirection.rtl);
    expect(child.resolve().direction, GeniusPdfResolvedDirection.ltr);
  });
}
