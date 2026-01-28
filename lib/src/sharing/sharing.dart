/// Sharing module for genius_link_pdf_generator.
///
/// Provides unified sharing capabilities for PDF documents including:
/// - System share sheet integration
/// - Email sharing (v2.3.1)
/// - Bluetooth sharing (v2.3.2)
/// - App-specific sharing (v2.3.3)
/// - Cloud storage integration (v2.4.0)
/// - Local file storage
///
/// Basic usage:
/// ```dart
/// import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';
///
/// // Share via system share sheet
/// final result = await GeniusShareService.instance.share(
///   pdfBytes: pdfBytes,
///   fileName: 'document.pdf',
///   target: GeniusShareTarget.system(),
/// );
///
/// // Share via email
/// final emailResult = await GeniusShareService.instance.share(
///   pdfBytes: pdfBytes,
///   fileName: 'report.pdf',
///   target: GeniusShareTarget.email(
///     toAddress: 'client@example.com',
///     subject: 'Monthly Report',
///   ),
/// );
///
/// // Quick share to saved contact
/// final quickResult = await GeniusShareService.instance.quickShare(
///   pdfBytes: pdfBytes,
///   fileName: 'invoice.pdf',
///   contact: myFavoriteContact,
/// );
/// ```
library;

export 'share_models.dart';
export 'share_service.dart';
export 'email_share_service.dart';
export 'bluetooth_share_service.dart';
export 'app_share_service.dart';
