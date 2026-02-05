import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

/// Demonstrates v2.10.0 smart space management features.
///
/// This example showcases:
/// - **Header/footer height tracking** — `headerHeight`, `footerHeight`, `effectivePageHeight`
/// - **Footer-aware `remainingHeight`** — prevents content from overlapping the footer
/// - **Header-offset new pages** — `newPage()` starts at `headerHeight`, not 0
/// - **Auto page-break for non-Grid methods** — `addSummary`, `addInfoBox`,
///   `addRichText`, `addReportHeader`, `addBulletList`, `addDualInfoBox`,
///   `addSectionDivider` all call `_ensureSpace` before drawing
/// - **`reserveHeaderSpace` / `reserveFooterSpace`** — manual space reservation
///
/// ## Example
/// ```dart
/// final doc = SmartSpaceDemoBuilder(
///   config: myConfig,
///   userName: 'Demo User',
/// );
/// final bytes = doc.generate();
/// doc.dispose();
/// ```
class SmartSpaceDemoBuilder extends GeniusPdfDocumentBuilder {
  SmartSpaceDemoBuilder({
    required GeniusPdfConfig config,
    this.userName = 'Demo User',
  }) : super(config);

  final String userName;

  @override
  void build() {
    // ── Step 1: Add header and footer ──
    // These automatically set _headerHeight and _footerHeight.
    addHeader(
      title: isRTL
          ? 'عرض إدارة المساحة الذكية — الإصدار 2.10.0'
          : 'Smart Space Management Demo — v2.10.0',
    );
    addFooter(
      userName: userName,
      showPageNumber: true,
      printTime: DateTime.now().toString().substring(0, 19),
    );

    // ── Step 2: First page — show space info ──
    newPage();

    addLine(
      isRTL
          ? '1. تتبع مساحة الرأس والتذييل'
          : '1. Header & Footer Space Tracking',
      font: config.boldFont,
    );
    addSpace(5);

    addLine(
      isRTL
          ? 'ارتفاع الرأس: ${headerHeight.toStringAsFixed(1)} بكسل'
          : 'Header height: ${headerHeight.toStringAsFixed(1)} px',
      topMargin: 5,
    );
    addLine(
      isRTL
          ? 'ارتفاع التذييل: ${footerHeight.toStringAsFixed(1)} بكسل'
          : 'Footer height: ${footerHeight.toStringAsFixed(1)} px',
      topMargin: 5,
    );
    addLine(
      isRTL
          ? 'ارتفاع الصفحة الفعّال: ${effectivePageHeight.toStringAsFixed(1)} بكسل'
          : 'Effective page height: ${effectivePageHeight.toStringAsFixed(1)} px',
      topMargin: 5,
    );
    addLine(
      isRTL
          ? 'المساحة المتبقية (تراعي التذييل): ${remainingHeight.toStringAsFixed(1)} بكسل'
          : 'Remaining height (footer-aware): ${remainingHeight.toStringAsFixed(1)} px',
      topMargin: 5,
    );

    addSpace(15);
    addHorizontalLine();
    addSpace(10);

    // ── Step 3: Fill page to demonstrate auto page-break ──
    addLine(
      isRTL
          ? '2. كسر الصفحة التلقائي للمكونات'
          : '2. Auto Page-Break for Components',
      font: config.boldFont,
    );
    addSpace(5);

    addLine(
      isRTL
          ? 'سنملأ الصفحة بنصوص حتى لا يتبقى مساحة كافية، ثم نضيف مكوناً.'
          : 'We will fill the page with text until there is not enough space, then add a component.',
    );
    addSpace(10);

    // Fill most of the remaining space with text lines.
    final linesToFill = (remainingHeight / 16).floor() - 8;
    for (var i = 1; i <= linesToFill; i++) {
      addLine(
        isRTL
            ? 'السطر $i — نص تعبئة لملء الصفحة'
            : 'Line $i — filler text to fill the page',
        topMargin: 2,
      );
    }

    addLine(
      isRTL
          ? 'المساحة المتبقية الآن: ${remainingHeight.toStringAsFixed(1)} بكسل'
          : 'Remaining space now: ${remainingHeight.toStringAsFixed(1)} px',
      topMargin: 5,
    );

    // This section divider should auto page-break if it doesn't fit.
    addSectionDivider(
      title: isRTL
          ? 'قسم جديد (كسر تلقائي)'
          : 'New Section (auto page-break)',
      spacing: 15,
    );

    addLine(
      isRTL
          ? 'هذا النص يجب أن يكون في صفحة جديدة إذا لم تكن المساحة كافية.'
          : 'This text should be on a new page if there was not enough space.',
      topMargin: 5,
    );

    addLine(
      isRTL
          ? 'رقم الصفحة الحالي: $pageCount'
          : 'Current page count: $pageCount',
      topMargin: 5,
    );

    addSpace(15);
    addHorizontalLine();
    addSpace(10);

    // ── Step 4: Demonstrate newPage starts at headerHeight ──
    addLine(
      isRTL
          ? '3. صفحة جديدة تبدأ من ارتفاع الرأس'
          : '3. New Page Starts at Header Height',
      font: config.boldFont,
    );
    addSpace(5);

    newPage();

    addLine(
      isRTL
          ? 'هذه صفحة جديدة. الموقع الحالي: currentY = ${currentY.toStringAsFixed(1)}'
          : 'This is a new page. Current position: currentY = ${currentY.toStringAsFixed(1)}',
      topMargin: 5,
    );
    addLine(
      isRTL
          ? 'يجب أن يكون currentY مساوياً لـ headerHeight (${headerHeight.toStringAsFixed(1)})'
          : 'currentY should equal headerHeight (${headerHeight.toStringAsFixed(1)})',
      topMargin: 5,
    );

    addSpace(15);
    addHorizontalLine();
    addSpace(10);

    // ── Step 5: canFit checks with footer awareness ──
    addLine(
      isRTL
          ? '4. فحص المساحة المتاحة (يراعي التذييل)'
          : '4. Space Check (footer-aware)',
      font: config.boldFont,
    );
    addSpace(5);

    final fits100 = canFit(100);
    final fits500 = canFit(500);
    final fitsAll = canFit(effectivePageHeight);
    addLine(
      isRTL
          ? 'canFit(100): ${fits100 ? "نعم" : "لا"}'
          : 'canFit(100): $fits100',
      topMargin: 5,
    );
    addLine(
      isRTL
          ? 'canFit(500): ${fits500 ? "نعم" : "لا"}'
          : 'canFit(500): $fits500',
      topMargin: 5,
    );
    addLine(
      isRTL
          ? 'canFit(effectivePageHeight): ${fitsAll ? "نعم" : "لا"} — لن يتسع لأننا رسمنا نصاً بالفعل'
          : 'canFit(effectivePageHeight): $fitsAll — won\'t fit because we already drew text',
      topMargin: 5,
    );

    addSpace(15);

    addLine(
      isRTL
          ? 'عدد الصفحات الإجمالي: $pageCount'
          : 'Total page count: $pageCount',
      font: config.boldFont,
      topMargin: 10,
    );
  }
}

/// Demonstrates v2.10.0 smart space management using the fluent Composer API.
///
/// ## Example
/// ```dart
/// final composer = GeniusPdfReportComposer(config: myConfig);
/// final bytes = composer
///     .withHeader(title: 'Smart Space Demo')
///     .withFooter(userName: 'Admin', showPageNumber: true)
///     .text('Header and footer are applied first.')
///     .text('remainingHeight accounts for footer space.')
///     .buildPdf();
/// composer.dispose();
/// ```
List<int> buildSmartSpaceComposerDemo(GeniusPdfConfig config) {
  final composer = GeniusPdfReportComposer(config: config);
  final bytes = composer
      .withHeader(title: 'Composer — Smart Space Demo (v2.10.0)')
      .withFooter(
        userName: 'Admin',
        showPageNumber: true,
        printTime: DateTime.now().toString().substring(0, 19),
      )
      .page()
      .text(
        'Header and footer heights are set BEFORE content rendering.',
        font: config.boldFont,
      )
      .space(10)
      .text('This ensures remainingHeight is always footer-aware.')
      .text('New pages start below the header, not at Y=0.')
      .space(10)
      .section('Section 1')
      .text('Sections auto page-break if they don\'t fit.')
      .space(10)
      .section('Section 2')
      .text('Each section divider checks for available space.')
      .buildPdf();
  composer.dispose();
  return bytes;
}
