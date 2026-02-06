/// Inventory Voucher template (Service IDs: 20600–20604).
///
/// Generates vouchers for:
/// - **20600** Inventory Addition — adding new items to inventory
/// - **20601** Inventory Issue — issuing items from inventory
/// - **20602** Inventory Adjustment — correcting inventory balances
/// - **20603** Inventory Transfer — transferring items between warehouses
/// - **20604** Inventory Damage/Write-off — recording damaged or lost items
library;

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Generates an inventory voucher PDF page.
///
/// ```dart
/// final voucher = InventoryVoucher(
///   config: config,
///   company: companyInfo,
///   data: VoucherData(
///     serviceId: VoucherServiceId.inventoryTransfer,
///     voucherNumber: 'INV-2026-001',
///     voucherDate: DateTime.now(),
///     amount: 15000,
///     items: [
///       VoucherLineItem(lineNumber: 1, description: 'Widget A', quantity: 100, unitPrice: 150, totalAmount: 15000),
///     ],
///   ),
///   inventoryData: VoucherInventoryData(
///     operationType: InventoryOperationType.transfer,
///     sourceWarehouse: 'Main Warehouse',
///     destinationWarehouse: 'Branch Warehouse',
///   ),
/// );
/// ```
class InventoryVoucher extends GeniusPdfVoucherTemplate {
  InventoryVoucher({
    required GeniusPdfConfig config,
    required GeniusPdfCompanyInfo company,
    required VoucherData data,
    required this.inventoryData,
    GeniusPdfVoucherStyle style = const GeniusPdfVoucherStyle(),
  }) : super(config: config, company: company, data: data, style: style);

  /// Inventory-specific data.
  final VoucherInventoryData inventoryData;

  @override
  void buildVoucherContent() {
    // Items table
    if (data.items.isNotEmpty) {
      _drawItemsTable();
    }

    // Value impact
    _drawValueImpact();

    // Amount block
    drawAmountBlock();

    // Account entries
    if (data.accountEntries.isNotEmpty) {
      drawAccountEntriesTable();
    }

    // Operation type
    _drawOperationInfo();

    // Warehouse info (varies by operation)
    _drawWarehouseInfo();

    // Reference info (PO, transfer order, etc.)
    _drawReferenceInfo();

    // Operation-specific details
    _drawOperationDetails();

    // Notes
    if (data.notes != null || data.notesAr != null) {
      drawNotesBlock();
    }
  }

  void _drawOperationInfo() {
    final opText = inventoryData.operationType.displayName(isRTL: isRTL);

    final items = <GeniusPdfLabeledValue>[
      _lv('نوع العملية', 'Operation Type', opText),
    ];

    addInfoSection(
      labelAr: 'معلومات العملية',
      labelEn: 'Operation Information',
      items: items,
      columns: 1,
    );
  }

  void _drawWarehouseInfo() {
    final items = <GeniusPdfLabeledValue>[];
    final op = inventoryData.operationType;

    // Source warehouse
    if (inventoryData.sourceWarehouse != null) {
      final label = op == InventoryOperationType.transfer
          ? (isRTL ? 'من المستودع' : 'From Warehouse')
          : (isRTL ? 'المستودع' : 'Warehouse');
      items.add(_lv(
          'من المستودع',
          label,
          isRTL
              ? (inventoryData.sourceWarehouseAr ??
                  inventoryData.sourceWarehouse!)
              : inventoryData.sourceWarehouse!));
    }

    // Destination warehouse
    if (inventoryData.destinationWarehouse != null) {
      final label = op == InventoryOperationType.transfer
          ? (isRTL ? 'إلى المستودع' : 'To Warehouse')
          : (isRTL ? 'المستودع' : 'Warehouse');
      items.add(_lv(
          'إلى المستودع',
          label,
          isRTL
              ? (inventoryData.destinationWarehouseAr ??
                  inventoryData.destinationWarehouse!)
              : inventoryData.destinationWarehouse!));
    }

    // Requesting department (for issue)
    if (inventoryData.requestingDepartment != null) {
      items.add(_lv(
          'القسم الطالب',
          'Requesting Dept',
          isRTL
              ? (inventoryData.requestingDepartmentAr ??
                  inventoryData.requestingDepartment!)
              : inventoryData.requestingDepartment!));
    }

    if (inventoryData.projectCode != null) {
      items.add(_lv('رمز المشروع', 'Project Code', inventoryData.projectCode!));
    }

    if (items.isEmpty) return;

    addInfoSection(
      labelAr: 'معلومات المستودع',
      labelEn: 'Warehouse Information',
      items: items,
      columns: items.length > 2 ? 2 : items.length,
    );
  }

  void _drawReferenceInfo() {
    final items = <GeniusPdfLabeledValue>[];

    if (data.referenceNumber != null) {
      items.add(_lv('رقم المرجع', 'Reference No', data.referenceNumber!));
    }

    if (inventoryData.transferOrderNumber != null) {
      items.add(_lv('رقم أمر التحويل', 'Transfer Order No',
          inventoryData.transferOrderNumber!));
    }

    if (inventoryData.authorizationReference != null) {
      items.add(_lv('مرجع الاعتماد', 'Authorization Ref',
          inventoryData.authorizationReference!));
    }

    if (items.isEmpty) return;

    addInfoSection(
      labelAr: 'المراجع',
      labelEn: 'References',
      items: items,
      columns: items.length,
    );
  }

  void _drawItemsTable() {
    final hasCode = data.items.any((i) => i.itemCode != null);
    final hasUnit = data.items.any((i) => i.unit != null);
    final op = inventoryData.operationType;

    // Determine quantity column header based on operation
    String qtyTitle;
    String qtyTitleAr;
    switch (op) {
      case InventoryOperationType.addition:
        qtyTitle = 'Qty Added';
        qtyTitleAr = 'الكمية المضافة';
        break;
      case InventoryOperationType.issue:
        qtyTitle = 'Qty Issued';
        qtyTitleAr = 'الكمية المصروفة';
        break;
      case InventoryOperationType.adjustment:
        qtyTitle = 'Qty Adjusted';
        qtyTitleAr = 'الكمية المعدلة';
        break;
      case InventoryOperationType.transfer:
        qtyTitle = 'Qty Transferred';
        qtyTitleAr = 'الكمية المحولة';
        break;
      case InventoryOperationType.damage:
        qtyTitle = 'Qty Damaged';
        qtyTitleAr = 'الكمية التالفة';
        break;
    }

    final columns = <GeniusPdfGridColumn>[
      const GeniusPdfGridColumn(
        id: 'no',
        title: '#',
        titleAr: '#',
        width: 30,
        alignment: GeniusPdfTextAlign.center,
      ),
      if (hasCode)
        const GeniusPdfGridColumn(
          id: 'code',
          title: 'Item Code',
          titleAr: 'رمز الصنف',
          width: 70,
          alignment: GeniusPdfTextAlign.center,
        ),
      const GeniusPdfGridColumn(
        id: 'desc',
        title: 'Description',
        titleAr: 'الوصف',
        flexFactor: 3,
      ),
      if (hasUnit)
        const GeniusPdfGridColumn(
          id: 'unit',
          title: 'Unit',
          titleAr: 'الوحدة',
          width: 50,
          alignment: GeniusPdfTextAlign.center,
        ),
      GeniusPdfGridColumn(
        id: 'qty',
        title: qtyTitle,
        titleAr: qtyTitleAr,
        width: 70,
        alignment: GeniusPdfTextAlign.center,
      ),
      GeniusPdfGridColumn.currency(
        id: 'cost',
        title: 'Unit Cost',
        titleAr: 'تكلفة الوحدة',
        width: 70,
        currencySymbol: '',
      ),
      GeniusPdfGridColumn.currency(
        id: 'total',
        title: 'Total Value',
        titleAr: 'القيمة الإجمالية',
        width: 85,
        currencySymbol: '',
      ),
    ];

    final rows = <GeniusPdfGridRow>[
      for (final item in data.items)
        GeniusPdfGridRow(cells: {
          'no': item.lineNumber,
          if (hasCode) 'code': item.itemCode ?? '',
          'desc': isRTL
              ? (item.descriptionAr ?? item.description)
              : item.description,
          if (hasUnit)
            'unit':
                isRTL ? (item.unitAr ?? item.unit ?? '') : (item.unit ?? ''),
          'qty': item.quantity,
          'cost': item.unitPrice,
          'total': item.totalAmount,
        }),
    ];

    // Items table label based on operation
    String labelAr;
    String labelEn;
    switch (op) {
      case InventoryOperationType.addition:
        labelAr = 'الأصناف المضافة';
        labelEn = 'Items Added';
        break;
      case InventoryOperationType.issue:
        labelAr = 'الأصناف المصروفة';
        labelEn = 'Items Issued';
        break;
      case InventoryOperationType.adjustment:
        labelAr = 'الأصناف المعدلة';
        labelEn = 'Items Adjusted';
        break;
      case InventoryOperationType.transfer:
        labelAr = 'الأصناف المحولة';
        labelEn = 'Items Transferred';
        break;
      case InventoryOperationType.damage:
        labelAr = 'الأصناف التالفة';
        labelEn = 'Damaged Items';
        break;
    }

    drawItemsTable(
      columns: columns,
      rows: rows,
      labelAr: labelAr,
      labelEn: labelEn,
    );
  }

  void _drawValueImpact() {
    final op = inventoryData.operationType;

    String impactLabel;
    String impactLabelAr;
    switch (op) {
      case InventoryOperationType.addition:
        impactLabel = 'Inventory Increase';
        impactLabelAr = 'زيادة المخزون';
        break;
      case InventoryOperationType.issue:
      case InventoryOperationType.damage:
        impactLabel = 'Inventory Decrease';
        impactLabelAr = 'نقص المخزون';
        break;
      case InventoryOperationType.adjustment:
        impactLabel = 'Net Adjustment';
        impactLabelAr = 'صافي التعديل';
        break;
      case InventoryOperationType.transfer:
        impactLabel = 'Transfer Value';
        impactLabelAr = 'قيمة التحويل';
        break;
    }

    final items = <GeniusPdfLabeledValue>[
      _lv(impactLabelAr, impactLabel,
          '${_fmtNum(data.amount)} ${data.currency}'),
    ];

    addInfoSection(
      labelAr: 'أثر القيمة',
      labelEn: 'Value Impact',
      items: items,
      columns: 1,
    );
  }

  void _drawOperationDetails() {
    final op = inventoryData.operationType;
    final items = <GeniusPdfLabeledValue>[];

    // Adjustment-specific
    if (op == InventoryOperationType.adjustment &&
        inventoryData.adjustmentReason != null) {
      items.add(_lv('سبب التعديل', 'Adjustment Reason',
          inventoryData.adjustmentReason!.displayName(isRTL: isRTL)));
    }

    // Damage-specific
    if (op == InventoryOperationType.damage) {
      if (inventoryData.damageType != null) {
        items.add(_lv('نوع التلف', 'Damage Type',
            inventoryData.damageType!.displayName(isRTL: isRTL)));
      }

      if (inventoryData.damageDescription != null ||
          inventoryData.damageDescriptionAr != null) {
        items.add(_lv(
            'وصف التلف',
            'Damage Description',
            isRTL
                ? (inventoryData.damageDescriptionAr ??
                    inventoryData.damageDescription!)
                : inventoryData.damageDescription!));
      }

      if (inventoryData.inspectedBy != null) {
        items.add(_lv(
            'فحص بواسطة',
            'Inspected By',
            isRTL
                ? (inventoryData.inspectedByAr ?? inventoryData.inspectedBy!)
                : inventoryData.inspectedBy!));
      }

      if (inventoryData.disposalMethod != null) {
        items.add(_lv(
            'طريقة التخلص',
            'Disposal Method',
            isRTL
                ? (inventoryData.disposalMethodAr ??
                    inventoryData.disposalMethod!)
                : inventoryData.disposalMethod!));
      }

      if (inventoryData.insuranceClaim == true) {
        items
            .add(_lv('مطالبة تأمين', 'Insurance Claim', isRTL ? 'نعم' : 'Yes'));
        if (inventoryData.insuranceClaimNumber != null) {
          items.add(_lv('رقم المطالبة', 'Claim Number',
              inventoryData.insuranceClaimNumber!));
        }
      }
    }

    if (items.isEmpty) return;

    addInfoSection(
      labelAr: 'تفاصيل العملية',
      labelEn: 'Operation Details',
      items: items,
      columns: items.length > 2 ? 2 : 1,
    );
  }

  // ── Helpers ──

  GeniusPdfLabeledValue _lv(String labelAr, String labelEn, String value) {
    return GeniusPdfLabeledValue(
      config: config,
      label: labelEn,
      labelAr: labelAr,
      value: value,
    );
  }

  String _fmtNum(double n) {
    if (n == n.truncateToDouble()) {
      return n.truncate().toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    }
    return n
        .toStringAsFixed(2)
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},');
  }

  @override
  List<VoucherSignatory> defaultSignatories() {
    final op = inventoryData.operationType;

    switch (op) {
      case InventoryOperationType.addition:
        return [
          InventorySignatories.storekeeper(),
          TradeSignatories.warehouseKeeper(),
          VoucherSignatory.accountant(),
        ];
      case InventoryOperationType.issue:
        return [
          InventorySignatories.requestor(),
          InventorySignatories.storekeeper(),
          VoucherSignatory.accountant(),
        ];
      case InventoryOperationType.adjustment:
        return [
          InventorySignatories.storekeeper(),
          InventorySignatories.warehouseManager(),
          VoucherSignatory.accountant(),
          VoucherSignatory.manager(),
        ];
      case InventoryOperationType.transfer:
        return [
          InventorySignatories.storekeeper(),
          InventorySignatories.warehouseManager(),
          VoucherSignatory.accountant(),
        ];
      case InventoryOperationType.damage:
        return [
          InventorySignatories.storekeeper(),
          TradeSignatories.qualityInspector(),
          InventorySignatories.insuranceOfficer(),
          VoucherSignatory.accountant(),
          VoucherSignatory.manager(),
        ];
    }
  }
}
