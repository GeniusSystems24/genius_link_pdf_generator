import 'package:flutter/widgets.dart';

enum ShowcaseTextDirectionMode { automatic, ltr, rtl }

extension ShowcaseTextDirectionModeX on ShowcaseTextDirectionMode {
  TextDirection resolve(Locale locale) => switch (this) {
        ShowcaseTextDirectionMode.automatic =>
          locale.languageCode.toLowerCase() == 'ar'
              ? TextDirection.rtl
              : TextDirection.ltr,
        ShowcaseTextDirectionMode.ltr => TextDirection.ltr,
        ShowcaseTextDirectionMode.rtl => TextDirection.rtl,
      };
}

class ShowcaseSettings extends InheritedWidget {
  const ShowcaseSettings({
    super.key,
    required this.locale,
    required this.textDirectionMode,
    required super.child,
  });

  final Locale locale;
  final ShowcaseTextDirectionMode textDirectionMode;

  TextDirection get textDirection => textDirectionMode.resolve(locale);

  static ShowcaseSettings of(BuildContext context) {
    final value = context.dependOnInheritedWidgetOfExactType<ShowcaseSettings>();
    assert(value != null, 'ShowcaseSettings is missing above this context.');
    return value!;
  }

  @override
  bool updateShouldNotify(ShowcaseSettings oldWidget) =>
      locale != oldWidget.locale || textDirectionMode != oldWidget.textDirectionMode;
}
