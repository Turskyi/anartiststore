import 'package:anartiststore/res/values/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(translate('about_us_title'))),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: <Widget>[
          _Section(
            title: translate('about_us_story_title'),
            text: translate('about_us_story_text'),
          ),
          const SizedBox(height: 32),
          _Section(
            title: translate('about_us_art_title'),
            text: translate('about_us_art_text'),
          ),
          const SizedBox(height: 32),
          _Section(
            title: translate('about_us_mission_title'),
            text: translate('about_us_mission_text'),
          ),
          const SizedBox(height: 32),
          Text(
            translate('about_us_instagram_prompt'),
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => launchUrl(Uri.parse(constants.instagramUrl)),
            child: Text(
              translate('about_us_instagram_handle'),
              style: textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(text, style: textTheme.bodyLarge),
      ],
    );
  }
}
