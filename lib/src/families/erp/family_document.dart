import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../builders/pdf_document_builder.dart';
import '../../components/components.dart';
import '../../core/component_directionality.dart';
import '../../core/directionality.dart';
import '../../core/pdf_config.dart';
import '../../core/pdf_theme.dart';
import '../../domain/erp/erp.dart';
import 'family_models.dart';

GeniusPdfConfig _resolveFamilyConfig(
  GeniusPdfConfig config,
  GeniusPdfTheme? themeOverride,
  GeniusErpPrintProfile? printProfile,
) {
  var resolved = printProfile == null ? config : printProfile.apply(config);
  if (themeOverride != null) {
    resolved = resolved.copyWith(theme: themeOverride);
  }
  return resolved;
}

/// Base implementation for all S08 generic ERP document families.
///
/// The class owns the structural slot order and page-flow policy. Applications
/// customize/reuse it through [GeniusErpFamilyPlan], component replacement,
/// custom sections and lifecycle hooks rather than copying renderer code.
class GeniusErpDocumentFamily extends GeniusPdfDocumentBuilder {
  GeniusErpDocumentFamily(
    GeniusPdfConfig config, {
    required this.familyKind,
    GeniusErpFamilyPlan? plan,
    GeniusPdfDirectionality? directionality,
    GeniusPdfTheme? themeOverride,
    GeniusErpPrintProfile? printProfile,
  })  : _providedPlan = plan,
        super(
          _resolveFamilyConfig(config, themeOverride, printProfile),
          directionality: directionality,
        );

  final GeniusErpDocumentFamilyKind familyKind;
  final GeniusErpFamilyPlan? _providedPlan;

  /// Override this in compatibility templates when the plan depends on fields
  /// initialized by the subclass constructor.
  GeniusErpFamilyPlan createFamilyPlan() {
    final value = _providedPlan;
    if (value == null) {
      throw StateError(
        '$runtimeType must receive a GeniusErpFamilyPlan or override '
        'createFamilyPlan().',
      );
    }
    return value;
  }

  @override
  void build() {
    final plan = createFamilyPlan();

    _invokeHooks(
      plan,
      GeniusErpFamilyHookPhase.beforeDocument,
    );

    newPage();

    for (final slot in GeniusErpFamilySlot.values) {
      _renderSlot(plan, slot);
    }

    _invokeHooks(
      plan,
      GeniusErpFamilyHookPhase.afterDocument,
    );
  }

  void _renderSlot(
    GeniusErpFamilyPlan plan,
    GeniusErpFamilySlot slot,
  ) {
    final policy = plan.policyFor(slot);

    _renderCustomSections(
      plan,
      slot,
      GeniusErpCustomSectionPosition.before,
    );

    _invokeHooks(
      plan,
      GeniusErpFamilyHookPhase.beforeSlot,
      slot: slot,
    );

    final replacement = _replacementFor(plan, slot);
    if (replacement != null) {
      final context = _componentContext(
        plan,
        slot,
        policy.direction,
      );
      final component = replacement(context);
      if (component != null) {
        drawFamilyComponent(
          component,
          spacingAfter: policy.spacingAfter,
          estimatedHeight: policy.estimatedHeight,
          breakPolicy: policy.breakPolicy,
        );
      }
    } else if (_defaultSlotHasContent(plan, slot)) {
      _prepareSlot(policy);
      _renderDefaultSlot(plan, slot, policy);
    }

    _invokeHooks(
      plan,
      GeniusErpFamilyHookPhase.afterSlot,
      slot: slot,
    );

    _renderCustomSections(
      plan,
      slot,
      GeniusErpCustomSectionPosition.after,
    );
  }

  GeniusErpSlotComponentFactory? _replacementFor(
    GeniusErpFamilyPlan plan,
    GeniusErpFamilySlot slot,
  ) {
    if (slot == GeniusErpFamilySlot.header &&
        pageCount == 1 &&
        plan.pageVariants.firstPageHeader != null) {
      return plan.pageVariants.firstPageHeader;
    }

    // The footer slot is reached only after body/summary/optional flow is
    // complete, therefore currentPage is the final page at this point.
    if (slot == GeniusErpFamilySlot.footer &&
        plan.pageVariants.lastPageFooter != null) {
      return plan.pageVariants.lastPageFooter;
    }

    return plan.replacements[slot];
  }

  bool _defaultSlotHasContent(
    GeniusErpFamilyPlan plan,
    GeniusErpFamilySlot slot,
  ) {
    switch (slot) {
      case GeniusErpFamilySlot.header:
        return plan.title.trim().isNotEmpty ||
            (plan.titleAr?.trim().isNotEmpty ?? false) ||
            plan.company != null;
      case GeniusErpFamilySlot.identity:
        return true;
      case GeniusErpFamilySlot.parties:
        return plan.primaryParty != null ||
            plan.secondaryParty != null ||
            plan.addresses.any(
              (section) => section.address != null && !section.address!.isEmpty,
            );
      case GeniusErpFamilySlot.references:
        return plan.document.references.isNotEmpty;
      case GeniusErpFamilySlot.body:
        return plan.calculation != null && plan.calculation!.lines.isNotEmpty;
      case GeniusErpFamilySlot.summary:
        return plan.showSummary && plan.calculation != null;
      case GeniusErpFamilySlot.notesTerms:
        return _hasText(plan.notes) ||
            _hasText(plan.notesAr) ||
            _hasText(plan.terms) ||
            _hasText(plan.termsAr);
      case GeniusErpFamilySlot.approvalsSignatures:
        return (plan.showApprovals && plan.document.approvals.isNotEmpty) ||
            plan.signatures.isNotEmpty;
      case GeniusErpFamilySlot.attachmentsCodes:
        return (plan.showAttachments && plan.document.attachments.isNotEmpty) ||
            (plan.code != null && !plan.code!.isEmpty);
      case GeniusErpFamilySlot.footer:
        return _hasText(plan.footerText) || _hasText(plan.footerTextAr);
    }
  }

  bool _hasText(String? value) => value != null && value.trim().isNotEmpty;

  void _prepareSlot(GeniusErpSlotPolicy policy) {
    if (policy.breakPolicy == GeniusErpSlotBreakPolicy.pageBefore) {
      if (currentY > headerHeight) {
        newPage();
      }
      return;
    }

    if (policy.breakPolicy == GeniusErpSlotBreakPolicy.keepTogether ||
        policy.breakPolicy == GeniusErpSlotBreakPolicy.auto) {
      if (remainingHeight < policy.estimatedHeight && currentY > headerHeight) {
        newPage();
      }
    }
  }

  GeniusErpFamilyComponentContext _componentContext(
    GeniusErpFamilyPlan plan,
    GeniusErpFamilySlot slot,
    GeniusPdfDirection direction,
  ) {
    return GeniusErpFamilyComponentContext(
      familyKind: familyKind,
      slot: slot,
      config: config,
      directionality: directionalityForComponent(direction),
      document: plan.document,
      calculation: plan.calculation,
    );
  }

  void _invokeHooks(
    GeniusErpFamilyPlan plan,
    GeniusErpFamilyHookPhase phase, {
    GeniusErpFamilySlot? slot,
  }) {
    if (plan.hooks.isEmpty) return;

    final context = GeniusErpFamilyHookContext(
      familyKind: familyKind,
      phase: phase,
      document: plan.document,
      calculation: plan.calculation,
      slot: slot,
      pageIndex: pageCount <= 0 ? 0 : pageCount - 1,
    );

    for (final hook in plan.hooks) {
      hook(context);
    }
  }

  void _renderCustomSections(
    GeniusErpFamilyPlan plan,
    GeniusErpFamilySlot slot,
    GeniusErpCustomSectionPosition position,
  ) {
    for (final section in plan.customSections) {
      if (section.slot != slot || section.position != position) {
        continue;
      }

      final context = _componentContext(
        plan,
        slot,
        section.policy.direction,
      );
      final component = section.builder(context);
      if (component == null || !component.isVisible) continue;

      drawFamilyComponent(
        component,
        spacingAfter: section.policy.spacingAfter,
        estimatedHeight: section.policy.estimatedHeight,
        breakPolicy: section.policy.breakPolicy,
      );
    }
  }

  void _renderDefaultSlot(
    GeniusErpFamilyPlan plan,
    GeniusErpFamilySlot slot,
    GeniusErpSlotPolicy policy,
  ) {
    switch (slot) {
      case GeniusErpFamilySlot.header:
        _renderHeader(plan, policy);
        return;
      case GeniusErpFamilySlot.identity:
        _renderIdentity(plan, policy);
        return;
      case GeniusErpFamilySlot.parties:
        _renderParties(plan, policy);
        return;
      case GeniusErpFamilySlot.references:
        _renderReferences(plan, policy);
        return;
      case GeniusErpFamilySlot.body:
        _renderBody(plan, policy);
        return;
      case GeniusErpFamilySlot.summary:
        _renderSummary(plan, policy);
        return;
      case GeniusErpFamilySlot.notesTerms:
        _renderNotesTerms(plan, policy);
        return;
      case GeniusErpFamilySlot.approvalsSignatures:
        _renderApprovalsAndSignatures(plan, policy);
        return;
      case GeniusErpFamilySlot.attachmentsCodes:
        _renderAttachmentsAndCodes(plan, policy);
        return;
      case GeniusErpFamilySlot.footer:
        _renderFooter(plan, policy);
        return;
    }
  }

  /// Draws one S07 semantic component while preserving null-collapse.
  ///
  /// No spacing is consumed when [component.isVisible] is false or draw()
  /// returns null.
  Rect? drawFamilyComponent(
    GeniusPdfErpComponent component, {
    double spacingAfter = 10,
    double estimatedHeight = 80,
    GeniusErpSlotBreakPolicy breakPolicy = GeniusErpSlotBreakPolicy.auto,
  }) {
    if (!component.isVisible) return null;

    if (breakPolicy == GeniusErpSlotBreakPolicy.pageBefore) {
      if (currentY > headerHeight) {
        newPage();
      }
    } else if ((breakPolicy == GeniusErpSlotBreakPolicy.auto ||
            breakPolicy == GeniusErpSlotBreakPolicy.keepTogether) &&
        remainingHeight < estimatedHeight &&
        currentY > headerHeight) {
      newPage();
    }

    final result = component.draw(
      page: currentPage,
      bounds: contentBounds,
    );

    if (result == null || result.height <= 0) {
      return null;
    }

    setCurrentPage(
      currentPage,
      y: result.bottom + spacingAfter,
    );
    return result;
  }

  void _renderHeader(
    GeniusErpFamilyPlan plan,
    GeniusErpSlotPolicy policy,
  ) {
    final company = plan.company;
    if (company == null) {
      drawFamilyComponent(
        GeniusPdfLabel(
          config: config,
          text: plan.title,
          textAr: plan.titleAr,
          tone: GeniusPdfSemanticTone.info,
          alignment: GeniusPdfLogicalAlignment.center,
          directionality: directionalityForComponent(policy.direction),
        ),
        spacingAfter: policy.spacingAfter,
        estimatedHeight: 32,
        breakPolicy: policy.breakPolicy,
      );
      return;
    }

    final header = GeniusPdfReportHeader(
      config: config,
      title: plan.title,
      titleAr: plan.titleAr,
      subtitle: '#${plan.document.identity.number}',
      subtitleAr: '#${plan.document.identity.number}',
      company: company,
      printDate: plan.document.identity.issueDate,
      style: const GeniusPdfReportHeaderStyle.modern(),
      layout: GeniusPdfReportHeaderLayout.bilingualSplit,
      directionality: directionalityForComponent(policy.direction),
    );

    addReportHeader(
      header,
      height: 105,
      spacing: policy.spacingAfter,
    );
  }

  void _renderIdentity(
    GeniusErpFamilyPlan plan,
    GeniusErpSlotPolicy policy,
  ) {
    final slotDirectionality = directionalityForComponent(policy.direction);

    drawFamilyComponent(
      GeniusPdfDocumentIdentity(
        config: config,
        data: plan.document.identity,
        directionality: slotDirectionality,
      ),
      spacingAfter: plan.detailFields.isEmpty ? policy.spacingAfter : 4,
      estimatedHeight: policy.estimatedHeight,
      breakPolicy: policy.breakPolicy,
    );

    if (plan.detailFields.isEmpty) return;

    final items = plan.detailFields
        .map(
          (field) => GeniusPdfLabeledValue(
            config: config,
            label: field.label,
            labelAr: field.labelAr,
            value: field.value,
            directionality: slotDirectionality,
            valueDirection:
                slotDirectionality.resolveValue(field.valueKind).isRtl
                    ? GeniusPdfDirection.rtl
                    : GeniusPdfDirection.ltr,
          ),
        )
        .toList(growable: false);

    final box = GeniusPdfInfoBox(
      config: config,
      title: 'Details',
      titleAr: 'التفاصيل',
      items: items,
      directionality: slotDirectionality,
    );

    final result = box.draw(
      page: currentPage,
      bounds: contentBounds,
    );

    if (result.height > 0) {
      setCurrentPage(
        currentPage,
        y: result.bottom + policy.spacingAfter,
      );
    }
  }

  void _renderParties(
    GeniusErpFamilyPlan plan,
    GeniusErpSlotPolicy policy,
  ) {
    final slotDirectionality = directionalityForComponent(policy.direction);
    final components = <GeniusPdfErpComponent>[];

    if (plan.primaryParty != null) {
      components.add(
        GeniusPdfPartyBlock(
          config: config,
          party: plan.primaryParty,
          title: plan.primaryPartyTitle,
          titleAr: plan.primaryPartyTitleAr,
          directionality: slotDirectionality,
        ),
      );
    }

    if (plan.secondaryParty != null) {
      components.add(
        GeniusPdfPartyBlock(
          config: config,
          party: plan.secondaryParty,
          title: plan.secondaryPartyTitle,
          titleAr: plan.secondaryPartyTitleAr,
          directionality: slotDirectionality,
        ),
      );
    }

    for (final address in plan.addresses) {
      components.add(
        GeniusPdfAddressBlock(
          config: config,
          address: address.address,
          title: address.title,
          titleAr: address.titleAr ?? '',
          directionality: slotDirectionality,
        ),
      );
    }

    if (components.isEmpty) return;

    final group = GeniusPdfErpComponentGroup(
      components: components,
      spacing: 8,
    );

    final result = group.draw(
      page: currentPage,
      bounds: contentBounds,
    );

    if (result != null && result.height > 0) {
      setCurrentPage(
        currentPage,
        y: result.bottom + policy.spacingAfter,
      );
    }
  }

  void _renderReferences(
    GeniusErpFamilyPlan plan,
    GeniusErpSlotPolicy policy,
  ) {
    drawFamilyComponent(
      GeniusPdfReferenceBlock(
        config: config,
        references: plan.document.references,
        directionality: directionalityForComponent(policy.direction),
      ),
      spacingAfter: policy.spacingAfter,
      estimatedHeight: policy.estimatedHeight,
      breakPolicy: policy.breakPolicy,
    );
  }

  void _renderBody(
    GeniusErpFamilyPlan plan,
    GeniusErpSlotPolicy policy,
  ) {
    final calculation = plan.calculation;
    if (calculation == null || calculation.lines.isEmpty) {
      return;
    }

    final hasDiscount = plan.showLineDiscount &&
        calculation.lines.any(
          (line) => !line.lineDiscountTotal.isZero,
        );
    final hasTax = plan.showLineTax &&
        calculation.lines.any(
          (line) => !line.taxTotal.isZero,
        );

    final columns = <GeniusPdfGridColumn>[
      const GeniusPdfGridColumn(
        id: 'no',
        title: '#',
        titleAr: '#',
        width: 32,
        alignment: GeniusPdfTextAlign.center,
      ),
      const GeniusPdfGridColumn(
        id: 'description',
        title: 'Description',
        titleAr: 'الوصف',
        flexFactor: 3,
      ),
      const GeniusPdfGridColumn(
        id: 'qty',
        title: 'Qty',
        titleAr: 'الكمية',
        width: 60,
        alignment: GeniusPdfTextAlign.center,
      ),
      GeniusPdfGridColumn.currency(
        id: 'price',
        title: 'Unit Price',
        titleAr: 'سعر الوحدة',
        width: 82,
        currencySymbol: '',
      ),
      if (hasDiscount)
        GeniusPdfGridColumn.currency(
          id: 'discount',
          title: 'Discount',
          titleAr: 'الخصم',
          width: 72,
          currencySymbol: '',
        ),
      if (hasTax)
        GeniusPdfGridColumn.currency(
          id: 'tax',
          title: 'Tax',
          titleAr: 'الضريبة',
          width: 72,
          currencySymbol: '',
        ),
      GeniusPdfGridColumn.currency(
        id: 'total',
        title: 'Total',
        titleAr: 'الإجمالي',
        width: 90,
        currencySymbol: '',
      ),
    ];

    final rows = <GeniusPdfGridRow>[];
    for (var index = 0; index < calculation.lines.length; index++) {
      final line = calculation.lines[index];
      final item = line.line;
      rows.add(
        GeniusPdfGridRow(
          cells: {
            'no': index + 1,
            'description': config.isRTL
                ? (item.descriptionAr ?? item.description)
                : item.description,
            'qty': config.formatter.formatQuantity(
              item.quantity.value,
              decimalPlaces: item.quantity.unit.precision,
            ),
            'price': item.unitPrice.toDouble(),
            if (hasDiscount) 'discount': line.lineDiscountTotal.toDouble(),
            if (hasTax) 'tax': line.taxTotal.toDouble(),
            'total': line.total.toDouble(),
          },
        ),
      );
    }

    final grid = GeniusPdfDataGrid(
      config: config,
      columns: columns,
      rows: rows,
      style: GeniusPdfGridStyle.modern(),
      directionality: directionalityForComponent(policy.direction),
    );

    final result = grid.drawAt(
      page: currentPage,
      x: 0,
      y: currentY,
      width: pageWidth,
    );

    if (result != null) {
      updateFromLayoutResult(
        result,
        spacing: policy.spacingAfter,
      );
    }
  }

  void _renderSummary(
    GeniusErpFamilyPlan plan,
    GeniusErpSlotPolicy policy,
  ) {
    final calculation = plan.calculation;
    if (!plan.showSummary || calculation == null) return;

    final slotDirectionality = directionalityForComponent(policy.direction);

    final group = GeniusPdfErpComponentGroup(
      spacing: 8,
      components: [
        GeniusPdfAdjustmentSummary(
          config: config,
          result: calculation,
          directionality: slotDirectionality,
        ),
        GeniusPdfTaxSummary(
          config: config,
          result: calculation,
          directionality: slotDirectionality,
        ),
        GeniusPdfBalanceDueBlock(
          config: config,
          result: calculation,
          directionality: slotDirectionality,
        ),
        GeniusPdfAmountInWords(
          config: config,
          amount: calculation.grandTotal,
          text: plan.amountInWords,
          textAr: plan.amountInWordsAr,
          directionality: slotDirectionality,
        ),
      ],
    );

    final result = group.draw(
      page: currentPage,
      bounds: contentBounds,
    );
    if (result != null && result.height > 0) {
      setCurrentPage(
        currentPage,
        y: result.bottom + policy.spacingAfter,
      );
    }
  }

  void _renderNotesTerms(
    GeniusErpFamilyPlan plan,
    GeniusErpSlotPolicy policy,
  ) {
    final slotDirectionality = directionalityForComponent(policy.direction);

    final group = GeniusPdfErpComponentGroup(
      spacing: 8,
      components: [
        GeniusPdfTermsSection(
          config: config,
          text: plan.notes,
          textAr: plan.notesAr,
          title: 'Notes',
          titleAr: 'ملاحظات',
          directionality: slotDirectionality,
        ),
        GeniusPdfTermsSection(
          config: config,
          text: plan.terms,
          textAr: plan.termsAr,
          directionality: slotDirectionality,
        ),
      ],
    );

    final result = group.draw(
      page: currentPage,
      bounds: contentBounds,
    );
    if (result != null && result.height > 0) {
      setCurrentPage(
        currentPage,
        y: result.bottom + policy.spacingAfter,
      );
    }
  }

  void _renderApprovalsAndSignatures(
    GeniusErpFamilyPlan plan,
    GeniusErpSlotPolicy policy,
  ) {
    final slotDirectionality = directionalityForComponent(policy.direction);

    if (plan.showApprovals && plan.document.approvals.isNotEmpty) {
      drawFamilyComponent(
        GeniusPdfApprovalTrail(
          config: config,
          approvals: plan.document.approvals,
          directionality: slotDirectionality,
        ),
        spacingAfter: policy.spacingAfter,
        estimatedHeight: policy.estimatedHeight,
        breakPolicy: policy.breakPolicy,
      );
    }

    if (plan.signatures.isEmpty) return;

    const signatureHeight = 68.0;
    if (remainingHeight < signatureHeight + policy.spacingAfter) {
      newPage();
    }

    final count = plan.signatures.length;
    final width = (pageWidth - (count - 1) * 12) / count;
    var maxBottom = currentY;

    for (var physicalIndex = 0; physicalIndex < count; physicalIndex++) {
      final definitionIndex = GeniusPdfComponentDirectionality.definitionIndex(
        index: physicalIndex,
        count: count,
        direction: slotDirectionality.resolve().direction,
        followDirection: true,
      );
      final spec = plan.signatures[definitionIndex];
      final x = physicalIndex * (width + 12);

      final area = GeniusPdfSignatureArea(
        config: config,
        title: spec.title,
        titleAr: spec.titleAr,
        showDate: spec.showDate,
        directionality: slotDirectionality,
      );

      final result = area.draw(
        page: currentPage,
        bounds: Rect.fromLTWH(
          x,
          currentY,
          width,
          signatureHeight,
        ),
      );

      if (result.bottom > maxBottom) {
        maxBottom = result.bottom;
      }
    }

    setCurrentPage(
      currentPage,
      y: maxBottom + policy.spacingAfter,
    );
  }

  void _renderAttachmentsAndCodes(
    GeniusErpFamilyPlan plan,
    GeniusErpSlotPolicy policy,
  ) {
    final slotDirectionality = directionalityForComponent(policy.direction);

    if (plan.showAttachments && plan.document.attachments.isNotEmpty) {
      final items = plan.document.attachments
          .map(
            (attachment) => GeniusPdfLabeledValue(
              config: config,
              label: attachment.name,
              labelAr: attachment.name,
              value: attachment.mimeType ?? attachment.id,
              directionality: slotDirectionality,
              valueDirection: GeniusPdfDirection.ltr,
            ),
          )
          .toList(growable: false);

      final box = GeniusPdfInfoBox(
        config: config,
        title: 'Attachments',
        titleAr: 'المرفقات',
        items: items,
        directionality: slotDirectionality,
      );

      final result = box.draw(
        page: currentPage,
        bounds: contentBounds,
      );
      if (result.height > 0) {
        setCurrentPage(
          currentPage,
          y: result.bottom + policy.spacingAfter,
        );
      }
    }

    final code = plan.code;
    if (code == null || code.isEmpty) return;

    if (remainingHeight < code.size + 30 + policy.spacingAfter) {
      newPage();
    }

    if (code.image != null) {
      final x = resolvedLayoutDirection.isRtl ? pageWidth - code.size : 0.0;
      currentPage.graphics.drawImage(
        PdfBitmap(code.image!.data),
        Rect.fromLTWH(
          x,
          currentY,
          code.size,
          code.size,
        ),
      );
      setCurrentPage(
        currentPage,
        y: currentY + code.size + policy.spacingAfter,
      );
      return;
    }

    final data = code.data;
    if (data == null || data.isEmpty) return;

    if (code.kind == GeniusErpCodeKind.barcode) {
      final barcode = GeniusPdfBarcode(
        data: data,
        type: code.barcodeType,
        caption: code.caption,
        captionAr: code.captionAr,
        config: config,
        directionality: slotDirectionality,
        height: code.size,
      );

      final result = barcode.draw(
        page: currentPage,
        bounds: Rect.fromLTWH(
          0,
          currentY,
          pageWidth,
          code.size + 40,
        ),
      );

      setCurrentPage(
        currentPage,
        y: result.bottom + policy.spacingAfter,
      );
      return;
    }

    final qr = GeniusPdfQRCodeGenerator(
      data: data,
      caption: code.caption,
      captionAr: code.captionAr,
      config: config,
      directionality: slotDirectionality,
    );

    final result = qr.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(
        0,
        currentY,
        pageWidth,
        code.size + 40,
      ),
    );

    setCurrentPage(
      currentPage,
      y: result.bottom + policy.spacingAfter,
    );
  }

  void _renderFooter(
    GeniusErpFamilyPlan plan,
    GeniusErpSlotPolicy policy,
  ) {
    final text = plan.footerText;
    final textAr = plan.footerTextAr;

    if ((text == null || text.isEmpty) && (textAr == null || textAr.isEmpty)) {
      return;
    }

    drawFamilyComponent(
      GeniusPdfLabel(
        config: config,
        text: text,
        textAr: textAr,
        tone: GeniusPdfSemanticTone.neutral,
        alignment: GeniusPdfLogicalAlignment.center,
        directionality: directionalityForComponent(policy.direction),
      ),
      spacingAfter: policy.spacingAfter,
      estimatedHeight: 28,
      breakPolicy: policy.breakPolicy,
    );
  }
}
