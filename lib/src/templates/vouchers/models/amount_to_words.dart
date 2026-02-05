/// Utility for converting numeric amounts to Arabic and English words.
library;

/// Currency information for amount-to-words conversion.
class CurrencyInfo {
  const CurrencyInfo({
    required this.nameEn,
    required this.nameAr,
    required this.subunitEn,
    required this.subunitAr,
    this.decimalPlaces = 2,
  });

  final String nameEn;
  final String nameAr;
  final String subunitEn;
  final String subunitAr;
  final int decimalPlaces;
}

/// Converts numeric amounts to Arabic and English words.
class AmountToWords {
  AmountToWords._();

  /// Supported currencies.
  static const Map<String, CurrencyInfo> currencies = {
    'SAR': CurrencyInfo(
      nameEn: 'Riyal',
      nameAr: 'ريال',
      subunitEn: 'Halala',
      subunitAr: 'هللة',
    ),
    'USD': CurrencyInfo(
      nameEn: 'Dollar',
      nameAr: 'دولار',
      subunitEn: 'Cent',
      subunitAr: 'سنت',
    ),
    'EUR': CurrencyInfo(
      nameEn: 'Euro',
      nameAr: 'يورو',
      subunitEn: 'Cent',
      subunitAr: 'سنت',
    ),
    'GBP': CurrencyInfo(
      nameEn: 'Pound',
      nameAr: 'جنيه',
      subunitEn: 'Penny',
      subunitAr: 'بنس',
    ),
    'AED': CurrencyInfo(
      nameEn: 'Dirham',
      nameAr: 'درهم',
      subunitEn: 'Fils',
      subunitAr: 'فلس',
    ),
    'KWD': CurrencyInfo(
      nameEn: 'Dinar',
      nameAr: 'دينار',
      subunitEn: 'Fils',
      subunitAr: 'فلس',
      decimalPlaces: 3,
    ),
    'QAR': CurrencyInfo(
      nameEn: 'Riyal',
      nameAr: 'ريال',
      subunitEn: 'Dirham',
      subunitAr: 'درهم',
    ),
    'BHD': CurrencyInfo(
      nameEn: 'Dinar',
      nameAr: 'دينار',
      subunitEn: 'Fils',
      subunitAr: 'فلس',
      decimalPlaces: 3,
    ),
    'OMR': CurrencyInfo(
      nameEn: 'Riyal',
      nameAr: 'ريال',
      subunitEn: 'Baisa',
      subunitAr: 'بيسة',
      decimalPlaces: 3,
    ),
    'EGP': CurrencyInfo(
      nameEn: 'Pound',
      nameAr: 'جنيه',
      subunitEn: 'Piastre',
      subunitAr: 'قرش',
    ),
    'JOD': CurrencyInfo(
      nameEn: 'Dinar',
      nameAr: 'دينار',
      subunitEn: 'Fils',
      subunitAr: 'فلس',
      decimalPlaces: 3,
    ),
  };

  // ── English ──

  static const _onesEn = [
    '', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine',
    'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen',
    'Seventeen', 'Eighteen', 'Nineteen',
  ];

  static const _tensEn = [
    '', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety',
  ];

  static const _scalesEn = ['', 'Thousand', 'Million', 'Billion', 'Trillion'];

  /// Converts an integer to English words.
  static String _intToEnglish(int number) {
    if (number == 0) return 'Zero';
    if (number < 0) return 'Negative ${_intToEnglish(-number)}';

    final parts = <String>[];
    var n = number;
    var scaleIndex = 0;

    while (n > 0) {
      final chunk = n % 1000;
      if (chunk > 0) {
        final chunkStr = _chunkToEnglish(chunk);
        if (scaleIndex > 0) {
          parts.insert(0, '$chunkStr ${_scalesEn[scaleIndex]}');
        } else {
          parts.insert(0, chunkStr);
        }
      }
      n ~/= 1000;
      scaleIndex++;
    }

    return parts.join(' ');
  }

  static String _chunkToEnglish(int n) {
    if (n == 0) return '';
    if (n < 20) return _onesEn[n];
    if (n < 100) {
      final ten = _tensEn[n ~/ 10];
      final one = n % 10 > 0 ? '-${_onesEn[n % 10]}' : '';
      return '$ten$one';
    }
    final hundred = '${_onesEn[n ~/ 100]} Hundred';
    final remainder = n % 100;
    if (remainder == 0) return hundred;
    return '$hundred and ${_chunkToEnglish(remainder)}';
  }

  /// Converts amount to English words with currency.
  static String toEnglish(double amount, {String currency = 'SAR'}) {
    final info = currencies[currency];
    final currencyName = info?.nameEn ?? currency;
    final subunitName = info?.subunitEn ?? 'cents';
    final decPlaces = info?.decimalPlaces ?? 2;

    final whole = amount.truncate();
    final fraction = ((amount - whole) * _pow10(decPlaces)).round();

    var result = '${_intToEnglish(whole)} $currencyName';
    if (fraction > 0) {
      result += ' and ${_intToEnglish(fraction)} $subunitName';
    }
    return '$result Only';
  }

  // ── Arabic ──

  static const _onesAr = [
    '', 'واحد', 'اثنان', 'ثلاثة', 'أربعة', 'خمسة', 'ستة', 'سبعة', 'ثمانية', 'تسعة',
    'عشرة', 'أحد عشر', 'اثنا عشر', 'ثلاثة عشر', 'أربعة عشر', 'خمسة عشر',
    'ستة عشر', 'سبعة عشر', 'ثمانية عشر', 'تسعة عشر',
  ];

  static const _tensAr = [
    '', '', 'عشرون', 'ثلاثون', 'أربعون', 'خمسون', 'ستون', 'سبعون', 'ثمانون', 'تسعون',
  ];

  static const _hundredsAr = [
    '', 'مائة', 'مائتان', 'ثلاثمائة', 'أربعمائة', 'خمسمائة',
    'ستمائة', 'سبعمائة', 'ثمانمائة', 'تسعمائة',
  ];

  /// Converts an integer to Arabic words.
  static String _intToArabic(int number) {
    if (number == 0) return 'صفر';
    if (number < 0) return 'سالب ${_intToArabic(-number)}';

    final parts = <String>[];
    var n = number;

    // Trillions
    if (n >= 1000000000000) {
      parts.add('${_chunkToArabic(n ~/ 1000000000000)} تريليون');
      n %= 1000000000000;
    }
    // Billions
    if (n >= 1000000000) {
      final b = n ~/ 1000000000;
      parts.add(b == 1 ? 'مليار' : b == 2 ? 'ملياران' : '${_chunkToArabic(b)} مليارات');
      n %= 1000000000;
    }
    // Millions
    if (n >= 1000000) {
      final m = n ~/ 1000000;
      parts.add(m == 1 ? 'مليون' : m == 2 ? 'مليونان' : '${_chunkToArabic(m)} ملايين');
      n %= 1000000;
    }
    // Thousands
    if (n >= 1000) {
      final t = n ~/ 1000;
      if (t == 1) {
        parts.add('ألف');
      } else if (t == 2) {
        parts.add('ألفان');
      } else if (t >= 3 && t <= 10) {
        parts.add('${_chunkToArabic(t)} آلاف');
      } else {
        parts.add('${_chunkToArabic(t)} ألفاً');
      }
      n %= 1000;
    }
    // Hundreds + remainder
    if (n > 0) {
      parts.add(_chunkToArabic(n));
    }

    return parts.join(' و');
  }

  static String _chunkToArabic(int n) {
    if (n == 0) return '';
    if (n < 20) return _onesAr[n];

    final parts = <String>[];

    if (n >= 100) {
      parts.add(_hundredsAr[n ~/ 100]);
      n %= 100;
    }
    if (n > 0) {
      if (n < 20) {
        parts.add(_onesAr[n]);
      } else {
        final ones = n % 10;
        final tens = n ~/ 10;
        if (ones > 0) {
          parts.add('${_onesAr[ones]} و${_tensAr[tens]}');
        } else {
          parts.add(_tensAr[tens]);
        }
      }
    }

    return parts.join(' و');
  }

  /// Converts amount to Arabic words with currency.
  static String toArabic(double amount, {String currency = 'SAR'}) {
    final info = currencies[currency];
    final currencyName = info?.nameAr ?? currency;
    final subunitName = info?.subunitAr ?? 'فلس';
    final decPlaces = info?.decimalPlaces ?? 2;

    final whole = amount.truncate();
    final fraction = ((amount - whole) * _pow10(decPlaces)).round();

    var result = '${_intToArabic(whole)} $currencyName';
    if (fraction > 0) {
      result += ' و${_intToArabic(fraction)} $subunitName';
    }
    return '$result فقط لا غير';
  }

  static int _pow10(int exp) {
    var result = 1;
    for (var i = 0; i < exp; i++) {
      result *= 10;
    }
    return result;
  }
}
