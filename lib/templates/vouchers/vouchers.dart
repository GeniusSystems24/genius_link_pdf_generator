/// Service Voucher Templates (v3.0.0+)
///
/// Comprehensive voucher system for financial document generation.
/// Supports bilingual Arabic/English output with 16+ voucher categories.
library;

// Models
export 'models/amount_to_words.dart';
export 'models/enums.dart';
export 'models/models.dart';
export 'models/style.dart';

// Base template
export 'docs/voucher_base.dart';
export 'docs/modern.dart';

// Financial voucher templates (v3.0.0)
export 'docs/accounting_entry.dart';
export 'docs/receipt.dart';
export 'docs/payment.dart';
export 'docs/tax.dart';

// Banking voucher templates (v3.1.0)
export 'docs/bank_deposit.dart';
export 'docs/bank_withdrawal.dart';
export 'docs/transfer.dart';
export 'docs/bill_payment.dart';

// Remittance voucher templates (v3.2.0)
export 'docs/remittance_outgoing.dart';
export 'docs/remittance_incoming.dart';

// Trade voucher templates (v3.3.0)
export 'docs/purchase.dart';
export 'docs/sales.dart';
export 'docs/purchase_return.dart';
export 'docs/sales_return.dart';

// Auxiliary voucher templates (v3.4.0)
export 'docs/gift.dart';
export 'docs/inventory.dart';

// Batch generation
export 'docs/voucher_batch.dart';
