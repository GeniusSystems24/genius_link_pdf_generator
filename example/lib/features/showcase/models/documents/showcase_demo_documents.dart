import 'dart:typed_data';

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';
import 'package:genius_pdf_example/features/showcase/models/documents/advanced_layout_demo_document.dart';
import 'package:genius_pdf_example/features/showcase/models/documents/auxiliary_voucher_demo_builder.dart';
import 'package:genius_pdf_example/features/showcase/models/documents/banking_voucher_demo_builder.dart';
import 'package:genius_pdf_example/features/showcase/models/documents/complete_voucher_demo_builder.dart';
import 'package:genius_pdf_example/features/showcase/models/documents/multi_grid_summary_demo_document.dart';
import 'package:genius_pdf_example/features/showcase/models/documents/position_tracking_demo_document.dart';
import 'package:genius_pdf_example/features/showcase/models/documents/qr_attachments_demo_document.dart';
import 'package:genius_pdf_example/features/showcase/models/documents/remittance_voucher_demo_builder.dart';
import 'package:genius_pdf_example/features/showcase/models/documents/report_composer_demo_document.dart';
import 'package:genius_pdf_example/features/showcase/models/documents/trade_voucher_demo_builder.dart';
import 'package:genius_pdf_example/features/showcase/models/documents/voucher_demo_builder.dart';

/// Generates bytes for one focused Showcase example.
///
/// This dispatcher never opens or saves a file. Presentation code can therefore
/// show the generated document in `GeniusPdfPreviewWidget` first.
Future<Uint8List> buildShowcaseDemoBytes({
  required String showcaseId,
  required GeniusPdfConfig config,
}) async {
  switch (showcaseId) {
    case 'showcase_advanced_layout':
      final builder = AdvancedLayoutDemoBuilder(config: config);
      try {
        return Uint8List.fromList(builder.generate());
      } finally {
        builder.dispose();
      }
    case 'showcase_position_tracking':
      final builder = PositionTrackingDemoBuilder(config: config);
      try {
        return Uint8List.fromList(builder.generate());
      } finally {
        builder.dispose();
      }
    case 'showcase_multi_grid_summary':
      final builder = MultiGridSummaryDemoBuilder(config: config);
      try {
        return Uint8List.fromList(builder.generate());
      } finally {
        builder.dispose();
      }
    case 'showcase_qr_attachments':
      final builder = QRAttachmentsDemoBuilder(config: config);
      try {
        return Uint8List.fromList(builder.generate());
      } finally {
        builder.dispose();
      }
    case 'showcase_report_composer':
      return Uint8List.fromList(
        buildComposerDemoReport(config: config),
      );
    case 'showcase_service_vouchers':
      return Uint8List.fromList(
        buildVoucherDemoReport(config: config),
      );
    case 'showcase_banking_vouchers':
      return Uint8List.fromList(
        buildBankingVoucherDemoReport(config: config),
      );
    case 'showcase_remittance_vouchers':
      return Uint8List.fromList(
        buildRemittanceVoucherDemoReport(config: config),
      );
    case 'showcase_trade_vouchers':
      return Uint8List.fromList(
        buildTradeVoucherDemoReport(config: config),
      );
    case 'showcase_auxiliary_vouchers':
      return Uint8List.fromList(
        buildAuxiliaryVoucherDemoReport(config: config),
      );
    case 'showcase_complete_demo':
      return Uint8List.fromList(
        buildCompleteVoucherDemoReport(config: config),
      );
    default:
      throw ArgumentError.value(
        showcaseId,
        'showcaseId',
        'Unsupported Showcase example',
      );
  }
}
