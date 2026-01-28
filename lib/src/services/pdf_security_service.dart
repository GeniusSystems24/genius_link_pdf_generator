import 'dart:typed_data';
import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart' hide PdfPermissions;

import '../components/models/security_models.dart';

/// خدمة أمان PDF
/// PDF Security Service for encryption, permissions, and digital signatures
class GeniusPdfSecurityService {
  /// تطبيق إعدادات الأمان على المستند
  /// Apply security settings to a document
  static void applySecurity(PdfDocument document, GeniusPdfSecuritySettings settings) {
    if (!settings.isEncrypted) return;

    final security = document.security;

    // Set encryption algorithm
    switch (settings.encryptionLevel) {
      case GeniusPdfEncryptionLevel.bit40:
        security.algorithm = PdfEncryptionAlgorithm.rc4x40Bit;
        break;
      case GeniusPdfEncryptionLevel.bit128:
        security.algorithm = PdfEncryptionAlgorithm.rc4x128Bit;
        break;
      case GeniusPdfEncryptionLevel.aes256:
        security.algorithm = PdfEncryptionAlgorithm.aesx256Bit;
        break;
    }

    // Set passwords
    if (settings.userPassword != null) {
      security.userPassword = settings.userPassword!;
    }
    if (settings.ownerPassword != null) {
      security.ownerPassword = settings.ownerPassword!;
    }

    // Set permissions
    _applyPermissions(security, settings.permissions);

    // ملاحظة: encryptMetadata غير مدعومة مباشرة في واجهة PdfSecurity
    // التشفير يتم تطبيقه تلقائياً عند تعيين كلمات المرور
  }

  /// تطبيق الصلاحيات
  static void _applyPermissions(PdfSecurity security, GeniusPdfPermissions permissions) {
    // Build permissions list
    final List<PdfPermissionsFlags> flags = [];

    if (permissions.allowPrinting) {
      flags.add(PdfPermissionsFlags.print);
    }
    if (permissions.allowCopying) {
      flags.add(PdfPermissionsFlags.copyContent);
    }
    if (permissions.allowModifying) {
      flags.add(PdfPermissionsFlags.editContent);
    }
    if (permissions.allowAnnotations) {
      flags.add(PdfPermissionsFlags.editAnnotations);
    }
    if (permissions.allowFormFilling) {
      flags.add(PdfPermissionsFlags.fillFields);
    }
    if (permissions.allowAccessibility) {
      flags.add(PdfPermissionsFlags.accessibilityCopyContent);
    }
    if (permissions.allowAssembling) {
      flags.add(PdfPermissionsFlags.assembleDocument);
    }
    if (permissions.allowHighQualityPrinting) {
      flags.add(PdfPermissionsFlags.fullQualityPrint);
    }

    // إضافة الصلاحيات باستخدام addAll
    if (flags.isNotEmpty) {
      security.permissions.addAll(flags);
    }
  }

  /// حماية المستند بكلمة مرور
  /// Protect document with password
  static void protectWithPassword(
    PdfDocument document, {
    required String password,
    GeniusPdfPermissions permissions = const GeniusPdfPermissions(),
    GeniusPdfEncryptionLevel encryptionLevel = GeniusPdfEncryptionLevel.aes256,
  }) {
    applySecurity(
      document,
      GeniusPdfSecuritySettings(
        userPassword: password,
        ownerPassword: password,
        permissions: permissions,
        encryptionLevel: encryptionLevel,
      ),
    );
  }

  /// حماية المستند للقراءة فقط
  /// Protect document as read-only
  static void protectReadOnly(
    PdfDocument document, {
    String? userPassword,
    required String ownerPassword,
  }) {
    applySecurity(
      document,
      GeniusPdfSecuritySettings.readOnly(
        userPassword: userPassword,
        ownerPassword: ownerPassword,
      ),
    );
  }

  /// حماية المستند للطباعة فقط
  /// Protect document for print only
  static void protectPrintOnly(
    PdfDocument document, {
    String? userPassword,
    required String ownerPassword,
  }) {
    applySecurity(
      document,
      GeniusPdfSecuritySettings.printOnly(
        userPassword: userPassword,
        ownerPassword: ownerPassword,
      ),
    );
  }

  /// إزالة الحماية من المستند
  /// Remove protection from document (requires owner password)
  static PdfDocument? removeProtection(
    Uint8List documentBytes, {
    required String ownerPassword,
  }) {
    try {
      final document = PdfDocument(inputBytes: documentBytes, password: ownerPassword);

      // Create new unprotected document
      final newDocument = PdfDocument();

      // Copy pages
      for (int i = 0; i < document.pages.count; i++) {
        final template = document.pages[i].createTemplate();
        final newPage = newDocument.pages.add();
        newPage.graphics.drawPdfTemplate(template, Offset.zero);
      }

      document.dispose();
      return newDocument;
    } catch (e) {
      return null;
    }
  }

  /// التحقق من حماية المستند
  /// Check if document is protected
  static bool isProtected(Uint8List documentBytes) {
    try {
      final document = PdfDocument(inputBytes: documentBytes);
      final isEncrypted = document.security.userPassword.isNotEmpty ||
          document.security.ownerPassword.isNotEmpty;
      document.dispose();
      return isEncrypted;
    } catch (e) {
      // If we can't open without password, it's protected
      return true;
    }
  }

  /// فتح مستند محمي
  /// Open protected document
  static PdfDocument? openProtected(
    Uint8List documentBytes, {
    required String password,
  }) {
    try {
      return PdfDocument(inputBytes: documentBytes, password: password);
    } catch (e) {
      return null;
    }
  }

  /// تغيير كلمة المرور
  /// Change password
  static Uint8List? changePassword(
    Uint8List documentBytes, {
    required String oldPassword,
    required String newPassword,
  }) {
    try {
      final document = PdfDocument(inputBytes: documentBytes, password: oldPassword);

      // Update passwords
      document.security.userPassword = newPassword;
      document.security.ownerPassword = newPassword;

      final bytes = document.saveSync();
      document.dispose();
      return Uint8List.fromList(bytes);
    } catch (e) {
      return null;
    }
  }
}

/// امتداد لإضافة الأمان للمستند
/// Extension to add security to document
extension PdfDocumentSecurityExtension on PdfDocument {
  /// تطبيق إعدادات الأمان
  void applySecurity(GeniusPdfSecuritySettings settings) {
    GeniusPdfSecurityService.applySecurity(this, settings);
  }

  /// حماية بكلمة مرور
  void protectWithPassword({
    required String password,
    GeniusPdfPermissions permissions = const GeniusPdfPermissions(),
  }) {
    GeniusPdfSecurityService.protectWithPassword(
      this,
      password: password,
      permissions: permissions,
    );
  }

  /// حماية للقراءة فقط
  void protectReadOnly({
    String? userPassword,
    required String ownerPassword,
  }) {
    GeniusPdfSecurityService.protectReadOnly(
      this,
      userPassword: userPassword,
      ownerPassword: ownerPassword,
    );
  }

  /// حماية للطباعة فقط
  void protectPrintOnly({
    String? userPassword,
    required String ownerPassword,
  }) {
    GeniusPdfSecurityService.protectPrintOnly(
      this,
      userPassword: userPassword,
      ownerPassword: ownerPassword,
    );
  }
}
