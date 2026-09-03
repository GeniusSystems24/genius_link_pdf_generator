
/// Canonical S00 values. Treat edits to these values as baseline changes.
abstract final class S00FixtureData {
  static const subtotal = '13,650.00 SAR';
  static const vat = '2,047.50 SAR';
  static const grandTotal = '15,697.50 SAR';

  static const documentNumber = 'INV-2026-000123';
  static const sku = 'SKU-AR-ENG-001';
  static const serial = 'SN-AZ09-998877';
  static const iban = 'SA0380000000608010167519';
  static const phone = '+966 55 123 4567';
  static const email = 'accounts@example.test';
  static const url = 'https://erp.example.test/invoices/INV-2026-000123';

  static const longEnglish =
      'This intentionally long English baseline sentence verifies wrapping, '
      'page flow, mixed identifiers, and stable generation without changing '
      'production rendering behavior.';

  static const longArabic =
      'هذا نص عربي طويل مخصص لتثبيت خط الأساس والتحقق من الالتفاف وتدفق '
      'المحتوى عبر الصفحات مع الإبقاء على أرقام المستندات والمعرفات اللاتينية '
      'كما هي دون إجراء أي إصلاح لاتجاه المحتوى ضمن Sprint S00.';

  static const String? nullableValue = null;
  static const emptyValue = '';
}
