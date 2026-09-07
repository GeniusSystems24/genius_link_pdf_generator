import 'dart:ui';

/// نوع العلامة المائية
/// Watermark type
enum GeniusWatermarkType {
  /// نص بسيط
  text,

  /// صورة
  image,

  /// نص قطري
  diagonal,

  /// نمط متكرر
  tiled,
}

/// موقع العلامة المائية
/// Watermark position
enum GeniusWatermarkPosition {
  /// المركز
  center,

  /// أعلى اليسار
  topLeft,

  /// أعلى اليمين
  topRight,

  /// أسفل اليسار
  bottomLeft,

  /// أسفل اليمين
  bottomRight,

  /// أعلى المنتصف
  topCenter,

  /// أسفل المنتصف
  bottomCenter,

  /// يسار المنتصف
  centerLeft,

  /// يمين المنتصف
  centerRight,

  /// تغطية كاملة (للعلامات المتكررة)
  fill,
}

/// طبقة العلامة المائية
/// Watermark layer
enum GeniusWatermarkLayer {
  /// خلف المحتوى
  background,

  /// فوق المحتوى
  foreground,
}

/// إعدادات العلامة المائية الأساسية
/// Base watermark settings
abstract class GeniusWatermarkSettings {

  const GeniusWatermarkSettings({
    this.opacity = 0.3,
    this.rotation = 0,
    this.position = GeniusWatermarkPosition.center,
    this.layer = GeniusWatermarkLayer.background,
    this.applyToAllPages = true,
    this.pageNumbers,
  });
  /// نوع العلامة المائية
  GeniusWatermarkType get type;

  /// الشفافية (0.0 - 1.0)
  final double opacity;

  /// زاوية الدوران (بالدرجات)
  final double rotation;

  /// الموقع
  final GeniusWatermarkPosition position;

  /// الطبقة
  final GeniusWatermarkLayer layer;

  /// تطبيق على جميع الصفحات
  final bool applyToAllPages;

  /// أرقام الصفحات المحددة (إذا لم يكن applyToAllPages)
  final List<int>? pageNumbers;
}

/// إعدادات العلامة المائية النصية
/// Text watermark settings
class GeniusTextWatermarkSettings extends GeniusWatermarkSettings {

  const GeniusTextWatermarkSettings({
    required this.text,
    this.fontSize = 48,
    this.color = const Color(0xFF808080),
    this.isBold = false,
    this.isItalic = false,
    this.fontFamily,
    super.opacity = 0.3,
    super.rotation = -45,
    super.position = GeniusWatermarkPosition.center,
    super.layer = GeniusWatermarkLayer.background,
    super.applyToAllPages = true,
    super.pageNumbers,
  });

  /// علامة "سري"
  factory GeniusTextWatermarkSettings.confidential({
    String text = 'CONFIDENTIAL',
    double opacity = 0.2,
  }) =>
      GeniusTextWatermarkSettings(
        text: text,
        fontSize: 60,
        color: const Color(0xFFFF0000),
        isBold: true,
        opacity: opacity,
        rotation: -45,
      );

  /// علامة "مسودة"
  factory GeniusTextWatermarkSettings.draft({
    String text = 'DRAFT',
    double opacity = 0.2,
  }) =>
      GeniusTextWatermarkSettings(
        text: text,
        fontSize: 72,
        color: const Color(0xFF808080),
        isBold: true,
        opacity: opacity,
        rotation: -45,
      );

  /// علامة "نسخة"
  factory GeniusTextWatermarkSettings.copy({
    String text = 'COPY',
    double opacity = 0.2,
  }) =>
      GeniusTextWatermarkSettings(
        text: text,
        fontSize: 60,
        color: const Color(0xFF0000FF),
        isBold: true,
        opacity: opacity,
        rotation: -45,
      );

  /// علامة "ملغي"
  factory GeniusTextWatermarkSettings.cancelled({
    String text = 'CANCELLED',
    double opacity = 0.3,
  }) =>
      GeniusTextWatermarkSettings(
        text: text,
        fontSize: 56,
        color: const Color(0xFFFF0000),
        isBold: true,
        opacity: opacity,
        rotation: -30,
      );

  /// علامة مخصصة
  factory GeniusTextWatermarkSettings.custom({
    required String text,
    double fontSize = 48,
    Color color = const Color(0xFF808080),
    double opacity = 0.3,
    double rotation = -45,
  }) =>
      GeniusTextWatermarkSettings(
        text: text,
        fontSize: fontSize,
        color: color,
        opacity: opacity,
        rotation: rotation,
      );
  @override
  GeniusWatermarkType get type => GeniusWatermarkType.text;

  /// النص
  final String text;

  /// حجم الخط
  final double fontSize;

  /// لون النص
  final Color color;

  /// خط عريض
  final bool isBold;

  /// خط مائل
  final bool isItalic;

  /// اسم الخط
  final String? fontFamily;
}

/// إعدادات العلامة المائية بالصورة
/// Image watermark settings
class GeniusImageWatermarkSettings extends GeniusWatermarkSettings {

  const GeniusImageWatermarkSettings({
    required this.imageBytes,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    super.opacity = 0.3,
    super.rotation = 0,
    super.position = GeniusWatermarkPosition.center,
    super.layer = GeniusWatermarkLayer.background,
    super.applyToAllPages = true,
    super.pageNumbers,
  });
  @override
  GeniusWatermarkType get type => GeniusWatermarkType.image;

  /// بيانات الصورة
  final List<int> imageBytes;

  /// العرض (null للحجم الأصلي)
  final double? width;

  /// الارتفاع (null للحجم الأصلي)
  final double? height;

  /// الحفاظ على نسبة العرض للارتفاع
  final bool maintainAspectRatio;
}

/// إعدادات العلامة المائية القطرية
/// Diagonal watermark settings
class GeniusDiagonalWatermarkSettings extends GeniusWatermarkSettings {

  const GeniusDiagonalWatermarkSettings({
    required this.text,
    this.fontSize = 48,
    this.color = const Color(0xFF808080),
    this.isBold = true,
    this.topLeftToBottomRight = true,
    super.opacity = 0.2,
    super.layer = GeniusWatermarkLayer.background,
    super.applyToAllPages = true,
    super.pageNumbers,
  }) : super(
          rotation: topLeftToBottomRight ? -45 : 45,
          position: GeniusWatermarkPosition.center,
        );
  @override
  GeniusWatermarkType get type => GeniusWatermarkType.diagonal;

  /// النص
  final String text;

  /// حجم الخط
  final double fontSize;

  /// لون النص
  final Color color;

  /// خط عريض
  final bool isBold;

  /// من أعلى اليسار إلى أسفل اليمين
  final bool topLeftToBottomRight;
}

/// إعدادات العلامة المائية المتكررة
/// Tiled watermark settings
class GeniusTiledWatermarkSettings extends GeniusWatermarkSettings {

  const GeniusTiledWatermarkSettings({
    required this.text,
    this.fontSize = 24,
    this.color = const Color(0xFF808080),
    this.isBold = false,
    this.horizontalSpacing = 100,
    this.verticalSpacing = 80,
    super.opacity = 0.15,
    super.rotation = -30,
    super.layer = GeniusWatermarkLayer.background,
    super.applyToAllPages = true,
    super.pageNumbers,
  }) : super(position: GeniusWatermarkPosition.fill);

  /// نمط كثيف
  factory GeniusTiledWatermarkSettings.dense({
    required String text,
    double fontSize = 18,
    Color color = const Color(0xFF808080),
    double opacity = 0.1,
  }) =>
      GeniusTiledWatermarkSettings(
        text: text,
        fontSize: fontSize,
        color: color,
        opacity: opacity,
        horizontalSpacing: 60,
        verticalSpacing: 50,
      );

  /// نمط متفرق
  factory GeniusTiledWatermarkSettings.sparse({
    required String text,
    double fontSize = 32,
    Color color = const Color(0xFF808080),
    double opacity = 0.2,
  }) =>
      GeniusTiledWatermarkSettings(
        text: text,
        fontSize: fontSize,
        color: color,
        opacity: opacity,
        horizontalSpacing: 150,
        verticalSpacing: 120,
      );
  @override
  GeniusWatermarkType get type => GeniusWatermarkType.tiled;

  /// النص
  final String text;

  /// حجم الخط
  final double fontSize;

  /// لون النص
  final Color color;

  /// خط عريض
  final bool isBold;

  /// المسافة الأفقية بين التكرارات
  final double horizontalSpacing;

  /// المسافة الرأسية بين التكرارات
  final double verticalSpacing;
}

/// صلاحيات PDF
/// PDF permissions
class GeniusPdfPermissions {

  const GeniusPdfPermissions({
    this.allowPrinting = true,
    this.allowHighQualityPrinting = true,
    this.allowCopying = true,
    this.allowModifying = true,
    this.allowAnnotations = true,
    this.allowFormFilling = true,
    this.allowAssembling = true,
    this.allowAccessibility = true,
  });

  /// جميع الصلاحيات
  factory GeniusPdfPermissions.all() => const GeniusPdfPermissions();

  /// لا صلاحيات
  factory GeniusPdfPermissions.none() => const GeniusPdfPermissions(
        allowPrinting: false,
        allowHighQualityPrinting: false,
        allowCopying: false,
        allowModifying: false,
        allowAnnotations: false,
        allowFormFilling: false,
        allowAssembling: false,
        allowAccessibility: false,
      );

  /// للقراءة فقط
  factory GeniusPdfPermissions.readOnly() => const GeniusPdfPermissions(
        allowPrinting: true,
        allowHighQualityPrinting: true,
        allowCopying: false,
        allowModifying: false,
        allowAnnotations: false,
        allowFormFilling: false,
        allowAssembling: false,
        allowAccessibility: true,
      );

  /// للطباعة فقط
  factory GeniusPdfPermissions.printOnly() => const GeniusPdfPermissions(
        allowPrinting: true,
        allowHighQualityPrinting: true,
        allowCopying: false,
        allowModifying: false,
        allowAnnotations: false,
        allowFormFilling: false,
        allowAssembling: false,
        allowAccessibility: true,
      );

  /// للتعبئة فقط
  factory GeniusPdfPermissions.fillFormsOnly() => const GeniusPdfPermissions(
        allowPrinting: true,
        allowHighQualityPrinting: true,
        allowCopying: false,
        allowModifying: false,
        allowAnnotations: false,
        allowFormFilling: true,
        allowAssembling: false,
        allowAccessibility: true,
      );

  /// للتعليق فقط
  factory GeniusPdfPermissions.annotateOnly() => const GeniusPdfPermissions(
        allowPrinting: true,
        allowHighQualityPrinting: true,
        allowCopying: false,
        allowModifying: false,
        allowAnnotations: true,
        allowFormFilling: true,
        allowAssembling: false,
        allowAccessibility: true,
      );
  /// السماح بالطباعة
  final bool allowPrinting;

  /// السماح بالطباعة عالية الجودة
  final bool allowHighQualityPrinting;

  /// السماح بالنسخ
  final bool allowCopying;

  /// السماح بالتعديل
  final bool allowModifying;

  /// السماح بإضافة تعليقات
  final bool allowAnnotations;

  /// السماح بتعبئة النماذج
  final bool allowFormFilling;

  /// السماح بإعادة ترتيب الصفحات
  final bool allowAssembling;

  /// السماح باستخراج المحتوى لإمكانية الوصول
  final bool allowAccessibility;
}

/// مستوى التشفير
/// Encryption level
enum GeniusPdfEncryptionLevel {
  /// تشفير 40-bit (RC4)
  bit40,

  /// تشفير 128-bit (RC4)
  bit128,

  /// تشفير 256-bit (AES)
  aes256,
}

/// إعدادات أمان PDF
/// PDF security settings
class GeniusPdfSecuritySettings {

  const GeniusPdfSecuritySettings({
    this.userPassword,
    this.ownerPassword,
    this.encryptionLevel = GeniusPdfEncryptionLevel.aes256,
    this.permissions = const GeniusPdfPermissions(),
    this.encryptMetadata = true,
  });

  /// حماية بكلمة مرور بسيطة
  factory GeniusPdfSecuritySettings.passwordProtected({
    required String password,
    GeniusPdfPermissions permissions = const GeniusPdfPermissions(),
  }) =>
      GeniusPdfSecuritySettings(
        userPassword: password,
        ownerPassword: password,
        permissions: permissions,
      );

  /// حماية للقراءة فقط
  factory GeniusPdfSecuritySettings.readOnly({
    String? userPassword,
    required String ownerPassword,
  }) =>
      GeniusPdfSecuritySettings(
        userPassword: userPassword,
        ownerPassword: ownerPassword,
        permissions: GeniusPdfPermissions.readOnly(),
      );

  /// حماية كاملة
  factory GeniusPdfSecuritySettings.fullProtection({
    required String userPassword,
    required String ownerPassword,
  }) =>
      GeniusPdfSecuritySettings(
        userPassword: userPassword,
        ownerPassword: ownerPassword,
        permissions: GeniusPdfPermissions.none(),
        encryptionLevel: GeniusPdfEncryptionLevel.aes256,
      );

  /// للطباعة فقط
  factory GeniusPdfSecuritySettings.printOnly({
    String? userPassword,
    required String ownerPassword,
  }) =>
      GeniusPdfSecuritySettings(
        userPassword: userPassword,
        ownerPassword: ownerPassword,
        permissions: GeniusPdfPermissions.printOnly(),
      );
  /// كلمة مرور المستخدم (للفتح)
  final String? userPassword;

  /// كلمة مرور المالك (للتعديل)
  final String? ownerPassword;

  /// مستوى التشفير
  final GeniusPdfEncryptionLevel encryptionLevel;

  /// الصلاحيات
  final GeniusPdfPermissions permissions;

  /// تشفير البيانات الوصفية
  final bool encryptMetadata;

  /// هل التشفير مفعل
  bool get isEncrypted => userPassword != null || ownerPassword != null;
}

/// نوع التوقيع الرقمي
/// Digital signature type
enum GeniusSignatureType {
  /// توقيع موافقة
  approval,

  /// توقيع شهادة
  certified,
}

/// مظهر التوقيع
/// Signature appearance
class GeniusSignatureAppearance {

  const GeniusSignatureAppearance({
    this.showName = true,
    this.showDate = true,
    this.showReason = true,
    this.showLocation = true,
    this.showImage = false,
    this.signatureImage,
    this.backgroundColor = const Color(0xFFFFFFF0),
    this.textColor = const Color(0xFF000000),
    this.borderColor = const Color(0xFF000080),
    this.borderWidth = 1,
  });
  /// إظهار الاسم
  final bool showName;

  /// إظهار التاريخ
  final bool showDate;

  /// إظهار السبب
  final bool showReason;

  /// إظهار الموقع
  final bool showLocation;

  /// إظهار صورة التوقيع
  final bool showImage;

  /// صورة التوقيع
  final List<int>? signatureImage;

  /// لون الخلفية
  final Color backgroundColor;

  /// لون النص
  final Color textColor;

  /// لون الحدود
  final Color borderColor;

  /// عرض الحدود
  final double borderWidth;
}

/// إعدادات التوقيع الرقمي
/// Digital signature settings
class GeniusDigitalSignatureSettings {

  const GeniusDigitalSignatureSettings({
    required this.signerName,
    this.reason,
    this.location,
    this.contactInfo,
    this.type = GeniusSignatureType.approval,
    this.certificateBytes,
    this.certificatePassword,
    this.addTimestamp = false,
    this.timestampServerUrl,
    this.appearance = const GeniusSignatureAppearance(),
    this.bounds,
    this.pageNumber = 0,
  });
  /// اسم الموقع
  final String signerName;

  /// سبب التوقيع
  final String? reason;

  /// موقع التوقيع
  final String? location;

  /// معلومات الاتصال
  final String? contactInfo;

  /// نوع التوقيع
  final GeniusSignatureType type;

  /// بيانات الشهادة (PKCS#12)
  final List<int>? certificateBytes;

  /// كلمة مرور الشهادة
  final String? certificatePassword;

  /// إضافة ختم الوقت
  final bool addTimestamp;

  /// عنوان خادم الختم الزمني
  final String? timestampServerUrl;

  /// مظهر التوقيع
  final GeniusSignatureAppearance appearance;

  /// موقع التوقيع في الصفحة
  final Rect? bounds;

  /// رقم الصفحة
  final int pageNumber;
}
