import 'package:anartiststore/enums/language.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_translate/flutter_translate.dart';

Future<LocalizationDelegate> getLocalizationDelegate() async {
  // Get the singleton instance of the `PlatformDispatcher`.
  final PlatformDispatcher platformDispatcher = PlatformDispatcher.instance;

  // Get the current locale from the `PlatformDispatcher`.
  final Locale deviceLocale = platformDispatcher.locale;

  // Get the language code from the `Locale`.
  final String deviceIsoLanguageCode = deviceLocale.languageCode;

  final LocalizationDelegate localizationDelegate =
      await LocalizationDelegate.create(
    fallbackLocale: Language.fromIsoLanguageCode(
      deviceIsoLanguageCode,
    ).isoLanguageCode,
    supportedLocales: Language.values
        .map((Language language) => language.isoLanguageCode)
        .toList(),
  );
  return localizationDelegate;
}
