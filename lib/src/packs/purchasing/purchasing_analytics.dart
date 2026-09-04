
import '../../domain/erp/erp.dart';
import '../shared/erp_pack_shared.dart';
import 'purchasing_models.dart';

class _PurchaseAggregate {
  _PurchaseAggregate({
    required this.label,
    required this.currency,
    this.labelAr,
  })  : net = ErpMoney.zero(currency),
        tax = ErpMoney.zero(currency);

  final String label;
  final String? labelAr;
  final ErpCurrency currency;
  double orderedQuantity = 0;
  double receivedQuantity = 0;
  ErpMoney net;
  ErpMoney tax;
}

/// Deterministic S13 purchasing analytical service.
class GeniusPurchasingAnalytics {
  const GeniusPurchasingAnalytics();

  GeniusErpPackReportData purchaseRegister(
    List<GeniusPurchaseLedgerEntry> entries,
  ) {
    return GeniusErpPackReportData(
      title: 'Purchase Register',
      titleAr: 'سجل المشتريات',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'date',
          title: 'Date',
          titleAr: 'التاريخ',
        ),
        GeniusErpPackReportColumn(
          id: 'document',
          title: 'Document',
          titleAr: 'المستند',
        ),
        GeniusErpPackReportColumn(
          id: 'supplier',
          title: 'Supplier',
          titleAr: 'المورد',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'item',
          title: 'Item',
          titleAr: 'الصنف',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'ordered',
          title: 'Ordered',
          titleAr: 'المطلوب',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'received',
          title: 'Received',
          titleAr: 'المستلم',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'net',
          title: 'Net',
          titleAr: 'الصافي',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'tax',
          title: 'Tax',
          titleAr: 'الضريبة',
          kind: GeniusErpPackReportColumnKind.money,
        ),
      ],
      rows: [
        for (final entry in entries)
          GeniusErpPackReportRow(
            cells: {
              'date': entry.date.toIso8601String().split('T').first,
              'document': entry.documentNumber,
              'supplier': GeniusErpPackLocalizedValue(
                value: entry.supplierName,
                valueAr: entry.supplierNameAr,
              ),
              'item': entry.itemCode,
              'ordered': entry.orderedQuantity,
              'received': entry.receivedQuantity,
              'net': entry.netAmount.toDouble(),
              'tax': entry.taxAmount.toDouble(),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData purchaseAnalysis(
    List<GeniusPurchaseLedgerEntry> entries,
  ) {
    final groups = <String, _PurchaseAggregate>{};

    for (final entry in entries) {
      final group = groups.putIfAbsent(
        entry.supplierId,
        () => _PurchaseAggregate(
          label: entry.supplierName,
          labelAr: entry.supplierNameAr,
          currency: entry.netAmount.currency,
        ),
      );
      _requireCurrency(group.currency, entry.netAmount.currency);
      group.orderedQuantity += entry.orderedQuantity;
      group.receivedQuantity += entry.receivedQuantity;
      group.net = group.net + entry.netAmount;
      group.tax = group.tax + entry.taxAmount;
    }

    return GeniusErpPackReportData(
      title: 'Purchase Analysis',
      titleAr: 'تحليل المشتريات',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'supplier',
          title: 'Supplier',
          titleAr: 'المورد',
          flexFactor: 3,
        ),
        GeniusErpPackReportColumn(
          id: 'ordered',
          title: 'Ordered',
          titleAr: 'المطلوب',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'received',
          title: 'Received',
          titleAr: 'المستلم',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'net',
          title: 'Net Purchases',
          titleAr: 'صافي المشتريات',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'tax',
          title: 'Tax',
          titleAr: 'الضريبة',
          kind: GeniusErpPackReportColumnKind.money,
        ),
      ],
      rows: [
        for (final group in groups.values)
          GeniusErpPackReportRow(
            cells: {
              'supplier': GeniusErpPackLocalizedValue(
                value: group.label,
                valueAr: group.labelAr,
              ),
              'ordered': group.orderedQuantity,
              'received': group.receivedQuantity,
              'net': group.net.toDouble(),
              'tax': group.tax.toDouble(),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData outstandingPurchaseOrders(
    List<GeniusPurchaseLedgerEntry> entries,
  ) {
    final open = entries
        .where((entry) => entry.outstandingQuantity > 0)
        .toList(growable: false);

    return GeniusErpPackReportData(
      title: 'Outstanding Purchase Orders',
      titleAr: 'أوامر الشراء المعلقة',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'po',
          title: 'PO',
          titleAr: 'أمر الشراء',
        ),
        GeniusErpPackReportColumn(
          id: 'supplier',
          title: 'Supplier',
          titleAr: 'المورد',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'item',
          title: 'Item',
          titleAr: 'الصنف',
        ),
        GeniusErpPackReportColumn(
          id: 'ordered',
          title: 'Ordered',
          titleAr: 'المطلوب',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'received',
          title: 'Received',
          titleAr: 'المستلم',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'open',
          title: 'Open',
          titleAr: 'المتبقي',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'delivery',
          title: 'Expected',
          titleAr: 'التسليم المتوقع',
        ),
      ],
      rows: [
        for (final entry in open)
          GeniusErpPackReportRow(
            cells: {
              'po': entry.documentNumber,
              'supplier': GeniusErpPackLocalizedValue(
                value: entry.supplierName,
                valueAr: entry.supplierNameAr,
              ),
              'item': entry.itemCode,
              'ordered': entry.orderedQuantity,
              'received': entry.receivedQuantity,
              'open': entry.outstandingQuantity,
              'delivery': entry.expectedDelivery
                      ?.toIso8601String()
                      .split('T')
                      .first ??
                  '',
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData supplierStatement(
    List<GeniusErpOpenItem> items,
  ) {
    return GeniusErpPackReportData(
      title: 'Supplier Statement',
      titleAr: 'كشف حساب المورد',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'document',
          title: 'Document',
          titleAr: 'المستند',
        ),
        GeniusErpPackReportColumn(
          id: 'issue',
          title: 'Issue Date',
          titleAr: 'تاريخ الإصدار',
        ),
        GeniusErpPackReportColumn(
          id: 'due',
          title: 'Due Date',
          titleAr: 'تاريخ الاستحقاق',
        ),
        GeniusErpPackReportColumn(
          id: 'amount',
          title: 'Amount',
          titleAr: 'المبلغ',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'outstanding',
          title: 'Outstanding',
          titleAr: 'الرصيد',
          kind: GeniusErpPackReportColumnKind.money,
        ),
      ],
      rows: [
        for (final item in items)
          GeniusErpPackReportRow(
            cells: {
              'document': item.documentNumber,
              'issue': item.issueDate.toIso8601String().split('T').first,
              'due': item.dueDate.toIso8601String().split('T').first,
              'amount': item.amount.toDouble(),
              'outstanding': item.outstanding.toDouble(),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData supplierAging(
    List<GeniusErpOpenItem> items, {
    required DateTime asOf,
  }) {
    final aging =
        const GeniusErpAgingService().calculate(items, asOf: asOf);

    return GeniusErpPackReportData(
      title: 'Supplier Aging',
      titleAr: 'أعمار ديون الموردين',
      subtitle: 'As of ${asOf.toIso8601String().split('T').first}',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'bucket',
          title: 'Bucket',
          titleAr: 'الفترة',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'amount',
          title: 'Outstanding',
          titleAr: 'الرصيد',
          kind: GeniusErpPackReportColumnKind.money,
        ),
      ],
      rows: [
        for (final bucket in aging.buckets)
          GeniusErpPackReportRow(
            cells: {
              'bucket': GeniusErpPackLocalizedValue(
                value: bucket.label,
                valueAr: bucket.labelAr,
              ),
              'amount': bucket.amount.toDouble(),
            },
          ),
        GeniusErpPackReportRow(
          isTotal: true,
          cells: {
            'bucket': 'Total',
            'amount': aging.total.toDouble(),
          },
        ),
      ],
    );
  }

  GeniusErpPackReportData goodsReceipt(
    List<GeniusPurchaseLedgerEntry> entries,
  ) {
    return GeniusErpPackReportData(
      title: 'Goods Receipt Note',
      titleAr: 'إشعار استلام بضاعة',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'po',
          title: 'PO',
          titleAr: 'أمر الشراء',
        ),
        GeniusErpPackReportColumn(
          id: 'item',
          title: 'Item',
          titleAr: 'الصنف',
        ),
        GeniusErpPackReportColumn(
          id: 'description',
          title: 'Description',
          titleAr: 'الوصف',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'ordered',
          title: 'Ordered',
          titleAr: 'المطلوب',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'received',
          title: 'Received',
          titleAr: 'المستلم',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'warehouse',
          title: 'Warehouse',
          titleAr: 'المستودع',
        ),
      ],
      rows: [
        for (final entry in entries)
          GeniusErpPackReportRow(
            cells: {
              'po': entry.documentNumber,
              'item': entry.itemCode,
              'description': GeniusErpPackLocalizedValue(
                value: entry.itemName,
                valueAr: entry.itemNameAr,
              ),
              'ordered': entry.orderedQuantity,
              'received': entry.receivedQuantity,
              'warehouse': entry.warehouse ?? '',
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData quotationComparison(
    List<GeniusSupplierQuoteLine> quotes,
  ) {
    final grouped = <String, List<GeniusSupplierQuoteLine>>{};
    for (final quote in quotes) {
      grouped.putIfAbsent(quote.itemCode, () => []).add(quote);
    }

    final rows = <GeniusErpPackReportRow>[];
    for (final entry in grouped.entries) {
      final candidates = entry.value;
      candidates.sort((a, b) {
        if (a.unitPrice.currency != b.unitPrice.currency) {
          throw ArgumentError(
            'Quotation comparison requires one currency per item.',
          );
        }
        return a.unitPrice.minorUnits.compareTo(b.unitPrice.minorUnits);
      });

      final best = candidates.first;
      for (final quote in candidates) {
        rows.add(
          GeniusErpPackReportRow(
            cells: {
              'item': quote.itemCode,
              'supplier': GeniusErpPackLocalizedValue(
                value: quote.supplierName,
                valueAr: quote.supplierNameAr,
              ),
              'price': quote.unitPrice.toDouble(),
              'lead': quote.leadTimeDays ?? '',
              'best': identical(quote, best) ? '✓' : '',
            },
          ),
        );
      }
    }

    return GeniusErpPackReportData(
      title: 'Quotation Comparison',
      titleAr: 'مقارنة عروض الأسعار',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'item',
          title: 'Item',
          titleAr: 'الصنف',
        ),
        GeniusErpPackReportColumn(
          id: 'supplier',
          title: 'Supplier',
          titleAr: 'المورد',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'price',
          title: 'Unit Price',
          titleAr: 'سعر الوحدة',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'lead',
          title: 'Lead Days',
          titleAr: 'أيام التوريد',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'best',
          title: 'Best',
          titleAr: 'الأفضل',
        ),
      ],
      rows: rows,
    );
  }

  void _requireCurrency(
    ErpCurrency expected,
    ErpCurrency actual,
  ) {
    if (expected != actual) {
      throw ArgumentError(
        'Purchasing analytics groups require one currency per report.',
      );
    }
  }
}
