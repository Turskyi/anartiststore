import 'package:anartiststore/enums/language.dart';
import 'package:flutter_translate/flutter_translate.dart';

Future<LocalizationDelegate> getLocalizationDelegate() async {
  final LocalizationDelegate localizationDelegate =
      await LocalizationDelegate.create(
    fallbackLocale: Language.en.isoLanguageCode,
    supportedLocales: Language.values
        .map((Language language) => language.isoLanguageCode)
        .toList(),
  );
  return localizationDelegate;
}
