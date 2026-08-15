import 'dart:io';
import 'dart:typed_data';

import 'package:anartiststore/data/app_options.dart';
import 'package:anartiststore/enums/group.dart';
import 'package:anartiststore/enums/language.dart';
import 'package:anartiststore/group/currency_selector_sheet.dart';
import 'package:anartiststore/group/language_selector_sheet.dart';
import 'package:anartiststore/group/theme_selector_sheet.dart';
import 'package:anartiststore/model/app_state_model.dart';
import 'package:anartiststore/res/values/constants.dart' as constants;
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class GroupMenuPage extends StatelessWidget {
  const GroupMenuPage({
    super.key,
    required this.currentCategory,
    required this.onCategoryTap,
  });

  final Group currentCategory;
  final ValueChanged<Group> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      // Note: This background color is currently tied to the Backdrop style.
      // In a full dark mode implementation, this would likely come from
      // theme.colorScheme.surfaceContainer or a custom theme extension.
      color: theme.appBarTheme.backgroundColor,
      child: ScopedModelDescendant<AppStateModel>(
        builder: (BuildContext context, Widget? child, AppStateModel model) {
          return ListView(
            padding:
                const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
            children: <Widget>[
              _MenuHeader(title: translate('catalog')),
              _CategoryTile(
                category: Group.all,
                currentCategory: currentCategory,
                onCategoryTap: onCategoryTap,
              ),
              _CategoryTile(
                category: Group.favourites,
                currentCategory: currentCategory,
                onCategoryTap: onCategoryTap,
              ),
              const Divider(height: 32),
              _MenuHeader(title: translate('preferences')),
              _MenuTile(
                title: translate('language'),
                subtitle: Language.fromIsoLanguageCode(
                  LocalizationProvider.of(context)
                      .state
                      .widget
                      .delegate
                      .currentLocale
                      .toString(),
                ).name,
                icon: Icons.language,
                onTap: () => _showLanguageSelector(context),
              ),
              _MenuTile(
                title: translate('currency'),
                subtitle: model.selectedCurrency.code,
                icon: Icons.attach_money,
                onTap: () => _showCurrencySelector(context),
              ),
              _MenuTile(
                title: translate('theme'),
                subtitle: _getThemeModeName(AppOptions.of(context).themeMode),
                icon: Icons.brightness_6,
                onTap: () => _showThemeSelector(context),
              ),
              const Divider(height: 32),
              _MenuHeader(title: translate('info')),
              _MenuTile(
                title: translate('about'),
                icon: Icons.info_outline,
                onTap: () => launchUrl(Uri.parse(constants.aboutUsUrl)),
              ),
              _MenuTile(
                title: translate('contact'),
                icon: Icons.contact_support_outlined,
                onTap: () => launchUrl(Uri.parse(constants.contactUsUrl)),
              ),
              _MenuTile(
                title: translate('report_problem'),
                icon: Icons.bug_report_outlined,
                onTap: () => _onReportPressed(context),
              ),
              const Divider(height: 32),
              _MenuHeader(title: translate('legal')),
              _MenuTile(
                title: translate('terms_of_use'),
                icon: Icons.gavel,
                onTap: () => launchUrl(Uri.parse(constants.termsOfUseUrl)),
              ),
              _MenuTile(
                title: translate('privacy_policy'),
                icon: Icons.privacy_tip_outlined,
                onTap: () => launchUrl(Uri.parse(constants.privacyPolicyUrl)),
              ),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }

  Future<void> _onReportPressed(BuildContext context) =>
      PackageInfo.fromPlatform().then(
        (PackageInfo packageInfo) {
          if (context.mounted) {
            BetterFeedback.of(context).show(
              (UserFeedback feedback) => _sendFeedback(
                feedback: feedback,
                packageInfo: packageInfo,
              ),
            );
          }
        },
      );

  Future<void> _sendFeedback({
    required UserFeedback feedback,
    required PackageInfo packageInfo,
  }) =>
      _writeImageToStorage(feedback.screenshot)
          .then((String screenshotFilePath) {
        return FlutterEmailSender.send(
          Email(
            body: '${feedback.text}\n\nApp id: ${packageInfo.packageName}\n'
                'App version: ${packageInfo.version}\n'
                'Build number: ${packageInfo.buildNumber}',
            subject: '${translate('app_feedback')}: '
                '${packageInfo.appName}',
            recipients: <String>[constants.techSupportEmail],
            attachmentPaths: <String>[screenshotFilePath],
          ),
        );
      });

  Future<String> _writeImageToStorage(Uint8List feedbackScreenshot) async {
    final Directory output = await getTemporaryDirectory();
    final String screenshotFilePath = '${output.path}/feedback.png';
    final File screenshotFile = File(screenshotFilePath);
    await screenshotFile.writeAsBytes(feedbackScreenshot);
    return screenshotFilePath;
  }

  void _showLanguageSelector(BuildContext context) {
    final bool isNarrow =
        MediaQuery.sizeOf(context).width <= constants.kMobileBreakpoint;

    if (isNarrow) {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (BuildContext context) => const LanguageSelectorSheet(),
      );
    } else {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) => const Dialog(
          child: SizedBox(
            width: constants.kDialogWidth,
            child: LanguageSelectorSheet(),
          ),
        ),
      );
    }
  }

  void _showCurrencySelector(BuildContext context) {
    final bool isNarrow =
        MediaQuery.sizeOf(context).width <= constants.kMobileBreakpoint;

    if (isNarrow) {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (BuildContext context) => const CurrencySelectorSheet(),
      );
    } else {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) => const Dialog(
          child: SizedBox(
            width: constants.kDialogWidth,
            child: CurrencySelectorSheet(),
          ),
        ),
      );
    }
  }

  void _showThemeSelector(BuildContext context) {
    final bool isNarrow =
        MediaQuery.sizeOf(context).width <= constants.kMobileBreakpoint;

    if (isNarrow) {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (BuildContext _) => const ThemeSelectorSheet(),
      );
    } else {
      showDialog<void>(
        context: context,
        builder: (BuildContext _) => const Dialog(
          child: SizedBox(
            width: constants.kDialogWidth,
            child: ThemeSelectorSheet(),
          ),
        ),
      );
    }
  }

  String _getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return translate('theme_system');
      case ThemeMode.light:
        return translate('theme_light');
      case ThemeMode.dark:
        return translate('theme_dark');
    }
  }
}

class _MenuHeader extends StatelessWidget {
  const _MenuHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.currentCategory,
    required this.onCategoryTap,
  });

  final Group category;
  final Group currentCategory;
  final ValueChanged<Group> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isSelected = category == currentCategory;
    String categoryString;
    IconData? icon;
    if (category == Group.all) {
      categoryString = translate('anArtistStoreCategoryNameAll');
      icon = Icons.grid_view;
    } else {
      categoryString = translate('favourites');
      icon = Icons.favorite_border;
    }

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface,
      ),
      title: Text(
        categoryString,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: isSelected
              ? theme.colorScheme.onSurface
              : theme.colorScheme.onSurface.withValues(alpha: 0.6),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? Container(
              width: 4.0,
              height: 24.0,
              color: theme.colorScheme.primary,
            )
          : null,
      onTap: () => onCategoryTap(category),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.title,
    this.subtitle = '',
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: theme.colorScheme.onSurface),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
      ),
      subtitle: subtitle.isNotEmpty
          ? Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            )
          : null,
      onTap: onTap,
    );
  }
}
