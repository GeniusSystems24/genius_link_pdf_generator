
import '../src/components/components.dart';
import '../src/domain/erp/erp.dart';

/// Shared compatibility helpers for S09 legacy template adapters.
///
/// They are intentionally kept outside Quotation/PurchaseOrder/TaxInvoice so
/// the three migrated templates do not duplicate company/currency/address
/// mapping or amount-in-words support.
class GeniusErpLegacyCompatibility {
  const GeniusErpLegacyCompatibility._();

  static ErpCurrency currency(String code) {
    final normalized = code.trim().toUpperCase();
    // Legacy template totals historically rendered two decimals. Preserve that
    // public behavior even for currencies whose modern domain precision may be
    // configured differently by new applications.
    return ErpCurrency(
      code: normalized.isEmpty ? 'SAR' : normalized,
      symbol: normalized.isEmpty ? 'SAR' : normalized,
      precision: 2,
    );
  }

  static ErpOrganization organization(
    GeniusPdfCompanyInfo company,
  ) {
    return ErpOrganization(
      id: company.crNumber ??
          company.vatNumber ??
          company.name,
      legalName: company.name,
      nameAr: company.nameAr,
      tradeName: company.slogan,
      taxIdentity: company.vatNumber == null
          ? null
          : ErpTaxIdentity(
              taxNumber: company.vatNumber!,
              legalRegistrationNumber: company.crNumber,
            ),
      registeredAddress: _address(
        line1: company.address,
        line1Ar: company.addressAr,
        city: company.city,
        cityAr: company.cityAr,
        postalCode: company.postalCode,
        countryCode: company.country,
        role: ErpAddressRole.registered,
      ),
      contacts: [
        ErpContactMetadata(
          phone: company.phone,
          email: company.email,
          website: company.website,
        ),
      ],
    );
  }

  static ErpParty party({
    String? id,
    required String name,
    String? nameAr,
    String? registrationNumber,
    String? taxNumber,
    String? address,
    String? addressAr,
    String? phone,
    String? email,
    String? contactName,
    ErpAddressRole addressRole = ErpAddressRole.billing,
  }) {
    final mappedAddress = _address(
      line1: address,
      line1Ar: addressAr,
      role: addressRole,
    );

    final contact = ErpContactMetadata(
      contactName: contactName,
      phone: phone,
      email: email,
    );

    return ErpParty(
      id: id,
      name: name,
      nameAr: nameAr,
      registrationNumber: registrationNumber,
      taxIdentity: taxNumber == null
          ? null
          : ErpTaxIdentity(taxNumber: taxNumber),
      addresses: mappedAddress == null
          ? const []
          : [mappedAddress],
      contacts: contact.isEmpty ? const [] : [contact],
    );
  }

  static ErpAddress? address({
    String? line1,
    String? line1Ar,
    String? city,
    String? cityAr,
    String? postalCode,
    String? countryCode,
    ErpAddressRole role = ErpAddressRole.other,
    String? attentionTo,
  }) {
    return _address(
      line1: line1,
      line1Ar: line1Ar,
      city: city,
      cityAr: cityAr,
      postalCode: postalCode,
      countryCode: countryCode,
      role: role,
      attentionTo: attentionTo,
    );
  }

  static ErpAddress? _address({
    String? line1,
    String? line1Ar,
    String? city,
    String? cityAr,
    String? postalCode,
    String? countryCode,
    ErpAddressRole role = ErpAddressRole.other,
    String? attentionTo,
  }) {
    final effectiveLine = line1 ?? line1Ar;
    final effectiveCity = city ?? cityAr;
    if ((effectiveLine == null || effectiveLine.trim().isEmpty) &&
        (effectiveCity == null || effectiveCity.trim().isEmpty) &&
        (postalCode == null || postalCode.trim().isEmpty) &&
        (countryCode == null || countryCode.trim().isEmpty) &&
        (attentionTo == null || attentionTo.trim().isEmpty)) {
      return null;
    }

    return ErpAddress(
      role: role,
      line1: effectiveLine,
      line2: line1 != null && line1Ar != null ? line1Ar : null,
      city: effectiveCity,
      postalCode: postalCode,
      countryCode: countryCode,
      attentionTo: attentionTo,
    );
  }
}

/// Shared S09 amount-in-words compatibility service.
///
/// This keeps TaxInvoice amount-in-words functional after the rendering helper
/// migration without embedding number conversion inside the template class.
class GeniusErpLegacyAmountInWords {
  const GeniusErpLegacyAmountInWords._();

  static String english(ErpMoney amount) {
    final absolute = amount.abs();
    final whole = absolute.toDouble().floor();
    final fraction =
        ((absolute.toDouble() - whole) * 100).round();
    final sign = amount.isNegative ? 'Minus ' : '';
    final main = _englishWhole(whole);
    final currency = _currencyName(amount.currency.code);
    final sub = _subCurrencyName(amount.currency.code);

    if (fraction > 0) {
      return '$sign$main $currency and '
          '${_englishWhole(fraction)} $sub Only';
    }
    return '$sign$main $currency Only';
  }

  static String arabic(ErpMoney amount) {
    final absolute = amount.abs();
    final whole = absolute.toDouble().floor();
    final fraction =
        ((absolute.toDouble() - whole) * 100).round();
    final sign = amount.isNegative ? 'سالب ' : '';
    final main = _arabicWhole(whole);
    final currency = _arabicCurrencyName(amount.currency.code);
    final sub = _arabicSubCurrencyName(amount.currency.code);

    if (fraction > 0) {
      return '$sign$main $currency و '
          '${_arabicWhole(fraction)} $sub لا غير';
    }
    return '$sign$main $currency لا غير';
  }

  static String _englishWhole(int number) {
    if (number == 0) return 'Zero';

    const ones = [
      '',
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine',
      'Ten',
      'Eleven',
      'Twelve',
      'Thirteen',
      'Fourteen',
      'Fifteen',
      'Sixteen',
      'Seventeen',
      'Eighteen',
      'Nineteen',
    ];
    const tens = [
      '',
      '',
      'Twenty',
      'Thirty',
      'Forty',
      'Fifty',
      'Sixty',
      'Seventy',
      'Eighty',
      'Ninety',
    ];

    String convert(int n) {
      if (n == 0) return '';
      if (n < 20) return ones[n];
      if (n < 100) {
        final rest = n % 10;
        return '${tens[n ~/ 10]}'
            '${rest == 0 ? '' : ' ${ones[rest]}'}';
      }
      if (n < 1000) {
        final rest = n % 100;
        return '${ones[n ~/ 100]} Hundred'
            '${rest == 0 ? '' : ' and ${convert(rest)}'}';
      }
      if (n < 1000000) {
        final rest = n % 1000;
        return '${convert(n ~/ 1000)} Thousand'
            '${rest == 0 ? '' : ' ${convert(rest)}'}';
      }
      if (n < 1000000000) {
        final rest = n % 1000000;
        return '${convert(n ~/ 1000000)} Million'
            '${rest == 0 ? '' : ' ${convert(rest)}'}';
      }
      final rest = n % 1000000000;
      return '${convert(n ~/ 1000000000)} Billion'
          '${rest == 0 ? '' : ' ${convert(rest)}'}';
    }

    return convert(number);
  }

  static String _arabicWhole(int number) {
    if (number == 0) return 'صفر';

    const ones = [
      '',
      'واحد',
      'اثنان',
      'ثلاثة',
      'أربعة',
      'خمسة',
      'ستة',
      'سبعة',
      'ثمانية',
      'تسعة',
      'عشرة',
      'أحد عشر',
      'اثنا عشر',
      'ثلاثة عشر',
      'أربعة عشر',
      'خمسة عشر',
      'ستة عشر',
      'سبعة عشر',
      'ثمانية عشر',
      'تسعة عشر',
    ];
    const tens = [
      '',
      '',
      'عشرون',
      'ثلاثون',
      'أربعون',
      'خمسون',
      'ستون',
      'سبعون',
      'ثمانون',
      'تسعون',
    ];
    const hundreds = [
      '',
      'مائة',
      'مائتان',
      'ثلاثمائة',
      'أربعمائة',
      'خمسمائة',
      'ستمائة',
      'سبعمائة',
      'ثمانمائة',
      'تسعمائة',
    ];

    String underThousand(int n) {
      if (n == 0) return '';
      final parts = <String>[];
      final h = n ~/ 100;
      final rest = n % 100;
      if (h > 0) parts.add(hundreds[h]);
      if (rest > 0) {
        if (rest < 20) {
          parts.add(ones[rest]);
        } else {
          final one = rest % 10;
          final ten = rest ~/ 10;
          if (one > 0) {
            parts.add('${ones[one]} و ${tens[ten]}');
          } else {
            parts.add(tens[ten]);
          }
        }
      }
      return parts.join(' و ');
    }

    String convert(int n) {
      if (n < 1000) return underThousand(n);

      final groups = <String>[];
      final billions = n ~/ 1000000000;
      final millions = (n ~/ 1000000) % 1000;
      final thousands = (n ~/ 1000) % 1000;
      final rest = n % 1000;

      if (billions > 0) {
        groups.add(
          billions == 1
              ? 'مليار'
              : '${underThousand(billions)} مليار',
        );
      }
      if (millions > 0) {
        groups.add(
          millions == 1
              ? 'مليون'
              : '${underThousand(millions)} مليون',
        );
      }
      if (thousands > 0) {
        groups.add(
          thousands == 1
              ? 'ألف'
              : '${underThousand(thousands)} ألف',
        );
      }
      if (rest > 0) groups.add(underThousand(rest));

      return groups.join(' و ');
    }

    return convert(number);
  }

  static String _currencyName(String code) {
    const names = {
      'SAR': 'Saudi Riyals',
      'USD': 'US Dollars',
      'EUR': 'Euros',
      'GBP': 'British Pounds',
      'AED': 'UAE Dirhams',
      'KWD': 'Kuwaiti Dinars',
      'BHD': 'Bahraini Dinars',
      'OMR': 'Omani Rials',
      'QAR': 'Qatari Riyals',
      'EGP': 'Egyptian Pounds',
      'JOD': 'Jordanian Dinars',
    };
    return names[code] ?? code;
  }

  static String _subCurrencyName(String code) {
    const names = {
      'SAR': 'Halalas',
      'USD': 'Cents',
      'EUR': 'Cents',
      'GBP': 'Pence',
      'AED': 'Fils',
      'KWD': 'Fils',
      'BHD': 'Fils',
      'OMR': 'Baisas',
      'QAR': 'Dirhams',
      'EGP': 'Piastres',
      'JOD': 'Fils',
    };
    return names[code] ?? 'units';
  }

  static String _arabicCurrencyName(String code) {
    const names = {
      'SAR': 'ريالاً سعودياً',
      'USD': 'دولاراً أمريكياً',
      'EUR': 'يورو',
      'GBP': 'جنيهاً إسترلينياً',
      'AED': 'درهماً إماراتياً',
      'KWD': 'ديناراً كويتياً',
      'BHD': 'ديناراً بحرينياً',
      'OMR': 'ريالاً عمانياً',
      'QAR': 'ريالاً قطرياً',
      'EGP': 'جنيهاً مصرياً',
      'JOD': 'ديناراً أردنياً',
    };
    return names[code] ?? code;
  }

  static String _arabicSubCurrencyName(String code) {
    const names = {
      'SAR': 'هللة',
      'USD': 'سنتاً',
      'EUR': 'سنتاً',
      'GBP': 'بنساً',
      'AED': 'فلساً',
      'KWD': 'فلساً',
      'BHD': 'فلساً',
      'OMR': 'بيسة',
      'QAR': 'درهماً',
      'EGP': 'قرشاً',
      'JOD': 'فلساً',
    };
    return names[code] ?? '';
  }
}
