part of '../pdf_report_header.dart';

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
// Header Info Group
// ---------------------------------------------------------------------------

/// A group of related header information items.
///
/// Used to organize header content into logical sections like:
/// - Company registration details (VAT, CR, License)
/// - Contact information (Phone, Email, Website)
/// - Address information (Street, City, Country)
///
/// ## Example
/// ```dart
/// GeniusPdfHeaderInfoGroup.registration(
///   vatNumber: '300123456789003',
///   crNumber: '1010123456',
///   licenseNumber: 'LIC-001',
/// )
/// ```
class GeniusPdfHeaderInfoGroup {
  const GeniusPdfHeaderInfoGroup({
    this.title,
    this.titleAr,
    required this.items,
    this.showTitle = false,
    this.titleStyle,
    this.itemStyle,
    this.spacing = 2.0,
    this.labelValueSeparator = ': ',
    this.groupColor,
  });

  /// Creates a registration info group (VAT, CR, License).
  factory GeniusPdfHeaderInfoGroup.registration({
    String? vatNumber,
    String? crNumber,
    String? licenseNumber,
    bool showTitle = false,
  }) {
    final items = <GeniusPdfHeaderInfoItem>[];
    if (vatNumber != null && vatNumber.isNotEmpty) {
      items.add(GeniusPdfHeaderInfoItem(
        label: 'VAT No',
        labelAr: 'الرقم الضريبي',
        value: vatNumber,
      ));
    }
    if (crNumber != null && crNumber.isNotEmpty) {
      items.add(GeniusPdfHeaderInfoItem(
        label: 'CR No',
        labelAr: 'السجل التجاري',
        value: crNumber,
      ));
    }
    if (licenseNumber != null && licenseNumber.isNotEmpty) {
      items.add(GeniusPdfHeaderInfoItem(
        label: 'License No',
        labelAr: 'رقم الترخيص',
        value: licenseNumber,
      ));
    }
    return GeniusPdfHeaderInfoGroup(
      title: 'Registration',
      titleAr: 'التسجيل',
      items: items,
      showTitle: showTitle,
    );
  }

  /// Creates a contact info group (Phone, Email, Website).
  factory GeniusPdfHeaderInfoGroup.contact({
    String? phone,
    String? phone2,
    String? email,
    String? website,
    String? fax,
    bool showTitle = false,
  }) {
    final items = <GeniusPdfHeaderInfoItem>[];
    if (phone != null && phone.isNotEmpty) {
      items.add(GeniusPdfHeaderInfoItem(
        label: 'Phone',
        labelAr: 'الهاتف',
        value: phone,
      ));
    }
    if (phone2 != null && phone2.isNotEmpty) {
      items.add(GeniusPdfHeaderInfoItem(
        label: 'Phone 2',
        labelAr: 'الهاتف 2',
        value: phone2,
      ));
    }
    if (fax != null && fax.isNotEmpty) {
      items.add(GeniusPdfHeaderInfoItem(
        label: 'Fax',
        labelAr: 'الفاكس',
        value: fax,
      ));
    }
    if (email != null && email.isNotEmpty) {
      items.add(GeniusPdfHeaderInfoItem(
        label: 'Email',
        labelAr: 'البريد',
        value: email,
      ));
    }
    if (website != null && website.isNotEmpty) {
      items.add(GeniusPdfHeaderInfoItem(
        label: 'Website',
        labelAr: 'الموقع',
        value: website,
      ));
    }
    return GeniusPdfHeaderInfoGroup(
      title: 'Contact',
      titleAr: 'التواصل',
      items: items,
      showTitle: showTitle,
    );
  }

  /// Creates an address info group.
  factory GeniusPdfHeaderInfoGroup.address({
    String? address,
    String? addressAr,
    String? city,
    String? cityAr,
    String? country,
    String? countryAr,
    String? postalCode,
    bool showTitle = false,
  }) {
    final items = <GeniusPdfHeaderInfoItem>[];
    if (address != null && address.isNotEmpty) {
      items.add(GeniusPdfHeaderInfoItem(
        label: '',
        labelAr: '',
        value: address,
        valueAr: addressAr,
        showLabel: false,
      ));
    }
    final locationParts = <String>[];
    final locationPartsAr = <String>[];
    if (city != null && city.isNotEmpty) {
      locationParts.add(city);
      locationPartsAr.add(cityAr ?? city);
    }
    if (country != null && country.isNotEmpty) {
      locationParts.add(country);
      locationPartsAr.add(countryAr ?? country);
    }
    if (postalCode != null && postalCode.isNotEmpty) {
      locationParts.add(postalCode);
      locationPartsAr.add(postalCode);
    }
    if (locationParts.isNotEmpty) {
      items.add(GeniusPdfHeaderInfoItem(
        label: '',
        labelAr: '',
        value: locationParts.join(', '),
        valueAr: locationPartsAr.join('، '),
        showLabel: false,
      ));
    }
    return GeniusPdfHeaderInfoGroup(
      title: 'Address',
      titleAr: 'العنوان',
      items: items,
      showTitle: showTitle,
    );
  }

  /// Creates a custom info group with provided items.
  const GeniusPdfHeaderInfoGroup.custom({
    required this.title,
    this.titleAr,
    required this.items,
    this.showTitle = true,
    this.titleStyle,
    this.itemStyle,
    this.spacing = 2.0,
    this.labelValueSeparator = ': ',
    this.groupColor,
  });

  /// Group title (English).
  final String? title;

  /// Group title (Arabic).
  final String? titleAr;

  /// Items in this group.
  final List<GeniusPdfHeaderInfoItem> items;

  /// Whether to show the group title.
  final bool showTitle;

  /// Style for group title.
  final GeniusPdfTextStyle? titleStyle;

  /// Style for items.
  final GeniusPdfTextStyle? itemStyle;

  /// Spacing between items.
  final double spacing;

  /// Separator between label and value.
  final String labelValueSeparator;

  /// Optional color for this group.
  final Color? groupColor;

  /// Gets the display title based on locale.
  String? getTitle({bool isArabic = false}) {
    if (isArabic && titleAr != null) return titleAr;
    return title;
  }

  /// Checks if the group has any items.
  bool get isEmpty => items.isEmpty;

  /// Checks if the group has items.
  bool get isNotEmpty => items.isNotEmpty;
}

/// A single header information item (label-value pair).
class GeniusPdfHeaderInfoItem {
  const GeniusPdfHeaderInfoItem({
    required this.label,
    this.labelAr,
    required this.value,
    this.valueAr,
    this.showLabel = true,
    this.icon,
    this.color,
  });

  /// Label text (English).
  final String label;

  /// Label text (Arabic).
  final String? labelAr;

  /// Value text.
  final String value;

  /// Value text (Arabic) - if different from English.
  final String? valueAr;

  /// Whether to show the label.
  final bool showLabel;

  /// Optional icon identifier.
  final String? icon;

  /// Optional color for this item.
  final Color? color;

  /// Gets the display label based on locale.
  String getLabel({bool isArabic = false}) {
    if (isArabic && labelAr != null) return labelAr!;
    return label;
  }

  /// Gets the display value based on locale.
  String getValue({bool isArabic = false}) {
    if (isArabic && valueAr != null) return valueAr!;
    return value;
  }

  /// Gets the formatted string (label: value or just value).
  String getFormatted({bool isArabic = false, String separator = ': '}) {
    if (!showLabel || label.isEmpty) {
      return getValue(isArabic: isArabic);
    }
    return '${getLabel(isArabic: isArabic)}$separator${getValue(isArabic: isArabic)}';
  }
}

/// Layout dimension calculator for header elements.
///
/// Provides accurate calculations for header element positioning
/// based on content size and available space.
class GeniusPdfHeaderLayoutCalculator {
  const GeniusPdfHeaderLayoutCalculator({
    this.minColumnWidth = 100.0,
    this.maxColumnWidth = 300.0,
    this.columnSpacing = 10.0,
    this.rowSpacing = 4.0,
    this.logoToContentSpacing = 12.0,
    this.sectionSpacing = 8.0,
  });

  /// Minimum column width.
  final double minColumnWidth;

  /// Maximum column width.
  final double maxColumnWidth;

  /// Spacing between columns.
  final double columnSpacing;

  /// Spacing between rows.
  final double rowSpacing;

  /// Spacing between logo and content.
  final double logoToContentSpacing;

  /// Spacing between sections.
  final double sectionSpacing;

  /// Calculates optimal column widths for bilingual layout.
  ({double leftWidth, double centerWidth, double rightWidth})
      calculateBilingualColumns({
    required double totalWidth,
    double logoWidth = 0,
    bool hasLogo = false,
  }) {
    final logoArea = hasLogo ? logoWidth + logoToContentSpacing * 2 : 0;
    final availableWidth = totalWidth - logoArea;
    final sideWidth =
        (availableWidth / 2)
            .clamp(minColumnWidth, maxColumnWidth)
            .toDouble();

    return (
      leftWidth: sideWidth,
      centerWidth: logoArea.toDouble(),
      rightWidth: sideWidth,
    );
  }

  /// Calculates optimal column widths for standard layout.
  ({double logoWidth, double contentWidth}) calculateStandardColumns({
    required double totalWidth,
    double logoWidth = 0,
    bool hasLogo = false,
  }) {
    if (!hasLogo || logoWidth <= 0) {
      return (logoWidth: 0, contentWidth: totalWidth);
    }

    final contentWidth = totalWidth - logoWidth - logoToContentSpacing;
    return (
      logoWidth: logoWidth,
      contentWidth:
          contentWidth.clamp(minColumnWidth, totalWidth).toDouble(),
    );
  }

  /// Estimates height for a text block.
  double estimateTextHeight({
    required int lineCount,
    required double fontSize,
    double lineSpacing = 2.0,
  }) {
    if (lineCount <= 0) return 0;
    return (fontSize + lineSpacing) * lineCount;
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
