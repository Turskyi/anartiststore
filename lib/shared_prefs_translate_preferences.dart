import 'dart:ui';

import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsTranslatePreferences implements ITranslatePreferences {
  static const String _kSelectedLocaleKey = 'selected_locale';

  @override
  Future<Locale?> getPreferredLocale() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? localeCode = prefs.getString(_kSelectedLocaleKey);
    if (localeCode == null) return null;

    final List<String> parts = localeCode.split('_');
    if (parts.length == 1) {
      return Locale(parts[0]);
    } else {
      return Locale(parts[0], parts[1]);
    }
  }

  @override
  Future<void> savePreferredLocale(Locale locale) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSelectedLocaleKey, locale.toString());
  }
}
