import 'package:flutter/material.dart';

abstract interface class SettingsRepository {
  Future<ThemeMode> getThemeMode();
  Future<void> saveThemeMode(ThemeMode themeMode);
}
