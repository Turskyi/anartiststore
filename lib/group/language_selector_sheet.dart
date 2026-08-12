import 'package:anartiststore/enums/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class LanguageSelectorSheet extends StatelessWidget {
  const LanguageSelectorSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String currentIsoCode = LocalizationProvider.of(context)
        .state
        .widget
        .delegate
        .currentLocale
        .toString();
    final Language currentLanguage =
        Language.fromIsoLanguageCode(currentIsoCode);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              translate('language'),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(height: 1),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: Language.values.length,
              itemBuilder: (BuildContext context, int index) {
                final Language language = Language.values[index];
                final bool isSelected = language == currentLanguage;

                return ListTile(
                  leading: Text(
                    language.flag,
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(
                    language.name,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check, color: theme.colorScheme.primary)
                      : null,
                  onTap: () {
                    changeLocale(context, language.isoLanguageCode);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
