
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

GeniusPdfConfig config() => GeniusPdfConfig(
      baseFontBytes: Uint8List(0),
      baseFont: PdfStandardFont(PdfFontFamily.helvetica, 10),
      textDirection: TextDirection.ltr,
    );

void main() {
  test('standard profile dimensions are deterministic', () {
    expect(
      GeniusPdfPrintProfile.a4Portrait().pageSize,
      GeniusPdfPageSize.a4,
    );
    expect(
      GeniusPdfPrintProfile.a4Landscape().orientation,
      PdfPageOrientation.landscape,
    );
    expect(
      GeniusPdfPrintProfile.a5().pageSize,
      const Size(420, 595),
    );
    expect(
      GeniusPdfPrintProfile.letter().pageSize,
      GeniusPdfPageSize.letter,
    );
    expect(
      GeniusPdfPrintProfile.legal().pageSize,
      GeniusPdfPageSize.legal,
    );
  });

  test('thermal widths are 58mm and 80mm in PDF points', () {
    final p58 = GeniusPdfPrintProfile.thermal58();
    final p80 = GeniusPdfPrintProfile.thermal80();

    expect(
      p58.pageSize.width,
      closeTo(
        58 * GeniusPdfPrintProfile.pointsPerMillimeter,
        0.001,
      ),
    );
    expect(
      p80.pageSize.width,
      closeTo(
        80 * GeniusPdfPrintProfile.pointsPerMillimeter,
        0.001,
      ),
    );
    expect(p58.isThermal, isTrue);
    expect(p80.isThermal, isTrue);
  });

  test('profile apply returns a new config with profile geometry', () {
    final original = config();
    final profile = GeniusPdfPrintProfile.a5(
      margins: const GeniusPdfPrintInsets.all(12),
      fontScale: 0.9,
    );

    final applied = profile.apply(original);

    expect(applied.pageSize, const Size(420, 595));
    expect(applied.margins.left, 12);
    expect(applied.baseFontSize, original.baseFontSize * 0.9);
    expect(original.pageSize, isNot(const Size(420, 595)));
  });

  test('label sheet exposes gaps/bleed/calibration', () {
    final profile = GeniusPdfPrintProfile.labelSheet(
      columns: 3,
      rows: 8,
      labelWidth: 170,
      labelHeight: 80,
      horizontalGap: 4,
      verticalGap: 5,
      bleed: 2,
      calibration: const GeniusPdfPrintCalibration(
        offset: GeniusPdfPrintOffset(dx: 1.5, dy: -2),
        scaleX: 1.001,
        scaleY: 0.999,
      ),
    );

    expect(profile.labelSheet!.labelsPerSheet, 24);
    expect(profile.labelGapX, 4);
    expect(profile.labelGapY, 5);
    expect(profile.labelSheet!.bleed, 2);
    expect(profile.calibration.offset.dx, 1.5);
  });

  test('pre-printed mode is explicit physical placement', () {
    final profile = GeniusPdfPrintProfile.prePrinted();
    expect(profile.isPrePrinted, isTrue);
    expect(profile.physicalPlacement, isTrue);
  });

  test('copy metadata is deterministic', () {
    const metadata = GeniusPdfCopyMetadata(
      kind: GeniusPdfCopyKind.copy,
      copyNumber: 2,
      totalCopies: 3,
    );

    expect(metadata.label(isRtl: false), 'Copy 2/3');
    expect(metadata.label(isRtl: true), 'نسخة 2/3');
  });
}
