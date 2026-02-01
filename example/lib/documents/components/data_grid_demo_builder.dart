import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds a Data Grid demo PDF document with extended details.
class DataGridDemoBuilder extends GeniusPdfDocumentBuilder {
  DataGridDemoBuilder(super.config);

  @override
  void build() {
    newPage();

    // Title using builder method
    addSectionDivider(
      title: config.isRTL
          ? 'جدول البيانات - GeniusPdfDataGrid'
          : 'Data Grid - GeniusPdfDataGrid',
      spacing: 10,
    );

    // Subtitle using addLine
    addLine(
      config.isRTL
          ? 'مثال عملي على جدول فواتير مع إجمالي، وملاحظات، ومراجعة تلقائية.'
          : 'Practical invoice table with totals, notes, and validation hints.',
      topMargin: 5,
    );

    addSpace(15);

    // Data Grid using builder method
    addGrid(
      GeniusPdfDataGrid(
        config: config,
        columns: [
          GeniusPdfGridColumn(
            id: 'code',
            title: 'Code',
            titleAr: 'الكود',
            width: 60,
          ),
          GeniusPdfGridColumn(
            id: 'desc',
            title: 'Description',
            titleAr: 'الوصف',
            flexFactor: 2,
          ),
          GeniusPdfGridColumn.numeric(
            id: 'qty',
            title: 'Qty',
            titleAr: 'الكمية',
          ),
          GeniusPdfGridColumn.currency(
            id: 'price',
            title: 'Price',
            titleAr: 'السعر',
            currencySymbol: config.isRTL ? 'ر.س' : 'SAR',
          ),
          GeniusPdfGridColumn.currency(
            id: 'total',
            title: 'Total',
            titleAr: 'الإجمالي',
            currencySymbol: config.isRTL ? 'ر.س' : 'SAR',
          ),
        ],
        rows: [
          GeniusPdfGridRow(cells: {
            'code': '001',
            'desc': config.isRTL ? 'منتج أول' : 'First Product',
            'qty': '10',
            'price': '100.00',
            'total': '1,000.00',
          }),
          GeniusPdfGridRow(cells: {
            'code': '002',
            'desc': config.isRTL ? 'منتج ثاني' : 'Second Product',
            'qty': '5',
            'price': '200.00',
            'total': '1,000.00',
          }),
          GeniusPdfGridRow(cells: {
            'code': '003',
            'desc': config.isRTL ? 'منتج ثالث' : 'Third Product',
            'qty': '8',
            'price': '150.00',
            'total': '1,200.00',
          }),
          GeniusPdfGridRow(cells: {
            'code': '004',
            'desc': config.isRTL ? 'خدمة استشارية' : 'Consulting Service',
            'qty': '3',
            'price': '500.00',
            'total': '1,500.00',
          }),
          GeniusPdfGridRow(cells: {
            'code': '005',
            'desc': config.isRTL ? 'دعم فني' : 'Support Package',
            'qty': '1',
            'price': '900.00',
            'total': '900.00',
          }),
          GeniusPdfGridRow.total({
            'desc': config.isRTL ? 'الإجمالي قبل الضريبة' : 'Subtotal',
            'total': '5,600.00',
          }),
        ],
        style: GeniusPdfGridStyle.corporate(),
      ),
      spacing: 15,
    );

    addSpace(20);

    // Info box using builder method
    addInfoBox(
      GeniusPdfInfoBox(
        config: config,
        title: config.isRTL ? 'ملاحظة' : 'Note',
        titleAr: 'ملاحظة',
        items: [
          GeniusPdfLabeledValue(
            config: config,
            label: config.isRTL ? 'المراجعة' : 'Validation',
            labelAr: 'المراجعة',
            value: config.isRTL
                ? 'تم التحقق من الأسعار والكميات تلقائياً.'
                : 'Prices and quantities validated automatically.',
          ),
        ],
        style: GeniusPdfInfoBoxStyle.info(),
      ),
      spacing: 10,
    );
  }
}
