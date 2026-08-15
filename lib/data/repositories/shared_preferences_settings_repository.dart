import 'package:anartiststore/model/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesSettingsRepository implements SettingsRepository {
  static const String _kThemeModeKey = 'theme_mode';

  @override
  Future<ThemeMode> getThemeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? themeName = prefs.getString(_kThemeModeKey);
    if (themeName == null) {
      return ThemeMode.system;
    }
    return ThemeMode.values.firstWhere(
      (ThemeMode e) => e.name == themeName,
      orElse: () => ThemeMode.system,
    );
  }

  @override
  Future<void> saveThemeMode(ThemeMode themeMode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemeModeKey, themeMode.name);
  }
}
