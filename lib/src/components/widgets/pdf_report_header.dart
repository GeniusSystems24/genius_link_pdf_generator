import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart'
    hide PdfTextStyle, PdfBorderStyle;

import '../../extensions/color_extensions.dart';
import '../../models/pdf_image.dart';
import '../models/pdf_styles.dart';

/// Company information for report headers.
///
/// Comprehensive company data structure supporting:
/// - Bilingual names and addresses
/// - Contact information
/// - Legal/tax identifiers
/// - Logo with positioning
/// - Social media links
///
/// ## Example
/// ```dart
/// GeniusPdfCompanyInfo(
///   name: 'Integrated Solutions Co.',
///   nameAr: 'شركة الحلول المتكاملة',
///   address: '123 Business Street, Riyadh',
///   addressAr: '123 شارع الأعمال، الرياض',
///   phone: '+966 11 123 4567',
///   vatNumber: '300000000000003',
///   logo: companyLogo,
/// )
/// ```
class GeniusPdfCompanyInfo {
  const GeniusPdfCompanyInfo({
    required this.name,
    this.nameAr,
    this.address,
    this.addressAr,
    this.addressLine2,
    this.addressLine2Ar,
    this.city,
    this.cityAr,
    this.state,
    this.postalCode,
    this.country,
    this.countryAr,
    this.phone,
    this.phone2,
    this.fax,
    this.email,
    this.email2,
    this.vatNumber,
    this.crNumber,
    this.licenseNumber,
    this.logo,
    this.secondaryLogo,
    this.website,
    this.slogan,
    this.sloganAr,
    this.socialMedia,
  });

  /// Creates company info from a map.
  factory GeniusPdfCompanyInfo.fromMap(Map<String, dynamic> data) {
    return GeniusPdfCompanyInfo(
      name: data['name'] ?? '',
      nameAr: data['nameAr'],
      address: data['address'],
      addressAr: data['addressAr'],
      addressLine2: data['addressLine2'],
      addressLine2Ar: data['addressLine2Ar'],
      city: data['city'],
      cityAr: data['cityAr'],
      state: data['state'],
      postalCode: data['postalCode'],
      country: data['country'],
      countryAr: data['countryAr'],
      phone: data['phone'],
      phone2: data['phone2'],
      fax: data['fax'],
      email: data['email'],
      email2: data['email2'],
      vatNumber: data['vatNumber'],
      crNumber: data['crNumber'],
      licenseNumber: data['licenseNumber'],
      website: data['website'],
      slogan: data['slogan'],
      sloganAr: data['sloganAr'],
    );
  }

  /// Company name (English or default).
  final String name;

  /// Arabic company name.
  final String? nameAr;

  /// Primary address (English).
  final String? address;

  /// Primary address (Arabic).
  final String? addressAr;

  /// Secondary address line.
  final String? addressLine2;

  /// Secondary address line (Arabic).
  final String? addressLine2Ar;

  /// City name.
  final String? city;

  /// City name (Arabic).
  final String? cityAr;

  /// State/Province.
  final String? state;

  /// Postal/ZIP code.
  final String? postalCode;

  /// Country name.
  final String? country;

  /// Country name (Arabic).
  final String? countryAr;

  /// Primary phone number.
  final String? phone;

  /// Secondary phone number.
  final String? phone2;

  /// Fax number.
  final String? fax;

  /// Primary email address.
  final String? email;

  /// Secondary email address.
  final String? email2;

  /// VAT/Tax registration number.
  final String? vatNumber;

  /// Commercial registration number.
  final String? crNumber;

  /// Business license number.
  final String? licenseNumber;

  /// Company logo image.
  final GeniusPdfImage? logo;

  /// Secondary logo (e.g., certification badge).
  final GeniusPdfImage? secondaryLogo;

  /// Company website URL.
  final String? website;

  /// Company slogan/tagline.
  final String? slogan;

  /// Company slogan (Arabic).
  final String? sloganAr;

  /// Social media links map (platform -> url).
  final Map<String, String>? socialMedia;

  /// Gets the display name based on locale.
  String getName({bool isArabic = false}) {
    if (isArabic && nameAr != null) return nameAr!;
    return name;
  }

  /// Gets bilingual name (English and Arabic).
  (String, String?) getBilingualName() => (name, nameAr);

  /// Gets the display address based on locale.
  String? getAddress({bool isArabic = false}) {
    if (isArabic && addressAr != null) return addressAr;
    return address;
  }

  /// Gets the full formatted address based on locale.
  String? getFullAddress({bool isArabic = false}) {
    final parts = <String>[];

    final line1 = getAddress(isArabic: isArabic);
    if (line1 != null && line1.isNotEmpty) parts.add(line1);

    final line2 = isArabic ? (addressLine2Ar ?? addressLine2) : addressLine2;
    if (line2 != null && line2.isNotEmpty) parts.add(line2);

    final cityPart = isArabic ? (cityAr ?? city) : city;
    final locationParts = <String>[];
    if (cityPart != null && cityPart.isNotEmpty) locationParts.add(cityPart);
    if (state != null && state!.isNotEmpty) locationParts.add(state!);
    if (postalCode != null && postalCode!.isNotEmpty) {
      locationParts.add(postalCode!);
    }
    if (locationParts.isNotEmpty) parts.add(locationParts.join(', '));

    final countryPart = isArabic ? (countryAr ?? country) : country;
    if (countryPart != null && countryPart.isNotEmpty) parts.add(countryPart);

    return parts.isNotEmpty ? parts.join('\n') : null;
  }

  /// Gets the slogan based on locale.
  String? getSlogan({bool isArabic = false}) {
    if (isArabic && sloganAr != null) return sloganAr;
    return slogan;
  }

  /// Gets formatted contact info.
  List<(String label, String value)> getContactInfo({bool isArabic = false}) {
    final contacts = <(String label, String value)>[];

    if (phone != null && phone!.isNotEmpty) {
      contacts.add((isArabic ? 'الهاتف' : 'Phone', phone!));
    }
    if (phone2 != null && phone2!.isNotEmpty) {
      contacts.add((isArabic ? 'الهاتف 2' : 'Phone 2', phone2!));
    }
    if (fax != null && fax!.isNotEmpty) {
      contacts.add((isArabic ? 'الفاكس' : 'Fax', fax!));
    }
    if (email != null && email!.isNotEmpty) {
      contacts.add((isArabic ? 'البريد' : 'Email', email!));
    }
    if (website != null && website!.isNotEmpty) {
      contacts.add((isArabic ? 'الموقع' : 'Website', website!));
    }

    return contacts;
  }

  /// Gets formatted registration info.
  List<(String label, String value)> getRegistrationInfo(
      {bool isArabic = false}) {
    final registrations = <(String label, String value)>[];

    if (vatNumber != null && vatNumber!.isNotEmpty) {
      registrations.add((isArabic ? 'الرقم الضريبي' : 'VAT No', vatNumber!));
    }
    if (crNumber != null && crNumber!.isNotEmpty) {
      registrations.add((isArabic ? 'السجل التجاري' : 'CR No', crNumber!));
    }
    if (licenseNumber != null && licenseNumber!.isNotEmpty) {
      registrations
          .add((isArabic ? 'رقم الترخيص' : 'License No', licenseNumber!));
    }

    return registrations;
  }

  /// Creates a copy with modified values.
  GeniusPdfCompanyInfo copyWith({
    String? name,
    String? nameAr,
    String? address,
    String? addressAr,
    String? addressLine2,
    String? addressLine2Ar,
    String? city,
    String? cityAr,
    String? state,
    String? postalCode,
    String? country,
    String? countryAr,
    String? phone,
    String? phone2,
    String? fax,
    String? email,
    String? email2,
    String? vatNumber,
    String? crNumber,
    String? licenseNumber,
    GeniusPdfImage? logo,
    GeniusPdfImage? secondaryLogo,
    String? website,
    String? slogan,
    String? sloganAr,
    Map<String, String>? socialMedia,
  }) {
    return GeniusPdfCompanyInfo(
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      address: address ?? this.address,
      addressAr: addressAr ?? this.addressAr,
      addressLine2: addressLine2 ?? this.addressLine2,
      addressLine2Ar: addressLine2Ar ?? this.addressLine2Ar,
      city: city ?? this.city,
      cityAr: cityAr ?? this.cityAr,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      countryAr: countryAr ?? this.countryAr,
      phone: phone ?? this.phone,
      phone2: phone2 ?? this.phone2,
      fax: fax ?? this.fax,
      email: email ?? this.email,
      email2: email2 ?? this.email2,
      vatNumber: vatNumber ?? this.vatNumber,
      crNumber: crNumber ?? this.crNumber,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      logo: logo ?? this.logo,
      secondaryLogo: secondaryLogo ?? this.secondaryLogo,
      website: website ?? this.website,
      slogan: slogan ?? this.slogan,
      sloganAr: sloganAr ?? this.sloganAr,
      socialMedia: socialMedia ?? this.socialMedia,
    );
  }
}

/// Logo position options.
enum GeniusPdfLogoPosition {
  /// Logo on the left side.
  left,

  /// Logo on the right side.
  right,

  /// Logo centered above title.
  centerTop,

  /// Logo in the background (watermark style).
  background,
}

/// Title alignment options for report header.
enum GeniusPdfTitleAlignment {
  /// Title aligned to the left.
  left,

  /// Title centered.
  center,

  /// Title aligned to the right.
  right,
}

/// Style configuration for report headers.
///
/// Comprehensive styling options for:
/// - Background and borders
/// - Title, subtitle, and company info typography
/// - Logo positioning and sizing
/// - Spacing and alignment control
/// - Decorative elements
///
/// ## Example
/// ```dart
/// GeniusPdfReportHeaderStyle.corporate(
///   primaryColor: Color(0xFF1565C0),
///   accentColor: Color(0xFF0D47A1),
/// )
/// ```
class GeniusPdfReportHeaderStyle {
  const GeniusPdfReportHeaderStyle({
    this.backgroundColor,
    this.titleStyle = const GeniusPdfTextStyle.title(fontSize: 16),
    this.subtitleStyle = const GeniusPdfTextStyle.subtitle(fontSize: 12),
    this.companyNameStyle = const GeniusPdfTextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
    this.companyInfoStyle = const GeniusPdfTextStyle.caption(),
    this.sloganStyle,
    this.dateStyle,
    this.showBorder = true,
    this.borderStyle = const GeniusPdfBorderStyle.bottom(width: 1),
    this.topBorderStyle,
    this.padding = const GeniusPdfCellPadding.all(10),
    this.spacing = 8,
    this.titleSpacing = 4,
    this.logoMaxWidth = 150,
    this.logoMaxHeight = 60,
    this.logoMinWidth,
    this.logoMinHeight,
    this.logoPosition = GeniusPdfLogoPosition.right,
    this.logoSpacing = 12,
    this.secondaryLogoMaxWidth = 60,
    this.secondaryLogoMaxHeight = 40,
    this.titleAlignment = GeniusPdfTitleAlignment.center,
    this.companyInfoAlignment = GeniusPdfTitleAlignment.right,
    this.showCompanyDivider = false,
    this.companyDividerColor,
    this.companyDividerWidth = 0.5,
    this.showTitleUnderline = false,
    this.titleUnderlineColor,
    this.titleUnderlineWidth = 2.0,
    this.titleUnderlineSpacing = 4,
    this.headerMinHeight,
    this.headerMaxHeight,
    this.showDateOnRight = true,
    this.dateFormat = 'dd/MM/yyyy HH:mm',
    this.showPageInfo = false,
    this.shadowEnabled = false,
    this.shadowColor,
    this.shadowOffset = 2,
    this.accentColor,
    this.accentLinePosition,
    this.accentLineWidth = 4,
  });

  /// Creates a modern header style with accent colors.
  const GeniusPdfReportHeaderStyle.modern()
      : backgroundColor = const Color(0xFFF5F5F5),
        titleStyle = const GeniusPdfTextStyle.title(
          fontSize: 18,
          color: Color(0xFF1565C0),
        ),
        subtitleStyle = const GeniusPdfTextStyle.subtitle(
          fontSize: 11,
          color: Color(0xFF757575),
        ),
        companyNameStyle = const GeniusPdfTextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF212121),
        ),
        companyInfoStyle = const GeniusPdfTextStyle(
          fontSize: 9,
          color: Color(0xFF616161),
        ),
        sloganStyle = const GeniusPdfTextStyle(
          fontSize: 8,
          color: Color(0xFF757575),
        ),
        dateStyle = null,
        showBorder = true,
        borderStyle = const GeniusPdfBorderStyle.bottom(
          width: 2,
          color: Color(0xFF1565C0),
        ),
        topBorderStyle = null,
        padding = const GeniusPdfCellPadding.all(12),
        spacing = 10,
        titleSpacing = 4,
        logoMaxWidth = 150,
        logoMaxHeight = 60,
        logoMinWidth = null,
        logoMinHeight = null,
        logoPosition = GeniusPdfLogoPosition.right,
        logoSpacing = 12,
        secondaryLogoMaxWidth = 60,
        secondaryLogoMaxHeight = 40,
        titleAlignment = GeniusPdfTitleAlignment.center,
        companyInfoAlignment = GeniusPdfTitleAlignment.left,
        showCompanyDivider = false,
        companyDividerColor = null,
        companyDividerWidth = 0.5,
        showTitleUnderline = false,
        titleUnderlineColor = null,
        titleUnderlineWidth = 2.0,
        titleUnderlineSpacing = 4,
        headerMinHeight = null,
        headerMaxHeight = null,
        showDateOnRight = true,
        dateFormat = 'dd/MM/yyyy HH:mm',
        showPageInfo = false,
        shadowEnabled = false,
        shadowColor = null,
        shadowOffset = 2,
        accentColor = const Color(0xFF1565C0),
        accentLinePosition = null,
        accentLineWidth = 4;

  /// Creates a classic header style.
  const GeniusPdfReportHeaderStyle.classic()
      : backgroundColor = null,
        titleStyle = const GeniusPdfTextStyle.title(fontSize: 14),
        subtitleStyle = const GeniusPdfTextStyle.subtitle(fontSize: 10),
        companyNameStyle = const GeniusPdfTextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
        companyInfoStyle = const GeniusPdfTextStyle.caption(fontSize: 9),
        sloganStyle = null,
        dateStyle = null,
        showBorder = true,
        borderStyle = const GeniusPdfBorderStyle.bottom(width: 0.5),
        topBorderStyle = null,
        padding = const GeniusPdfCellPadding.all(8),
        spacing = 6,
        titleSpacing = 3,
        logoMaxWidth = 120,
        logoMaxHeight = 50,
        logoMinWidth = null,
        logoMinHeight = null,
        logoPosition = GeniusPdfLogoPosition.left,
        logoSpacing = 10,
        secondaryLogoMaxWidth = 50,
        secondaryLogoMaxHeight = 35,
        titleAlignment = GeniusPdfTitleAlignment.center,
        companyInfoAlignment = GeniusPdfTitleAlignment.right,
        showCompanyDivider = false,
        companyDividerColor = null,
        companyDividerWidth = 0.5,
        showTitleUnderline = false,
        titleUnderlineColor = null,
        titleUnderlineWidth = 1.0,
        titleUnderlineSpacing = 3,
        headerMinHeight = null,
        headerMaxHeight = null,
        showDateOnRight = true,
        dateFormat = 'dd/MM/yyyy HH:mm',
        showPageInfo = false,
        shadowEnabled = false,
        shadowColor = null,
        shadowOffset = 2,
        accentColor = null,
        accentLinePosition = null,
        accentLineWidth = 4;

  /// Creates a corporate/professional header style.
  factory GeniusPdfReportHeaderStyle.corporate({
    Color primaryColor = const Color(0xFF1565C0),
    Color? accentColor,
    Color? backgroundColor,
    bool showAccentLine = true,
  }) {
    final effectiveAccent = accentColor ?? primaryColor;
    return GeniusPdfReportHeaderStyle(
      backgroundColor: backgroundColor,
      titleStyle: GeniusPdfTextStyle.title(
        fontSize: 16,
        color: primaryColor,
      ),
      subtitleStyle: const GeniusPdfTextStyle.subtitle(
        fontSize: 11,
        color: Color(0xFF616161),
      ),
      companyNameStyle: const GeniusPdfTextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Color(0xFF212121),
      ),
      companyInfoStyle: const GeniusPdfTextStyle(
        fontSize: 9,
        color: Color(0xFF616161),
      ),
      sloganStyle: GeniusPdfTextStyle(
        fontSize: 8,
        color: primaryColor.withValues(alpha: 0.7),
      ),
      showBorder: true,
      borderStyle: GeniusPdfBorderStyle.bottom(
        width: 2,
        color: primaryColor,
      ),
      padding: const GeniusPdfCellPadding.all(12),
      spacing: 10,
      logoPosition: GeniusPdfLogoPosition.right,
      titleAlignment: GeniusPdfTitleAlignment.center,
      companyInfoAlignment: GeniusPdfTitleAlignment.left,
      accentColor: effectiveAccent,
      accentLinePosition: showAccentLine ? GeniusPdfLogoPosition.left : null,
      accentLineWidth: 4,
    );
  }

  /// Creates a minimal/clean header style.
  factory GeniusPdfReportHeaderStyle.minimal({
    Color accentColor = const Color(0xFF424242),
  }) {
    return GeniusPdfReportHeaderStyle(
      backgroundColor: null,
      titleStyle: GeniusPdfTextStyle.title(
        fontSize: 14,
        color: accentColor,
      ),
      subtitleStyle: GeniusPdfTextStyle.subtitle(
        fontSize: 10,
        color: accentColor.withValues(alpha: 0.7),
      ),
      companyNameStyle: GeniusPdfTextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: accentColor,
      ),
      companyInfoStyle: GeniusPdfTextStyle(
        fontSize: 8,
        color: accentColor.withValues(alpha: 0.6),
      ),
      showBorder: true,
      borderStyle: GeniusPdfBorderStyle.bottom(
        width: 1,
        color: accentColor,
      ),
      padding: const GeniusPdfCellPadding.symmetric(horizontal: 0, vertical: 8),
      spacing: 6,
      logoMaxWidth: 100,
      logoMaxHeight: 40,
      logoPosition: GeniusPdfLogoPosition.left,
      titleAlignment: GeniusPdfTitleAlignment.left,
      companyInfoAlignment: GeniusPdfTitleAlignment.right,
    );
  }

  /// Creates a Saudi-themed header style with green colors.
  factory GeniusPdfReportHeaderStyle.saudi({
    Color primaryColor = const Color(0xFF006C35),
    Color? accentColor,
  }) {
    final effectiveAccent = accentColor ?? primaryColor;
    return GeniusPdfReportHeaderStyle(
      backgroundColor: primaryColor.withValues(alpha: 0.03),
      titleStyle: GeniusPdfTextStyle.title(
        fontSize: 16,
        color: primaryColor,
      ),
      subtitleStyle: const GeniusPdfTextStyle.subtitle(
        fontSize: 11,
        color: Color(0xFF616161),
      ),
      companyNameStyle: GeniusPdfTextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: effectiveAccent,
      ),
      companyInfoStyle: const GeniusPdfTextStyle(
        fontSize: 9,
        color: Color(0xFF616161),
      ),
      showBorder: true,
      borderStyle: GeniusPdfBorderStyle.bottom(
        width: 2,
        color: primaryColor,
      ),
      topBorderStyle: GeniusPdfBorderStyle.top(
        width: 4,
        color: primaryColor,
      ),
      padding: const GeniusPdfCellPadding.all(12),
      spacing: 10,
      logoPosition: GeniusPdfLogoPosition.right,
      titleAlignment: GeniusPdfTitleAlignment.center,
      companyInfoAlignment: GeniusPdfTitleAlignment.left,
      accentColor: effectiveAccent,
    );
  }

  /// Creates an invoice-style header.
  factory GeniusPdfReportHeaderStyle.invoice({
    Color primaryColor = const Color(0xFF333333),
    bool showBackground = true,
  }) {
    return GeniusPdfReportHeaderStyle(
      backgroundColor: showBackground ? const Color(0xFFF8F8F8) : null,
      titleStyle: GeniusPdfTextStyle.title(
        fontSize: 20,
        color: primaryColor,
      ),
      subtitleStyle: const GeniusPdfTextStyle.subtitle(
        fontSize: 10,
        color: Color(0xFF666666),
      ),
      companyNameStyle: GeniusPdfTextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
      companyInfoStyle: const GeniusPdfTextStyle(
        fontSize: 9,
        color: Color(0xFF666666),
      ),
      showBorder: true,
      borderStyle: GeniusPdfBorderStyle.all(
        width: 1,
        color: const Color(0xFFCCCCCC),
      ),
      padding: const GeniusPdfCellPadding.all(15),
      spacing: 12,
      logoPosition: GeniusPdfLogoPosition.left,
      logoMaxWidth: 180,
      logoMaxHeight: 70,
      titleAlignment: GeniusPdfTitleAlignment.right,
      companyInfoAlignment: GeniusPdfTitleAlignment.left,
      showCompanyDivider: true,
      companyDividerColor: const Color(0xFFCCCCCC),
    );
  }

  /// Background color for header area.
  final Color? backgroundColor;

  /// Style for main title.
  final GeniusPdfTextStyle titleStyle;

  /// Style for subtitle.
  final GeniusPdfTextStyle subtitleStyle;

  /// Style for company name.
  final GeniusPdfTextStyle companyNameStyle;

  /// Style for company info (address, phone, etc.).
  final GeniusPdfTextStyle companyInfoStyle;

  /// Style for company slogan.
  final GeniusPdfTextStyle? sloganStyle;

  /// Style for date/time display.
  final GeniusPdfTextStyle? dateStyle;

  /// Whether to show bottom border.
  final bool showBorder;

  /// Bottom border style.
  final GeniusPdfBorderStyle borderStyle;

  /// Top border style (optional).
  final GeniusPdfBorderStyle? topBorderStyle;

  /// Padding around header content.
  final GeniusPdfCellPadding padding;

  /// General spacing between sections.
  final double spacing;

  /// Spacing between title and subtitle.
  final double titleSpacing;

  /// Maximum logo width.
  final double logoMaxWidth;

  /// Maximum logo height.
  final double logoMaxHeight;

  /// Minimum logo width.
  final double? logoMinWidth;

  /// Minimum logo height.
  final double? logoMinHeight;

  /// Logo position in header.
  final GeniusPdfLogoPosition logoPosition;

  /// Spacing around logo.
  final double logoSpacing;

  /// Maximum width for secondary logo.
  final double secondaryLogoMaxWidth;

  /// Maximum height for secondary logo.
  final double secondaryLogoMaxHeight;

  /// Title text alignment.
  final GeniusPdfTitleAlignment titleAlignment;

  /// Company info alignment.
  final GeniusPdfTitleAlignment companyInfoAlignment;

  /// Whether to show divider below company info.
  final bool showCompanyDivider;

  /// Color for company divider.
  final Color? companyDividerColor;

  /// Width of company divider.
  final double companyDividerWidth;

  /// Whether to show underline under title.
  final bool showTitleUnderline;

  /// Color for title underline.
  final Color? titleUnderlineColor;

  /// Width of title underline.
  final double titleUnderlineWidth;

  /// Spacing around title underline.
  final double titleUnderlineSpacing;

  /// Minimum height for header.
  final double? headerMinHeight;

  /// Maximum height for header.
  final double? headerMaxHeight;

  /// Whether to show date on the right side.
  final bool showDateOnRight;

  /// Date format string.
  final String dateFormat;

  /// Whether to show page info (Page X of Y).
  final bool showPageInfo;

  /// Whether to show shadow.
  final bool shadowEnabled;

  /// Shadow color.
  final Color? shadowColor;

  /// Shadow offset.
  final double shadowOffset;

  /// Accent color for decorative elements.
  final Color? accentColor;

  /// Position for accent line (null to hide).
  final GeniusPdfLogoPosition? accentLinePosition;

  /// Width of accent line.
  final double accentLineWidth;

  /// Creates a copy with modified values.
  GeniusPdfReportHeaderStyle copyWith({
    Color? backgroundColor,
    GeniusPdfTextStyle? titleStyle,
    GeniusPdfTextStyle? subtitleStyle,
    GeniusPdfTextStyle? companyNameStyle,
    GeniusPdfTextStyle? companyInfoStyle,
    GeniusPdfTextStyle? sloganStyle,
    GeniusPdfTextStyle? dateStyle,
    bool? showBorder,
    GeniusPdfBorderStyle? borderStyle,
    GeniusPdfBorderStyle? topBorderStyle,
    GeniusPdfCellPadding? padding,
    double? spacing,
    double? titleSpacing,
    double? logoMaxWidth,
    double? logoMaxHeight,
    double? logoMinWidth,
    double? logoMinHeight,
    GeniusPdfLogoPosition? logoPosition,
    double? logoSpacing,
    double? secondaryLogoMaxWidth,
    double? secondaryLogoMaxHeight,
    GeniusPdfTitleAlignment? titleAlignment,
    GeniusPdfTitleAlignment? companyInfoAlignment,
    bool? showCompanyDivider,
    Color? companyDividerColor,
    double? companyDividerWidth,
    bool? showTitleUnderline,
    Color? titleUnderlineColor,
    double? titleUnderlineWidth,
    double? titleUnderlineSpacing,
    double? headerMinHeight,
    double? headerMaxHeight,
    bool? showDateOnRight,
    String? dateFormat,
    bool? showPageInfo,
    bool? shadowEnabled,
    Color? shadowColor,
    double? shadowOffset,
    Color? accentColor,
    GeniusPdfLogoPosition? accentLinePosition,
    double? accentLineWidth,
  }) {
    return GeniusPdfReportHeaderStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      titleStyle: titleStyle ?? this.titleStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      companyNameStyle: companyNameStyle ?? this.companyNameStyle,
      companyInfoStyle: companyInfoStyle ?? this.companyInfoStyle,
      sloganStyle: sloganStyle ?? this.sloganStyle,
      dateStyle: dateStyle ?? this.dateStyle,
      showBorder: showBorder ?? this.showBorder,
      borderStyle: borderStyle ?? this.borderStyle,
      topBorderStyle: topBorderStyle ?? this.topBorderStyle,
      padding: padding ?? this.padding,
      spacing: spacing ?? this.spacing,
      titleSpacing: titleSpacing ?? this.titleSpacing,
      logoMaxWidth: logoMaxWidth ?? this.logoMaxWidth,
      logoMaxHeight: logoMaxHeight ?? this.logoMaxHeight,
      logoMinWidth: logoMinWidth ?? this.logoMinWidth,
      logoMinHeight: logoMinHeight ?? this.logoMinHeight,
      logoPosition: logoPosition ?? this.logoPosition,
      logoSpacing: logoSpacing ?? this.logoSpacing,
      secondaryLogoMaxWidth:
          secondaryLogoMaxWidth ?? this.secondaryLogoMaxWidth,
      secondaryLogoMaxHeight:
          secondaryLogoMaxHeight ?? this.secondaryLogoMaxHeight,
      titleAlignment: titleAlignment ?? this.titleAlignment,
      companyInfoAlignment: companyInfoAlignment ?? this.companyInfoAlignment,
      showCompanyDivider: showCompanyDivider ?? this.showCompanyDivider,
      companyDividerColor: companyDividerColor ?? this.companyDividerColor,
      companyDividerWidth: companyDividerWidth ?? this.companyDividerWidth,
      showTitleUnderline: showTitleUnderline ?? this.showTitleUnderline,
      titleUnderlineColor: titleUnderlineColor ?? this.titleUnderlineColor,
      titleUnderlineWidth: titleUnderlineWidth ?? this.titleUnderlineWidth,
      titleUnderlineSpacing:
          titleUnderlineSpacing ?? this.titleUnderlineSpacing,
      headerMinHeight: headerMinHeight ?? this.headerMinHeight,
      headerMaxHeight: headerMaxHeight ?? this.headerMaxHeight,
      showDateOnRight: showDateOnRight ?? this.showDateOnRight,
      dateFormat: dateFormat ?? this.dateFormat,
      showPageInfo: showPageInfo ?? this.showPageInfo,
      shadowEnabled: shadowEnabled ?? this.shadowEnabled,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowOffset: shadowOffset ?? this.shadowOffset,
      accentColor: accentColor ?? this.accentColor,
      accentLinePosition: accentLinePosition ?? this.accentLinePosition,
      accentLineWidth: accentLineWidth ?? this.accentLineWidth,
    );
  }
}

/// A professional report header component.
///
/// [GeniusPdfReportHeader] creates headers suitable for business reports with:
/// - Company logo and information
/// - Bilingual title support (Arabic/English)
/// - Print date and document metadata
/// - Multiple layout options
/// - Customizable styling
///
/// ## Example
/// ```dart
/// final header = GeniusPdfReportHeader(
///   title: 'Trial Balance',
///   titleAr: 'ميزان المراجعة',
///   subtitle: 'As of December 31, 2025',
///   subtitleAr: 'كما في 31 ديسمبر 2025',
///   company: GeniusPdfCompanyInfo(
///     name: 'Integrated Solutions Co.',
///     nameAr: 'شركة الحلول المتكاملة',
///     logo: logoImage,
///   ),
///   style: GeniusPdfReportHeaderStyle.corporate(),
/// );
///
/// header.draw(page: page, bounds: bounds);
/// ```
class GeniusPdfReportHeader {
  GeniusPdfReportHeader({
    required this.title,
    this.titleAr,
    this.subtitle,
    this.subtitleAr,
    this.secondarySubtitle,
    this.secondarySubtitleAr,
    this.company,
    this.secondaryCompany,
    this.printDate,
    this.documentNumber,
    this.documentNumberLabel,
    this.documentNumberLabelAr,
    this.referenceNumber,
    this.referenceLabel,
    this.referenceLabelAr,
    this.style = const GeniusPdfReportHeaderStyle(),
    required this.baseFont,
    required this.boldFont,
    this.isRTL = true,
    this.showPrintDate = true,
    this.showCompanyInfo = true,
    this.showBilingualTitle = true,
    this.bilingualTitleOrder = GeniusPdfBilingualOrder.arabicFirst,
    this.layout = GeniusPdfReportHeaderLayout.standard,
    this.pageNumber,
    this.totalPages,
    this.showPageNumber = false,
    this.customFields,
    this.tag,
  });

  /// Creates a report header for invoices/receipts.
  factory GeniusPdfReportHeader.invoice({
    required String title,
    required String documentNumber,
    String? titleAr,
    String? subtitle,
    String? subtitleAr,
    GeniusPdfCompanyInfo? company,
    GeniusPdfCompanyInfo? customerCompany,
    DateTime? date,
    String documentNumberLabel = 'Invoice No',
    String documentNumberLabelAr = 'رقم الفاتورة',
    GeniusPdfReportHeaderStyle? style,
    required PdfFont baseFont,
    required PdfFont boldFont,
    bool isRTL = true,
  }) {
    return GeniusPdfReportHeader(
      title: title,
      titleAr: titleAr,
      subtitle: subtitle,
      subtitleAr: subtitleAr,
      company: company,
      secondaryCompany: customerCompany,
      printDate: date,
      documentNumber: documentNumber,
      documentNumberLabel: documentNumberLabel,
      documentNumberLabelAr: documentNumberLabelAr,
      style: style ?? GeniusPdfReportHeaderStyle.invoice(),
      baseFont: baseFont,
      boldFont: boldFont,
      isRTL: isRTL,
      layout: GeniusPdfReportHeaderLayout.invoice,
    );
  }

  /// Creates a simple report header with minimal info.
  factory GeniusPdfReportHeader.simple({
    required String title,
    String? titleAr,
    String? subtitle,
    String? subtitleAr,
    DateTime? date,
    GeniusPdfReportHeaderStyle? style,
    required PdfFont baseFont,
    required PdfFont boldFont,
    bool isRTL = true,
  }) {
    return GeniusPdfReportHeader(
      title: title,
      titleAr: titleAr,
      subtitle: subtitle,
      subtitleAr: subtitleAr,
      printDate: date,
      style: style ?? GeniusPdfReportHeaderStyle.minimal(),
      baseFont: baseFont,
      boldFont: boldFont,
      isRTL: isRTL,
      showCompanyInfo: false,
      layout: GeniusPdfReportHeaderLayout.compact,
    );
  }

  /// Creates a header with full company details.
  factory GeniusPdfReportHeader.withCompany({
    required String title,
    required GeniusPdfCompanyInfo company,
    String? titleAr,
    String? subtitle,
    String? subtitleAr,
    DateTime? date,
    GeniusPdfReportHeaderStyle? style,
    required PdfFont baseFont,
    required PdfFont boldFont,
    bool isRTL = true,
  }) {
    return GeniusPdfReportHeader(
      title: title,
      titleAr: titleAr,
      subtitle: subtitle,
      subtitleAr: subtitleAr,
      company: company,
      printDate: date,
      style: style ?? const GeniusPdfReportHeaderStyle.modern(),
      baseFont: baseFont,
      boldFont: boldFont,
      isRTL: isRTL,
      showCompanyInfo: true,
      layout: GeniusPdfReportHeaderLayout.standard,
    );
  }

  /// Report title (English or default).
  final String title;

  /// Arabic title (optional).
  final String? titleAr;

  /// Report subtitle (English or default).
  final String? subtitle;

  /// Arabic subtitle (optional).
  final String? subtitleAr;

  /// Secondary subtitle (e.g., period range).
  final String? secondarySubtitle;

  /// Secondary subtitle in Arabic.
  final String? secondarySubtitleAr;

  /// Primary company information.
  final GeniusPdfCompanyInfo? company;

  /// Secondary company (e.g., customer for invoices).
  final GeniusPdfCompanyInfo? secondaryCompany;

  /// Print/generation date.
  final DateTime? printDate;

  /// Document number (e.g., invoice number).
  final String? documentNumber;

  /// Label for document number.
  final String? documentNumberLabel;

  /// Arabic label for document number.
  final String? documentNumberLabelAr;

  /// Reference number.
  final String? referenceNumber;

  /// Label for reference.
  final String? referenceLabel;

  /// Arabic label for reference.
  final String? referenceLabelAr;

  /// Header style configuration.
  final GeniusPdfReportHeaderStyle style;

  /// Base font for text.
  final PdfFont baseFont;

  /// Bold font for titles.
  final PdfFont boldFont;

  /// Whether to use RTL layout.
  final bool isRTL;

  /// Whether to show print date.
  final bool showPrintDate;

  /// Whether to show company info.
  final bool showCompanyInfo;

  /// Whether to show both English and Arabic titles.
  final bool showBilingualTitle;

  /// Order for bilingual title display.
  final GeniusPdfBilingualOrder bilingualTitleOrder;

  /// Header layout type.
  final GeniusPdfReportHeaderLayout layout;

  /// Current page number.
  final int? pageNumber;

  /// Total number of pages.
  final int? totalPages;

  /// Whether to show page number.
  final bool showPageNumber;

  /// Custom fields to display (label -> value).
  final Map<String, String>? customFields;

  /// Custom tag for identification.
  final String? tag;

  /// Gets the display title based on locale.
  String getTitle() {
    if (isRTL && titleAr != null) return titleAr!;
    return title;
  }

  /// Gets the display subtitle based on locale.
  String? getSubtitle() {
    if (isRTL && subtitleAr != null) return subtitleAr;
    return subtitle;
  }

  /// Gets the secondary subtitle based on locale.
  String? getSecondarySubtitle() {
    if (isRTL && secondarySubtitleAr != null) return secondarySubtitleAr;
    return secondarySubtitle;
  }

  /// Gets the document number label based on locale.
  String? getDocumentNumberLabel() {
    if (isRTL && documentNumberLabelAr != null) return documentNumberLabelAr;
    return documentNumberLabel;
  }

  /// Gets the reference label based on locale.
  String? getReferenceLabel() {
    if (isRTL && referenceLabelAr != null) return referenceLabelAr;
    return referenceLabel;
  }

  /// Gets both titles for bilingual display.
  (String, String?) getBilingualTitle() {
    return (title, titleAr);
  }

  /// Gets the page info string.
  String? getPageInfo() {
    if (!showPageNumber || pageNumber == null) return null;
    if (totalPages != null) {
      return isRTL
          ? 'صفحة $pageNumber من $totalPages'
          : 'Page $pageNumber of $totalPages';
    }
    return isRTL ? 'صفحة $pageNumber' : 'Page $pageNumber';
  }

  /// Draws the header on a PDF page.
  ///
  /// Returns the height of the drawn header.
  double draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    switch (layout) {
      case GeniusPdfReportHeaderLayout.compact:
        return _drawCompactLayout(page, bounds);
      case GeniusPdfReportHeaderLayout.centered:
        return _drawCenteredLayout(page, bounds);
      case GeniusPdfReportHeaderLayout.invoice:
        return _drawInvoiceLayout(page, bounds);
      default:
        return _drawStandardLayout(page, bounds);
    }
  }

  double _drawStandardLayout(PdfPage page, Rect bounds) {
    final graphics = page.graphics;
    double currentY = bounds.top + style.padding.top;
    final contentLeft = bounds.left + style.padding.left;
    final contentRight = bounds.right - style.padding.right;
    final contentWidth = contentRight - contentLeft;

    // Draw logo and company info on the right (for RTL)
    double logoHeight = 0;
    if (company?.logo != null && showCompanyInfo) {
      final logo = company!.logo!.scaledToFit(
        maxWidth: style.logoMaxWidth,
        maxHeight: style.logoMaxHeight,
      );

      final logoX = isRTL ? contentLeft : contentRight - logo.width;
      graphics.drawImage(
        PdfBitmap(logo.data),
        Rect.fromLTWH(logoX, currentY, logo.width, logo.height),
      );
      logoHeight = logo.height;
    }

    // Draw company info on the opposite side
    if (showCompanyInfo && company != null) {
      final infoX = isRTL ? contentRight - 200 : contentLeft;
      double infoY = currentY;

      // Company name
      final nameFont = boldFont;

      graphics.drawString(
        company!.getName(isArabic: isRTL),
        nameFont,
        brush: style.companyNameStyle.toBrush(),
        bounds: Rect.fromLTWH(infoX, infoY, 200, 0),
        format: PdfStringFormat(
          alignment: isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
          textDirection: isRTL
              ? PdfTextDirection.rightToLeft
              : PdfTextDirection.leftToRight,
        ),
      );
      infoY += style.companyNameStyle.fontSize + 2;

      // Address
      final infoFont = baseFont;

      if (company!.getAddress(isArabic: isRTL) != null) {
        graphics.drawString(
          company!.getAddress(isArabic: isRTL)!,
          infoFont,
          brush: style.companyInfoStyle.toBrush(),
          bounds: Rect.fromLTWH(infoX, infoY, 200, 0),
          format: PdfStringFormat(
            alignment: isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
            textDirection: isRTL
                ? PdfTextDirection.rightToLeft
                : PdfTextDirection.leftToRight,
          ),
        );
        infoY += style.companyInfoStyle.fontSize + 2;
      }

      // VAT Number
      if (company!.vatNumber != null) {
        final vatLabel = isRTL ? 'الرقم الضريبي: ' : 'VAT No: ';
        graphics.drawString(
          '$vatLabel${company!.vatNumber}',
          infoFont,
          brush: style.companyInfoStyle.toBrush(),
          bounds: Rect.fromLTWH(infoX, infoY, 200, 0),
          format: PdfStringFormat(
            alignment: isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
            textDirection: isRTL
                ? PdfTextDirection.rightToLeft
                : PdfTextDirection.leftToRight,
          ),
        );
        infoY += style.companyInfoStyle.fontSize + 2;
      }

      // Phone
      if (company!.phone != null) {
        final phoneLabel = isRTL ? 'الهاتف: ' : 'Phone: ';
        graphics.drawString(
          '$phoneLabel${company!.phone}',
          infoFont,
          brush: style.companyInfoStyle.toBrush(),
          bounds: Rect.fromLTWH(infoX, infoY, 200, 0),
          format: PdfStringFormat(
            alignment: isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
            textDirection: isRTL
                ? PdfTextDirection.rightToLeft
                : PdfTextDirection.leftToRight,
          ),
        );
      }
    }

    currentY += logoHeight > 0 ? logoHeight + style.spacing : style.spacing;

    // Draw title (centered, bilingual)
    final titleFont = boldFont;

    // Draw Arabic title
    if (titleAr != null) {
      graphics.drawString(
        titleAr!,
        titleFont,
        brush: style.titleStyle.toBrush(),
        bounds: Rect.fromLTWH(contentLeft, currentY, contentWidth, 0),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          textDirection: PdfTextDirection.rightToLeft,
        ),
      );
      currentY += style.titleStyle.fontSize + 2;
    }

    // Draw English title
    graphics.drawString(
      title,
      titleFont,
      brush: style.titleStyle.toBrush(),
      bounds: Rect.fromLTWH(contentLeft, currentY, contentWidth, 0),
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
        textDirection: PdfTextDirection.leftToRight,
      ),
    );
    currentY += style.titleStyle.fontSize + style.spacing;

    // Draw subtitle
    final displaySubtitle = getSubtitle();
    if (displaySubtitle != null) {
      // Font
      final subtitleFont = baseFont;

      // Arabic subtitle
      if (subtitleAr != null) {
        graphics.drawString(
          subtitleAr!,
          subtitleFont,
          brush: style.subtitleStyle.toBrush(),
          bounds: Rect.fromLTWH(contentLeft, currentY, contentWidth, 0),
          format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            textDirection: PdfTextDirection.rightToLeft,
          ),
        );
        currentY += style.subtitleStyle.fontSize + 2;
      }

      // English subtitle
      if (subtitle != null) {
        graphics.drawString(
          subtitle!,
          subtitleFont,
          brush: style.subtitleStyle.toBrush(),
          bounds: Rect.fromLTWH(contentLeft, currentY, contentWidth, 0),
          format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            textDirection: PdfTextDirection.leftToRight,
          ),
        );
        currentY += style.subtitleStyle.fontSize;
      }
    }

    currentY += style.padding.bottom;

    // Draw print date
    if (showPrintDate && printDate != null) {
      // Font
      final dateFont = baseFont;
      final dateText = isRTL
          ? 'تاريخ الطباعة: ${_formatDate(printDate!)}'
          : 'Printed on: ${_formatDate(printDate!)}';

      graphics.drawString(
        dateText,
        dateFont,
        brush: PdfSolidBrush(const Color(0xFF757575).toPdfColor()),
        bounds: Rect.fromLTWH(contentRight - 150, currentY - 12, 150, 0),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.right,
        ),
      );
    }

    // Draw border
    if (style.showBorder) {
      graphics.drawLine(
        style.borderStyle.toPen(),
        Offset(bounds.left, currentY),
        Offset(bounds.right, currentY),
      );
    }

    return currentY - bounds.top;
  }

  double _drawCompactLayout(PdfPage page, Rect bounds) {
    final graphics = page.graphics;
    double currentY = bounds.top + style.padding.top;
    final contentLeft = bounds.left + style.padding.left;
    final contentRight = bounds.right - style.padding.right;
    final contentWidth = contentRight - contentLeft;

    // Logo on one side, title on other
    double logoWidth = 0;
    if (company?.logo != null) {
      final logo = company!.logo!.scaledToFit(
        maxWidth: style.logoMaxWidth * 0.7,
        maxHeight: style.logoMaxHeight * 0.7,
      );

      final logoX = isRTL ? contentLeft : contentRight - logo.width;
      graphics.drawImage(
        PdfBitmap(logo.data),
        Rect.fromLTWH(logoX, currentY, logo.width, logo.height),
      );
      logoWidth = logo.width + style.spacing;
    }

    // Title
    final titleFont = boldFont;

    final titleX = isRTL ? contentLeft + logoWidth : contentLeft;
    final titleWidth = contentWidth - logoWidth;

    // Bilingual title on same area
    if (titleAr != null) {
      graphics.drawString(
        titleAr!,
        titleFont,
        brush: style.titleStyle.toBrush(),
        bounds: Rect.fromLTWH(titleX, currentY, titleWidth, 0),
        format: PdfStringFormat(
          alignment: isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
          textDirection: PdfTextDirection.rightToLeft,
        ),
      );
      currentY += style.titleStyle.fontSize + 2;
    }

    graphics.drawString(
      title,
      titleFont,
      brush: style.titleStyle.toBrush(),
      bounds: Rect.fromLTWH(titleX, currentY, titleWidth, 0),
      format: PdfStringFormat(
        alignment: isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
        textDirection: PdfTextDirection.leftToRight,
      ),
    );
    currentY += style.titleStyle.fontSize + style.spacing;

    currentY += style.padding.bottom;

    if (style.showBorder) {
      graphics.drawLine(
        style.borderStyle.toPen(),
        Offset(bounds.left, currentY),
        Offset(bounds.right, currentY),
      );
    }

    return currentY - bounds.top;
  }

  double _drawCenteredLayout(PdfPage page, Rect bounds) {
    final graphics = page.graphics;
    double currentY = bounds.top + style.padding.top;
    final contentLeft = bounds.left + style.padding.left;
    final contentRight = bounds.right - style.padding.right;
    final contentWidth = contentRight - contentLeft;

    // Center logo
    if (company?.logo != null) {
      final logo = company!.logo!.scaledToFit(
        maxWidth: style.logoMaxWidth,
        maxHeight: style.logoMaxHeight,
      );

      final logoX = contentLeft + (contentWidth - logo.width) / 2;
      graphics.drawImage(
        PdfBitmap(logo.data),
        Rect.fromLTWH(logoX, currentY, logo.width, logo.height),
      );
      currentY += logo.height + style.spacing;
    }

    // Center title
    final titleFont = boldFont;

    if (titleAr != null) {
      graphics.drawString(
        titleAr!,
        titleFont,
        brush: style.titleStyle.toBrush(),
        bounds: Rect.fromLTWH(contentLeft, currentY, contentWidth, 0),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          textDirection: PdfTextDirection.rightToLeft,
        ),
      );
      currentY += style.titleStyle.fontSize + 2;
    }

    graphics.drawString(
      title,
      titleFont,
      brush: style.titleStyle.toBrush(),
      bounds: Rect.fromLTWH(contentLeft, currentY, contentWidth, 0),
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
        textDirection: PdfTextDirection.leftToRight,
      ),
    );
    currentY += style.titleStyle.fontSize + style.spacing;

    // Subtitle
    if (subtitle != null || subtitleAr != null) {
      // Font
      final subtitleFont = baseFont;

      if (subtitleAr != null) {
        graphics.drawString(
          subtitleAr!,
          subtitleFont,
          brush: style.subtitleStyle.toBrush(),
          bounds: Rect.fromLTWH(contentLeft, currentY, contentWidth, 0),
          format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            textDirection: PdfTextDirection.rightToLeft,
          ),
        );
        currentY += style.subtitleStyle.fontSize + 2;
      }

      if (subtitle != null) {
        graphics.drawString(
          subtitle!,
          subtitleFont,
          brush: style.subtitleStyle.toBrush(),
          bounds: Rect.fromLTWH(contentLeft, currentY, contentWidth, 0),
          format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            textDirection: PdfTextDirection.leftToRight,
          ),
        );
        currentY += style.subtitleStyle.fontSize;
      }
    }

    currentY += style.padding.bottom;

    if (style.showBorder) {
      graphics.drawLine(
        style.borderStyle.toPen(),
        Offset(bounds.left, currentY),
        Offset(bounds.right, currentY),
      );
    }

    return currentY - bounds.top;
  }

  double _drawInvoiceLayout(PdfPage page, Rect bounds) {
    // Invoice layout with company on sides and title in center
    return _drawStandardLayout(page, bounds);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

/// Layout options for report headers.
enum GeniusPdfReportHeaderLayout {
  /// Standard layout with logo, company info, and centered title.
  standard,

  /// Compact layout with logo and title side by side.
  compact,

  /// Centered layout with everything centered.
  centered,

  /// Invoice-style layout with dual company info.
  invoice,

  /// Letter-style layout with company on top left.
  letterhead,

  /// Report card layout with bordered sections.
  reportCard,

  /// Minimal layout with just title and optional date.
  minimal,

  /// Full width layout with company info spanning width.
  fullWidth,
}

/// Order for bilingual text display.
enum GeniusPdfBilingualOrder {
  /// Show Arabic text first, then English.
  arabicFirst,

  /// Show English text first, then Arabic.
  englishFirst,

  /// Show only the primary language based on RTL setting.
  primaryOnly,

  /// Show text side by side (Arabic on right, English on left).
  sideBySide,
}
