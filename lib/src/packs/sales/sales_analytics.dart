
import '../../domain/erp/erp.dart';
import '../shared/erp_pack_shared.dart';
import 'sales_models.dart';

class _SalesAggregate {
  _SalesAggregate({
    required this.label,
    required this.currency,
    this.labelAr,
  })  : net = ErpMoney.zero(currency),
        tax = ErpMoney.zero(currency),
        cost = ErpMoney.zero(currency),
        commission = ErpMoney.zero(currency);

  final String label;
  final String? labelAr;
  final ErpCurrency currency;
  double quantity = 0;
  ErpMoney net;
  ErpMoney tax;
  ErpMoney cost;
  ErpMoney commission;
}

/// Deterministic S12 analytical service.
///
/// All aggregation is performed before PDF rendering.
class GeniusSalesAnalytics {
  const GeniusSalesAnalytics();

  GeniusErpPackReportData salesRegister(
    List<GeniusSalesLedgerEntry> entries,
  ) {
    return GeniusErpPackReportData(
      title: 'Sales Register',
      titleAr: 'سجل المبيعات',
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
          id: 'customer',
          title: 'Customer',
          titleAr: 'العميل',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'item',
          title: 'Item',
          titleAr: 'الصنف',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'qty',
          title: 'Qty',
          titleAr: 'الكمية',
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
              'customer': GeniusErpPackLocalizedValue(
                value: entry.customerName,
                valueAr: entry.customerNameAr,
              ),
              'item': GeniusErpPackLocalizedValue(
                value: entry.itemName,
                valueAr: entry.itemNameAr,
              ),
              'qty': entry.quantity,
              'net': entry.netAmount.toDouble(),
              'tax': entry.taxAmount.toDouble(),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData salesByCustomer(
    List<GeniusSalesLedgerEntry> entries,
  ) =>
      _aggregateReport(
        entries,
        title: 'Sales by Customer',
        titleAr: 'المبيعات حسب العميل',
        key: (entry) => entry.customerId,
        label: (entry) => entry.customerName,
        labelAr: (entry) => entry.customerNameAr,
      );

  GeniusErpPackReportData salesByItem(
    List<GeniusSalesLedgerEntry> entries,
  ) =>
      _aggregateReport(
        entries,
        title: 'Sales by Item',
        titleAr: 'المبيعات حسب الصنف',
        key: (entry) => entry.itemId,
        label: (entry) => entry.itemName,
        labelAr: (entry) => entry.itemNameAr,
      );

  GeniusErpPackReportData salesBySalesperson(
    List<GeniusSalesLedgerEntry> entries,
  ) =>
      _aggregateReport(
        entries.where(
          (entry) =>
              entry.salespersonId != null ||
              entry.salespersonName != null,
        ),
        title: 'Sales by Salesperson',
        titleAr: 'المبيعات حسب مندوب المبيعات',
        key: (entry) =>
            entry.salespersonId ?? entry.salespersonName ?? 'unknown',
        label: (entry) =>
            entry.salespersonName ?? entry.salespersonId ?? 'Unknown',
        labelAr: (entry) => entry.salespersonNameAr,
      );

  GeniusErpPackReportData commissionReport(
    List<GeniusSalesLedgerEntry> entries,
  ) {
    final groups = <String, _SalesAggregate>{};

    for (final entry in entries) {
      final key =
          entry.salespersonId ?? entry.salespersonName ?? 'unknown';
      final group = groups.putIfAbsent(
        key,
        () => _SalesAggregate(
          label:
              entry.salespersonName ?? entry.salespersonId ?? 'Unknown',
          labelAr: entry.salespersonNameAr,
          currency: entry.netAmount.currency,
        ),
      );
      _requireCurrency(group.currency, entry.netAmount.currency);
      group.net = group.net + entry.netAmount;
      group.commission = group.commission +
          entry.netAmount.multiply(
            entry.commissionRatePercent / 100,
          );
    }

    return GeniusErpPackReportData(
      title: 'Commission Report',
      titleAr: 'تقرير العمولات',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'salesperson',
          title: 'Salesperson',
          titleAr: 'مندوب المبيعات',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'sales',
          title: 'Sales',
          titleAr: 'المبيعات',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'commission',
          title: 'Commission',
          titleAr: 'العمولة',
          kind: GeniusErpPackReportColumnKind.money,
        ),
      ],
      rows: [
        for (final group in groups.values)
          GeniusErpPackReportRow(
            cells: {
              'salesperson': GeniusErpPackLocalizedValue(
                value: group.label,
                valueAr: group.labelAr,
              ),
              'sales': group.net.toDouble(),
              'commission': group.commission.toDouble(),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData priceList(
    List<GeniusSalesPriceEntry> prices,
  ) {
    return GeniusErpPackReportData(
      title: 'Price List',
      titleAr: 'قائمة الأسعار',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'code',
          title: 'Code',
          titleAr: 'الرمز',
        ),
        GeniusErpPackReportColumn(
          id: 'description',
          title: 'Description',
          titleAr: 'الوصف',
          flexFactor: 3,
        ),
        GeniusErpPackReportColumn(
          id: 'unit',
          title: 'Unit',
          titleAr: 'الوحدة',
        ),
        GeniusErpPackReportColumn(
          id: 'price',
          title: 'Price',
          titleAr: 'السعر',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'valid',
          title: 'Validity',
          titleAr: 'الصلاحية',
          flexFactor: 2,
        ),
      ],
      rows: [
        for (final price in prices)
          GeniusErpPackReportRow(
            cells: {
              'code': price.itemCode,
              'description': GeniusErpPackLocalizedValue(
                value: price.description,
                valueAr: price.descriptionAr,
              ),
              'unit': price.unit,
              'price': price.price.toDouble(),
              'valid': [
                if (price.validFrom != null)
                  price.validFrom!.toIso8601String().split('T').first,
                if (price.validTo != null)
                  price.validTo!.toIso8601String().split('T').first,
              ].join(' → '),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData backorders(
    List<GeniusSalesBackorderLine> lines,
  ) {
    final open = lines
        .where((line) => line.outstandingQuantity > 0)
        .toList(growable: false);

    return GeniusErpPackReportData(
      title: 'Backorders',
      titleAr: 'الطلبات المتأخرة',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'order',
          title: 'Order',
          titleAr: 'الطلب',
        ),
        GeniusErpPackReportColumn(
          id: 'customer',
          title: 'Customer',
          titleAr: 'العميل',
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
          id: 'fulfilled',
          title: 'Fulfilled',
          titleAr: 'المنفذ',
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
          titleAr: 'المتوقع',
        ),
      ],
      rows: [
        for (final line in open)
          GeniusErpPackReportRow(
            cells: {
              'order': line.orderNumber,
              'customer': GeniusErpPackLocalizedValue(
                value: line.customerName,
                valueAr: line.customerNameAr,
              ),
              'item': line.itemCode,
              'ordered': line.orderedQuantity,
              'fulfilled': line.fulfilledQuantity,
              'open': line.outstandingQuantity,
              'delivery': line.expectedDelivery
                      ?.toIso8601String()
                      .split('T')
                      .first ??
                  '',
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData customerAging(
    List<GeniusErpOpenItem> items, {
    required DateTime asOf,
  }) {
    final aging =
        const GeniusErpAgingService().calculate(items, asOf: asOf);

    return GeniusErpPackReportData(
      title: 'Customer Aging',
      titleAr: 'أعمار ديون العملاء',
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

  GeniusErpPackReportData _aggregateReport(
    Iterable<GeniusSalesLedgerEntry> entries, {
    required String title,
    required String titleAr,
    required String Function(GeniusSalesLedgerEntry) key,
    required String Function(GeniusSalesLedgerEntry) label,
    required String? Function(GeniusSalesLedgerEntry) labelAr,
  }) {
    final groups = <String, _SalesAggregate>{};

    for (final entry in entries) {
      final group = groups.putIfAbsent(
        key(entry),
        () => _SalesAggregate(
          label: label(entry),
          labelAr: labelAr(entry),
          currency: entry.netAmount.currency,
        ),
      );
      _requireCurrency(group.currency, entry.netAmount.currency);
      group.quantity += entry.quantity;
      group.net = group.net + entry.netAmount;
      group.tax = group.tax + entry.taxAmount;
      if (entry.costAmount != null) {
        group.cost = group.cost + entry.costAmount!;
      }
    }

    return GeniusErpPackReportData(
      title: title,
      titleAr: titleAr,
      columns: const [
        GeniusErpPackReportColumn(
          id: 'name',
          title: 'Name',
          titleAr: 'الاسم',
          flexFactor: 3,
        ),
        GeniusErpPackReportColumn(
          id: 'qty',
          title: 'Qty',
          titleAr: 'الكمية',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'net',
          title: 'Net Sales',
          titleAr: 'صافي المبيعات',
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
              'name': GeniusErpPackLocalizedValue(
                value: group.label,
                valueAr: group.labelAr,
              ),
              'qty': group.quantity,
              'net': group.net.toDouble(),
              'tax': group.tax.toDouble(),
            },
          ),
      ],
    );
  }

  void _requireCurrency(
    ErpCurrency expected,
    ErpCurrency actual,
  ) {
    if (expected != actual) {
      throw ArgumentError(
        'Sales analytics groups require one currency per report.',
      );
    }
  }
}
