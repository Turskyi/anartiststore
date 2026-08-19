import 'package:anartiststore/settings/widgets/bullet_point.dart';
import 'package:anartiststore/settings/widgets/section_body.dart';
import 'package:anartiststore/settings/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class TermsOfUsePage extends StatelessWidget {
  const TermsOfUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(translate('terms_of_use')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          SectionHeader(title: translate('terms_intro_title')),
          SectionBody(text: translate('terms_intro_text')),
          const SizedBox(height: 24),
          SectionHeader(title: translate('terms_ownership_title')),
          SectionBody(text: translate('terms_ownership_text')),
          const SizedBox(height: 24),
          SectionHeader(title: translate('terms_use_title')),
          SectionBody(text: translate('terms_use_text_1')),
          SectionBody(text: translate('terms_use_text_2')),
          SectionBody(text: translate('terms_use_text_3')),
          SectionBody(text: translate('terms_use_text_4')),
          SectionBody(text: translate('terms_use_text_5')),
          SectionBody(text: translate('terms_use_text_6')),
          SectionBody(text: translate('terms_use_text_7')),
          SectionBody(text: translate('terms_use_text_8')),
          const SizedBox(height: 24),
          SectionHeader(title: translate('terms_communications_title')),
          SectionBody(text: translate('terms_communications_text_1')),
          SectionBody(text: translate('terms_communications_text_2')),
          SectionBody(text: translate('terms_communications_text_3')),
          SectionBody(text: translate('terms_communications_text_4')),
          SectionBody(text: translate('terms_communications_text_5')),
          const SizedBox(height: 24),
          SectionHeader(title: translate('terms_rules_title')),
          SectionBody(text: translate('terms_rules_text_1')),
          SectionBody(text: translate('terms_rules_text_2')),
          SectionBody(text: translate('terms_rules_text_3')),
          BulletPoint(text: translate('terms_rules_bullet_1')),
          BulletPoint(text: translate('terms_rules_bullet_2')),
          BulletPoint(text: translate('terms_rules_bullet_3')),
          BulletPoint(text: translate('terms_rules_bullet_4')),
          BulletPoint(text: translate('terms_rules_bullet_5')),
          BulletPoint(text: translate('terms_rules_bullet_6')),
          BulletPoint(text: translate('terms_rules_bullet_7')),
          BulletPoint(text: translate('terms_rules_bullet_8')),
          BulletPoint(text: translate('terms_rules_bullet_9')),
          SectionBody(text: translate('terms_rules_text_4')),
          const SizedBox(height: 24),
          SectionHeader(title: translate('terms_assistance_title')),
          SectionBody(text: translate('terms_assistance_text_1')),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              translate('terms_assistance_address'),
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SectionBody(text: translate('terms_assistance_text_2')),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
