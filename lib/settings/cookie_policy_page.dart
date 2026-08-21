import 'package:anartiststore/settings/widgets/bullet_point.dart';
import 'package:anartiststore/settings/widgets/section_body.dart';
import 'package:anartiststore/settings/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class CookiePolicyPage extends StatelessWidget {
  const CookiePolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(translate('cookie_title'))),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: <Widget>[
          SectionHeader(title: translate('cookie_what_title')),
          SectionBody(text: translate('cookie_what_text')),
          const SizedBox(height: 24),
          SectionHeader(title: translate('cookie_usage_title')),
          SectionBody(text: translate('cookie_usage_text')),
          BulletPoint(text: translate('cookie_usage_bullet_1')),
          BulletPoint(text: translate('cookie_usage_bullet_2')),
          BulletPoint(text: translate('cookie_usage_bullet_3')),
          const SizedBox(height: 24),
          SectionHeader(title: translate('cookie_disabling_title')),
          SectionBody(text: translate('cookie_disabling_text')),
          const SizedBox(height: 24),
          SectionHeader(title: translate('cookie_more_info_title')),
          SectionBody(text: translate('cookie_more_info_text')),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
