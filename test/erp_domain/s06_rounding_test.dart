
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

void main() {
  test('half-up boundaries are deterministic', () {
    const r = ErpRoundingStrategy(mode: ErpRoundingMode.halfUp);
    expect(r.roundScaled(100.5), 101);
    expect(r.roundScaled(-100.5), -101);
  });

  test('half-even chooses the even neighbor', () {
    const r = ErpRoundingStrategy(mode: ErpRoundingMode.halfEven);
    expect(r.roundScaled(100.5), 100);
    expect(r.roundScaled(101.5), 102);
  });

  test('cash increments are deterministic', () {
    const r = ErpRoundingStrategy();
    expect(r.roundMinorUnitsToIncrement(1002, 5), 1000);
    expect(r.roundMinorUnitsToIncrement(1003, 5), 1005);
  });
}
