import 'package:flutter/material.dart';

/// Controls the example application's UI language.
///
/// PDF example LTR/RTL controls remain independent from the application locale.
final class LocaleController extends ValueNotifier<Locale> {
  LocaleController({Locale initialLocale = const Locale('en')})
      : super(initialLocale);

  bool get isArabic => value.languageCode == 'ar';
  bool get isEnglish => value.languageCode == 'en';

  void toggleLanguage() {
    value = isArabic ? const Locale('en') : const Locale('ar');
  }

  void setArabic() => value = const Locale('ar');
  void setEnglish() => value = const Locale('en');
}

final localeController = LocaleController();
