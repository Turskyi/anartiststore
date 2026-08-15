import 'package:anartiststore/data/app_options.dart';
import 'package:anartiststore/data/repositories/shared_preferences_settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ThemeSelectorSheet extends StatelessWidget {
  const ThemeSelectorSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppOptions options = AppOptions.of(context);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              translate('theme'),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(height: 1),
          _ThemeTile(
            title: translate('theme_system'),
            icon: Icons.brightness_auto,
            mode: ThemeMode.system,
            currentMode: options.themeMode,
          ),
          _ThemeTile(
            title: translate('theme_light'),
            icon: Icons.light_mode,
            mode: ThemeMode.light,
            currentMode: options.themeMode,
          ),
          _ThemeTile(
            title: translate('theme_dark'),
            icon: Icons.dark_mode,
            mode: ThemeMode.dark,
            currentMode: options.themeMode,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile({
    required this.title,
    required this.icon,
    required this.mode,
    required this.currentMode,
  });

  final String title;
  final IconData icon;
  final ThemeMode mode;
  final ThemeMode currentMode;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isSelected = mode == currentMode;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check, color: theme.colorScheme.primary)
          : null,
      onTap: () async {
        final AppOptions options = AppOptions.of(context);
        AppOptions.update(context, options.copyWith(themeMode: mode));
        await SharedPreferencesSettingsRepository().saveThemeMode(mode);
        if (context.mounted) {
          Navigator.pop(context);
        }
      },
    );
  }
}
