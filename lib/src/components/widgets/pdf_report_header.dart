import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart'
    hide PdfTextStyle, PdfBorderStyle;

import '../../core/pdf_config.dart';
import '../../core/pdf_print_theme.dart';
import '../../core/pdf_logger.dart';
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

// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

/// Logo position options (direction-aware).
///
/// `start` and `end` resolve based on RTL/LTR context:
/// - In LTR: start = left, end = right
/// - In RTL: start = right, end = left
enum GeniusPdfLogoPosition {
  /// Start side (left in LTR, right in RTL).
  start,

  /// End side (right in LTR, left in RTL).
  end,

  /// Centered horizontally.
  center,

  /// Centered above title.
  centerTop,

  /// Centered below content.
  centerBottom,

  /// Logo in the background (watermark style).
  background,
}

/// Title alignment options (direction-aware).
///
/// `start` and `end` resolve based on RTL/LTR context:
/// - In LTR: start = left, end = right
/// - In RTL: start = right, end = left
enum GeniusPdfTitleAlignment {
  /// Aligned to start (left in LTR, right in RTL).
  start,

  /// Aligned to end (right in LTR, left in RTL).
  end,

  /// Centered.
  center,
}

// ---------------------------------------------------------------------------
// Style
// ---------------------------------------------------------------------------

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
    this.logoPosition = GeniusPdfLogoPosition.end,
    this.logoSpacing = 12,
    this.secondaryLogoMaxWidth = 60,
    this.secondaryLogoMaxHeight = 40,
    this.titleAlignment = GeniusPdfTitleAlignment.center,
    this.companyInfoAlignment = GeniusPdfTitleAlignment.end,
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
    this.dateSpacing = 6,
  });

  /// Creates a header style from [GeniusPdfPrintTheme].
  factory GeniusPdfReportHeaderStyle.fromTheme(GeniusPdfPrintTheme theme) {
    final headerTheme =
        theme.headerTheme ?? const GeniusPdfHeaderTheme.defaults();
    final typography = theme.typography;

    return GeniusPdfReportHeaderStyle(
      backgroundColor: headerTheme.backgroundColor,
      titleStyle: GeniusPdfTextStyle.title(
        fontSize: typography.titleSize,
        color: headerTheme.titleColor,
      ),
      subtitleStyle: GeniusPdfTextStyle.subtitle(
        fontSize: typography.subheadingSize,
        color: headerTheme.subtitleColor,
      ),
      companyNameStyle: GeniusPdfTextStyle(
        fontSize: typography.headingSize,
        fontWeight: FontWeight.bold,
        color: headerTheme.companyNameColor,
      ),
      companyInfoStyle: GeniusPdfTextStyle(
        fontSize: typography.bodySize,
        color: headerTheme.companyInfoColor,
      ),
      dateStyle: GeniusPdfTextStyle(
        fontSize: typography.captionSize,
        color: headerTheme.subtitleColor,
      ),
      borderStyle: headerTheme.showBorder
          ? GeniusPdfBorderStyle.all(
              width: headerTheme.borderWidth,
              color: headerTheme.borderColor,
            )
          : const GeniusPdfBorderStyle.none(),
      padding: headerTheme.padding,
      spacing: headerTheme.spacing,
      logoMaxWidth: headerTheme.logoMaxWidth,
      logoMaxHeight: headerTheme.logoMaxHeight,
      showBorder: headerTheme.showBorder,
    );
  }

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
        logoPosition = GeniusPdfLogoPosition.end,
        logoSpacing = 12,
        secondaryLogoMaxWidth = 60,
        secondaryLogoMaxHeight = 40,
        titleAlignment = GeniusPdfTitleAlignment.center,
        companyInfoAlignment = GeniusPdfTitleAlignment.start,
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
        accentLineWidth = 4,
        dateSpacing = 6;

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
        logoPosition = GeniusPdfLogoPosition.start,
        logoSpacing = 10,
        secondaryLogoMaxWidth = 50,
        secondaryLogoMaxHeight = 35,
        titleAlignment = GeniusPdfTitleAlignment.center,
        companyInfoAlignment = GeniusPdfTitleAlignment.end,
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
        accentLineWidth = 4,
        dateSpacing = 6;

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
      logoPosition: GeniusPdfLogoPosition.end,
      titleAlignment: GeniusPdfTitleAlignment.center,
      companyInfoAlignment: GeniusPdfTitleAlignment.start,
      accentColor: effectiveAccent,
      accentLinePosition: showAccentLine ? GeniusPdfLogoPosition.start : null,
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
      logoPosition: GeniusPdfLogoPosition.start,
      titleAlignment: GeniusPdfTitleAlignment.start,
      companyInfoAlignment: GeniusPdfTitleAlignment.end,
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
      logoPosition: GeniusPdfLogoPosition.end,
      titleAlignment: GeniusPdfTitleAlignment.center,
      companyInfoAlignment: GeniusPdfTitleAlignment.start,
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
      logoPosition: GeniusPdfLogoPosition.start,
      logoMaxWidth: 180,
      logoMaxHeight: 70,
      titleAlignment: GeniusPdfTitleAlignment.end,
      companyInfoAlignment: GeniusPdfTitleAlignment.start,
      showCompanyDivider: true,
      companyDividerColor: const Color(0xFFCCCCCC),
    );
  }

  /// Creates a bilingual split header style (Arabic right, English left).
  factory GeniusPdfReportHeaderStyle.bilingualSplit({
    Color primaryColor = const Color(0xFF006C35),
    Color? accentColor,
  }) {
    final effectiveAccent = accentColor ?? primaryColor;
    return GeniusPdfReportHeaderStyle(
      backgroundColor: null,
      titleStyle: GeniusPdfTextStyle.title(
        fontSize: 16,
        color: primaryColor,
      ),
      subtitleStyle: const GeniusPdfTextStyle.subtitle(
        fontSize: 11,
        color: Color(0xFF616161),
      ),
      companyNameStyle: GeniusPdfTextStyle(
        fontSize: 12,
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
        width: 3,
        color: primaryColor,
      ),
      padding: const GeniusPdfCellPadding.all(10),
      spacing: 8,
      logoPosition: GeniusPdfLogoPosition.center,
      logoMaxWidth: 100,
      logoMaxHeight: 80,
      titleAlignment: GeniusPdfTitleAlignment.center,
      companyInfoAlignment: GeniusPdfTitleAlignment.start,
      accentColor: effectiveAccent,
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

  /// Spacing between date and border line.
  final double dateSpacing;

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
    double? dateSpacing,
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
      dateSpacing: dateSpacing ?? this.dateSpacing,
    );
  }
}

// ---------------------------------------------------------------------------
// Header Component
// ---------------------------------------------------------------------------

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
    required this.config,
    GeniusPdfReportHeaderStyle? style,
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
  }) : style = _resolveHeaderStyle(style, config);

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
    required GeniusPdfConfig config,
    GeniusPdfReportHeaderStyle? style,
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
      config: config,
      style: style ?? GeniusPdfReportHeaderStyle.invoice(),
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
    required GeniusPdfConfig config,
    GeniusPdfReportHeaderStyle? style,
  }) {
    return GeniusPdfReportHeader(
      title: title,
      titleAr: titleAr,
      subtitle: subtitle,
      subtitleAr: subtitleAr,
      printDate: date,
      config: config,
      style: style ?? GeniusPdfReportHeaderStyle.minimal(),
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
    required GeniusPdfConfig config,
    GeniusPdfReportHeaderStyle? style,
  }) {
    return GeniusPdfReportHeader(
      title: title,
      titleAr: titleAr,
      subtitle: subtitle,
      subtitleAr: subtitleAr,
      company: company,
      printDate: date,
      config: config,
      style: style ?? const GeniusPdfReportHeaderStyle.modern(),
      showCompanyInfo: true,
      layout: GeniusPdfReportHeaderLayout.standard,
    );
  }

  /// Creates a bilingual split header (Arabic right, English left, logo center).
  factory GeniusPdfReportHeader.bilingualSplit({
    required String title,
    required String titleAr,
    required GeniusPdfCompanyInfo company,
    String? subtitle,
    String? subtitleAr,
    DateTime? date,
    required GeniusPdfConfig config,
    GeniusPdfReportHeaderStyle? style,
  }) {
    return GeniusPdfReportHeader(
      title: title,
      titleAr: titleAr,
      subtitle: subtitle,
      subtitleAr: subtitleAr,
      company: company,
      printDate: date,
      config: config,
      style: style ?? GeniusPdfReportHeaderStyle.bilingualSplit(),
      showCompanyInfo: true,
      showBilingualTitle: true,
      layout: GeniusPdfReportHeaderLayout.bilingualSplit,
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

  /// PDF configuration.
  final GeniusPdfConfig config;

  /// Base font for text.
  PdfFont get baseFont => config.baseFont;

  /// Bold font for titles.
  PdfFont get boldFont => config.boldFont;

  /// Whether to use RTL layout.
  bool get isRTL => config.isRTL;

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

  static GeniusPdfReportHeaderStyle _resolveHeaderStyle(
    GeniusPdfReportHeaderStyle? style,
    GeniusPdfConfig config,
  ) {
    if (style != null) return style;
    return GeniusPdfReportHeaderStyle.fromTheme(config.printTheme);
  }

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

  // -------------------------------------------------------------------------
  // Alignment helpers
  // -------------------------------------------------------------------------

  /// Resolves [GeniusPdfTitleAlignment] to [PdfTextAlignment] based on RTL.
  PdfTextAlignment _resolveTextAlignment(GeniusPdfTitleAlignment alignment) {
    switch (alignment) {
      case GeniusPdfTitleAlignment.start:
        return isRTL ? PdfTextAlignment.right : PdfTextAlignment.left;
      case GeniusPdfTitleAlignment.end:
        return isRTL ? PdfTextAlignment.left : PdfTextAlignment.right;
      case GeniusPdfTitleAlignment.center:
        return PdfTextAlignment.center;
    }
  }

  /// Resolves logo X position based on [GeniusPdfLogoPosition] and RTL.
  double _resolveLogoX(
    GeniusPdfLogoPosition position,
    double contentLeft,
    double contentRight,
    double logoWidth,
  ) {
    switch (position) {
      case GeniusPdfLogoPosition.start:
        return isRTL ? contentRight - logoWidth : contentLeft;
      case GeniusPdfLogoPosition.end:
        return isRTL ? contentLeft : contentRight - logoWidth;
      case GeniusPdfLogoPosition.center:
      case GeniusPdfLogoPosition.centerTop:
      case GeniusPdfLogoPosition.centerBottom:
        return contentLeft + ((contentRight - contentLeft) - logoWidth) / 2;
      case GeniusPdfLogoPosition.background:
        return contentLeft + ((contentRight - contentLeft) - logoWidth) / 2;
    }
  }

  /// Creates a [PdfStringFormat] for the given alignment and RTL direction.
  PdfStringFormat _textFormat(GeniusPdfTitleAlignment alignment) {
    return PdfStringFormat(
      alignment: _resolveTextAlignment(alignment),
      textDirection:
          isRTL ? PdfTextDirection.rightToLeft : PdfTextDirection.leftToRight,
    );
  }

  /// Creates a [PdfStringFormat] with explicit text direction.
  PdfStringFormat _textFormatDir(
      PdfTextAlignment alignment, PdfTextDirection direction) {
    return PdfStringFormat(alignment: alignment, textDirection: direction);
  }

  // -------------------------------------------------------------------------
  // Common drawing helpers
  // -------------------------------------------------------------------------

  /// Draws the background, top border, and accent line.
  void _drawBackground(PdfGraphics graphics, Rect bounds) {
    // Shadow
    if (style.shadowEnabled) {
      final shadowColor =
          (style.shadowColor ?? const Color(0xFF000000)).withValues(alpha: 0.1);
      graphics.drawRectangle(
        brush: PdfSolidBrush(shadowColor.toPdfColor()),
        bounds: Rect.fromLTWH(
          bounds.left + style.shadowOffset,
          bounds.top + style.shadowOffset,
          bounds.width,
          bounds.height,
        ),
      );
    }

    // Background
    if (style.backgroundColor != null) {
      graphics.drawRectangle(
        brush: PdfSolidBrush(style.backgroundColor!.toPdfColor()),
        bounds: bounds,
      );
    }

    // Top border
    if (style.topBorderStyle != null) {
      graphics.drawLine(
        style.topBorderStyle!.toPen(),
        Offset(bounds.left, bounds.top),
        Offset(bounds.right, bounds.top),
      );
    }

    // Accent line
    if (style.accentLinePosition != null && style.accentColor != null) {
      final pen = PdfPen(
        style.accentColor!.toPdfColor(),
        width: style.accentLineWidth,
      );
      switch (style.accentLinePosition!) {
        case GeniusPdfLogoPosition.start:
          final x = isRTL
              ? bounds.right - style.accentLineWidth / 2
              : bounds.left + style.accentLineWidth / 2;
          graphics.drawLine(
              pen, Offset(x, bounds.top), Offset(x, bounds.bottom));
          break;
        case GeniusPdfLogoPosition.end:
          final x = isRTL
              ? bounds.left + style.accentLineWidth / 2
              : bounds.right - style.accentLineWidth / 2;
          graphics.drawLine(
              pen, Offset(x, bounds.top), Offset(x, bounds.bottom));
          break;
        default:
          break;
      }
    }
  }

  /// Draws date and page info, returns the height consumed.
  double _drawDateSection(
    PdfGraphics graphics,
    double currentY,
    double contentLeft,
    double contentRight,
  ) {
    if (!showPrintDate && !showPageNumber) return 0;

    final dateFont = baseFont;
    final dateBrush = style.dateStyle?.toBrush() ??
        PdfSolidBrush(const Color(0xFF757575).toPdfColor());
    final dateFontSize = style.dateStyle?.fontSize ?? 8;
    double dateHeight = 0;

    if (showPrintDate && printDate != null) {
      final dateText = isRTL
          ? 'تاريخ الطباعة: ${_formatDate(printDate!)}'
          : 'Printed: ${_formatDate(printDate!)}';

      final dateAlignment = style.showDateOnRight
          ? PdfTextAlignment.right
          : PdfTextAlignment.left;
      final dateX = style.showDateOnRight ? contentLeft : contentLeft;
      final dateWidth = contentRight - contentLeft;

      graphics.drawString(
        dateText,
        dateFont,
        brush: dateBrush,
        bounds: Rect.fromLTWH(dateX, currentY, dateWidth, 0),
        format: PdfStringFormat(alignment: dateAlignment),
      );
      dateHeight = dateFontSize + 2;
    }

    // Page info on the opposite side of date
    final pageInfo = getPageInfo();
    if (pageInfo != null) {
      final pageAlignment = style.showDateOnRight
          ? PdfTextAlignment.left
          : PdfTextAlignment.right;

      graphics.drawString(
        pageInfo,
        dateFont,
        brush: dateBrush,
        bounds:
            Rect.fromLTWH(contentLeft, currentY, contentRight - contentLeft, 0),
        format: PdfStringFormat(alignment: pageAlignment),
      );
      if (dateHeight == 0) dateHeight = dateFontSize + 2;
    }

    return dateHeight;
  }

  /// Draws the bottom border at the given Y position.
  void _drawBottomBorder(PdfGraphics graphics, Rect bounds, double y) {
    if (style.showBorder) {
      graphics.drawLine(
        style.borderStyle.toPen(),
        Offset(bounds.left, y),
        Offset(bounds.right, y),
      );
    }
  }

  /// Draws company info block, returns height consumed.
  double _drawCompanyInfoBlock(
    PdfGraphics graphics,
    double x,
    double y,
    double width,
    GeniusPdfTitleAlignment alignment, {
    bool isArabic = false,
  }) {
    if (company == null) return 0;

    double infoY = y;
    final nameAlignment = _resolveTextAlignment(alignment);
    final dir =
        isArabic ? PdfTextDirection.rightToLeft : PdfTextDirection.leftToRight;

    // Company name
    graphics.drawString(
      company!.getName(isArabic: isArabic),
      boldFont,
      brush: style.companyNameStyle.toBrush(),
      bounds: Rect.fromLTWH(x, infoY, width, 0),
      format: _textFormatDir(nameAlignment, dir),
    );
    infoY += style.companyNameStyle.fontSize + 3;

    // Address
    final address = company!.getAddress(isArabic: isArabic);
    if (address != null && address.isNotEmpty) {
      graphics.drawString(
        address,
        baseFont,
        brush: style.companyInfoStyle.toBrush(),
        bounds: Rect.fromLTWH(x, infoY, width, 0),
        format: _textFormatDir(nameAlignment, dir),
      );
      infoY += style.companyInfoStyle.fontSize + 2;
    }

    // City + Country
    final city = isArabic ? (company!.cityAr ?? company!.city) : company!.city;
    final country =
        isArabic ? (company!.countryAr ?? company!.country) : company!.country;
    if (city != null || country != null) {
      final parts = <String>[];
      if (city != null && city.isNotEmpty) parts.add(city);
      if (country != null && country.isNotEmpty) parts.add(country);
      if (parts.isNotEmpty) {
        graphics.drawString(
          parts.join(', '),
          baseFont,
          brush: style.companyInfoStyle.toBrush(),
          bounds: Rect.fromLTWH(x, infoY, width, 0),
          format: _textFormatDir(nameAlignment, dir),
        );
        infoY += style.companyInfoStyle.fontSize + 2;
      }
    }

    // VAT Number
    if (company!.vatNumber != null && company!.vatNumber!.isNotEmpty) {
      final vatLabel = isArabic ? 'الرقم الضريبي: ' : 'VAT No: ';
      graphics.drawString(
        '$vatLabel${company!.vatNumber}',
        baseFont,
        brush: style.companyInfoStyle.toBrush(),
        bounds: Rect.fromLTWH(x, infoY, width, 0),
        format: _textFormatDir(nameAlignment, dir),
      );
      infoY += style.companyInfoStyle.fontSize + 2;
    }

    // CR Number
    if (company!.crNumber != null && company!.crNumber!.isNotEmpty) {
      final crLabel = isArabic ? 'السجل التجاري: ' : 'CR No: ';
      graphics.drawString(
        '$crLabel${company!.crNumber}',
        baseFont,
        brush: style.companyInfoStyle.toBrush(),
        bounds: Rect.fromLTWH(x, infoY, width, 0),
        format: _textFormatDir(nameAlignment, dir),
      );
      infoY += style.companyInfoStyle.fontSize + 2;
    }

    // Phone
    if (company!.phone != null && company!.phone!.isNotEmpty) {
      final phoneLabel = isArabic ? 'الهاتف: ' : 'Phone: ';
      graphics.drawString(
        '$phoneLabel${company!.phone}',
        baseFont,
        brush: style.companyInfoStyle.toBrush(),
        bounds: Rect.fromLTWH(x, infoY, width, 0),
        format: _textFormatDir(nameAlignment, dir),
      );
      infoY += style.companyInfoStyle.fontSize + 2;
    }

    // Email
    if (company!.email != null && company!.email!.isNotEmpty) {
      final emailLabel = isArabic ? 'البريد: ' : 'Email: ';
      graphics.drawString(
        '$emailLabel${company!.email}',
        baseFont,
        brush: style.companyInfoStyle.toBrush(),
        bounds: Rect.fromLTWH(x, infoY, width, 0),
        format: _textFormatDir(nameAlignment, dir),
      );
      infoY += style.companyInfoStyle.fontSize + 2;
    }

    // Slogan
    final slogan = company!.getSlogan(isArabic: isArabic);
    if (slogan != null && slogan.isNotEmpty && style.sloganStyle != null) {
      graphics.drawString(
        slogan,
        baseFont,
        brush: style.sloganStyle!.toBrush(),
        bounds: Rect.fromLTWH(x, infoY, width, 0),
        format: _textFormatDir(nameAlignment, dir),
      );
      infoY += style.sloganStyle!.fontSize + 2;
    }

    // Company divider
    if (style.showCompanyDivider) {
      final dividerColor = style.companyDividerColor ?? const Color(0xFFCCCCCC);
      graphics.drawLine(
        PdfPen(dividerColor.toPdfColor(), width: style.companyDividerWidth),
        Offset(x, infoY + 2),
        Offset(x + width, infoY + 2),
      );
      infoY += 5;
    }

    return infoY - y;
  }

  /// Draws bilingual title block, returns height consumed.
  double _drawTitleBlock(
    PdfGraphics graphics,
    double y,
    double contentLeft,
    double contentWidth,
    GeniusPdfTitleAlignment alignment,
  ) {
    double titleY = y;
    final pdfAlignment = _resolveTextAlignment(alignment);

    // Bilingual title
    if (showBilingualTitle && titleAr != null) {
      final firstIsArabic =
          bilingualTitleOrder != GeniusPdfBilingualOrder.englishFirst;

      if (bilingualTitleOrder == GeniusPdfBilingualOrder.primaryOnly) {
        // Only primary language
        graphics.drawString(
          getTitle(),
          boldFont,
          brush: style.titleStyle.toBrush(),
          bounds: Rect.fromLTWH(contentLeft, titleY, contentWidth, 0),
          format: _textFormat(alignment),
        );
        titleY += style.titleStyle.fontSize + style.titleSpacing;
      } else {
        // First title
        final firstTitle = firstIsArabic ? titleAr! : title;
        final firstDir = firstIsArabic
            ? PdfTextDirection.rightToLeft
            : PdfTextDirection.leftToRight;
        graphics.drawString(
          firstTitle,
          boldFont,
          brush: style.titleStyle.toBrush(),
          bounds: Rect.fromLTWH(contentLeft, titleY, contentWidth, 0),
          format: _textFormatDir(pdfAlignment, firstDir),
        );
        titleY += style.titleStyle.fontSize + style.titleSpacing;

        // Second title
        final secondTitle = firstIsArabic ? title : titleAr!;
        final secondDir = firstIsArabic
            ? PdfTextDirection.leftToRight
            : PdfTextDirection.rightToLeft;
        graphics.drawString(
          secondTitle,
          boldFont,
          brush: style.titleStyle.toBrush(),
          bounds: Rect.fromLTWH(contentLeft, titleY, contentWidth, 0),
          format: _textFormatDir(pdfAlignment, secondDir),
        );
        titleY += style.titleStyle.fontSize + style.titleSpacing;
      }
    } else {
      // Single title
      graphics.drawString(
        title,
        boldFont,
        brush: style.titleStyle.toBrush(),
        bounds: Rect.fromLTWH(contentLeft, titleY, contentWidth, 0),
        format: _textFormat(alignment),
      );
      titleY += style.titleStyle.fontSize + style.titleSpacing;
    }

    // Title underline
    if (style.showTitleUnderline) {
      final underlineColor =
          style.titleUnderlineColor ?? style.titleStyle.color;
      graphics.drawLine(
        PdfPen(underlineColor.toPdfColor(), width: style.titleUnderlineWidth),
        Offset(contentLeft, titleY),
        Offset(contentLeft + contentWidth, titleY),
      );
      titleY += style.titleUnderlineSpacing;
    }

    return titleY - y;
  }

  /// Draws subtitle block, returns height consumed.
  double _drawSubtitleBlock(
    PdfGraphics graphics,
    double y,
    double contentLeft,
    double contentWidth,
    GeniusPdfTitleAlignment alignment,
  ) {
    double subY = y;

    if (subtitle == null && subtitleAr == null) return 0;

    final pdfAlignment = _resolveTextAlignment(alignment);

    // Arabic subtitle
    if (subtitleAr != null) {
      graphics.drawString(
        subtitleAr!,
        baseFont,
        brush: style.subtitleStyle.toBrush(),
        bounds: Rect.fromLTWH(contentLeft, subY, contentWidth, 0),
        format: _textFormatDir(pdfAlignment, PdfTextDirection.rightToLeft),
      );
      subY += style.subtitleStyle.fontSize + 2;
    }

    // English subtitle
    if (subtitle != null) {
      graphics.drawString(
        subtitle!,
        baseFont,
        brush: style.subtitleStyle.toBrush(),
        bounds: Rect.fromLTWH(contentLeft, subY, contentWidth, 0),
        format: _textFormatDir(pdfAlignment, PdfTextDirection.leftToRight),
      );
      subY += style.subtitleStyle.fontSize + 2;
    }

    // Secondary subtitle
    final secSub = getSecondarySubtitle();
    if (secSub != null) {
      graphics.drawString(
        secSub,
        baseFont,
        brush: style.subtitleStyle.toBrush(),
        bounds: Rect.fromLTWH(contentLeft, subY, contentWidth, 0),
        format: _textFormat(alignment),
      );
      subY += style.subtitleStyle.fontSize + 2;
    }

    return subY - y;
  }

  /// Draws document number and reference, returns height consumed.
  double _drawDocumentInfo(
    PdfGraphics graphics,
    double y,
    double contentLeft,
    double contentWidth,
  ) {
    if (documentNumber == null && referenceNumber == null) return 0;

    double docY = y;
    final dateBrush = style.dateStyle?.toBrush() ??
        PdfSolidBrush(const Color(0xFF616161).toPdfColor());
    final fontSize = style.dateStyle?.fontSize ?? 9;

    if (documentNumber != null) {
      final label = getDocumentNumberLabel() ?? 'Doc No';
      graphics.drawString(
        '$label: $documentNumber',
        baseFont,
        brush: dateBrush,
        bounds: Rect.fromLTWH(contentLeft, docY, contentWidth, 0),
        format: _textFormat(style.showDateOnRight
            ? GeniusPdfTitleAlignment.end
            : GeniusPdfTitleAlignment.start),
      );
      docY += fontSize + 2;
    }

    if (referenceNumber != null) {
      final label = getReferenceLabel() ?? 'Ref';
      graphics.drawString(
        '$label: $referenceNumber',
        baseFont,
        brush: dateBrush,
        bounds: Rect.fromLTWH(contentLeft, docY, contentWidth, 0),
        format: _textFormat(style.showDateOnRight
            ? GeniusPdfTitleAlignment.end
            : GeniusPdfTitleAlignment.start),
      );
      docY += fontSize + 2;
    }

    return docY - y;
  }

  // -------------------------------------------------------------------------
  // Draw dispatcher
  // -------------------------------------------------------------------------

  /// Draws the header on a PDF page.
  ///
  /// Returns the height of the drawn header.
  double draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    GeniusPdfLogger.debug('Drawing report header: layout=$layout, '
        'title="$title", isRTL=$isRTL');

    double result;
    switch (layout) {
      case GeniusPdfReportHeaderLayout.compact:
        result = _drawCompactLayout(page, bounds);
        break;
      case GeniusPdfReportHeaderLayout.centered:
        result = _drawCenteredLayout(page, bounds);
        break;
      case GeniusPdfReportHeaderLayout.invoice:
        result = _drawInvoiceLayout(page, bounds);
        break;
      case GeniusPdfReportHeaderLayout.bilingualSplit:
        result = _drawBilingualSplitLayout(page, bounds);
        break;
      default:
        result = _drawStandardLayout(page, bounds);
        break;
    }

    // Enforce min/max height
    if (style.headerMinHeight != null && result < style.headerMinHeight!) {
      result = style.headerMinHeight!;
    }
    if (style.headerMaxHeight != null && result > style.headerMaxHeight!) {
      result = style.headerMaxHeight!;
    }

    GeniusPdfLogger.debug('Report header drawn: height=$result');
    return result;
  }

  // -------------------------------------------------------------------------
  // Standard layout
  // -------------------------------------------------------------------------

  double _drawStandardLayout(PdfPage page, Rect bounds) {
    final graphics = page.graphics;
    final contentLeft = bounds.left + style.padding.left;
    final contentRight = bounds.right - style.padding.right;
    final contentWidth = contentRight - contentLeft;

    _drawBackground(graphics, bounds);

    double currentY = bounds.top + style.padding.top;

    // --- Logo and company info row ---
    double logoSectionHeight = 0;
    double companySectionHeight = 0;

    // Calculate logo dimensions
    double logoWidth = 0;
    double logoHeight = 0;
    GeniusPdfImage? scaledLogo;
    if (company?.logo != null && showCompanyInfo) {
      scaledLogo = company!.logo!.scaledToFit(
        maxWidth: style.logoMaxWidth,
        maxHeight: style.logoMaxHeight,
      );
      logoWidth = scaledLogo.width;
      logoHeight = scaledLogo.height;
    }

    // Determine layout based on logo position
    final logoPos = style.logoPosition;

    if (logoPos == GeniusPdfLogoPosition.centerTop && scaledLogo != null) {
      // Logo centered above everything
      final logoX =
          _resolveLogoX(logoPos, contentLeft, contentRight, logoWidth);
      graphics.drawImage(
        PdfBitmap(scaledLogo.data),
        Rect.fromLTWH(logoX, currentY, logoWidth, logoHeight),
      );
      currentY += logoHeight + style.logoSpacing;
      logoSectionHeight = logoHeight + style.logoSpacing;
    }

    if (logoPos == GeniusPdfLogoPosition.background && scaledLogo != null) {
      // Logo as watermark in background
      final bgLogoWidth = contentWidth * 0.5;
      final scale = bgLogoWidth / scaledLogo.width;
      final bgLogoHeight = scaledLogo.height * scale;
      final logoX = contentLeft + (contentWidth - bgLogoWidth) / 2;
      final logoY = currentY +
          (bounds.height -
                  style.padding.top -
                  style.padding.bottom -
                  bgLogoHeight) /
              2;
      graphics.setTransparency(0.08);
      graphics.drawImage(
        PdfBitmap(scaledLogo.data),
        Rect.fromLTWH(logoX, logoY, bgLogoWidth, bgLogoHeight),
      );
      graphics.setTransparency(1.0);
    }

    // Side logo (start or end)
    final hasLogoOnSide = scaledLogo != null &&
        (logoPos == GeniusPdfLogoPosition.start ||
            logoPos == GeniusPdfLogoPosition.end ||
            logoPos == GeniusPdfLogoPosition.center);

    double companyAreaLeft = contentLeft;
    double companyAreaWidth = contentWidth;

    if (hasLogoOnSide && logoPos != GeniusPdfLogoPosition.center) {
      final logoX =
          _resolveLogoX(logoPos, contentLeft, contentRight, logoWidth);
      graphics.drawImage(
        PdfBitmap(scaledLogo.data),
        Rect.fromLTWH(logoX, currentY, logoWidth, logoHeight),
      );
      logoSectionHeight = logoHeight;

      // Adjust company area to avoid logo
      if (logoPos == GeniusPdfLogoPosition.start) {
        if (isRTL) {
          // Logo on right, company on left
          companyAreaWidth = contentWidth - logoWidth - style.logoSpacing;
        } else {
          // Logo on left, company on right
          companyAreaLeft = contentLeft + logoWidth + style.logoSpacing;
          companyAreaWidth = contentWidth - logoWidth - style.logoSpacing;
        }
      } else {
        // end
        if (isRTL) {
          // Logo on left, company on right
          companyAreaLeft = contentLeft + logoWidth + style.logoSpacing;
          companyAreaWidth = contentWidth - logoWidth - style.logoSpacing;
        } else {
          // Logo on right, company on left
          companyAreaWidth = contentWidth - logoWidth - style.logoSpacing;
        }
      }
    }

    // Draw company info in the company area
    if (showCompanyInfo && company != null) {
      companySectionHeight = _drawCompanyInfoBlock(
        graphics,
        companyAreaLeft,
        currentY,
        companyAreaWidth,
        style.companyInfoAlignment,
        isArabic: isRTL,
      );
    }

    // Advance past the taller of logo and company info
    final topRowHeight = logoSectionHeight > companySectionHeight
        ? logoSectionHeight
        : companySectionHeight;
    if (topRowHeight > 0) {
      currentY += topRowHeight + style.spacing;
    }

    // --- Title section ---
    final titleHeight = _drawTitleBlock(
      graphics,
      currentY,
      contentLeft,
      contentWidth,
      style.titleAlignment,
    );
    currentY += titleHeight;

    // --- Subtitle section ---
    final subtitleHeight = _drawSubtitleBlock(
      graphics,
      currentY,
      contentLeft,
      contentWidth,
      style.titleAlignment,
    );
    currentY += subtitleHeight;

    // --- Document info ---
    final docInfoHeight =
        _drawDocumentInfo(graphics, currentY, contentLeft, contentWidth);
    currentY += docInfoHeight;

    // --- Date section (drawn ABOVE the border with proper spacing) ---
    final dateHeight =
        _drawDateSection(graphics, currentY, contentLeft, contentRight);
    if (dateHeight > 0) {
      currentY += dateHeight + style.dateSpacing;
    } else {
      currentY += style.padding.bottom;
    }

    // --- CenterBottom logo ---
    if (logoPos == GeniusPdfLogoPosition.centerBottom && scaledLogo != null) {
      final logoX =
          _resolveLogoX(logoPos, contentLeft, contentRight, logoWidth);
      graphics.drawImage(
        PdfBitmap(scaledLogo.data),
        Rect.fromLTWH(logoX, currentY, logoWidth, logoHeight),
      );
      currentY += logoHeight + style.logoSpacing;
    }

    // --- Bottom border (BELOW date — no overlap) ---
    _drawBottomBorder(graphics, bounds, currentY);

    return currentY - bounds.top;
  }

  // -------------------------------------------------------------------------
  // Compact layout
  // -------------------------------------------------------------------------

  double _drawCompactLayout(PdfPage page, Rect bounds) {
    final graphics = page.graphics;
    final contentLeft = bounds.left + style.padding.left;
    final contentRight = bounds.right - style.padding.right;
    final contentWidth = contentRight - contentLeft;

    _drawBackground(graphics, bounds);

    double currentY = bounds.top + style.padding.top;

    // Logo on one side, title on other
    double logoWidth = 0;
    if (company?.logo != null) {
      final logo = company!.logo!.scaledToFit(
        maxWidth: style.logoMaxWidth * 0.7,
        maxHeight: style.logoMaxHeight * 0.7,
      );

      final logoX = _resolveLogoX(
          style.logoPosition, contentLeft, contentRight, logo.width);
      graphics.drawImage(
        PdfBitmap(logo.data),
        Rect.fromLTWH(logoX, currentY, logo.width, logo.height),
      );
      logoWidth = logo.width + style.logoSpacing;
    }

    // Title area (next to logo)
    double titleX;
    double titleWidth;
    if (style.logoPosition == GeniusPdfLogoPosition.start) {
      if (isRTL) {
        titleX = contentLeft;
        titleWidth = contentWidth - logoWidth;
      } else {
        titleX = contentLeft + logoWidth;
        titleWidth = contentWidth - logoWidth;
      }
    } else {
      if (isRTL) {
        titleX = contentLeft + logoWidth;
        titleWidth = contentWidth - logoWidth;
      } else {
        titleX = contentLeft;
        titleWidth = contentWidth - logoWidth;
      }
    }

    // Bilingual title
    final titleHeight = _drawTitleBlock(
      graphics,
      currentY,
      titleX,
      titleWidth,
      style.titleAlignment,
    );
    currentY += titleHeight;

    // Subtitle
    final subtitleHeight = _drawSubtitleBlock(
      graphics,
      currentY,
      titleX,
      titleWidth,
      style.titleAlignment,
    );
    currentY += subtitleHeight;

    // Date
    final dateHeight =
        _drawDateSection(graphics, currentY, contentLeft, contentRight);
    if (dateHeight > 0) {
      currentY += dateHeight + style.dateSpacing;
    } else {
      currentY += style.padding.bottom;
    }

    _drawBottomBorder(graphics, bounds, currentY);

    return currentY - bounds.top;
  }

  // -------------------------------------------------------------------------
  // Centered layout
  // -------------------------------------------------------------------------

  double _drawCenteredLayout(PdfPage page, Rect bounds) {
    final graphics = page.graphics;
    final contentLeft = bounds.left + style.padding.left;
    final contentRight = bounds.right - style.padding.right;
    final contentWidth = contentRight - contentLeft;

    _drawBackground(graphics, bounds);

    double currentY = bounds.top + style.padding.top;
    const centerAlign = GeniusPdfTitleAlignment.center;

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
      currentY += logo.height + style.logoSpacing;
    }

    // Company name centered
    if (showCompanyInfo && company != null) {
      graphics.drawString(
        company!.getName(isArabic: isRTL),
        boldFont,
        brush: style.companyNameStyle.toBrush(),
        bounds: Rect.fromLTWH(contentLeft, currentY, contentWidth, 0),
        format: _textFormatDir(
            PdfTextAlignment.center,
            isRTL
                ? PdfTextDirection.rightToLeft
                : PdfTextDirection.leftToRight),
      );
      currentY += style.companyNameStyle.fontSize + style.spacing;
    }

    // Title
    final titleHeight = _drawTitleBlock(
      graphics,
      currentY,
      contentLeft,
      contentWidth,
      centerAlign,
    );
    currentY += titleHeight;

    // Subtitle
    final subtitleHeight = _drawSubtitleBlock(
      graphics,
      currentY,
      contentLeft,
      contentWidth,
      centerAlign,
    );
    currentY += subtitleHeight;

    // Date
    final dateHeight =
        _drawDateSection(graphics, currentY, contentLeft, contentRight);
    if (dateHeight > 0) {
      currentY += dateHeight + style.dateSpacing;
    } else {
      currentY += style.padding.bottom;
    }

    _drawBottomBorder(graphics, bounds, currentY);

    return currentY - bounds.top;
  }

  // -------------------------------------------------------------------------
  // Invoice layout
  // -------------------------------------------------------------------------

  double _drawInvoiceLayout(PdfPage page, Rect bounds) {
    final graphics = page.graphics;
    final contentLeft = bounds.left + style.padding.left;
    final contentRight = bounds.right - style.padding.right;
    final contentWidth = contentRight - contentLeft;

    _drawBackground(graphics, bounds);

    double currentY = bounds.top + style.padding.top;

    // Logo on start side
    double logoWidth = 0;
    double logoHeight = 0;
    if (company?.logo != null) {
      final logo = company!.logo!.scaledToFit(
        maxWidth: style.logoMaxWidth,
        maxHeight: style.logoMaxHeight,
      );
      final logoX = _resolveLogoX(
          style.logoPosition, contentLeft, contentRight, logo.width);
      graphics.drawImage(
        PdfBitmap(logo.data),
        Rect.fromLTWH(logoX, currentY, logo.width, logo.height),
      );
      logoWidth = logo.width;
      logoHeight = logo.height;
    }

    // Company info on the opposite side of logo
    final companyAlignment = style.companyInfoAlignment;
    double companyAreaLeft = contentLeft;
    double companyAreaWidth = contentWidth;
    if (logoWidth > 0) {
      if (style.logoPosition == GeniusPdfLogoPosition.start) {
        if (isRTL) {
          companyAreaWidth = contentWidth - logoWidth - style.logoSpacing;
        } else {
          companyAreaLeft = contentLeft + logoWidth + style.logoSpacing;
          companyAreaWidth = contentWidth - logoWidth - style.logoSpacing;
        }
      } else {
        if (isRTL) {
          companyAreaLeft = contentLeft + logoWidth + style.logoSpacing;
          companyAreaWidth = contentWidth - logoWidth - style.logoSpacing;
        } else {
          companyAreaWidth = contentWidth - logoWidth - style.logoSpacing;
        }
      }
    }

    double companySectionHeight = 0;
    if (showCompanyInfo && company != null) {
      companySectionHeight = _drawCompanyInfoBlock(
        graphics,
        companyAreaLeft,
        currentY,
        companyAreaWidth,
        companyAlignment,
        isArabic: isRTL,
      );
    }

    final topRowHeight =
        logoHeight > companySectionHeight ? logoHeight : companySectionHeight;
    if (topRowHeight > 0) {
      currentY += topRowHeight + style.spacing;
    }

    // Title centered
    final titleHeight = _drawTitleBlock(
      graphics,
      currentY,
      contentLeft,
      contentWidth,
      style.titleAlignment,
    );
    currentY += titleHeight;

    // Subtitle
    final subtitleHeight = _drawSubtitleBlock(
      graphics,
      currentY,
      contentLeft,
      contentWidth,
      style.titleAlignment,
    );
    currentY += subtitleHeight;

    // Document info (invoice number, reference)
    final docInfoHeight =
        _drawDocumentInfo(graphics, currentY, contentLeft, contentWidth);
    currentY += docInfoHeight;

    // Date
    final dateHeight =
        _drawDateSection(graphics, currentY, contentLeft, contentRight);
    if (dateHeight > 0) {
      currentY += dateHeight + style.dateSpacing;
    } else {
      currentY += style.padding.bottom;
    }

    _drawBottomBorder(graphics, bounds, currentY);

    return currentY - bounds.top;
  }

  // -------------------------------------------------------------------------
  // Bilingual Split layout
  // Arabic company info on right, English on left, logo in center
  // -------------------------------------------------------------------------

  double _drawBilingualSplitLayout(PdfPage page, Rect bounds) {
    final graphics = page.graphics;
    final contentLeft = bounds.left + style.padding.left;
    final contentRight = bounds.right - style.padding.right;
    final contentWidth = contentRight - contentLeft;

    _drawBackground(graphics, bounds);

    double currentY = bounds.top + style.padding.top;

    // Calculate three columns: [English left] [Logo center] [Arabic right]
    double logoWidth = 0;
    double logoHeight = 0;
    GeniusPdfImage? scaledLogo;
    if (company?.logo != null) {
      scaledLogo = company!.logo!.scaledToFit(
        maxWidth: style.logoMaxWidth,
        maxHeight: style.logoMaxHeight,
      );
      logoWidth = scaledLogo.width;
      logoHeight = scaledLogo.height;
    }

    final logoAreaWidth = logoWidth > 0 ? logoWidth + style.logoSpacing * 2 : 0;
    final sideWidth = (contentWidth - logoAreaWidth) / 2;

    // English company info on the LEFT
    double enHeight = 0;
    if (showCompanyInfo && company != null) {
      enHeight = _drawCompanyInfoBlock(
        graphics,
        contentLeft,
        currentY,
        sideWidth,
        GeniusPdfTitleAlignment.start,
        isArabic: false,
      );
    }

    // Logo in the CENTER
    if (scaledLogo != null) {
      final logoX = contentLeft + sideWidth + style.logoSpacing;
      graphics.drawImage(
        PdfBitmap(scaledLogo.data),
        Rect.fromLTWH(logoX, currentY, logoWidth, logoHeight),
      );
    }

    // Arabic company info on the RIGHT
    double arHeight = 0;
    if (showCompanyInfo && company != null) {
      final arX = contentLeft + sideWidth + logoAreaWidth;
      arHeight = _drawCompanyInfoBlock(
        graphics,
        arX,
        currentY,
        sideWidth,
        GeniusPdfTitleAlignment.end,
        isArabic: true,
      );
    }

    // Advance past the tallest column
    double topRowHeight = enHeight > arHeight ? enHeight : arHeight;
    if (logoHeight > topRowHeight) topRowHeight = logoHeight;
    if (topRowHeight > 0) {
      currentY += topRowHeight + style.spacing;
    }

    // Title centered (bilingual)
    const centerAlign = GeniusPdfTitleAlignment.center;
    final titleHeight = _drawTitleBlock(
      graphics,
      currentY,
      contentLeft,
      contentWidth,
      centerAlign,
    );
    currentY += titleHeight;

    // Subtitle
    final subtitleHeight = _drawSubtitleBlock(
      graphics,
      currentY,
      contentLeft,
      contentWidth,
      centerAlign,
    );
    currentY += subtitleHeight;

    // Document info
    final docInfoHeight =
        _drawDocumentInfo(graphics, currentY, contentLeft, contentWidth);
    currentY += docInfoHeight;

    // Date
    final dateHeight =
        _drawDateSection(graphics, currentY, contentLeft, contentRight);
    if (dateHeight > 0) {
      currentY += dateHeight + style.dateSpacing;
    } else {
      currentY += style.padding.bottom;
    }

    _drawBottomBorder(graphics, bounds, currentY);

    return currentY - bounds.top;
  }

  // -------------------------------------------------------------------------
  // Utilities
  // -------------------------------------------------------------------------

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}

// ---------------------------------------------------------------------------
// Layout enum
// ---------------------------------------------------------------------------

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

  /// Bilingual split: English info on left, logo in center, Arabic info on right.
  bilingualSplit,

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
