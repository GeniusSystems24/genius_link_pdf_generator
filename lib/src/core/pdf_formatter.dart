import 'package:intl/intl.dart';

/// Shared value kinds supported by the S05 formatting engine.
enum GeniusPdfFormatKind {
  money,
  number,
  quantity,
  percentage,
  date,
  time,
  dateTime,
  identifier,
  exchangeRate,
  unit,
}

/// Digit-shape policy for display values.
enum GeniusPdfDigitPolicy { latin, arabicIndic, locale }

/// Currency label policy.
enum GeniusPdfCurrencyDisplay { code, symbol, codeAndSymbol, none }

/// Currency placement relative to the numeric value.
enum GeniusPdfCurrencyPosition { locale, before, after }

/// Negative-number presentation.
enum GeniusPdfNegativeFormat { minus, accounting }

/// Shared policy for null values.
class GeniusPdfNullPlaceholderPolicy {
  const GeniusPdfNullPlaceholderPolicy._(this.placeholder);
  const GeniusPdfNullPlaceholderPolicy.empty() : placeholder = '';
  const GeniusPdfNullPlaceholderPolicy.dash() : placeholder = '-';
  const GeniusPdfNullPlaceholderPolicy.emDash() : placeholder = '—';
  const GeniusPdfNullPlaceholderPolicy.custom(String value)
      : placeholder = value;

  final String placeholder;
}

/// Default settings for [GeniusPdfFormatter].
class GeniusPdfFormatSettings {
  const GeniusPdfFormatSettings({
    this.locale = 'en_US',
    this.digitPolicy = GeniusPdfDigitPolicy.latin,
    this.nullPolicy = const GeniusPdfNullPlaceholderPolicy.empty(),
    this.numberDecimalPlaces = 2,
    this.moneyDecimalPlaces = 2,
    this.quantityDecimalPlaces = 2,
    this.percentageDecimalPlaces = 2,
    this.exchangeRateDecimalPlaces = 4,
    this.currencyDisplay = GeniusPdfCurrencyDisplay.code,
    this.currencyPosition = GeniusPdfCurrencyPosition.after,
    this.negativeFormat = GeniusPdfNegativeFormat.minus,
    this.datePattern = 'yyyy-MM-dd',
    this.timePattern = 'HH:mm',
    this.dateTimePattern = 'yyyy-MM-dd HH:mm',
    this.useGrouping = true,
  })  : assert(numberDecimalPlaces >= 0),
        assert(moneyDecimalPlaces >= 0),
        assert(quantityDecimalPlaces >= 0),
        assert(percentageDecimalPlaces >= 0),
        assert(exchangeRateDecimalPlaces >= 0);

  final String locale;
  final GeniusPdfDigitPolicy digitPolicy;
  final GeniusPdfNullPlaceholderPolicy nullPolicy;
  final int numberDecimalPlaces;
  final int moneyDecimalPlaces;
  final int quantityDecimalPlaces;
  final int percentageDecimalPlaces;
  final int exchangeRateDecimalPlaces;
  final GeniusPdfCurrencyDisplay currencyDisplay;
  final GeniusPdfCurrencyPosition currencyPosition;
  final GeniusPdfNegativeFormat negativeFormat;
  final String datePattern;
  final String timePattern;
  final String dateTimePattern;
  final bool useGrouping;

  GeniusPdfFormatSettings copyWith({
    String? locale,
    GeniusPdfDigitPolicy? digitPolicy,
    GeniusPdfNullPlaceholderPolicy? nullPolicy,
    int? numberDecimalPlaces,
    int? moneyDecimalPlaces,
    int? quantityDecimalPlaces,
    int? percentageDecimalPlaces,
    int? exchangeRateDecimalPlaces,
    GeniusPdfCurrencyDisplay? currencyDisplay,
    GeniusPdfCurrencyPosition? currencyPosition,
    GeniusPdfNegativeFormat? negativeFormat,
    String? datePattern,
    String? timePattern,
    String? dateTimePattern,
    bool? useGrouping,
  }) => GeniusPdfFormatSettings(
        locale: locale ?? this.locale,
        digitPolicy: digitPolicy ?? this.digitPolicy,
        nullPolicy: nullPolicy ?? this.nullPolicy,
        numberDecimalPlaces: numberDecimalPlaces ?? this.numberDecimalPlaces,
        moneyDecimalPlaces: moneyDecimalPlaces ?? this.moneyDecimalPlaces,
        quantityDecimalPlaces: quantityDecimalPlaces ?? this.quantityDecimalPlaces,
        percentageDecimalPlaces: percentageDecimalPlaces ?? this.percentageDecimalPlaces,
        exchangeRateDecimalPlaces: exchangeRateDecimalPlaces ?? this.exchangeRateDecimalPlaces,
        currencyDisplay: currencyDisplay ?? this.currencyDisplay,
        currencyPosition: currencyPosition ?? this.currencyPosition,
        negativeFormat: negativeFormat ?? this.negativeFormat,
        datePattern: datePattern ?? this.datePattern,
        timePattern: timePattern ?? this.timePattern,
        dateTimePattern: dateTimePattern ?? this.dateTimePattern,
        useGrouping: useGrouping ?? this.useGrouping,
      );
}

/// Component-safe description of how a raw value must be formatted.
class GeniusPdfFormatSpec {
  const GeniusPdfFormatSpec({
    required this.kind,
    this.decimalPlaces,
    this.currencyCode,
    this.currencyDisplay,
    this.currencyPosition,
    this.negativeFormat,
    this.percentageIsFraction = false,
    this.pattern,
    this.unit,
    this.unitAr,
    this.exchangeFrom,
    this.exchangeTo,
    this.useGrouping,
  });

  const GeniusPdfFormatSpec.money({
    this.currencyCode,
    this.decimalPlaces,
    this.currencyDisplay,
    this.currencyPosition,
    this.negativeFormat,
    this.useGrouping,
  })  : kind = GeniusPdfFormatKind.money,
        percentageIsFraction = false,
        pattern = null,
        unit = null,
        unitAr = null,
        exchangeFrom = null,
        exchangeTo = null;

  const GeniusPdfFormatSpec.number({
    this.decimalPlaces,
    this.negativeFormat,
    this.useGrouping,
  })  : kind = GeniusPdfFormatKind.number,
        currencyCode = null,
        currencyDisplay = null,
        currencyPosition = null,
        percentageIsFraction = false,
        pattern = null,
        unit = null,
        unitAr = null,
        exchangeFrom = null,
        exchangeTo = null;

  const GeniusPdfFormatSpec.quantity({
    this.decimalPlaces,
    this.unit,
    this.unitAr,
    this.useGrouping,
  })  : kind = GeniusPdfFormatKind.quantity,
        currencyCode = null,
        currencyDisplay = null,
        currencyPosition = null,
        negativeFormat = null,
        percentageIsFraction = false,
        pattern = null,
        exchangeFrom = null,
        exchangeTo = null;

  const GeniusPdfFormatSpec.percentage({
    this.decimalPlaces,
    this.percentageIsFraction = false,
  })  : kind = GeniusPdfFormatKind.percentage,
        currencyCode = null,
        currencyDisplay = null,
        currencyPosition = null,
        negativeFormat = null,
        pattern = null,
        unit = null,
        unitAr = null,
        exchangeFrom = null,
        exchangeTo = null,
        useGrouping = false;

  const GeniusPdfFormatSpec.date({this.pattern})
      : kind = GeniusPdfFormatKind.date,
        decimalPlaces = null,
        currencyCode = null,
        currencyDisplay = null,
        currencyPosition = null,
        negativeFormat = null,
        percentageIsFraction = false,
        unit = null,
        unitAr = null,
        exchangeFrom = null,
        exchangeTo = null,
        useGrouping = false;

  const GeniusPdfFormatSpec.time({this.pattern})
      : kind = GeniusPdfFormatKind.time,
        decimalPlaces = null,
        currencyCode = null,
        currencyDisplay = null,
        currencyPosition = null,
        negativeFormat = null,
        percentageIsFraction = false,
        unit = null,
        unitAr = null,
        exchangeFrom = null,
        exchangeTo = null,
        useGrouping = false;

  const GeniusPdfFormatSpec.dateTime({this.pattern})
      : kind = GeniusPdfFormatKind.dateTime,
        decimalPlaces = null,
        currencyCode = null,
        currencyDisplay = null,
        currencyPosition = null,
        negativeFormat = null,
        percentageIsFraction = false,
        unit = null,
        unitAr = null,
        exchangeFrom = null,
        exchangeTo = null,
        useGrouping = false;

  const GeniusPdfFormatSpec.identifier()
      : kind = GeniusPdfFormatKind.identifier,
        decimalPlaces = null,
        currencyCode = null,
        currencyDisplay = null,
        currencyPosition = null,
        negativeFormat = null,
        percentageIsFraction = false,
        pattern = null,
        unit = null,
        unitAr = null,
        exchangeFrom = null,
        exchangeTo = null,
        useGrouping = false;

  const GeniusPdfFormatSpec.exchangeRate({
    required this.exchangeFrom,
    required this.exchangeTo,
    this.decimalPlaces,
  })  : kind = GeniusPdfFormatKind.exchangeRate,
        currencyCode = null,
        currencyDisplay = null,
        currencyPosition = null,
        negativeFormat = null,
        percentageIsFraction = false,
        pattern = null,
        unit = null,
        unitAr = null,
        useGrouping = false;

  const GeniusPdfFormatSpec.unit({
    required this.unit,
    this.unitAr,
    this.decimalPlaces,
    this.useGrouping,
  })  : kind = GeniusPdfFormatKind.unit,
        currencyCode = null,
        currencyDisplay = null,
        currencyPosition = null,
        negativeFormat = null,
        percentageIsFraction = false,
        pattern = null,
        exchangeFrom = null,
        exchangeTo = null;

  final GeniusPdfFormatKind kind;
  final int? decimalPlaces;
  final String? currencyCode;
  final GeniusPdfCurrencyDisplay? currencyDisplay;
  final GeniusPdfCurrencyPosition? currencyPosition;
  final GeniusPdfNegativeFormat? negativeFormat;
  final bool percentageIsFraction;
  final String? pattern;
  final String? unit;
  final String? unitAr;
  final String? exchangeFrom;
  final String? exchangeTo;
  final bool? useGrouping;
}

/// Stable S05 value-formatting contract.
abstract class GeniusPdfFormatter {
  const GeniusPdfFormatter();
  GeniusPdfFormatSettings get settings;

  String format(Object? value, GeniusPdfFormatSpec spec, {bool isRtl = false});
  String formatMoney(Object? value, {String? currencyCode, int? decimalPlaces, GeniusPdfCurrencyDisplay? currencyDisplay, GeniusPdfCurrencyPosition? currencyPosition, GeniusPdfNegativeFormat? negativeFormat, bool? useGrouping});
  String formatNumber(Object? value, {int? decimalPlaces, GeniusPdfNegativeFormat? negativeFormat, bool? useGrouping});
  String formatQuantity(Object? value, {int? decimalPlaces, String? unit, String? unitAr, bool isRtl = false, bool? useGrouping});
  String formatPercentage(Object? value, {int? decimalPlaces, bool isFraction = false});
  String formatDate(Object? value, {String? pattern});
  String formatTime(Object? value, {String? pattern});
  String formatDateTime(Object? value, {String? pattern});
  String formatIdentifier(Object? value);
  String formatExchangeRate(Object? value, {required String from, required String to, int? decimalPlaces});
  String formatUnit(Object? value, {required String unit, String? unitAr, int? decimalPlaces, bool isRtl = false, bool? useGrouping});
}

/// Default locale-aware implementation based on `intl`.
class GeniusPdfDefaultFormatter extends GeniusPdfFormatter {
  const GeniusPdfDefaultFormatter({
    this.settings = const GeniusPdfFormatSettings(),
  });

  @override
  final GeniusPdfFormatSettings settings;

  @override
  String format(Object? value, GeniusPdfFormatSpec spec, {bool isRtl = false}) {
    switch (spec.kind) {
      case GeniusPdfFormatKind.money:
        return formatMoney(value, currencyCode: spec.currencyCode, decimalPlaces: spec.decimalPlaces, currencyDisplay: spec.currencyDisplay, currencyPosition: spec.currencyPosition, negativeFormat: spec.negativeFormat, useGrouping: spec.useGrouping);
      case GeniusPdfFormatKind.number:
        return formatNumber(value, decimalPlaces: spec.decimalPlaces, negativeFormat: spec.negativeFormat, useGrouping: spec.useGrouping);
      case GeniusPdfFormatKind.quantity:
        return formatQuantity(value, decimalPlaces: spec.decimalPlaces, unit: spec.unit, unitAr: spec.unitAr, isRtl: isRtl, useGrouping: spec.useGrouping);
      case GeniusPdfFormatKind.percentage:
        return formatPercentage(value, decimalPlaces: spec.decimalPlaces, isFraction: spec.percentageIsFraction);
      case GeniusPdfFormatKind.date:
        return formatDate(value, pattern: spec.pattern);
      case GeniusPdfFormatKind.time:
        return formatTime(value, pattern: spec.pattern);
      case GeniusPdfFormatKind.dateTime:
        return formatDateTime(value, pattern: spec.pattern);
      case GeniusPdfFormatKind.identifier:
        return formatIdentifier(value);
      case GeniusPdfFormatKind.exchangeRate:
        return formatExchangeRate(value, from: spec.exchangeFrom ?? '', to: spec.exchangeTo ?? '', decimalPlaces: spec.decimalPlaces);
      case GeniusPdfFormatKind.unit:
        return formatUnit(value, unit: spec.unit ?? '', unitAr: spec.unitAr, decimalPlaces: spec.decimalPlaces, isRtl: isRtl, useGrouping: spec.useGrouping);
    }
  }

  @override
  String formatMoney(Object? value, {String? currencyCode, int? decimalPlaces, GeniusPdfCurrencyDisplay? currencyDisplay, GeniusPdfCurrencyPosition? currencyPosition, GeniusPdfNegativeFormat? negativeFormat, bool? useGrouping}) {
    final number = _asNum(value);
    if (number == null) return value == null ? _nullText() : value.toString();
    final negative = number < 0;
    final numeric = _number(number.abs(), decimals: decimalPlaces ?? settings.moneyDecimalPlaces, grouping: useGrouping ?? settings.useGrouping);
    final code = currencyCode?.trim() ?? '';
    final display = currencyDisplay ?? settings.currencyDisplay;
    final position = currencyPosition ?? settings.currencyPosition;
    var result = _combineCurrency(numeric, _currencyLabel(code, display), position, code);
    result = _applyNegative(result, negative, negativeFormat ?? settings.negativeFormat);
    return _digits(result);
  }

  @override
  String formatNumber(Object? value, {int? decimalPlaces, GeniusPdfNegativeFormat? negativeFormat, bool? useGrouping}) {
    final number = _asNum(value);
    if (number == null) return value == null ? _nullText() : value.toString();
    var result = _number(number.abs(), decimals: decimalPlaces ?? settings.numberDecimalPlaces, grouping: useGrouping ?? settings.useGrouping);
    result = _applyNegative(result, number < 0, negativeFormat ?? settings.negativeFormat);
    return _digits(result);
  }

  @override
  String formatQuantity(Object? value, {int? decimalPlaces, String? unit, String? unitAr, bool isRtl = false, bool? useGrouping}) {
    if (value == null) return _nullText();
    final number = formatNumber(value, decimalPlaces: decimalPlaces ?? settings.quantityDecimalPlaces, useGrouping: useGrouping);
    final resolvedUnit = isRtl && unitAr != null ? unitAr : unit;
    return resolvedUnit == null || resolvedUnit.isEmpty ? number : '$number $resolvedUnit';
  }

  @override
  String formatPercentage(Object? value, {int? decimalPlaces, bool isFraction = false}) {
    final number = _asNum(value);
    if (number == null) return value == null ? _nullText() : value.toString();
    final effective = isFraction ? number * 100 : number;
    return _digits('${_number(effective, decimals: decimalPlaces ?? settings.percentageDecimalPlaces, grouping: false)}%');
  }

  @override
  String formatDate(Object? value, {String? pattern}) => _date(value, pattern ?? settings.datePattern);

  @override
  String formatTime(Object? value, {String? pattern}) => _date(value, pattern ?? settings.timePattern);

  @override
  String formatDateTime(Object? value, {String? pattern}) => _date(value, pattern ?? settings.dateTimePattern);

  @override
  String formatIdentifier(Object? value) {
    // Identifiers are data, not localized numbers. Never reorder or reshape.
    return value == null ? _nullText() : value.toString();
  }

  @override
  String formatExchangeRate(Object? value, {required String from, required String to, int? decimalPlaces}) {
    if (value == null) return _nullText();
    final formatted = formatNumber(value, decimalPlaces: decimalPlaces ?? settings.exchangeRateDecimalPlaces, useGrouping: false);
    if (from.isEmpty && to.isEmpty) return formatted;
    if (from.isEmpty) return '$formatted $to';
    if (to.isEmpty) return '1 $from = $formatted';
    return '1 $from = $formatted $to';
  }

  @override
  String formatUnit(Object? value, {required String unit, String? unitAr, int? decimalPlaces, bool isRtl = false, bool? useGrouping}) => formatQuantity(value, decimalPlaces: decimalPlaces, unit: unit, unitAr: unitAr, isRtl: isRtl, useGrouping: useGrouping);

  String _date(Object? value, String pattern) {
    final date = _asDate(value);
    if (date == null) return value == null ? _nullText() : value.toString();
    return _digits(DateFormat(pattern, settings.locale).format(date));
  }

  String _nullText() => settings.nullPolicy.placeholder;

  String _number(num value, {required int decimals, required bool grouping}) {
    final formatter = NumberFormat.decimalPattern(settings.locale)
      ..minimumFractionDigits = decimals
      ..maximumFractionDigits = decimals;
    if (!grouping) formatter.turnOffGrouping();
    return formatter.format(value);
  }

  String _currencyLabel(String code, GeniusPdfCurrencyDisplay display) {
    if (display == GeniusPdfCurrencyDisplay.none || code.isEmpty) return '';
    String symbol;
    try {
      symbol = NumberFormat.simpleCurrency(locale: settings.locale, name: code).currencySymbol;
    } catch (_) {
      symbol = code;
    }
    switch (display) {
      case GeniusPdfCurrencyDisplay.code:
        return code;
      case GeniusPdfCurrencyDisplay.symbol:
        return symbol;
      case GeniusPdfCurrencyDisplay.codeAndSymbol:
        return symbol == code ? code : '$code $symbol';
      case GeniusPdfCurrencyDisplay.none:
        return '';
    }
  }

  String _combineCurrency(String number, String label, GeniusPdfCurrencyPosition position, String code) {
    if (label.isEmpty) return number;
    switch (position) {
      case GeniusPdfCurrencyPosition.before:
        return '$label $number';
      case GeniusPdfCurrencyPosition.after:
        return '$number $label';
      case GeniusPdfCurrencyPosition.locale:
        try {
          final format = code.isEmpty
              ? NumberFormat.simpleCurrency(locale: settings.locale)
              : NumberFormat.simpleCurrency(locale: settings.locale, name: code);
          final sample = format.format(1);
          final symbol = format.currencySymbol;
          final symbolIndex = sample.indexOf(symbol);
          final digitMatch = RegExp(r'[0-9٠-٩]').firstMatch(sample);
          if (symbolIndex >= 0 && digitMatch != null && symbolIndex < digitMatch.start) {
            return '$label $number';
          }
        } catch (_) {}
        return '$number $label';
    }
  }

  String _applyNegative(String value, bool negative, GeniusPdfNegativeFormat format) {
    if (!negative) return value;
    return format == GeniusPdfNegativeFormat.accounting ? '($value)' : '-$value';
  }

  String _digits(String value) {
    final policy = settings.digitPolicy == GeniusPdfDigitPolicy.locale
        ? (settings.locale.toLowerCase().startsWith('ar') ? GeniusPdfDigitPolicy.arabicIndic : GeniusPdfDigitPolicy.latin)
        : settings.digitPolicy;
    const latin = '0123456789';
    const arabic = '٠١٢٣٤٥٦٧٨٩';
    const eastern = '۰۱۲۳۴۵۶۷۸۹';
    var result = value;
    if (policy == GeniusPdfDigitPolicy.arabicIndic) {
      for (var i = 0; i < latin.length; i++) {
        result = result.replaceAll(latin[i], arabic[i]).replaceAll(eastern[i], arabic[i]);
      }
      return result;
    }
    for (var i = 0; i < latin.length; i++) {
      result = result.replaceAll(arabic[i], latin[i]).replaceAll(eastern[i], latin[i]);
    }
    return result;
  }

  num? _asNum(Object? value) {
    if (value is num) return value;
    if (value is String) {
      return num.tryParse(value.trim().replaceAll(',', '').replaceAll('٬', '').replaceAll('٫', '.'));
    }
    return null;
  }

  DateTime? _asDate(Object? value) {
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
