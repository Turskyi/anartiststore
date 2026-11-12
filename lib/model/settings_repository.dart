import 'package:material_ui/material_ui.dart';

abstract interface class SettingsRepository {
  Future<ThemeMode> getThemeMode();
  Future<void> saveThemeMode(ThemeMode themeMode);
}
